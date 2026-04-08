# Pemetaan Temuan ke OWASP Top 10

## Cara Kerja Pemetaan

Setiap temuan dari Pertemuan 3 harus dipetakan ke:

1. Kategori OWASP (A01–A10)
2. CWE (Common Weakness Enumeration) — nomor kelemahan
3. CVE (jika ada kerentanan yang sudah terdaftar)

## Contoh Pemetaan Temuan OJS

| ID Temuan | Deskripsi | OWASP | CWE | CVE |
|---|---|---|---|---|
| VUL-001 | Stored XSS pada field abstrak artikel | A03 | CWE-79 | CVE-2020-28112 |
| VUL-002 | SQL Injection pada parameter search | A03 | CWE-89 | - |
| VUL-003 | SSRF melalui journal stylesheet URL | A10 | CWE-918 | CVE-2021-27188 |
| VUL-004 | Upload plugin tanpa validasi integritas | A08 | CWE-349 | - |
| VUL-005 | Directory listing pada `/ojs/cache/` | A05 | CWE-548 | - |
| VUL-006 | Tidak ada rate limiting pada login | A07 | CWE-307 | - |
| VUL-007 | Versi OJS terekspos di HTTP header | A05 | CWE-200 | - |
| VUL-008 | Cookie session tanpa flag `HttpOnly` | A05 | CWE-1004 | - |
| VUL-009 | XSS via Open Redirect parameter | A03 | CWE-601 | CVE-2022-24822 |
| VUL-010 | IDOR pada API `/api/v1/users/{id}` | A01 | CWE-639 | - |

## Catatan

File ini dibuat terpisah agar pemetaan temuan OWASP bisa dipakai sebagai dokumen mandiri dan tidak bercampur dengan file analisis lain.
