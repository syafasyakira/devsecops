# Laporan Temuan Keamanan Aplikasi OJS (Terautentikasi - Author & Admin)

# Temuan #01
| Field | Nilai |
|---|---|
| **Nama Kerentanan** | Path Traversal |
| **Tool Penemu** | DAST |
| **Tool Spesifik** | ZAP (Sesi Author & Admin) |
| **URL / File** | Terlampir di rincian *Instances* |
| **Method** | GET, POST |
| **Parameter** | `assocType`, `publicationId`, `queryId`, `source`, `username`, `csrfToken` |
| **Response / Bukti** | Serangan dengan membubuhkan `%5c` (backslash) atau `../` seperti `\fetch-grid` digunakan untuk memanipulasi direktori/path asli pada URL. |
| **OWASP Category** | A01:2021-Broken Access Control |
| **Severity (Raw)** | High |

**Daftar Instances:**
* **(Author)** `GET /ojs/index.php/jtkc/$$$call$$$/grid/files/query/manage-query-note-files-grid/fetch-grid` — Parameter: `assocType`
* **(Author)** `GET /ojs/index.php/jtkc/$$$call$$$/grid/users/author/author-grid/fetch-grid` — Parameter: `publicationId`
* **(Author)** `POST /ojs/index.php/jtkc/$$$call$$$/grid/files/query/manage-query-note-files-grid/update-query-note-files` — Parameter: `queryId`
* **(Admin)** `GET /ojs/index.php/jtkc/$$$call$$$/grid/files/query/query-note-files-grid/fetch-grid` — Parameter: `noteId`
* **(Admin)** `GET /ojs/index.php/jtkc/login` — Parameter: `source`
* **(Admin)** `POST /ojs/index.php/index/login/signIn` — Parameter: `username`

**Catatan:** Kerentanan Path Traversal memungkinkan penyerang untuk mengakses file, direktori, dan perintah yang berpotensi berada di luar direktori root dokumen web. Variasi input berbahaya dikirimkan ke parameter URL dan ditangani secara tidak aman oleh aplikasi. Rekomendasi: Validasi input menggunakan allow list eksak dan jangan mengandalkan sanitasi/deny list semata, implementasikan validasi path menggunakan fungsi built-in, serta batasi hak akses pada operasi file di sisi sistem operasi.

---

# Temuan #02
| Field | Nilai |
|---|---|
| **Nama Kerentanan** | SQL Injection |
| **Tool Penemu** | DAST |
| **Tool Spesifik** | ZAP (Sesi Author & Admin) |
| **URL / File** | Terlampir di rincian *Instances* |
| **Method** | GET, POST |
| **Parameter** | `queryId`, `noteId`, `stageId`, `_`, `submissionId`, `assocType` |
| **Response / Bukti** | Parameter dapat dimanipulasi dengan eksploitasi parameter logika boolean seperti `1038 AND 1=1 --` atau `1016 OR 1=1 --`. URL terbukti membocorkan manipulasi data kueri atau mengembalikan *500 Internal Server Error* ketika disubmit payload `1"`. |
| **OWASP Category** | A03:2021-Injection |
| **Severity (Raw)** | High |

**Daftar Instances (Sebagian Endpoint Terdampak dari total 47 Admin & 15 Author):**
* **(Author)** `GET /ojs/index.php/jtkc/$$$call$$$/grid/queries/queries-grid/fetch-row` — Parameter: `_`
* **(Author)** `GET /ojs/index.php/jtkc/workflow/editorDecisionActions` — Parameter: `stageId`
* **(Author)** `POST /ojs/index.php/jtkc/$$$call$$$/grid/queries/queries-grid/update-query` — Parameter: `queryId`, `subject`, `submitFormButton`
* **(Admin)** `GET /ojs/index.php/jtkc/$$$call$$$/grid/article-galleys/article-galley-grid/fetch-grid` — Parameter: `submissionId`, `publicationId`
* **(Admin)** `GET /ojs/index.php/jtkc/$$$call$$$/grid/files/query/manage-query-note-files-grid/fetch-grid` — Parameter: `assocType`, `assocId`
* **(Admin)** `GET /ojs/index.php/jtkc/$$$call$$$/grid/queries/query-notes-grid/fetch-grid` — Parameter: `stageId`

**Catatan:** SQL Injection memungkinkan penyerang memanipulasi kueri database yang digenerate oleh server melalui karakter input berbahaya. Ini memicu kemungkinan memodifikasi, merusak, dan membocorkan data sensitif dalam DBMS. Rekomendasi: Gunakan kueri berparameter (Parameterized Queries / Prepared Statements) di sisi back-end untuk menghindari penyambungan parameter string secara langsung. 

---

# Temuan #03
| Field | Nilai |
|---|---|
| **Nama Kerentanan** | SQL Injection - Authentication Bypass |
| **Tool Penemu** | DAST |
| **Tool Spesifik** | ZAP (Sesi Author & Admin) |
| **URL / File** | `/ojs/index.php/index/login/signIn` |
| **Method** | POST |
| **Parameter** | `source`, `username`, `password`, `remember` |
| **Response / Bukti** | Form autentikasi gagal memberikan mitigasi saat disisipi payload karakter boolean, dapat dimanfaatkan untuk mengeksekusi *logic* DBMS internal atau melakukan bypass pengecekan identitas login akun. |
| **OWASP Category** | A03:2021-Injection / A07:2021-Identification and Authentication Failures |
| **Severity (Raw)** | High |

**Daftar Instances (Total 7 Titik di Admin & 2 di Author):**
* **(Author & Admin)** `POST /ojs/index.php/index/login/signIn` — Parameter: `remember` (Attack payload: `1 AND 1=1 --`)
* **(Author & Admin)** `POST /ojs/index.php/index/login/signIn` — Parameter: `source` (Attack payload: `OR 1=1 --`)
* **(Admin)** `POST /ojs/index.php/index/login/signIn` — Parameter: `username` (Attack payload: `admin' AND '1'='1`)
* **(Admin)** `POST /ojs/index.php/index/login/signIn` — Parameter: `password` 

**Catatan:** Varian SQL Injection di halaman otentikasi login yang rentan di mana *attacker* dapat membypass form kredensial untuk melakukan impersonasi profil user dengan otoritas tinggi (Admin/Manajer). Rekomendasi: Terapkan *prepared statements* pada titik input log in yang membinding parameter saat dieksekusi database.

---

# Temuan #04
| Field | Nilai |
|---|---|
| **Nama Kerentanan** | User Controllable HTML Element Attribute (Potential XSS) |
| **Tool Penemu** | DAST |
| **Tool Spesifik** | ZAP (Sesi Admin) |
| **URL / File** | `/ojs/index.php/jtkc/workflow/submissionProgressBar` |
| **Method** | GET |
| **Parameter** | `submissionId` |
| **Response / Bukti** | Atribut HTML merender nilai dari parameter yang dikontrol user sepenuhnya tanpa proses encoding/escaping lanjutan. |
| **OWASP Category** | A03:2021-Injection (Cross-Site Scripting) |
| **Severity (Raw)** | Info |

**Daftar Instances:**
* **(Admin)** `GET /ojs/index.php/jtkc/workflow/submissionProgressBar` — Parameter: `submissionId` 

**Catatan:** Ditemukan elemen atribut HTML yang nilainya bisa dirender dan dimanipulasi dengan parameter input dari web. Ketidakhadiran sanitasi memunculkan potensi *Persistent* atau *Reflected XSS*. Rekomendasi: Validasi dan berikan *HTML entity encode* pada output server yang merender atau menautkan string di dalam markup attribute HTML.

---

# Temuan #05
| Field | Nilai |
|---|---|
| **Nama Kerentanan** | Session Management / Authentication Request Identified |
| **Tool Penemu** | DAST |
| **Tool Spesifik** | ZAP (Sesi Admin) |
| **URL / File** | `/ojs/index.php/index/login` |
| **Method** | POST |
| **Parameter** | `Cookie` (OJSSID) |
| **Response / Bukti** | Deteksi informasi log in & mekanisme Session ID dalam transaksi terautentikasi ZAP yang dikategorisasikan oleh pemindaian DAST. |
| **OWASP Category** | A07:2021-Identification and Authentication Failures (Informational) |
| **Severity (Raw)** | Info |

**Daftar Instances:**
* **(Admin)** Terdeteksi di minimal 25 response HTTP berbeda yang melakukan penyetelan otentikasi pada *Cookie*.
* Ditemukan request otentikasi eksplisit via `POST /ojs/index.php/index/login`.

**Catatan:** Identifikasi manajemen sesi oleh scanner DAST, menunjukkan adanya pola pembagian Cookie respons. Rekomendasi: Sebagai langkah proaktif, pastikan session identifier seperti `OJSSID` diamankan menggunakan set atribut referensi `HttpOnly`, `Secure`, dan `SameSite=Strict`.