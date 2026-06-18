-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jun 18, 2026 at 09:54 AM
-- Server version: 10.4.27-MariaDB
-- PHP Version: 7.4.33

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `sipakar360_laporan`
--

-- --------------------------------------------------------

--
-- Table structure for table `akhlak_values`
--

CREATE TABLE `akhlak_values` (
  `akhlak_id` int(11) NOT NULL,
  `akhlak_name` varchar(80) NOT NULL,
  `akhlak_description` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `akhlak_values`
--

INSERT INTO `akhlak_values` (`akhlak_id`, `akhlak_name`, `akhlak_description`) VALUES
(1, 'Amanah', 'Memegang teguh kepercayaan yang diberikan'),
(2, 'Kompeten', 'Terus belajar dan mengembangkan kapabilitas'),
(3, 'Harmonis', 'Saling peduli dan menghargai perbedaan'),
(4, 'Loyal', 'Berdedikasi dan mengutamakan kepentingan bangsa dan negara'),
(5, 'Adaptif', 'Terus berinovasi dan antusias dalam menggerakkan perubahan'),
(6, 'Kolaboratif', 'Membangun kerja sama yang sinergis');

-- --------------------------------------------------------

--
-- Table structure for table `assessments`
--

CREATE TABLE `assessments` (
  `assessment_id` int(11) NOT NULL,
  `evaluator_id` int(11) NOT NULL,
  `evaluatee_id` int(11) NOT NULL,
  `period_id` int(11) NOT NULL,
  `assessment_type` varchar(50) NOT NULL,
  `assessment_date` date DEFAULT NULL,
  `assessment_status` varchar(30) DEFAULT 'draft'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `assessments`
--

INSERT INTO `assessments` (`assessment_id`, `evaluator_id`, `evaluatee_id`, `period_id`, `assessment_type`, `assessment_date`, `assessment_status`) VALUES
(1, 4, 4, 1, 'self', '2026-06-01', 'submitted'),
(2, 5, 4, 1, 'peer', '2026-06-02', 'submitted'),
(3, 6, 4, 1, 'peer', '2026-06-03', 'submitted'),
(4, 3, 4, 1, 'supervisor', '2026-06-04', 'submitted'),
(5, 4, 5, 1, 'peer', '2026-06-03', 'submitted'),
(6, 3, 5, 1, 'supervisor', '2026-06-04', 'submitted'),
(7, 5, 5, 1, 'self', '2026-06-01', 'submitted'),
(8, 3, 6, 1, 'supervisor', '2026-06-04', 'submitted'),
(9, 6, 6, 1, 'self', '2026-06-01', 'submitted'),
(10, 4, 8, 1, 'peer', '2026-06-05', 'submitted'),
(11, 8, 8, 1, 'self', '2026-06-05', 'submitted'),
(12, 3, 8, 1, 'supervisor', '2026-06-05', 'submitted'),
(13, 4, 3, 1, 'subordinate', '2026-06-06', 'submitted'),
(14, 8, 3, 1, 'subordinate', '2026-06-06', 'submitted'),
(15, 3, 3, 1, 'self', '2026-06-06', 'submitted'),
(16, 1, 1, 1, 'self', '2026-06-18', 'submitted'),
(17, 2, 2, 1, 'self', '2026-06-18', 'submitted'),
(18, 2, 1, 1, 'subordinate', '2026-06-18', 'submitted');

-- --------------------------------------------------------

--
-- Table structure for table `assessment_details`
--

CREATE TABLE `assessment_details` (
  `assessment_detail_id` int(11) NOT NULL,
  `assessment_id` int(11) NOT NULL,
  `question_id` int(11) NOT NULL,
  `score` int(11) NOT NULL,
  `comment` varchar(500) DEFAULT NULL
) ;

--
-- Dumping data for table `assessment_details`
--

INSERT INTO `assessment_details` (`assessment_detail_id`, `assessment_id`, `question_id`, `score`, `comment`) VALUES
(1, 1, 1, 5, ''),
(2, 1, 2, 4, ''),
(3, 1, 3, 5, ''),
(4, 1, 4, 4, ''),
(5, 1, 5, 4, ''),
(6, 1, 6, 5, ''),
(7, 1, 7, 4, ''),
(8, 1, 8, 4, ''),
(9, 1, 9, 5, ''),
(10, 1, 10, 4, ''),
(11, 1, 11, 5, ''),
(12, 1, 12, 4, ''),
(13, 2, 1, 4, ''),
(14, 2, 2, 4, ''),
(15, 2, 3, 5, ''),
(16, 2, 4, 5, ''),
(17, 2, 5, 4, ''),
(18, 2, 6, 4, ''),
(19, 2, 7, 4, ''),
(20, 2, 8, 5, ''),
(21, 2, 9, 4, ''),
(22, 2, 10, 4, ''),
(23, 2, 11, 5, ''),
(24, 2, 12, 5, ''),
(25, 3, 1, 5, ''),
(26, 3, 2, 5, ''),
(27, 3, 3, 4, ''),
(28, 3, 4, 4, ''),
(29, 3, 5, 4, ''),
(30, 3, 6, 5, ''),
(31, 3, 7, 5, ''),
(32, 3, 8, 4, ''),
(33, 3, 9, 4, ''),
(34, 3, 10, 5, ''),
(35, 3, 11, 4, ''),
(36, 3, 12, 5, ''),
(37, 4, 1, 5, ''),
(38, 4, 2, 5, ''),
(39, 4, 3, 5, ''),
(40, 4, 4, 5, ''),
(41, 4, 5, 4, ''),
(42, 4, 6, 5, ''),
(43, 4, 7, 5, ''),
(44, 4, 8, 5, ''),
(45, 4, 9, 4, ''),
(46, 4, 10, 5, ''),
(47, 4, 11, 5, ''),
(48, 4, 12, 5, ''),
(49, 5, 1, 4, ''),
(50, 5, 2, 4, ''),
(51, 5, 3, 4, ''),
(52, 5, 4, 3, ''),
(53, 5, 5, 5, ''),
(54, 5, 6, 4, ''),
(55, 5, 7, 4, ''),
(56, 5, 8, 4, ''),
(57, 5, 9, 4, ''),
(58, 5, 10, 3, ''),
(59, 5, 11, 4, ''),
(60, 5, 12, 5, ''),
(61, 6, 1, 4, ''),
(62, 6, 2, 4, ''),
(63, 6, 3, 4, ''),
(64, 6, 4, 4, ''),
(65, 6, 5, 5, ''),
(66, 6, 6, 4, ''),
(67, 6, 7, 4, ''),
(68, 6, 8, 4, ''),
(69, 6, 9, 4, ''),
(70, 6, 10, 4, ''),
(71, 6, 11, 4, ''),
(72, 6, 12, 5, ''),
(73, 7, 1, 4, ''),
(74, 7, 2, 4, ''),
(75, 7, 3, 4, ''),
(76, 7, 4, 4, ''),
(77, 7, 5, 5, ''),
(78, 7, 6, 5, ''),
(79, 7, 7, 4, ''),
(80, 7, 8, 4, ''),
(81, 7, 9, 4, ''),
(82, 7, 10, 4, ''),
(83, 7, 11, 4, ''),
(84, 7, 12, 5, ''),
(85, 8, 1, 4, ''),
(86, 8, 2, 4, ''),
(87, 8, 3, 4, ''),
(88, 8, 4, 4, ''),
(89, 8, 5, 4, ''),
(90, 8, 6, 4, ''),
(91, 8, 7, 4, ''),
(92, 8, 8, 4, ''),
(93, 8, 9, 3, ''),
(94, 8, 10, 4, ''),
(95, 8, 11, 4, ''),
(96, 8, 12, 4, ''),
(97, 9, 1, 4, ''),
(98, 9, 2, 4, ''),
(99, 9, 3, 4, ''),
(100, 9, 4, 4, ''),
(101, 9, 5, 4, ''),
(102, 9, 6, 4, ''),
(103, 9, 7, 4, ''),
(104, 9, 8, 4, ''),
(105, 9, 9, 4, ''),
(106, 9, 10, 4, ''),
(107, 9, 11, 4, ''),
(108, 9, 12, 4, ''),
(109, 10, 1, 5, ''),
(110, 10, 2, 4, ''),
(111, 10, 3, 4, ''),
(112, 10, 4, 4, ''),
(113, 10, 5, 4, ''),
(114, 10, 6, 4, ''),
(115, 10, 7, 4, ''),
(116, 10, 8, 4, ''),
(117, 10, 9, 5, ''),
(118, 10, 10, 4, ''),
(119, 10, 11, 4, ''),
(120, 10, 12, 5, ''),
(121, 11, 1, 5, ''),
(122, 11, 2, 4, ''),
(123, 11, 3, 5, ''),
(124, 11, 4, 4, ''),
(125, 11, 5, 4, ''),
(126, 11, 6, 4, ''),
(127, 11, 7, 4, ''),
(128, 11, 8, 4, ''),
(129, 11, 9, 5, ''),
(130, 11, 10, 5, ''),
(131, 11, 11, 4, ''),
(132, 11, 12, 5, ''),
(133, 12, 1, 5, ''),
(134, 12, 2, 5, ''),
(135, 12, 3, 5, ''),
(136, 12, 4, 5, ''),
(137, 12, 5, 4, ''),
(138, 12, 6, 4, ''),
(139, 12, 7, 5, ''),
(140, 12, 8, 5, ''),
(141, 12, 9, 5, ''),
(142, 12, 10, 5, ''),
(143, 12, 11, 5, ''),
(144, 12, 12, 5, ''),
(145, 13, 1, 4, ''),
(146, 13, 2, 4, ''),
(147, 13, 3, 4, ''),
(148, 13, 4, 4, ''),
(149, 13, 5, 4, ''),
(150, 13, 6, 4, ''),
(151, 13, 7, 4, ''),
(152, 13, 8, 4, ''),
(153, 13, 9, 4, ''),
(154, 13, 10, 4, ''),
(155, 13, 11, 5, ''),
(156, 13, 12, 5, ''),
(157, 14, 1, 5, ''),
(158, 14, 2, 4, ''),
(159, 14, 3, 4, ''),
(160, 14, 4, 4, ''),
(161, 14, 5, 5, ''),
(162, 14, 6, 4, ''),
(163, 14, 7, 4, ''),
(164, 14, 8, 4, ''),
(165, 14, 9, 5, ''),
(166, 14, 10, 4, ''),
(167, 14, 11, 5, ''),
(168, 14, 12, 5, ''),
(169, 15, 1, 4, ''),
(170, 15, 2, 4, ''),
(171, 15, 3, 4, ''),
(172, 15, 4, 5, ''),
(173, 15, 5, 4, ''),
(174, 15, 6, 4, ''),
(175, 15, 7, 5, ''),
(176, 15, 8, 4, ''),
(177, 15, 9, 4, ''),
(178, 15, 10, 4, ''),
(179, 15, 11, 4, ''),
(180, 15, 12, 4, ''),
(206, 18, 1, 5, ''),
(207, 18, 2, 5, ''),
(208, 18, 3, 4, ''),
(209, 18, 4, 3, ''),
(210, 18, 5, 3, ''),
(211, 18, 6, 2, ''),
(212, 18, 7, 2, ''),
(213, 18, 8, 3, ''),
(214, 18, 9, 4, ''),
(215, 18, 10, 3, ''),
(216, 18, 11, 4, ''),
(217, 18, 12, 3, ''),
(218, 18, 13, 4, ''),
(219, 17, 1, 1, ''),
(220, 17, 2, 2, ''),
(221, 17, 3, 3, ''),
(222, 17, 4, 4, ''),
(223, 17, 5, 5, ''),
(224, 17, 6, 4, ''),
(225, 17, 7, 3, ''),
(226, 17, 8, 2, ''),
(227, 17, 9, 1, ''),
(228, 17, 10, 2, ''),
(229, 17, 11, 3, ''),
(230, 17, 12, 5, ''),
(231, 17, 13, 4, ''),
(258, 16, 1, 4, ''),
(259, 16, 2, 4, ''),
(260, 16, 3, 4, ''),
(261, 16, 4, 4, ''),
(262, 16, 5, 4, ''),
(263, 16, 6, 4, ''),
(264, 16, 7, 4, ''),
(265, 16, 8, 4, ''),
(266, 16, 9, 4, ''),
(267, 16, 10, 4, ''),
(268, 16, 11, 4, ''),
(269, 16, 12, 4, ''),
(270, 16, 13, 4, '');

-- --------------------------------------------------------

--
-- Table structure for table `audit_logs`
--

CREATE TABLE `audit_logs` (
  `log_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `activity` varchar(255) NOT NULL,
  `activity_time` datetime NOT NULL,
  `ip_address` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `audit_logs`
--

INSERT INTO `audit_logs` (`log_id`, `user_id`, `activity`, `activity_time`, `ip_address`) VALUES
(1, 1, 'Seed database imported', '2026-06-17 17:25:12', '127.0.0.1'),
(2, 2, 'Membuat periode evaluasi AKHLAK', '2026-06-17 17:25:12', '127.0.0.1'),
(3, 3, 'Memvalidasi peer assignment tim Operations', '2026-06-17 17:25:12', '127.0.0.1'),
(4, 8, 'Mengisi self-assessment', '2026-06-17 17:25:12', '127.0.0.1'),
(5, 1, 'Simpan periode evaluasi', '2026-06-17 17:25:32', '::1'),
(6, 1, 'Membuat notifikasi', '2026-06-17 17:28:53', '::1'),
(7, 1, 'Simpan periode evaluasi', '2026-06-17 17:29:01', '::1'),
(8, 1, 'Kelola pertanyaan AKHLAK', '2026-06-17 17:29:20', '::1'),
(9, 1, 'Tambah karyawan Joko Knalpot', '2026-06-17 17:32:00', '::1'),
(10, 1, 'Kelola pertanyaan AKHLAK', '2026-06-17 17:33:12', '::1'),
(11, 1, 'Tambah periode evaluasi Evaluasi AKHLAK Semester 3 2026', '2026-06-17 17:34:28', '::1'),
(12, 1, 'Update peer assignment', '2026-06-17 17:34:59', '::1'),
(13, 1, 'Submit assessment Self Assessment', '2026-06-17 17:35:16', '::1'),
(14, 1, 'Update karyawan Anggit', '2026-06-17 17:37:07', '::1'),
(15, 1, 'Update karyawan Salsabila Kirana', '2026-06-17 17:37:12', '::1'),
(16, 1, 'Update karyawan Rama Pratama', '2026-06-17 17:37:16', '::1'),
(17, 1, 'Update karyawan Dimas Nugraha', '2026-06-17 17:37:20', '::1'),
(18, 1, 'Update karyawan Nadia Maharani', '2026-06-17 17:37:25', '::1'),
(19, 1, 'Update karyawan Bima Arya', '2026-06-17 17:37:30', '::1'),
(20, 1, 'Update karyawan Intan Wulandari', '2026-06-17 17:37:35', '::1'),
(21, 1, 'Update karyawan Gifary', '2026-06-17 17:37:42', '::1'),
(22, 1, 'Update karyawan Daffa Sayyid Zahran', '2026-06-17 17:37:47', '::1'),
(23, 1, 'Update karyawan Anggit', '2026-06-17 17:37:51', '::1'),
(24, 1, 'Logout dari sistem', '2026-06-17 17:37:55', '::1'),
(25, 8, 'Login berhasil sebagai Karyawan', '2026-06-17 17:38:36', '::1'),
(26, 8, 'Logout dari sistem', '2026-06-17 17:38:56', '::1'),
(27, 1, 'Login berhasil sebagai Admin HR', '2026-06-17 17:39:30', '::1'),
(28, 1, 'Tambah pertanyaan AKHLAK', '2026-06-17 17:39:53', '::1'),
(29, 1, 'Tambah peer assignment', '2026-06-17 17:40:18', '::1'),
(30, 1, 'Logout dari sistem', '2026-06-17 18:01:23', '::1'),
(31, 1, 'Login berhasil sebagai Admin HR', '2026-06-17 18:02:05', '::1'),
(32, 1, 'Logout dari sistem', '2026-06-17 18:07:39', '::1'),
(33, 1, 'Login berhasil sebagai Admin HR', '2026-06-17 18:13:01', '::1'),
(34, 1, 'Logout dari sistem', '2026-06-17 18:20:04', '::1'),
(35, 1, 'Login berhasil sebagai Admin HR', '2026-06-17 18:22:23', '::1'),
(36, 1, 'Logout dari sistem', '2026-06-17 18:31:39', '::1'),
(37, 8, 'Login berhasil sebagai Karyawan', '2026-06-17 18:33:20', '::1'),
(38, 8, 'Logout dari sistem', '2026-06-17 18:35:34', '::1'),
(39, 3, 'Login berhasil sebagai Atasan', '2026-06-17 18:35:38', '::1'),
(40, 3, 'Logout dari sistem', '2026-06-17 18:35:46', '::1'),
(41, 2, 'Login berhasil sebagai Admin HR', '2026-06-17 18:35:52', '::1'),
(42, 2, 'Logout dari sistem', '2026-06-17 18:36:01', '::1'),
(43, 3, 'Login berhasil sebagai Atasan', '2026-06-17 18:36:05', '::1'),
(44, 3, 'Logout dari sistem', '2026-06-17 18:38:10', '::1'),
(45, 4, 'Login berhasil sebagai Karyawan', '2026-06-17 18:38:15', '::1'),
(46, 4, 'Logout dari sistem', '2026-06-17 18:41:56', '::1'),
(47, 1, 'Login berhasil sebagai Admin HR', '2026-06-17 18:41:58', '::1'),
(48, 1, 'Logout dari sistem', '2026-06-17 18:43:12', '::1'),
(49, 3, 'Login berhasil sebagai Atasan', '2026-06-17 18:43:17', '::1'),
(50, 3, 'Logout dari sistem', '2026-06-17 18:45:52', '::1'),
(51, 4, 'Login berhasil sebagai Karyawan', '2026-06-17 18:45:57', '::1'),
(52, 4, 'Logout dari sistem', '2026-06-17 20:06:46', '::1'),
(53, 1, 'Login berhasil sebagai Admin HR', '2026-06-17 20:06:49', '::1'),
(54, 1, 'Logout dari sistem', '2026-06-17 20:36:55', '::1'),
(55, 8, 'Login berhasil sebagai Karyawan', '2026-06-17 20:37:11', '::1'),
(56, 8, 'Logout dari sistem', '2026-06-17 20:40:13', '::1'),
(57, 7, 'Login berhasil sebagai Manajemen', '2026-06-17 20:40:21', '::1'),
(58, 7, 'Logout dari sistem', '2026-06-17 21:12:57', '::1'),
(59, 3, 'Login berhasil sebagai Atasan', '2026-06-17 21:13:50', '::1'),
(60, 3, 'Logout dari sistem', '2026-06-17 21:30:42', '::1'),
(61, 7, 'Login berhasil sebagai Manajemen', '2026-06-17 21:31:26', '::1'),
(62, 7, 'Logout dari sistem', '2026-06-17 21:32:49', '::1'),
(63, 3, 'Login berhasil sebagai Atasan', '2026-06-17 21:33:07', '::1'),
(64, 3, 'Logout dari sistem', '2026-06-17 21:34:12', '::1'),
(65, 8, 'Login berhasil sebagai Karyawan', '2026-06-17 21:34:34', '::1'),
(66, 8, 'Logout dari sistem', '2026-06-18 11:56:40', '::1'),
(67, 2, 'Login berhasil sebagai Admin HR', '2026-06-18 12:26:23', '::1'),
(68, 2, 'Submit assessment Self Assessment', '2026-06-18 12:28:58', '::1'),
(69, 2, 'Submit assessment Penilaian Bawahan', '2026-06-18 12:29:25', '::1'),
(70, 2, 'Submit assessment Self Assessment', '2026-06-18 12:29:50', '::1'),
(71, 2, 'Logout dari sistem', '2026-06-18 13:35:43', '::1'),
(72, 1, 'Login berhasil sebagai Admin HR', '2026-06-18 13:37:21', '::1'),
(73, 1, 'Update karyawan Muhammad Gifary', '2026-06-18 13:37:50', '::1'),
(74, 1, 'Update karyawan Rama Pratama', '2026-06-18 13:39:47', '::1'),
(75, 1, 'Update karyawan Dimas Nugraha', '2026-06-18 13:40:00', '::1'),
(76, 1, 'Update karyawan Nadia Maharani', '2026-06-18 13:40:14', '::1'),
(77, 1, 'Update karyawan Asep Dendeng', '2026-06-18 13:41:01', '::1'),
(78, 1, 'Update karyawan Rama Pratama', '2026-06-18 13:41:22', '::1'),
(79, 1, 'Update karyawan Anggit', '2026-06-18 13:41:33', '::1'),
(80, 1, 'Update karyawan Joko Knalpot', '2026-06-18 13:41:55', '::1'),
(81, 1, 'Update karyawan Rama Pratama', '2026-06-18 13:43:34', '::1'),
(82, 1, 'Update karyawan Dimas Nugraha', '2026-06-18 13:43:57', '::1'),
(83, 1, 'Update karyawan Asep Dendeng', '2026-06-18 13:44:19', '::1'),
(84, 1, 'Update karyawan Asep Dendeng', '2026-06-18 13:44:30', '::1'),
(85, 1, 'Update karyawan Joko Knalpot', '2026-06-18 13:45:08', '::1'),
(86, 1, 'Update karyawan Bima Arya', '2026-06-18 13:45:42', '::1'),
(87, 1, 'Update karyawan Muhammad Gifary', '2026-06-18 13:46:33', '::1'),
(88, 1, 'Update karyawan Rama Pratama', '2026-06-18 13:46:39', '::1'),
(89, 1, 'Update karyawan Dimas Nugraha', '2026-06-18 13:46:46', '::1'),
(90, 1, 'Update karyawan Nadia Maharani', '2026-06-18 13:46:53', '::1'),
(91, 1, 'Logout dari sistem', '2026-06-18 13:47:58', '::1'),
(92, 1, 'Login berhasil sebagai Admin HR', '2026-06-18 13:57:10', '::1'),
(93, 1, 'Submit assessment Self Assessment', '2026-06-18 14:08:42', '::1'),
(94, 1, 'Submit assessment Self Assessment', '2026-06-18 14:09:05', '::1'),
(95, 1, 'Submit assessment Self Assessment', '2026-06-18 14:09:10', '::1'),
(96, 1, 'Update periode evaluasi Evaluasi AKHLAK Semester 1 2026', '2026-06-18 14:16:50', '::1'),
(97, 1, 'Update periode evaluasi Evaluasi AKHLAK Semester 2 2026', '2026-06-18 14:17:12', '::1'),
(98, 1, 'Tambah peer assignment', '2026-06-18 14:18:10', '::1'),
(99, 1, 'Update peer assignment', '2026-06-18 14:18:17', '::1'),
(100, 1, 'Logout dari sistem', '2026-06-18 14:18:34', '::1'),
(101, 8, 'Login berhasil sebagai Karyawan', '2026-06-18 14:18:39', '::1'),
(102, 8, 'Logout dari sistem', '2026-06-18 14:19:22', '::1'),
(103, 1, 'Login berhasil sebagai Admin HR', '2026-06-18 14:19:27', '::1'),
(104, 1, 'Hapus/batalkan peer assignment', '2026-06-18 14:21:34', '::1'),
(105, 1, 'Hapus/batalkan peer assignment', '2026-06-18 14:21:35', '::1'),
(106, 1, 'Hapus/batalkan peer assignment', '2026-06-18 14:21:37', '::1'),
(107, 1, 'Hapus/batalkan peer assignment', '2026-06-18 14:21:38', '::1'),
(108, 1, 'Hapus/batalkan peer assignment', '2026-06-18 14:21:39', '::1'),
(109, 1, 'Hapus/batalkan peer assignment', '2026-06-18 14:21:40', '::1'),
(110, 1, 'Hapus/batalkan peer assignment', '2026-06-18 14:21:40', '::1'),
(111, 1, 'Hapus/batalkan peer assignment', '2026-06-18 14:21:41', '::1'),
(112, 1, 'Hapus/batalkan peer assignment', '2026-06-18 14:21:42', '::1'),
(113, 1, 'Hapus/batalkan peer assignment', '2026-06-18 14:21:42', '::1'),
(114, 1, 'Hapus/batalkan peer assignment', '2026-06-18 14:21:44', '::1'),
(115, 1, 'Hapus/batalkan peer assignment', '2026-06-18 14:21:45', '::1'),
(116, 1, 'Hapus/batalkan peer assignment', '2026-06-18 14:21:55', '::1'),
(117, 1, 'Hapus/batalkan peer assignment', '2026-06-18 14:21:57', '::1'),
(118, 1, 'Tambah peer assignment', '2026-06-18 14:22:18', '::1'),
(119, 1, 'Logout dari sistem', '2026-06-18 14:22:31', '::1'),
(120, 8, 'Login berhasil sebagai Karyawan', '2026-06-18 14:22:44', '::1'),
(121, 8, 'Logout dari sistem', '2026-06-18 14:22:54', '::1'),
(122, 1, 'Login berhasil sebagai Admin HR', '2026-06-18 14:22:55', '::1'),
(123, 1, 'Hapus/batalkan peer assignment', '2026-06-18 14:23:04', '::1'),
(124, 1, 'Tambah peer assignment', '2026-06-18 14:23:12', '::1'),
(125, 1, 'Logout dari sistem', '2026-06-18 14:23:37', '::1'),
(126, 8, 'Login berhasil sebagai Karyawan', '2026-06-18 14:23:41', '::1'),
(127, 8, 'Logout dari sistem', '2026-06-18 14:25:13', '::1'),
(128, 1, 'Login berhasil sebagai Admin HR', '2026-06-18 14:25:14', '::1'),
(129, 1, 'Update periode evaluasi Evaluasi AKHLAK Semester 2 2026', '2026-06-18 14:27:41', '::1'),
(130, 1, 'Update periode evaluasi Evaluasi AKHLAK Semester 3 2026', '2026-06-18 14:27:44', '::1'),
(131, 1, 'Logout dari sistem', '2026-06-18 14:27:45', '::1'),
(132, 8, 'Login berhasil sebagai Karyawan', '2026-06-18 14:27:49', '::1'),
(133, 8, 'Logout dari sistem', '2026-06-18 14:27:53', '::1'),
(134, 9, 'Login berhasil sebagai Manajemen', '2026-06-18 14:27:57', '::1'),
(135, 9, 'Logout dari sistem', '2026-06-18 14:28:06', '::1'),
(136, 1, 'Login berhasil sebagai Admin HR', '2026-06-18 14:28:07', '::1'),
(137, 1, 'Tambah peer assignment', '2026-06-18 14:28:36', '::1'),
(138, 1, 'Logout dari sistem', '2026-06-18 14:28:39', '::1'),
(139, 8, 'Login berhasil sebagai Karyawan', '2026-06-18 14:28:43', '::1'),
(140, 8, 'Logout dari sistem', '2026-06-18 14:29:57', '::1'),
(141, 1, 'Login berhasil sebagai Admin HR', '2026-06-18 14:29:59', '::1'),
(142, 1, 'Logout dari sistem', '2026-06-18 14:39:36', '::1'),
(143, 8, 'Login berhasil sebagai Karyawan', '2026-06-18 14:39:40', '::1'),
(144, 8, 'Logout dari sistem', '2026-06-18 14:40:29', '::1'),
(145, 1, 'Login berhasil sebagai Admin HR', '2026-06-18 14:40:31', '::1'),
(146, 1, 'Tambah peer assignment', '2026-06-18 14:46:14', '::1'),
(147, 1, 'Hapus/batalkan peer assignment', '2026-06-18 14:46:19', '::1'),
(148, 1, 'Tambah peer assignment', '2026-06-18 14:46:54', '::1'),
(149, 1, 'Tambah peer assignment', '2026-06-18 14:51:01', '::1'),
(150, 1, 'Update pertanyaan AKHLAK', '2026-06-18 14:51:32', '::1'),
(151, 1, 'Update periode evaluasi Evaluasi AKHLAK Semester 3 2026', '2026-06-18 14:52:30', '::1'),
(152, 1, 'Update periode evaluasi Evaluasi AKHLAK Semester 1 2026', '2026-06-18 14:52:35', '::1');

-- --------------------------------------------------------

--
-- Table structure for table `departments`
--

CREATE TABLE `departments` (
  `department_id` int(11) NOT NULL,
  `department_name` varchar(100) NOT NULL,
  `department_desc` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `departments`
--

INSERT INTO `departments` (`department_id`, `department_name`, `department_desc`) VALUES
(1, 'Human Capital', 'Mengelola administrasi SDM, periode evaluasi, dan pengembangan karyawan'),
(2, 'Operations', 'Mengelola proses operasional dan performansi lapangan'),
(3, 'Finance', 'Mengelola keuangan dan kontrol biaya'),
(4, 'Supply Chain', 'Mengelola pengadaan dan rantai pasok'),
(5, 'Management', 'Manajemen strategis perusahaan');

-- --------------------------------------------------------

--
-- Table structure for table `employees`
--

CREATE TABLE `employees` (
  `employee_id` int(11) NOT NULL,
  `department_id` int(11) NOT NULL,
  `position_id` int(11) NOT NULL,
  `supervisor_id` int(11) DEFAULT NULL,
  `employee_nik` varchar(30) NOT NULL,
  `employee_name` varchar(120) NOT NULL,
  `employee_email` varchar(120) NOT NULL,
  `employee_phone` varchar(30) DEFAULT NULL,
  `hire_date` date DEFAULT NULL,
  `employee_status` varchar(30) DEFAULT 'active'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `employees`
--

INSERT INTO `employees` (`employee_id`, `department_id`, `position_id`, `supervisor_id`, `employee_nik`, `employee_name`, `employee_email`, `employee_phone`, `hire_date`, `employee_status`) VALUES
(1, 1, 1, NULL, 'PEN-0001', 'Muhammad Gifary', 'gifary@sipakar.test', '081200000001', '2023-01-10', 'active'),
(2, 1, 8, 7, 'PEN-0002', 'Rama Pratama', 'rama@sipakar.test', '081200000002', '2023-02-12', 'active'),
(3, 2, 3, 10, 'PEN-0003', 'Dimas Nugraha', 'dimas@sipakar.test', '081200000003', '2022-08-01', 'active'),
(4, 2, 9, 3, 'PEN-0004', 'Nadia Maharani', 'nadia@sipakar.test', '081200000004', '2024-03-15', 'active'),
(5, 4, 6, 2, 'PEN-0005', 'Bima Arya', 'bima@sipakar.test', '081200000005', '2024-05-20', 'active'),
(6, 3, 7, 3, 'PEN-0006', 'Intan Wulandari', 'intan@sipakar.test', '081200000006', '2023-11-04', 'active'),
(7, 5, 4, 1, 'PEN-0007', 'Asep Dendeng', 'asep@sipakar.test', '081200000007', '2021-07-01', 'active'),
(8, 2, 2, 3, 'PEN-0008', 'Daffa Sayyid Zahran', 'daffa@sipakar.test', '081200000008', '2024-07-10', 'active'),
(9, 3, 5, 1, 'PEN-0009', 'Anggit', 'anggit@sipakar.test', '09090909090', '2026-06-17', 'active'),
(10, 3, 7, 3, 'PEN-0010', 'Joko Knalpot', 'joko@sipakar.test', '09090909090', '2026-06-17', 'active');

-- --------------------------------------------------------

--
-- Table structure for table `evaluation_periods`
--

CREATE TABLE `evaluation_periods` (
  `period_id` int(11) NOT NULL,
  `period_name` varchar(120) NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `period_status` varchar(30) DEFAULT 'draft'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `evaluation_periods`
--

INSERT INTO `evaluation_periods` (`period_id`, `period_name`, `start_date`, `end_date`, `period_status`) VALUES
(1, 'Evaluasi AKHLAK Semester 1 2026', '2026-01-01', '2026-06-30', 'active'),
(2, 'Evaluasi AKHLAK Semester 2 2026', '2026-07-01', '2026-12-31', 'closed'),
(3, 'Evaluasi AKHLAK Semester 3 2026', '2026-06-17', '2026-09-17', 'closed');

-- --------------------------------------------------------

--
-- Table structure for table `final_results`
--

CREATE TABLE `final_results` (
  `result_id` int(11) NOT NULL,
  `employee_id` int(11) NOT NULL,
  `period_id` int(11) NOT NULL,
  `self_score` decimal(5,2) DEFAULT 0.00,
  `peer_score` decimal(5,2) DEFAULT 0.00,
  `subordinate_score` decimal(5,2) DEFAULT 0.00,
  `supervisor_score` decimal(5,2) DEFAULT 0.00,
  `final_score` decimal(5,2) DEFAULT 0.00,
  `gap_analysis` varchar(500) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `final_results`
--

INSERT INTO `final_results` (`result_id`, `employee_id`, `period_id`, `self_score`, `peer_score`, `subordinate_score`, `supervisor_score`, `final_score`, `gap_analysis`) VALUES
(1, 3, 1, '4.17', '0.00', '4.33', '0.00', '4.28', 'Area pengembangan utama: Kompeten. Rekomendasi IDP: penguatan coaching, feedback rutin, dan delegasi berbasis kompetensi.'),
(2, 4, 1, '4.42', '4.50', '0.00', '4.83', '4.70', 'Kinerja sangat baik. Fokus pengembangan: konsistensi inovasi dan dokumentasi kolaborasi.'),
(3, 5, 1, '4.25', '4.08', '0.00', '4.25', '4.20', 'Kinerja baik. Fokus pengembangan: peningkatan inisiatif adaptif dan kompetensi teknis.'),
(4, 6, 1, '4.00', '0.00', '0.00', '3.92', '3.96', 'Kinerja baik. Fokus pengembangan: kecepatan adaptasi dan kolaborasi lintas fungsi.'),
(5, 8, 1, '4.42', '4.33', '0.00', '4.83', '4.66', 'Kinerja sangat baik. Fokus pengembangan: persiapan peran talent pool dan penguatan leadership.'),
(6, 1, 1, '4.00', '0.00', '3.46', '0.00', '3.60', 'Area pengembangan utama: Harmonis dengan skor rata-rata 3.25. Perlu IDP terarah: pelatihan perilaku AKHLAK, evaluasi bulanan, dan pendampingan atasan.'),
(7, 2, 1, '3.00', '0.00', '0.00', '0.00', '3.00', 'Area pengembangan utama: Amanah dengan skor rata-rata 1.5. Prioritas pengembangan: coaching intensif, rencana perbaikan perilaku, dan monitoring HR.');

-- --------------------------------------------------------

--
-- Table structure for table `notifications`
--

CREATE TABLE `notifications` (
  `notification_id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `title` varchar(120) NOT NULL,
  `message` varchar(500) NOT NULL,
  `notification_type` varchar(50) DEFAULT 'info',
  `is_read` tinyint(1) DEFAULT 0,
  `created_at` datetime NOT NULL,
  `created_by` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `notifications`
--

INSERT INTO `notifications` (`notification_id`, `user_id`, `title`, `message`, `notification_type`, `is_read`, `created_at`, `created_by`) VALUES
(1, NULL, 'Periode Evaluasi Aktif', 'Periode Evaluasi AKHLAK Semester 1 2026 sedang berlangsung. Harap selesaikan penilaian sesuai batas waktu.', 'period', 0, '2026-06-17 17:25:12', 1),
(2, 8, 'Reminder Penilaian', 'Daffa, masih ada penilaian peer yang perlu diselesaikan sebelum periode ditutup.', 'reminder', 0, '2026-06-17 17:25:12', 1),
(3, 3, 'Validasi Peer Assignment', 'Terdapat daftar peer assignment yang perlu divalidasi oleh atasan.', 'approval', 0, '2026-06-17 17:25:12', 1),
(7, NULL, 'Peer Assignment Diperbarui', 'Admin HR memperbarui daftar penilai silang.', 'assignment', 0, '2026-06-17 17:34:59', 1),
(8, NULL, 'Assessment Submitted', 'Salsabila Kirana telah mengirim Self Assessment untuk Salsabila Kirana.', 'assessment', 0, '2026-06-17 17:35:16', 1),
(9, NULL, 'Peer Assignment Diperbarui', 'Admin HR memperbarui daftar penilai silang.', 'assignment', 0, '2026-06-17 17:40:18', 1),
(10, NULL, 'Assessment Submitted', 'Rama Pratama telah mengirim Self Assessment untuk Rama Pratama.', 'assessment', 0, '2026-06-18 12:28:58', 2),
(11, NULL, 'Assessment Submitted', 'Rama Pratama telah mengirim Penilaian Bawahan untuk Salsabila Kirana.', 'assessment', 0, '2026-06-18 12:29:25', 2),
(12, NULL, 'Assessment Submitted', 'Rama Pratama telah mengirim Self Assessment untuk Rama Pratama.', 'assessment', 0, '2026-06-18 12:29:50', 2),
(13, NULL, 'Assessment Submitted', 'Muhammad Gifary telah mengirim Self Assessment untuk Muhammad Gifary.', 'assessment', 0, '2026-06-18 14:08:42', 1),
(14, NULL, 'Assessment Submitted', 'Muhammad Gifary telah mengirim Self Assessment untuk Muhammad Gifary.', 'assessment', 0, '2026-06-18 14:09:05', 1),
(15, NULL, 'Assessment Submitted', 'Muhammad Gifary telah mengirim Self Assessment untuk Muhammad Gifary.', 'assessment', 0, '2026-06-18 14:09:10', 1),
(16, NULL, 'Periode Evaluasi Aktif', 'Periode Evaluasi AKHLAK Semester 2 2026 telah dibuka.', 'period', 0, '2026-06-18 14:17:12', 1),
(17, NULL, 'Peer Assignment Diperbarui', 'Admin HR memperbarui daftar penilai silang.', 'assignment', 0, '2026-06-18 14:18:10', 1),
(18, NULL, 'Peer Assignment Diperbarui', 'Admin HR memperbarui daftar penilai silang.', 'assignment', 0, '2026-06-18 14:18:17', 1),
(19, NULL, 'Peer Assignment Diperbarui', 'Admin HR memperbarui daftar penilai silang.', 'assignment', 0, '2026-06-18 14:22:18', 1),
(20, NULL, 'Peer Assignment Diperbarui', 'Admin HR memperbarui daftar penilai silang.', 'assignment', 0, '2026-06-18 14:23:12', 1),
(21, NULL, 'Periode Evaluasi Aktif', 'Periode Evaluasi AKHLAK Semester 3 2026 telah dibuka.', 'period', 0, '2026-06-18 14:27:44', 1),
(22, NULL, 'Peer Assignment Diperbarui', 'Admin HR memperbarui daftar penilai silang.', 'assignment', 0, '2026-06-18 14:28:36', 1),
(23, NULL, 'Peer Assignment Diperbarui', 'Admin HR memperbarui daftar penilai silang.', 'assignment', 0, '2026-06-18 14:46:14', 1),
(24, NULL, 'Peer Assignment Diperbarui', 'Admin HR memperbarui daftar penilai silang.', 'assignment', 0, '2026-06-18 14:46:54', 1),
(25, NULL, 'Peer Assignment Diperbarui', 'Admin HR memperbarui daftar penilai silang.', 'assignment', 0, '2026-06-18 14:51:01', 1),
(26, NULL, 'Periode Evaluasi Aktif', 'Periode Evaluasi AKHLAK Semester 1 2026 telah dibuka.', 'period', 0, '2026-06-18 14:52:35', 1);

-- --------------------------------------------------------

--
-- Table structure for table `peer_assignments`
--

CREATE TABLE `peer_assignments` (
  `peer_assignment_id` int(11) NOT NULL,
  `employee_id` int(11) NOT NULL,
  `peer_employee_id` int(11) NOT NULL,
  `period_id` int(11) NOT NULL,
  `approval_status` varchar(30) DEFAULT 'pending',
  `approved_by` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `peer_assignments`
--

INSERT INTO `peer_assignments` (`peer_assignment_id`, `employee_id`, `peer_employee_id`, `period_id`, `approval_status`, `approved_by`) VALUES
(1, 4, 5, 1, 'cancelled', 'Dimas Nugraha'),
(2, 4, 6, 1, 'cancelled', 'Dimas Nugraha'),
(3, 5, 4, 1, 'approved', 'Dimas Nugraha'),
(4, 6, 4, 1, 'approved', 'Dimas Nugraha'),
(5, 8, 4, 1, 'approved', 'Dimas Nugraha'),
(6, 8, 5, 1, 'pending', NULL),
(7, 3, 4, 1, 'approved', 'Muhammad Gifary'),
(8, 3, 8, 1, 'cancelled', 'Muhammad Gifary'),
(12, 8, 9, 3, 'approved', NULL),
(13, 9, 8, 3, 'approved', 'Rama'),
(15, 3, 1, 3, 'approved', NULL),
(16, 2, 1, 3, 'approved', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `positions`
--

CREATE TABLE `positions` (
  `position_id` int(11) NOT NULL,
  `position_name` varchar(100) NOT NULL,
  `position_level` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `positions`
--

INSERT INTO `positions` (`position_id`, `position_name`, `position_level`) VALUES
(1, 'Admin HRIS', 'Admin HR'),
(2, 'Staff', 'Staff'),
(3, 'Atasan / Manager', 'Atasan'),
(4, 'Manajemen', 'Manajemen'),
(5, 'HR Development Officer', 'Admin HR'),
(6, 'Procurement Analyst', 'Staff'),
(7, 'Finance Analyst', 'Staff'),
(8, 'Operations Manager', 'Atasan'),
(9, 'Process Engineer', 'Staff');

-- --------------------------------------------------------

--
-- Table structure for table `questions`
--

CREATE TABLE `questions` (
  `question_id` int(11) NOT NULL,
  `akhlak_id` int(11) NOT NULL,
  `question_text` varchar(500) NOT NULL,
  `question_category` varchar(80) DEFAULT 'Perilaku',
  `question_status` varchar(30) DEFAULT 'active'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `questions`
--

INSERT INTO `questions` (`question_id`, `akhlak_id`, `question_text`, `question_category`, `question_status`) VALUES
(1, 1, 'Karyawan menunjukkan integritas dalam menjalankan pekerjaan dan menjaga kepercayaan perusahaan.', 'Perilaku', 'active'),
(2, 1, 'Karyawan bertanggung jawab terhadap hasil kerja dan komitmen yang sudah disepakati.', 'Perilaku', 'active'),
(3, 2, 'Karyawan mampu menyelesaikan pekerjaan sesuai standar kompetensi jabatannya.', 'Kompetensi', 'active'),
(4, 2, 'Karyawan aktif belajar untuk meningkatkan kemampuan kerja.', 'Kompetensi', 'active'),
(5, 3, 'Karyawan mampu menjaga hubungan kerja yang saling menghargai.', 'Perilaku', 'active'),
(6, 3, 'Karyawan peduli terhadap kondisi rekan kerja dan lingkungan kerja.', 'Perilaku', 'active'),
(7, 4, 'Karyawan menunjukkan dedikasi terhadap target dan kepentingan perusahaan.', 'Perilaku', 'active'),
(8, 4, 'Karyawan menjaga nama baik perusahaan dalam aktivitas kerja.', 'Perilaku', 'active'),
(9, 5, 'Karyawan mampu menyesuaikan diri terhadap perubahan proses kerja.', 'Perilaku', 'active'),
(10, 5, 'Karyawan memberikan ide perbaikan atau inovasi pada pekerjaan.', 'Kompetensi', 'active'),
(11, 6, 'Karyawan aktif bekerja sama dengan unit lain untuk menyelesaikan pekerjaan.', 'Perilaku', 'active'),
(12, 6, 'Karyawan terbuka menerima masukan dan mendukung pencapaian target tim.', 'Perilaku', 'active'),
(13, 6, 'testing', 'Perilaku', 'inactive');

-- --------------------------------------------------------

--
-- Table structure for table `roles`
--

CREATE TABLE `roles` (
  `role_id` int(11) NOT NULL,
  `role_name` varchar(50) NOT NULL,
  `role_description` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `roles`
--

INSERT INTO `roles` (`role_id`, `role_name`, `role_description`) VALUES
(1, 'admin_hr', 'Mengelola master data, periode, pertanyaan, assignment, notifikasi, dan report'),
(2, 'staff', 'Mengisi assessment dan melihat dashboard serta report pribadi'),
(3, 'atasan', 'Memvalidasi penilai, melihat dashboard tim, dan membuat IDP bawahan'),
(4, 'manajemen', 'Melihat dashboard eksekutif, top score, gap, talent mapping, dan laporan perusahaan');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `user_id` int(11) NOT NULL,
  `role_id` int(11) NOT NULL,
  `employee_id` int(11) NOT NULL,
  `username` varchar(80) NOT NULL,
  `password` varchar(255) NOT NULL,
  `last_login` datetime DEFAULT NULL,
  `account_status` varchar(30) DEFAULT 'active'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`user_id`, `role_id`, `employee_id`, `username`, `password`, `last_login`, `account_status`) VALUES
(1, 1, 1, 'gifary', '123123', '2026-06-18 14:40:31', 'active'),
(2, 3, 2, 'rama', '123123', '2026-06-18 12:26:23', 'active'),
(3, 3, 3, 'dimas', '123123', '2026-06-17 21:33:07', 'active'),
(4, 2, 4, 'nadia', '123123', '2026-06-17 18:45:57', 'active'),
(5, 2, 5, 'bima', '123123', NULL, 'active'),
(6, 2, 6, 'intan', '123123', NULL, 'active'),
(7, 4, 7, 'manajemen', '123123', '2026-06-17 21:31:26', 'active'),
(8, 2, 8, 'daffa', '123123', '2026-06-18 14:39:40', 'active'),
(9, 4, 9, 'anggit', '123123', '2026-06-18 14:27:57', 'active'),
(12, 2, 10, 'joko', '123123', NULL, 'active');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `akhlak_values`
--
ALTER TABLE `akhlak_values`
  ADD PRIMARY KEY (`akhlak_id`);

--
-- Indexes for table `assessments`
--
ALTER TABLE `assessments`
  ADD PRIMARY KEY (`assessment_id`),
  ADD UNIQUE KEY `uq_assessment_once` (`evaluator_id`,`evaluatee_id`,`period_id`,`assessment_type`),
  ADD KEY `fk_assess_evaluatee` (`evaluatee_id`),
  ADD KEY `fk_assess_period` (`period_id`);

--
-- Indexes for table `assessment_details`
--
ALTER TABLE `assessment_details`
  ADD PRIMARY KEY (`assessment_detail_id`),
  ADD UNIQUE KEY `uq_answer` (`assessment_id`,`question_id`),
  ADD KEY `fk_detail_question` (`question_id`);

--
-- Indexes for table `audit_logs`
--
ALTER TABLE `audit_logs`
  ADD PRIMARY KEY (`log_id`),
  ADD KEY `fk_audit_user` (`user_id`);

--
-- Indexes for table `departments`
--
ALTER TABLE `departments`
  ADD PRIMARY KEY (`department_id`);

--
-- Indexes for table `employees`
--
ALTER TABLE `employees`
  ADD PRIMARY KEY (`employee_id`),
  ADD UNIQUE KEY `employee_nik` (`employee_nik`),
  ADD UNIQUE KEY `employee_email` (`employee_email`),
  ADD KEY `fk_emp_dept` (`department_id`),
  ADD KEY `fk_emp_pos` (`position_id`),
  ADD KEY `fk_emp_supervisor` (`supervisor_id`);

--
-- Indexes for table `evaluation_periods`
--
ALTER TABLE `evaluation_periods`
  ADD PRIMARY KEY (`period_id`);

--
-- Indexes for table `final_results`
--
ALTER TABLE `final_results`
  ADD PRIMARY KEY (`result_id`),
  ADD UNIQUE KEY `uq_result` (`employee_id`,`period_id`),
  ADD KEY `fk_result_period` (`period_id`);

--
-- Indexes for table `notifications`
--
ALTER TABLE `notifications`
  ADD PRIMARY KEY (`notification_id`),
  ADD KEY `fk_notif_user` (`user_id`),
  ADD KEY `fk_notif_creator` (`created_by`);

--
-- Indexes for table `peer_assignments`
--
ALTER TABLE `peer_assignments`
  ADD PRIMARY KEY (`peer_assignment_id`),
  ADD UNIQUE KEY `uq_peer_assignment` (`employee_id`,`peer_employee_id`,`period_id`),
  ADD KEY `fk_peer_peer` (`peer_employee_id`),
  ADD KEY `fk_peer_period` (`period_id`);

--
-- Indexes for table `positions`
--
ALTER TABLE `positions`
  ADD PRIMARY KEY (`position_id`);

--
-- Indexes for table `questions`
--
ALTER TABLE `questions`
  ADD PRIMARY KEY (`question_id`),
  ADD KEY `fk_question_akhlak` (`akhlak_id`);

--
-- Indexes for table `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`role_id`),
  ADD UNIQUE KEY `role_name` (`role_name`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `employee_id` (`employee_id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD KEY `fk_user_role` (`role_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `akhlak_values`
--
ALTER TABLE `akhlak_values`
  MODIFY `akhlak_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `assessments`
--
ALTER TABLE `assessments`
  MODIFY `assessment_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT for table `assessment_details`
--
ALTER TABLE `assessment_details`
  MODIFY `assessment_detail_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `audit_logs`
--
ALTER TABLE `audit_logs`
  MODIFY `log_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=153;

--
-- AUTO_INCREMENT for table `departments`
--
ALTER TABLE `departments`
  MODIFY `department_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `employees`
--
ALTER TABLE `employees`
  MODIFY `employee_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `evaluation_periods`
--
ALTER TABLE `evaluation_periods`
  MODIFY `period_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `final_results`
--
ALTER TABLE `final_results`
  MODIFY `result_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `notifications`
--
ALTER TABLE `notifications`
  MODIFY `notification_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;

--
-- AUTO_INCREMENT for table `peer_assignments`
--
ALTER TABLE `peer_assignments`
  MODIFY `peer_assignment_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT for table `positions`
--
ALTER TABLE `positions`
  MODIFY `position_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `questions`
--
ALTER TABLE `questions`
  MODIFY `question_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `roles`
--
ALTER TABLE `roles`
  MODIFY `role_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `assessments`
--
ALTER TABLE `assessments`
  ADD CONSTRAINT `fk_assess_evaluatee` FOREIGN KEY (`evaluatee_id`) REFERENCES `employees` (`employee_id`),
  ADD CONSTRAINT `fk_assess_evaluator` FOREIGN KEY (`evaluator_id`) REFERENCES `employees` (`employee_id`),
  ADD CONSTRAINT `fk_assess_period` FOREIGN KEY (`period_id`) REFERENCES `evaluation_periods` (`period_id`);

--
-- Constraints for table `assessment_details`
--
ALTER TABLE `assessment_details`
  ADD CONSTRAINT `fk_detail_assessment` FOREIGN KEY (`assessment_id`) REFERENCES `assessments` (`assessment_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_detail_question` FOREIGN KEY (`question_id`) REFERENCES `questions` (`question_id`);

--
-- Constraints for table `audit_logs`
--
ALTER TABLE `audit_logs`
  ADD CONSTRAINT `fk_audit_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`);

--
-- Constraints for table `employees`
--
ALTER TABLE `employees`
  ADD CONSTRAINT `fk_emp_dept` FOREIGN KEY (`department_id`) REFERENCES `departments` (`department_id`),
  ADD CONSTRAINT `fk_emp_pos` FOREIGN KEY (`position_id`) REFERENCES `positions` (`position_id`),
  ADD CONSTRAINT `fk_emp_supervisor` FOREIGN KEY (`supervisor_id`) REFERENCES `employees` (`employee_id`) ON DELETE SET NULL;

--
-- Constraints for table `final_results`
--
ALTER TABLE `final_results`
  ADD CONSTRAINT `fk_result_employee` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`employee_id`),
  ADD CONSTRAINT `fk_result_period` FOREIGN KEY (`period_id`) REFERENCES `evaluation_periods` (`period_id`);

--
-- Constraints for table `notifications`
--
ALTER TABLE `notifications`
  ADD CONSTRAINT `fk_notif_creator` FOREIGN KEY (`created_by`) REFERENCES `users` (`user_id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_notif_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Constraints for table `peer_assignments`
--
ALTER TABLE `peer_assignments`
  ADD CONSTRAINT `fk_peer_employee` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`employee_id`),
  ADD CONSTRAINT `fk_peer_peer` FOREIGN KEY (`peer_employee_id`) REFERENCES `employees` (`employee_id`),
  ADD CONSTRAINT `fk_peer_period` FOREIGN KEY (`period_id`) REFERENCES `evaluation_periods` (`period_id`);

--
-- Constraints for table `questions`
--
ALTER TABLE `questions`
  ADD CONSTRAINT `fk_question_akhlak` FOREIGN KEY (`akhlak_id`) REFERENCES `akhlak_values` (`akhlak_id`);

--
-- Constraints for table `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `fk_user_employee` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`employee_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_user_role` FOREIGN KEY (`role_id`) REFERENCES `roles` (`role_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
