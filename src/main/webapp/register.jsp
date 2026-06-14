<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Daftar Akun - LogisTel</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    fontFamily: { sans: ['Outfit', 'sans-serif'] },
                    colors: {
                        telkom: {
                            50: '#fef2f2', 100: '#fee2e2', 500: '#ef4444', 
                            600: '#dc2626', 700: '#b91c1c', 800: '#991b1b', 900: '#7f1d1d'
                        }
                    }
                }
            }
        }
    </script>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>body { font-family: 'Outfit', sans-serif; }</style>
</head>
<body class="bg-gray-50 min-h-screen flex items-center justify-center p-4">

    <div class="w-full max-w-md bg-white rounded-3xl shadow-xl border border-gray-100 overflow-hidden">
        
        <div class="px-8 pt-10 pb-6 flex flex-col items-center text-center">
            <div class="w-16 h-16 rounded-xl bg-telkom-700 p-0.5 shadow-md shadow-red-200 mb-4 flex items-center justify-center">
                <div class="w-full h-full bg-white rounded-[10px] flex items-center justify-center overflow-hidden">
                    <svg class="w-8 h-8 text-telkom-700" fill="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                        <path d="M12 2L2 7v7c0 5.25 4.2 10.13 10 11 5.8-0.87 10-5.75 10-11V7L12 2zm0 4.5c1.38 0 2.5 1.12 2.5 2.5s-1.12 2.5-2.5 2.5-2.5-1.12-2.5-2.5 1.12-2.5 2.5-2.5zm0 15c-3.75-1-6.5-4.57-6.5-8.5V8.55l6.5-3.25 6.5 3.25V13c0 3.93-2.75 7.5-6.5 8.5z"/>
                        <path d="M9 13.5h6v1.5H9z"/>
                    </svg>
                </div>
            </div>
            <h1 class="text-2xl font-bold text-gray-900 tracking-tight">Logis<span class="text-telkom-700">Tel</span></h1>
            <p class="text-[11px] text-gray-500 font-semibold tracking-wide uppercase mt-1 px-4">Portal Peminjaman Ruangan & Barang Telkom University Purwokerto</p>
            <div class="w-12 h-1 bg-telkom-700 rounded-full mt-4"></div>
        </div>

        <% 
            String error = (String) request.getAttribute("error");
            if (error != null) {
        %>
            <div class="mx-8 mb-6 p-4 bg-red-50 border border-red-200 rounded-xl text-red-700 text-sm flex items-start gap-3">
                <svg class="w-5 h-5 text-red-600 shrink-0 mt-0.5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"/></svg>
                <div class="font-medium"><%= error %></div>
            </div>
        <% } %>

        <form action="${pageContext.request.contextPath}/register-process" method="POST" class="px-8 pb-10 space-y-4">
            <div>
                <label class="block text-xs font-bold text-gray-500 uppercase tracking-wider mb-2">Nama Lengkap</label>
                <input type="text" name="nama" required placeholder="Masukkan nama lengkap" class="w-full px-4 py-3 bg-gray-50 border border-gray-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-telkom-500 focus:border-transparent transition text-sm">
            </div>
            <div>
                <label class="block text-xs font-bold text-gray-500 uppercase tracking-wider mb-2">NIM</label>
                <input type="text" name="nim" required maxlength="15" placeholder="Masukkan NIM" 
                    class="w-full px-4 py-3 bg-gray-50 border border-gray-200 rounded-xl ...">
            </div>
            <div>
                <label class="block text-xs font-bold text-gray-500 uppercase tracking-wider mb-2">Email SSO / Username</label>
                <input type="email" name="username" required placeholder="nama@student.telkomuniversity.ac.id" class="w-full px-4 py-3 bg-gray-50 border border-gray-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-telkom-500 focus:border-transparent transition text-sm">
            </div>
            <div>
                <label class="block text-xs font-bold text-gray-500 uppercase tracking-wider mb-2">Nomor Telepon / WhatsApp</label>
                <input type="text" name="no_hp" required placeholder="Contoh: 081234567890" class="w-full px-4 py-3 bg-gray-50 border border-gray-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-telkom-500 focus:border-transparent transition text-sm">
            </div>
            <div>
                <label class="block text-xs font-bold text-gray-500 uppercase tracking-wider mb-2">Password</label>
                <input type="password" name="password" required placeholder="••••••••" class="w-full px-4 py-3 bg-gray-50 border border-gray-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-telkom-500 focus:border-transparent transition text-sm">
            </div>
            <div>
                <label class="block text-xs font-bold text-gray-500 uppercase tracking-wider mb-2">Ormawa / Satker</label>
                <input type="text" name="ormawa" required placeholder="Contoh: HMIF" class="w-full px-4 py-3 bg-gray-50 border border-gray-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-telkom-500 focus:border-transparent transition text-sm">
            </div>

            <button type="submit" class="w-full py-3.5 bg-telkom-700 hover:bg-telkom-800 text-white font-bold rounded-xl transition duration-150 shadow-md shadow-red-100 mt-4">Daftar Sekarang</button>

            <p class="text-center text-xs text-gray-500 mt-6">
                Sudah punya akun? <a href="${pageContext.request.contextPath}/login.jsp" class="text-telkom-700 font-bold hover:underline">Masuk di sini</a>
            </p>
        </form>
    </div>

</body>
</html>