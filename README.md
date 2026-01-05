# Fix TTL pada OpenWrt (RLXWRT Edition)

<p align="center">
  <img src="https://img.shields.io/badge/OpenWrt-23.05-blue?style=for-the-badge&logo=openwrt" alt="OpenWrt Version">
  <img src="https://img.shields.io/badge/UI-Modern-brightgreen?style=for-the-badge" alt="UI Style">
  <img src="https://img.shields.io/badge/Platform-STB%20HG680P-orange?style=for-the-badge" alt="Platform">
</p>

---

Proyek ini bertujuan untuk memperbaiki dan mengonfigurasi **TTL (Time To Live)** pada OpenWrt secara otomatis. Dengan menggunakan skrip **RLXWRT**, Anda dapat menetapkan nilai TTL agar trafik hotspot terdeteksi sebagai trafik reguler, lengkap dengan antarmuka web yang elegan untuk memudahkan pengelolaan.

## 🚀 Fitur Utama

* **Fix TTL 65**: Mengonfigurasi `nftables` secara otomatis untuk bypass deteksi kuota hotspot.
* **Modern Web Interface**: Tampilan berbasis kartu yang bersih dan responsif menggunakan framework LuCI.
* **Control Center**: Tombol **Enable** dan **Disable** instan tanpa perlu edit kode manual.
* **Zero Conflict**: Skrip dirancang untuk berjalan berdampingan dengan firewall OpenWrt tanpa merusak rule yang sudah ada.

## 🛠 Instalasi

### 1. Persiapkan Perangkat OpenWrt
Pastikan perangkat Anda sudah memiliki paket `luci` dan `nftables`. Jalankan perintah ini di terminal:

```bash
opkg update
opkg install luci nftables

# Memberikan izin eksekusi
chmod +x rlxwrt.sh

# Menjalankan instalasi
./rlxwrt.sh
