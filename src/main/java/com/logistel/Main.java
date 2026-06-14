package com.logistel;

import com.logistel.config.DatabaseConfig;
import com.logistel.model.Admin;
import com.logistel.model.AuthService;
import com.logistel.model.Barang;
import com.logistel.model.DetailPeminjamanBarang;
import com.logistel.model.DetailPeminjamanRuangan;
import com.logistel.model.IManajemenStok;
import com.logistel.model.LogistikAset;
import com.logistel.model.Peminjaman;
import com.logistel.model.PeminjamanService;
import com.logistel.model.Pengguna;
import com.logistel.model.Ruangan;
import com.logistel.model.User;
import java.sql.Connection;
import java.sql.SQLException;

/**
 * Kelas utama (Main) bertindak sebagai Driver/Client.
 * Mendemonstrasikan seluruh pilar OOP (Enkapsulasi, Overloading, Pewarisan, Polimorfisme,
 * Interface, Collection, Stream, dan Exception Handling) pada sistem LogisTel.
 */
public class Main {
    public static void main(String[] args) {
        System.out.println("=== LOGISTEL SYSTEM INITIALIZATION ===");

        // ==========================================
        // PILAR 1 & 2: CONSTRUCTOR OVERLOADING & INHERITANCE
        // ==========================================
        System.out.println("\n--- 1 & 2. Demonstrasi Constructor Overloading & Pewarisan (Inheritance) ---");
        
        // Menggunakan Constructor Overloaded ke-2 (Standard)
        Admin adminStandard = new Admin(
            "ADM001",
            "Budi Santoso",
            "budis",
            "passwordAdmin123",
            "NIP19950812"
        );

        User userStandard = new User(
            "USR001",
            "Andi Wijaya",
            "andiw",
            "passwordUser456",
            "1202220001",
            "Himpunan Mahasiswa Teknologi Informasi (HMTI)",
            "081234567890",
            "andiw@student.telkomuniversity.ac.id"
        );

        // Menggunakan Constructor Overloaded ke-3 (Full Parameters)
        Admin adminFull = new Admin(
            "ADM002",
            "Siti Aminah",
            "sitia",
            "passwordSiti456",
            "089988776655",
            true,
            "NIP19920101"
        );

        User userFull = new User(
            "USR002",
            "Dewi Lestari",
            "dewil",
            "passwordDewi789",
            "082211003344",
            true,
            "1202220002",
            "Keluarga Besar Mahasiswa (KBM)",
            "dewil@student.telkomuniversity.ac.id"
        );

        // ==========================================
        // PILAR 4: POLIMORFISME & VIRTUAL METHOD INVOCATION (toString overriding)
        // ==========================================
        System.out.println("\n--- 3. Demonstrasi Polimorfisme & Method Overriding (toString) ---");
        Pengguna p1 = adminStandard;
        Pengguna p2 = userStandard;

        System.out.println("Akses Superclass (Polymorphism) ->");
        System.out.println("Pengguna 1 - Nama: " + p1.getNama() + " | Role: " + p1.getRole());
        System.out.println("Pengguna 2 - Nama: " + p2.getNama() + " | Role: " + p2.getRole());

        System.out.println("\nOverridden toString() Invocation (Virtual Method Invocation) ->");
        System.out.println(p1.toString());
        System.out.println(p2.toString());
        System.out.println(adminFull.toString());
        System.out.println(userFull.toString());

        // ==========================================
        // PILAR 1 & 6: ENKAPSULASI DENGAN VALIDASI & EXCEPTION HANDLING
        // ==========================================
        System.out.println("\n--- 4. Demonstrasi Enkapsulasi & Penanganan Eksepsi (Exception Handling) ---");
        try {
            System.out.println("Mencoba membuat user dengan NIM kosong...");
            User invalidUser = new User();
            invalidUser.setNim(""); // Akan memicu Exception
        } catch (IllegalArgumentException e) {
            System.out.println("[EXCEPTION TERCATCH] Gagal menyetel NIM: " + e.getMessage());
        }

        try {
            System.out.println("Mencoba membuat barang dengan stok minus...");
            Barang invalidBarang = new Barang(99, "LAPTOP", -10); // Akan memicu Exception
        } catch (IllegalArgumentException e) {
            System.out.println("[EXCEPTION TERCATCH] Gagal menyetel barang: " + e.getMessage());
        }

        // ==========================================
        // PILAR 5: HETEROGENEOUS COLLECTION & STREAM FILTERING (LAMBDA)
        // ==========================================
        System.out.println("\n--- 5. Demonstrasi Application Controller (ArrayList & Stream Filtering) ---");
        Application app = new Application();
        
        // Memasukkan data ke dalam heterogeneous collection daftarPengguna (Pilar Collection)
        app.tambahPengguna(adminStandard);
        app.tambahPengguna(adminFull);
        app.tambahPengguna(userStandard);
        app.tambahPengguna(userFull);

        // Memasukkan data ke dalam collection daftarBarang
        Barang kameraObj = new Barang(1, "KAMERA", 10);
        Barang proyektorObj = new Barang(2, "PROYEKTOR", 5);
        app.tambahBarang(kameraObj);
        app.tambahBarang(proyektorObj);

        // Menggunakan Java Stream & Lambda untuk pencarian
        System.out.println("\nMencari user dengan username 'andiw' menggunakan Stream...");
        try {
            Pengguna hasilCari = app.cariPenggunaBerdasarkanUsername("andiw");
            System.out.println("User Ditemukan: " + hasilCari);
        } catch (IllegalArgumentException e) {
            System.out.println("Pencarian Gagal: " + e.getMessage());
        }

        System.out.println("\nMencari barang dengan nama 'PROYEKTOR' menggunakan Stream...");
        try {
            Barang hasilBarang = app.cariBarangBerdasarkanNama("PROYEKTOR");
            System.out.println("Barang Ditemukan: " + hasilBarang.getNamaBarang() + " (Stok: " + hasilBarang.getStok() + ")");
        } catch (IllegalArgumentException e) {
            System.out.println("Pencarian Gagal: " + e.getMessage());
        }

        System.out.println("\nMencari user yang TIDAK ADA...");
        try {
            app.cariPenggunaBerdasarkanUsername("unknownuser");
        } catch (IllegalArgumentException e) {
            System.out.println("[EXCEPTION TERCATCH] " + e.getMessage());
        }

        // ==========================================
        // PILAR 3: INTERFACE & VIRTUAL METHOD INVOCATION
        // ==========================================
        System.out.println("\n--- 6. Demonstrasi Interface (LogistikAset) ---");
        LogistikAset asetBarang = kameraObj;
        LogistikAset asetRuangan = new Ruangan(1, "AULA RACHMAT EFFENDY", 1);

        asetBarang.perbaruiStatus();
        asetRuangan.perbaruiStatus();

        // ==========================================
        // UJI COBA KONEKSI DATABASE & AUTHSERVICE ORIGINAL
        // ==========================================
        System.out.println("\n--- 7. Menguji Koneksi Database ---");
        try {
            Connection conn = DatabaseConfig.getConnection();
            if (conn != null && !conn.isClosed()) {
                System.out.println("[KONEKSI SUKSES] LogisTel siap terhubung ke database!");
            }
        } catch (SQLException e) {
            System.out.println("[KONEKSI GAGAL] Tidak dapat terhubung ke database (ini wajar jika MySQL/XAMPP belum aktif).");
        }

        System.out.println("\n--- 8. Inisialisasi AuthService ---");
        AuthService authService = new AuthService();
        System.out.println("AuthService berhasil dimuat: " + (authService != null));

        // ==========================================
        // SIMULASI TRANSAKSI PEMINJAMAN DENGAN EXCEPTION HANDLING
        // ==========================================
        System.out.println("\n--- 9. Simulasi Peminjaman & Exception Handling Stok ---");
        IManajemenStok kameraMgt = kameraObj;
        System.out.println("Stok Awal KAMERA: " + kameraMgt.getStok());

        try {
            System.out.println("Meminjam 3 unit KAMERA...");
            kameraMgt.kurangiStok(3);
            System.out.println("Peminjaman sukses! Stok sekarang: " + kameraMgt.getStok());

            System.out.println("Mencoba meminjam 15 unit KAMERA (melebihi stok)...");
            kameraMgt.kurangiStok(15); // Akan memicu IllegalArgumentException
        } catch (IllegalArgumentException e) {
            System.out.println("[EXCEPTION TERCATCH] Peminjaman gagal: " + e.getMessage());
        }

        System.out.println("\n--- 10. Simulasi Pembuatan Objek Transaksi Peminjaman ---");
        Peminjaman transaksiBarang = new Peminjaman(101, userStandard, "2026-05-20", "2026-05-25", "PENDING", "TX-BARANG-001");
        DetailPeminjamanBarang detailBarang = new DetailPeminjamanBarang(201, transaksiBarang, kameraObj, 2, "Pameran Ormawa", "Meminjam kamera untuk dokumentasi");

        System.out.println("Detail Transaksi Peminjaman Barang:");
        System.out.println("- Peminjam       : " + detailBarang.getPeminjaman().getUserPeminjam().getNama());
        System.out.println("- Barang         : " + detailBarang.getBarang().getNamaBarang());
        System.out.println("- Jumlah         : " + detailBarang.getJumlah() + " unit");
        System.out.println("- Kegiatan       : " + detailBarang.getNamaKegiatan());
        System.out.println("- Status Awal    : " + detailBarang.getPeminjaman().getStatus());

        PeminjamanService peminjamanService = new PeminjamanService();
        System.out.println("\nPeminjamanService berhasil dimuat: " + (peminjamanService != null));
        
        System.out.println("\n===============================================");
    }
}
