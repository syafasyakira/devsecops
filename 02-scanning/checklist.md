### DAST Checklist
- [x] Nikto dijalankan dan output tersimpan
- [x] ZAP Spider dijalankan (minimal 100 URL terindeks)
- [ ] ZAP Active Scan dijalankan (unauthenticated)
- [ ] ZAP Active Scan dijalankan (authenticated sebagai Author)
- [ ] ZAP Active Scan dijalankan (authenticated sebagai Admin)
- [x] SQLMap dijalankan pada minimal 3 parameter
- [ ] SSRF test dilakukan pada CVE-2021-27188
- [ ] Manual XSS test pada form search, profil, abstrak

### SAST Checklist
- [x] Semgrep dengan ruleset `p/php` selesai dijalankan
- [x] Semgrep dengan ruleset `p/owasp-top-ten` selesai dijalankan
- [x] Custom rules Semgrep dijalankan
- [ ] Manual review pada 5 file kritis
- [ ] Temuan deduplikasi (hapus false positive)