<div align="center">

# XiuCode Defender
### Time Attack Edition -- v0.1

**Cyberpunk Hacking Simulation Game**

![Flutter](https://img.shields.io/badge/Flutter-3.44.6-02569B?style=for-the-badge&logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.12.2-0175C2?style=for-the-badge&logo=dart)
![Platform](https://img.shields.io/badge/Platform-Linux%20%7C%20Android%20%7C%20Web-3DDC84?style=for-the-badge)
![Version](https://img.shields.io/badge/Version-0.1.0-ff0066?style=for-the-badge)

</div>

---

## Deskripsi Game

**XiuCode Defender** adalah game simulasi peretasan bergenre cyberpunk dengan mekanik Time Attack. Pemain berperan sebagai **Cyber Guardian** -- operator keamanan siber yang bertugas melindungi **Xiu Corporation**, sebuah perusahaan teknologi multinasional yang menjadi garis pertahanan terakhir keamanan siber di kawasan Asia Tenggara.

### Latar Cerita

**Xiu Corporation** berpusat di Jalan Kembang Jepun (Kawasan Kya-Kya), Surabaya, Indonesia. Perusahaan ini mengembangkan dan mengelola sistem keamanan jaringan nasional, termasuk infrastruktur pertahanan siber untuk klien-klien strategis di seluruh Asia Tenggara.

Di bawah komando mentor AI bernama **XIU**, setiap operator ditugaskan untuk menghadapi ancaman dari sindikat peretas global yang mengincar data sensitif Xiu Corporation dan kliennya. Dengan waktu yang terbatas, setiap operasi harus diselesaikan sebelum sistem dikompromikan.

### Gameplay

- 15 level eksploitasi sistem dengan tingkat kesulitan berprogressi
- 5 menit waktu per level -- waktu habis = Game Over
- Ketik perintah terminal nyata (nmap, hydra, sqlmap, john, dll)
- Command salah = -10 detik penalti waktu
- Misi muncul sebagai transmisi terenkripsi 3 detik setelah level dimulai
- Cerita operasi XIU Corporation yang menghubungkan setiap level
- Leaderboard lokal untuk mencatat rekor tercepat

### Terminal

Game ini dirancang menyerupai terminal Kali Linux asli, dengan prompt `root@xiu-defender`, boot sequence, dan tampilan filesystem yang autentik. Setiap perintah yang diketikkan akan menghasilkan output seolah-olah dijalankan di sistem nyata.

---

## Struktur Level

| Level | Nama | Kategori | Teknik |
|-------|------|----------|--------|
| 1 | Port Recon Alpha | Introductory | nmap -sV |
| 2 | Service Fingerprint | Introductory | OS Detection |
| 3 | Open Port Strike | Introductory | FTP Exploit |
| 4 | Network Topology Map | Introductory | Ping Sweep |
| 5 | Vuln Scanner | Introductory | NSE Scripts |
| 6 | SSH Brute Force | Intermediate | Hydra |
| 7 | FTP Anonymous Pwn | Intermediate | File Exfiltration |
| 8 | Firewall Bypass | Intermediate | Packet Fragmentation |
| 9 | Log Wiper | Intermediate | Forensics Evasion |
| 10 | Hash Cracker | Intermediate | John The Ripper |
| 11 | SSL/TLS Crackdown | Advanced | OpenSSL Audit |
| 12 | Root Escalation | Advanced | SUID Exploit |
| 13 | SQL Injection | Advanced | sqlmap |
| 14 | XSS Payload | Advanced | Cookie Stealing |
| 15 | SYSTEM ZERO | Advanced | Full Chain Attack |

---

## Tech Stack

| Komponen | Teknologi |
|----------|-----------|
| Framework | Flutter |
| Language | Dart |
| State Management | Provider |
| Animasi | flutter_animate |
| Storage | shared_preferences |
| Background | Custom Canvas (Matrix Rain) |
| Mascot | CustomPainter (Pixel Art) |

---

## Build

### Prasyarat

- Flutter SDK 3.44+
- Android Studio (untuk Android SDK)
- Java 17+

### Langkah

```bash
# Clone repository
git clone https://github.com/YOUR_USERNAME/xiucode-defender.git
cd xiucode-defender

# Install dependencies
flutter pub get

# Jalankan di Linux
flutter run -d linux

# Build APK debug
flutter build apk --debug

# Build APK release
flutter build apk --release
```

---

## License

MIT License.
