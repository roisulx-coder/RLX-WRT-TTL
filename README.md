# 🚀 RLX-WRT Fix TTL 65 Engine

[![Status](https://img.shields.io/badge/Status-Stable-green.svg)]()
[![Platform](https://img.shields.io/badge/Platform-OpenWrt-blue.svg)]()
[![Engine](https://img.shields.io/badge/Engine-nftables-orange.svg)]()

**RLX-WRT Fix TTL** adalah solusi otomatis untuk memanipulasi nilai **Time To Live (TTL)** pada perangkat OpenWrt. Proyek ini dirancang khusus untuk membantu pengguna melakukan bypass deteksi hotspot/tethering dari operator seluler agar trafik terdeteksi sebagai trafik perangkat reguler.

---

## ✨ Fitur Utama
* **One-Click Installation**: Instalasi sangat mudah hanya dengan satu baris perintah.
* **Modern UI**: Antarmuka berbasis LuCI yang bersih dan elegan (RLX-WRT style).
* **Nftables Support**: Menggunakan teknologi firewall terbaru untuk kinerja yang lebih ringan dan stabil.
* **Dual Chain Fix**: Mengatur TTL pada rantai *prerouting* dan *postrouting* secara bersamaan.
* **Auto-Cleanup**: Menghapus file konfigurasi lama (seperti `ttl64.nft`) secara otomatis saat dinonaktifkan.

---

## 📸 Tampilan Antarmuka


---

## 🛠️ Instalasi Cepat

Buka terminal SSH (Putty atau Termius) pada OpenWrt Anda, lalu salin dan tempel perintah di bawah ini:

```bash
wget -qO- [https://raw.githubusercontent.com/roisulx-coder/RLX-WRT-TTL/main/rlxwrtttl.sh](https://raw.githubusercontent.com/roisulx-coder/RLX-WRT-TTL/main/rlxwrtttl.sh) | sed 's/\r$//' | sh
