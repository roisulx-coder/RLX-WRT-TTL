#!/bin/sh

# =========================================================
# RLX-WRT Fix TTL Installer - Full Edition
# =========================================================

# Jalur file utama
TTL_FILE="/etc/nftables.d/ttl65.nft"
RLXWRT_LUA="/usr/lib/lua/luci/controller/rlxwrt.lua"
PAGE_HTM="/usr/lib/lua/luci/view/rlxwrt/page.htm"

echo "Memulai proses instalasi RLX-WRT..."

# 1. Bersihkan sisa instalasi lama (agar tidak bentrok)
rm -rf /usr/lib/lua/luci/controller/rlxwrt* 2>/dev/null
rm -rf /usr/lib/lua/luci/view/rlxwrt/ 2>/dev/null
rm -rf /usr/lib/lua/luci/controller/indowrt* 2>/dev/null
rm -rf /usr/lib/lua/luci/view/indowrt/ 2>/dev/null

# 2. Buat direktori yang diperlukan secara paksa
mkdir -p /etc/nftables.d
mkdir -p /usr/lib/lua/luci/controller
mkdir -p /usr/lib/lua/luci/view/rlxwrt

# 3. Membuat file rlxwrt.lua (Controller)
# Menggunakan 'EOL' untuk mencegah variabel Lua diproses oleh shell Linux
cat <<'EOL' > "$RLXWRT_LUA"
module("luci.controller.rlxwrt", package.seeall)

function index()
    -- Menu akan muncul di Network -> Fix TTL 65
    entry({"admin", "network", "rlxwrt"}, call("render_page"), _("Fix TTL 65"), 100).leaf = true
end

function get_status()
    local f = io.open("/etc/nftables.d/ttl65.nft", "r")
    if f then
        f:close()
        return true
    end
    return false
end

function render_page()
    local http = require "luci.http"
    local sys = require "luci.sys"
    local action = http.formvalue("action")

    if action == "enable" then
        local ttl_rule = [[
## Fix TTL RLXWRT
chain rlxwrt_post {
    type filter hook postrouting priority 300; policy accept;
    counter ip ttl set 65
}
chain rlxwrt_pre {
    type filter hook prerouting priority 300; policy accept;
    counter ip ttl set 65
}
]]
        local f = io.open("/etc/nftables.d/ttl65.nft", "w")
        if f then 
            f:write(ttl_rule) 
            f:close() 
        end
        sys.call("/etc/init.d/firewall restart")
    elseif action == "disable" then
        sys.call("rm -f /etc/nftables.d/ttl65.nft")
        sys.call("/etc/init.d/firewall restart")
    end

    luci.template.render("rlxwrt/page", {
        is_active = get_status()
    })
end
EOL

# 4. Membuat file page.htm (Tampilan Web)
cat <<'EOL' > "$PAGE_HTM"
<%+header%>

<style>
    .rlx-container { max-width: 600px; margin: 20px auto; font-family: -apple-system, system-ui, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif; }
    .rlx-card { background: #fff; border-radius: 12px; box-shadow: 0 4px 15px rgba(0,0,0,0.08); padding: 30px; border: 1px solid #eee; text-align: center; }
    .status-badge { display: inline-block; padding: 8px 20px; border-radius: 50px; font-weight: bold; margin-bottom: 25px; font-size: 13px; letter-spacing: 0.5px; }
    .status-on { background: #dcfce7; color: #166534; border: 1px solid #bbf7d0; }
    .status-off { background: #fee2e2; color: #991b1b; border: 1px solid #fecaca; }
    .rlx-title { font-size: 26px; color: #1a202c; margin-bottom: 12px; font-weight: 800; }
    .rlx-desc { color: #4a5568; margin-bottom: 30px; line-height: 1.6; font-size: 14px; }
    .btn-wrap { display: flex; gap: 15px; justify-content: center; }
    .btn-rlx { border: none; padding: 12px 28px; border-radius: 8px; font-weight: 700; cursor: pointer; transition: all 0.2s; font-size: 14px; min-width: 150px; }
    .btn-enable { background: #2563eb; color: white; box-shadow: 0 4px 10px rgba(37, 99, 235, 0.2); }
    .btn-enable:hover { background: #1d4ed8; transform: translateY(-1px); }
    .btn-disable { background: #f1f5f9; color: #475569; border: 1px solid #e2e8f0; }
    .btn-disable:hover { background: #e2e8f0; color: #1e293b; }
    .footer-note { margin-top: 30px; font-size: 10px; color: #94a3b8; text-transform: uppercase; letter-spacing: 2px; font-weight: 600; }
</style>

<div class="rlx-container">
    <div class="rlx-card">
        <div class="rlx-title">RLX-WRT Engine</div>
        <p class="rlx-desc">Optimasi jaringan dengan Fix TTL 65 untuk menyamarkan trafik perangkat Anda dari deteksi hotspot operator.</p>
        
        <% if is_active then %>
            <div class="status-badge status-on">● SERVICE ACTIVE (TTL 65)</div>
        <% else %>
            <div class="status-badge status-off">● SERVICE INACTIVE</div>
        <% end %>

        <div class="btn-wrap">
            <form method="post" action="<%=request_uri%>" style="display:inline;">
                <input type="hidden" name="action" value="enable" />
                <button type="submit" class="btn-rlx btn-enable">ENABLE NOW</button>
            </form>

            <form method="post" action="<%=request_uri%>" style="display:inline;">
                <input type="hidden" name="action" value="disable" />
                <button type="submit" class="btn-rlx btn-disable">DISABLE</button>
            </form>
        </div>
        
        <div class="footer-note">Powered by roisulx-coder</div>
    </div>
</div>

<%+footer%>
EOL

# 5. Atur Izin File agar bisa dibaca LuCI
chmod 644 "$RLXWRT_LUA"
chmod 644 "$PAGE_HTM"

# 6. Paksa hapus cache index LuCI (Sangat Penting agar controller muncul)
rm -rf /tmp/luci-indexcache /tmp/luci-modulecache/*

# 7. Restart Layanan
/etc/init.d/uhttpd restart
/etc/init.d/firewall restart

# Sinkronisasi ke disk penyimpanan
sync

echo "----------------------------------------------------"
echo "  SUKSES: RLX-WRT Fix TTL telah terpasang!"
echo "  Silakan REFRESH browser Anda (F5)."
echo "  Cek di menu: Network -> Fix TTL 65"
echo "----------------------------------------------------"
