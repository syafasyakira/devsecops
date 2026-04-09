## 5. Risk Register

### 5.1 Formula Risk (OWASP Risk Rating Methodology)

Penentuan tingkat risiko didasarkan pada metodologi OWASP dengan mempertimbangkan faktor kemudahan eksploitasi (Likelihood) dan dampak yang ditimbulkan (Impact).

$$Likelihood = \frac{\text{Threat Agent Factors} + \text{Vulnerability Factors}}{2}$$
$$Impact = \frac{\text{Technical Impact} + \text{Business Impact}}{2}$$
$$\text{Risk Score} = \text{Likelihood} \times \text{Impact}$$

---

### 5.2 Risk Register OJS — Temuan Terkonsolidasi

| ID | Kerentanan | OWASP | CVSS | Rating | Likelihood | Business Impact | Risk | Prioritas |
|:---:|:---|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
| **VUL-001** | SSRF via Akismet API (DAST-26) | A10 | 7.7 | High | 3 (Medium) | 4 (High) | **High** | 1 |
| **VUL-002** | Stored XSS via Abstract (DAST-28) | A03 | 5.4 | Medium | 4 (High) | 4 (High) | **High** | 2 |
| **VUL-003** | Stored XSS via User Profile (C4) | A03 | 6.4 | Medium | 4 (High) | 3 (Medium) | **High** | 2 |
| **VUL-004** | Directory Indexing /cache/ (DAST-04) | A01 | 5.3 | Medium | 5 (Very High) | 3 (Medium) | **High** | 3 |
| **VUL-005** | No HTTPS / HTTP Only (DAST-12) | A02 | 6.5 | Medium | 5 (Very High) | 3 (Medium) | **High** | 3 |
| **VUL-006** | Cookie tanpa HttpOnly (DAST-02) | A05 | 4.3 | Medium | 4 (High) | 3 (Medium) | **Medium** | 4 |
| **VUL-007** | Missing CSP Header (DAST-11) | A05 | 4.0 | Low | 4 (High) | 2 (Low) | **Medium** | 5 |
| **VUL-008** | Missing Anti-Clickjacking (DAST-01) | A05 | 4.0 | Low | 3 (Medium) | 2 (Low) | **Low** | 6 |
| **VUL-009** | Server Info Leakage (DAST-03) | A05 | 3.7 | Low | 5 (Very High) | 1 (Minimal) | **Low** | 7 |
| **VUL-010** | Reflected XSS Search (DAST-27) | A03 | 0.0 | Info | 1 (Very Low) | 1 (Minimal) | **Informational** | 8 |

---

### 5.3 Likelihood Scale

| Skor | Level | Deskripsi |
|:---:|:---|:---|
| **1** | Very Low | Sulit dieksploitasi, butuh skill tinggi atau mitigasi aktif. |
| **2** | Low | Membutuhkan kondisi tertentu yang jarang terjadi. |
| **3** | Medium | Aktor dengan kemampuan rata-rata bisa mengeksploitasi. |
| **4** | High | Mudah dieksploitasi, banyak tools otomatis tersedia. |
| **5** | Very High | Otomatis, sangat mudah, dan tidak ada proteksi sama sekali. |

---

### 5.4 Business Impact Scale

| Skor | Level | Dampak |
|:---:|:---|:---|
| **1** | Minimal | Tidak ada dampak signifikan pada operasional atau data. |
| **2** | Low | Gangguan minor, kerugian finansial sangat kecil. |
| **3** | Medium | Gangguan signifikan, reputasi instansi terdampak. |
| **4** | High | Kebocoran data pengguna, potensi denda regulasi (UU PDP). |
| **5** | Critical | Kompromi sistem penuh (RCE), data breach masif, operasional mati. |

---

### Analisis Risiko Utama

1. **VUL-001 (SSRF):** Memiliki prioritas tertinggi karena server dapat dipaksa melakukan koneksi ke internal network kampus yang seharusnya terisolasi. Hal ini dapat dimanfaatkan untuk *pivoting* ke infrastruktur internal.
2. **VUL-002 & VUL-003 (Stored XSS):** Risiko tinggi karena dapat digunakan untuk mencuri *session cookie* administrator. Likelihood tinggi (4) karena entry point berada pada fitur yang umum digunakan (Profil & Abstrak).
3. **VUL-004 (Directory Indexing):** Sangat mudah ditemukan (Likelihood 5). Jika folder cache mengandung informasi sensitif, penyerang dapat memetakan struktur internal server dengan sangat cepat.
4. **VUL-010 (Reflected XSS):** Meskipun secara teori rentan, namun karena statusnya telah ter-filter (*Sanitized/Mitigated*), maka risiko dianggap Informational hingga ditemukan *bypass* payload yang baru.