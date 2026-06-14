<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, com.logistel.config.DatabaseConfig" %>

<%
    // =======================================================================
    // PROTEKSI HALAMAN & PENGAMBILAN DATA SESI (SERVER-SIDE)
    // =======================================================================
    String role = (String) session.getAttribute("role");
    
    // Jika belum login atau bukan user biasa, tendang ke halaman login
    if (role == null || !role.equalsIgnoreCase("user")) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return; 
    }

    // Mengambil data dari session (Pastikan saat login, atribut ini di-set)
    String nama = (String) session.getAttribute("nama");
    if (nama == null) nama = "Pengguna Mahasiswa"; // Fallback jika null
    
    String nim = (String) session.getAttribute("nim");
    if (nim == null) nim = "-";
    
    String ormawa = (String) session.getAttribute("ormawa");
    if (ormawa == null) ormawa = "Universitas Telkom";

    String hp = (String) session.getAttribute("hp");
    if (hp == null) hp = "-";

    String email = (String) session.getAttribute("email");
    if (email == null) email = (String) session.getAttribute("username");

    // Membuat inisial untuk Avatar (2 huruf pertama dari nama)
    String initial = "U";
    if (nama.length() >= 2) {
        initial = nama.substring(0, 2).toUpperCase();
    }
%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>LogisTel - Portal Mahasiswa</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    fontFamily: {
                        sans: ['Outfit', 'sans-serif'],
                    },
                    colors: {
                        telkom: {
                            50: '#fef2f2',
                            100: '#fee2e2',
                            500: '#ef4444',
                            600: '#dc2626',
                            700: '#b91c1c',
                            800: '#991b1b',
                            900: '#7f1d1d',
                        }
                    }
                }
            }
        }
    </script>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Outfit', sans-serif; }
    </style>
</head>
<body class="bg-gray-50 text-gray-900 min-h-screen flex flex-col md:flex-row relative">

    <aside id="sidebar" class="fixed inset-y-0 left-0 z-30 w-64 bg-telkom-800 text-white flex flex-col justify-between transform -translate-x-full md:translate-x-0 transition-transform duration-300 ease-in-out shadow-lg">
        <div class="flex flex-col h-full">
            <div class="h-16 px-6 border-b border-telkom-900 flex items-center gap-3 shrink-0">
                <div class="w-8 h-8 rounded-lg bg-white flex items-center justify-center text-telkom-800 font-bold text-lg shadow-sm">
                    L
                </div>
                <span class="text-xl font-bold tracking-tight text-white">Logis<span class="text-red-200">Tel</span></span>
                <span class="bg-telkom-900/60 text-red-200 border border-telkom-700/50 text-[10px] font-semibold px-2 py-0.5 rounded-full uppercase tracking-wider">User</span>
            </div>

            <nav class="flex-1 px-4 py-6 space-y-1.5">
                <button onclick="switchTab('katalog-tab', 'katalog-section')" id="katalog-tab" 
                    class="nav-link w-full flex items-center gap-3 px-4 py-3 text-red-100 rounded-xl hover:bg-telkom-700 hover:text-white transition duration-150 group active-tab bg-telkom-700 text-white font-medium">
                    <svg class="w-5 h-5 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6a2 2 0 012-2h2a2 2 0 012 2v4a2 2 0 01-2 2H6a2 2 0 01-2-2V6zM14 6a2 2 0 012-2h2a2 2 0 012 2v4a2 2 0 01-2 2h-2a2 2 0 01-2-2V6zM4 16a2 2 0 012-2h2a2 2 0 012 2v4a2 2 0 01-2 2H6a2 2 0 01-2-2v-4zM14 16a2 2 0 012-2h2a2 2 0 012 2v4a2 2 0 01-2 2h-2a2 2 0 01-2-2v-4z"></path>
                    </svg>
                    <span>Katalog Inventaris</span>
                </button>

                <button onclick="switchTab('form-tab', 'form-section')" id="form-tab" 
                    class="nav-link w-full flex items-center gap-3 px-4 py-3 text-red-200 rounded-xl hover:bg-telkom-700 hover:text-white transition duration-150 group">
                    <svg class="w-5 h-5 text-red-200 group-hover:text-white transition" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v3m0 0v3m0-3h3m-3 0h-3m-2-5a4 4 0 11-8 0 4 4 0 018 0zM3 20a6 6 0 0112 0v1H3v-1z"></path>
                    </svg>
                    <span>Form Pengajuan</span>
                </button>

                <button onclick="switchTab('riwayat-tab', 'riwayat-section')" id="riwayat-tab" 
                    class="nav-link w-full flex items-center gap-3 px-4 py-3 text-red-200 rounded-xl hover:bg-telkom-700 hover:text-white transition duration-150 group">
                    <svg class="w-5 h-5 text-red-200 group-hover:text-white transition" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2"></path>
                    </svg>
                    <span>Riwayat Peminjaman</span>
                </button>
            </nav>
        </div>

        <div class="p-4 border-t border-telkom-900 shrink-0">
            <button onclick="window.location.href='${pageContext.request.contextPath}/logout-process'" class="flex items-center justify-center gap-2 w-full py-2.5 bg-telkom-900/40 hover:bg-telkom-900/80 text-red-200 hover:text-white font-bold rounded-xl text-sm transition duration-150">
                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1"></path>
                </svg>
                <span>Keluar (Logout)</span>
            </button>
        </div>
    </aside>

    <main class="flex-1 min-h-screen md:pl-64 flex flex-col w-full">
        <header class="h-16 px-6 border-b border-gray-200 bg-white flex items-center justify-between sticky top-0 z-20 shadow-sm">
            <div class="flex items-center gap-4">
                <button onclick="toggleMobileSidebar()" class="md:hidden text-gray-500 hover:text-gray-900 focus:outline-none transition">
                    <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16"></path>
                    </svg>
                </button>
                <h2 id="section-title" class="text-lg font-bold text-gray-900 tracking-tight">Katalog Inventaris</h2>
            </div>
            
            <div class="flex items-center gap-4">
                <span class="bg-red-50 border border-red-200 text-telkom-700 text-xs px-2.5 py-1 rounded-md font-semibold font-mono uppercase tracking-wider">SSO CONNECTED</span>
            </div>
        </header>

        <div class="p-6 space-y-6 flex-1 bg-gray-50">

            <div class="bg-white border border-gray-200 rounded-2xl p-6 relative overflow-hidden shadow-sm">
                <div class="absolute top-0 left-0 bottom-0 w-1.5 bg-telkom-700"></div>
                
                <div class="flex flex-col lg:flex-row lg:items-center justify-between gap-6 pl-2">
                    <div class="flex items-center gap-4 justify-between w-full lg:w-auto">
                        <div class="flex items-center gap-4">
                            <div class="w-12 h-12 rounded-xl bg-telkom-50 border border-telkom-100 text-telkom-700 flex items-center justify-center font-bold text-lg shadow-sm shrink-0">
                                <%= initial %>
                            </div>
                            <div>
                                <h3 class="text-base font-bold text-gray-900 flex flex-wrap items-center gap-2">
                                    <span><%= nama %></span>
                                    <span class="bg-red-100 text-telkom-700 border border-red-200/50 text-[10px] font-bold px-2.5 py-0.5 rounded-full uppercase">Mahasiswa</span>
                                </h3>
                                <p class="text-xs text-gray-500 mt-0.5">Program Studi Universitas Telkom</p>
                            </div>
                        </div>
                        <button onclick="openEditProfileModal()" class="lg:hidden text-xs font-semibold text-telkom-700 hover:text-telkom-800 bg-red-50 hover:bg-red-100 border border-red-200 px-3 py-1.5 rounded-lg transition flex items-center gap-1.5 shrink-0">
                            <svg class="w-3.5 h-3.5" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15.232 5.232l3.536 3.536m-2.036-5.036a2.5 2.5 0 113.536 3.536L6.5 21.036H3v-3.572L16.732 3.732z"></path></svg>
                            <span>Edit</span>
                        </button>
                    </div>
                    
                    <div class="grid grid-cols-2 sm:grid-cols-4 gap-4 lg:gap-6 border-t lg:border-t-0 lg:border-l border-gray-200 pt-4 lg:pt-0 lg:pl-6 flex-1">
                        <div>
                            <p class="text-[10px] text-gray-400 uppercase tracking-wider font-bold">NIM</p>
                            <p class="text-sm font-semibold text-gray-800 font-mono mt-0.5"><%= nim %></p>
                        </div>
                        <div>
                            <p class="text-[10px] text-gray-400 uppercase tracking-wider font-bold">Ormawa</p>
                            <p class="text-sm font-semibold text-gray-800 mt-0.5"><%= ormawa %></p>
                        </div>
                        <div>
                            <p class="text-[10px] text-gray-400 uppercase tracking-wider font-bold">Nomor HP</p>
                            <p id="display-hp" class="text-sm font-semibold text-gray-800 mt-0.5"><%= hp %></p>
                        </div>
                        <div>
                            <p class="text-[10px] text-gray-400 uppercase tracking-wider font-bold">Email SSO</p>
                            <p class="text-sm font-semibold text-gray-800 truncate mt-0.5" title="<%= email %>"><%= email %></p>
                        </div>
                    </div>
                    <button onclick="openEditProfileModal()" class="hidden lg:flex text-xs font-semibold text-telkom-700 hover:text-telkom-800 bg-red-50 hover:bg-red-100 border border-red-200 px-3 py-1.5 rounded-lg transition items-center gap-1.5 shrink-0">
                        <svg class="w-3.5 h-3.5" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15.232 5.232l3.536 3.536m-2.036-5.036a2.5 2.5 0 113.536 3.536L6.5 21.036H3v-3.572L16.732 3.732z"></path></svg>
                        <span>Edit Profil</span>
                    </button>
                </div>
            </div>

            <section id="katalog-section" class="tab-content space-y-6">
                <div class="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4">
                    <div class="flex bg-white border border-gray-200 p-1 rounded-xl shadow-sm">
                        <button onclick="filterCatalog('Semua')" id="filter-all" class="catalog-filter-btn px-4 py-1.5 text-xs font-semibold rounded-lg bg-telkom-700 text-white transition">Semua</button>
                        <button onclick="filterCatalog('Barang')" id="filter-barang" class="catalog-filter-btn px-4 py-1.5 text-xs font-semibold rounded-lg text-gray-500 hover:text-gray-900 transition">Barang</button>
                        <button onclick="filterCatalog('Ruangan')" id="filter-ruangan" class="catalog-filter-btn px-4 py-1.5 text-xs font-semibold rounded-lg text-gray-500 hover:text-gray-900 transition">Ruangan</button>
                    </div>
                    
                    <div class="relative w-full sm:w-64">
                        <input type="text" id="catalog-search" oninput="searchCatalog()" placeholder="Cari nama barang/ruangan..." 
                            class="w-full pl-9 pr-4 py-2 bg-white border border-gray-200 rounded-xl text-xs text-gray-900 placeholder-gray-400 focus:outline-none focus:ring-1 focus:ring-telkom-500 focus:border-telkom-700 transition shadow-sm">
                        <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none text-gray-400">
                            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"/></svg>
                        </div>
                    </div>
                </div>

                <div id="catalog-grid" class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
                    <%
                        Connection conn = null;
                        try {
                            conn = DatabaseConfig.getConnection();
                            Statement stmt = conn.createStatement();
                            
                            // Load Barang
                            ResultSet rsB = stmt.executeQuery("SELECT * FROM barang");
                            while(rsB.next()) {
                    %>
                                <div class="catalog-card bg-white border border-gray-200 rounded-2xl p-5 shadow-sm" data-type="Barang" data-name="<%= rsB.getString("nama_barang").toLowerCase() %>">
                                    <span class="bg-red-50 text-telkom-700 text-[10px] font-bold px-2 py-0.5 rounded-full uppercase">Barang</span>
                                    <h4 class="text-base font-bold text-gray-900 mt-2"><%= rsB.getString("nama_barang") %></h4>
                                    <p class="text-xs text-gray-500 mb-4">Stok: <%= rsB.getInt("stok") %></p>
                                    <button onclick="quickBorrow('Barang', '<%= rsB.getString("nama_barang") %>')" class="w-full py-2 bg-gray-100 hover:bg-telkom-700 hover:text-white rounded-xl text-xs font-semibold">Pinjam Sekarang</button>
                                </div>
                    <%
                            }
                            // Load Ruangan
                            ResultSet rsR = stmt.executeQuery("SELECT * FROM ruangan");
                            while(rsR.next()) {
                    %>
                                <div class="catalog-card bg-white border border-gray-200 rounded-2xl p-5 shadow-sm" data-type="Ruangan" data-name="<%= rsR.getString("nama_ruangan").toLowerCase() %>">
                                    <span class="bg-blue-50 text-blue-700 text-[10px] font-bold px-2 py-0.5 rounded-full uppercase">Ruangan</span>
                                    <h4 class="text-base font-bold text-gray-900 mt-2"><%= rsR.getString("nama_ruangan") %></h4>
                                    <button onclick="quickBorrow('Ruangan', '<%= rsR.getString("nama_ruangan") %>')" class="w-full py-2 bg-gray-100 hover:bg-telkom-700 hover:text-white rounded-xl text-xs font-semibold">Pinjam Sekarang</button>
                                </div>
                    <%
                            }
                            rsB.close(); rsR.close(); stmt.close();
                        } catch (Exception e) {
                            out.println("Error memuat data: " + e.getMessage());
                        } finally {
                            if(conn != null) conn.close();
                        }
                    %>
                </div>
            </section>

            <section id="form-section" class="tab-content hidden">
                <div class="max-w-2xl bg-white border border-gray-200 rounded-2xl p-8 shadow-sm">
                    <h3 class="text-base font-bold text-gray-900 mb-6 uppercase tracking-wider border-b border-gray-100 pb-2">Formulir Pengajuan Peminjaman</h3>
                    
                    <form id="peminjaman-form" action="${pageContext.request.contextPath}/pengajuan-peminjaman" method="POST" class="space-y-6">
                        <div class="grid grid-cols-1 sm:grid-cols-2 gap-6">
                            <div>
                                <label for="nim" class="block text-xs font-bold text-gray-500 uppercase tracking-wider mb-2">NIM Pemohon</label>
                                <input type="text" name="nim" id="nim" value="<%= nim %>" readonly 
                                    class="w-full px-4 py-3 bg-gray-50 border border-gray-200 rounded-xl text-gray-500 font-mono text-sm focus:outline-none cursor-not-allowed">
                            </div>
                            <div>
                                <label for="nama_ormawa" class="block text-xs font-bold text-gray-500 uppercase tracking-wider mb-2">Nama Ormawa</label>
                                <input type="text" name="nama_ormawa" id="nama_ormawa" value="<%= ormawa %>" readonly 
                                    class="w-full px-4 py-3 bg-gray-50 border border-gray-200 rounded-xl text-gray-500 text-sm focus:outline-none cursor-not-allowed">
                            </div>
                        </div>

                        <div class="grid grid-cols-1 sm:grid-cols-2 gap-6">
                            <div>
                                <label for="tipe_inventaris" class="block text-xs font-bold text-gray-500 uppercase tracking-wider mb-2">Jenis Inventaris</label>
                                <select name="tipe_inventaris" id="tipe_inventaris" required onchange="handleFormTypeChange()"
                                    class="w-full px-4 py-3 bg-white border border-gray-300 rounded-xl text-gray-800 text-sm focus:outline-none focus:ring-1 focus:ring-telkom-500 focus:border-telkom-700 appearance-none cursor-pointer">
                                    <option value="Barang">Barang (Logistik)</option>
                                    <option value="Ruangan">Ruangan (Fasilitas)</option>
                                </select>
                            </div>
                            <div>
                                <label for="id_item" class="block text-xs font-bold text-gray-500 uppercase tracking-wider mb-2">Pilih Item</label>
                                <select name="id_item" id="id_item" required
                                    class="w-full px-4 py-3 bg-white border border-gray-300 rounded-xl text-gray-850 text-sm focus:outline-none focus:ring-1 focus:ring-telkom-500 focus:border-telkom-700 cursor-pointer">
                                </select>
                            </div>
                        </div>

                        <div id="jumlah-container">
                            <label for="jumlah" class="block text-xs font-bold text-gray-500 uppercase tracking-wider mb-2">Jumlah Barang</label>
                            <input type="number" name="jumlah" id="jumlah" min="1" max="10" value="1" required
                                class="w-full px-4 py-3 bg-white border border-gray-300 rounded-xl text-gray-900 placeholder-gray-400 focus:outline-none focus:ring-1 focus:ring-telkom-500 focus:border-telkom-700 text-sm transition">
                        </div>

                        <div>
                            <label for="nama_kegiatan" class="block text-xs font-bold text-gray-500 uppercase tracking-wider mb-2">Nama Kegiatan</label>
                            <input type="text" name="nama_kegiatan" id="nama_kegiatan" required placeholder="Contoh: Rapat Kerja Internal"
                                class="w-full px-4 py-3 bg-white border border-gray-300 rounded-xl text-gray-900 placeholder-gray-400 focus:outline-none focus:ring-1 focus:ring-telkom-500 focus:border-telkom-700 text-sm transition">
                        </div>

                        <div class="grid grid-cols-1 sm:grid-cols-2 gap-6">
                            <div>
                                <label for="tanggal_mulai" class="block text-xs font-bold text-gray-500 uppercase tracking-wider mb-2">Tanggal Mulai Pinjam</label>
                                <input type="date" name="tanggal_mulai" id="tanggal_mulai" required
                                    class="w-full px-4 py-3 bg-white border border-gray-300 rounded-xl text-gray-900 focus:outline-none focus:ring-1 focus:ring-telkom-500 focus:border-telkom-700 text-sm transition">
                            </div>
                            <div>
                                <label for="tanggal_selesai" class="block text-xs font-bold text-gray-500 uppercase tracking-wider mb-2">Tanggal Selesai</label>
                                <input type="date" name="tanggal_selesai" id="tanggal_selesai" required
                                    class="w-full px-4 py-3 bg-white border border-gray-300 rounded-xl text-gray-900 focus:outline-none focus:ring-1 focus:ring-telkom-500 focus:border-telkom-700 text-sm transition">
                            </div>
                        </div>

                        <div>
                            <label for="deskripsi" class="block text-xs font-bold text-gray-500 uppercase tracking-wider mb-2">Deskripsi Rencana Kegiatan</label>
                            <textarea name="deskripsi" id="deskripsi" rows="4" required placeholder="Jelaskan secara mendetail tujuan peminjaman..."
                                class="w-full px-4 py-3 bg-white border border-gray-300 rounded-xl text-gray-900 placeholder-gray-400 focus:outline-none focus:ring-1 focus:ring-telkom-500 focus:border-telkom-700 text-sm transition"></textarea>
                        </div>

                        <button type="submit" id="submit-peminjaman" class="w-full py-3.5 px-4 bg-telkom-700 hover:bg-telkom-800 text-white font-bold rounded-xl shadow-sm transition-all duration-150">
                            Kirim Berkas Pengajuan
                        </button>
                    </form>
                </div>
            </section>

            <section id="riwayat-section" class="tab-content hidden space-y-6">
                <div>
                    <h3 class="text-base font-bold text-gray-900">Riwayat Peminjaman</h3>
                    <p class="text-xs text-gray-500">Daftar transaksi dan berkas yang diajukan oleh akun login Anda</p>
                </div>

                <div class="bg-white border border-gray-200 rounded-2xl overflow-hidden shadow-sm">
                    <div class="overflow-x-auto">
                        <table class="w-full text-left border-collapse">
                            <thead>
                                <tr class="bg-gray-50 border-b border-gray-200 text-gray-500 text-xs font-bold uppercase tracking-wider">
                                    <th class="px-6 py-4">ID Transaksi</th>
                                    <th class="px-6 py-4">Nama Kegiatan</th>
                                    <th class="px-6 py-4">Detail Inventaris</th>
                                    <th class="px-6 py-4">Tanggal Peminjaman</th>
                                    <th class="px-6 py-4">Status</th>
                                    <th class="px-6 py-4 text-center">Barcode</th>
                                </tr>
                            </thead>
                             <tbody class="divide-y divide-gray-200 text-sm text-gray-700">
                                </tbody>
                        </table>
                    </div>
                </div>
            </section>

        </div>
    </main>

    <div id="barcode-modal" class="fixed inset-0 z-50 flex items-center justify-center p-4 bg-gray-950/40 backdrop-blur-sm hidden opacity-0 transition-opacity duration-200">
        <div class="bg-white border border-gray-200 w-full max-w-sm rounded-2xl overflow-hidden shadow-xl transform scale-95 transition-transform duration-200">
            <div class="px-6 py-4 border-b border-gray-150 flex justify-between items-center bg-gray-50">
                <h4 class="text-sm font-bold text-gray-900 uppercase tracking-wider">Barcode Peminjaman</h4>
                <button onclick="closeBarcodeModal()" class="text-gray-400 hover:text-gray-600 transition focus:outline-none">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/></svg>
                </button>
            </div>
            
            <div class="p-6 flex flex-col items-center text-center space-y-4">
                <p class="text-xs text-gray-500">Tunjukkan barcode ini kepada petugas logistik di gudang untuk melakukan serah terima inventaris.</p>
                
                <div class="bg-white p-4 rounded-xl border border-gray-200 w-full flex flex-col items-center shadow-sm">
                    <svg class="w-full h-24" viewBox="0 0 100 30" xmlns="http://www.w3.org/2000/svg">
                        <rect width="100" height="30" fill="white"/>
                        <rect x="5" y="2" width="2" height="20" fill="black"/>
                        <rect x="9" y="2" width="1" height="20" fill="black"/>
                        <rect x="12" y="2" width="3" height="20" fill="black"/>
                        <rect x="17" y="2" width="1" height="20" fill="black"/>
                        <rect x="19" y="2" width="2" height="20" fill="black"/>
                        <rect x="23" y="2" width="4" height="20" fill="black"/>
                        <rect x="29" y="2" width="1" height="20" fill="black"/>
                        <rect x="32" y="2" width="2" height="20" fill="black"/>
                        <rect x="36" y="2" width="1" height="20" fill="black"/>
                        <rect x="39" y="2" width="3" height="20" fill="black"/>
                        <rect x="44" y="2" width="2" height="20" fill="black"/>
                        <rect x="48" y="2" width="1" height="20" fill="black"/>
                        <rect x="51" y="2" width="4" height="20" fill="black"/>
                        <rect x="57" y="2" width="2" height="20" fill="black"/>
                        <rect x="61" y="2" width="1" height="20" fill="black"/>
                        <rect x="64" y="2" width="3" height="20" fill="black"/>
                        <rect x="69" y="2" width="2" height="20" fill="black"/>
                        <rect x="73" y="2" width="1" height="20" fill="black"/>
                        <rect x="76" y="2" width="4" height="20" fill="black"/>
                        <rect x="82" y="2" width="2" height="20" fill="black"/>
                        <rect x="86" y="2" width="1" height="20" fill="black"/>
                        <rect x="89" y="2" width="3" height="20" fill="black"/>
                        <rect x="94" y="2" width="2" height="20" fill="black"/>
                        <text x="50" y="27" font-family="monospace" font-size="4" text-anchor="middle" fill="black" id="barcode-display-val">HMTF-881-BAR</text>
                    </svg>
                </div>

                <div class="w-full text-left space-y-1.5 text-xs bg-gray-50 border border-gray-150 p-3.5 rounded-xl">
                    <p class="text-gray-500">ID Peminjaman: <span id="barcode-modal-id" class="text-gray-800 font-semibold font-mono"></span></p>
                    <p class="text-gray-500">Nama Barang: <span id="barcode-modal-item" class="text-gray-800 font-semibold"></span></p>
                </div>

                <button onclick="closeBarcodeModal()" class="w-full py-2 bg-gray-200 hover:bg-gray-300 text-gray-700 text-xs font-semibold rounded-xl transition">
                    Tutup Tampilan
                </button>
            </div>
        </div>
    </div>

    <div id="edit-profile-modal" class="fixed inset-0 z-50 flex items-center justify-center p-4 bg-gray-950/40 backdrop-blur-sm hidden opacity-0 transition-opacity duration-200">
        <div class="bg-white border border-gray-200 w-full max-w-md rounded-2xl overflow-hidden shadow-xl transform scale-95 transition-transform duration-200">
            <div class="px-6 py-4 border-b border-gray-150 flex justify-between items-center bg-gray-50">
                <h4 class="text-sm font-bold text-gray-900 uppercase tracking-wider">Edit Profil</h4>
                <button onclick="closeEditProfileModal()" class="text-gray-400 hover:text-gray-600 transition focus:outline-none">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/></svg>
                </button>
            </div>
            
            <form id="edit-profile-form" class="p-6 space-y-4">
                <div id="modal-error-alert" class="p-3 bg-red-50 border border-red-200 rounded-xl text-red-700 text-xs hidden flex items-start gap-2">
                    <svg class="w-4 h-4 text-red-600 shrink-0 mt-0.5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"/></svg>
                    <span id="modal-error-message" class="font-medium">Nomor handphone tidak boleh kosong!</span>
                </div>

                <div>
                    <label for="modal-nama" class="block text-xs font-bold text-gray-500 uppercase tracking-wider mb-1.5">Nama Lengkap</label>
                    <input type="text" id="modal-nama" value="<%= nama %>" readonly class="w-full px-4 py-2.5 bg-gray-50 border border-gray-250 rounded-xl text-gray-400 text-sm focus:outline-none cursor-not-allowed font-medium">
                </div>

                <div>
                    <label for="modal-nim" class="block text-xs font-bold text-gray-500 uppercase tracking-wider mb-1.5">NIM</label>
                    <input type="text" id="modal-nim" value="<%= nim %>" readonly class="w-full px-4 py-2.5 bg-gray-50 border border-gray-250 rounded-xl text-gray-400 text-sm focus:outline-none cursor-not-allowed font-mono">
                </div>

                <div>
                    <label for="modal-hp" class="block text-xs font-bold text-gray-700 uppercase tracking-wider mb-1.5">Nomor HP</label>
                    <input type="text" id="modal-hp" value="<%= hp %>" required class="w-full px-4 py-2.5 bg-white border border-gray-300 rounded-xl text-gray-900 focus:ring-2 focus:ring-telkom-500/20 focus:border-telkom-700 text-sm transition">
                </div>

                <div class="pt-2 flex gap-3">
                     <button type="button" onclick="closeEditProfileModal()" class="flex-1 py-2.5 bg-gray-100 hover:bg-gray-200 text-gray-700 text-xs font-semibold rounded-xl transition border border-gray-200">Batal</button>
                     <button type="submit" class="flex-1 py-2.5 bg-telkom-700 hover:bg-telkom-800 text-white text-xs font-semibold rounded-xl transition">Simpan</button>
                </div>
            </form>
        </div>
    </div>

    <script>
        // Seed dummy data for visual catalog presentation
        if (!localStorage.getItem("logistel_inventaris")) {
            const defaultInventaris = [
                { id: "B001", nama: "Kamera", tipe: "Barang", stok: 10, deskripsi: "Peralatan dokumentasi resolusi tinggi." },
                { id: "B003", nama: "Mic Wireless", tipe: "Barang", stok: 8, deskripsi: "Paket mikrofon nirkabel beserta receiver suara." },
                { id: "R001", nama: "DSP 301", tipe: "Ruangan", stok: 1, deskripsi: "Ruang kelas dengan fasilitas proyektor, AC." }
            ];
            localStorage.setItem("logistel_inventaris", JSON.stringify(defaultInventaris));
        }

        document.addEventListener("DOMContentLoaded", function() {
            renderRiwayatTable();
            handleFormTypeChange();
        });

        function switchTab(tabId, sectionId) {
            document.querySelectorAll('.tab-content').forEach(section => section.classList.add('hidden'));
            document.getElementById(sectionId).classList.remove('hidden');

            document.querySelectorAll('.nav-link').forEach(link => {
                link.classList.remove('bg-telkom-700', 'text-white', 'active-tab', 'font-medium');
                link.classList.add('text-red-200');
            });

            const targetLink = document.getElementById(tabId);
            targetLink.classList.add('bg-telkom-700', 'text-white', 'active-tab', 'font-medium');
            targetLink.classList.remove('text-red-200');

            let title = "Katalog Inventaris";
            if (sectionId === 'form-section') title = "Form Pengajuan Baru";
            if (sectionId === 'riwayat-section') title = "Riwayat Transaksi Peminjaman";
            document.getElementById('section-title').innerText = title;

            const sidebar = document.getElementById('sidebar');
            sidebar.classList.add('-translate-x-full');
        }

        function toggleMobileSidebar() {
            const sidebar = document.getElementById('sidebar');
            if (sidebar.classList.contains('-translate-x-full')) {
                sidebar.classList.remove('-translate-x-full');
            } else {
                sidebar.classList.add('-translate-x-full');
            }
        }


        function filterCatalog(filterType) {
            document.querySelectorAll('.catalog-filter-btn').forEach(btn => btn.className = "catalog-filter-btn px-4 py-1.5 text-xs font-semibold rounded-lg text-gray-500 hover:text-gray-900 transition");
            document.getElementById(filterType === 'Semua' ? 'filter-all' : filterType === 'Barang' ? 'filter-barang' : 'filter-ruangan').className = "catalog-filter-btn px-4 py-1.5 text-xs font-semibold rounded-lg bg-telkom-700 text-white transition";
            document.querySelectorAll('.catalog-card').forEach(card => {
                if (filterType === 'Semua' || card.getAttribute('data-type') === filterType) card.classList.remove('hidden');
                else card.classList.add('hidden');
            });
        }

        function searchCatalog() {
            const query = document.getElementById('catalog-search').value.toLowerCase().trim();
            document.querySelectorAll('.catalog-card').forEach(card => {
                if (card.getAttribute('data-name').includes(query)) card.classList.remove('hidden');
                else card.classList.add('hidden');
            });
        }

        function populateDropdown(type, selectedItemValue = null) {
            const dropdown = document.getElementById('id_item');
            dropdown.innerHTML = '';
            const inventaris = JSON.parse(localStorage.getItem("logistel_inventaris")) || [];
            inventaris.filter(item => item.tipe === type).forEach(opt => {
                const element = document.createElement('option');
                element.value = opt.id; element.text = opt.nama;
                if (selectedItemValue && opt.nama.toUpperCase().includes(selectedItemValue.toUpperCase())) element.selected = true;
                dropdown.appendChild(element);
            });
        }

        function handleFormTypeChange() {
            const type = document.getElementById('tipe_inventaris').value;
            const qtyContainer = document.getElementById('jumlah-container');
            const qtyInput = document.getElementById('jumlah');
            populateDropdown(type);
            if (type === 'Ruangan') {
                qtyContainer.classList.add('hidden');
                qtyInput.value = '1';
                qtyInput.required = false;
            } else {
                qtyContainer.classList.remove('hidden');
                qtyInput.required = true;
            }
        }

        function quickBorrow(type, itemName) {
            switchTab('form-tab', 'form-section');
            document.getElementById('tipe_inventaris').value = type;
            handleFormTypeChange();
            populateDropdown(type, itemName);
        }

        function openBarcodeModal(id, item, barcodeText) {
            const modal = document.getElementById('barcode-modal');
            document.getElementById('barcode-modal-id').innerText = "#" + id;
            document.getElementById('barcode-modal-item').innerText = item;
            document.getElementById('barcode-display-val').textContent = barcodeText;
            modal.classList.remove('hidden');
            setTimeout(() => { modal.classList.remove('opacity-0'); modal.querySelector('div').classList.remove('scale-95'); }, 10);
        }

        function closeBarcodeModal() {
            const modal = document.getElementById('barcode-modal');
            modal.classList.add('opacity-0'); modal.querySelector('div').classList.add('scale-95');
            setTimeout(() => { modal.classList.add('hidden'); }, 200);
        }

        function openEditProfileModal() {
            const modal = document.getElementById('edit-profile-modal');
            modal.classList.remove('hidden');
            setTimeout(() => { modal.classList.remove('opacity-0'); modal.querySelector('div').classList.remove('scale-95'); }, 10);
        }

        function closeEditProfileModal() {
            const modal = document.getElementById('edit-profile-modal');
            modal.classList.add('opacity-0'); modal.querySelector('div').classList.add('scale-95');
            setTimeout(() => { modal.classList.add('hidden'); }, 200);
        }

        // Dummy render history if exists in localStorage (Nanti diganti JSTL by Backend)
        function renderRiwayatTable() {
            const tbody = document.querySelector("#riwayat-section tbody");
            if (!tbody) return;
            const peminjamans = JSON.parse(localStorage.getItem("logistel_peminjaman")) || [];
            const userPeminjamans = peminjamans.filter(p => p.nim === "<%= nim %>");
            
            if (userPeminjamans.length === 0) {
                tbody.innerHTML = `<tr><td colspan="6" class="px-6 py-8 text-center text-gray-500 font-medium bg-white">Belum ada riwayat pengajuan peminjaman.</td></tr>`;
                return;
            }
            
            tbody.innerHTML = "";
            userPeminjamans.forEach(p => {
                const tr = document.createElement("tr");
                tr.className = "border-b border-gray-150";
                tr.innerHTML = `<td class="px-6 py-4 font-mono text-telkom-700">#${p.id}</td><td class="px-6 py-4 font-semibold text-gray-900">${p.namaKegiatan}</td><td class="px-6 py-4 text-gray-600">${p.itemNama}</td><td class="px-6 py-4 text-gray-500 font-mono text-xs">${p.tanggalMulai}</td><td class="px-6 py-4"><span class="inline-flex items-center gap-1.5 text-xs text-amber-700 font-semibold bg-amber-50 border border-amber-200 px-2.5 py-0.5 rounded-full">PENDING</span></td><td class="px-6 py-4 text-center text-gray-400 font-mono text-xs">-</td>`;
                tbody.appendChild(tr);
            });
        }
    </script>
</body>
</html>