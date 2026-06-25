# SIPAKAR 360

**SIPAKAR 360** adalah prototype aplikasi web berbasis PHP dan MySQL untuk mendukung proses **penilaian AKHLAK karyawan berbasis 360 derajat**. Sistem ini dirancang untuk membantu perusahaan dalam mengelola data karyawan, periode evaluasi, pertanyaan penilaian, peer assignment, proses assessment, laporan hasil evaluasi, gap analysis, dan rekomendasi IDP.

Project ini dibuat sebagai prototype sistem informasi untuk kebutuhan tugas/praktikum APSI.

---

## Fitur Utama

### 1. Login dan Role-Based Access

Sistem memiliki halaman login yang mengarahkan pengguna ke menu sesuai role masing-masing. Role yang tersedia adalah:

- **Admin HR**
- **Karyawan / Staff**
- **Atasan**
- **Manajemen**

Pembagian role digunakan agar setiap pengguna hanya dapat mengakses fitur yang sesuai dengan tugas dan kewenangannya.

---

### 2. Admin HR

Admin HR berperan sebagai pengelola utama sistem. Fitur yang tersedia meliputi:

- Dashboard monitoring penilaian
- Master data karyawan
- Pembuatan akun user otomatis saat menambah karyawan
- Pengelolaan periode evaluasi
- Pengelolaan pertanyaan AKHLAK
- Pengelolaan peer assignment
- Pengiriman notifikasi dan reminder
- Report dan IDP
- Audit trail aktivitas pengguna

---

### 3. Karyawan / Staff

Karyawan berperan sebagai pengguna yang mengisi penilaian dan melihat hasil pribadi. Fitur yang tersedia meliputi:

- Dashboard pribadi
- Melihat progress pengisian assessment
- Mengisi self assessment
- Mengisi penilaian peer apabila ditugaskan
- Mengisi penilaian terhadap atasan atau bawahan sesuai assignment
- Menyimpan draft penilaian
- Submit penilaian
- Melihat hasil penilaian pribadi
- Melihat gap analysis dan riwayat periode
- Melihat notifikasi dan reminder

---

### 4. Atasan

Atasan berperan dalam validasi assignment dan evaluasi bawahan. Fitur yang tersedia meliputi:

- Dashboard tim
- Melihat progress bawahan
- Validasi peer assignment
- Approve atau reject assignment
- Memberikan catatan revisi
- Mengisi penilaian bawahan
- Melihat hasil penilaian bawahan
- Melihat gap analysis bawahan
- Mengelola rekomendasi IDP bawahan

---

### 5. Manajemen

Manajemen berperan dalam memantau hasil evaluasi secara organisasi. Fitur yang tersedia meliputi:

- Dashboard organisasi
- Melihat rata-rata nilai AKHLAK
- Melihat distribusi skor
- Melihat tren penilaian
- Gap analysis organisasi
- Talent mapping
- Melihat karyawan high performer dan need development
- Melihat report evaluasi
- Download laporan dalam format PDF, Excel, dan CSV

---

## Teknologi yang Digunakan

- PHP Native
- MySQL / MariaDB
- HTML
- CSS
- JavaScript
- XAMPP sebagai local server

---

## Cara Menjalankan Project di Localhost

### 1. Install XAMPP

Pastikan komputer sudah memiliki XAMPP. Setelah itu, jalankan:

- Apache
- MySQL

---

### 2. Pindahkan Project ke Folder `htdocs`

Copy folder project ke dalam folder `htdocs` XAMPP.

Contoh lokasi folder di Windows:

```text
C:\xampp\htdocs\sipakar360
```

Jika folder project bernama `sipakar360`, maka alamat web di browser adalah:

```text
http://localhost/sipakar360/
```

Jika nama folder berbeda, sesuaikan URL dengan nama folder tersebut.

Contoh:

```text
http://localhost/nama-folder-project/
```

---

### 3. Import Database

Buka phpMyAdmin melalui browser:

```text
http://localhost/phpmyadmin
```

Lalu lakukan langkah berikut:

1. Klik menu **Import**.
2. Pilih file:

```text
database/sipakar360_laporan.sql
```

3. Klik **Go / Kirim**.
4. Database `sipakar360_laporan` akan otomatis dibuat.

File `sipakar360_laporan.sql` sudah berisi perintah:

```sql
CREATE DATABASE IF NOT EXISTS sipakar360_laporan;
USE sipakar360_laporan;
```

Jadi, database tidak perlu dibuat manual terlebih dahulu.

---

### 4. Cek Konfigurasi Database

Secara default, konfigurasi database berada di bagian awal file `index.php`:

```php
define('DB_HOST', '127.0.0.1');
define('DB_NAME', 'sipakar360_laporan');
define('DB_USER', 'root');
define('DB_PASS', '');
```

Konfigurasi tersebut sesuai dengan default XAMPP. Jika MySQL di komputer lain menggunakan password, ubah bagian `DB_PASS` sesuai password MySQL masing-masing.

---

### 5. Jalankan Web

Buka browser dan akses:

```text
http://localhost/sipakar360/
```

Setelah itu, login menggunakan akun dummy yang tersedia.

---

## Akun Dummy

| Role | Username | Password |
|---|---|---|
| Admin HR | `gifary` | `123123` |
| Atasan | `rama` | `123123` |
| Karyawan / Staff | `daffa` | `123123` |
| Manajemen | `anggit` | `123123` |

---

## Cara Clone dari GitHub ke Localhost Orang Lain

Jika project sudah di-upload ke GitHub, orang lain dapat menjalankannya di localhost dengan cara berikut:

### 1. Buka Terminal di Folder `htdocs`

```bash
cd C:/xampp/htdocs
```

### 2. Clone Repository

Ganti `USERNAME` dan `NAMA-REPOSITORY` sesuai repository GitHub.

```bash
git clone https://github.com/USERNAME/NAMA-REPOSITORY.git
```

Contoh:

```bash
git clone https://github.com/username/sipakar360.git
```

### 3. Masuk ke Folder Project

```bash
cd sipakar360
```

### 4. Jalankan Apache dan MySQL di XAMPP

Pastikan service berikut aktif:

- Apache
- MySQL

### 5. Import Database

Import file berikut melalui phpMyAdmin:

```text
database/sipakar360_laporan.sql
```

### 6. Akses Web

Jika folder hasil clone bernama `sipakar360`, buka:

```text
http://localhost/sipakar360/
```

---

## Cara Upload Project ke GitHub

### 1. Extract ZIP Project

Extract file ZIP project terlebih dahulu. Pastikan yang dibuka di VS Code adalah folder project utama yang berisi:

```text
index.php
assets/
database/
README.md
```

---

### 2. Buka Project di VS Code

Klik kanan folder project, lalu pilih:

```text
Open with Code
```

Atau buka VS Code, lalu pilih:

```text
File > Open Folder
```

---

### 3. Buka Terminal VS Code

Di VS Code, buka terminal:

```text
Terminal > New Terminal
```

---

### 4. Inisialisasi Git

Jalankan command berikut:

```bash
git init
```

---

### 5. Tambahkan Semua File ke Git

```bash
git add .
```

---

### 6. Commit Project

```bash
git commit -m "Initial commit SIPAKAR 360"
```

---

### 7. Buat Repository di GitHub

Buka GitHub, lalu:

1. Klik **New repository**.
2. Isi nama repository, misalnya:

```text
sipakar360
```

3. Pilih **Public** atau **Private**.
4. Jangan centang **Add a README file** jika README sudah ada di project lokal.
5. Klik **Create repository**.

---

### 8. Hubungkan Project Lokal ke Repository GitHub

Ganti URL berikut dengan URL repository GitHub masing-masing.

```bash
git branch -M main
git remote add origin https://github.com/USERNAME/sipakar360.git
git push -u origin main
```

Jika berhasil, semua file project akan masuk ke GitHub.

---

## Cara Update Project Setelah Ada Perubahan

Jika sudah pernah push ke GitHub dan ingin upload perubahan terbaru, jalankan:

```bash
git status
git add .
git commit -m "Update project"
git push
```

---

## Catatan Penting

- Project ini masih berupa prototype lokal, bukan aplikasi production.
- Password pada data dummy masih dibuat sederhana agar mudah diuji saat praktikum.
- Untuk implementasi nyata, password sebaiknya menggunakan hashing seperti `password_hash()` dan `password_verify()`.
- Pastikan Apache dan MySQL aktif sebelum membuka web.
- Pastikan file `database/sipakar360_laporan.sql` sudah di-import sebelum login.
- Jika muncul error koneksi database, periksa kembali nama database, username, dan password MySQL pada file `index.php`.
