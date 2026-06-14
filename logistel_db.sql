-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jun 14, 2026 at 11:51 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `logistel_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `admin`
--

CREATE TABLE `admin` (
  `id_admin` int(11) NOT NULL,
  `no_pegawai` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `admin`
--

INSERT INTO `admin` (`id_admin`, `no_pegawai`) VALUES
(11, 'PEG-001');

-- --------------------------------------------------------

--
-- Table structure for table `barang`
--

CREATE TABLE `barang` (
  `id_barang` int(11) NOT NULL,
  `nama_barang` varchar(50) NOT NULL,
  `stok` int(11) NOT NULL DEFAULT 10
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `barang`
--

INSERT INTO `barang` (`id_barang`, `nama_barang`, `stok`) VALUES
(1, 'KAMERA', 10),
(2, 'STAND MIC', 10),
(3, 'MIC WIRELESS', 10),
(4, 'BENDERA', 10),
(5, 'NAMPAN', 10),
(6, 'MEJA', 10),
(7, 'SOFA', 17);

-- --------------------------------------------------------

--
-- Table structure for table `detail_peminjaman_barang`
--

CREATE TABLE `detail_peminjaman_barang` (
  `id_detail_peminjaman_barang` int(11) NOT NULL,
  `id_peminjaman` int(11) NOT NULL,
  `id_barang` int(11) NOT NULL,
  `jumlah` int(11) NOT NULL,
  `nama_kegiatan` varchar(100) NOT NULL,
  `deskripsi` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `detail_peminjaman_ruangan`
--

CREATE TABLE `detail_peminjaman_ruangan` (
  `id_detail_peminjaman_ruangan` int(11) NOT NULL,
  `id_peminjaman` int(11) NOT NULL,
  `id_ruangan` int(11) NOT NULL,
  `nama_kegiatan` varchar(100) NOT NULL,
  `deskripsi` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `peminjaman`
--

CREATE TABLE `peminjaman` (
  `id_peminjaman` int(11) NOT NULL,
  `id_user` int(11) NOT NULL,
  `tanggal_mulai` date NOT NULL,
  `tanggal_selesai` date NOT NULL,
  `status` enum('PENDING','APPROVED','REJECTED','RETURNED') NOT NULL DEFAULT 'PENDING',
  `barcode` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `pengguna`
--

CREATE TABLE `pengguna` (
  `id_pengguna` int(11) NOT NULL,
  `nama` varchar(50) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('Admin','User') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `pengguna`
--

INSERT INTO `pengguna` (`id_pengguna`, `nama`, `username`, `password`, `role`) VALUES
(10, 'Amelia Candradewi', 'ameliacandradewi05@gmail.com', '123', 'User'),
(11, 'Administrator Gudang', 'admin_gudang', 'admin123', 'Admin');

-- --------------------------------------------------------

--
-- Table structure for table `ruangan`
--

CREATE TABLE `ruangan` (
  `id_ruangan` int(11) NOT NULL,
  `nama_ruangan` varchar(50) NOT NULL,
  `stok` int(11) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `ruangan`
--

INSERT INTO `ruangan` (`id_ruangan`, `nama_ruangan`, `stok`) VALUES
(1, 'DSP 301', 1),
(2, 'DSP 302', 1),
(3, 'DSP 303', 1),
(4, 'DSP 304', 1),
(5, 'DSP 305', 1),
(6, 'DSP 306', 1),
(7, 'DSP 307', 1),
(8, 'DSP 308', 1),
(9, 'REK 201', 1),
(10, 'REK 202', 1),
(11, 'REK 203', 1),
(12, 'REK 204', 1),
(13, 'REK 205', 1),
(14, 'REK 206', 1),
(15, 'REK 207', 1),
(16, 'REK 301', 1),
(17, 'REK 302', 1),
(18, 'REK 303', 1),
(19, 'REK 304', 1),
(20, 'REK 305', 1),
(21, 'REK 306', 1),
(22, 'REK 307', 1),
(23, 'AULA RACHMAT EFFENDY', 1),
(24, 'IOT 101', 1),
(25, 'IOT 102', 1),
(26, 'IOT 103', 1),
(27, 'IOT 104', 1),
(28, 'IOT 105', 1),
(29, 'TT 101', 1),
(30, 'TT 102', 1),
(31, 'TT 103', 1),
(32, 'TT 104', 1),
(33, 'TT 105', 1),
(34, 'DC 301', 1),
(35, 'DC 302', 1),
(36, 'DC 303', 1),
(37, 'DC 304', 1),
(38, 'DC 305', 1),
(39, 'Parkiran DSP', 1),
(40, 'GOR DI PANDJAITAN', 1);

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE `user` (
  `id_user` int(11) NOT NULL,
  `nim` varchar(20) NOT NULL,
  `nama_ormawa` varchar(50) NOT NULL,
  `no_handphone` varchar(15) NOT NULL,
  `email_sso` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`id_user`, `nim`, `nama_ormawa`, `no_handphone`, `email_sso`) VALUES
(10, '103112400140', 'HMIF', '085156724013', 'ameliacandradewi05@gmail.com');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `admin`
--
ALTER TABLE `admin`
  ADD PRIMARY KEY (`id_admin`),
  ADD UNIQUE KEY `no_pegawai` (`no_pegawai`);

--
-- Indexes for table `barang`
--
ALTER TABLE `barang`
  ADD PRIMARY KEY (`id_barang`),
  ADD UNIQUE KEY `nama_barang` (`nama_barang`);

--
-- Indexes for table `detail_peminjaman_barang`
--
ALTER TABLE `detail_peminjaman_barang`
  ADD PRIMARY KEY (`id_detail_peminjaman_barang`),
  ADD KEY `fk_detail_barang_peminjaman` (`id_peminjaman`),
  ADD KEY `fk_detail_barang_barang` (`id_barang`);

--
-- Indexes for table `detail_peminjaman_ruangan`
--
ALTER TABLE `detail_peminjaman_ruangan`
  ADD PRIMARY KEY (`id_detail_peminjaman_ruangan`),
  ADD KEY `fk_detail_ruangan_peminjaman` (`id_peminjaman`),
  ADD KEY `fk_detail_ruangan_ruangan` (`id_ruangan`);

--
-- Indexes for table `peminjaman`
--
ALTER TABLE `peminjaman`
  ADD PRIMARY KEY (`id_peminjaman`),
  ADD UNIQUE KEY `barcode` (`barcode`),
  ADD KEY `fk_peminjaman_user` (`id_user`);

--
-- Indexes for table `pengguna`
--
ALTER TABLE `pengguna`
  ADD PRIMARY KEY (`id_pengguna`),
  ADD UNIQUE KEY `username` (`username`);

--
-- Indexes for table `ruangan`
--
ALTER TABLE `ruangan`
  ADD PRIMARY KEY (`id_ruangan`),
  ADD UNIQUE KEY `nama_ruangan` (`nama_ruangan`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`id_user`),
  ADD UNIQUE KEY `nim` (`nim`),
  ADD UNIQUE KEY `email_sso` (`email_sso`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `barang`
--
ALTER TABLE `barang`
  MODIFY `id_barang` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `detail_peminjaman_barang`
--
ALTER TABLE `detail_peminjaman_barang`
  MODIFY `id_detail_peminjaman_barang` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `detail_peminjaman_ruangan`
--
ALTER TABLE `detail_peminjaman_ruangan`
  MODIFY `id_detail_peminjaman_ruangan` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `peminjaman`
--
ALTER TABLE `peminjaman`
  MODIFY `id_peminjaman` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `pengguna`
--
ALTER TABLE `pengguna`
  MODIFY `id_pengguna` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `ruangan`
--
ALTER TABLE `ruangan`
  MODIFY `id_ruangan` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=41;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `admin`
--
ALTER TABLE `admin`
  ADD CONSTRAINT `fk_admin_pengguna` FOREIGN KEY (`id_admin`) REFERENCES `pengguna` (`id_pengguna`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `detail_peminjaman_barang`
--
ALTER TABLE `detail_peminjaman_barang`
  ADD CONSTRAINT `fk_detail_barang_barang` FOREIGN KEY (`id_barang`) REFERENCES `barang` (`id_barang`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_detail_barang_peminjaman` FOREIGN KEY (`id_peminjaman`) REFERENCES `peminjaman` (`id_peminjaman`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `detail_peminjaman_ruangan`
--
ALTER TABLE `detail_peminjaman_ruangan`
  ADD CONSTRAINT `fk_detail_ruangan_peminjaman` FOREIGN KEY (`id_peminjaman`) REFERENCES `peminjaman` (`id_peminjaman`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_detail_ruangan_ruangan` FOREIGN KEY (`id_ruangan`) REFERENCES `ruangan` (`id_ruangan`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `peminjaman`
--
ALTER TABLE `peminjaman`
  ADD CONSTRAINT `fk_peminjaman_user` FOREIGN KEY (`id_user`) REFERENCES `user` (`id_user`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `user`
--
ALTER TABLE `user`
  ADD CONSTRAINT `fk_user_pengguna` FOREIGN KEY (`id_user`) REFERENCES `pengguna` (`id_pengguna`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
