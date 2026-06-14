<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, com.logistel.config.DatabaseConfig" %>
<%
    // 1. Cek Session
    if (session.getAttribute("role") == null || !session.getAttribute("role").equals("Admin")) {
        response.sendRedirect("login.jsp");
        return;
    }

    // 2. Deklarasi Variabel Profil (Mencegah Error 500)
    String nama = (String) session.getAttribute("nama");
    if (nama == null) nama = "Administrator Gudang";

    String initial = "AD";
    if (nama.length() >= 2) initial = nama.substring(0, 2).toUpperCase();

    // Nilai default untuk Admin karena tidak memiliki NIM/Ormawa
    String nim = "PEG-ADMIN"; 
    String ormawa = "Pengelola Logistik";
    String hp = "-";
    String email = (String) session.getAttribute("username");
    if (email == null) email = "admin@logistel.com";

    // 3. Koneksi Database & Query Statistik
    Connection conn = null;
    Statement stmt = null;
    int totalStokBarang = 0, totalRuangan = 0, totalPending = 0;

    try {
        conn = DatabaseConfig.getConnection();
        stmt = conn.createStatement();
        
        ResultSet rsBarang = stmt.executeQuery("SELECT SUM(stok) FROM barang");
        if(rsBarang.next()) totalStokBarang = rsBarang.getInt(1);

        ResultSet rsRuangan = stmt.executeQuery("SELECT COUNT(*) FROM ruangan");
        if(rsRuangan.next()) totalRuangan = rsRuangan.getInt(1);

        ResultSet rsPending = stmt.executeQuery("SELECT COUNT(*) FROM peminjaman WHERE status = 'PENDING'");
        if(rsPending.next()) totalPending = rsPending.getInt(1);
    } catch (Exception e) {
        e.printStackTrace();
    }
%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>LogisTel - Portal Admin</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    fontFamily: { sans: ['Outfit', 'sans-serif'], },
                    colors: {
                        telkom: {
                            50: '#fef2f2', 100: '#fee2e2', 500: '#ef4444',
                            600: '#dc2626', 700: '#b91c1c', 800: '#991b1b', 900: '#7f1d1d',
                        }
                    }
                }
            }
        }
    </script>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>body { font-family: 'Outfit', sans-serif; }</style>
</head>
<body class="bg-gray-50 text-gray-900 min-h-screen flex flex-col md:flex-row relative">

    <aside id="sidebar" class="fixed inset-y-0 left-0 z-30 w-64 bg-telkom-800 text-white flex flex-col justify-between transform -translate-x-full md:translate-x-0 transition-transform duration-300 ease-in-out shadow-lg">
        <div class="flex flex-col h-full">
            <div class="h-16 px-6 border-b border-telkom-900 flex items-center gap-3 shrink-0">
                <div class="w-8 h-8 rounded-lg bg-white flex items-center justify-center text-telkom-800 font-bold text-lg shadow-sm">L</div>
                <span class="text-xl font-bold tracking-tight text-white">Logis<span class="text-red-200">Tel</span></span>
                <span class="bg-red-500 text-white border border-red-400 text-[10px] font-semibold px-2 py-0.5 rounded-full uppercase tracking-wider">Admin</span>
            </div>

            <nav class="flex-1 px-4 py-6 space-y-1.5">
                <button onclick="switchTab('katalog-tab', 'katalog-section')" id="katalog-tab" 
                    class="nav-link w-full flex items-center gap-3 px-4 py-3 rounded-xl transition duration-150 group active-tab bg-telkom-700 text-white font-medium">
                    <svg class="w-5 h-5 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6a2 2 0 012-2h2a2 2 0 012 2v4a2 2 0 01-2 2H6a2 2 0 01-2-2V6zM14 6a2 2 0 012-2h2a2 2 0 012 2v4a2 2 0 01-2 2h-2a2 2 0 01-2-2V6zM4 16a2 2 0 012-2h2a2 2 0 012 2v4a2 2 0 01-2 2H6a2 2 0 01-2-2v-4zM14 16a2 2 0 012-2h2a2 2 0 012 2v4a2 2 0 01-2 2h-2a2 2 0 01-2-2v-4z"></path></svg>
                    <span>Katalog Inventaris</span>
                </button>

                <button onclick="switchTab('verifikasi-tab', 'verifikasi-section')" id="verifikasi-tab" 
                    class="nav-link w-full flex items-center gap-3 px-4 py-3 text-red-200 rounded-xl hover:bg-telkom-700 hover:text-white transition duration-150 group">
                    <svg class="w-5 h-5 text-red-200 group-hover:text-white transition" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2"></path></svg>
                    <span>Verifikasi Peminjaman</span>
                    <% if(totalPending > 0) { %>
                        <span class="ml-auto bg-red-500 text-white text-[10px] font-bold px-2 py-0.5 rounded-full"><%= totalPending %></span>
                    <% } %>
                </button>

                <button onclick="switchTab('pengguna-tab', 'pengguna-section')" id="pengguna-tab" 
                    class="nav-link w-full flex items-center gap-3 px-4 py-3 text-red-200 rounded-xl hover:bg-telkom-700 hover:text-white transition duration-150 group">
                    <svg class="w-5 h-5 text-red-200 group-hover:text-white transition" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M13 7a4 4 0 11-8 0 4 4 0 018 0z"></path></svg>
                    <span>Data Pengguna</span>
                </button>
            </nav>
        </div>

        <div class="p-4 border-t border-telkom-900 shrink-0">
            <button onclick="window.location.href='${pageContext.request.contextPath}/logout-process'" class="flex items-center justify-center gap-2 w-full py-2.5 bg-telkom-900/40 hover:bg-telkom-900/80 text-red-200 hover:text-white font-bold rounded-xl text-sm transition duration-150">
                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1"></path></svg>
                <span>Keluar (Logout)</span>
            </button>
        </div>
    </aside>

    <main class="flex-1 min-h-screen md:pl-64 flex flex-col w-full">
        <header class="h-16 px-6 border-b border-gray-200 bg-white flex items-center justify-between sticky top-0 z-20 shadow-sm">
            <div class="flex items-center gap-4">
                <button onclick="toggleMobileSidebar()" class="md:hidden text-gray-500 hover:text-gray-900 focus:outline-none transition">
                    <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16"></path></svg>
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
                                    <span class="bg-red-100 text-telkom-700 border border-red-200/50 text-[10px] font-bold px-2.5 py-0.5 rounded-full uppercase">Administrator</span>
                                </h3>
                                <p class="text-xs text-gray-500 mt-0.5">Pengelola Sistem Telkom University</p>
                            </div>
                        </div>
                    </div>
                    
                    <div class="grid grid-cols-2 sm:grid-cols-4 gap-4 lg:gap-6 border-t lg:border-t-0 lg:border-l border-gray-200 pt-4 lg:pt-0 lg:pl-6 flex-1">
                        <div>
                            <p class="text-[10px] text-gray-400 uppercase tracking-wider font-bold">ID Pegawai</p>
                            <p class="text-sm font-semibold text-gray-800 font-mono mt-0.5"><%= nim %></p>
                        </div>
                        <div>
                            <p class="text-[10px] text-gray-400 uppercase tracking-wider font-bold">Departemen</p>
                            <p class="text-sm font-semibold text-gray-800 mt-0.5"><%= ormawa %></p>
                        </div>
                        <div>
                            <p class="text-[10px] text-gray-400 uppercase tracking-wider font-bold">Nomor HP</p>
                            <p class="text-sm font-semibold text-gray-800 mt-0.5"><%= hp %></p>
                        </div>
                        <div>
                            <p class="text-[10px] text-gray-400 uppercase tracking-wider font-bold">Email Admin</p>
                            <p class="text-sm font-semibold text-gray-800 truncate mt-0.5" title="<%= email %>"><%= email %></p>
                        </div>
                    </div>
                </div>
            </div>

            <section id="katalog-section" class="tab-content space-y-6">
                <div class="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4">
                    <div class="flex bg-white border border-gray-200 p-1 rounded-xl shadow-sm">
                        <button onclick="filterCatalog('Semua')" id="filter-all" class="catalog-filter-btn px-4 py-1.5 text-xs font-semibold rounded-lg bg-telkom-700 text-white transition">Semua</button>
                        <button onclick="filterCatalog('Barang')" id="filter-barang" class="catalog-filter-btn px-4 py-1.5 text-xs font-semibold rounded-lg text-gray-500 hover:text-gray-900 transition">Barang</button>
                        <button onclick="filterCatalog('Ruangan')" id="filter-ruangan" class="catalog-filter-btn px-4 py-1.5 text-xs font-semibold rounded-lg text-gray-500 hover:text-gray-900 transition">Ruangan</button>
                    </div>
                    
                    <div class="flex items-center gap-3 w-full sm:w-auto">
                        <button onclick="openTambahModal()" class="bg-emerald-600 hover:bg-emerald-700 text-white text-xs font-bold px-4 py-2.5 rounded-xl transition shadow-sm whitespace-nowrap flex items-center gap-1.5">
                            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"></path></svg>
                            Tambah Barang
                        </button>

                        <div class="relative w-full sm:w-64">
                            <input type="text" id="catalog-search" oninput="searchCatalog()" placeholder="Cari nama barang/ruangan..." 
                                class="w-full pl-9 pr-4 py-2.5 bg-white border border-gray-200 rounded-xl text-xs text-gray-900 placeholder-gray-400 focus:outline-none focus:ring-1 focus:ring-telkom-500 focus:border-telkom-700 transition shadow-sm">
                            <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none text-gray-400">
                                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"/></svg>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div id="catalog-grid" class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
                    <%
                        if(conn != null) {
                            try {
                                // --- BARANG ---
                                ResultSet rsKatalog = stmt.executeQuery("SELECT * FROM barang ORDER BY id_barang DESC");
                                while(rsKatalog.next()) {
                                    String id = rsKatalog.getString("id_barang");
                                    String namaBrg = rsKatalog.getString("nama_barang");
                                    int stokBrg = rsKatalog.getInt("stok");
                    %>
                                <div class="catalog-card bg-white border border-gray-200 rounded-2xl p-5 shadow-sm group" data-type="Barang" data-name="<%= namaBrg.toLowerCase() %>">
                                    <h4 class="text-base font-bold text-gray-900 uppercase"><%= namaBrg %></h4>
                                    <p class="text-xs text-gray-500 font-mono mb-4">Stok: <%= stokBrg %></p>
                                    <div class="flex gap-2 border-t pt-3">
                                        <button onclick="openEditModal('<%= id %>', '<%= namaBrg %>', '<%= stokBrg %>', 'barang')" 
                                                class="w-full py-1.5 bg-gray-50 text-gray-600 font-semibold rounded-lg text-xs border border-gray-200">Edit</button>
                                        <button onclick="hapusBarang('<%= id %>')" 
                                                class="w-full py-1.5 bg-red-50 text-red-600 font-semibold rounded-lg text-xs border border-red-200">Hapus</button>
                                    </div>
                                </div>
                    <%          } 

                                // --- RUANGAN ---
                                ResultSet rsRuang = stmt.executeQuery("SELECT * FROM ruangan ORDER BY id_ruangan DESC");
                                while(rsRuang.next()) {
                                    String idR = rsRuang.getString("id_ruangan");
                                    String namaR = rsRuang.getString("nama_ruangan");
                    %>
                                <div class="catalog-card bg-white border border-gray-200 rounded-2xl p-5 shadow-sm group" data-type="Ruangan" data-name="<%= namaR.toLowerCase() %>">
                                    <h4 class="text-base font-bold text-gray-900 uppercase"><%= namaR %></h4>
                                    <p class="text-xs text-gray-500 font-mono mb-4">Ruangan</p>
                                    <div class="flex gap-2 border-t pt-3">
                                        <button onclick="openEditModal('<%= idR %>', '<%= namaR %>', '0', 'ruangan')" 
                                                class="w-full py-1.5 bg-gray-50 text-gray-600 font-semibold rounded-lg text-xs border border-gray-200">Edit</button>
                                    </div>
                                </div>
                    <%          }
                            } catch (Exception e) { e.printStackTrace(); }
                        }
                    %>
                </div>
            </section>

            <section id="verifikasi-section" class="tab-content hidden space-y-6">
                <div>
                    <h3 class="text-base font-bold text-gray-900">Verifikasi Pengajuan Peminjaman</h3>
                    <p class="text-xs text-gray-500">Daftar permintaan peminjaman inventaris yang menunggu persetujuan Anda</p>
                </div>

                <div class="bg-white border border-gray-200 rounded-2xl overflow-hidden shadow-sm">
                    <div class="overflow-x-auto">
                        <table class="w-full text-left border-collapse">
                            <thead>
                                <tr class="bg-gray-50 border-b border-gray-200 text-gray-500 text-xs font-bold uppercase tracking-wider">
                                    <th class="px-6 py-4">ID Transaksi</th>
                                    <th class="px-6 py-4">Nama Ormawa</th>
                                    <th class="px-6 py-4">Kegiatan</th>
                                    <th class="px-6 py-4">Detail Inventaris</th>
                                    <th class="px-6 py-4 text-center">Aksi Verifikasi</th>
                                </tr>
                            </thead>
                            <tbody class="divide-y divide-gray-200 text-sm text-gray-700">
                                <%
                                    if(conn != null) {
                                        ResultSet rsVerif = stmt.executeQuery(
                                            "SELECT p.id_peminjaman, u.nama_ormawa, p.status, dpb.nama_kegiatan, b.nama_barang " +
                                            "FROM peminjaman p " +
                                            "JOIN user u ON p.id_user = u.id_user " +
                                            "JOIN detail_peminjaman_barang dpb ON p.id_peminjaman = dpb.id_peminjaman " +
                                            "JOIN barang b ON dpb.id_barang = b.id_barang " +
                                            "WHERE p.status = 'PENDING'"
                                        );
                                        boolean hasPending = false;
                                        while(rsVerif.next()) {
                                            hasPending = true;
                                %>
                                    <tr>
                                        <td class="px-6 py-4 font-mono font-semibold text-telkom-700">#<%= rsVerif.getString("id_peminjaman") %></td>
                                        <td class="px-6 py-4 font-bold"><%= rsVerif.getString("nama_ormawa") %></td>
                                        <td class="px-6 py-4"><%= rsVerif.getString("nama_kegiatan") %></td>
                                        <td class="px-6 py-4"><%= rsVerif.getString("nama_barang") %></td>
                                        <td class="px-6 py-4 text-center">
                                            <form action="${pageContext.request.contextPath}/verifikasi-servlet" method="POST" class="flex items-center justify-center gap-3">
                                                <input type="hidden" name="id" value="<%= rsVerif.getString("id_peminjaman") %>">
                                                <button name="action" value="APPROVED" class="text-xs font-bold bg-emerald-50 text-emerald-600 hover:bg-emerald-100 border border-emerald-200 px-3 py-1.5 rounded-lg transition">Setujui</button>
                                                <button name="action" value="REJECTED" class="text-xs font-bold bg-red-50 text-red-600 hover:bg-red-100 border border-red-200 px-3 py-1.5 rounded-lg transition">Tolak</button>
                                            </form>
                                        </td>
                                    </tr>
                                <%      } 
                                        if(!hasPending) { %>
                                            <tr><td colspan="5" class="px-6 py-8 text-center text-gray-500 font-medium">Tidak ada pengajuan yang menunggu verifikasi.</td></tr>
                                <%      } 
                                    } %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </section>

            <section id="pengguna-section" class="tab-content hidden space-y-6">
                <div>
                    <h3 class="text-base font-bold text-gray-900">Manajemen Data Pengguna</h3>
                    <p class="text-xs text-gray-500">Seluruh data akun terdaftar di sistem LogisTel</p>
                </div>

                <div class="bg-white border border-gray-200 rounded-2xl overflow-hidden shadow-sm">
                    <div class="overflow-x-auto">
                        <table class="w-full text-left border-collapse">
                            <thead>
                                <tr class="bg-gray-50 border-b border-gray-200 text-gray-500 text-xs font-bold uppercase tracking-wider">
                                    <th class="px-6 py-4">ID</th>
                                    <th class="px-6 py-4">Nama Lengkap</th>
                                    <th class="px-6 py-4">Username / SSO</th>
                                    <th class="px-6 py-4">Role</th>
                                    <th class="px-6 py-4">NIM</th>
                                    <th class="px-6 py-4">Ormawa</th>
                                </tr>
                            </thead>
                            <tbody id="pengguna-table-body" class="divide-y divide-gray-200 text-sm text-gray-700">
                                <%
                                    if(conn != null) {
                                        ResultSet rsUsers = stmt.executeQuery(
                                            "SELECT p.*, u.nim, u.nama_ormawa " +
                                            "FROM pengguna p " +
                                            "LEFT JOIN user u ON p.id_pengguna = u.id_user"
                                        );
                                        while(rsUsers.next()) {
                                %>
                                    <tr class="hover:bg-gray-50/50 transition">
                                        <td class="px-6 py-4 font-mono text-gray-400">#<%= rsUsers.getInt("id_pengguna") %></td>
                                        <td class="px-6 py-4 font-bold text-gray-900"><%= rsUsers.getString("nama") %></td>
                                        <td class="px-6 py-4 text-gray-500"><%= rsUsers.getString("username") %></td>
                                        <td class="px-6 py-4"><span class="px-2.5 py-1 rounded-full text-[10px] font-bold uppercase tracking-wider <%= rsUsers.getString("role").equals("Admin") ? "bg-red-50 text-red-700 border border-red-200" : "bg-gray-100 text-gray-600 border border-gray-200" %>"><%= rsUsers.getString("role") %></span></td>
                                        <td class="px-6 py-4 font-mono text-gray-600"><%= rsUsers.getString("nim") != null ? rsUsers.getString("nim") : "-" %></td>
                                        <td class="px-6 py-4 text-gray-600"><%= rsUsers.getString("nama_ormawa") != null ? rsUsers.getString("nama_ormawa") : "-" %></td>
                                    </tr>
                                <%      } 
                                    } %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </section>

        </div>
    </main>

    <div id="tambah-barang-modal" class="fixed inset-0 z-50 flex items-center justify-center p-4 bg-gray-950/40 backdrop-blur-sm hidden opacity-0 transition-opacity duration-200">
        <div class="bg-white border border-gray-200 w-full max-w-md rounded-2xl overflow-hidden shadow-xl transform scale-95 transition-transform duration-200">
            <div class="px-6 py-4 border-b border-gray-150 flex justify-between items-center bg-gray-50">
                <h4 class="text-sm font-bold text-gray-900 uppercase tracking-wider">Tambah Inventaris Baru</h4>
                <button onclick="closeTambahModal()" class="text-gray-400 hover:text-gray-600 transition focus:outline-none">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/></svg>
                </button>
            </div>
            
            <form action="${pageContext.request.contextPath}/tambah-barang" method="POST" class="p-6 space-y-4">
                <div>
                    <label class="block text-xs font-bold text-gray-700 uppercase tracking-wider mb-1.5">Nama Barang</label>
                    <input type="text" name="nama_barang" required placeholder="Contoh: PROYEKTOR EPSON" 
                           class="w-full px-4 py-2.5 bg-white border border-gray-300 rounded-xl text-gray-900 focus:ring-2 focus:ring-telkom-500/20 focus:border-telkom-700 text-sm transition">
                </div>
                
                <div>
                    <label class="block text-xs font-bold text-gray-700 uppercase tracking-wider mb-1.5">Stok Awal</label>
                    <input type="number" name="stok" min="1" required placeholder="Contoh: 10" 
                           class="w-full px-4 py-2.5 bg-white border border-gray-300 rounded-xl text-gray-900 focus:ring-2 focus:ring-telkom-500/20 focus:border-telkom-700 text-sm transition">
                </div>

                <div class="pt-2 flex gap-3">
                    <button type="button" onclick="closeTambahModal()" class="flex-1 py-2.5 bg-gray-100 hover:bg-gray-200 text-gray-700 text-xs font-semibold rounded-xl transition border border-gray-200">Batal</button>
                    <button type="submit" class="flex-1 py-2.5 bg-emerald-600 hover:bg-emerald-700 text-white text-xs font-semibold rounded-xl transition">Simpan Barang</button>
                </div>
            </form>
        </div>
    </div>

    <div id="edit-modal" class="fixed inset-0 z-50 flex items-center justify-center p-4 bg-gray-950/40 hidden">
        <div class="bg-white p-6 rounded-2xl w-full max-w-md shadow-xl">
            <h4 class="font-bold text-lg mb-4">Edit Data</h4>
            <form action="${pageContext.request.contextPath}/barang-action" method="POST">
                <input type="hidden" name="action" value="edit">
                <input type="hidden" name="id" id="edit-id">
                <input type="hidden" name="type" id="edit-type">
                
                <div class="mb-3">
                    <label class="text-xs font-bold uppercase text-gray-500">Nama</label>
                    <input type="text" name="nama_barang" id="edit-nama" class="w-full border p-2 rounded-xl">
                </div>
                <div class="mb-4">
                    <label class="text-xs font-bold uppercase text-gray-500">Stok</label>
                    <input type="number" name="stok" id="edit-stok" class="w-full border p-2 rounded-xl">
                </div>
                <div class="flex gap-2">
                    <button type="button" onclick="document.getElementById('edit-modal').classList.add('hidden')" class="flex-1 py-2 bg-gray-100 rounded-xl">Batal</button>
                    <button type="submit" class="flex-1 py-2 bg-blue-600 text-white rounded-xl">Simpan</button>
                </div>
            </form>
        </div>
    </div>

    <script>
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
            if (sectionId === 'verifikasi-section') title = "Verifikasi Peminjaman";
            if (sectionId === 'pengguna-section') title = "Data Pengguna Terdaftar";
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
        
        function openTambahModal() {
            const modal = document.getElementById('tambah-barang-modal');
            modal.classList.remove('hidden');
            setTimeout(() => { 
                modal.classList.remove('opacity-0'); 
                modal.querySelector('div').classList.remove('scale-95'); 
            }, 10);
        }

        function closeTambahModal() {
            const modal = document.getElementById('tambah-barang-modal');
            modal.classList.add('opacity-0'); 
            modal.querySelector('div').classList.add('scale-95');
            setTimeout(() => { 
                modal.classList.add('hidden'); 
            }, 200);
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

        function openEditModal(id, nama, stok, type) {
            // Debug: Cek apakah elemen ditemukan
            const editId = document.getElementById('edit-id');
            const editNama = document.getElementById('edit-nama');
            const editStok = document.getElementById('edit-stok');
            const editType = document.getElementById('edit-type');

            if (!editId || !editNama || !editStok) {
                console.error("Error: Salah satu elemen input modal tidak ditemukan di DOM!");
                return;
            }

            editId.value = id;
            editNama.value = nama;
            editStok.value = stok;
            editType.value = type;
            
            document.getElementById('edit-modal').classList.remove('hidden');
        }

        function hapusBarang(id) {
            if(confirm('Yakin ingin menghapus barang ini?')) {
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = '${pageContext.request.contextPath}/barang-action';
                form.innerHTML = '<input type="hidden" name="action" value="hapus"><input type="hidden" name="id" value="'+id+'">';
                document.body.appendChild(form);
                form.submit();
            }
        }
        
        document.addEventListener("DOMContentLoaded", function() {
            if(window.location.search.includes('status=tambah_sukses')) {
                // Notifikasi bisa ditambahkan di sini nantinya
            }
        });
    </script>
</body>
</html>