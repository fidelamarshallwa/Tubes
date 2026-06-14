## 📦 LogisTel - Sistem Manajemen Peminjaman Logistik & Ruangan

LogisTel adalah aplikasi berbasis web yang dirancang khusus untuk mengelola alur pengajuan, verifikasi, serta pelacakan peminjaman logistik (barang) dan fasilitas (ruangan) di lingkungan kampus Telkom University. Sistem ini mengintegrasikan otentikasi akun, pengecekan ketersediaan jadwal secara real-time, manajemen stok gudang otomatis, dan sistem serah terima berbasis kode barcode unik.

---

## ✨ Fitur Utama

### 👤 Portal Mahasiswa (User)
* **Katalog Inventaris Dinamis:** Melihat daftar barang (beserta sisa stok) dan ruangan yang tersedia secara real-time dengan fitur filter kategori dan pencarian cepat.
* **Formulir Pengajuan Cerdas:** Pengajuan peminjaman logistik/ruangan yang terintegrasi dengan session profil mahasiswa (NIM, Nama, Ormawa).
* **Sistem Validasi Anti-Bentrok Jadwal:** Mencegah pengajuan disetujui jika tanggal yang dipilih telah dipesan (`APPROVED`) oleh organisasi lain untuk item yang sama.
* **Riwayat Transaksi Transparan:** Memantau status pengajuan (*Pending, Approved, Rejected, Returned*) lengkap dengan visualisasi durasi rentang tanggal pinjam.
* **E-Barcode Peminjaman:** Mengunduh/menampilkan kode barcode unik berbasis UUID acak untuk divalidasi oleh petugas logistik saat serah terima fisik.

### 👨‍💼 Portal Administrator (Gudang/Logistik)
* **Dasbor Statistik Ringkas:** Memantau total kapasitas stok barang, jumlah ruangan, dan indikator jumlah antrean verifikasi yang masuk.
* **Sistem Verifikasi Alur Kerja Lengkap:** Menyetujui (`APPROVED`) atau menolak (`REJECTED`) peminjaman baru, serta memproses verifikasi peminjaman selesai (`RETURNED`).
* **Manajemen Stok Otomatis:** * Stok barang akan **berkurang otomatis** di database begitu admin mengklik tombol *Setujui* pengajuan.
    * Stok barang akan **bertambah kembali** secara otomatis begitu admin memproses *Terima Pengembalian*.
* **Manajemen Data Pengguna:** Melihat seluruh daftar akun yang terdaftar di dalam sistem beserta hak akses (*role*) masing-masing.

---

## 🛠️ Arsitektur Teknologi & Dependensi

* **Core Language:** Java (JDK 8 / JDK 11)
* **Web Framework:** Java Servlet (HTTPServlet DOM HTML) & JavaServer Pages (JSP)
* **Database:** MySQL / MariaDB (Relational Architecture)
* **Database Driver:** MySQL Connector/J (`mysql-connector-j-9.7.0.jar`)
* **Build Tool & Dependency Manager:** Apache Maven
* **Front-End Styling:** Tailwind CSS (via CDN) & Google Fonts (Outfit)
* **Interactive Components:** SweetAlert2 (Pop-up Validasi) & HTML5 Canvas/SVG Barcode

---

## 💾 Struktur Database Relasional

Aplikasi ini menggunakan skema relasi database untuk menangani modularisasi antara barang, ruangan, dan detail transaksi peminjaman:


```

```text
README.md successfully generated.

```sql
-- 1. Tabel Induk Akun Pengguna
CREATE TABLE pengguna (
    id_pengguna INT AUTO_INCREMENT PRIMARY KEY,
    nama VARCHAR(100) NOT NULL,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    role ENUM('Admin', 'User') NOT NULL
);

-- 2. Tabel Ekstensi Profil Mahasiswa (User)
CREATE TABLE user (
    id_user INT PRIMARY KEY,
    nim VARCHAR(20) NOT NULL UNIQUE,
    nama_ormawa VARCHAR(100),
    FOREIGN KEY (id_user) REFERENCES pengguna(id_pengguna) ON DELETE CASCADE
);

-- 3. Tabel Master Barang
CREATE TABLE barang (
    id_barang INT AUTO_INCREMENT PRIMARY KEY,
    nama_barang VARCHAR(100) NOT NULL,
    stok INT NOT NULL DEFAULT 0
);

-- 4. Tabel Master Ruangan
CREATE TABLE ruangan (
    id_ruangan INT AUTO_INCREMENT PRIMARY KEY,
    nama_ruangan VARCHAR(100) NOT NULL
);

-- 5. Tabel Induk Transaksi Peminjaman
CREATE TABLE peminjaman (
    id_peminjaman INT AUTO_INCREMENT PRIMARY KEY,
    id_user INT NOT NULL,
    tanggal_mulai DATE NOT NULL,
    tanggal_selesai DATE NOT NULL,
    nama_kegiatan VARCHAR(150) NOT NULL,
    deskripsi TEXT,
    status ENUM('PENDING', 'APPROVED', 'REJECTED', 'RETURN_REQUESTED', 'RETURNED') DEFAULT 'PENDING',
    barcode VARCHAR(50) NOT NULL,
    FOREIGN KEY (id_user) REFERENCES pengguna(id_pengguna)
);

-- 6. Tabel Detail Peminjaman Barang (Logistik)
CREATE TABLE detail_peminjaman_barang (
    id_detail_barang INT AUTO_INCREMENT PRIMARY KEY,
    id_peminjaman INT NOT NULL,
    id_barang INT NOT NULL,
    jumlah INT NOT NULL DEFAULT 1,
    nama_kegiatan VARCHAR(150),
    deskripsi TEXT,
    FOREIGN KEY (id_peminjaman) REFERENCES peminjaman(id_peminjaman) ON DELETE CASCADE,
    FOREIGN KEY (id_barang) REFERENCES barang(id_barang)
);

-- 7. Tabel Detail Peminjaman Ruangan (Fasilitas)
CREATE TABLE detail_peminjaman_ruangan (
    id_detail_ruangan INT AUTO_INCREMENT PRIMARY KEY,
    id_peminjaman INT NOT NULL,
    id_ruangan INT NOT NULL,
    nama_kegiatan VARCHAR(150),
    deskripsi TEXT,
    FOREIGN KEY (id_peminjaman) REFERENCES peminjaman(id_peminjaman) ON DELETE CASCADE,
    FOREIGN KEY (id_ruangan) REFERENCES ruangan(id_ruangan)
);

```

---

## 🚀 Panduan Instalasi & Menjalankan Proyek

### 1. Prasyarat Sistem

Pastikan perangkat Anda sudah terinstal tools berikut:

* Java Development Kit (JDK 8 atau versi di atasnya)
* Apache Maven (terkonfigurasi di Environment Path)
* MySQL Server / XAMPP

### 2. Kloning & Persiapan Database

1. Ekstrak atau klon proyek ke direktori lokal Anda:
```bash
cd PBO-Fix

```


2. Buka MySQL (phpMyAdmin/HeidiSQL/DBeaver), buat database baru bernama `logistel`:
```sql
CREATE DATABASE logistel;

```


3. Import atau eksekusi struktur query DDL di atas ke dalam database `logistel`.
4. Sesuaikan konfigurasi *username* dan *password* database MySQL Anda di dalam berkas konfigurasi Java JDBC: `src/main/java/com/logistel/config/DatabaseConfig.java`.

### 3. Kompilasi & Menjalankan Server (Maven Tomcat Plugin)

Gunakan Maven untuk membersihkan berkas sampah, mengompilasi servlet, dan menjalankan server Tomcat lokal tertanam (*embedded*):

```bash
mvn clean tomcat7:run

```

Tunggu hingga terminal menampilkan log status server berhasil berjalan:

```text
[INFO] Running war on http://localhost:8080/PBO-Fix
[INFO] Tomcat diperbaharui dan siap menerima request.

```

Buka browser Anda dan akses sistem melalui tautan:
🔗 **`http://localhost:8080/login.jsp`**

---

## ⚙️ Penanganan Isu Teknis yang Telah Diperbaiki

* **Solusi Konflik ID (UNION Dropdown):** Menggunakan format pengidentifikasi string gabungan (`CONCAT('BARANG_', id_barang)`) saat query gabungan dijalankan agar elemen DOM select tidak saling bertabrakan antara ID Ruangan dan ID Barang yang bernilai sama. Nilai kemudian diurai kembali menggunakan perintah `.split("_")` di sisi Servlet Backend.
* **Solusi Incompatible Types JDBC:** Memperbaiki penanganan parameter Servlet yang awalnya berupa objek teks `String` ke dalam konversi data numerik murni `int` menggunakan `Integer.parseInt()` sebelum ditembakkan ke metode `.setInt(index, value)` pada `PreparedStatement`.
"""

with open("README.md", "w", encoding="utf-8") as f:
f.write(readme_content.strip())

print("README.md successfully generated.")

```
Berikut adalah berkas dokumentasi proyek `README.md` yang telah berhasil dibuat dan disesuaikan secara komprehensif berdasarkan arsitektur, fitur *anti-conflict* ID, logika *overlap check*, serta perbaikan isu kompilasi Maven yang telah diselesaikan pada sistem **LogisTel**.

Your Markdown file is ready
[file-tag: code-generated-file-0-1781463852744337657]

---

### 📝 Pratonton Isi `README.md`

Berkas tersebut mencakup poin-poin struktural penting sebagai berikut:

1. **Deskripsi Umum Sistem:** Mengenai platform **LogisTel** sebagai portal peminjaman logistik berbasis web mahasiswa dan admin di Telkom University.
2. **Fitur Portal Mahasiswa & Admin:** Penjelasan alur fitur mulai dari katalog dinamis, sistem pengajuan terproteksi session, validasi jadwal anti-bentrok, hingga pelacakan stok otomatis.
3. **Arsitektur Teknologi:** Spesifikasi dependensi proyek seperti penggunaan Java/JSP, Servlet, Driver JDBC `mysql-connector-j`, Apache Maven, dan integrasi komponen front-end (Tailwind & SweetAlert2).
4. **Skema Relasi Database (DDL SQL):** Rancangan tabel lengkap (`pengguna`, `user`, `barang`, `ruangan`, `peminjaman`, serta tabel detail perantara logistik) yang siap dieksekusi ke MySQL.
5. **Panduan Instalasi & Deployment Server:** Instruksi langkah demi langkah untuk menjalankan perintah kompilasi proyek melalui *embedded server plugin* Maven (`mvn clean tomcat7:run`).
6. **Dokumentasi Solusi Isu Teknis:** Penjelasan teknis mengenai metode mitigasi tabrakan ID menggunakan teknik prefiks string `CONCAT('BARANG_', id)` dan penyelesaian error *incompatible types* pada `VerifikasiServlet`.

Berkas ini siap digunakan sebagai halaman dokumentasi utama repositori kode (*repository root page*) proyek tugas besar pemrograman berorientasi objek Anda!

```
