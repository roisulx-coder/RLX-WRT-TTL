#!/bin/sh

# =========================================================
# RLX-WRT Fix TTL Engine - Pro Edition (Multi-TTL & Auto)
# =========================================================

# Jalur file utama
RLXWRT_LUA="/usr/lib/lua/luci/controller/rlxwrt.lua"
PAGE_HTM="/usr/lib/lua/luci/view/rlxwrt/page.htm"

echo "Menginstal RLX-WRT Pro Edition..."

# 1. Bersihkan instalasi lama
rm -rf /usr/lib/lua/luci/controller/rlxwrt* /usr/lib/lua/luci/view/rlxwrt/ 2>/dev/null

# 2. Buat direktori
mkdir -p /etc/nftables.d /usr/lib/lua/luci/controller /usr/lib/lua/luci/view/rlxwrt

# 3. Membuat file rlxwrt.lua (Controller Pro)
cat <<'EOL' > "$RLXWRT_LUA"
module("luci.controller.rlxwrt", package.seeall)

function index()
    entry({"admin", "network", "rlxwrt"}, call("render_page"), _("Fix TTL Engine"), 100).leaf = true
end

function get_status()
    local f = io.popen("ls /etc/nftables.d/ttl*.nft 2>/dev/null")
    local content = f:read("*all")
    f:close()
    if content ~= "" then
        return content:match("ttl(%d+)")
    end
    return nil
end

function render_page()
    local http = require "luci.http"
    local sys = require "luci.sys"
    local action = http.formvalue("action")
    local val = http.formvalue("ttl_val")

    if action == "enable" and val then
        sys.call("rm -f /etc/nftables.d/ttl*.nft")
        local ttl_rule = string.format([[
chain rlxwrt_post {
    type filter hook postrouting priority 300; policy accept;
    counter ip ttl set %s
}
chain rlxwrt_pre {
    type filter hook prerouting priority 300; policy accept;
    counter ip ttl set %s
}]], val, val)
        
        local f = io.open("/etc/nftables.d/ttl" .. val .. ".nft", "w")
        if f then f:write(ttl_rule) f:close() end
        sys.call("/etc/init.d/firewall restart")
    elseif action == "disable" then
        sys.call("rm -f /etc/nftables.d/ttl*.nft && /etc/init.d/firewall restart")
    end

    luci.template.render("rlxwrt/page", {
        active_ttl = get_status()
    })
end
EOL

# 4. Membuat file page.htm (UI Pro)
cat <<'EOL' > "$PAGE_HTM"
<%+header%>
<style>
    .rlx-card { background: #fff; border-radius: 15px; box-shadow: 0 10px 30px rgba(0,0,0,0.1); padding: 35px; text-align: center; max-width: 550px; margin: 30px auto; border: 1px solid #eee; }
    .status-box { padding: 10px 20px; border-radius: 10px; font-weight: bold; margin: 20px 0; display: inline-block; }
    .status-on { background: #dcfce7; color: #15803d; border: 1px solid #bbf7d0; }
    .status-off { background: #fee2e2; color: #b91c1c; border: 1px solid #fecaca; }
    .btn-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 10px; margin-top: 20px; }
    .btn-rlx { border: none; padding: 15px; border-radius: 8px; font-weight: bold; cursor: pointer; transition: 0.3s; }
    .btn-blue { background: #2563eb; color: white; }
    .btn-blue:hover { background: #1d4ed8; }
    .btn-red { background: #f1f5f9; color: #475569; grid-column: span 2; margin-top: 10px; }
    .btn-red:hover { background: #e2e8f0; }
    .badge-ttl { font-size: 24px; display: block; margin-top: 5px; }
</style>

<div class="rlx-card">
    <h2 style="color:#1e293b; margin-bottom:5px;">RLX-WRT Engine</h2>
    <p style="color:#64748b;">Fix TTL Bypass Hotspot Detection</p>

    <% if active_ttl then %>
        <div class="status-box status-on">
            SERVICE ACTIVE
            <span class="badge-ttl">TTL <%=active_ttl%></span>
        </div>
    <% else %>
        <div class="status-box status-off">SERVICE INACTIVE</div>
    <% end %>

    <form method="post" action="<%=request_uri%>">
        <input type="hidden" name="action" value="enable" />
        <div class="btn-grid">
            <button type="submit" name="ttl_val" value="64" class="btn-rlx btn-blue">SET TTL 64</button>
            <button type="submit" name="ttl_val" value="65" class="btn-rlx btn-blue">SET TTL 65</button>
        </div>
    </form>

    <form method="post" action="<%=request_uri%>">
        <input type="hidden" name="action" value="disable" />
        <button type="submit" class="btn-rlx btn-red">DISABLE & RESET</button>
    </form>

    <div style="margin-top:30px; font-size:10px; color:#cbd5e1; letter-spacing:2px;">POWERED BY ROISULX-CODER</div>
</div>
<%+footer%>
EOL

# 5. Finalisasi
chmod 644 "$RLXWRT_LUA" "$PAGE_HTM"
rm -rf /tmp/luci-indexcache /tmp/luci-modulecache/*
/etc/init.d/uhttpd restart
sync

echo "FIX TTL Berhasil Terpasang!"

