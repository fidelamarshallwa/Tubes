<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>LogisTel - Masuk Portal Logistik</title>
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
        body {
            font-family: 'Outfit', sans-serif;
        }
    </style>
</head>
<body class="bg-gray-50 text-gray-900 min-h-screen flex items-center justify-center p-4 relative overflow-hidden">
    <div class="absolute top-0 left-0 right-0 h-2 bg-gradient-to-r from-telkom-700 to-red-500"></div>

    <div class="w-full max-w-md z-10">
        <div class="bg-white border border-gray-200 rounded-2xl p-8 shadow-sm transition-all duration-300 hover:shadow-md">
            
            <div class="flex flex-col items-center text-center mb-8">
                <div class="w-16 h-16 rounded-xl bg-telkom-700 p-0.5 shadow-sm mb-4 flex items-center justify-center">
                    <div class="w-full h-full bg-white rounded-[10px] flex items-center justify-center overflow-hidden relative group">
                        <svg class="w-8 h-8 text-telkom-700 transform group-hover:scale-110 transition-transform duration-300" fill="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                            <path d="M12 2L2 7v7c0 5.25 4.2 10.13 10 11 5.8-0.87 10-5.75 10-11V7L12 2zm0 4.5c1.38 0 2.5 1.12 2.5 2.5s-1.12 2.5-2.5 2.5-2.5-1.12-2.5-2.5 1.12-2.5 2.5-2.5zm0 15c-3.75-1-6.5-4.57-6.5-8.5V8.55l6.5-3.25 6.5 3.25V13c0 3.93-2.75 7.5-6.5 8.5z"/>
                            <path d="M9 13.5h6v1.5H9z"/>
                        </svg>
                    </div>
                </div>
                <h1 class="text-2xl font-bold text-gray-900 tracking-tight">Logis<span class="text-telkom-700">Tel</span></h1>
                <p class="text-xs text-gray-500 font-semibold tracking-wide uppercase mt-1">Portal Peminjaman Ruangan & Barang Telkom University Purwokerto</p>
                <div class="w-12 h-1 bg-telkom-700 rounded-full mt-3"></div>
            </div>

            <% 
                String error = (String) request.getAttribute("error");
                if (error != null) {
            %>
                <div class="mb-6 p-4 bg-red-50 border border-red-200 rounded-xl text-red-700 text-sm flex items-start gap-3 transition-all duration-200">
                    <svg class="w-5 h-5 text-red-600 shrink-0 mt-0.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"/>
                    </svg>
                    <div class="font-medium"><%= error %></div>
                </div>
            <% 
                } 
            %>

            <form action="${pageContext.request.contextPath}/login-process" method="POST" class="px-8 pb-10 space-y-4">
                <div>
                    <label for="username" class="block text-xs font-bold text-gray-700 uppercase tracking-wider mb-2">Username / Email SSO</label>
                    <div class="relative">
                        <div class="absolute inset-y-0 left-0 pl-3.5 flex items-center pointer-events-none text-gray-400">
                            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"></path>
                            </svg>
                        </div>
                        <input type="text" name="username" id="username" placeholder="username@student.telkomuniversity.ac.id" required
                            class="w-full pl-11 pr-4 py-3 bg-white border border-gray-300 rounded-xl text-gray-900 placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-telkom-500/20 focus:border-telkom-700 transition-all duration-200 text-sm">
                    </div>
                </div>

                <div>
                    <div class="flex justify-between items-center mb-2">
                        <label for="password" class="block text-xs font-bold text-gray-700 uppercase tracking-wider">Kata Sandi</label>
                        <a href="#" class="text-xs text-telkom-700 hover:text-telkom-800 font-semibold transition">Lupa password?</a>
                    </div>
                    <div class="relative">
                        <div class="absolute inset-y-0 left-0 pl-3.5 flex items-center pointer-events-none text-gray-400">
                            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z"></path>
                            </svg>
                        </div>
                        <input type="password" name="password" id="password" placeholder="••••••••" required
                            class="w-full pl-11 pr-11 py-3 bg-white border border-gray-300 rounded-xl text-gray-900 placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-telkom-500/20 focus:border-telkom-700 transition-all duration-200 text-sm">
                        <button type="button" onclick="togglePasswordVisibility()" class="absolute inset-y-0 right-0 pr-3.5 flex items-center text-gray-400 hover:text-gray-600 focus:outline-none transition">
                            <svg id="eye-icon" class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"></path>
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"></path>
                            </svg>
                        </button>
                    </div>
                </div>

                <div>
                    <label for="role" class="block text-xs font-bold text-gray-700 uppercase tracking-wider mb-2">Pilih Peran (Role)</label>
                    <div class="relative">
                        <div class="absolute inset-y-0 left-0 pl-3.5 flex items-center pointer-events-none text-gray-400">
                            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0z"></path>
                            </svg>
                        </div>
                        <select name="role" id="role" required
                            class="w-full pl-11 pr-10 py-3 bg-white border border-gray-300 rounded-xl text-gray-700 focus:outline-none focus:ring-2 focus:ring-telkom-500/20 focus:border-telkom-700 appearance-none transition-all duration-200 cursor-pointer text-sm">
                            <option value="" disabled selected class="text-gray-400">-- Pilih Role --</option>
                            <option value="Admin" class="text-gray-900">Admin (Pengelola)</option>
                            <option value="User" class="text-gray-900">User (Mahasiswa / Ormawa)</option>
                        </select>
                        <div class="absolute inset-y-0 right-0 flex items-center pr-3 pointer-events-none text-gray-400">
                            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"></path>
                            </svg>
                        </div>
                    </div>
                </div>

                <button type="submit"
                    class="w-full py-3 px-4 bg-telkom-700 hover:bg-telkom-800 text-white font-bold rounded-xl shadow-sm hover:shadow transition-all duration-150 text-sm">
                    Masuk ke Akun
                </button>
                <p class="text-center text-xs text-gray-500 mt-6">
                    Belum punya akun? <a href="${pageContext.request.contextPath}/register.jsp" class="text-telkom-700 font-bold hover:underline">Daftar di sini</a>
                </p>
            </form>
        </div>

        <p class="text-center text-gray-400 text-xs mt-6">
            &copy; 2026 LogisTel - Universitas Telkom. Hak Cipta Dilindungi.
        </p>
    </div>

    <script>
        function togglePasswordVisibility() {
            const passwordInput = document.getElementById('password');
            const eyeIcon = document.getElementById('eye-icon');
            
            if (passwordInput.type === 'password') {
                passwordInput.type = 'text';
                eyeIcon.innerHTML = `
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13.875 18.825A10.05 10.05 0 0112 19c-4.478 0-8.268-2.943-9.543-7a9.97 9.97 0 011.563-3.029m5.858.908a3 3 0 114.243 4.243M9.878 9.878l4.242 4.242M9.88 9.88l-3.29-3.29m7.532 7.532l3.29 3.29M3 3l3.59 3.59m0 0A9.953 9.953 0 0112 5c4.478 0 8.268 2.943 9.543 7a10.025 10.025 0 01-4.132 5.411m0 0L21 21" />
                `;
            } else {
                passwordInput.type = 'password';
                eyeIcon.innerHTML = `
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"></path>
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"></path>
                `;
            }
        }
    </script>
</body>
</html>