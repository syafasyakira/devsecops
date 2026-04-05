# LAPORAN TEMUAN SAST (PHPCS + SEMGREP)

# BAGIAN 1 — PHPCS SECURITY

---

## Temuan #1

| Field | Nilai |
|---|---|
| **Nama Kerentanan** | Penggunaan `eval()` pada Kode Produksi |
| **Tool Penemu** | SAST |
| **Tool Spesifik** | PHP_CodeSniffer (phpcs) |
| **URL / File** | `ojs-src/lib/pkp/classes/install/Installer.inc.php` (baris 383, 431) |
| **Parameter / Baris Kode** | Baris 383: `eval(...)` ; Baris 431: `eval(...)` |
| **Method** | - |
| **Payload** | - |
| **Response / Bukti** | `ERROR \| Please do not use eval() functions` — PHPCS menandai dua penggunaan `eval()` di dalam kelas Installer. Fungsi ini mengeksekusi string sebagai kode PHP secara dinamis. |
| **OWASP Category** | A03:2021 - Injection |
| **Severity (Raw)** | High |

### Screenshot / Bukti

📷 Tangkap layar terminal yang menampilkan output PHPCS untuk file `Installer.inc.php`, khususnya baris yang menampilkan `ERROR | Please do not use eval() functions` di baris 383 dan 431.

### Catatan

Fungsi `eval()` mengeksekusi string sebagai kode PHP. Jika string tersebut dapat dipengaruhi oleh input pengguna atau data eksternal, dapat terjadi Remote Code Execution (RCE). Dalam konteks installer, penggunaan `eval()` berpotensi sangat berbahaya jika proses instalasi dapat dipicu dari luar atau jika parameter instalasi dapat dimanipulasi.

---

## Temuan #2

| Field | Nilai |
|---|---|
| **Nama Kerentanan** | Penggunaan `eval()` pada Validator — Potensi Code Injection |
| **Tool Penemu** | SAST |
| **Tool Spesifik** | PHP_CodeSniffer (phpcs) |
| **URL / File** | `ojs-src/lib/pkp/classes/validation/ValidatorTypeDescription.inc.php` (baris 95) |
| **Parameter / Baris Kode** | Baris 95: `eval(...)` |
| **Method** | - |
| **Payload** | - |
| **Response / Bukti** | `ERROR \| Please do not use eval() functions` — `eval()` ditemukan di dalam class validator yang bertugas memvalidasi tipe data. |
| **OWASP Category** | A03:2021 - Injection |
| **Severity (Raw)** | High |

### Screenshot / Bukti

📷 Tangkap layar output PHPCS untuk file `ValidatorTypeDescription.inc.php` yang menampilkan `ERROR | Please do not use eval() functions` di baris 95.

### Catatan

Keberadaan `eval()` di dalam kelas validasi sangat berbahaya karena validator adalah layer pertama yang menerima dan memproses input. Jika logika validasi menggunakan `eval()` untuk mengeksekusi ekspresi validasi yang berasal dari konfigurasi atau input, terdapat risiko code injection yang serius.

---

## Temuan #3

| Field | Nilai |
|---|---|
| **Nama Kerentanan** | File Upload Tanpa Validasi — `move_uploaded_file()` dan `is_uploaded_file()` Langsung dari User Input |
| **Tool Penemu** | SAST |
| **Tool Spesifik** | PHP_CodeSniffer (phpcs) |
| **URL / File** | `ojs-src/lib/pkp/classes/file/FileManager.inc.php` (baris 51, 91, 143) |
| **Parameter / Baris Kode** | Baris 51: `is_uploaded_file()` dari user input; Baris 91: `is_uploaded_file()` dari user input; Baris 143: `move_uploaded_file()` dari user input |
| **Method** | POST |
| **Payload** | Upload file berbahaya (misalnya PHP shell disguised as image) |
| **Response / Bukti** | `ERROR \| Filesystem function is_uploaded_file() detected with dynamic parameter directly from user input` (baris 51, 91) dan `ERROR \| Filesystem function move_uploaded_file() detected with dynamic parameter directly from user input` (baris 143) |
| **OWASP Category** | A04:2021 - Insecure Design |
| **Severity (Raw)** | High |

### Screenshot / Bukti

📷 Tangkap layar output PHPCS untuk file `FileManager.inc.php` yang menampilkan tiga baris ERROR terkait `is_uploaded_file()` dan `move_uploaded_file()` dengan parameter langsung dari user input.

### Catatan

Penggunaan `move_uploaded_file()` dan `is_uploaded_file()` dengan parameter yang bersumber langsung dari user input tanpa sanitasi adalah risiko keamanan kritis. Penyerang dapat mengupload file PHP berbahaya (web shell) yang kemudian dapat dieksekusi melalui server. Perlu dipastikan adanya validasi tipe file, ekstensi, dan konten sebelum memindahkan file yang diupload.

---

## Temuan #4

| Field | Nilai |
|---|---|
| **Nama Kerentanan** | `getimagesize()` Langsung dari User Input — Potensi SSRF / File Read |
| **Tool Penemu** | SAST |
| **Tool Spesifik** | PHP_CodeSniffer (phpcs) |
| **URL / File** | `ojs-src/lib/pkp/api/v1/_uploadPublicFile/PKPUploadPublicFileHandler.inc.php` (baris 148) |
| **Parameter / Baris Kode** | Baris 148: `getimagesize($userInput)` |
| **Method** | POST |
| **Payload** | URL atau path file arbitrer sebagai parameter input |
| **Response / Bukti** | `ERROR \| Filesystem function getimagesize() detected with dynamic parameter directly from user input` |
| **OWASP Category** | A10:2021 - Server-Side Request Forgery (SSRF) |
| **Severity (Raw)** | High |

### Screenshot / Bukti

📷 Tangkap layar output PHPCS untuk file `PKPUploadPublicFileHandler.inc.php` yang menampilkan `ERROR | Filesystem function getimagesize() detected with dynamic parameter directly from user input` di baris 148.

### Catatan

`getimagesize()` di PHP dapat menerima URL sebagai argumen. Jika input berasal langsung dari pengguna tanpa validasi, penyerang dapat menyuplai URL arbitrer untuk memaksa server melakukan request ke sistem internal (SSRF) atau membaca file lokal. Ini terjadi di endpoint API yang menangani upload file publik.

---

## Temuan #5

| Field | Nilai |
|---|---|
| **Nama Kerentanan** | `dirname()` Langsung dari User Input — Potensi Path Traversal |
| **Tool Penemu** | SAST |
| **Tool Spesifik** | PHP_CodeSniffer (phpcs) |
| **URL / File** | `ojs-src/lib/pkp/classes/install/form/InstallForm.inc.php` (baris 130) |
| **Parameter / Baris Kode** | Baris 130: `dirname($userInput)` |
| **Method** | POST |
| **Payload** | `../../../../etc/passwd` atau path traversal lainnya |
| **Response / Bukti** | `ERROR \| Filesystem function dirname() detected with dynamic parameter directly from user input` |
| **OWASP Category** | A01:2021 - Broken Access Control |
| **Severity (Raw)** | High |

### Screenshot / Bukti

📷 Tangkap layar output PHPCS untuk file `InstallForm.inc.php` yang menampilkan `ERROR | Filesystem function dirname() detected with dynamic parameter directly from user input` di baris 130.

### Catatan

Penggunaan `dirname()` dengan input langsung dari pengguna pada form instalasi berpotensi mengizinkan path traversal. Penyerang dapat memanipulasi input untuk mengakses direktori di luar yang seharusnya, atau menemukan struktur direktori server.

---

## Temuan #6

| Field | Nilai |
|---|---|
| **Nama Kerentanan** | `basename()` Langsung dari User Input — Potensi Path Traversal (Test Coverage Report) |
| **Tool Penemu** | SAST |
| **Tool Spesifik** | PHP_CodeSniffer (phpcs) |
| **URL / File** | `ojs-src/lib/pkp/tests/prependCoverageReport.php` (baris 20) |
| **Parameter / Baris Kode** | Baris 20: `basename($argv[...])` dari argumen CLI yang tidak disanitasi |
| **Method** | - |
| **Payload** | - |
| **Response / Bukti** | `ERROR \| Filesystem function basename() detected with dynamic parameter directly from user input` |
| **OWASP Category** | A01:2021 - Broken Access Control |
| **Severity (Raw)** | Medium |

### Screenshot / Bukti

📷 Tangkap layar output PHPCS untuk file `prependCoverageReport.php` yang menampilkan `ERROR | Filesystem function basename() detected with dynamic parameter directly from user input` di baris 20.

### Catatan

Meskipun ini adalah file test/tooling, penggunaan argumen CLI tanpa sanitasi tetap berpotensi berbahaya jika skrip ini dapat dipanggil dari web atau proses otomatis dengan input yang dikendalikan penyerang.

---

## Temuan #7

| Field | Nilai |
|---|---|
| **Nama Kerentanan** | Include/Require Tanpa Ekstensi File — Berpotensi PHP Code Not Scanned |
| **Tool Penemu** | SAST |
| **Tool Spesifik** | PHP_CodeSniffer (phpcs) |
| **URL / File** | 18 file terdampak — file kritis: `ojs-src/lib/pkp/classes/install/Installer.inc.php` (baris 439), `ojs-src/lib/pkp/classes/core/PKPPageRouter.inc.php` (baris 203, 205, 206), `ojs-src/lib/pkp/classes/core/APIRouter.inc.php` (baris 113), `ojs-src/lib/pkp/classes/cache/FileCache.inc.php` (baris 46), `ojs-src/lib/pkp/classes/plugins/PluginRegistry.inc.php` (baris 241), `ojs-src/lib/pkp/classes/plugins/Plugin.inc.php` (baris 495), `ojs-src/lib/pkp/includes/functions.inc.php` (baris 25, 347) |
| **Parameter / Baris Kode** | Berbagai baris — `include`/`require` dengan path tanpa ekstensi file |
| **Method** | - |
| **Payload** | - |
| **Response / Bukti** | `ERROR \| No file extension has been found in a include/require function. This implies that some PHP code is not scanned by PHPCS.` — 18 instance ditemukan |
| **OWASP Category** | A05:2021 - Security Misconfiguration |
| **Severity (Raw)** | Medium |

### Screenshot / Bukti

📷 Tangkap layar output PHPCS untuk file `PKPPageRouter.inc.php` yang menampilkan tiga baris ERROR `No file extension has been found` di baris 203, 205, 206.

### Catatan

Statement `include`/`require` tanpa ekstensi file berarti PHPCS tidak dapat mengikuti dan menganalisis file yang diinclude. Ini menciptakan blind spot dalam analisis keamanan statis. Dalam kasus router seperti `PKPPageRouter.inc.php`, include dinamis bisa menjadi vektor untuk Local File Inclusion (LFI) jika parameter include dapat dimanipulasi.

---

## Temuan #8

| Field | Nilai |
|---|---|
| **Nama Kerentanan** | Potensi SQL Injection — Direct Variable Usage di Query Builder (`PKPEmailTemplateQueryBuilder`) |
| **Tool Penemu** | SAST |
| **Tool Spesifik** | PHP_CodeSniffer (phpcs) |
| **URL / File** | `ojs-src/lib/pkp/classes/services/queryBuilders/PKPEmailTemplateQueryBuilder.inc.php` |
| **Parameter / Baris Kode** | Baris 291, 299–301, 306, 308, 346–347, 367–368, 398–400, 422–423, 438–439 (25 warning) |
| **Method** | - |
| **Payload** | SQL injection payload pada parameter query email template |
| **Response / Bukti** | `WARNING \| Potential SQL injection with direct variable usage in where/leftJoin with param #1` — 25 warning di file ini saja |
| **OWASP Category** | A03:2021 - Injection |
| **Severity (Raw)** | High |

### Screenshot / Bukti

📷 Tangkap layar output PHPCS untuk file `PKPEmailTemplateQueryBuilder.inc.php` yang menampilkan 25 warning SQL injection pada berbagai baris.

### Catatan

File ini adalah query builder untuk template email. Terdapat 25 indikasi penggunaan variabel langsung dalam klausa `where` dan `leftJoin` tanpa parameterisasi yang tepat. Jika variabel-variabel ini bersumber dari input pengguna, dapat terjadi SQL injection yang memungkinkan pembacaan, modifikasi, atau penghapusan data database.

---

## Temuan #9

| Field | Nilai |
|---|---|
| **Nama Kerentanan** | Potensi SQL Injection — Direct Variable Usage di Query Builder (`PKPSubmissionQueryBuilder`) |
| **Tool Penemu** | SAST |
| **Tool Spesifik** | PHP_CodeSniffer (phpcs) |
| **URL / File** | `ojs-src/lib/pkp/classes/services/queryBuilders/PKPSubmissionQueryBuilder.inc.php` |
| **Parameter / Baris Kode** | Baris 85, 263, 328, 336–340, 358, 364, 369–371, 382, 397–399 (22 warning) |
| **Method** | - |
| **Payload** | SQL injection payload pada parameter pencarian submission |
| **Response / Bukti** | `WARNING \| Potential SQL injection with direct variable usage in orderBy/leftJoin/where with param #1 atau #2` — 22 warning |
| **OWASP Category** | A03:2021 - Injection |
| **Severity (Raw)** | High |

### Screenshot / Bukti

📷 Tangkap layar output PHPCS untuk file `PKPSubmissionQueryBuilder.inc.php` yang menampilkan 22 warning SQL injection.

### Catatan

Query builder untuk submission (naskah ilmiah) adalah salah satu komponen paling kritis di OJS. Penggunaan variabel langsung di `orderBy`, `leftJoin`, dan `where` pada 22 lokasi mengindikasikan risiko SQL injection yang signifikan, terutama pada fitur pencarian, pengurutan, dan filter submission.

---

## Temuan #10

| Field | Nilai |
|---|---|
| **Nama Kerentanan** | Potensi SQL Injection — Direct Variable Usage di `IssueQueryBuilder` |
| **Tool Penemu** | SAST |
| **Tool Spesifik** | PHP_CodeSniffer (phpcs) |
| **URL / File** | `ojs-src/classes/services/queryBuilders/IssueQueryBuilder.inc.php` |
| **Parameter / Baris Kode** | Baris 82, 229, 295, 312–315 (19 warning) |
| **Method** | - |
| **Payload** | SQL injection payload pada parameter pencarian/filter issue |
| **Response / Bukti** | `WARNING \| Potential SQL injection with direct variable usage in orderBy/where with param #1 atau #2` — 19 warning |
| **OWASP Category** | A03:2021 - Injection |
| **Severity (Raw)** | High |

### Screenshot / Bukti

📷 Tangkap layar output PHPCS untuk file `IssueQueryBuilder.inc.php` yang menampilkan 19 warning SQL injection pada baris-baris terkait.

### Catatan

Query builder untuk issue (edisi jurnal) memiliki 19 indikasi SQL injection, terutama pada operasi `orderBy` dan `where`. Fitur pengurutan dan filter issue yang menggunakan parameter dari request pengguna tanpa sanitasi berpotensi dieksploitasi.

---

## Temuan #11

| Field | Nilai |
|---|---|
| **Nama Kerentanan** | Potensi SQL Injection — Direct Variable Usage di `PKPContextQueryBuilder` |
| **Tool Penemu** | SAST |
| **Tool Spesifik** | PHP_CodeSniffer (phpcs) |
| **URL / File** | `ojs-src/lib/pkp/classes/services/queryBuilders/PKPContextQueryBuilder.inc.php` |
| **Parameter / Baris Kode** | Baris 121, 126, 141, 152–155, 166–169 (19 warning) |
| **Method** | - |
| **Payload** | SQL injection payload pada parameter pencarian context/jurnal |
| **Response / Bukti** | `WARNING \| Potential SQL injection with direct variable usage in where/groupBy with param #1` — 19 warning |
| **OWASP Category** | A03:2021 - Injection |
| **Severity (Raw)** | High |

### Screenshot / Bukti

📷 Tangkap layar output PHPCS untuk file `PKPContextQueryBuilder.inc.php` yang menampilkan 19 warning SQL injection.

### Catatan

Query builder untuk context (jurnal/platform) memiliki 19 indikasi SQL injection pada klausa `where` dan `groupBy`. Data context mencakup konfigurasi seluruh jurnal, sehingga exploitasi dapat berdampak pada keseluruhan platform.

---

## Temuan #12

| Field | Nilai |
|---|---|
| **Nama Kerentanan** | Potensi SQL Injection — Direct Variable Usage di `PKPUserQueryBuilder` |
| **Tool Penemu** | SAST |
| **Tool Spesifik** | PHP_CodeSniffer (phpcs) |
| **URL / File** | `ojs-src/lib/pkp/classes/services/queryBuilders/PKPUserQueryBuilder.inc.php` |
| **Parameter / Baris Kode** | Baris 120, 521, 560–561, 621, 623, 631, 633, 678, 691, 703 (16 warning) |
| **Method** | - |
| **Payload** | SQL injection payload pada parameter pencarian user |
| **Response / Bukti** | `WARNING \| Potential SQL injection with direct variable usage in orderBy/leftJoin/where/having with param #1 atau #2` — 16 warning |
| **OWASP Category** | A03:2021 - Injection |
| **Severity (Raw)** | High |

### Screenshot / Bukti

📷 Tangkap layar output PHPCS untuk file `PKPUserQueryBuilder.inc.php` yang menampilkan 16 warning SQL injection mencakup klausa `orderBy`, `leftJoin`, `where`, dan `having`.

### Catatan

Query builder untuk data pengguna adalah target sangat sensitif. Klausa `having` yang rentan terhadap SQL injection sangat berbahaya karena dapat digunakan untuk bypass autentikasi atau mengeksfiltrasi data pengguna termasuk hash password.

---

## Temuan #13

| Field | Nilai |
|---|---|
| **Nama Kerentanan** | Potensi SQL Injection — Direct Variable Usage di `FormComponent` |
| **Tool Penemu** | SAST |
| **Tool Spesifik** | PHP_CodeSniffer (phpcs) |
| **URL / File** | `ojs-src/lib/pkp/classes/components/forms/FormComponent.inc.php` |
| **Parameter / Baris Kode** | Baris 74, 86–87, 100, 143, 242–244 (14 warning) |
| **Method** | POST |
| **Payload** | SQL injection payload melalui field form |
| **Response / Bukti** | `WARNING \| Potential SQL injection with direct variable usage in fields with param #1` — 14 warning |
| **OWASP Category** | A03:2021 - Injection |
| **Severity (Raw)** | High |

### Screenshot / Bukti

📷 Tangkap layar output PHPCS untuk file `FormComponent.inc.php` yang menampilkan 14 warning SQL injection pada klausa `fields`.

### Catatan

Komponen form adalah layer yang langsung berinteraksi dengan input pengguna. Indikasi SQL injection pada `FormComponent` berpotensi berdampak pada semua form di seluruh aplikasi OJS yang menggunakan komponen ini sebagai base class.

---

## Temuan #14

| Field | Nilai |
|---|---|
| **Nama Kerentanan** | Potensi SQL Injection — Direct Variable Usage di `PKPAuthorQueryBuilder` |
| **Tool Penemu** | SAST |
| **Tool Spesifik** | PHP_CodeSniffer (phpcs) |
| **URL / File** | `ojs-src/lib/pkp/classes/services/queryBuilders/PKPAuthorQueryBuilder.inc.php` |
| **Parameter / Baris Kode** | Baris 136–137, 141–142, 154–155, 163–164 (12 warning) |
| **Method** | - |
| **Payload** | SQL injection payload pada parameter pencarian author |
| **Response / Bukti** | `WARNING \| Potential SQL injection with direct variable usage in where with param #1` — 12 warning |
| **OWASP Category** | A03:2021 - Injection |
| **Severity (Raw)** | High |

### Screenshot / Bukti

📷 Tangkap layar output PHPCS untuk file `PKPAuthorQueryBuilder.inc.php` yang menampilkan 12 warning SQL injection.

### Catatan

Query builder untuk data penulis (author) memiliki 12 indikasi SQL injection. Data author bersifat publik namun exploitasi dapat digunakan untuk mengeksfiltrasi data sensitif dari tabel lain melalui SQL injection.

---

## Temuan #15

| Field | Nilai |
|---|---|
| **Nama Kerentanan** | Potensi SQL Injection — Direct Variable Usage di `PKPAnnouncementQueryBuilder` |
| **Tool Penemu** | SAST |
| **Tool Spesifik** | PHP_CodeSniffer (phpcs) |
| **URL / File** | `ojs-src/lib/pkp/classes/services/queryBuilders/PKPAnnouncementQueryBuilder.inc.php` |
| **Parameter / Baris Kode** | Baris 111–114 (11 warning) |
| **Method** | - |
| **Payload** | SQL injection payload pada parameter filter pengumuman |
| **Response / Bukti** | `WARNING \| Potential SQL injection with direct variable usage in where with param #1` — 11 warning |
| **OWASP Category** | A03:2021 - Injection |
| **Severity (Raw)** | Medium |

### Screenshot / Bukti

📷 Tangkap layar output PHPCS untuk file `PKPAnnouncementQueryBuilder.inc.php` yang menampilkan 11 warning SQL injection di baris 111–114.

### Catatan

Meskipun modul pengumuman bersifat publik, SQL injection pada query builder ini tetap berpotensi dimanfaatkan untuk mengeksfiltrasi data dari database melalui teknik UNION-based atau blind SQL injection.

---

## Temuan #16

| Field | Nilai |
|---|---|
| **Nama Kerentanan** | Potensi SQL Injection — Direct Variable Usage di `PKPTemplateManager` |
| **Tool Penemu** | SAST |
| **Tool Spesifik** | PHP_CodeSniffer (phpcs) |
| **URL / File** | `ojs-src/lib/pkp/classes/template/PKPTemplateManager.inc.php` |
| **Parameter / Baris Kode** | Baris 2091–2092 (klausa `join`) |
| **Method** | - |
| **Payload** | SQL injection payload melalui parameter template |
| **Response / Bukti** | `WARNING \| Potential SQL injection with direct variable usage in join with param #3` — 2 warning |
| **OWASP Category** | A03:2021 - Injection |
| **Severity (Raw)** | High |

### Screenshot / Bukti

📷 Tangkap layar output PHPCS untuk file `PKPTemplateManager.inc.php` di bagian akhir output yang menampilkan warning SQL injection di baris 2091–2092.

### Catatan

Template manager adalah komponen inti yang digunakan di seluruh aplikasi untuk merender halaman. SQL injection dalam komponen ini berpotensi berdampak luas karena dieksekusi di hampir setiap request.

---

## Temuan #17

| Field | Nilai |
|---|---|
| **Nama Kerentanan** | Potensi SQL Injection — Berbagai File Query Builder dan DAO Lainnya |
| **Tool Penemu** | SAST |
| **Tool Spesifik** | PHP_CodeSniffer (phpcs) |
| **URL / File** | `ojs-src/classes/services/queryBuilders/SubmissionQueryBuilder.inc.php` (baris 68–69), `ojs-src/classes/services/IssueService.inc.php` (baris 121), `ojs-src/classes/publication/Publication.inc.php` (baris 38), `ojs-src/lib/pkp/classes/services/PKPPublicationService.inc.php` (baris 745), `ojs-src/lib/pkp/classes/services/PKPUserService.inc.php` (baris 128), `ojs-src/lib/pkp/classes/services/PKPStatsService.inc.php` (baris 111, 179), `ojs-src/lib/pkp/classes/services/PKPSubmissionService.inc.php` (baris 143), `ojs-src/lib/pkp/classes/submission/PKPSubmissionFileDAO.inc.php` (baris 69, 197), `ojs-src/lib/pkp/classes/announcement/AnnouncementDAO.inc.php` (baris 53), `ojs-src/lib/pkp/classes/migration/upgrade/PKPv3_3_0UpgradeMigration.inc.php` (baris 204, 667), `ojs-src/classes/migration/upgrade/OJSv3_3_0UpgradeMigration.inc.php` (baris 163, 165) |
| **Parameter / Baris Kode** | Berbagai baris (lihat URL / File di atas) |
| **Method** | GET / POST |
| **Payload** | SQL injection payload pada parameter yang terkait |
| **Response / Bukti** | `WARNING \| Potential SQL injection with direct variable usage in where/orderBy/join/leftJoin/groupBy with param #1 atau #2` — Total 174 warning SQL injection di seluruh codebase |
| **OWASP Category** | A03:2021 - Injection |
| **Severity (Raw)** | High |

### Screenshot / Bukti

📷 Tangkap layar output PHPCS untuk beberapa file yang disebutkan di atas (misalnya `AnnouncementDAO.inc.php` atau `PKPSubmissionFileDAO.inc.php`) yang menampilkan warning SQL injection.

### Catatan

Total terdapat **174 warning SQL injection** yang tersebar di seluruh codebase OJS. Meskipun sebagian besar merupakan false positive (karena OJS menggunakan query builder yang sudah memiliki layer proteksi internal), jumlah yang sangat besar ini mengindikasikan pola pengkodean yang berisiko dan memerlukan audit manual menyeluruh untuk memastikan tidak ada yang benar-benar rentan.

---

## Temuan #18

| Field | Nilai |
|---|---|
| **Nama Kerentanan** | `assert()` dengan Parameter Dinamis — Potensi Code Injection |
| **Tool Penemu** | SAST |
| **Tool Spesifik** | PHP_CodeSniffer (phpcs) |
| **URL / File** | Tersebar di 100+ file — contoh paling kritis: `ojs-src/lib/pkp/classes/core/PKPRouter.inc.php` (18 warning), `ojs-src/lib/pkp/classes/i18n/PKPLocale.inc.php` (18 warning), `ojs-src/lib/pkp/classes/notification/PKPNotificationManager.inc.php` (22 warning), `ojs-src/lib/pkp/classes/metadata/MetadataDescription.inc.php` (12 warning) |
| **Parameter / Baris Kode** | Berbagai baris — pola `assert($dynamicVariable)` |
| **Method** | - |
| **Payload** | String kode PHP yang dieksekusi jika `assert()` menerima string |
| **Response / Bukti** | `WARNING \| Assert eval function assert() detected with dynamic parameter` — Total 621 warning di seluruh codebase |
| **OWASP Category** | A03:2021 - Injection |
| **Severity (Raw)** | Medium |

### Screenshot / Bukti

📷 Tangkap layar output PHPCS untuk file `PKPRouter.inc.php` yang menampilkan 18 warning `Assert eval function assert() detected with dynamic parameter`.

### Catatan

Pada PHP versi lama (< 7.0), `assert()` dapat mengeksekusi string sebagai kode PHP — perilaku yang setara dengan `eval()`. Dengan **621 warning** tersebar di 100+ file, ini merupakan risiko sistemik. Meskipun PHP modern (7.0+) mengubah perilaku `assert()`, keberadaannya yang masif tetap menunjukkan pola pengkodean yang tidak aman dan harus diganti dengan exception atau penggunaan `assert()` dengan ekspresi boolean (bukan string).

---

## Temuan #19

| Field | Nilai |
|---|---|
| **Nama Kerentanan** | Eksekusi Perintah Sistem — `exec()`, `popen()`, dan Backtick Operator |
| **Tool Penemu** | SAST |
| **Tool Spesifik** | PHP_CodeSniffer (phpcs) |
| **URL / File** | `ojs-src/lib/pkp/classes/core/PKPString.inc.php` (baris 336 — backtick), `ojs-src/lib/pkp/classes/search/SearchHelperParser.inc.php` (baris 34 — `popen()`), `ojs-src/lib/pkp/classes/file/FileArchive.inc.php` (baris 45 — `exec()`), `ojs-src/lib/pkp/classes/file/FileManager.inc.php` (baris 614 — `exec()`), `ojs-src/lib/pkp/classes/xslt/XSLTransformer.inc.php` (baris 204 — `exec()`), `ojs-src/lib/pkp/classes/plugins/PluginHelper.inc.php` (baris 62 — `exec()`), `ojs-src/lib/pkp/plugins/importexport/datacite/DataciteExportPlugin.inc.php` (baris 384 — `exec()`), `ojs-src/lib/pkp/tools/copyAccessLogFileTool.php` (baris 204 — `exec()`) |
| **Parameter / Baris Kode** | Berbagai baris — pola `exec($dynamicVar)`, `popen($dynamicVar)`, backtick dengan variabel dinamis |
| **Method** | - |
| **Payload** | OS command injection: `; cat /etc/passwd`, `& whoami`, dll. |
| **Response / Bukti** | `WARNING \| System program execution function exec() detected with dynamic parameter`, `WARNING \| System program execution function popen() detected with dynamic parameter`, `WARNING \| System execution with backticks detected with dynamic parameter` |
| **OWASP Category** | A03:2021 - Injection |
| **Severity (Raw)** | High |

### Screenshot / Bukti

📷 Tangkap layar output PHPCS untuk file `PKPString.inc.php` yang menampilkan warning backtick execution di baris 336, dan/atau file `SearchHelperParser.inc.php` yang menampilkan warning `popen()` di baris 34.

### Catatan

Penggunaan `exec()`, `popen()`, dan backtick operator dengan parameter dinamis adalah risiko OS Command Injection yang sangat serius. Jika parameter ini berasal dari input pengguna, penyerang dapat mengeksekusi perintah arbitrer di server. Kasus paling kritis adalah `PKPString.inc.php` yang menggunakan backtick operator dan `SearchHelperParser.inc.php` yang menggunakan `popen()` untuk proses parsing pencarian.

---

## Temuan #20

| Field | Nilai |
|---|---|
| **Nama Kerentanan** | `preg_replace()` dengan Potensi `/e` Modifier — Remote Code Execution |
| **Tool Penemu** | SAST |
| **Tool Spesifik** | PHP_CodeSniffer (phpcs) |
| **URL / File** | `ojs-src/lib/pkp/classes/core/PKPString.inc.php` (baris 279), `ojs-src/lib/pkp/classes/core/PKPRequest.inc.php` (baris 180), `ojs-src/lib/pkp/classes/mail/Mail.inc.php` (baris 552), `ojs-src/lib/pkp/classes/template/PKPTemplateManager.inc.php` (baris 1775, 1780), `ojs-src/docs/dev/doxygen-input-filter.php` (baris 10, 23), `ojs-src/plugins/generic/lensGalley/LensGalleyPlugin.inc.php` (baris 218) |
| **Parameter / Baris Kode** | Berbagai baris — pola `preg_replace($pattern, $replacement, $subject)` dengan variabel dinamis |
| **Method** | - |
| **Payload** | Regex pattern dengan `/e` modifier: `/pattern/e` yang mengeksekusi replacement sebagai PHP code |
| **Response / Bukti** | `WARNING \| Dynamic usage of preg_replace, please check manually for /e modifier or user input.` dan `WARNING \| Weird usage of preg_replace, please check manually for /e modifier.` |
| **OWASP Category** | A03:2021 - Injection |
| **Severity (Raw)** | High |

### Screenshot / Bukti

📷 Tangkap layar output PHPCS untuk file `PKPString.inc.php` yang menampilkan warning `Dynamic usage of preg_replace` di baris 279, dan/atau file `doxygen-input-filter.php` di baris 10 dan 23.

### Catatan

Modifier `/e` pada `preg_replace()` mengeksekusi hasil replacement sebagai kode PHP — setara dengan `eval()`. Ini sudah di-deprecated sejak PHP 5.5 dan dihapus di PHP 7.0. Jika pola regex atau string replacement dapat dikontrol penyerang, ini menjadi vektor RCE. File `doxygen-input-filter.php` menggunakan pola ini dua kali dan harus diperiksa secara mendesak.

---

## Temuan #21

| Field | Nilai |
|---|---|
| **Nama Kerentanan** | CVE-2013-4113 — Kerentanan PHP XML Parser (Heap Memory Corruption) |
| **Tool Penemu** | SAST |
| **Tool Spesifik** | PHP_CodeSniffer (phpcs) |
| **URL / File** | `ojs-src/lib/pkp/classes/xml/PKPXMLParser.inc.php` (baris 163) |
| **Parameter / Baris Kode** | Baris 163: penggunaan `xml_parse_into_struct()` |
| **Method** | GET / POST (input XML) |
| **Payload** | Crafted XML document dengan parsing depth yang sangat dalam |
| **Response / Bukti** | `WARNING \| CVE-2013-4113 ext/xml/xml.c in PHP before 5.3.27 does not properly consider parsing depth, which allows remote attackers to cause a denial of service (heap memory corruption) or possibly have unspecified other impact via a crafted document that is processed by the xml_parse_into_struct function.` |
| **OWASP Category** | A06:2021 - Vulnerable and Outdated Components |
| **Severity (Raw)** | Medium |

### Screenshot / Bukti

📷 Tangkap layar output PHPCS untuk file `PKPXMLParser.inc.php` yang menampilkan warning CVE-2013-4113 di baris 163.

### Catatan

PHPCS menandai penggunaan `xml_parse_into_struct()` yang terkait dengan CVE-2013-4113. Meskipun kerentanan ini sudah di-patch di PHP 5.3.27, penandaan ini mengingatkan bahwa parser XML OJS berpotensi rentan terhadap Denial of Service melalui XML yang dirancang khusus (XML bomb / deeply nested XML). Perlu verifikasi versi PHP yang digunakan dan apakah ada validasi terhadap kompleksitas/depth dokumen XML yang diterima.

---

## Temuan #22

| Field | Nilai |
|---|---|
| **Nama Kerentanan** | Bad CORS Header — Konfigurasi Cross-Origin Tidak Aman |
| **Tool Penemu** | SAST |
| **Tool Spesifik** | PHP_CodeSniffer (phpcs) |
| **URL / File** | `ojs-src/lib/pkp/classes/handler/APIHandler.inc.php` (baris 131) |
| **Parameter / Baris Kode** | Baris 131: pengaturan header CORS |
| **Method** | - |
| **Payload** | Cross-origin request dari domain berbahaya |
| **Response / Bukti** | `WARNING \| Bad CORS header detected.` |
| **OWASP Category** | A05:2021 - Security Misconfiguration |
| **Severity (Raw)** | Medium |

### Screenshot / Bukti

📷 Tangkap layar output PHPCS untuk file `APIHandler.inc.php` yang menampilkan `WARNING | Bad CORS header detected.` di baris 131.

### Catatan

Konfigurasi CORS yang tidak tepat pada API handler dapat memungkinkan website berbahaya melakukan request lintas-origin ke API OJS menggunakan kredensial pengguna yang sudah login (cookie sesi). Ini dapat berujung pada pencurian data atau tindakan tidak sah atas nama pengguna.

---

## Temuan #23

| Field | Nilai |
|---|---|
| **Nama Kerentanan** | `phpinfo()` Terekspos di Panel Admin |
| **Tool Penemu** | SAST |
| **Tool Spesifik** | PHP_CodeSniffer (phpcs) |
| **URL / File** | `ojs-src/lib/pkp/pages/admin/AdminHandler.inc.php` (baris 374, 375) |
| **Parameter / Baris Kode** | Baris 374–375: `phpinfo()` |
| **Method** | GET |
| **Payload** | - |
| **Response / Bukti** | `WARNING \| phpinfo() function detected` — dua kali di halaman admin |
| **OWASP Category** | A05:2021 - Security Misconfiguration |
| **Severity (Raw)** | Medium |

### Screenshot / Bukti

📷 Tangkap layar output PHPCS untuk file `AdminHandler.inc.php` yang menampilkan dua warning `phpinfo() function detected` di baris 374 dan 375.

### Catatan

Fungsi `phpinfo()` menampilkan informasi lengkap tentang konfigurasi PHP server termasuk ekstensi yang aktif, versi PHP, direktori instalasi, environment variables, dan konfigurasi keamanan. Meskipun berada di panel admin (yang seharusnya memerlukan autentikasi), keberadaannya tetap berbahaya jika admin panel dapat diakses atau jika ada bypass autentikasi.

---

## Temuan #24

| Field | Nilai |
|---|---|
| **Nama Kerentanan** | Penggunaan `call_user_func()` dan `call_user_func_array()` dengan Parameter Dinamis |
| **Tool Penemu** | SAST |
| **Tool Spesifik** | PHP_CodeSniffer (phpcs) |
| **URL / File** | `ojs-src/lib/pkp/classes/install/Installer.inc.php` (baris 203, 442, 444), `ojs-src/lib/pkp/classes/core/PKPPageRouter.inc.php` (baris 182, 478), `ojs-src/lib/pkp/classes/core/PKPRequest.inc.php` (baris 760), `ojs-src/lib/pkp/classes/core/PKPRouter.inc.php` (baris 395), `ojs-src/lib/pkp/classes/cache/GenericCache.inc.php` (baris 63), `ojs-src/lib/pkp/classes/controllers/listbuilder/ListbuilderHandler.inc.php` (baris 243, 280, 282), `ojs-src/lib/pkp/classes/form/Form.inc.php` (baris 259, 260) |
| **Parameter / Baris Kode** | Berbagai baris — pola `call_user_func($dynamicCallback, ...)` |
| **Method** | - |
| **Payload** | Injeksi callback berbahaya jika parameter callable dapat dikontrol penyerang |
| **Response / Bukti** | `WARNING \| Function handling function call_user_func() detected with dynamic parameter` dan `WARNING \| Function call_user_func() that supports callback detected` |
| **OWASP Category** | A03:2021 - Injection |
| **Severity (Raw)** | Medium |

### Screenshot / Bukti

📷 Tangkap layar output PHPCS untuk file `Installer.inc.php` yang menampilkan warning `call_user_func() detected with dynamic parameter` di baris 203, 442, 444.

### Catatan

`call_user_func()` dan `call_user_func_array()` memanggil fungsi atau metode secara dinamis. Jika nama fungsi yang dipanggil dapat dipengaruhi oleh input pengguna (misalnya melalui parameter request atau data yang tersimpan di database), penyerang dapat melakukan arbitrary function call yang berpotensi mengarah ke RCE. Komponen paling kritis adalah `PKPPageRouter` yang menggunakan ini untuk routing request HTTP.

---

## Temuan #25

| Field | Nilai |
|---|---|
| **Nama Kerentanan** | Operasi Filesystem dengan Parameter Dinamis — Tersebar di Seluruh Codebase |
| **Tool Penemu** | SAST |
| **Tool Spesifik** | PHP_CodeSniffer (phpcs) |
| **URL / File** | File paling kritis: `ojs-src/lib/pkp/classes/file/FileManager.inc.php` (38 warning termasuk `fopen`, `fwrite`, `unlink`, `rmdir`, `mkdir`, `chmod`), `ojs-src/lib/pkp/classes/config/ConfigParser.inc.php` (19 warning termasuk `fopen`, `fwrite`, `fclose`), `ojs-src/lib/pkp/classes/core/Dispatcher.inc.php` (14 warning termasuk `fopen`, `fread`, `fwrite`), `ojs-src/plugins/generic/usageStats/UsageStatsPlugin.inc.php` (29 warning termasuk berbagai operasi file) |
| **Parameter / Baris Kode** | Berbagai baris — pola `fopen($dynamicPath)`, `unlink($dynamicPath)`, `chmod($dynamicPath)` |
| **Method** | POST / GET |
| **Payload** | Path traversal: `../../../../etc/passwd`, `../config.inc.php` |
| **Response / Bukti** | Ratusan warning `Filesystem function [nama_fungsi]() detected with dynamic parameter` — tersebar di 200+ file |
| **OWASP Category** | A01:2021 - Broken Access Control |
| **Severity (Raw)** | Medium |

### Screenshot / Bukti

📷 Tangkap layar output PHPCS untuk file `FileManager.inc.php` yang menampilkan 38 warning operasi filesystem dengan parameter dinamis.

### Catatan

Penggunaan fungsi filesystem dengan parameter dinamis secara masif (fopen, fwrite, unlink, chmod, mkdir, rmdir, dll.) menunjukkan pola pengkodean yang berpotensi rentan terhadap Path Traversal jika parameter tersebut berasal dari atau dapat dipengaruhi oleh input pengguna. Kasus paling kritis adalah `FileManager.inc.php` yang merupakan komponen utama manajemen file di OJS.

---

## Temuan #26

| Field | Nilai |
|---|---|
| **Nama Kerentanan** | Short Open Tags (`<?`) Tidak Terdeteksi — Potensi Blind Spot Analisis |
| **Tool Penemu** | SAST |
| **Tool Spesifik** | PHP_CodeSniffer (phpcs) |
| **URL / File** | `ojs-src/lib/pkp/tests/classes/core/config/config.request1.inc.php` (baris 1), `ojs-src/lib/pkp/tests/classes/core/config/config.request2.inc.php` (baris 1), `ojs-src/lib/pkp/tests/config/config.TEMPLATE.mysql.inc.php` (baris 1), `ojs-src/lib/pkp/tests/config/config.TEMPLATE.pgsql.inc.php` (baris 1) |
| **Parameter / Baris Kode** | Baris 1 setiap file |
| **Method** | - |
| **Payload** | - |
| **Response / Bukti** | `WARNING \| No PHP code was found in this file and short open tags are not allowed by this install of PHP. This file may be using short open tags but PHP does not allow them.` |
| **OWASP Category** | A05:2021 - Security Misconfiguration |
| **Severity (Raw)** | Info |

### Screenshot / Bukti

📷 Tangkap layar output PHPCS untuk file `config.request1.inc.php` yang menampilkan warning terkait short open tags di baris 1.

### Catatan

File-file konfigurasi ini menggunakan short open tags (`<?`) alih-alih tag PHP standar (`<?php`). Ini menyebabkan PHPCS tidak dapat menganalisis isi file sama sekali, menciptakan blind spot dalam analisis. Selain itu, short open tags tidak selalu aktif di semua konfigurasi PHP, yang dapat menyebabkan file konfigurasi di-serve sebagai plaintext oleh web server, mengekspos konfigurasi sensitif.

---

# BAGIAN 2 — SEMGREP

---

## Temuan #27

| Field | Nilai |
|---|---|
| **Nama Kerentanan** | Ruleset Semgrep `p/injection` Gagal Diunduh — Scan Injection Level Kode Tidak Berjalan |
| **Tool Penemu** | SAST |
| **Tool Spesifik** | Semgrep v1.157.0 (`semgrep_injection.json`) |
| **URL / File** | `https://semgrep.dev/c/p/injection` |
| **Parameter / Baris Kode** | - |
| **Method** | - |
| **Payload** | - |
| **Response / Bukti** | `[ERROR] Failed to download configuration from https://semgrep.dev/c/p/injection HTTP 404` dan `invalid configuration file found (1 configs were invalid)` — 0 file dipindai, scan tidak berjalan sama sekali |
| **OWASP Category** | A03:2021 - Injection (gagal diuji) |
| **Severity (Raw)** | Info |

### Screenshot / Bukti

📷 Tangkap layar terminal yang menampilkan output perintah semgrep dengan ruleset `p/injection`, atau tampilkan isi file `semgrep_injection.json` yang menunjukkan pesan error HTTP 404.

### Catatan

Scan dengan ruleset `p/injection` gagal total karena konfigurasi tidak dapat diunduh (HTTP 404). Seluruh source code OJS tidak diuji untuk kerentanan injection pada level kode sumber oleh ruleset ini. Perlu diganti dengan ruleset valid seperti `p/php` atau custom rules lokal.

---

## Temuan #28

| Field | Nilai |
|---|---|
| **Nama Kerentanan** | PartialParsing Error — 10 File Template Smarty (`.tpl`) Tidak Dapat Dianalisis |
| **Tool Penemu** | SAST |
| **Tool Spesifik** | Semgrep v1.157.0 (`semgrep_custom.json`) |
| **URL / File** | `ojs-src/plugins/generic/announcementFeed/templates/atom.tpl` (baris 11), `ojs-src/plugins/generic/announcementFeed/templates/rss.tpl` (baris 11), `ojs-src/plugins/generic/announcementFeed/templates/rss2.tpl` (baris 11), `ojs-src/plugins/generic/webFeed/templates/atom.tpl` (baris 11), `ojs-src/plugins/generic/webFeed/templates/rss.tpl` (baris 11), `ojs-src/plugins/generic/webFeed/templates/rss2.tpl` (baris 11), `ojs-src/plugins/reports/counter/templates/reportxml.tpl` (baris 11), `ojs-src/plugins/reports/counter/templates/soaperror.tpl` (baris 10), `ojs-src/plugins/reports/counter/templates/sushixml.tpl` (baris 10), `ojs-src/templates/payments/openAccessNotifyEmail.tpl` (baris 32) |
| **Parameter / Baris Kode** | Baris 10–11 setiap file: deklarasi `<?xml version="1.0" encoding=...?>` |
| **Method** | - |
| **Payload** | - |
| **Response / Bukti** | `[WARN] PartialParsing: Syntax error at line ...: xml version="1.0" encoding= was unexpected` — 10 file tidak berhasil diparse dan tidak teranalisis |
| **OWASP Category** | A03:2021 - Injection (gagal diuji) |
| **Severity (Raw)** | Info |

### Screenshot / Bukti

📷 Tangkap layar bagian `errors` dari file `semgrep_custom.json` yang menampilkan daftar 10 file `.tpl` dengan error PartialParsing.

### Catatan

Semgrep tidak dapat mem-parse file Smarty template yang mengandung deklarasi XML di baris awal. Semua file ini berpotensi mengandung output variabel yang tidak di-escape (XSS atau XML injection) namun tidak terdeteksi oleh SAST. File `openAccessNotifyEmail.tpl` paling kritis karena merupakan template email pembayaran yang memproses data transaksi pengguna. Review manual diperlukan untuk semua file ini.

---

## Temuan #29

| Field | Nilai |
|---|---|
| **Nama Kerentanan** | PartialParsing Error — Shell Script `startSubmodulesTRAVIS.sh` Tidak Dapat Dianalisis |
| **Tool Penemu** | SAST |
| **Tool Spesifik** | Semgrep v1.157.0 (`semgrep_owasp.json`) |
| **URL / File** | `ojs-src/tools/startSubmodulesTRAVIS.sh` |
| **Parameter / Baris Kode** | Baris 2–43 (keseluruhan file) |
| **Method** | - |
| **Payload** | - |
| **Response / Bukti** | `[WARN] PartialParsing: Syntax error at line ojs-src/tools/startSubmodulesTRAVIS.sh:2` — File mengandung `git config --global user.email "pkp@mailinator.com"` yang di-hardcode. Scan OWASP: 0 file dipindai. |
| **OWASP Category** | A05:2021 - Security Misconfiguration |
| **Severity (Raw)** | Info |

### Screenshot / Bukti

📷 Tangkap layar bagian `errors` dari file `semgrep_owasp.json` yang menampilkan entry PartialParsing untuk file `startSubmodulesTRAVIS.sh`.

### Catatan

File shell script CI/CD tidak dapat dianalisis. File mengandung credential git yang di-hardcode dan pola variabel shell dari output git tanpa sanitasi, berpotensi rentan terhadap command injection dalam pipeline CI.

---

## Temuan #30

| Field | Nilai |
|---|---|
| **Nama Kerentanan** | Ruleset `semgrep_php` Tidak Memindai File Apapun — Cakupan Scan Kosong |
| **Tool Penemu** | SAST |
| **Tool Spesifik** | Semgrep v1.157.0 (`semgrep_php.json`) |
| **URL / File** | `ojs-src/` (seluruh direktori target) |
| **Parameter / Baris Kode** | - |
| **Method** | - |
| **Payload** | - |
| **Response / Bukti** | `results: 0, errors: 0` dengan `paths.scanned: []` (array kosong) — 0 file dipindai meskipun tidak ada error |
| **OWASP Category** | A05:2021 - Security Misconfiguration (dari sisi proses DevSecOps) |
| **Severity (Raw)** | Info |

### Screenshot / Bukti

📷 Tangkap layar isi file `semgrep_php.json` yang menunjukkan `"scanned": []` pada bagian `paths` dan `"results": []`.

### Catatan

Ruleset PHP Semgrep tidak memindai file apapun akibat kemungkinan kesalahan konfigurasi perintah scan (path target tidak ditentukan atau tidak cocok). Seluruh 482+ file PHP OJS tidak mendapatkan analisis dari ruleset ini, sehingga kerentanan PHP spesifik tidak terdeteksi oleh Semgrep.
