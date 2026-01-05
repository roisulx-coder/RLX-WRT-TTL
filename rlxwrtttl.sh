#!/bin/sh

# Jalur file
TTL_FILE="/etc/nftables.d/ttl65.nft"
RLXWRT_LUA="/usr/lib/lua/luci/controller/rlxwrt/rlxwrt.lua"
PAGE_HTM="/usr/lib/lua/luci/view/rlxwrt/page.htm"

# Hapus sisa-sisa file lama
rm -rf /usr/lib/lua/luci/controller/rlxwrt/ /usr/lib/lua/luci/view/rlxwrt/ 2>/dev/null
rm -rf /usr/lib/lua/luci/controller/indowrt/ /usr/lib/lua/luci/view/indowrt/ 2>/dev/null

# 1. Membuat file rlxwrt.lua
mkdir -p "$(dirname "$RLXWRT_LUA")"
cat <<EOL > "$RLXWRT_LUA"
module("luci.controller.rlxwrt.rlxwrt", package.seeall)

function index()
    entry({"admin", "network", "rlxwrt"}, call("render_page"), _("Fix TTL 65"), 100).leaf = true
end

function get_status()
    local stat = luci.sys.call("ls /etc/nftables.d/ttl65.nft >/dev/null 2>&1")
    return (stat == 0)
end

function render_page()
    local http = require "luci.http"
    local sys = require "luci.sys"
    local action = http.formvalue("action")

    if action == "enable" then
        local ttl_rule = [[
## Fix TTL RLXWRT
chain mangle_postrouting_ttl65 {
    type filter hook postrouting priority 300; policy accept;
    counter ip ttl set 65
}
chain mangle_prerouting_ttl65 {
    type filter hook prerouting priority 300; policy accept;
    counter ip ttl set 65
}
]]
        local f = io.open("/etc/nftables.d/ttl65.nft", "w")
        if f then f:write(ttl_rule) f:close() end
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

# 2. Membuat file page.htm (Tampilan Elegan)
mkdir -p "$(dirname "$PAGE_HTM")"
cat <<EOL > "$PAGE_HTM"
<%+header%>

<style>
    .rlx-container { max-width: 600px; margin: 20px auto; font-family: sans-serif; }
    .rlx-card { background: #fff; border-radius: 12px; box-shadow: 0 4px 15px rgba(0,0,0,0.1); padding: 30px; border: 1px solid #eee; text-align: center; }
    .status-badge { display: inline-block; padding: 8px 20px; border-radius: 50px; font-weight: bold; margin-bottom: 20px; font-size: 14px; }
    .status-on { background: #e6fffa; color: #2d6a4f; border: 1px solid #b7e4c7; }
    .status-off { background: #fff5f5; color: #c53030; border: 1px solid #feb2b2; }
    .rlx-title { font-size: 24px; color: #2d3748; margin-bottom: 10px; font-weight: 700; }
    .rlx-desc { color: #718096; margin-bottom: 30px; line-height: 1.6; }
    .btn-wrap { display: flex; gap: 15px; justify-content: center; }
    .btn-rlx { border: none; padding: 12px 25px; border-radius: 8px; font-weight: 600; cursor: pointer; transition: all 0.3s; font-size: 14px; min-width: 140px; }
    .btn-enable { background: #3182ce; color: white; box-shadow: 0 4px 6px rgba(49, 130, 206, 0.3); }
    .btn-enable:hover { background: #2b6cb0; transform: translateY(-2px); }
    .btn-disable { background: #edf2f7; color: #4a5568; }
    .btn-disable:hover { background: #e2e8f0; color: #2d3748; }
    .footer-note { margin-top: 25px; font-size: 11px; color: #a0aec0; text-transform: uppercase; letter-spacing: 1px; }
</style>

<div class="rlx-container">
    <div class="rlx-card">
        <div class="rlx-title">RLXWRT Engine</div>
        <p class="rlx-desc">Fix TTL 65 Bypass Hotspot detection. Menyamarkan trafik perangkat Anda menjadi trafik reguler secara otomatis.</p>
        
        <% if is_active then %>
            <div class="status-badge status-on">● SERVICE ACTIVE (TTL 65)</div>
        <% else %>
            <div class="status-badge status-off">● SERVICE INACTIVE</div>
        <% end %>

        <div class="btn-wrap">
            <form method="post" action="<%=request_uri%>">
                <input type="hidden" name="action" value="enable" />
                <button type="submit" class="btn-rlx btn-enable">ENABLE NOW</button>
            </form>

            <form method="post" action="<%=request_uri%>">
                <input type="hidden" name="action" value="disable" />
                <button type="submit" class="btn-rlx btn-disable">DISABLE</button>
            </form>
        </div>
        
        <div class="footer-note">MOD by RLX-WRT</div>
    </div>
</div>

<%+footer%>
EOL

# Izin dan Restart uhttpd
chmod -R 755 /usr/lib/lua/luci/controller/rlxwrt/
chmod -R 755 /usr/lib/lua/luci/view/rlxwrt/
/etc/init.d/uhttpd restart

echo "----------------------------------------------------"
echo "  RLX-WRT Fix TTL Terpasang!"
echo "  Cek di: Network -> Fix TTL 65"
echo "----------------------------------------------------"