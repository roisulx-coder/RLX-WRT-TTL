# <p align="center">🚀 RLX-WRT: Fix TTL Pro Engine</p>

<p align="center">
  <img src="https://img.shields.io/badge/OpenWrt-21.02%2B-blue?style=for-the-badge&logo=openwrt" alt="OpenWrt Version">
  <img src="https://img.shields.io/badge/Engine-Nftables-orange?style=for-the-badge" alt="Engine">
  <img src="https://img.shields.io/badge/Version-Pro--Edition-red?style=for-the-badge" alt="Version">
</p>

---

## 🛠 Deskripsi Proyek
**RLX-WRT Fix TTL Pro** adalah alat manajemen jaringan untuk OpenWrt yang berfungsi memanipulasi nilai **Time To Live (TTL)**. Versi Pro ini memungkinkan Anda memilih nilai TTL secara fleksibel (64 atau 65) melalui antarmuka visual yang modern.

### 🌟 Fitur Baru di Versi Pro
- **Multi-TTL Selection**: Pilih antara TTL 64 (Linux/Android) atau TTL 65 (Windows/Bypass Hotspot).
- **Persistent Rules**: Aturan otomatis aktif kembali setelah router di-reboot.
- **Dynamic Dashboard**: Status real-time yang menampilkan angka TTL yang sedang aktif.
- **Smart Firewall Integration**: Terintegrasi langsung dengan `nftables` tanpa mengganggu rule lain.

---

## 📸 Cara Kerja TTL Manipulation


---

## 📥 Panduan Instalasi Cepat

Gunakan perintah di bawah ini pada terminal SSH (Putty/Termius) OpenWrt Anda:

```bash
wget -qO- [https://raw.githubusercontent.com/roisulx-coder/RLX-WRT-TTL/main/rlxwrtttl.sh](https://raw.githubusercontent.com/roisulx-coder/RLX-WRT-TTL/main/rlxwrtttl.sh) | sed 's/\r$//' | sh
