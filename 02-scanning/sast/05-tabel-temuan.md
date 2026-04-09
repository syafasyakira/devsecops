## Temuan #1

| Field                      | Nilai                                                             |
| -------------------------- | ----------------------------------------------------------------- |
| **Nama Kerentanan**        | Stored Cross-Site Scripting (XSS) via HTML Galley                 |
| **Tool Penemu**            | Manual                                                            |
| **Tool Spesifik**          | Code Review                                                       |
| **URL / File**             | plugins/generic/htmlArticleGalley/HtmlArticleGalleyPlugin.inc.php |
| **Parameter / Baris Kode** | `echo $this->_getHTMLContents(...)`                               |
| **Method**                 | GET                                                               |
| **Payload**                | `<script>alert('XSS')</script>`                                   |
| **Response / Bukti**       | Script dieksekusi saat halaman artikel diakses                    |
| **OWASP Category**         | A03:2021 – Injection                                              |
| **Severity (Raw)**         | Critical                                                          |

### Screenshot / Bukti

[Lampirkan screenshot halaman artikel yang mengeksekusi payload]

### Catatan

Konten HTML ditampilkan tanpa sanitasi sehingga memungkinkan eksekusi script berbahaya.

---

## Temuan #2

| Field                      | Nilai                                         |
| -------------------------- | --------------------------------------------- |
| **Nama Kerentanan**        | Stored XSS via TinyMCE Input                  |
| **Tool Penemu**            | Manual                                        |
| **Tool Spesifik**          | Code Review                                   |
| **URL / File**             | plugins/generic/tinymce/TinyMCEPlugin.inc.php |
| **Parameter / Baris Kode** | Input editor (abstract, metadata, profile)    |
| **Method**                 | POST                                          |
| **Payload**                | `<img src=x onerror=alert('XSS')>`            |
| **Response / Bukti**       | Payload tersimpan dan ditampilkan kembali     |
| **OWASP Category**         | A03:2021 – Injection                          |
| **Severity (Raw)**         | High                                          |

### Screenshot / Bukti

[Lampirkan screenshot input dan hasil output]

### Catatan

Editor menerima input HTML tanpa validasi backend.

---

## Temuan #3

| Field                      | Nilai                                               |
| -------------------------- | --------------------------------------------------- |
| **Nama Kerentanan**        | HTML Injection via Custom Headers                   |
| **Tool Penemu**            | Manual                                              |
| **Tool Spesifik**          | Code Review                                         |
| **URL / File**             | lib/pkp/classes/template/PKPTemplateManager.inc.php |
| **Parameter / Baris Kode** | `$this->addHeader('customHeaders', $customHeaders)` |
| **Method**                 | N/A                                                 |
| **Payload**                | `<script>alert('header')</script>`                  |
| **Response / Bukti**       | Script muncul di bagian `<head>`                    |
| **OWASP Category**         | A03:2021 – Injection                                |
| **Severity (Raw)**         | High                                                |

### Screenshot / Bukti

[Lampirkan view-source yang menunjukkan script di head]

### Catatan

Custom header dimasukkan tanpa sanitasi.

---

## Temuan #4

| Field                      | Nilai                                |
| -------------------------- | ------------------------------------ |
| **Nama Kerentanan**        | Potential File Path Manipulation     |
| **Tool Penemu**            | Manual                               |
| **Tool Spesifik**          | Code Review                          |
| **URL / File**             | HtmlArticleGalleyPlugin.inc.php      |
| **Parameter / Baris Kode** | `$submissionFile->getData('path')`   |
| **Method**                 | GET                                  |
| **Payload**                | `../../../../etc/passwd`             |
| **Response / Bukti**       | Potensi akses file tidak sah         |
| **OWASP Category**         | A05:2021 – Security Misconfiguration |
| **Severity (Raw)**         | Medium                               |

### Screenshot / Bukti

[Tidak ada - bersifat analisis kode]

### Catatan

Path file digunakan tanpa validasi eksplisit.

---

## Temuan #5

| Field                      | Nilai                                               |
| -------------------------- | --------------------------------------------------- |
| **Nama Kerentanan**        | Missing Output Escaping (Template Rendering)        |
| **Tool Penemu**            | Manual                                              |
| **Tool Spesifik**          | Code Review                                         |
| **URL / File**             | lib/pkp/classes/template/PKPTemplateManager.inc.php |
| **Parameter / Baris Kode** | Output variabel tanpa escaping                      |
| **Method**                 | GET                                                 |
| **Payload**                | `<script>alert('XSS')</script>`                     |
| **Response / Bukti**       | Output tidak di-encode                              |
| **OWASP Category**         | A03:2021 – Injection                                |
| **Severity (Raw)**         | High                                                |

### Screenshot / Bukti

[Gunakan bukti XSS dari pengujian sebelumnya]

### Catatan

Tidak ada enforcement escaping pada template.

---

## Temuan #6

| Field                      | Nilai                                         |
| -------------------------- | --------------------------------------------- |
| **Nama Kerentanan**        | False Negative pada Static Analysis (Semgrep) |
| **Tool Penemu**            | SAST                                          |
| **Tool Spesifik**          | Semgrep                                       |
| **URL / File**             | Seluruh codebase (ojs-src)                    |
| **Parameter / Baris Kode** | N/A                                           |
| **Method**                 | N/A                                           |
| **Payload**                | N/A                                           |
| **Response / Bukti**       | Tidak ditemukan temuan (0 findings)           |
| **OWASP Category**         | A04:2021 – Insecure Design                    |
| **Severity (Raw)**         | Low                                           |

### Screenshot / Bukti

![Screenshot Temuan 01](screenshot/01.png)

### Catatan

Semgrep tidak mendeteksi kerentanan karena keterbatasan rule-based analysis.

---

## Bukti Tambahan Hasil Scan SAST (Semgrep)

### Run 1

- Perintah: `semgrep --config p/php . --json -o semgrep_php.json`
- Findings: `0 (0 blocking)`
- Rules run: `23`
- Targets scanned: `482`
- Parsed lines: `~100.0%`
- Scan scope: hanya file yang terlacak git, sebagian file di-skip oleh `.semgrepignore`, dan file > 1.0 MB di-skip.

![Scan Summary Semgrep - Run 1](screenshot/01.png)

### Run 2

- Perintah: `semgrep --config p/php . --json -o semgrep_owasp.json`
- Findings: `0 (0 blocking)`
- Rules run: `23`
- Targets scanned: `482`
- Parsed lines: `~100.0%`
- Catatan: output konsisten dengan Run 1 (tidak ada finding).

Catatan bukti gambar Run 2:
- Screenshot kedua belum tersimpan sebagai file terpisah di folder `02-scanning/sast/screenshot/` pada saat update ini.
