### DAST

| Kode | Kategori | Relevansi pada OJS |
|---|---|---|
| A01 | Broken Access Control | Directory indexing pada `/ojs/cache/` dan direktori lain memungkinkan akses file tanpa otorisasi |
| A02 | Cryptographic Failures | Aplikasi hanya menggunakan HTTP tanpa HTTPS sehingga data dapat disadap |
| A03 | Injection | Reflected dan Stored XSS ditemukan pada fitur pencarian, metadata, dan profile |
| A05 | Security Misconfiguration | Banyak header keamanan tidak diterapkan (CSP, X-Frame-Options, X-Content-Type-Options) |
| A10 | Server-Side Request Forgery (SSRF) | SSRF ditemukan pada plugin Akismet (Temuan #26) |

### SAST

| Kode | Kategori | Relevansi pada OJS |
|---|---|---|
| A03 | Injection | Stored XSS ditemukan pada template rendering dan input TinyMCE tanpa sanitasi |
| A04 | Insecure Design | Desain sistem memperbolehkan HTML bebas tanpa filtering (TinyMCE + TemplateManager) |
| A05 | Security Misconfiguration | Tidak ada enforcement escaping pada template engine |