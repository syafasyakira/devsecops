### Dynamic Application Security Testing (DAST)

| Kode | Kategori | Relevansi pada OJS |
|---|---|---|
| A01 | Broken Access Control | Directory indexing pada `/ojs/cache/` dan direktori lain memungkinkan akses file tanpa otorisasi |
| A02 | Cryptographic Failures | Aplikasi hanya menggunakan HTTP tanpa HTTPS sehingga data dapat disadap |
| A03 | Injection | Reflected dan Stored XSS ditemukan pada fitur pencarian, metadata, dan profile |
| A04 | Insecure Design | Fitur plugin memungkinkan input URL eksternal tanpa validasi (SSRF) |
| A05 | Security Misconfiguration | Banyak header keamanan tidak diterapkan (CSP, X-Frame-Options, X-Content-Type-Options) |
| A06 | Vulnerable & Outdated Components | OJS 3.3.x dan Apache/Ubuntu versi tertentu berpotensi memiliki kerentanan |
| A07 | Identification & Authentication Failures | Cookie sesi tidak menggunakan HttpOnly dan Secure |
| A08 | Software & Data Integrity Failures | Plugin (Akismet) dapat dimanipulasi untuk SSRF tanpa validasi |
| A09 | Security Logging & Monitoring Failures | Tidak ditemukan mekanisme logging atau alerting terhadap aktivitas mencurigakan |
| A10 | Server-Side Request Forgery (SSRF) | SSRF ditemukan pada pengaturan plugin Akismet (Temuan #26) |

### Static Application Security Testing (SAST)

| Kode | Kategori | Relevansi pada OJS |
|---|---|---|
| A01 | Broken Access Control | Potensi IDOR pada penggunaan parameter internal seperti assocId tanpa validasi |
| A02 | Cryptographic Failures | Tidak ditemukan langsung pada code review |
| A03 | Injection | Stored XSS ditemukan pada template rendering dan input TinyMCE tanpa sanitasi |
| A04 | Insecure Design | Desain sistem memperbolehkan HTML bebas tanpa filtering (TinyMCE + TemplateManager) |
| A05 | Security Misconfiguration | Tidak ada enforcement escaping pada template engine |
| A06 | Vulnerable & Outdated Components | Ketergantungan pada plugin dan library lama |
| A07 | Identification & Authentication Failures | Tidak ditemukan eksplisit dalam code review |
| A08 | Software & Data Integrity Failures | Plugin dapat menjadi attack surface tanpa validasi |
| A09 | Security Logging & Monitoring Failures | Tidak ditemukan implementasi logging pada level kode |
| A10 | Server-Side Request Forgery (SSRF) | Tidak terdeteksi oleh SAST (false negative) |