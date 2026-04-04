# BAGIAN 1: TEMUAN NIKTO

## Temuan #1

| Field | Nilai |
|---|---|
| Nama Kerentanan | Missing X-Frame-Options Header (Anti-Clickjacking) |
| Tool Penemu | DAST |
| Tool Spesifik | Nikto v2.1.5 |
| URL / File | http://10.34.100.181/ojs/ojs/ |
| Parameter / Baris Kode | - |
| Method | GET |
| Payload | - |
| Response / Bukti | Header X-Frame-Options tidak ditemukan dalam HTTP response dari endpoint /ojs/ojs/ |
| OWASP Category | A05:2021 - Security Misconfiguration |
| Severity (Raw) | Medium |

### Screenshot / Bukti
📷 Screenshot yang harus dilampirkan: Tangkap layar response header HTTP dari browser DevTools (F12 > Network > pilih request ke /ojs/ojs/ > tab Headers) yang menunjukkan TIDAK adanya header X-Frame-Options.

### Catatan
Tanpa header X-Frame-Options, halaman dapat di-embed dalam iframe oleh situs pihak ketiga. Hal ini memungkinkan serangan clickjacking di mana pengguna dapat ditipu untuk mengklik elemen tersembunyi.

---

## Temuan #2

| Field | Nilai |
|---|---|
| Nama Kerentanan | Cookie OJSSID Tanpa Flag HttpOnly |
| Tool Penemu | DAST |
| Tool Spesifik | Nikto v2.1.5 |
| URL / File | http://10.34.100.181/ojs/ojs/ |
| Parameter / Baris Kode | Cookie: OJSSID |
| Method | GET |
| Payload | - |
| Response / Bukti | Set-Cookie: OJSSID=... (tanpa atribut HttpOnly) |
| OWASP Category | A02:2021 - Cryptographic Failures / A07:2021 - Identification and Authentication Failures |
| Severity (Raw) | Low |

### Screenshot / Bukti
📷 Screenshot yang harus dilampirkan: Tangkap layar dari browser DevTools (F12 > Application > Cookies atau F12 > Network > response header Set-Cookie) yang menunjukkan cookie OJSSID tanpa flag HttpOnly.

### Catatan
Cookie sesi tanpa flag HttpOnly dapat diakses oleh JavaScript. Jika terdapat celah XSS pada aplikasi, penyerang dapat mencuri cookie sesi dan melakukan session hijacking.

---

## Temuan #3

| Field | Nilai |
|---|---|
| Nama Kerentanan | Server Leaks Inode via ETags Header |
| Tool Penemu | DAST |
| Tool Spesifik | Nikto v2.1.5 |
| URL / File | http://10.34.100.181/ojs/robots.txt |
| Parameter / Baris Kode | ETag: 0x20 0x5cadc3ba77780 |
| Method | GET |
| Payload | - |
| Response / Bukti | Header ETag mengekspos informasi inode server: fields 0x20 0x5cadc3ba77780 |
| OWASP Category | A05:2021 - Security Misconfiguration |
| Severity (Raw) | Low |

### Screenshot / Bukti
📷 Screenshot yang harus dilampirkan: Tangkap layar response header dari request ke /ojs/robots.txt (browser DevTools > Network > Headers) yang menampilkan nilai ETag berisi informasi inode server.

### Catatan
ETag berbasis inode dapat mengungkap informasi sistem file internal server. Informasi ini dapat dimanfaatkan penyerang untuk fingerprinting dan pemetaan struktur server.

---

## Temuan #4

| Field | Nilai |
|---|---|
| Nama Kerentanan | Directory Indexing Terbuka - /ojs/cache/ |
| Tool Penemu | DAST |
| Tool Spesifik | Nikto v2.1.5 (OSVDB-3268) |
| URL / File | http://10.34.100.181/ojs/ojs/cache/ |
| Parameter / Baris Kode | - |
| Method | GET |
| Payload | - |
| Response / Bukti | HTTP 200 OK - Server menampilkan daftar file/direktori di /ojs/cache/ |
| OWASP Category | A05:2021 - Security Misconfiguration |
| Severity (Raw) | Medium |

### Screenshot / Bukti
📷 Screenshot yang harus dilampirkan: Tangkap layar halaman browser yang menampilkan directory listing saat mengakses http://10.34.100.181/ojs/ojs/cache/ (terlihat daftar file/folder terbuka).

### Catatan
Directory indexing yang aktif memungkinkan penyerang melihat seluruh isi direktori cache, berpotensi mengekspos file sensitif, data sesi, atau konfigurasi yang tersimpan di cache.

---

## Temuan #5

| Field | Nilai |
|---|---|
| Nama Kerentanan | Direktori /cache/ Dapat Diakses (robots.txt Bypass) |
| Tool Penemu | DAST |
| Tool Spesifik | Nikto v2.1.5 |
| URL / File | http://10.34.100.181/ojs//cache/ |
| Parameter / Baris Kode | - |
| Method | GET |
| Payload | - |
| Response / Bukti | File/dir '/cache/' dalam robots.txt mengembalikan HTTP 200 (bukan 403/redirect) |
| OWASP Category | A05:2021 - Security Misconfiguration |
| Severity (Raw) | Low |

### Screenshot / Bukti
📷 Screenshot yang harus dilampirkan: Tangkap layar response HTTP 200 saat mengakses http://10.34.100.181/ojs//cache/ - tunjukkan status code 200 di DevTools Network tab.

### Catatan
Direktori yang dimasukkan dalam robots.txt seharusnya dilindungi dengan kontrol akses yang tepat (403 Forbidden), bukan hanya mengandalkan robots.txt sebagai satu-satunya penghalang.

---

## Temuan #6

| Field | Nilai |
|---|---|
| Nama Kerentanan | File robots.txt Mengekspos Informasi Direktori Sensitif |
| Tool Penemu | DAST |
| Tool Spesifik | Nikto v2.1.5 |
| URL / File | http://10.34.100.181/ojs/robots.txt |
| Parameter / Baris Kode | - |
| Method | GET |
| Payload | - |
| Response / Bukti | robots.txt berisi 1 entri yang mengekspos path direktori internal aplikasi |
| OWASP Category | A01:2021 - Broken Access Control |
| Severity (Raw) | Info |

### Screenshot / Bukti
📷 Screenshot yang harus dilampirkan: Tangkap layar isi file robots.txt saat diakses melalui browser (http://10.34.100.181/ojs/robots.txt) yang menampilkan direktori yang di-Disallow.

### Catatan
robots.txt bersifat publik dan dapat dibaca siapapun. Entri Disallow di dalamnya justru memberikan petunjuk kepada penyerang mengenai direktori yang dianggap sensitif.

---

## Temuan #7

| Field | Nilai |
|---|---|
| Nama Kerentanan | HTTP Methods Berbahaya Diizinkan (OPTIONS) |
| Tool Penemu | DAST |
| Tool Spesifik | Nikto v2.1.5 |
| URL / File | http://10.34.100.181/ojs/ |
| Parameter / Baris Kode | Allow: OPTIONS, HEAD, GET, POST |
| Method | OPTIONS |
| Payload | - |
| Response / Bukti | Response header Allow menunjukkan metode OPTIONS, HEAD, GET, POST diizinkan |
| OWASP Category | A05:2021 - Security Misconfiguration |
| Severity (Raw) | Info |

### Screenshot / Bukti
📷 Screenshot yang harus dilampirkan: Tangkap layar hasil request OPTIONS ke http://10.34.100.181/ojs/ menggunakan Burp Suite atau curl (tampilkan header Allow dalam response).

### Catatan
Metode OPTIONS dapat digunakan penyerang untuk melakukan fingerprinting terhadap kemampuan server. Sebaiknya dibatasi hanya untuk metode yang benar-benar dibutuhkan.

---

## Temuan #8

| Field | Nilai |
|---|---|
| Nama Kerentanan | HTTP DEBUG Method Aktif |
| Tool Penemu | DAST |
| Tool Spesifik | Nikto v2.1.5 |
| URL / File | http://10.34.100.181/ojsHASH(0x5bd5718ac7c0) |
| Parameter / Baris Kode | - |
| Method | DEBUG |
| Payload | - |
| Response / Bukti | Server merespons method DEBUG - berpotensi mengekspos informasi debugging |
| OWASP Category | A05:2021 - Security Misconfiguration |
| Severity (Raw) | Medium |

### Screenshot / Bukti
📷 Screenshot yang harus dilampirkan: Tangkap layar response dari request DEBUG menggunakan Burp Suite atau curl terhadap endpoint yang ditemukan Nikto, tampilkan status code dan response body.

### Catatan
HTTP DEBUG method dapat mengekspos informasi sensitif server seperti variabel lingkungan, path internal, dan informasi debugging lainnya yang tidak seharusnya terlihat oleh publik.

---

## Temuan #9

| Field | Nilai |
|---|---|
| Nama Kerentanan | HTTP TRACK Method Aktif - Rentan XST (Cross-Site Tracing) |
| Tool Penemu | DAST |
| Tool Spesifik | Nikto v2.1.5 (OSVDB-877) |
| URL / File | http://10.34.100.181/ojs/ |
| Parameter / Baris Kode | - |
| Method | TRACK |
| Payload | - |
| Response / Bukti | Server merespons method TRACK, mengindikasikan kerentanan XST (Cross-Site Tracing) |
| OWASP Category | A05:2021 - Security Misconfiguration |
| Severity (Raw) | Medium |

### Screenshot / Bukti
📷 Screenshot yang harus dilampirkan: Tangkap layar response dari request TRACK ke http://10.34.100.181/ojs/ menggunakan Burp Suite (tunjukkan bahwa server merespons method TRACK dengan HTTP 200).

### Catatan
TRACK method memungkinkan penyerang melakukan Cross-Site Tracing (XST) yang dapat digunakan untuk mencuri cookie HttpOnly atau header Authorization melalui JavaScript.

---

## Temuan #10

| Field | Nilai |
|---|---|
| Nama Kerentanan | Directory Indexing Terbuka - /ojs/lib/ |
| Tool Penemu | DAST |
| Tool Spesifik | Nikto v2.1.5 (OSVDB-3268) |
| URL / File | http://10.34.100.181/ojs/ojs/lib/ |
| Parameter / Baris Kode | - |
| Method | GET |
| Payload | - |
| Response / Bukti | HTTP 200 - Directory listing aktif di /ojs/lib/ |
| OWASP Category | A05:2021 - Security Misconfiguration |
| Severity (Raw) | Medium |

### Screenshot / Bukti
📷 Screenshot yang harus dilampirkan: Tangkap layar halaman browser yang menampilkan directory listing di http://10.34.100.181/ojs/ojs/lib/

### Catatan
Direktori lib/ biasanya berisi library dan dependensi aplikasi. Mengeksposnya secara publik memungkinkan penyerang mengetahui versi library yang digunakan dan menargetkan kerentanan spesifik.

---

## Temuan #11

| Field | Nilai |
|---|---|
| Nama Kerentanan | Directory Indexing Terbuka - /ojs/pages/ |
| Tool Penemu | DAST |
| Tool Spesifik | Nikto v2.1.5 (OSVDB-3268) |
| URL / File | http://10.34.100.181/ojs/ojs/pages/ |
| Parameter / Baris Kode | - |
| Method | GET |
| Payload | - |
| Response / Bukti | HTTP 200 - Directory listing aktif di /ojs/pages/ |
| OWASP Category | A05:2021 - Security Misconfiguration |
| Severity (Raw) | Medium |

### Screenshot / Bukti
📷 Screenshot yang harus dilampirkan: Tangkap layar halaman browser yang menampilkan directory listing di http://10.34.100.181/ojs/ojs/pages/

### Catatan
Direktori pages/ mengekspos struktur halaman dan controller aplikasi. Penyerang dapat memetakan endpoint tersembunyi atau tidak terdokumentasi dari aplikasi.

---

## Temuan #12

| Field | Nilai |
|---|---|
| Nama Kerentanan | Direktori /ojs/public/ Dapat Diakses |
| Tool Penemu | DAST |
| Tool Spesifik | Nikto v2.1.5 |
| URL / File | http://10.34.100.181/ojs/ojs/public/ |
| Parameter / Baris Kode | - |
| Method | GET |
| Payload | - |
| Response / Bukti | HTTP 200 - Direktori /ojs/public/ dapat diakses dan berpotensi menarik perhatian penyerang |
| OWASP Category | A05:2021 - Security Misconfiguration |
| Severity (Raw) | Info |

### Screenshot / Bukti
📷 Screenshot yang harus dilampirkan: Tangkap layar saat mengakses http://10.34.100.181/ojs/ojs/public/ melalui browser (tampilkan response/halaman yang muncul).

### Catatan
Meskipun direktori public/ memang dimaksudkan untuk file publik, perlu diverifikasi tidak ada file sensitif yang tidak sengaja tersimpan di sini.

---

## Temuan #13

| Field | Nilai |
|---|---|
| Nama Kerentanan | Directory Indexing Terbuka - /ojs/tools/ |
| Tool Penemu | DAST |
| Tool Spesifik | Nikto v2.1.5 (OSVDB-3268) |
| URL / File | http://10.34.100.181/ojs/ojs/tools/ |
| Parameter / Baris Kode | - |
| Method | GET |
| Payload | - |
| Response / Bukti | HTTP 200 - Directory listing aktif di /ojs/tools/ |
| OWASP Category | A05:2021 - Security Misconfiguration |
| Severity (Raw) | Medium |

### Screenshot / Bukti
📷 Screenshot yang harus dilampirkan: Tangkap layar halaman browser yang menampilkan directory listing di http://10.34.100.181/ojs/ojs/tools/

### Catatan
Direktori tools/ kemungkinan berisi skrip administrasi atau alat utilitas yang tidak seharusnya dapat diakses publik.

---

## Temuan #14

| Field | Nilai |
|---|---|
| Nama Kerentanan | Directory Indexing Terbuka - /ojs/docs/ |
| Tool Penemu | DAST |
| Tool Spesifik | Nikto v2.1.5 (OSVDB-3268) |
| URL / File | http://10.34.100.181/ojs/ojs/docs/ |
| Parameter / Baris Kode | - |
| Method | GET |
| Payload | - |
| Response / Bukti | HTTP 200 - Directory listing aktif di /ojs/docs/ |
| OWASP Category | A05:2021 - Security Misconfiguration |
| Severity (Raw) | Medium |

### Screenshot / Bukti
📷 Screenshot yang harus dilampirkan: Tangkap layar halaman browser yang menampilkan directory listing di http://10.34.100.181/ojs/ojs/docs/

### Catatan
Direktori docs/ dapat mengekspos dokumentasi teknis internal, changelog, atau panduan instalasi yang berisi informasi versi dan konfigurasi sensitif.

---

## Temuan #15

| Field | Nilai |
|---|---|
| Nama Kerentanan | Directory Indexing Terbuka - /ojs/styles/ |
| Tool Penemu | DAST |
| Tool Spesifik | Nikto v2.1.5 (OSVDB-3268) |
| URL / File | http://10.34.100.181/ojs/ojs/styles/ |
| Parameter / Baris Kode | - |
| Method | GET |
| Payload | - |
| Response / Bukti | HTTP 200 - Directory listing aktif di /ojs/styles/ |
| OWASP Category | A05:2021 - Security Misconfiguration |
| Severity (Raw) | Low |

### Screenshot / Bukti
📷 Screenshot yang harus dilampirkan: Tangkap layar halaman browser yang menampilkan directory listing di http://10.34.100.181/ojs/ojs/styles/

### Catatan
Meskipun direktori styles/ umumnya berisi CSS, directory listing tetap mengekspos struktur aplikasi dan harus dinonaktifkan.

---

# BAGIAN 2: TEMUAN ZAP (OWASP ZAP v2.17.0)

## Temuan #16

| Field | Nilai |
|---|---|
| Nama Kerentanan | Content Security Policy (CSP) Header Not Set |
| Tool Penemu | DAST |
| Tool Spesifik | OWASP ZAP v2.17.0 (Plugin ID: 10038) |
| URL / File | http://10.34.100.181/ | http://10.34.100.181/manual | http://10.34.100.181/ojs/ | http://10.34.100.181/robots.txt | http://10.34.100.181/sitemap.xml |
| Parameter / Baris Kode | - |
| Method | GET |
| Payload | - |
| Response / Bukti | Header Content-Security-Policy tidak ditemukan dalam HTTP response (5 endpoint terdampak) |
| OWASP Category | A05:2021 - Security Misconfiguration |
| Severity (Raw) | Medium |

### Screenshot / Bukti
📷 Screenshot yang harus dilampirkan: Tangkap layar alert CSP dari ZAP GUI atau laporan ZAP HTML yang menunjukkan temuan ini, serta response header dari salah satu URL yang terdampak tanpa header Content-Security-Policy.

### Catatan
Tanpa CSP, browser tidak memiliki petunjuk dari server tentang sumber konten mana yang boleh dimuat. Ini meningkatkan risiko serangan XSS dan data injection.

---

## Temuan #17

| Field | Nilai |
|---|---|
| Nama Kerentanan | HTTP Only Site (Tidak Menggunakan HTTPS) |
| Tool Penemu | DAST |
| Tool Spesifik | OWASP ZAP v2.17.0 (Plugin ID: 10106) |
| URL / File | http://10.34.100.181/ojs/ |
| Parameter / Baris Kode | - |
| Method | GET |
| Payload | - |
| Response / Bukti | Koneksi HTTPS gagal (ZAP attempted to connect via https://10.34.100.181/ojs/ - Failed to connect). Situs hanya melayani HTTP. |
| OWASP Category | A02:2021 - Cryptographic Failures |
| Severity (Raw) | Medium |

### Screenshot / Bukti
📷 Screenshot yang harus dilampirkan: Tangkap layar browser yang menampilkan pesan 'Not Secure' atau koneksi tanpa gembok di address bar saat mengakses http://10.34.100.181/ojs/, serta alert ZAP untuk temuan ini.

### Catatan
Seluruh komunikasi antara client dan server dikirim dalam plaintext tanpa enkripsi, memungkinkan serangan man-in-the-middle untuk menyadap kredensial dan data sesi.

---

## Temuan #18

| Field | Nilai |
|---|---|
| Nama Kerentanan | Missing Anti-clickjacking Header (X-Frame-Options) |
| Tool Penemu | DAST |
| Tool Spesifik | OWASP ZAP v2.17.0 (Plugin ID: 10020, CWE-1021) |
| URL / File | http://10.34.100.181/ | http://10.34.100.181/ojs/ |
| Parameter / Baris Kode | x-frame-options |
| Method | GET |
| Payload | - |
| Response / Bukti | Response tidak mengandung header X-Frame-Options maupun CSP frame-ancestors directive (2 endpoint terdampak) |
| OWASP Category | A05:2021 - Security Misconfiguration |
| Severity (Raw) | Medium |

### Screenshot / Bukti
📷 Screenshot yang harus dilampirkan: Tangkap layar alert ZAP untuk Missing Anti-clickjacking Header dan response header dari DevTools yang tidak menampilkan X-Frame-Options.

### Catatan
Dikonfirmasi juga oleh Nikto (Temuan #1). Ketiadaan header ini pada dua endpoint utama meningkatkan risiko clickjacking secara signifikan.

---

## Temuan #19

| Field | Nilai |
|---|---|
| Nama Kerentanan | Cookie No HttpOnly Flag |
| Tool Penemu | DAST |
| Tool Spesifik | OWASP ZAP v2.17.0 (Plugin ID: 10010, CWE-1004) |
| URL / File | http://10.34.100.181/ojs/ |
| Parameter / Baris Kode | Cookie: OJSSID |
| Method | GET |
| Payload | - |
| Response / Bukti | Set-Cookie: OJSSID (tanpa flag HttpOnly) - Evidence: Set-Cookie: OJSSID |
| OWASP Category | A02:2021 - Cryptographic Failures |
| Severity (Raw) | Low |

### Screenshot / Bukti
📷 Screenshot yang harus dilampirkan: Tangkap layar dari DevTools > Application > Cookies yang menunjukkan OJSSID tanpa centang pada kolom HttpOnly, atau dari Network tab yang menampilkan Set-Cookie header.

### Catatan
Dikonfirmasi juga oleh Nikto (Temuan #2). ZAP mengonfirmasi bahwa cookie sesi OJSSID tidak memiliki flag HttpOnly, membuatnya rentan terhadap pencurian via JavaScript.

---

## Temuan #20

| Field | Nilai |
|---|---|
| Nama Kerentanan | Cookie Without SameSite Attribute |
| Tool Penemu | DAST |
| Tool Spesifik | OWASP ZAP v2.17.0 (Plugin ID: 10054, CWE-1275) |
| URL / File | http://10.34.100.181/ojs/ |
| Parameter / Baris Kode | Cookie: OJSSID |
| Method | GET |
| Payload | - |
| Response / Bukti | Set-Cookie: OJSSID tidak memiliki atribut SameSite - Evidence: Set-Cookie: OJSSID |
| OWASP Category | A01:2021 - Broken Access Control |
| Severity (Raw) | Low |

### Screenshot / Bukti
📷 Screenshot yang harus dilampirkan: Tangkap layar dari DevTools > Application > Cookies yang menunjukkan kolom SameSite pada cookie OJSSID kosong atau 'None', atau dari response header Set-Cookie yang tidak memiliki atribut SameSite.

### Catatan
Tanpa atribut SameSite, cookie dapat dikirimkan pada cross-site request sehingga rentan terhadap serangan CSRF (Cross-Site Request Forgery).

---

## Temuan #21

| Field | Nilai |
|---|---|
| Nama Kerentanan | Cross-Origin-Embedder-Policy (COEP) Header Missing or Invalid |
| Tool Penemu | DAST |
| Tool Spesifik | OWASP ZAP v2.17.0 (Plugin ID: 90004-2, CWE-693) |
| URL / File | http://10.34.100.181/ | http://10.34.100.181/ojs/ |
| Parameter / Baris Kode | Cross-Origin-Embedder-Policy |
| Method | GET |
| Payload | - |
| Response / Bukti | Header Cross-Origin-Embedder-Policy tidak ditemukan pada 2 endpoint |
| OWASP Category | A05:2021 - Security Misconfiguration |
| Severity (Raw) | Low |

### Screenshot / Bukti
📷 Screenshot yang harus dilampirkan: Tangkap layar response header dari DevTools yang tidak menampilkan header Cross-Origin-Embedder-Policy, beserta alert ZAP terkait.

### Catatan
Header COEP mencegah dokumen memuat resource cross-origin yang tidak memberikan izin eksplisit. Ketiadaannya meningkatkan risiko serangan side-channel seperti Spectre.

---

## Temuan #22

| Field | Nilai |
|---|---|
| Nama Kerentanan | Cross-Origin-Opener-Policy (COOP) Header Missing or Invalid |
| Tool Penemu | DAST |
| Tool Spesifik | OWASP ZAP v2.17.0 (Plugin ID: 90004-3, CWE-693) |
| URL / File | http://10.34.100.181/ | http://10.34.100.181/ojs/ |
| Parameter / Baris Kode | Cross-Origin-Opener-Policy |
| Method | GET |
| Payload | - |
| Response / Bukti | Header Cross-Origin-Opener-Policy tidak ditemukan pada 2 endpoint |
| OWASP Category | A05:2021 - Security Misconfiguration |
| Severity (Raw) | Low |

### Screenshot / Bukti
📷 Screenshot yang harus dilampirkan: Tangkap layar response header dari DevTools yang tidak menampilkan header Cross-Origin-Opener-Policy, beserta alert ZAP terkait.

### Catatan
Header COOP mengisolasi konteks browsing dari dokumen berbahaya lintas origin. Ketiadaannya berpotensi memungkinkan kebocoran data antar tab.

---

## Temuan #23

| Field | Nilai |
|---|---|
| Nama Kerentanan | Cross-Origin-Resource-Policy (CORP) Header Missing or Invalid |
| Tool Penemu | DAST |
| Tool Spesifik | OWASP ZAP v2.17.0 (Plugin ID: 90004-1, CWE-693) |
| URL / File | http://10.34.100.181/ | http://10.34.100.181/icons/ubuntu-logo.png | http://10.34.100.181/ojs/ |
| Parameter / Baris Kode | Cross-Origin-Resource-Policy |
| Method | GET |
| Payload | - |
| Response / Bukti | Header Cross-Origin-Resource-Policy tidak ditemukan pada 3 endpoint |
| OWASP Category | A05:2021 - Security Misconfiguration |
| Severity (Raw) | Low |

### Screenshot / Bukti
📷 Screenshot yang harus dilampirkan: Tangkap layar response header dari request ke salah satu URL terdampak (misalnya /ojs/) yang tidak menampilkan header Cross-Origin-Resource-Policy.

### Catatan
Header CORP mencegah resource dimuat oleh halaman cross-origin sebagai counter-measure terhadap serangan side-channel.

---

## Temuan #24

| Field | Nilai |
|---|---|
| Nama Kerentanan | In Page Banner Information Leak (Apache Version Disclosure) |
| Tool Penemu | DAST |
| Tool Spesifik | OWASP ZAP v2.17.0 (Plugin ID: 10009, CWE-497) |
| URL / File | http://10.34.100.181/manual | http://10.34.100.181/robots.txt | http://10.34.100.181/sitemap.xml | http://10.34.100.181/usr/share/doc/apache2/README.Debian.gz. | http://10.34.100.181/var/www/html/index.html |
| Parameter / Baris Kode | - |
| Method | GET |
| Payload | - |
| Response / Bukti | Evidence: Apache/2.4.58 - versi Apache terekspos dalam konten halaman (5 endpoint terdampak) |
| OWASP Category | A05:2021 - Security Misconfiguration |
| Severity (Raw) | Low |

### Screenshot / Bukti
📷 Screenshot yang harus dilampirkan: Tangkap layar halaman http://10.34.100.181/manual atau response dari salah satu URL terdampak yang menampilkan string 'Apache/2.4.58' dalam konten halaman.

### Catatan
Versi Apache yang terekspos (2.4.58) memudahkan penyerang mengidentifikasi kerentanan CVE yang spesifik untuk versi tersebut.

---

## Temuan #25

| Field | Nilai |
|---|---|
| Nama Kerentanan | Permissions Policy Header Not Set |
| Tool Penemu | DAST |
| Tool Spesifik | OWASP ZAP v2.17.0 (Plugin ID: 10063, CWE-693) |
| URL / File | http://10.34.100.181/ | http://10.34.100.181/manual | http://10.34.100.181/ojs/ | http://10.34.100.181/robots.txt | http://10.34.100.181/sitemap.xml |
| Parameter / Baris Kode | - |
| Method | GET |
| Payload | - |
| Response / Bukti | Header Permissions-Policy tidak ditemukan pada 5 endpoint |
| OWASP Category | A05:2021 - Security Misconfiguration |
| Severity (Raw) | Low |

### Screenshot / Bukti
📷 Screenshot yang harus dilampirkan: Tangkap layar response header dari salah satu URL terdampak yang tidak menampilkan header Permissions-Policy, beserta alert ZAP.

### Catatan
Tanpa Permissions-Policy, halaman web tidak membatasi akses fitur browser sensitif (kamera, mikrofon, geolokasi) yang dapat disalahgunakan oleh skrip berbahaya.

--- 
## Temuan #26

| Field | Nilai |
|---|---|
| Nama Kerentanan | Server Leaks Version Information via Server HTTP Response Header |
| Tool Penemu | DAST |
| Tool Spesifik | OWASP ZAP v2.17.0 (Plugin ID: 10036, CWE-497) |
| URL / File | http://10.34.100.181/ | http://10.34.100.181/ojs | http://10.34.100.181/ojs/ | http://10.34.100.181/robots.txt | http://10.34.100.181/sitemap.xml |
| Parameter / Baris Kode | Server header |
| Method | GET |
| Payload | - |
| Response / Bukti | Evidence: Apache/2.4.58 (Ubuntu) - versi server terekspos di header Server pada 5 endpoint |
| OWASP Category | A05:2021 - Security Misconfiguration |
| Severity (Raw) | Low |

### Screenshot / Bukti
📷 Screenshot yang harus dilampirkan: Tangkap layar response header dari DevTools (salah satu URL terdampak) yang menampilkan header 'Server: Apache/2.4.58 (Ubuntu)'.

### Catatan
Header Server mengekspos versi Apache dan sistem operasi (Ubuntu), mempermudah penyerang melakukan reconnaissance untuk menargetkan exploit yang sesuai.

---

## Temuan #27

| Field | Nilai |
|---|---|
| Nama Kerentanan | X-Content-Type-Options Header Missing |
| Tool Penemu | DAST |
| Tool Spesifik | OWASP ZAP v2.17.0 (Plugin ID: 10021, CWE-693) |
| URL / File | http://10.34.100.181/ | http://10.34.100.181/icons/ubuntu-logo.png | http://10.34.100.181/ojs/ |
| Parameter / Baris Kode | x-content-type-options |
| Method | GET |
| Payload | - |
| Response / Bukti | Header X-Content-Type-Options tidak di-set ke 'nosniff' pada 3 endpoint |
| OWASP Category | A05:2021 - Security Misconfiguration |
| Severity (Raw) | Low |

### Screenshot / Bukti
📷 Screenshot yang harus dilampirkan: Tangkap layar response header dari salah satu URL terdampak yang tidak menampilkan header X-Content-Type-Options: nosniff.

### Catatan
Tanpa header nosniff, browser lama dapat melakukan MIME-type sniffing yang memungkinkan file non-executable dieksekusi sebagai script berbahaya.

---

## Temuan #28

| Field | Nilai |
|---|---|
| Nama Kerentanan | Cookie Slack Detector - Cookie OJSSID Tidak Mempengaruhi Response |
| Tool Penemu | DAST |
| Tool Spesifik | OWASP ZAP v2.17.0 (Plugin ID: 90027, CWE-205) |
| URL / File | http://10.34.100.181/ojs/ |
| Parameter / Baris Kode | Cookie: OJSSID |
| Method | GET |
| Payload | - |
| Response / Bukti | Cookie OJSSID tidak mempengaruhi response - mengindikasikan autentikasi berbasis cookie mungkin tidak ditegakkan |
| OWASP Category | A07:2021 - Identification and Authentication Failures |
| Severity (Raw) | Info |

### Screenshot / Bukti
📷 Screenshot yang harus dilampirkan: Tangkap layar alert ZAP Cookie Slack Detector yang menampilkan detail: 'These cookies did NOT affect the response: OJSSID'.

### Catatan
Temuan ini mengindikasikan bahwa mekanisme validasi sesi mungkin tidak bekerja dengan benar di endpoint yang diuji. Perlu investigasi lebih lanjut apakah halaman yang seharusnya memerlukan autentikasi dapat diakses tanpa sesi yang valid.

---

## Temuan #29

| Field | Nilai |
|---|---|
| Nama Kerentanan | Information Disclosure - Suspicious Comments |
| Tool Penemu | DAST |
| Tool Spesifik | OWASP ZAP v2.17.0 (Plugin ID: 10027) |
| URL / File | http://10.34.100.181/ |
| Parameter / Baris Kode | - |
| Method | GET |
| Payload | - |
| Response / Bukti | Komentar HTML mencurigakan ditemukan: '<!-- Modified from the Debian original for Ubuntu, Last updated: 2022-03-22, See: https://launchpad.net/bugs/1966004 -->' |
| OWASP Category | A05:2021 - Security Misconfiguration |
| Severity (Raw) | Info |

### Screenshot / Bukti
📷 Screenshot yang harus dilampirkan: Tangkap layar dari DevTools > Elements atau View Page Source di http://10.34.100.181/ yang menampilkan komentar HTML berisi referensi ke bug Ubuntu dan versi OS.

### Catatan
Komentar HTML mengekspos bahwa server menggunakan Ubuntu dan mengacu pada bug tracker Launchpad, memberikan informasi fingerprinting OS kepada penyerang.

---

## Temuan #30

| Field | Nilai |
|---|---|
| Nama Kerentanan | Storable and Cacheable Content |
| Tool Penemu | DAST |
| Tool Spesifik | OWASP ZAP v2.17.0 (Plugin ID: 10049, CWE-524) |
| URL / File | http://10.34.100.181/manual | http://10.34.100.181/ojs | http://10.34.100.181/ojs/ | http://10.34.100.181/robots.txt | http://10.34.100.181/sitemap.xml |
| Parameter / Baris Kode | - |
| Method | GET |
| Payload | - |
| Response / Bukti | Response dapat di-cache tanpa batas waktu (heuristic 1 tahun menurut rfc7234) karena tidak ada directive Cache-Control yang eksplisit - 5 endpoint terdampak |
| OWASP Category | A05:2021 - Security Misconfiguration |
| Severity (Raw) | Info |

### Screenshot / Bukti
📷 Screenshot yang harus dilampirkan: Tangkap layar response header dari salah satu URL terdampak (misalnya /ojs/) di DevTools yang menunjukkan tidak ada header Cache-Control: no-store atau Pragma: no-cache.

### Catatan
Konten yang dapat di-cache oleh proxy bersama berpotensi mengekspos data pengguna kepada pengguna lain yang menggunakan proxy yang sama di jaringan korporat atau pendidikan.

---

## Temuan #31

| Field | Nilai |
|---|---|
| Nama Kerentanan | Session Management Response Identified (OJSSID) |
| Tool Penemu | DAST |
| Tool Spesifik | OWASP ZAP v2.17.0 (Plugin ID: 10112) |
| URL / File | http://10.34.100.181/ojs/ |
| Parameter / Baris Kode | Cookie: OJSSID |
| Method | GET |
| Payload | - |
| Response / Bukti | Token manajemen sesi OJSSID teridentifikasi dalam response cookie |
| OWASP Category | A07:2021 - Identification and Authentication Failures |
| Severity (Raw) | Info |

### Screenshot / Bukti
📷 Screenshot yang harus dilampirkan: Tangkap layar alert ZAP Session Management Response Identified yang mengidentifikasi cookie OJSSID sebagai token sesi aplikasi.

### Catatan
Ini merupakan temuan informatif yang mengonfirmasi mekanisme manajemen sesi aplikasi. Perlu diperhatikan bersama temuan #19 (no HttpOnly) dan #20 (no SameSite) terkait keamanan cookie sesi ini.

---

# BAGIAN 3: TEMUAN SQLMAP

## Temuan #32

| Field | Nilai |
|---|---|
| Nama Kerentanan | SQL Injection Testing - Login Endpoint (Negatif / Tidak Rentan) |
| Tool Penemu | DAST |
| Tool Spesifik | SQLMap v1.8.4 |
| URL / File | http://10.34.100.181/ojs/index.php/index/login/signIn |
| Parameter / Baris Kode | POST: username, password, remember |
| Method | POST |
| Payload | username=test&password=test&remember=0 |
| Response / Bukti | [CRITICAL] all tested parameters do not appear to be injectable. POST parameter 'username', 'password', 'remember' - masing-masing tidak menunjukkan tanda injeksi SQL. Server merespons dengan cookie OJSSID. Tested dengan level default, risk default. |
| OWASP Category | A03:2021 - Injection |
| Severity (Raw) | Info |

### Screenshot / Bukti
📷 Screenshot yang harus dilampirkan: Tangkap layar terminal yang menampilkan output SQLMap dengan pesan CRITICAL 'all tested parameters do not appear to be injectable' pada endpoint login (timestamp 12:50:15 - 12:50:20, 2026-04-03).

### Catatan
SQLMap tidak berhasil menemukan injeksi SQL pada endpoint login dengan pengujian level/risk default. Ini merupakan hasil negatif yang baik, namun tidak menjamin 100% aman karena SQLMap menyarankan untuk meningkatkan nilai --level/--risk atau menggunakan --tamper untuk menghindari kemungkinan WAF/proteksi lainnya.

---

## Temuan #33

| Field | Nilai |
|---|---|
| Nama Kerentanan | SQL Injection Testing - Search Endpoint (Negatif / Tidak Rentan) |
| Tool Penemu | DAST |
| Tool Spesifik | SQLMap v1.8.4 |
| URL / File | http://10.34.100.181/ojs/index.php/index/search?query=test |
| Parameter / Baris Kode | GET: query; Header: User-Agent; Header: Referer |
| Method | GET |
| Payload | query=test (diuji dengan level=3, risk=2) |
| Response / Bukti | [CRITICAL] all tested parameters do not appear to be injectable. Parameter 'query' (GET), 'User-Agent', dan 'Referer' tidak menunjukkan tanda injeksi SQL. Pengujian dilakukan dengan --level=3 --risk=2 yang mencakup lebih dari 100 teknik injeksi berbeda. |
| OWASP Category | A03:2021 - Injection |
| Severity (Raw) | Info |

### Screenshot / Bukti
📷 Screenshot yang harus dilampirkan: Tangkap layar terminal yang menampilkan output SQLMap dengan pesan CRITICAL 'all tested parameters do not appear to be injectable' pada endpoint search (timestamp 12:50:44 - 12:52:35, 2026-04-03). Tampilkan juga bagian awal yang menunjukkan --level=3 --risk=2.

### Catatan
Pengujian dilakukan dengan level yang lebih tinggi (level=3, risk=2) mencakup parameter GET, User-Agent, dan Referer. Hasilnya negatif, menunjukkan endpoint search memiliki proteksi terhadap injeksi SQL pada parameter yang diuji. SQLMap menyarankan penggunaan --tamper untuk bypass potensi WAF.

---

## Temuan #34

| Field | Nilai |
|---|---|
| Nama Kerentanan | SQL Injection Testing via Request File dengan Tamper (Negatif / Tidak Rentan) |
| Tool Penemu | DAST |
| Tool Spesifik | SQLMap v1.8.4 |
| URL / File | http://10.34.100.181/ojs/index.php/index/login/signIn (via request.txt) |
| Parameter / Baris Kode | POST: username, password, remember |
| Method | POST |
| Payload | Menggunakan tamper=space2comment (mengganti spasi dengan komentar SQL /* */ untuk bypass WAF) |
| Response / Bukti | [CRITICAL] all tested parameters do not appear to be injectable. Semua parameter POST tidak menunjukkan tanda injeksi meski menggunakan teknik bypass WAF (space2comment tamper script). |
| OWASP Category | A03:2021 - Injection |
| Severity (Raw) | Info |

### Screenshot / Bukti
📷 Screenshot yang harus dilampirkan: Tangkap layar terminal yang menampilkan output SQLMap dengan pesan CRITICAL 'all tested parameters do not appear to be injectable' pada pengujian menggunakan -r request.txt --tamper=space2comment (timestamp 12:54:39 - 12:54:44, 2026-04-03). Tampilkan baris yang menunjukkan 'loading tamper module space2comment'.

### Catatan
Pengujian ketiga menggunakan file request yang dibuat secara manual (-r request.txt) dengan teknik tamper space2comment untuk mencoba bypass proteksi WAF/IPS. Hasilnya tetap negatif. Kombinasi tiga pengujian SQLMap ini mengindikasikan bahwa aplikasi OJS memiliki perlindungan yang cukup baik terhadap SQL injection pada endpoint yang diuji. Namun, endpoint lain yang belum diuji mungkin masih rentan.