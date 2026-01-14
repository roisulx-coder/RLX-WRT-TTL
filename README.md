# <p align="center">🚀 RLX-WRT: Ultimate Fix TTL Engine</p>

<p align="center">
  <img src="https://img.shields.io/badge/OpenWrt-21.02%2B-blue?style=for-the-badge&logo=openwrt" alt="OpenWrt Version">
  <img src="https://img.shields.io/badge/Language-Lua%20%7C%20Shell-brightgreen?style=for-the-badge" alt="Languages">
  <img src="https://img.shields.io/badge/Engine-Nftables-orange?style=for-the-badge" alt="Engine">
  <img src="https://img.shields.io/badge/License-MIT-red?style=for-the-badge" alt="License">
</p>

---

## 🛠 Apa itu RLX-WRT TTL?

**RLX-WRT Fix TTL** adalah instrumen otomatisasi untuk OpenWrt yang dirancang untuk melewati deteksi hotspot operator seluler. Dengan mengubah nilai **Time To Live (TTL)** secara cerdas, trafik tethering Anda akan terbaca sebagai trafik perangkat reguler.



### ⚡ Fitur Unggulan
* **Modern UI Dashboard**: Antarmuka berbasis LuCI yang elegan dan responsif.
* **One-Click Toggle**: Aktifkan atau nonaktifkan bypass TTL hanya dengan satu klik.
* **Nftables Backend**: Menggunakan teknologi firewall modern, lebih ringan dan hemat CPU.
* **Smart Cleanup**: Menghapus residu konfigurasi otomatis saat fitur dinonaktifkan.
* **Ghost Mode**: Menyamarkan trafik secara efektif di balik nilai TTL 65.

---

## 📥 Instalasi Cepat

Cukup salin dan tempel satu baris perintah sakti ini ke terminal SSH Anda:

```bash
wget -qO- [https://raw.githubusercontent.com/roisulx-coder/RLX-WRT-TTL/main/rlxwrtttl.sh](https://raw.githubusercontent.com/roisulx-coder/RLX-WRT-TTL/main/rlxwrtttl.sh) | sed 's/\r$//' | sh
