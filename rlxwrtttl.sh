#!/bin/sh

# =========================================================
# RLX-WRT TTL Installer
# =========================================================

# Jalur file utama
RLXWRT_LUA="/usr/lib/lua/luci/controller/rlxwrt.lua"
PAGE_HTM="/usr/lib/lua/luci/view/rlxwrt/page.htm"

echo "Memperbarui instalasi RLX-WRT..."

# 1. Persiapan Folder
mkdir -p /etc/nftables.d
mkdir -p /usr/lib/lua/luci/controller
mkdir -p /usr/lib/lua/luci/view/rlxwrt

# 2. Membuat file rlxwrt.lua (Controller)
cat <<'EOL' > "$RLXWRT_LUA"
module("luci.controller.rlxwrt", package.seeall)

function index()
    entry({"admin", "network", "rlxwrt"}, call("render_page"), _("Fix TTL 65"), 100).leaf = true
end

function get_status()
    -- Mengecek apakah ada file ttl di direktori nftables
    local stat = os.execute("ls /etc/nftables.d/ttl*.nft >/dev/null 2>&1")
    return (stat == 0)
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
        -- Pastikan folder ada
        sys.call("mkdir -p /etc/nftables.d")
        local f = io.open("/etc/nftables.d/ttl65.nft", "w")
        if f then 
            f:write(ttl_rule) 
            f:close() 
        end
        sys.call("/etc/init.d/firewall restart")
        
    elseif action == "disable" then
        -- Menghapus semua file ttl64.nft atau ttl65.nft agar bersih
        sys.call("rm -f /etc/nftables.d/ttl64.nft")
        sys.call("rm -f /etc/nftables.d/ttl65.nft")
        sys.call("/etc/init.d/firewall restart")
    end

    luci.template.render("rlxwrt/page", {
        is_active = get_status()
    })
end
EOL

# 3. Membuat file page.htm (Tampilan Web)
cat <<'EOL' > "$PAGE_HTM"
<%+header%>
<style>
    .rlx-container { max-width: 600px; margin: 20px auto; font-family: sans-serif; }
    .rlx-card { background: #fff; border-radius: 12px; box-shadow: 0 4px 15px rgba(0,0,0,0.08); padding: 30px; border: 1px solid #eee; text-align: center; }
    .status-badge { display: inline-block; padding: 8px 20px; border-radius: 50px; font-weight: bold; margin-bottom: 25px; font-size: 13px; }
    .status-on { background: #dcfce7; color: #166534; border: 1px solid #bbf7d0; }
    .status-off { background: #fee2e2; color: #991b1b; border: 1px solid #fecaca; }
    .rlx-title { font-size: 26px; color: #1a202c; margin-bottom: 12px; font-weight: 800; }
    .btn-wrap { display: flex; gap: 15px; justify-content: center; }
    .btn-rlx { border: none; padding: 12px 28px; border-radius: 8px; font-weight: 700; cursor: pointer; transition: 0.2s; min-width: 150px; }
    .btn-enable { background: #2563eb; color: white; }
    .btn-disable { background: #f1f5f9; color: #475569; border: 1px solid #e2e8f0; }
    .footer-note { margin-top: 30px; font-size: 10px; color: #94a3b8; text-transform: uppercase; letter-spacing: 2px; }
</style>

<div class="rlx-container">
    <div class="rlx-card">
        <div class="rlx-title">RLX-WRT | Fix TTK</div>
        <p>Fix TTL Bypass Hotspot Detection</p>
        
        <% if is_active then %>
            <div class="status-badge status-on">● TTL TERPASANG</div>
        <% else %>
            <div class="status-badge status-off">● TTL MATI</div>
        <% end %>

        <div class="btn-wrap">
            <form method="post" action="<%=request_uri%>" style="display:inline;">
                <input type="hidden" name="action" value="enable" />
                <button type="submit" class="btn-rlx btn-enable">PASANG TTL</button>
            </form>
            <form method="post" action="<%=request_uri%>" style="display:inline;">
                <input type="hidden" name="action" value="disable" />
                <button type="submit" class="btn-rlx btn-disable">HAPUS TTL</button>
            </form>
        </div>
        <div class="footer-note">Powered by roisulx-coder</div>
    </div>
</div>
<%+footer%>
EOL

# 4. Pengaturan Izin
chmod 644 "$RLXWRT_LUA"
chmod 644 "$PAGE_HTM"

# 5. Bersihkan Cache LuCI agar perubahan Controller terbaca
rm -rf /tmp/luci-indexcache /tmp/luci-modulecache/*

# 6. Restart uhttpd
/etc/init.d/uhttpd restart
sync

echo "----------------------------------------------------"
echo "  SUKSES TERPASANG!"
echo "  POWERED BY RLXWRT"
echo "----------------------------------------------------"

