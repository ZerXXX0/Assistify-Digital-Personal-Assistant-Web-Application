-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Waktu pembuatan: 14 Jun 2025 pada 09.29
-- Versi server: 10.4.32-MariaDB
-- Versi PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `assistify`
--

-- --------------------------------------------------------

--
-- Struktur dari tabel `activity`
--

CREATE TABLE `activity` (
  `id` int(11) NOT NULL,
  `title` varchar(50) NOT NULL,
  `description` text DEFAULT NULL,
  `start_time` datetime DEFAULT NULL,
  `end_time` datetime DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `activity`
--

INSERT INTO `activity` (`id`, `title`, `description`, `start_time`, `end_time`, `user_id`) VALUES
(1, 'Baca Buku Harry Potter', 'BAB 1 - V', '2025-06-08 01:00:00', '2025-06-08 08:51:00', 1),
(5, 'nyapu', 'menyapu halaman rumah', '2025-06-09 11:31:00', NULL, 12),
(7, 'RAPAT PLENO', 'PLENO REVELI 2025', '2025-06-13 15:21:00', '2025-06-14 15:21:00', 17);

-- --------------------------------------------------------

--
-- Struktur dari tabel `alarm`
--

CREATE TABLE `alarm` (
  `id` int(11) NOT NULL,
  `time` datetime NOT NULL,
  `status` varchar(12) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `title` varchar(100) DEFAULT 'Alarm'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `alarm`
--

INSERT INTO `alarm` (`id`, `time`, `status`, `user_id`, `title`) VALUES
(13, '2025-06-09 07:35:19', 'active', 11, 'Testing 1 menit'),
(14, '2025-06-09 12:16:00', 'dismissed', 11, 'TEsting kali'),
(16, '2025-06-09 19:32:00', 'inactive', 13, 'wake tf up'),
(18, '2025-06-10 17:36:25', 'active', 14, 'bangunn!'),
(24, '2025-06-13 01:59:00', 'active', 1, 'sdfdsfsdf'),
(25, '2025-06-13 02:04:00', 'active', 1, 'asdasd'),
(26, '2025-06-13 02:06:00', 'active', 1, 'dasfsad'),
(27, '2025-06-13 02:09:00', 'active', 16, 'asdsadas'),
(28, '2025-06-13 02:21:00', 'active', 1, 'adasd'),
(29, '2025-06-13 02:35:00', 'active', 1, 'asdasdasda'),
(30, '2025-06-13 02:51:00', 'active', 1, 'qdasdasdas'),
(31, '2025-06-13 02:56:00', 'inactive', 1, 'eqrasasdasd'),
(32, '2025-06-13 14:47:36', 'active', 1, 'TEST');

-- --------------------------------------------------------

--
-- Struktur dari tabel `journalentry`
--

CREATE TABLE `journalentry` (
  `id` int(11) NOT NULL,
  `entrydate` datetime NOT NULL DEFAULT current_timestamp(),
  `content` text NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `title` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `journalentry`
--

INSERT INTO `journalentry` (`id`, `entrydate`, `content`, `user_id`, `title`) VALUES
(3, '2025-06-07 11:05:11', 'ASDASDASS', NULL, NULL),
(4, '2025-06-07 11:13:31', 'ASDASDDS', NULL, NULL),
(5, '2025-06-08 19:19:17', 'Hari itu aku menatapnya selama berjam jasmss', 1, 'Dia yang ku sukass'),
(9, '2025-06-09 05:58:25', 'Tiba tiba aku jatoh gesasdsasdasdeasdassaasdasddasd', 1, 'Jatuh cinta pada pandangan pertama'),
(11, '2025-06-09 07:50:10', 'I Love u, buat orang yang di sana', 11, 'Aku Cinta Dia'),
(12, '2025-06-09 11:47:16', 'mzmzmmzmzmzmzmmzmzmzmzmzmzmzzmzmzmzmzmzmzmzmzmzmzmzmzmzmzzm mmz zmzmmmzmzmzmzmzmzmzmzmz mzmzmzmzmzmzmzmzmzmzmzmzzm mzmzmzzmzm mmzmzzmzmzmzmzmzmzmzmzz mzmzmzmzzm', 12, 'jiwa terluka'),
(13, '2025-06-10 17:41:59', 'halo gais\njadi hari ini kita lagi konsul dka :)\ndan besok tau gak ada apa? ada UAS SA dan DKA!!\n\nsedih nya di jurnal ini gak bisa masukin emot :(\n\nsekian terima gaji', 14, 'Jurnal Today'),
(14, '2025-06-12 19:32:39', 'Alamak beda agama', 1, 'Aku suka dia tapi dia katolik'),
(15, '2025-06-12 19:33:07', 'Alamak', 1, 'Alamak'),
(16, '2025-06-13 15:23:00', 'AKU MAU ESKRIM:<', 17, 'GATAU');

-- --------------------------------------------------------

--
-- Struktur dari tabel `notification_settings`
--

CREATE TABLE `notification_settings` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `type` enum('Alarm','Notification') NOT NULL,
  `sound` int(11) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `notification_settings`
--

INSERT INTO `notification_settings` (`id`, `user_id`, `type`, `sound`, `created_at`, `updated_at`) VALUES
(1, 1, 'Alarm', 1, '2025-06-08 23:31:02', '2025-06-12 18:55:11'),
(2, 2, 'Alarm', 1, '2025-06-08 23:31:02', '2025-06-08 23:31:02'),
(3, 3, 'Alarm', 1, '2025-06-08 23:31:02', '2025-06-08 23:31:02'),
(4, 5, 'Alarm', 1, '2025-06-08 23:31:02', '2025-06-08 23:31:02'),
(5, 6, 'Alarm', 1, '2025-06-08 23:31:02', '2025-06-08 23:31:02'),
(6, 8, 'Alarm', 1, '2025-06-08 23:31:02', '2025-06-08 23:31:02'),
(8, 1, 'Notification', 3, '2025-06-08 23:31:02', '2025-06-13 07:41:44'),
(9, 2, 'Notification', 1, '2025-06-08 23:31:02', '2025-06-08 23:31:02'),
(10, 3, 'Notification', 1, '2025-06-08 23:31:02', '2025-06-08 23:31:02'),
(11, 5, 'Notification', 1, '2025-06-08 23:31:02', '2025-06-08 23:31:02'),
(12, 6, 'Notification', 1, '2025-06-08 23:31:02', '2025-06-08 23:31:02'),
(13, 8, 'Notification', 1, '2025-06-08 23:31:02', '2025-06-08 23:31:02'),
(15, 11, 'Alarm', 1, '2025-06-09 00:32:25', '2025-06-09 00:32:25'),
(16, 11, 'Notification', 2, '2025-06-09 00:32:25', '2025-06-09 00:32:25'),
(17, 12, 'Alarm', 1, '2025-06-09 04:19:54', '2025-06-09 04:19:54'),
(18, 12, 'Notification', 2, '2025-06-09 04:19:54', '2025-06-09 04:19:54'),
(19, 14, 'Alarm', 2, '2025-06-10 10:33:27', '2025-06-10 10:33:27'),
(20, 14, 'Notification', 1, '2025-06-10 10:33:27', '2025-06-10 10:33:27'),
(21, 15, 'Alarm', 1, '2025-06-12 08:51:24', '2025-06-12 08:51:24'),
(22, 15, 'Notification', 2, '2025-06-12 08:51:24', '2025-06-12 08:51:24'),
(23, 19, 'Alarm', 1, '2025-06-14 07:12:09', '2025-06-14 07:12:09'),
(24, 19, 'Notification', 1, '2025-06-14 07:12:09', '2025-06-14 07:12:09');

-- --------------------------------------------------------

--
-- Struktur dari tabel `reminder`
--

CREATE TABLE `reminder` (
  `id` int(11) NOT NULL,
  `time` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `message` varchar(255) NOT NULL,
  `idtask` int(11) DEFAULT NULL,
  `user_id` int(11) NOT NULL,
  `type` enum('todoitem','activity') DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `reminder`
--

INSERT INTO `reminder` (`id`, `time`, `message`, `idtask`, `user_id`, `type`) VALUES
(9, '2025-06-12 18:53:00', 'asdasdasdasd', 3, 1, 'todoitem');

-- --------------------------------------------------------

--
-- Struktur dari tabel `textnote`
--

CREATE TABLE `textnote` (
  `id` int(11) NOT NULL,
  `title` varchar(100) NOT NULL,
  `note_text` text DEFAULT NULL,
  `created_date` datetime DEFAULT current_timestamp(),
  `user_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `textnote`
--

INSERT INTO `textnote` (`id`, `title`, `note_text`, `created_date`, `user_id`) VALUES
(1, 'Testing CuySSSSA', 'AGASFSASSasdsd', '2025-06-08 18:58:33', 1),
(6, 'TEst', 'teatew', '2025-06-09 07:49:40', 11),
(7, 'nbnbnb', 'bnbnbnb\r\nbnbnbnbnb\r\nbnbnbnbnbn\r\nnmbnbnb bnbnbn bnbnb bmnmmnmnmnmnmnmnmnmnmnmnmnmnmn\r\nbnbnbnbnb\r\nbnbnbnb\r\nnbnb bnbnb \r\nbnbnbnb\r\nbnbn bnbn bnbnb\r\nnbnb nbnb nbnbn   nbnbn', '2025-06-09 11:45:48', 12);

-- --------------------------------------------------------

--
-- Struktur dari tabel `todoitem`
--

CREATE TABLE `todoitem` (
  `id` int(11) NOT NULL,
  `title` varchar(50) NOT NULL,
  `due_date` datetime DEFAULT NULL,
  `priority` int(11) DEFAULT NULL,
  `is_completed` tinyint(1) DEFAULT 0,
  `user_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `todoitem`
--

INSERT INTO `todoitem` (`id`, `title`, `due_date`, `priority`, `is_completed`, `user_id`) VALUES
(3, 'Test', '2025-06-08 02:40:00', 10, 0, 1),
(8, 'asdasd', '2025-06-09 02:45:00', 7, 0, 1),
(9, 'asdasd1232132', '2025-06-11 02:46:00', 8, 0, 1),
(11, 'nganter anak', '2025-06-09 11:30:00', 9, 0, 12),
(12, 'gangguin bayu', '2025-06-10 17:38:00', 1, 0, 14),
(13, 'Alamak', '2025-06-08 19:27:00', 10, 0, 1),
(14, 'asdasdasd', '2025-06-12 19:30:00', 1, 0, 1),
(15, 'adsasd', '2025-06-12 19:30:00', 10, 0, 1),
(16, 'COTS PBO', '2025-06-13 15:21:00', 10, 1, 17),
(18, 'COTS PBO', '2025-06-14 14:05:00', 10, 0, 19);

-- --------------------------------------------------------

--
-- Struktur dari tabel `user`
--

CREATE TABLE `user` (
  `id` int(11) NOT NULL,
  `username` varchar(25) NOT NULL,
  `password` varchar(25) NOT NULL,
  `email` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `user`
--

INSERT INTO `user` (`id`, `username`, `password`, `email`) VALUES
(1, 'Fansa', 'fansa123', 'fathansanum@gmail.com'),
(2, 'BangEl', '12345', 'El@gmail.com'),
(3, 'mikal', '123', 'mikal@gmail.com'),
(5, 'admin', 'admin123', 'bayusatriowid@gmail.com'),
(6, 'Kecoa Terbang', 'terbang123', 'kecoaterbang12@gmail.com'),
(8, 'pasta', '123456', 'pasta@gmail.com'),
(11, 'baysatriow', 'bayu123', 'bayusatriowid@gmail.com'),
(12, 'Kecoa Terbang 12', 'terbang12', 'kecoaterbang123@gmail.com'),
(13, 'zerx', 'Ichbinghozy2312', 'ghozyhernandez@gmail.com'),
(14, 'nida', 'nida123', 'nida@gmail.com'),
(15, 'testing123', 'testing123', 'testing123@gmail.com'),
(16, 'golden', 'golden123', 'golden@gmail.com'),
(17, 'caca', 'pikacomel', 'caca@gmail.com'),
(18, 'cacaa', 'pikacomel', 'caca@gmail.com'),
(19, 'fathansanum', 'admin111', 'fathanfs17@gmail.com');

-- --------------------------------------------------------

--
-- Struktur dari tabel `voicenote`
--

CREATE TABLE `voicenote` (
  `id` int(11) NOT NULL,
  `title` varchar(100) NOT NULL,
  `voice_file` varchar(255) DEFAULT NULL,
  `created_date` datetime DEFAULT current_timestamp(),
  `user_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `voicenote`
--

INSERT INTO `voicenote` (`id`, `title`, `voice_file`, `created_date`, `user_id`) VALUES
(7, 'Testing Record', 'uploads/voice_notes/recorded_1749429067953.mp3', '2025-06-09 07:31:08', 11),
(8, 'TEst Rec', 'uploads/voice_notes/recorded_1749429251084.mp3', '2025-06-09 07:34:11', 11),
(10, 'asdasdasd', 'uploads/voice_notes/recorded_1749448311437.mp3', '2025-06-09 12:51:51', 1),
(11, 'asdasds', 'uploads/voice_notes/recorded_1749448434697.mp3', '2025-06-09 12:53:55', 1),
(12, 'adasdas', 'uploads/voice_notes/voice_1749448605756.mp3', '2025-06-09 12:56:46', 1),
(13, 'Testing', 'uploads/voice_notes/recorded_1749448742023.mp3', '2025-06-09 12:59:02', 1),
(14, 'TESTING', 'uploads/voice_notes/recorded_1749472500312.mp3', '2025-06-09 19:35:00', 1),
(15, 'Replay', 'uploads/voice_notes/voice_1749551754947.mp3', '2025-06-10 17:35:55', 14),
(16, 'bang bang bang', 'uploads/voice_notes/voice_1749551855084.mp3', '2025-06-10 17:37:35', 14),
(18, 'PRISKA', 'uploads/voice_notes/recorded_1749800586786.mp3', '2025-06-13 14:43:07', 1),
(19, 'SADS', 'http://commondatastorage.googleapis.com/codeskulptor-demos/DDR_assets/Kangaroo_MusiQue_-_The_Neverwritten_Role_Playing_Game.mp3', '2025-06-13 14:44:48', 1),
(20, 'ghfgfggf', 'uploads/voice_notes/recorded_1749802110007.mp3', '2025-06-13 15:08:30', 17);

--
-- Indexes for dumped tables
--

--
-- Indeks untuk tabel `activity`
--
ALTER TABLE `activity`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indeks untuk tabel `alarm`
--
ALTER TABLE `alarm`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `journalentry`
--
ALTER TABLE `journalentry`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `notification_settings`
--
ALTER TABLE `notification_settings`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_user_type` (`user_id`,`type`);

--
-- Indeks untuk tabel `reminder`
--
ALTER TABLE `reminder`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_reminder_user` (`user_id`),
  ADD KEY `idx_reminder_time` (`time`);

--
-- Indeks untuk tabel `textnote`
--
ALTER TABLE `textnote`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indeks untuk tabel `todoitem`
--
ALTER TABLE `todoitem`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indeks untuk tabel `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `voicenote`
--
ALTER TABLE `voicenote`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- AUTO_INCREMENT untuk tabel yang dibuang
--

--
-- AUTO_INCREMENT untuk tabel `activity`
--
ALTER TABLE `activity`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT untuk tabel `alarm`
--
ALTER TABLE `alarm`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=36;

--
-- AUTO_INCREMENT untuk tabel `journalentry`
--
ALTER TABLE `journalentry`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT untuk tabel `notification_settings`
--
ALTER TABLE `notification_settings`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT untuk tabel `reminder`
--
ALTER TABLE `reminder`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT untuk tabel `textnote`
--
ALTER TABLE `textnote`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT untuk tabel `todoitem`
--
ALTER TABLE `todoitem`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT untuk tabel `user`
--
ALTER TABLE `user`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT untuk tabel `voicenote`
--
ALTER TABLE `voicenote`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- Ketidakleluasaan untuk tabel pelimpahan (Dumped Tables)
--

--
-- Ketidakleluasaan untuk tabel `activity`
--
ALTER TABLE `activity`
  ADD CONSTRAINT `activity_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `notification_settings`
--
ALTER TABLE `notification_settings`
  ADD CONSTRAINT `notification_settings_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `reminder`
--
ALTER TABLE `reminder`
  ADD CONSTRAINT `reminder_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `textnote`
--
ALTER TABLE `textnote`
  ADD CONSTRAINT `textnote_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `todoitem`
--
ALTER TABLE `todoitem`
  ADD CONSTRAINT `todoitem_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `voicenote`
--
ALTER TABLE `voicenote`
  ADD CONSTRAINT `voicenote_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
