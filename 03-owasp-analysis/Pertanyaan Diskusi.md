Pertanyaan Diskusi

### 1. Mengapa kerentanan dengan CVSS 9.8 (Critical) bisa memiliki actual risk yang lebih rendah dari CVSS 6.5 (Medium) dalam konteks bisnis tertentu?
CVSS (Common Vulnerability Scoring System) hanya mengukur **keparahan teknis** secara teoritis (*intrinsic severity*), sedangkan **Actual Risk** memperhitungkan konteks lingkungan nyata.
* **Aksesibilitas:** Kerentanan 9.8 mungkin berada pada server internal yang tidak terhubung ke internet sama sekali (air-gapped), sementara kerentanan 6.5 berada pada server publik yang menyimpan data krusial mahasiswa.
* **Kontrol Kompensasi:** Sebuah sistem mungkin memiliki kerentanan 9.8, tetapi sudah dilindungi oleh WAF (Web Application Firewall) yang sangat ketat, sehingga *likelihood* (kemungkinan) eksploitasi di lapangan menjadi sangat kecil dibanding kerentanan 6.5 yang belum memiliki proteksi sama sekali.

### 2. Jelaskan perbedaan CVSS Base, Temporal, dan Environmental Score! Mana yang paling relevan untuk laporan institusi pendidikan?
* **Base Score:** Skor standar yang mewakili karakteristik intrinsik dari kerentanan (tidak berubah seiring waktu dan tidak tergantung lingkungan).
* **Temporal Score:** Skor yang menyesuaikan tingkat keparahan berdasarkan status terkini dari kerentanan, seperti ketersediaan *exploit code* di publik atau ketersediaan *patch* dari vendor.
* **Environmental Score:** Skor yang disesuaikan dengan lingkungan spesifik organisasi (misal: seberapa penting aset yang terkena dampak bagi institusi).

**Paling Relevan:** **Environmental Score**. Bagi institusi pendidikan, skor ini paling akurat karena mempertimbangkan urgensi aset (seperti database nilai atau data pribadi dosen/mahasiswa) dan langkah mitigasi yang sudah ada di jaringan kampus, sehingga membantu manajemen dalam memprioritaskan anggaran perbaikan.

### 3. Dalam kasus OJS, apakah A06 (Vulnerable & Outdated Components) seharusnya mendapatkan skor tinggi? Jelaskan!
**Ya, seharusnya mendapatkan skor tinggi.**
Argumennya adalah OJS merupakan aplikasi berbasis *monolithic* yang sangat bergantung pada banyak library pihak ketiga dan plugin. 
* **Efek Domino:** Satu plugin yang usang (seperti Akismet atau TinyMCE pada temuan SAST) dapat membuka pintu bagi serangan SSRF atau RCE. 
* **Kemudahan Eksploitasi:** Kerentanan pada komponen *outdated* biasanya sudah memiliki *PoC (Proof of Concept)* yang tersebar luas di internet, sehingga penyerang dengan kemampuan rendah pun bisa melakukan eksploitasi secara otomatis.

### 4. Jika Anda adalah CISO Universitas, kerentanan mana (VUL-001 s/d VUL-010) yang akan diprioritaskan pertama kali? Mengapa?
Saya akan memprioritaskan **VUL-001 (SSRF via Akismet API)** dan **VUL-002 (Stored XSS via Abstract)**.

**Alasan:**
* **VUL-001 (SSRF):** Ini adalah ancaman infrastruktur. SSRF memungkinkan penyerang menembus barikade jaringan luar dan memindai layanan internal universitas (seperti SIAKAD atau database internal) yang seharusnya tidak bisa diakses dari internet. Ini adalah risiko "pintu masuk" bagi serangan yang lebih besar.
* **VUL-002 (Stored XSS):** Ini adalah ancaman kredensial. Akun Admin jurnal seringkali dipegang oleh dosen atau staf penting. Jika akun mereka diambil alih melalui pencurian *session cookie* via XSS, penyerang bisa memanipulasi naskah ilmiah, merusak reputasi jurnal universitas, atau bahkan melakukan eskalasi hak akses ke sistem pusat.
