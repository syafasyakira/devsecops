# SAST Deduplikasi (Semgrep)

Tanggal analisis: 2026-04-09

## Ringkasan Hasil

| Metrik | Nilai |
|---|---:|
| Total temuan mentah | 0 |
| Duplikasi antar laporan | 0 |
| False positive yang dihapus | 0 |
| Total temuan valid (final) | 0 |

## Sumber Data

- ../02-scanning/sast/semgrep_custom.json
- ../02-scanning/sast/semgrep_owasp.json
- ../02-scanning/sast/semgrep_php.json

Ketiga file JSON di atas memiliki field results dengan jumlah 0, sehingga tidak ada item yang bisa dideduplikasi maupun diklasifikasikan sebagai false positive.

## Kenapa Tidak Ada Temuan Setelah Deduplikasi

1. Hasil scan Semgrep menunjukkan 0 findings pada report JSON.
2. Karena tidak ada finding mentah, proses deduplikasi tidak menghasilkan penghapusan apa pun.
3. Validasi screenshot juga konsisten: Scan completed successfully dan Findings: 0.
4. Pada salah satu output juga terlihat hanya aturan OSS yang aktif. Ini bisa menurunkan cakupan deteksi dibanding rule set yang lebih luas.

## Bukti Gambar

### Gambar 1 - Hasil scan Semgrep

![Gambar 1 - Scan Summary Semgrep](../02-scanning/sast/screenshot/01.png)

Keterangan validasi Gambar 1:
- Scan completed successfully.
- Findings: 0 (0 blocking).

