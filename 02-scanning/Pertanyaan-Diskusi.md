# 1. Mengapa DAST lebih cocok untuk menemukan Stored XSS dibanding SAST?
DAST (Dynamic Application Security Testing) lebih unggul dalam mendeteksi Stored XSS karena ia menguji aplikasi dari luar ke dalam pada saat runtime.

- Eksekusi Payload: DAST menyuntikkan payload XSS ke dalam input (seperti form profil atau komentar) dan kemudian menavigasi ke halaman lain untuk melihat apakah payload tersebut benar-benar dieksekusi oleh browser.

- Visibilitas End-to-End: DAST melihat hasil akhir dari penggabungan data antara database, backend, dan frontend.

- Keterbatasan SAST: Sebaliknya, SAST hanya memindai kode sumber statis. SAST sering kali kesulitan melacak alur data (taint analysis) yang masuk ke database di satu modul kode dan keluar di modul kode lain yang berbeda, sehingga sering melewatkan konteks bagaimana data tersebut akhirnya dirender di browser.

# 2. Apa kekurangan utama Semgrep dalam mendeteksi kerentanan business logic?
Kekurangan utama Semgrep (dan alat SAST berbasis pattern matching lainnya) adalah ketidakmampuannya untuk memahami konteks fungsional dan tujuan desain sebuah fitur.

- Berbasis Pola, Bukan Logika: Semgrep bekerja dengan mencari pola kode yang berbahaya (seperti penggunaan fungsi eval()). Namun, business logic (seperti: "Apakah user A boleh melihat data user B?") bukanlah sebuah "pola kode yang salah", melainkan kesalahan alur kerja.

- State-Insensitive: Semgrep tidak mengetahui status aplikasi atau izin akses yang seharusnya berlaku pada kondisi tertentu. Alat ini tidak bisa membedakan mana diskon 100% yang merupakan fitur promosi resmi dengan diskon 100% yang merupakan hasil manipulasi parameter oleh penyerang.

# 3. Mengapa false positive menjadi masalah serius dalam SAST, terutama dalam pipeline CI/CD?
Dalam pipeline CI/CD yang menuntut kecepatan (velocity), false positive (peringatan keamanan yang salah) dapat melumpuhkan produktivitas tim pengembang karena:

- Menghambat Deployment: Jika pipeline diatur untuk fail saat ditemukan kerentanan, false positive akan menghentikan rilis fitur yang sebenarnya aman, menyebabkan penundaan (bottleneck).

- "Alert Fatigue": Pengembang akan mulai mengabaikan peringatan keamanan jika terlalu banyak laporan yang tidak akurat. Hal ini berbahaya karena saat ada kerentanan asli (true positive), pengembang mungkin menganggapnya sebagai kesalahan sistem lagi.

- Beban Investigasi: Setiap temuan memerlukan waktu manual dari tim security atau developer untuk memverifikasi, yang membuang-buang sumber daya berharga.

# 4. Pada kasus SSRF CVE-2021-27188, data apa yang dapat diakses attacker jika SSRF berhasil ke http://127.0.0.1/?
Pada kasus kerentanan SSRF (Server-Side Request Forgery) di AdmirerGallery (CVE-2021-27188), jika penyerang berhasil mengarahkan server untuk melakukan request ke http://127.0.0.1/ (localhost), mereka dapat mengakses:

- Layanan Internal: Data dari layanan yang hanya mendengarkan (listening) pada interface lokal (loopback) dan tidak terekspos ke internet publik.

- Metadata Server: Jika berjalan di lingkungan cloud (seperti AWS/GCP/Azure), penyerang bisa mengakses endpoint metadata (misalnya 169.254.169.254) untuk mendapatkan IAM credentials, access tokens, atau konfigurasi instans.

- File Lokal/Konfigurasi: Tergantung pada protokol yang didukung (seperti file:// atau gopher://), penyerang mungkin bisa membaca file sensitif seperti /etc/passwd atau file konfigurasi database yang berisi clear-text password.

- Integrasi Internal: Mengakses panel administrasi internal atau API lokal yang tidak memerlukan autentikasi tambahan karena menganggap koneksi dari 127.0.0.1 adalah koneksi terpercaya (trusted).