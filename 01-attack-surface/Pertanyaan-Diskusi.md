# Pertanyaan Diskusi

### 1. Bagaimana cara membedakan attack surface dan attack vector? Berikan contoh pada OJS!

**Attack Surface** adalah keseluruhan titik (permukaan) di mana pengguna yang tidak berwenang dapat mencoba memasukkan atau mengekstrak data dari sistem. Ini mencakup semua *endpoint* yang terekspos, *form* input, hingga konfigurasi server. 

**Attack Vector** adalah metode atau jalur spesifik yang digunakan oleh penyerang untuk mengeksploitasi kerentanan pada *attack surface* tersebut.

**Contoh pada OJS:**
* **Attack Surface:** * *Endpoint* unggah file (B1–B4) seperti *submission* atau *plugin manager*.
    * *Form* login dan registrasi.
    * *REST API endpoints* seperti `/api/v1/submissions`.
* **Attack Vector:**
    * Mengunggah *web shell* melalui fitur *plugin manager* untuk mendapatkan *Remote Code Execution* (RCE).
    * Melakukan *SQL Injection* pada kolom *username* untuk melewati proses autentikasi.
    * Memanfaatkan informasi versi PHP dari header `X-Powered-By` untuk mencari *exploit* yang sesuai.

---

### 2. Mengapa endpoint upload file (B1–B4) memiliki risiko lebih tinggi dibanding endpoint baca (GET)?

Endpoint *upload* file (seperti *submission wizard* atau *plugin upload*) memiliki risiko yang jauh lebih tinggi dibandingkan endpoint baca (GET) karena alasan berikut:

* **Interaksi Langsung dengan Server:** Endpoint *upload* menerima data dari luar dan menyimpannya langsung ke dalam *file system* server. 
* **Potensi RCE:** Jika validasi tipe file atau ekstensi tidak ketat (kerentanan *Unrestricted File Upload*), penyerang bisa mengunggah skrip berbahaya (misal: `.php`) dan mengeksekusinya untuk mengambil alih server.
* **Path Traversal:** Penyerang dapat memanipulasi nama file (misal: `../../shell.php`) untuk menulis file di luar direktori yang seharusnya.
* **Endpoint GET:** Umumnya hanya berisiko pada kebocoran informasi (*information disclosure*) atau *SQL Injection* pada parameter query, yang dampaknya seringkali tidak secepat atau sefatal eksekusi kode langsung pada server.

---

### 3. Pada alur autentikasi OJS, di titik mana kemungkinan terbesar terjadinya SQL Injection? Jelaskan!

Pada alur autentikasi OJS, titik yang paling berpotensi terjadi **SQL Injection** adalah pada fungsi **`UserDAO::getUserByUsername()`**.

**Penjelasan:**
* Proses login dimulai saat sistem menerima input *username* dari pengguna.
* Input ini kemudian diteruskan ke fungsi `getUserByUsername()` untuk mencari data di database.
* Jika kueri SQL disusun menggunakan teknik *string concatenation* (penggabungan string manual) tanpa *prepared statements*, input berbahaya seperti `admin' --` dapat mengubah logika kueri asli.
* Hal ini dapat menyebabkan kondisi kueri selalu bernilai benar, sehingga penyerang bisa masuk tanpa password yang sah.

---

### 4. Sebutkan minimal 3 informasi sensitif yang mungkin bocor melalui HTTP response headers OJS!

HTTP *response headers* yang tidak dikonfigurasi dengan aman dapat membocorkan informasi teknis yang membantu penyerang dalam tahap pengumpulan informasi (*reconnaissance*). Tiga informasi tersebut adalah:

1.  **Versi Bahasa Pemrograman:** Melalui header **`X-Powered-By`** (misal: `PHP/7.4.33`), yang memungkinkan penyerang mencari CVE spesifik untuk versi tersebut.
2.  **Identitas Web Server:** Melalui header **`Server`** (misal: `Apache/2.4.52 (Ubuntu)`), yang mengungkap jenis OS dan versi server yang digunakan.
3.  **Informasi Sesi:** Melalui header **`Set-Cookie`**. Jika atribut seperti `HttpOnly` atau `Secure` tidak ada, *session identifier* dapat dicuri melalui serangan XSS atau *Man-in-the-Middle* (MITM).