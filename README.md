<div align="center">

# 🎮 XiuCode Defender
### *Time Attack Edition — v0.1*

**Cyberpunk Hacking Simulation Game untuk Android**

![Flutter](https://img.shields.io/badge/Flutter-3.41.9-02569B?style=for-the-badge&logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.11.5-0175C2?style=for-the-badge&logo=dart)
![Android](https://img.shields.io/badge/Android-APK-3DDC84?style=for-the-badge&logo=android)
![Version](https://img.shields.io/badge/Version-0.1.0-ff0066?style=for-the-badge)

[![Build APK](https://github.com/YOUR_USERNAME/xiucode-defender/actions/workflows/build_apk.yml/badge.svg)](https://github.com/YOUR_USERNAME/xiucode-defender/actions/workflows/build_apk.yml)

</div>

---

## 🕹️ Tentang Game

**XiuCode Defender** adalah game simulasi peretasan *fast-paced* di mana pemain berperan sebagai **white-hat hacker**. Selesaikan **15 level eksploitasi sistem** dalam batas waktu **5 menit per level** dengan mengetikkan perintah terminal yang tepat!

### ⚡ Core Gameplay
- ⏱️ **5 menit** per level — waktu habis = Game Over
- ⌨️ Ketik perintah terminal nyata (nmap, hydra, sqlmap, dll)
- ❌ Command salah = **-10 detik** penalti waktu
- 💡 Hint tersedia via tombol XIU Mascot
- 🏆 Leaderboard lokal untuk catat rekor tercepat

---

## 🗺️ Level Structure

| Level | Nama | Kategori | Teknik |
|-------|------|----------|--------|
| 1 | Port Recon Alpha | 🟢 Introductory | nmap -sV |
| 2 | Service Fingerprint | 🟢 Introductory | OS Detection |
| 3 | Open Port Strike | 🟢 Introductory | FTP Exploit |
| 4 | Network Topology Map | 🟢 Introductory | Ping Sweep |
| 5 | Vuln Scanner | 🟢 Introductory | NSE Scripts |
| 6 | SSH Brute Force | 🟡 Intermediate | Hydra |
| 7 | FTP Anonymous Pwn | 🟡 Intermediate | File Exfiltration |
| 8 | Firewall Bypass | 🟡 Intermediate | Packet Fragmentation |
| 9 | Log Wiper | 🟡 Intermediate | Forensics Evasion |
| 10 | Hash Cracker | 🟡 Intermediate | John The Ripper |
| 11 | SSL/TLS Crackdown | 🔴 Advanced | OpenSSL Audit |
| 12 | Root Escalation | 🔴 Advanced | SUID Exploit |
| 13 | SQL Injection | 🔴 Advanced | sqlmap |
| 14 | XSS Payload | 🔴 Advanced | Cookie Stealing |
| 15 | SYSTEM ZERO | 🔴 Advanced | Full Chain Attack |

---

## 📥 Download APK

### Cara Termudah (GitHub Actions)
1. Pergi ke tab **[Actions](../../actions)**
2. Klik workflow **Build & Release APK** terbaru
3. Scroll ke bawah bagian **Artifacts**
4. Download **xiucode-defender-apk**

### Via GitHub Releases
Pergi ke **[Releases](../../releases)** untuk download APK versi stabil.

---

## 🛠️ Build Sendiri

### Prasyarat
- [Flutter SDK 3.41+](https://docs.flutter.dev/get-started/install)
- [Android Studio](https://developer.android.com/studio) (untuk Android SDK)
- Java 17+

### Langkah Build
```bash
# Clone repository
git clone https://github.com/YOUR_USERNAME/xiucode-defender.git
cd xiucode-defender

# Install dependencies
flutter pub get

# Build APK debug (untuk testing)
flutter build apk --debug

# Build APK release (untuk distribusi)
flutter build apk --release

# APK tersimpan di:
# build/app/outputs/flutter-apk/app-release.apk
```

---

## 🎨 Tech Stack

| Komponen | Teknologi |
|----------|-----------|
| Framework | Flutter 3.41.9 |
| Language | Dart 3.11.5 |
| State Management | Provider |
| Animasi | flutter_animate |
| Storage | shared_preferences |
| Background | Custom Canvas (Matrix Rain) |

---

## 📱 Cara Install APK di HP

1. Download file `.apk` dari Releases/Artifacts
2. Buka **Pengaturan → Keamanan**
3. Aktifkan **"Sumber tidak dikenal"** / **"Install unknown apps"**
4. Buka file APK dan install
5. Mainkan! 🎮

---

## 👾 Maskot XIU

Game ini menampilkan **XIU** — operator sistem yang memantau performa kamu:

| State | Kapan Muncul |
|-------|-------------|
| 😎 Normal | Saat briefing atau mengetik lancar |
| 😄 Success | Saat berhasil menembus target |
| 😨 Fail | Saat command salah / waktu menipis |

---

## 📄 License

MIT License — bebas digunakan dan dimodifikasi.

---

<div align="center">
Made with ❤️ and ☕ by XiuCode Team
</div>
