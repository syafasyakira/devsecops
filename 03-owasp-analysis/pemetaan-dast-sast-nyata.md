# Pemetaan Temuan Nyata ke OWASP Top 10

## Sumber

- DAST: [02-scanning/dast/04-tabel-temuan.md](../02-scanning/dast/04-tabel-temuan.md)
- SAST: [02-scanning/sast/05-tabel-temuan.md](../02-scanning/sast/05-tabel-temuan.md)
- Entry point reference: [01-attack-surface/02-tabel-entry-points.md](../01-attack-surface/02-tabel-entry-points.md)

## Aturan Pemetaan

Setiap temuan dipetakan ke:

1. Kategori OWASP Top 10 2021
2. CWE yang paling relevan
3. CVE bila ada referensi resmi yang cocok
4. Entry point atau file sumber temuan

## DAST

| ID | Entry Point / URL | Deskripsi | OWASP | CWE | CVE |
|---|---|---|---|---|---|
| DAST-01 | `/ojs/` | Missing anti-clickjacking header (`X-Frame-Options` / `frame-ancestors`) | A05 | CWE-1021 | - |
| DAST-02 | `/ojs/` | Cookie `OJSSID` without `HttpOnly` | A05 | CWE-1004 | - |
| DAST-03 | `/ojs/`, `/ojs/robots.txt` | Server information leak via `Server` / `ETag` header | A05 | CWE-200 | - |
| DAST-04 | `/ojs/cache/` | Directory indexing enabled | A01 | CWE-548 | - |
| DAST-05 | `/ojs/robots.txt` | Sensitive path exposure via robots.txt | A05 | CWE-200 | - |
| DAST-06 | `/ojs//cache/` | Improper access control on normalized double-slash path | A01 | CWE-284 | - |
| DAST-07 | `/ojs/` | Insecure HTTP method `OPTIONS` enabled | A05 | CWE-16 | - |
| DAST-08 | `/ojs/` | HTTP `DEBUG` method enabled | A05 | CWE-16 | - |
| DAST-09 | `/ojs/` | HTTP `TRACK` method active (potential XST) | A05 | CWE-16 | - |
| DAST-10 | `/ojs/lib/`, `/ojs/tools/`, `/ojs/docs/`, dll. | Multiple directory indexing found | A01 | CWE-548 | - |
| DAST-11 | `/, /ojs/, /robots.txt, /sitemap.xml, /manual` | Content-Security-Policy header not set | A05 | CWE-16 | - |
| DAST-12 | `https://10.34.100.181/ojs/` | HTTPS not available; only HTTP | A02 | CWE-319 | - |
| DAST-13 | `/ojs/` | Cookie without `SameSite` attribute | A05 | CWE-614 | - |
| DAST-14 | `/, /ojs/` | Cross-Origin-Embedder-Policy header missing | A05 | CWE-16 | - |
| DAST-15 | `/, /ojs/` | Cross-Origin-Opener-Policy header missing | A05 | CWE-16 | - |
| DAST-16 | `/, /icons/ubuntu-logo.png, /ojs/` | Cross-Origin-Resource-Policy header missing | A05 | CWE-16 | - |
| DAST-17 | `/manual, /robots.txt, /sitemap.xml, /usr/share/doc/apache2/README.Debian.gz, /var/www/html/index.html` | In-page banner information leak | A05 | CWE-200 | - |
| DAST-18 | `/, /manual, /ojs/, /robots.txt, /sitemap.xml` | Permissions-Policy header not set | A05 | CWE-16 | - |
| DAST-19 | `/, /icons/ubuntu-logo.png, /ojs/` | `X-Content-Type-Options` header missing | A05 | CWE-16 | - |
| DAST-21 | `/` | Suspicious HTML comments leak information | A05 | CWE-200 | - |
| DAST-24 | `/manual, /ojs, /ojs/, /robots.txt, /sitemap.xml` | Cacheable content without explicit cache controls | A05 | CWE-525 | - |
| DAST-26 | `/index.php/journal1/management/settings/website` | SSRF via Akismet API Server URL | A10 | CWE-918 | CVE-2021-27188 |
| DAST-27 | `/index.php/journal1/search` | Reflected XSS on search parameter, mitigated by output encoding | A03 | CWE-79 | - |
| DAST-28 | `/index.php/journal1/article/view/$id` | Stored XSS via article abstract metadata | A03 | CWE-79 | CVE-2020-28112 |

## SAST

| ID | Entry Point / File | Deskripsi | OWASP | CWE | CVE |
|---|---|---|---|---|---|
| SAST-01 | `plugins/generic/htmlArticleGalley/HtmlArticleGalleyPlugin.inc.php` | Stored XSS via HTML galley | A03 | CWE-79 | CVE-2020-28112 |
| SAST-02 | `plugins/generic/tinymce/TinyMCEPlugin.inc.php` | Stored XSS via TinyMCE input | A03 | CWE-79 | CVE-2023-28131 |
| SAST-03 | `lib/pkp/classes/template/PKPTemplateManager.inc.php` | HTML injection via custom headers | A03 | CWE-79 | - |
| SAST-04 | `HtmlArticleGalleyPlugin.inc.php` | Potential file path manipulation | A05 | CWE-73 | - |
| SAST-05 | `lib/pkp/classes/template/PKPTemplateManager.inc.php` | Missing output escaping in template rendering | A03 | CWE-79 | - |

## Temuan Informasional / Tidak Dipetakan

Temuan berikut ada di laporan, tetapi tidak dipetakan sebagai vulnerability utama karena bersifat informational atau coverage note:

- DAST-20: Cookie slack detector
- DAST-22: Modern web application
- DAST-23: Session management response identified
- DAST-25: User agent fuzzer
- SAST-06: Semgrep false negative / no findings note

## Catatan

Dokumen ini menggunakan temuan nyata dari laporan DAST dan SAST, serta menuliskan entry point atau file sumber untuk memudahkan pelacakan balik ke artefak pengujian.
