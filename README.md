<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Instalasi RLX-WRT Fix TTL</title>
    <style>
        :root {
            --primary: #2563eb;
            --bg: #f8fafc;
            --text: #1e293b;
            --code-bg: #1e1e1e;
        }
        body {
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
            background-color: var(--bg);
            color: var(--text);
            line-height: 1.6;
            margin: 0;
            padding: 20px;
        }
        .container {
            max-width: 800px;
            margin: 40px auto;
            background: white;
            padding: 40px;
            border-radius: 16px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.05);
        }
        .header {
            text-align: center;
            border-bottom: 2px solid #f1f5f9;
            padding-bottom: 20px;
            margin-bottom: 30px;
        }
        h1 { color: var(--primary); margin: 0; font-size: 28px; }
        h2 { font-size: 20px; margin-top: 30px; border-left: 4px solid var(--primary); padding-left: 15px; }
        
        .code-block {
            background: var(--code-bg);
            color: #dcdcdc;
            padding: 20px;
            border-radius: 10px;
            position: relative;
            font-family: "SFMono-Regular", Consolas, monospace;
            font-size: 14px;
            overflow-x: auto;
            margin: 20px 0;
        }
        .copy-btn {
            position: absolute;
            top: 10px;
            right: 10px;
            background: rgba(255,255,255,0.1);
            border: 1px solid rgba(255,255,255,0.2);
            color: white;
            padding: 5px 10px;
            border-radius: 5px;
            cursor: pointer;
            font-size: 12px;
        }
        .copy-btn:hover { background: var(--primary); }

        .step {
            display: flex;
            align-items: flex-start;
            margin-bottom: 20px;
        }
        .step-number {
            background: var(--primary);
            color: white;
            width: 28px;
            height: 28px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
            margin-right: 15px;
            flex-shrink: 0;
            font-size: 14px;
        }
        .footer {
            text-align: center;
            margin-top: 40px;
            font-size: 12px;
            color: #94a3b8;
        }
        .badge {
            background: #dcfce7;
            color: #166534;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: bold;
        }
    </style>
</head>
<body>

<div class="container">
    <div class="header">
        <span class="badge">v2.0 Stable</span>
        <h1>RLX-WRT Fix TTL 65</h1>
        <p>Solusi Bypass Hotspot Detection untuk OpenWrt</p>
    </div>

    <h2>1. Persiapan Perangkat</h2>
    <div class="step">
        <div class="step-number">1</div>
        <p>Pastikan OpenWrt Anda sudah terhubung ke internet dan memiliki paket <code>wget</code> serta <code>nftables</code>.</p>
    </div>

    <h2>2. Jalankan Perintah Instalasi</h2>
    <p>Salin dan tempel perintah di bawah ini ke terminal (SSH) OpenWrt Anda:</p>
    
    <div class="code-block">
        <button class="copy-btn" onclick="copyCode()">Salin</button>
        <code id="installCommand">wget -qO- https://raw.githubusercontent.com/roisulx-coder/RLX-WRT-TTL/main/rlxwrtttl.sh | sed 's/\r$//' | sh</code>
    </div>

    <h2>3. Konfigurasi Via Web</h2>
    <div class="step">
        <div class="step-number">2</div>
        <p>Buka LuCI di browser, arahkan ke menu <b>Network → Fix TTL 65</b>.</p>
    </div>
    <div class="step">
        <div class="step-number">3</div>
        <p>Klik tombol <b>ENABLE NOW</b> untuk mengaktifkan fitur bypass.</p>
    </div>

    <div style="background: #fff9db; border-left: 4px solid #fcc419; padding: 15px; border-radius: 4px; font-size: 14px;">
        <strong>Catatan:</strong> Jika menu tidak muncul, silakan tekan <code>CTRL + F5</code> pada browser Anda untuk membersihkan cache.
    </div>

    <div class="footer">
        &copy; 2026 roisulx-coder | RLX-WRT Project Indonesia
    </div>
</div>

<script>
    function copyCode() {
        const text = document.getElementById('installCommand').innerText;
        navigator.clipboard.writeText(text);
        alert('Perintah berhasil disalin!');
    }
</script>

</body>
</html>
