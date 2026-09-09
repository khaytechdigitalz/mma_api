-- phpMyAdmin SQL Dump
-- version 5.2.3
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Sep 09, 2026 at 09:52 AM
-- Server version: 8.0.45
-- PHP Version: 8.2.32

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `mma`
--

-- --------------------------------------------------------

--
-- Table structure for table `attributes`
--

CREATE TABLE `attributes` (
  `id` bigint UNSIGNED NOT NULL,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `slug` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `type` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `attribute_values`
--

CREATE TABLE `attribute_values` (
  `id` bigint UNSIGNED NOT NULL,
  `attribute_id` bigint UNSIGNED NOT NULL,
  `value` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `audit_logs`
--

CREATE TABLE `audit_logs` (
  `id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED DEFAULT NULL,
  `user_type` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'e.g., admin, vendor, customer',
  `action` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'e.g., product.create, product.status_update',
  `description` text COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Human readable action summary',
  `ip_address` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_agent` text COLLATE utf8mb4_unicode_ci,
  `device` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'e.g., Desktop, Mobile, Tablet',
  `browser` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'e.g., Chrome, Safari, Firefox',
  `platform` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'e.g., Windows, macOS, iOS, Android',
  `payload` json DEFAULT NULL COMMENT 'Input data received in request',
  `old_values` json DEFAULT NULL COMMENT 'State before change (for updates/deletes)',
  `new_values` json DEFAULT NULL COMMENT 'State after change (for updates/creates)',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `audit_logs`
--

INSERT INTO `audit_logs` (`id`, `user_id`, `user_type`, `action`, `description`, `ip_address`, `user_agent`, `device`, `browser`, `platform`, `payload`, `old_values`, `new_values`, `created_at`, `updated_at`) VALUES
(1, 1, 'admin', 'category.create', 'Created category \'Electronics & Gadgets\' (ID: 1)', '127.0.0.1', 'PostmanRuntime/2.3.0', 'Desktop', 'Unknown', 'Unknown', '{\"icon\": {}, \"name\": \"Electronics & Gadgets\", \"banner\": {}, \"priority\": \"1\", \"is_active\": \"1\", \"parent_id\": null, \"meta_title\": \"Buy Electronics Online\", \"meta_description\": \"Explore top quality electronics, gadgets, and tech accessories.\"}', NULL, '{\"id\": 1, \"icon\": \"categoriesicons/2026/08/6a777d43-dcdf-415d-96f3-3e1e27c1b99b_1787667486.webp\", \"name\": \"Electronics & Gadgets\", \"slug\": \"electronics-gadgets\", \"banner\": \"categoriesbanners/2026/08/8a32409d-5f8f-469e-a8ff-8998057719cc_1787667486.webp\", \"priority\": 1, \"created_at\": \"2026-08-25T14:18:06.000000Z\", \"updated_at\": \"2026-08-25T14:18:06.000000Z\"}', '2026-08-25 13:18:06', '2026-08-25 13:18:06'),
(2, 1, 'admin', 'category.create', 'Created category \'Home Gadgets\' (ID: 2)', '127.0.0.1', 'PostmanRuntime/2.3.0', 'Desktop', 'Unknown', 'Unknown', '{\"icon\": {}, \"name\": \"Home Gadgets\", \"banner\": {}, \"priority\": \"1\", \"is_active\": \"1\", \"parent_id\": \"0\", \"meta_title\": \"Buy Electronics Online\", \"meta_description\": \"Explore top quality electronics, gadgets, and tech accessories.\"}', NULL, '{\"id\": 2, \"icon\": \"categoriesicons/2026/08/6566f4e4-21ef-4b62-950b-c6ab8ce349f4_1787667567.webp\", \"name\": \"Home Gadgets\", \"slug\": \"home-gadgets\", \"banner\": \"categoriesbanners/2026/08/d9c19614-e583-4f80-98d5-58dab5f09c02_1787667567.webp\", \"priority\": 1, \"created_at\": \"2026-08-25T14:19:27.000000Z\", \"updated_at\": \"2026-08-25T14:19:27.000000Z\"}', '2026-08-25 13:19:27', '2026-08-25 13:19:27'),
(3, 1, 'admin', 'category.update', 'Updated category \'Consumer Electronics\' (ID: 1)', '127.0.0.1', 'PostmanRuntime/2.3.0', 'Desktop', 'Unknown', 'Unknown', '{\"name\": \"Consumer Electronics\", \"status\": \"1\", \"priority\": \"2\"}', '{\"id\": 1, \"icon\": \"categoriesicons/2026/08/6a777d43-dcdf-415d-96f3-3e1e27c1b99b_1787667486.webp\", \"name\": \"Electronics & Gadgets\", \"slug\": \"electronics-gadgets\", \"banner\": \"categoriesbanners/2026/08/8a32409d-5f8f-469e-a8ff-8998057719cc_1787667486.webp\", \"status\": true, \"priority\": 1, \"created_at\": \"2026-08-25T14:18:06.000000Z\", \"updated_at\": \"2026-08-25T14:18:06.000000Z\"}', '{\"id\": 1, \"icon\": \"categoriesicons/2026/08/6a777d43-dcdf-415d-96f3-3e1e27c1b99b_1787667486.webp\", \"name\": \"Consumer Electronics\", \"slug\": \"consumer-electronics\", \"banner\": \"categoriesbanners/2026/08/8a32409d-5f8f-469e-a8ff-8998057719cc_1787667486.webp\", \"status\": true, \"priority\": 2, \"created_at\": \"2026-08-25T14:18:06.000000Z\", \"updated_at\": \"2026-08-25T14:26:02.000000Z\"}', '2026-08-25 13:26:02', '2026-08-25 13:26:02'),
(4, 1, 'admin', 'category.update', 'Updated category \'Consumer Electronics\' (ID: 1)', '127.0.0.1', 'PostmanRuntime/2.3.0', 'Desktop', 'Unknown', 'Unknown', '{\"name\": \"Consumer Electronics\", \"status\": \"1\", \"priority\": \"2\"}', '{\"id\": 1, \"icon\": \"categoriesicons/2026/08/6a777d43-dcdf-415d-96f3-3e1e27c1b99b_1787667486.webp\", \"name\": \"Consumer Electronics\", \"slug\": \"consumer-electronics\", \"banner\": \"categoriesbanners/2026/08/8a32409d-5f8f-469e-a8ff-8998057719cc_1787667486.webp\", \"status\": true, \"priority\": 2, \"created_at\": \"2026-08-25T14:18:06.000000Z\", \"updated_at\": \"2026-08-25T14:26:02.000000Z\"}', '{\"id\": 1, \"icon\": \"categoriesicons/2026/08/6a777d43-dcdf-415d-96f3-3e1e27c1b99b_1787667486.webp\", \"name\": \"Consumer Electronics\", \"slug\": \"consumer-electronics\", \"banner\": \"categoriesbanners/2026/08/8a32409d-5f8f-469e-a8ff-8998057719cc_1787667486.webp\", \"status\": true, \"priority\": 2, \"created_at\": \"2026-08-25T14:18:06.000000Z\", \"updated_at\": \"2026-08-25T14:26:02.000000Z\"}', '2026-08-25 13:26:43', '2026-08-25 13:26:43'),
(5, 1, 'admin', 'category.update', 'Updated category \'Consumer Electronics\' (ID: 1)', '127.0.0.1', 'PostmanRuntime/2.3.0', 'Desktop', 'Unknown', 'Unknown', '{\"name\": \"Consumer Electronics\", \"status\": \"active\", \"priority\": \"2\"}', '{\"id\": 1, \"icon\": \"categoriesicons/2026/08/6a777d43-dcdf-415d-96f3-3e1e27c1b99b_1787667486.webp\", \"name\": \"Consumer Electronics\", \"slug\": \"consumer-electronics\", \"banner\": \"categoriesbanners/2026/08/8a32409d-5f8f-469e-a8ff-8998057719cc_1787667486.webp\", \"status\": \"inactive\", \"priority\": 2, \"created_at\": \"2026-08-25T14:18:06.000000Z\", \"updated_at\": \"2026-08-25T14:26:02.000000Z\"}', '{\"id\": 1, \"icon\": \"categoriesicons/2026/08/6a777d43-dcdf-415d-96f3-3e1e27c1b99b_1787667486.webp\", \"name\": \"Consumer Electronics\", \"slug\": \"consumer-electronics\", \"banner\": \"categoriesbanners/2026/08/8a32409d-5f8f-469e-a8ff-8998057719cc_1787667486.webp\", \"status\": \"active\", \"priority\": 2, \"created_at\": \"2026-08-25T14:18:06.000000Z\", \"updated_at\": \"2026-08-25T14:29:48.000000Z\"}', '2026-08-25 13:29:48', '2026-08-25 13:29:48'),
(6, 1, 'admin', 'category.delete', 'Deleted category \'Consumer Electronics\' (ID: 1)', '127.0.0.1', 'PostmanRuntime/2.3.0', 'Desktop', 'Unknown', 'Unknown', NULL, '{\"id\": 1, \"icon\": \"categoriesicons/2026/08/6a777d43-dcdf-415d-96f3-3e1e27c1b99b_1787667486.webp\", \"name\": \"Consumer Electronics\", \"slug\": \"consumer-electronics\", \"banner\": \"categoriesbanners/2026/08/8a32409d-5f8f-469e-a8ff-8998057719cc_1787667486.webp\", \"status\": \"active\", \"priority\": 2, \"created_at\": \"2026-08-25T14:18:06.000000Z\", \"updated_at\": \"2026-08-25T14:29:48.000000Z\"}', NULL, '2026-08-25 13:31:42', '2026-08-25 13:31:42'),
(7, 1, 'admin', 'category.create', 'Created category \'Local Gadgets\' (ID: 3)', '127.0.0.1', 'PostmanRuntime/2.3.0', 'Desktop', 'Unknown', 'Unknown', '{\"icon\": {}, \"name\": \"Local Gadgets\", \"banner\": {}, \"priority\": \"1\", \"is_active\": \"1\", \"parent_id\": \"0\", \"meta_title\": \"Buy Electronics Online\", \"meta_description\": \"Explore top quality electronics, gadgets, and tech accessories.\"}', NULL, '{\"id\": 3, \"icon\": \"categoriesicons/2026/08/35636f03-4c03-472d-9977-3801e9687d21_1787668323.webp\", \"name\": \"Local Gadgets\", \"slug\": \"local-gadgets\", \"banner\": \"categoriesbanners/2026/08/cca8a1f6-9a95-4d51-b2e7-f01c94a971ee_1787668323.webp\", \"status\": true, \"priority\": 1, \"created_at\": \"2026-08-25T14:32:03.000000Z\", \"updated_at\": \"2026-08-25T14:32:03.000000Z\"}', '2026-08-25 13:32:03', '2026-08-25 13:32:03'),
(8, 1, 'admin', 'category.update', 'Updated category \'Local Electronics\' (ID: 3)', '127.0.0.1', 'PostmanRuntime/2.3.0', 'Desktop', 'Unknown', 'Unknown', '{\"name\": \"Local Electronics\", \"status\": \"active\", \"priority\": \"2\"}', '{\"id\": 3, \"icon\": \"categoriesicons/2026/08/35636f03-4c03-472d-9977-3801e9687d21_1787668323.webp\", \"name\": \"Local Gadgets\", \"slug\": \"local-gadgets\", \"banner\": \"categoriesbanners/2026/08/cca8a1f6-9a95-4d51-b2e7-f01c94a971ee_1787668323.webp\", \"status\": \"inactive\", \"priority\": 1, \"created_at\": \"2026-08-25T14:32:03.000000Z\", \"updated_at\": \"2026-08-25T14:32:03.000000Z\"}', '{\"id\": 3, \"icon\": \"categoriesicons/2026/08/35636f03-4c03-472d-9977-3801e9687d21_1787668323.webp\", \"name\": \"Local Electronics\", \"slug\": \"local-electronics\", \"banner\": \"categoriesbanners/2026/08/cca8a1f6-9a95-4d51-b2e7-f01c94a971ee_1787668323.webp\", \"status\": \"active\", \"priority\": 2, \"created_at\": \"2026-08-25T14:32:03.000000Z\", \"updated_at\": \"2026-08-25T14:34:31.000000Z\"}', '2026-08-25 13:34:31', '2026-08-25 13:34:31'),
(9, 1, 'admin', 'category.update', 'Updated category \'Local Electronics\' (ID: 3)', '127.0.0.1', 'PostmanRuntime/2.3.0', 'Desktop', 'Unknown', 'Unknown', '{\"name\": \"Local Electronics\", \"status\": \"active\", \"priority\": \"2\"}', '{\"id\": 3, \"icon\": \"categoriesicons/2026/08/35636f03-4c03-472d-9977-3801e9687d21_1787668323.webp\", \"name\": \"Local Electronics\", \"slug\": \"local-electronics\", \"banner\": \"categoriesbanners/2026/08/cca8a1f6-9a95-4d51-b2e7-f01c94a971ee_1787668323.webp\", \"status\": \"active\", \"priority\": 2, \"created_at\": \"2026-08-25T14:32:03.000000Z\", \"updated_at\": \"2026-08-25T14:34:31.000000Z\"}', '{\"id\": 3, \"icon\": \"categoriesicons/2026/08/35636f03-4c03-472d-9977-3801e9687d21_1787668323.webp\", \"name\": \"Local Electronics\", \"slug\": \"local-electronics\", \"banner\": \"categoriesbanners/2026/08/cca8a1f6-9a95-4d51-b2e7-f01c94a971ee_1787668323.webp\", \"status\": \"active\", \"priority\": 2, \"created_at\": \"2026-08-25T14:32:03.000000Z\", \"updated_at\": \"2026-08-25T14:34:31.000000Z\"}', '2026-08-25 13:35:15', '2026-08-25 13:35:15'),
(10, 1, 'admin', 'category.update', 'Updated category \'Local Electronics\' (ID: 3)', '127.0.0.1', 'PostmanRuntime/2.3.0', 'Desktop', 'Unknown', 'Unknown', '{\"name\": \"Local Electronics\", \"status\": \"active\", \"priority\": \"2\"}', '{\"id\": 3, \"icon\": \"categoriesicons/2026/08/35636f03-4c03-472d-9977-3801e9687d21_1787668323.webp\", \"name\": \"Local Electronics\", \"slug\": \"local-electronics\", \"banner\": \"categoriesbanners/2026/08/cca8a1f6-9a95-4d51-b2e7-f01c94a971ee_1787668323.webp\", \"status\": \"active\", \"priority\": 2, \"created_at\": \"2026-08-25T14:32:03.000000Z\", \"updated_at\": \"2026-08-25T14:34:31.000000Z\"}', '{\"id\": 3, \"icon\": \"categoriesicons/2026/08/35636f03-4c03-472d-9977-3801e9687d21_1787668323.webp\", \"name\": \"Local Electronics\", \"slug\": \"local-electronics\", \"banner\": \"categoriesbanners/2026/08/cca8a1f6-9a95-4d51-b2e7-f01c94a971ee_1787668323.webp\", \"status\": \"active\", \"priority\": 2, \"created_at\": \"2026-08-25T14:32:03.000000Z\", \"updated_at\": \"2026-08-25T14:34:31.000000Z\"}', '2026-08-25 13:35:22', '2026-08-25 13:35:22'),
(11, 1, 'admin', 'category.update', 'Updated category \'Local Electronics\' (ID: 3)', '127.0.0.1', 'PostmanRuntime/2.3.0', 'Desktop', 'Unknown', 'Unknown', '{\"icon\": {}, \"name\": \"Local Electronics\", \"status\": \"active\", \"priority\": \"2\"}', '{\"id\": 3, \"icon\": \"categoriesicons/2026/08/35636f03-4c03-472d-9977-3801e9687d21_1787668323.webp\", \"name\": \"Local Electronics\", \"slug\": \"local-electronics\", \"banner\": \"categoriesbanners/2026/08/cca8a1f6-9a95-4d51-b2e7-f01c94a971ee_1787668323.webp\", \"status\": \"active\", \"priority\": 2, \"created_at\": \"2026-08-25T14:32:03.000000Z\", \"updated_at\": \"2026-08-25T14:34:31.000000Z\"}', '{\"id\": 3, \"icon\": \"categoriesicons/2026/08/35aac74b-348e-4127-b5d0-8d157943abdd_1787668526.webp\", \"name\": \"Local Electronics\", \"slug\": \"local-electronics\", \"banner\": \"categoriesbanners/2026/08/cca8a1f6-9a95-4d51-b2e7-f01c94a971ee_1787668323.webp\", \"status\": \"active\", \"priority\": 2, \"created_at\": \"2026-08-25T14:32:03.000000Z\", \"updated_at\": \"2026-08-25T14:35:26.000000Z\"}', '2026-08-25 13:35:26', '2026-08-25 13:35:26'),
(12, 1, 'admin', 'category.update', 'Updated category \'Local Electronics\' (ID: 3)', '127.0.0.1', 'PostmanRuntime/2.3.0', 'Desktop', 'Unknown', 'Unknown', '{\"icon\": {}, \"name\": \"Local Electronics\", \"status\": \"active\", \"priority\": \"2\"}', '{\"id\": 3, \"icon\": \"categoriesicons/2026/08/35aac74b-348e-4127-b5d0-8d157943abdd_1787668526.webp\", \"name\": \"Local Electronics\", \"slug\": \"local-electronics\", \"banner\": \"categoriesbanners/2026/08/cca8a1f6-9a95-4d51-b2e7-f01c94a971ee_1787668323.webp\", \"status\": \"active\", \"priority\": 2, \"created_at\": \"2026-08-25T14:32:03.000000Z\", \"updated_at\": \"2026-08-25T14:35:26.000000Z\"}', '{\"id\": 3, \"icon\": \"categoriesicons/2026/08/197b6f6b-33ca-4dca-a638-ed26a76a7066_1787668530.webp\", \"name\": \"Local Electronics\", \"slug\": \"local-electronics\", \"banner\": \"categoriesbanners/2026/08/cca8a1f6-9a95-4d51-b2e7-f01c94a971ee_1787668323.webp\", \"status\": \"active\", \"priority\": 2, \"created_at\": \"2026-08-25T14:32:03.000000Z\", \"updated_at\": \"2026-08-25T14:35:30.000000Z\"}', '2026-08-25 13:35:30', '2026-08-25 13:35:30'),
(13, 1, 'admin', 'category.update', 'Updated category \'Local Electronics\' (ID: 3)', '127.0.0.1', 'PostmanRuntime/2.3.0', 'Desktop', 'Unknown', 'Unknown', '{\"icon\": {}, \"name\": \"Local Electronics\", \"status\": \"active\", \"priority\": \"2\"}', '{\"id\": 3, \"icon\": \"categoriesicons/2026/08/197b6f6b-33ca-4dca-a638-ed26a76a7066_1787668530.webp\", \"name\": \"Local Electronics\", \"slug\": \"local-electronics\", \"banner\": \"categoriesbanners/2026/08/cca8a1f6-9a95-4d51-b2e7-f01c94a971ee_1787668323.webp\", \"status\": \"active\", \"priority\": 2, \"created_at\": \"2026-08-25T14:32:03.000000Z\", \"updated_at\": \"2026-08-25T14:35:30.000000Z\"}', '{\"id\": 3, \"icon\": \"categories/icons/2026/08/d5479097-01ee-4e30-9092-0b3b1d6fb373_1787668611.webp\", \"name\": \"Local Electronics\", \"slug\": \"local-electronics\", \"banner\": \"categoriesbanners/2026/08/cca8a1f6-9a95-4d51-b2e7-f01c94a971ee_1787668323.webp\", \"status\": \"active\", \"priority\": 2, \"created_at\": \"2026-08-25T14:32:03.000000Z\", \"updated_at\": \"2026-08-25T14:36:51.000000Z\"}', '2026-08-25 13:36:51', '2026-08-25 13:36:51'),
(14, 1, 'admin', 'product.create', 'Created product \'Wireless Noise-Canceling Headphones\' (ID: 1)', '127.0.0.1', 'PostmanRuntime/2.3.0', 'Desktop', 'Unknown', 'Unknown', '{\"sku\": \"HP-ANC-001\", \"name\": \"Wireless Noise-Canceling Headphones\", \"brand_id\": \"1\", \"discount\": \"10\", \"seller_id\": \"2\", \"unit_price\": \"199.99\", \"category_id\": \"2\", \"description\": \"Experience studio-grade sound with ultra-comfortable ear cushions and up to 30 hours of battery life.\", \"product_type\": \"physical\", \"current_stock\": \"50\", \"discount_type\": \"percent\", \"purchase_price\": \"120.00\", \"short_description\": \"High-fidelity audio with active noise cancellation.\"}', NULL, '{\"id\": 1, \"sku\": \"HP-ANC-001\", \"tax\": 0, \"name\": \"Wireless Noise-Canceling Headphones\", \"slug\": \"wireless-noise-canceling-headphones-ft0t9\", \"tags\": [], \"unit\": null, \"width\": 0, \"height\": 0, \"images\": [], \"length\": 0, \"status\": \"approved\", \"weight\": 0, \"brand_id\": \"1\", \"discount\": 10, \"tax_type\": \"flat\", \"published\": true, \"seller_id\": \"2\", \"thumbnail\": \"products/thumbnails/2026/08/177f96a2-e359-4d2a-9cc4-552a4112d4cc_1787669126.webp\", \"created_at\": \"2026-08-25T14:45:26.000000Z\", \"meta_image\": null, \"meta_title\": null, \"unit_price\": 199.99, \"updated_at\": \"2026-08-25T14:45:26.000000Z\", \"category_id\": \"2\", \"description\": \"Experience studio-grade sound with ultra-comfortable ear cushions and up to 30 hours of battery life.\", \"is_featured\": false, \"digital_file\": null, \"multiply_qty\": false, \"product_type\": \"physical\", \"stock_status\": \"in_stock\", \"current_stock\": \"50\", \"denied_reason\": null, \"discount_type\": \"percent\", \"shipping_cost\": 0, \"is_todays_deal\": false, \"purchase_price\": 120, \"sub_category_id\": null, \"meta_description\": null, \"digital_file_type\": null, \"minimum_order_qty\": 1, \"short_description\": \"High-fidelity audio with active noise cancellation.\", \"low_stock_threshold\": 5}', '2026-08-25 13:45:26', '2026-08-25 13:45:26'),
(15, 1, 'admin', 'product.create', 'Created product \'Wireless Noise-Canceling Headphones\' (ID: 2)', '127.0.0.1', 'PostmanRuntime/2.3.0', 'Desktop', 'Unknown', 'Unknown', '{\"sku\": \"HP-ANC-0012\", \"name\": \"Wireless Noise-Canceling Headphones\", \"brand_id\": \"1\", \"discount\": \"10\", \"seller_id\": \"2\", \"unit_price\": \"199.99\", \"category_id\": \"2\", \"description\": \"Experience studio-grade sound with ultra-comfortable ear cushions and up to 30 hours of battery life.\", \"product_type\": \"physical\", \"current_stock\": \"50\", \"discount_type\": \"percent\", \"gallery_images\": [{}, {}, {}, {}, {}], \"purchase_price\": \"120.00\", \"short_description\": \"High-fidelity audio with active noise cancellation.\"}', NULL, '{\"id\": 2, \"sku\": \"HP-ANC-0012\", \"tax\": 0, \"name\": \"Wireless Noise-Canceling Headphones\", \"slug\": \"wireless-noise-canceling-headphones-b8fnV\", \"tags\": [], \"unit\": null, \"width\": 0, \"height\": 0, \"images\": [\"products/gallery/2026/08/9ad32e1e-9ef8-491b-950c-8be6da996e3c_1787669343.webp\", \"products/gallery/2026/08/1653f53d-e006-4547-ba8d-c645f10dd68c_1787669343.webp\", \"products/gallery/2026/08/694e24ae-53b9-47fc-b99f-cae606408418_1787669343.webp\", \"products/gallery/2026/08/c40606e7-f84c-4370-b982-8e2b30595be6_1787669343.webp\", \"products/gallery/2026/08/8331c756-ee47-4971-8c4d-95ec3e554c23_1787669343.webp\"], \"length\": 0, \"status\": \"approved\", \"weight\": 0, \"brand_id\": \"1\", \"discount\": 10, \"tax_type\": \"flat\", \"published\": true, \"seller_id\": \"2\", \"thumbnail\": \"products/thumbnails/2026/08/366ecf4d-61c8-4e96-be46-6f8782103694_1787669343.webp\", \"created_at\": \"2026-08-25T14:49:03.000000Z\", \"meta_image\": null, \"meta_title\": null, \"unit_price\": 199.99, \"updated_at\": \"2026-08-25T14:49:03.000000Z\", \"category_id\": \"2\", \"description\": \"Experience studio-grade sound with ultra-comfortable ear cushions and up to 30 hours of battery life.\", \"is_featured\": false, \"digital_file\": null, \"multiply_qty\": false, \"product_type\": \"physical\", \"stock_status\": \"in_stock\", \"current_stock\": \"50\", \"denied_reason\": null, \"discount_type\": \"percent\", \"shipping_cost\": 0, \"is_todays_deal\": false, \"purchase_price\": 120, \"sub_category_id\": null, \"meta_description\": null, \"digital_file_type\": null, \"minimum_order_qty\": 1, \"short_description\": \"High-fidelity audio with active noise cancellation.\", \"low_stock_threshold\": 5}', '2026-08-25 13:49:03', '2026-08-25 13:49:03'),
(16, 1, 'admin', 'product.create', 'Created product \'Wireless Noise-Canceling Headphones\' (ID: 4)', '127.0.0.1', 'PostmanRuntime/2.3.0', 'Desktop', 'Unknown', 'Unknown', '{\"sku\": \"HP-ANC-00123\", \"name\": \"Wireless Noise-Canceling Headphones\", \"brand_id\": \"1\", \"discount\": \"10\", \"seller_id\": \"2\", \"unit_price\": \"199.99\", \"category_id\": \"2\", \"description\": \"Experience studio-grade sound with ultra-comfortable ear cushions and up to 30 hours of battery life.\", \"product_type\": \"physical\", \"current_stock\": \"50\", \"discount_type\": \"percent\", \"gallery_images\": [{}, {}, {}, {}, {}], \"purchase_price\": \"120.00\", \"sub_category_id\": \"1\", \"short_description\": \"High-fidelity audio with active noise cancellation.\"}', NULL, '{\"id\": 4, \"sku\": \"HP-ANC-00123\", \"tax\": 0, \"name\": \"Wireless Noise-Canceling Headphones\", \"slug\": \"wireless-noise-canceling-headphones-mfjPC\", \"tags\": [], \"unit\": null, \"width\": 0, \"height\": 0, \"images\": [\"products/gallery/2026/08/fbfab8d1-ce94-4b70-bbd5-9163778a2881_1787669596.webp\", \"products/gallery/2026/08/b76f5b0b-08fa-4d25-8e6b-072eded7393c_1787669597.webp\", \"products/gallery/2026/08/f5e1188b-6ff5-44da-8ff6-8f7f0d6664a3_1787669597.webp\", \"products/gallery/2026/08/0436d1c5-ef18-4334-a3f8-657600921628_1787669597.webp\", \"products/gallery/2026/08/84e76e65-58af-4e60-b20c-bde7d9d5dfe3_1787669597.webp\"], \"length\": 0, \"status\": \"approved\", \"weight\": 0, \"brand_id\": \"1\", \"discount\": 10, \"tax_type\": \"flat\", \"published\": true, \"seller_id\": \"2\", \"thumbnail\": \"products/thumbnails/2026/08/2561d78d-a3e9-467d-897b-611f3adb1668_1787669596.webp\", \"created_at\": \"2026-08-25T14:53:17.000000Z\", \"meta_image\": null, \"meta_title\": null, \"unit_price\": 199.99, \"updated_at\": \"2026-08-25T14:53:17.000000Z\", \"category_id\": \"2\", \"description\": \"Experience studio-grade sound with ultra-comfortable ear cushions and up to 30 hours of battery life.\", \"is_featured\": false, \"digital_file\": null, \"multiply_qty\": false, \"product_type\": \"physical\", \"stock_status\": \"in_stock\", \"current_stock\": \"50\", \"denied_reason\": null, \"discount_type\": \"percent\", \"shipping_cost\": 0, \"is_todays_deal\": false, \"purchase_price\": 120, \"sub_category_id\": \"1\", \"meta_description\": null, \"digital_file_type\": null, \"minimum_order_qty\": 1, \"short_description\": \"High-fidelity audio with active noise cancellation.\", \"low_stock_threshold\": 5}', '2026-08-25 13:53:17', '2026-08-25 13:53:17'),
(17, 1, 'admin', 'subcategory.create', 'Created subcategory \'Digital Illustrations\' (ID: 2) under Category ID 2', '127.0.0.1', 'PostmanRuntime/2.3.0', 'Desktop', 'Unknown', 'Unknown', '{\"name\": \"Digital Illustrations\", \"priority\": 1, \"category_id\": 2}', NULL, '{\"id\": 2, \"name\": \"Digital Illustrations\", \"slug\": \"digital-illustrations-pObm\", \"status\": null, \"priority\": 1, \"created_at\": \"2026-08-25T15:25:13.000000Z\", \"updated_at\": \"2026-08-25T15:25:13.000000Z\", \"category_id\": 2}', '2026-08-25 14:25:13', '2026-08-25 14:25:13'),
(18, 1, 'admin', 'subcategory.update', 'Updated subcategory \'Modern & Contemporary Art\' (ID: 1)', '127.0.0.1', 'PostmanRuntime/2.3.0', 'Desktop', 'Unknown', 'Unknown', '{\"name\": \"Modern & Contemporary Art\", \"status\": \"inactive\", \"priority\": 2, \"category_id\": 2}', '{\"id\": 1, \"name\": \"Best\", \"slug\": \"best\", \"status\": \"active\", \"priority\": 1, \"created_at\": \"2026-08-25T15:51:51.000000Z\", \"updated_at\": \"2026-08-25T15:51:51.000000Z\", \"category_id\": 2}', '{\"id\": 1, \"name\": \"Modern & Contemporary Art\", \"slug\": \"modern-contemporary-art-IOUn\", \"status\": \"inactive\", \"priority\": 2, \"created_at\": \"2026-08-25T15:51:51.000000Z\", \"updated_at\": \"2026-08-25T15:25:49.000000Z\", \"category_id\": 2}', '2026-08-25 14:25:49', '2026-08-25 14:25:49'),
(19, 1, 'admin', 'product.create', 'Created product \'Wireless Noise-Canceling Headphones\' (ID: 7)', '127.0.0.1', 'PostmanRuntime/2.3.0', 'Desktop', 'Unknown', 'Unknown', '{\"sku\": \"HP-ANC-0013267\", \"name\": \"Wireless Noise-Canceling Headphones\", \"colors\": [\"2\"], \"brand_id\": \"1\", \"discount\": \"10\", \"seller_id\": \"2\", \"attributes\": {\"2\": [\"3\"]}, \"meta_image\": {}, \"unit_price\": \"199.99\", \"category_id\": \"2\", \"description\": \"Experience studio-grade sound with ultra-comfortable ear cushions and up to 30 hours of battery life.\", \"product_type\": \"physical\", \"current_stock\": \"50\", \"discount_type\": \"percent\", \"gallery_images\": [{}, {}, {}, {}, {}], \"purchase_price\": \"120.00\", \"sub_category_id\": \"1\", \"short_description\": \"High-fidelity audio with active noise cancellation.\"}', NULL, '{\"id\": 7, \"sku\": \"HP-ANC-0013267\", \"tax\": 0, \"name\": \"Wireless Noise-Canceling Headphones\", \"slug\": \"wireless-noise-canceling-headphones-6NhhM\", \"tags\": [], \"unit\": null, \"images\": [\"products/gallery/2026/08/7fd27f8d-772e-4e93-b334-b69b9e7448e6_1787677755.webp\", \"products/gallery/2026/08/72b85c72-715c-4299-bc6c-390b2ae9f2d0_1787677755.webp\", \"products/gallery/2026/08/aec3b831-bf2c-4a33-a05d-eaba69f8cd8c_1787677755.webp\", \"products/gallery/2026/08/00f5319c-eb0c-48d6-b2b7-4cc54917386f_1787677755.webp\", \"products/gallery/2026/08/8537d32a-7769-45b5-8728-9cfd9f531a46_1787677755.webp\"], \"status\": \"approved\", \"brand_id\": \"1\", \"discount\": 10, \"tax_type\": \"flat\", \"published\": true, \"seller_id\": \"2\", \"thumbnail\": \"products/thumbnails/2026/08/b68fa7a2-8295-4615-822a-6877b60e07e1_1787677755.webp\", \"created_at\": \"2026-08-25T17:09:16.000000Z\", \"meta_image\": \"products/meta/2026/08/81381953-d3de-4251-bd23-408b65ac0e43_1787677755.webp\", \"meta_title\": null, \"unit_price\": 199.99, \"updated_at\": \"2026-08-25T17:09:16.000000Z\", \"category_id\": \"2\", \"description\": \"Experience studio-grade sound with ultra-comfortable ear cushions and up to 30 hours of battery life.\", \"is_featured\": false, \"digital_file\": null, \"multiply_qty\": false, \"product_type\": \"physical\", \"stock_status\": \"in_stock\", \"current_stock\": \"50\", \"denied_reason\": null, \"discount_type\": \"percent\", \"shipping_cost\": 0, \"is_todays_deal\": false, \"purchase_price\": 120, \"sub_category_id\": \"1\", \"meta_description\": null, \"digital_file_type\": null, \"minimum_order_qty\": 1, \"short_description\": \"High-fidelity audio with active noise cancellation.\", \"low_stock_threshold\": 5}', '2026-08-25 16:09:16', '2026-08-25 16:09:16'),
(20, 1, 'admin', 'product.update', 'Updated product \'Wireless Noise-Canceling Headphones Pro\' (ID: 1)', '127.0.0.1', 'PostmanRuntime/2.3.0', 'Desktop', 'Unknown', 'Unknown', '{\"name\": \"Wireless Noise-Canceling Headphones Pro\", \"unit_price\": \"229.99\", \"current_stock\": \"75\"}', '{\"id\": 1, \"sku\": \"HP-ANC-001\", \"tax\": 0, \"name\": \"Wireless Noise-Canceling Headphones\", \"slug\": \"wireless-noise-canceling-headphones-ft0t9\", \"tags\": [], \"unit\": null, \"images\": [], \"status\": \"approved\", \"brand_id\": 1, \"discount\": 10, \"tax_type\": \"flat\", \"published\": true, \"seller_id\": 2, \"thumbnail\": \"products/thumbnails/2026/08/177f96a2-e359-4d2a-9cc4-552a4112d4cc_1787669126.webp\", \"created_at\": \"2026-08-25T14:45:26.000000Z\", \"deleted_at\": null, \"meta_image\": null, \"meta_title\": null, \"unit_price\": 199.99, \"updated_at\": \"2026-08-25T14:45:26.000000Z\", \"variations\": [], \"category_id\": 2, \"description\": \"Experience studio-grade sound with ultra-comfortable ear cushions and up to 30 hours of battery life.\", \"is_featured\": false, \"digital_file\": null, \"multiply_qty\": false, \"product_type\": \"physical\", \"stock_status\": \"in_stock\", \"current_stock\": 50, \"denied_reason\": null, \"discount_type\": \"percent\", \"shipping_cost\": 0, \"is_todays_deal\": false, \"purchase_price\": 120, \"sub_category_id\": null, \"meta_description\": null, \"digital_file_type\": null, \"minimum_order_qty\": 1, \"short_description\": \"High-fidelity audio with active noise cancellation.\", \"low_stock_threshold\": 5}', '{\"id\": 1, \"sku\": \"HP-ANC-001\", \"tax\": 0, \"name\": \"Wireless Noise-Canceling Headphones Pro\", \"slug\": \"wireless-noise-canceling-headphones-pro-SdXPQ\", \"tags\": [], \"unit\": null, \"images\": [], \"status\": \"approved\", \"brand_id\": 1, \"discount\": 10, \"tax_type\": \"flat\", \"published\": true, \"seller_id\": 2, \"thumbnail\": \"products/thumbnails/2026/08/177f96a2-e359-4d2a-9cc4-552a4112d4cc_1787669126.webp\", \"created_at\": \"2026-08-25T14:45:26.000000Z\", \"deleted_at\": null, \"meta_image\": null, \"meta_title\": null, \"unit_price\": 229.99, \"updated_at\": \"2026-08-25T17:22:47.000000Z\", \"variations\": [], \"category_id\": 2, \"description\": \"Experience studio-grade sound with ultra-comfortable ear cushions and up to 30 hours of battery life.\", \"is_featured\": false, \"digital_file\": null, \"multiply_qty\": false, \"product_type\": \"physical\", \"stock_status\": \"in_stock\", \"current_stock\": 75, \"denied_reason\": null, \"discount_type\": \"percent\", \"shipping_cost\": 0, \"is_todays_deal\": false, \"purchase_price\": 120, \"sub_category_id\": null, \"meta_description\": null, \"digital_file_type\": null, \"minimum_order_qty\": 1, \"short_description\": \"High-fidelity audio with active noise cancellation.\", \"low_stock_threshold\": 5}', '2026-08-25 16:22:47', '2026-08-25 16:22:47'),
(21, 1, 'admin', 'product.update', 'Updated product \'Wireless Noise-Canceling Headphones Pro\' (ID: 1)', '127.0.0.1', 'PostmanRuntime/2.3.0', 'Desktop', 'Unknown', 'Unknown', '{\"name\": \"Wireless Noise-Canceling Headphones Pro\", \"colors\": [\"2\"], \"attributes\": {\"2\": [\"3\"]}, \"unit_price\": \"229.99\", \"current_stock\": \"75\"}', '{\"id\": 1, \"sku\": \"HP-ANC-001\", \"tax\": 0, \"name\": \"Wireless Noise-Canceling Headphones Pro\", \"slug\": \"wireless-noise-canceling-headphones-pro-SdXPQ\", \"tags\": [], \"unit\": null, \"images\": [], \"status\": \"approved\", \"brand_id\": 1, \"discount\": 10, \"tax_type\": \"flat\", \"published\": true, \"seller_id\": 2, \"thumbnail\": \"products/thumbnails/2026/08/177f96a2-e359-4d2a-9cc4-552a4112d4cc_1787669126.webp\", \"created_at\": \"2026-08-25T14:45:26.000000Z\", \"deleted_at\": null, \"meta_image\": null, \"meta_title\": null, \"unit_price\": 229.99, \"updated_at\": \"2026-08-25T17:22:47.000000Z\", \"variations\": [], \"category_id\": 2, \"description\": \"Experience studio-grade sound with ultra-comfortable ear cushions and up to 30 hours of battery life.\", \"is_featured\": false, \"digital_file\": null, \"multiply_qty\": false, \"product_type\": \"physical\", \"stock_status\": \"in_stock\", \"current_stock\": 75, \"denied_reason\": null, \"discount_type\": \"percent\", \"shipping_cost\": 0, \"is_todays_deal\": false, \"purchase_price\": 120, \"sub_category_id\": null, \"meta_description\": null, \"digital_file_type\": null, \"minimum_order_qty\": 1, \"short_description\": \"High-fidelity audio with active noise cancellation.\", \"low_stock_threshold\": 5}', '{\"id\": 1, \"sku\": \"HP-ANC-001\", \"tax\": 0, \"name\": \"Wireless Noise-Canceling Headphones Pro\", \"slug\": \"wireless-noise-canceling-headphones-pro-SdXPQ\", \"tags\": [], \"unit\": null, \"images\": [], \"status\": \"approved\", \"brand_id\": 1, \"discount\": 10, \"tax_type\": \"flat\", \"published\": true, \"seller_id\": 2, \"thumbnail\": \"products/thumbnails/2026/08/177f96a2-e359-4d2a-9cc4-552a4112d4cc_1787669126.webp\", \"created_at\": \"2026-08-25T14:45:26.000000Z\", \"deleted_at\": null, \"meta_image\": null, \"meta_title\": null, \"unit_price\": 229.99, \"updated_at\": \"2026-08-25T17:22:47.000000Z\", \"variations\": [{\"id\": 2, \"color_id\": 2, \"created_at\": \"2026-08-25T17:29:54.000000Z\", \"product_id\": 1, \"updated_at\": \"2026-08-25T17:29:54.000000Z\", \"attribute_id\": null, \"attribute_value_ids\": []}], \"category_id\": 2, \"description\": \"Experience studio-grade sound with ultra-comfortable ear cushions and up to 30 hours of battery life.\", \"is_featured\": false, \"digital_file\": null, \"multiply_qty\": false, \"product_type\": \"physical\", \"stock_status\": \"in_stock\", \"current_stock\": 75, \"denied_reason\": null, \"discount_type\": \"percent\", \"shipping_cost\": 0, \"is_todays_deal\": false, \"purchase_price\": 120, \"sub_category_id\": null, \"meta_description\": null, \"digital_file_type\": null, \"minimum_order_qty\": 1, \"short_description\": \"High-fidelity audio with active noise cancellation.\", \"low_stock_threshold\": 5}', '2026-08-25 16:29:54', '2026-08-25 16:29:54'),
(22, 1, 'admin', 'product.update', 'Updated product \'Wireless Noise-Canceling Headphones Pro\' (ID: 1)', '127.0.0.1', 'PostmanRuntime/2.3.0', 'Desktop', 'Unknown', 'Unknown', '{\"name\": \"Wireless Noise-Canceling Headphones Pro\", \"colors\": [\"2\"], \"attributes\": {\"2\": [\"3\"]}, \"unit_price\": \"229.99\", \"current_stock\": \"75\"}', '{\"id\": 1, \"sku\": \"HP-ANC-001\", \"tax\": 0, \"name\": \"Wireless Noise-Canceling Headphones Pro\", \"slug\": \"wireless-noise-canceling-headphones-pro-SdXPQ\", \"tags\": [], \"unit\": null, \"images\": [], \"status\": \"approved\", \"brand_id\": 1, \"discount\": 10, \"tax_type\": \"flat\", \"published\": true, \"seller_id\": 2, \"thumbnail\": \"products/thumbnails/2026/08/177f96a2-e359-4d2a-9cc4-552a4112d4cc_1787669126.webp\", \"created_at\": \"2026-08-25T14:45:26.000000Z\", \"deleted_at\": null, \"meta_image\": null, \"meta_title\": null, \"unit_price\": 229.99, \"updated_at\": \"2026-08-25T17:22:47.000000Z\", \"variations\": [{\"id\": 2, \"color_id\": 2, \"created_at\": \"2026-08-25T17:29:54.000000Z\", \"product_id\": 1, \"updated_at\": \"2026-08-25T17:29:54.000000Z\", \"attribute_id\": null, \"attribute_value_ids\": []}], \"category_id\": 2, \"description\": \"Experience studio-grade sound with ultra-comfortable ear cushions and up to 30 hours of battery life.\", \"is_featured\": false, \"digital_file\": null, \"multiply_qty\": false, \"product_type\": \"physical\", \"stock_status\": \"in_stock\", \"current_stock\": 75, \"denied_reason\": null, \"discount_type\": \"percent\", \"shipping_cost\": 0, \"is_todays_deal\": false, \"purchase_price\": 120, \"sub_category_id\": null, \"meta_description\": null, \"digital_file_type\": null, \"minimum_order_qty\": 1, \"short_description\": \"High-fidelity audio with active noise cancellation.\", \"low_stock_threshold\": 5}', '{\"id\": 1, \"sku\": \"HP-ANC-001\", \"tax\": 0, \"name\": \"Wireless Noise-Canceling Headphones Pro\", \"slug\": \"wireless-noise-canceling-headphones-pro-SdXPQ\", \"tags\": [], \"unit\": null, \"images\": [], \"status\": \"approved\", \"brand_id\": 1, \"discount\": 10, \"tax_type\": \"flat\", \"published\": true, \"seller_id\": 2, \"thumbnail\": \"products/thumbnails/2026/08/177f96a2-e359-4d2a-9cc4-552a4112d4cc_1787669126.webp\", \"created_at\": \"2026-08-25T14:45:26.000000Z\", \"deleted_at\": null, \"meta_image\": null, \"meta_title\": null, \"unit_price\": 229.99, \"updated_at\": \"2026-08-25T17:22:47.000000Z\", \"variations\": [{\"id\": 3, \"color_id\": 2, \"created_at\": \"2026-08-25T17:30:30.000000Z\", \"product_id\": 1, \"updated_at\": \"2026-08-25T17:30:30.000000Z\", \"attribute_id\": null, \"attribute_value_ids\": []}], \"category_id\": 2, \"description\": \"Experience studio-grade sound with ultra-comfortable ear cushions and up to 30 hours of battery life.\", \"is_featured\": false, \"digital_file\": null, \"multiply_qty\": false, \"product_type\": \"physical\", \"stock_status\": \"in_stock\", \"current_stock\": 75, \"denied_reason\": null, \"discount_type\": \"percent\", \"shipping_cost\": 0, \"is_todays_deal\": false, \"purchase_price\": 120, \"sub_category_id\": null, \"meta_description\": null, \"digital_file_type\": null, \"minimum_order_qty\": 1, \"short_description\": \"High-fidelity audio with active noise cancellation.\", \"low_stock_threshold\": 5}', '2026-08-25 16:30:30', '2026-08-25 16:30:30'),
(23, 1, 'admin', 'product.update', 'Updated product \'Wireless Noise-Canceling Headphones Pro\' (ID: 1)', '127.0.0.1', 'PostmanRuntime/2.3.0', 'Desktop', 'Unknown', 'Unknown', '{\"name\": \"Wireless Noise-Canceling Headphones Pro\", \"colors\": [\"2\"], \"attributes\": {\"2\": [\"3\"]}, \"unit_price\": \"229.99\", \"current_stock\": \"75\"}', '{\"id\": 1, \"sku\": \"HP-ANC-001\", \"tax\": 0, \"name\": \"Wireless Noise-Canceling Headphones Pro\", \"slug\": \"wireless-noise-canceling-headphones-pro-SdXPQ\", \"tags\": [], \"unit\": null, \"images\": [], \"status\": \"approved\", \"brand_id\": 1, \"discount\": 10, \"tax_type\": \"flat\", \"published\": true, \"seller_id\": 2, \"thumbnail\": \"products/thumbnails/2026/08/177f96a2-e359-4d2a-9cc4-552a4112d4cc_1787669126.webp\", \"created_at\": \"2026-08-25T14:45:26.000000Z\", \"deleted_at\": null, \"meta_image\": null, \"meta_title\": null, \"unit_price\": 229.99, \"updated_at\": \"2026-08-25T17:22:47.000000Z\", \"variations\": [], \"category_id\": 2, \"description\": \"Experience studio-grade sound with ultra-comfortable ear cushions and up to 30 hours of battery life.\", \"is_featured\": false, \"digital_file\": null, \"multiply_qty\": false, \"product_type\": \"physical\", \"stock_status\": \"in_stock\", \"current_stock\": 75, \"denied_reason\": null, \"discount_type\": \"percent\", \"shipping_cost\": 0, \"is_todays_deal\": false, \"purchase_price\": 120, \"sub_category_id\": null, \"meta_description\": null, \"digital_file_type\": null, \"minimum_order_qty\": 1, \"short_description\": \"High-fidelity audio with active noise cancellation.\", \"low_stock_threshold\": 5}', '{\"id\": 1, \"sku\": \"HP-ANC-001\", \"tax\": 0, \"name\": \"Wireless Noise-Canceling Headphones Pro\", \"slug\": \"wireless-noise-canceling-headphones-pro-SdXPQ\", \"tags\": [], \"unit\": null, \"images\": [], \"status\": \"approved\", \"brand_id\": 1, \"discount\": 10, \"tax_type\": \"flat\", \"published\": true, \"seller_id\": 2, \"thumbnail\": \"products/thumbnails/2026/08/177f96a2-e359-4d2a-9cc4-552a4112d4cc_1787669126.webp\", \"created_at\": \"2026-08-25T14:45:26.000000Z\", \"deleted_at\": null, \"meta_image\": null, \"meta_title\": null, \"unit_price\": 229.99, \"updated_at\": \"2026-08-25T17:22:47.000000Z\", \"variations\": [], \"category_id\": 2, \"description\": \"Experience studio-grade sound with ultra-comfortable ear cushions and up to 30 hours of battery life.\", \"is_featured\": false, \"digital_file\": null, \"multiply_qty\": false, \"product_type\": \"physical\", \"stock_status\": \"in_stock\", \"current_stock\": 75, \"denied_reason\": null, \"discount_type\": \"percent\", \"shipping_cost\": 0, \"is_todays_deal\": false, \"purchase_price\": 120, \"sub_category_id\": null, \"meta_description\": null, \"digital_file_type\": null, \"minimum_order_qty\": 1, \"short_description\": \"High-fidelity audio with active noise cancellation.\", \"low_stock_threshold\": 5}', '2026-08-25 16:48:35', '2026-08-25 16:48:35'),
(24, 1, 'admin', 'product.update', 'Updated product \'Wireless Noise-Canceling Headphones Pro\' (ID: 1)', '127.0.0.1', 'PostmanRuntime/2.3.0', 'Desktop', 'Unknown', 'Unknown', '{\"name\": \"Wireless Noise-Canceling Headphones Pro\", \"attributes\": {\"2\": [\"3\"]}, \"unit_price\": \"229.99\", \"current_stock\": \"75\"}', '{\"id\": 1, \"sku\": \"HP-ANC-001\", \"tax\": 0, \"name\": \"Wireless Noise-Canceling Headphones Pro\", \"slug\": \"wireless-noise-canceling-headphones-pro-SdXPQ\", \"tags\": [], \"unit\": null, \"images\": [], \"status\": \"approved\", \"brand_id\": 1, \"discount\": 10, \"tax_type\": \"flat\", \"published\": true, \"seller_id\": 2, \"thumbnail\": \"products/thumbnails/2026/08/177f96a2-e359-4d2a-9cc4-552a4112d4cc_1787669126.webp\", \"created_at\": \"2026-08-25T14:45:26.000000Z\", \"deleted_at\": null, \"meta_image\": null, \"meta_title\": null, \"unit_price\": 229.99, \"updated_at\": \"2026-08-25T17:22:47.000000Z\", \"variations\": [], \"category_id\": 2, \"description\": \"Experience studio-grade sound with ultra-comfortable ear cushions and up to 30 hours of battery life.\", \"is_featured\": false, \"digital_file\": null, \"multiply_qty\": false, \"product_type\": \"physical\", \"stock_status\": \"in_stock\", \"current_stock\": 75, \"denied_reason\": null, \"discount_type\": \"percent\", \"shipping_cost\": 0, \"is_todays_deal\": false, \"purchase_price\": 120, \"sub_category_id\": null, \"meta_description\": null, \"digital_file_type\": null, \"minimum_order_qty\": 1, \"short_description\": \"High-fidelity audio with active noise cancellation.\", \"low_stock_threshold\": 5}', '{\"id\": 1, \"sku\": \"HP-ANC-001\", \"tax\": 0, \"name\": \"Wireless Noise-Canceling Headphones Pro\", \"slug\": \"wireless-noise-canceling-headphones-pro-SdXPQ\", \"tags\": [], \"unit\": null, \"images\": [], \"status\": \"approved\", \"brand_id\": 1, \"discount\": 10, \"tax_type\": \"flat\", \"published\": true, \"seller_id\": 2, \"thumbnail\": \"products/thumbnails/2026/08/177f96a2-e359-4d2a-9cc4-552a4112d4cc_1787669126.webp\", \"created_at\": \"2026-08-25T14:45:26.000000Z\", \"deleted_at\": null, \"meta_image\": null, \"meta_title\": null, \"unit_price\": 229.99, \"updated_at\": \"2026-08-25T17:22:47.000000Z\", \"variations\": [], \"category_id\": 2, \"description\": \"Experience studio-grade sound with ultra-comfortable ear cushions and up to 30 hours of battery life.\", \"is_featured\": false, \"digital_file\": null, \"multiply_qty\": false, \"product_type\": \"physical\", \"stock_status\": \"in_stock\", \"current_stock\": 75, \"denied_reason\": null, \"discount_type\": \"percent\", \"shipping_cost\": 0, \"is_todays_deal\": false, \"purchase_price\": 120, \"sub_category_id\": null, \"meta_description\": null, \"digital_file_type\": null, \"minimum_order_qty\": 1, \"short_description\": \"High-fidelity audio with active noise cancellation.\", \"low_stock_threshold\": 5}', '2026-08-25 16:56:24', '2026-08-25 16:56:24'),
(25, 1, 'admin', 'product.update', 'Updated product \'Wireless Noise-Canceling Headphones Pro\' (ID: 1)', '127.0.0.1', 'PostmanRuntime/2.3.0', 'Desktop', 'Unknown', 'Unknown', '{\"name\": \"Wireless Noise-Canceling Headphones Pro\", \"unit_price\": \"229.99\", \"variations\": [{\"attribute_id\": \"3\", \"attribute_value_ids\": [\"3\"]}], \"current_stock\": \"75\"}', '{\"id\": 1, \"sku\": \"HP-ANC-001\", \"tax\": 0, \"name\": \"Wireless Noise-Canceling Headphones Pro\", \"slug\": \"wireless-noise-canceling-headphones-pro-SdXPQ\", \"tags\": [], \"unit\": null, \"images\": [], \"status\": \"approved\", \"brand_id\": 1, \"discount\": 10, \"tax_type\": \"flat\", \"published\": true, \"seller_id\": 2, \"thumbnail\": \"products/thumbnails/2026/08/177f96a2-e359-4d2a-9cc4-552a4112d4cc_1787669126.webp\", \"created_at\": \"2026-08-25T14:45:26.000000Z\", \"deleted_at\": null, \"meta_image\": null, \"meta_title\": null, \"unit_price\": 229.99, \"updated_at\": \"2026-08-25T17:22:47.000000Z\", \"variations\": [], \"category_id\": 2, \"description\": \"Experience studio-grade sound with ultra-comfortable ear cushions and up to 30 hours of battery life.\", \"is_featured\": false, \"digital_file\": null, \"multiply_qty\": false, \"product_type\": \"physical\", \"stock_status\": \"in_stock\", \"current_stock\": 75, \"denied_reason\": null, \"discount_type\": \"percent\", \"shipping_cost\": 0, \"is_todays_deal\": false, \"purchase_price\": 120, \"sub_category_id\": null, \"meta_description\": null, \"digital_file_type\": null, \"minimum_order_qty\": 1, \"short_description\": \"High-fidelity audio with active noise cancellation.\", \"low_stock_threshold\": 5}', '{\"id\": 1, \"sku\": \"HP-ANC-001\", \"tax\": 0, \"name\": \"Wireless Noise-Canceling Headphones Pro\", \"slug\": \"wireless-noise-canceling-headphones-pro-SdXPQ\", \"tags\": [], \"unit\": null, \"images\": [], \"status\": \"approved\", \"brand_id\": 1, \"discount\": 10, \"tax_type\": \"flat\", \"published\": true, \"seller_id\": 2, \"thumbnail\": \"products/thumbnails/2026/08/177f96a2-e359-4d2a-9cc4-552a4112d4cc_1787669126.webp\", \"created_at\": \"2026-08-25T14:45:26.000000Z\", \"deleted_at\": null, \"meta_image\": null, \"meta_title\": null, \"unit_price\": 229.99, \"updated_at\": \"2026-08-25T17:22:47.000000Z\", \"variations\": [{\"id\": 4, \"color_id\": null, \"created_at\": \"2026-08-25T18:00:31.000000Z\", \"product_id\": 1, \"updated_at\": \"2026-08-25T18:00:31.000000Z\", \"attribute_id\": 3, \"attribute_value_ids\": [\"3\"]}], \"category_id\": 2, \"description\": \"Experience studio-grade sound with ultra-comfortable ear cushions and up to 30 hours of battery life.\", \"is_featured\": false, \"digital_file\": null, \"multiply_qty\": false, \"product_type\": \"physical\", \"stock_status\": \"in_stock\", \"current_stock\": 75, \"denied_reason\": null, \"discount_type\": \"percent\", \"shipping_cost\": 0, \"is_todays_deal\": false, \"purchase_price\": 120, \"sub_category_id\": null, \"meta_description\": null, \"digital_file_type\": null, \"minimum_order_qty\": 1, \"short_description\": \"High-fidelity audio with active noise cancellation.\", \"low_stock_threshold\": 5}', '2026-08-25 17:00:31', '2026-08-25 17:00:31'),
(26, 1, 'admin', 'product.update', 'Updated product \'Wireless Noise-Canceling Headphones Pro\' (ID: 1)', '127.0.0.1', 'PostmanRuntime/2.3.0', 'Desktop', 'Unknown', 'Unknown', '{\"name\": \"Wireless Noise-Canceling Headphones Pro\", \"unit_price\": \"229.99\", \"variations\": [{\"attribute_id\": \"3\", \"attribute_value_ids\": [\"3\", \"7\"]}], \"current_stock\": \"75\"}', '{\"id\": 1, \"sku\": \"HP-ANC-001\", \"tax\": 0, \"name\": \"Wireless Noise-Canceling Headphones Pro\", \"slug\": \"wireless-noise-canceling-headphones-pro-SdXPQ\", \"tags\": [], \"unit\": null, \"images\": [], \"status\": \"approved\", \"brand_id\": 1, \"discount\": 10, \"tax_type\": \"flat\", \"published\": true, \"seller_id\": 2, \"thumbnail\": \"products/thumbnails/2026/08/177f96a2-e359-4d2a-9cc4-552a4112d4cc_1787669126.webp\", \"created_at\": \"2026-08-25T14:45:26.000000Z\", \"deleted_at\": null, \"meta_image\": null, \"meta_title\": null, \"unit_price\": 229.99, \"updated_at\": \"2026-08-25T17:22:47.000000Z\", \"variations\": [{\"id\": 4, \"color_id\": null, \"created_at\": \"2026-08-25T18:00:31.000000Z\", \"product_id\": 1, \"updated_at\": \"2026-08-25T18:00:31.000000Z\", \"attribute_id\": 3, \"attribute_value_ids\": [\"3\"]}], \"category_id\": 2, \"description\": \"Experience studio-grade sound with ultra-comfortable ear cushions and up to 30 hours of battery life.\", \"is_featured\": false, \"digital_file\": null, \"multiply_qty\": false, \"product_type\": \"physical\", \"stock_status\": \"in_stock\", \"current_stock\": 75, \"denied_reason\": null, \"discount_type\": \"percent\", \"shipping_cost\": 0, \"is_todays_deal\": false, \"purchase_price\": 120, \"sub_category_id\": null, \"meta_description\": null, \"digital_file_type\": null, \"minimum_order_qty\": 1, \"short_description\": \"High-fidelity audio with active noise cancellation.\", \"low_stock_threshold\": 5}', '{\"id\": 1, \"sku\": \"HP-ANC-001\", \"tax\": 0, \"name\": \"Wireless Noise-Canceling Headphones Pro\", \"slug\": \"wireless-noise-canceling-headphones-pro-SdXPQ\", \"tags\": [], \"unit\": null, \"images\": [], \"status\": \"approved\", \"brand_id\": 1, \"discount\": 10, \"tax_type\": \"flat\", \"published\": true, \"seller_id\": 2, \"thumbnail\": \"products/thumbnails/2026/08/177f96a2-e359-4d2a-9cc4-552a4112d4cc_1787669126.webp\", \"created_at\": \"2026-08-25T14:45:26.000000Z\", \"deleted_at\": null, \"meta_image\": null, \"meta_title\": null, \"unit_price\": 229.99, \"updated_at\": \"2026-08-25T17:22:47.000000Z\", \"variations\": [{\"id\": 5, \"color_id\": null, \"created_at\": \"2026-08-25T18:02:14.000000Z\", \"product_id\": 1, \"updated_at\": \"2026-08-25T18:02:14.000000Z\", \"attribute_id\": 3, \"attribute_value_ids\": [\"3\", \"7\"]}], \"category_id\": 2, \"description\": \"Experience studio-grade sound with ultra-comfortable ear cushions and up to 30 hours of battery life.\", \"is_featured\": false, \"digital_file\": null, \"multiply_qty\": false, \"product_type\": \"physical\", \"stock_status\": \"in_stock\", \"current_stock\": 75, \"denied_reason\": null, \"discount_type\": \"percent\", \"shipping_cost\": 0, \"is_todays_deal\": false, \"purchase_price\": 120, \"sub_category_id\": null, \"meta_description\": null, \"digital_file_type\": null, \"minimum_order_qty\": 1, \"short_description\": \"High-fidelity audio with active noise cancellation.\", \"low_stock_threshold\": 5}', '2026-08-25 17:02:14', '2026-08-25 17:02:14'),
(27, 1, NULL, 'update_own_profile', 'User updated their profile details', '127.0.0.1', 'PostmanRuntime/2.4.0', NULL, NULL, NULL, NULL, '{\"name\": \"Adetunji Kayode\", \"email\": \"admin@admin.com\", \"phone\": null}', '{\"name\": \"Oluwakayode Adetunji\", \"email\": \"admin@admin.com\", \"phone\": \"+2348012345678\"}', '2026-08-27 22:14:18', '2026-08-27 22:14:18'),
(28, 1, 'admin', 'product.unpublished', 'Unpublished product \'Wireless Noise-Canceling Headphones Pro\' (ID: 1)', '127.0.0.1', 'PostmanRuntime/2.4.0', 'Desktop', 'Unknown', 'Unknown', '{\"published\": 1}', '{\"id\": 1, \"sku\": \"HP-ANC-001\", \"tax\": 0, \"name\": \"Wireless Noise-Canceling Headphones Pro\", \"slug\": \"wireless-noise-canceling-headphones-pro-SdXPQ\", \"tags\": [], \"unit\": null, \"images\": [], \"status\": \"approved\", \"brand_id\": 1, \"discount\": 10, \"tax_type\": \"flat\", \"published\": true, \"seller_id\": 2, \"thumbnail\": \"products/thumbnails/2026/08/177f96a2-e359-4d2a-9cc4-552a4112d4cc_1787669126.webp\", \"created_at\": \"2026-08-25T14:45:26.000000Z\", \"deleted_at\": null, \"meta_image\": null, \"meta_title\": null, \"unit_price\": 229.99, \"updated_at\": \"2026-08-25T17:22:47.000000Z\", \"category_id\": 2, \"description\": \"Experience studio-grade sound with ultra-comfortable ear cushions and up to 30 hours of battery life.\", \"is_featured\": false, \"digital_file\": null, \"multiply_qty\": false, \"product_type\": \"physical\", \"stock_status\": \"in_stock\", \"current_stock\": 75, \"denied_reason\": null, \"discount_type\": \"percent\", \"shipping_cost\": 0, \"is_todays_deal\": false, \"purchase_price\": 120, \"sub_category_id\": null, \"meta_description\": null, \"digital_file_type\": null, \"minimum_order_qty\": 1, \"short_description\": \"High-fidelity audio with active noise cancellation.\", \"low_stock_threshold\": 5}', '{\"id\": 1, \"sku\": \"HP-ANC-001\", \"tax\": 0, \"name\": \"Wireless Noise-Canceling Headphones Pro\", \"slug\": \"wireless-noise-canceling-headphones-pro-SdXPQ\", \"tags\": [], \"unit\": null, \"images\": [], \"status\": \"approved\", \"brand_id\": 1, \"discount\": 10, \"tax_type\": \"flat\", \"published\": false, \"seller_id\": 2, \"thumbnail\": \"products/thumbnails/2026/08/177f96a2-e359-4d2a-9cc4-552a4112d4cc_1787669126.webp\", \"created_at\": \"2026-08-25T14:45:26.000000Z\", \"deleted_at\": null, \"meta_image\": null, \"meta_title\": null, \"unit_price\": 229.99, \"updated_at\": \"2026-08-30T08:58:03.000000Z\", \"category_id\": 2, \"description\": \"Experience studio-grade sound with ultra-comfortable ear cushions and up to 30 hours of battery life.\", \"is_featured\": false, \"digital_file\": null, \"multiply_qty\": false, \"product_type\": \"physical\", \"stock_status\": \"in_stock\", \"current_stock\": 75, \"denied_reason\": null, \"discount_type\": \"percent\", \"shipping_cost\": 0, \"is_todays_deal\": false, \"purchase_price\": 120, \"sub_category_id\": null, \"meta_description\": null, \"digital_file_type\": null, \"minimum_order_qty\": 1, \"short_description\": \"High-fidelity audio with active noise cancellation.\", \"low_stock_threshold\": 5}', '2026-08-30 07:58:03', '2026-08-30 07:58:03');
INSERT INTO `audit_logs` (`id`, `user_id`, `user_type`, `action`, `description`, `ip_address`, `user_agent`, `device`, `browser`, `platform`, `payload`, `old_values`, `new_values`, `created_at`, `updated_at`) VALUES
(29, 1, 'admin', 'product.published', 'Published product \'Wireless Noise-Canceling Headphones Pro\' (ID: 1)', '127.0.0.1', 'PostmanRuntime/2.4.0', 'Desktop', 'Unknown', 'Unknown', '{\"published\": 1}', '{\"id\": 1, \"sku\": \"HP-ANC-001\", \"tax\": 0, \"name\": \"Wireless Noise-Canceling Headphones Pro\", \"slug\": \"wireless-noise-canceling-headphones-pro-SdXPQ\", \"tags\": [], \"unit\": null, \"images\": [], \"status\": \"approved\", \"brand_id\": 1, \"discount\": 10, \"tax_type\": \"flat\", \"published\": false, \"seller_id\": 2, \"thumbnail\": \"products/thumbnails/2026/08/177f96a2-e359-4d2a-9cc4-552a4112d4cc_1787669126.webp\", \"created_at\": \"2026-08-25T14:45:26.000000Z\", \"deleted_at\": null, \"meta_image\": null, \"meta_title\": null, \"unit_price\": 229.99, \"updated_at\": \"2026-08-30T08:58:03.000000Z\", \"category_id\": 2, \"description\": \"Experience studio-grade sound with ultra-comfortable ear cushions and up to 30 hours of battery life.\", \"is_featured\": false, \"digital_file\": null, \"multiply_qty\": false, \"product_type\": \"physical\", \"stock_status\": \"in_stock\", \"current_stock\": 75, \"denied_reason\": null, \"discount_type\": \"percent\", \"shipping_cost\": 0, \"is_todays_deal\": false, \"purchase_price\": 120, \"sub_category_id\": null, \"meta_description\": null, \"digital_file_type\": null, \"minimum_order_qty\": 1, \"short_description\": \"High-fidelity audio with active noise cancellation.\", \"low_stock_threshold\": 5}', '{\"id\": 1, \"sku\": \"HP-ANC-001\", \"tax\": 0, \"name\": \"Wireless Noise-Canceling Headphones Pro\", \"slug\": \"wireless-noise-canceling-headphones-pro-SdXPQ\", \"tags\": [], \"unit\": null, \"images\": [], \"status\": \"approved\", \"brand_id\": 1, \"discount\": 10, \"tax_type\": \"flat\", \"published\": true, \"seller_id\": 2, \"thumbnail\": \"products/thumbnails/2026/08/177f96a2-e359-4d2a-9cc4-552a4112d4cc_1787669126.webp\", \"created_at\": \"2026-08-25T14:45:26.000000Z\", \"deleted_at\": null, \"meta_image\": null, \"meta_title\": null, \"unit_price\": 229.99, \"updated_at\": \"2026-08-30T08:58:04.000000Z\", \"category_id\": 2, \"description\": \"Experience studio-grade sound with ultra-comfortable ear cushions and up to 30 hours of battery life.\", \"is_featured\": false, \"digital_file\": null, \"multiply_qty\": false, \"product_type\": \"physical\", \"stock_status\": \"in_stock\", \"current_stock\": 75, \"denied_reason\": null, \"discount_type\": \"percent\", \"shipping_cost\": 0, \"is_todays_deal\": false, \"purchase_price\": 120, \"sub_category_id\": null, \"meta_description\": null, \"digital_file_type\": null, \"minimum_order_qty\": 1, \"short_description\": \"High-fidelity audio with active noise cancellation.\", \"low_stock_threshold\": 5}', '2026-08-30 07:58:04', '2026-08-30 07:58:04'),
(30, 1, 'admin', 'product.unpublished', 'Unpublished product \'Wireless Noise-Canceling Headphones\' (ID: 7)', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'Desktop', 'Chrome', 'macOS', '{\"published\": false}', '{\"id\": 7, \"sku\": \"HP-ANC-0013267\", \"tax\": 0, \"name\": \"Wireless Noise-Canceling Headphones\", \"slug\": \"wireless-noise-canceling-headphones-6NhhM\", \"tags\": [], \"unit\": null, \"images\": [\"products/gallery/2026/08/7fd27f8d-772e-4e93-b334-b69b9e7448e6_1787677755.webp\", \"products/gallery/2026/08/72b85c72-715c-4299-bc6c-390b2ae9f2d0_1787677755.webp\", \"products/gallery/2026/08/aec3b831-bf2c-4a33-a05d-eaba69f8cd8c_1787677755.webp\", \"products/gallery/2026/08/00f5319c-eb0c-48d6-b2b7-4cc54917386f_1787677755.webp\", \"products/gallery/2026/08/8537d32a-7769-45b5-8728-9cfd9f531a46_1787677755.webp\"], \"status\": \"approved\", \"brand_id\": 1, \"discount\": 10, \"tax_type\": \"flat\", \"published\": true, \"seller_id\": 2, \"thumbnail\": \"products/thumbnails/2026/08/b68fa7a2-8295-4615-822a-6877b60e07e1_1787677755.webp\", \"created_at\": \"2026-08-25T17:09:16.000000Z\", \"deleted_at\": null, \"meta_image\": \"products/meta/2026/08/81381953-d3de-4251-bd23-408b65ac0e43_1787677755.webp\", \"meta_title\": null, \"unit_price\": 199.99, \"updated_at\": \"2026-08-25T17:09:16.000000Z\", \"category_id\": 2, \"description\": \"Experience studio-grade sound with ultra-comfortable ear cushions and up to 30 hours of battery life.\", \"is_featured\": false, \"digital_file\": null, \"multiply_qty\": false, \"product_type\": \"physical\", \"stock_status\": \"in_stock\", \"current_stock\": 50, \"denied_reason\": null, \"discount_type\": \"percent\", \"shipping_cost\": 0, \"is_todays_deal\": false, \"purchase_price\": 120, \"sub_category_id\": 1, \"meta_description\": null, \"digital_file_type\": null, \"minimum_order_qty\": 1, \"short_description\": \"High-fidelity audio with active noise cancellation.\", \"low_stock_threshold\": 5}', '{\"id\": 7, \"sku\": \"HP-ANC-0013267\", \"tax\": 0, \"name\": \"Wireless Noise-Canceling Headphones\", \"slug\": \"wireless-noise-canceling-headphones-6NhhM\", \"tags\": [], \"unit\": null, \"images\": [\"products/gallery/2026/08/7fd27f8d-772e-4e93-b334-b69b9e7448e6_1787677755.webp\", \"products/gallery/2026/08/72b85c72-715c-4299-bc6c-390b2ae9f2d0_1787677755.webp\", \"products/gallery/2026/08/aec3b831-bf2c-4a33-a05d-eaba69f8cd8c_1787677755.webp\", \"products/gallery/2026/08/00f5319c-eb0c-48d6-b2b7-4cc54917386f_1787677755.webp\", \"products/gallery/2026/08/8537d32a-7769-45b5-8728-9cfd9f531a46_1787677755.webp\"], \"status\": \"approved\", \"brand_id\": 1, \"discount\": 10, \"tax_type\": \"flat\", \"published\": false, \"seller_id\": 2, \"thumbnail\": \"products/thumbnails/2026/08/b68fa7a2-8295-4615-822a-6877b60e07e1_1787677755.webp\", \"created_at\": \"2026-08-25T17:09:16.000000Z\", \"deleted_at\": null, \"meta_image\": \"products/meta/2026/08/81381953-d3de-4251-bd23-408b65ac0e43_1787677755.webp\", \"meta_title\": null, \"unit_price\": 199.99, \"updated_at\": \"2026-08-30T09:29:17.000000Z\", \"category_id\": 2, \"description\": \"Experience studio-grade sound with ultra-comfortable ear cushions and up to 30 hours of battery life.\", \"is_featured\": false, \"digital_file\": null, \"multiply_qty\": false, \"product_type\": \"physical\", \"stock_status\": \"in_stock\", \"current_stock\": 50, \"denied_reason\": null, \"discount_type\": \"percent\", \"shipping_cost\": 0, \"is_todays_deal\": false, \"purchase_price\": 120, \"sub_category_id\": 1, \"meta_description\": null, \"digital_file_type\": null, \"minimum_order_qty\": 1, \"short_description\": \"High-fidelity audio with active noise cancellation.\", \"low_stock_threshold\": 5}', '2026-08-30 08:29:17', '2026-08-30 08:29:17'),
(31, 1, 'admin', 'product.published', 'Published product \'Wireless Noise-Canceling Headphones\' (ID: 7)', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'Desktop', 'Chrome', 'macOS', '{\"published\": true}', '{\"id\": 7, \"sku\": \"HP-ANC-0013267\", \"tax\": 0, \"name\": \"Wireless Noise-Canceling Headphones\", \"slug\": \"wireless-noise-canceling-headphones-6NhhM\", \"tags\": [], \"unit\": null, \"images\": [\"products/gallery/2026/08/7fd27f8d-772e-4e93-b334-b69b9e7448e6_1787677755.webp\", \"products/gallery/2026/08/72b85c72-715c-4299-bc6c-390b2ae9f2d0_1787677755.webp\", \"products/gallery/2026/08/aec3b831-bf2c-4a33-a05d-eaba69f8cd8c_1787677755.webp\", \"products/gallery/2026/08/00f5319c-eb0c-48d6-b2b7-4cc54917386f_1787677755.webp\", \"products/gallery/2026/08/8537d32a-7769-45b5-8728-9cfd9f531a46_1787677755.webp\"], \"status\": \"approved\", \"brand_id\": 1, \"discount\": 10, \"tax_type\": \"flat\", \"published\": false, \"seller_id\": 2, \"thumbnail\": \"products/thumbnails/2026/08/b68fa7a2-8295-4615-822a-6877b60e07e1_1787677755.webp\", \"created_at\": \"2026-08-25T17:09:16.000000Z\", \"deleted_at\": null, \"meta_image\": \"products/meta/2026/08/81381953-d3de-4251-bd23-408b65ac0e43_1787677755.webp\", \"meta_title\": null, \"unit_price\": 199.99, \"updated_at\": \"2026-08-30T09:29:17.000000Z\", \"category_id\": 2, \"description\": \"Experience studio-grade sound with ultra-comfortable ear cushions and up to 30 hours of battery life.\", \"is_featured\": false, \"digital_file\": null, \"multiply_qty\": false, \"product_type\": \"physical\", \"stock_status\": \"in_stock\", \"current_stock\": 50, \"denied_reason\": null, \"discount_type\": \"percent\", \"shipping_cost\": 0, \"is_todays_deal\": false, \"purchase_price\": 120, \"sub_category_id\": 1, \"meta_description\": null, \"digital_file_type\": null, \"minimum_order_qty\": 1, \"short_description\": \"High-fidelity audio with active noise cancellation.\", \"low_stock_threshold\": 5}', '{\"id\": 7, \"sku\": \"HP-ANC-0013267\", \"tax\": 0, \"name\": \"Wireless Noise-Canceling Headphones\", \"slug\": \"wireless-noise-canceling-headphones-6NhhM\", \"tags\": [], \"unit\": null, \"images\": [\"products/gallery/2026/08/7fd27f8d-772e-4e93-b334-b69b9e7448e6_1787677755.webp\", \"products/gallery/2026/08/72b85c72-715c-4299-bc6c-390b2ae9f2d0_1787677755.webp\", \"products/gallery/2026/08/aec3b831-bf2c-4a33-a05d-eaba69f8cd8c_1787677755.webp\", \"products/gallery/2026/08/00f5319c-eb0c-48d6-b2b7-4cc54917386f_1787677755.webp\", \"products/gallery/2026/08/8537d32a-7769-45b5-8728-9cfd9f531a46_1787677755.webp\"], \"status\": \"approved\", \"brand_id\": 1, \"discount\": 10, \"tax_type\": \"flat\", \"published\": true, \"seller_id\": 2, \"thumbnail\": \"products/thumbnails/2026/08/b68fa7a2-8295-4615-822a-6877b60e07e1_1787677755.webp\", \"created_at\": \"2026-08-25T17:09:16.000000Z\", \"deleted_at\": null, \"meta_image\": \"products/meta/2026/08/81381953-d3de-4251-bd23-408b65ac0e43_1787677755.webp\", \"meta_title\": null, \"unit_price\": 199.99, \"updated_at\": \"2026-08-30T09:29:21.000000Z\", \"category_id\": 2, \"description\": \"Experience studio-grade sound with ultra-comfortable ear cushions and up to 30 hours of battery life.\", \"is_featured\": false, \"digital_file\": null, \"multiply_qty\": false, \"product_type\": \"physical\", \"stock_status\": \"in_stock\", \"current_stock\": 50, \"denied_reason\": null, \"discount_type\": \"percent\", \"shipping_cost\": 0, \"is_todays_deal\": false, \"purchase_price\": 120, \"sub_category_id\": 1, \"meta_description\": null, \"digital_file_type\": null, \"minimum_order_qty\": 1, \"short_description\": \"High-fidelity audio with active noise cancellation.\", \"low_stock_threshold\": 5}', '2026-08-30 08:29:21', '2026-08-30 08:29:21'),
(32, 1, 'admin', 'product.create', 'Created product \'Super  TEST\' (ID: 8)', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'Desktop', 'Chrome', 'macOS', '{\"sku\": \"S-3319\", \"tax\": \"10\", \"name\": \"Super  TEST\", \"status\": \"pending\", \"brand_id\": \"2\", \"discount\": \"2\", \"tax_type\": \"flat\", \"published\": \"1\", \"seller_id\": \"2\", \"attributes\": [[\"8\"], [\"4\", \"5\", \"6\", \"3\"]], \"meta_image\": {}, \"meta_title\": \"Hello we are ready now\", \"unit_price\": \"100\", \"category_id\": \"3\", \"description\": \"This is the best of them all This is the best of them all This is the best of them all This is the best of them all This is the best of them all This is the best of them all This is the best of them all\", \"is_featured\": \"1\", \"multiply_qty\": \"0\", \"product_type\": \"physical\", \"stock_status\": \"in_stock\", \"current_stock\": \"10\", \"discount_type\": \"flat\", \"shipping_cost\": \"0\", \"gallery_images\": [{}, {}, {}, {}, {}], \"is_todays_deal\": \"0\", \"purchase_price\": \"1000\", \"sub_category_id\": \"2\", \"meta_description\": \"This is the best of them all\", \"minimum_order_qty\": \"1\", \"short_description\": \"This is the best of them all\", \"low_stock_threshold\": \"5\"}', NULL, '{\"id\": 8, \"sku\": \"S-3319\", \"tax\": 10, \"name\": \"Super  TEST\", \"slug\": \"super-test-H6Krp\", \"tags\": [], \"unit\": null, \"images\": [\"products/gallery/2026/08/c2e97580-0f5a-4182-ac6e-cbfa640c918c_1788085894.webp\", \"products/gallery/2026/08/773c3990-b86c-43c6-a04a-052c95cfe465_1788085894.webp\", \"products/gallery/2026/08/87ffed81-19d0-4842-b8b7-1fa351293004_1788085894.webp\", \"products/gallery/2026/08/8afe6702-7913-402a-84d7-a89b31ba2b25_1788085894.webp\", \"products/gallery/2026/08/4af9e845-9c8e-43ff-96da-4615cbb9e900_1788085894.webp\"], \"status\": \"pending\", \"brand_id\": \"2\", \"discount\": 2, \"tax_type\": \"flat\", \"published\": true, \"seller_id\": \"2\", \"thumbnail\": \"products/thumbnails/2026/08/d069f540-9450-465d-b616-1c173f79410e_1788085894.webp\", \"created_at\": \"2026-08-30T10:31:34.000000Z\", \"meta_image\": \"products/meta/2026/08/fc86ee15-e2f0-40b1-8c76-7c5e8c3b52ea_1788085894.webp\", \"meta_title\": \"Hello we are ready now\", \"unit_price\": 100, \"updated_at\": \"2026-08-30T10:31:34.000000Z\", \"category_id\": \"3\", \"description\": \"This is the best of them all This is the best of them all This is the best of them all This is the best of them all This is the best of them all This is the best of them all This is the best of them all\", \"is_featured\": true, \"digital_file\": null, \"multiply_qty\": false, \"product_type\": \"physical\", \"stock_status\": \"in_stock\", \"current_stock\": \"10\", \"denied_reason\": null, \"discount_type\": \"flat\", \"shipping_cost\": 0, \"is_todays_deal\": false, \"purchase_price\": 1000, \"sub_category_id\": \"2\", \"meta_description\": \"This is the best of them all\", \"digital_file_type\": null, \"minimum_order_qty\": \"1\", \"short_description\": \"This is the best of them all\", \"low_stock_threshold\": \"5\"}', '2026-08-30 09:31:34', '2026-08-30 09:31:34'),
(33, 1, 'admin', 'product.create', 'Created product \'Super  TEST\' (ID: 9)', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'Desktop', 'Chrome', 'macOS', '{\"sku\": \"SUPERTES-5500\", \"tax\": \"1\", \"name\": \"Super  TEST\", \"tags\": [\"hello\", \"melody\", \"uncle\"], \"unit\": \"KG\", \"status\": \"approved\", \"brand_id\": \"2\", \"tax_type\": \"flat\", \"published\": \"0\", \"seller_id\": \"2\", \"attributes\": [[\"3\"]], \"meta_image\": {}, \"meta_title\": \"Hello we are ready now\", \"unit_price\": \"200\", \"category_id\": \"3\", \"description\": \"Hello We are Here Now Hello We are Here Now Hello We are Here Now Hello We are Here Now Hello We are Here Now\", \"is_featured\": \"1\", \"multiply_qty\": \"1\", \"product_type\": \"physical\", \"stock_status\": \"in_stock\", \"current_stock\": \"10\", \"discount_type\": \"flat\", \"shipping_cost\": \"0\", \"gallery_images\": [{}, {}, {}, {}, {}], \"is_todays_deal\": \"1\", \"purchase_price\": \"500\", \"meta_description\": \"Hello We are Here NowHello We are Here NowHello We are Here NowHello We are Here Now\", \"minimum_order_qty\": \"1\", \"short_description\": \"Hello We are Here Now\", \"low_stock_threshold\": \"5\"}', NULL, '{\"id\": 9, \"sku\": \"SUPERTES-5500\", \"tax\": 1, \"name\": \"Super  TEST\", \"slug\": \"super-test-lx3Dx\", \"tags\": [\"hello\", \"melody\", \"uncle\"], \"unit\": \"KG\", \"images\": [\"products/gallery/2026/08/34ad7cd4-1115-4cd9-bc7d-fbd6e6e32fc7_1788086395.webp\", \"products/gallery/2026/08/55adc9ba-f85a-44f8-964a-2513c606f82d_1788086395.webp\", \"products/gallery/2026/08/e05c56e8-2bd5-4143-bec9-0bb56ce58f7b_1788086395.webp\", \"products/gallery/2026/08/287c524c-8595-4b6c-8708-dee41edd0a23_1788086395.webp\", \"products/gallery/2026/08/0256cfbc-2407-4ddc-8d5b-7a3979fafe53_1788086395.webp\"], \"status\": \"approved\", \"brand_id\": \"2\", \"discount\": 0, \"tax_type\": \"flat\", \"published\": false, \"seller_id\": \"2\", \"thumbnail\": \"products/thumbnails/2026/08/898a351c-ddfc-4690-acb8-52f54aaf4042_1788086395.webp\", \"created_at\": \"2026-08-30T10:39:55.000000Z\", \"meta_image\": \"products/meta/2026/08/c03ae5cd-da5c-4815-a84b-5b0bbfa6a063_1788086395.webp\", \"meta_title\": \"Hello we are ready now\", \"unit_price\": 200, \"updated_at\": \"2026-08-30T10:39:55.000000Z\", \"category_id\": \"3\", \"description\": \"Hello We are Here Now Hello We are Here Now Hello We are Here Now Hello We are Here Now Hello We are Here Now\", \"is_featured\": true, \"digital_file\": null, \"multiply_qty\": true, \"product_type\": \"physical\", \"stock_status\": \"in_stock\", \"current_stock\": \"10\", \"denied_reason\": null, \"discount_type\": \"flat\", \"shipping_cost\": 0, \"is_todays_deal\": true, \"purchase_price\": 500, \"sub_category_id\": null, \"meta_description\": \"Hello We are Here NowHello We are Here NowHello We are Here NowHello We are Here Now\", \"digital_file_type\": null, \"minimum_order_qty\": \"1\", \"short_description\": \"Hello We are Here Now\", \"low_stock_threshold\": \"5\"}', '2026-08-30 09:39:55', '2026-08-30 09:39:55'),
(34, 1, 'admin', 'product.unpublished', 'Unpublished product \'Super  TEST\' (ID: 8)', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'Desktop', 'Chrome', 'macOS', '{\"published\": false}', '{\"id\": 8, \"sku\": \"S-3319\", \"tax\": 10, \"name\": \"Super  TEST\", \"slug\": \"super-test-H6Krp\", \"tags\": [], \"unit\": null, \"images\": [\"products/gallery/2026/08/c2e97580-0f5a-4182-ac6e-cbfa640c918c_1788085894.webp\", \"products/gallery/2026/08/773c3990-b86c-43c6-a04a-052c95cfe465_1788085894.webp\", \"products/gallery/2026/08/87ffed81-19d0-4842-b8b7-1fa351293004_1788085894.webp\", \"products/gallery/2026/08/8afe6702-7913-402a-84d7-a89b31ba2b25_1788085894.webp\", \"products/gallery/2026/08/4af9e845-9c8e-43ff-96da-4615cbb9e900_1788085894.webp\"], \"status\": \"pending\", \"brand_id\": 2, \"discount\": 2, \"tax_type\": \"flat\", \"published\": true, \"seller_id\": 2, \"thumbnail\": \"products/thumbnails/2026/08/d069f540-9450-465d-b616-1c173f79410e_1788085894.webp\", \"created_at\": \"2026-08-30T10:31:34.000000Z\", \"deleted_at\": null, \"meta_image\": \"products/meta/2026/08/fc86ee15-e2f0-40b1-8c76-7c5e8c3b52ea_1788085894.webp\", \"meta_title\": \"Hello we are ready now\", \"unit_price\": 100, \"updated_at\": \"2026-08-30T10:31:34.000000Z\", \"category_id\": 3, \"description\": \"This is the best of them all This is the best of them all This is the best of them all This is the best of them all This is the best of them all This is the best of them all This is the best of them all\", \"is_featured\": true, \"digital_file\": null, \"multiply_qty\": false, \"product_type\": \"physical\", \"stock_status\": \"in_stock\", \"current_stock\": 10, \"denied_reason\": null, \"discount_type\": \"flat\", \"shipping_cost\": 0, \"is_todays_deal\": false, \"purchase_price\": 1000, \"sub_category_id\": 2, \"meta_description\": \"This is the best of them all\", \"digital_file_type\": null, \"minimum_order_qty\": 1, \"short_description\": \"This is the best of them all\", \"low_stock_threshold\": 5}', '{\"id\": 8, \"sku\": \"S-3319\", \"tax\": 10, \"name\": \"Super  TEST\", \"slug\": \"super-test-H6Krp\", \"tags\": [], \"unit\": null, \"images\": [\"products/gallery/2026/08/c2e97580-0f5a-4182-ac6e-cbfa640c918c_1788085894.webp\", \"products/gallery/2026/08/773c3990-b86c-43c6-a04a-052c95cfe465_1788085894.webp\", \"products/gallery/2026/08/87ffed81-19d0-4842-b8b7-1fa351293004_1788085894.webp\", \"products/gallery/2026/08/8afe6702-7913-402a-84d7-a89b31ba2b25_1788085894.webp\", \"products/gallery/2026/08/4af9e845-9c8e-43ff-96da-4615cbb9e900_1788085894.webp\"], \"status\": \"pending\", \"brand_id\": 2, \"discount\": 2, \"tax_type\": \"flat\", \"published\": false, \"seller_id\": 2, \"thumbnail\": \"products/thumbnails/2026/08/d069f540-9450-465d-b616-1c173f79410e_1788085894.webp\", \"created_at\": \"2026-08-30T10:31:34.000000Z\", \"deleted_at\": null, \"meta_image\": \"products/meta/2026/08/fc86ee15-e2f0-40b1-8c76-7c5e8c3b52ea_1788085894.webp\", \"meta_title\": \"Hello we are ready now\", \"unit_price\": 100, \"updated_at\": \"2026-08-30T10:43:47.000000Z\", \"category_id\": 3, \"description\": \"This is the best of them all This is the best of them all This is the best of them all This is the best of them all This is the best of them all This is the best of them all This is the best of them all\", \"is_featured\": true, \"digital_file\": null, \"multiply_qty\": false, \"product_type\": \"physical\", \"stock_status\": \"in_stock\", \"current_stock\": 10, \"denied_reason\": null, \"discount_type\": \"flat\", \"shipping_cost\": 0, \"is_todays_deal\": false, \"purchase_price\": 1000, \"sub_category_id\": 2, \"meta_description\": \"This is the best of them all\", \"digital_file_type\": null, \"minimum_order_qty\": 1, \"short_description\": \"This is the best of them all\", \"low_stock_threshold\": 5}', '2026-08-30 09:43:47', '2026-08-30 09:43:47'),
(35, 1, 'admin', 'product.update', 'Updated product \'Super  TEST\' (ID: 9)', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'Desktop', 'Chrome', 'macOS', '{\"sku\": \"SUPERTES-5500\", \"tax\": \"1\", \"name\": \"Super  TEST\", \"tags\": [\"hello\", \"melody\", \"uncle\"], \"unit\": \"KG\", \"status\": \"approved\", \"_method\": \"POST\", \"brand_id\": \"2\", \"discount\": \"0\", \"tax_type\": \"flat\", \"published\": \"0\", \"seller_id\": \"2\", \"attributes\": [[\"3\"]], \"meta_title\": \"Hello we are ready now\", \"unit_price\": \"200\", \"category_id\": \"3\", \"description\": \"Hello We are Here Now Hello We are Here Now Hello We are Here Now Hello We are Here Now Hello We are Here Now\", \"is_featured\": \"1\", \"multiply_qty\": \"1\", \"product_type\": \"physical\", \"stock_status\": \"in_stock\", \"current_stock\": \"10\", \"discount_type\": \"flat\", \"shipping_cost\": \"0\", \"is_todays_deal\": \"1\", \"purchase_price\": \"500\", \"meta_description\": \"Hello We are Here NowHello We are Here NowHello We are Here NowHello We are Here Now\", \"minimum_order_qty\": \"1\", \"short_description\": \"Hello We are Here Now\", \"low_stock_threshold\": \"5\", \"existing_gallery_images\": [\"products/gallery/2026/08/34ad7cd4-1115-4cd9-bc7d-fbd6e6e32fc7_1788086395.webp\", \"products/gallery/2026/08/55adc9ba-f85a-44f8-964a-2513c606f82d_1788086395.webp\", \"products/gallery/2026/08/e05c56e8-2bd5-4143-bec9-0bb56ce58f7b_1788086395.webp\", \"products/gallery/2026/08/287c524c-8595-4b6c-8708-dee41edd0a23_1788086395.webp\", \"products/gallery/2026/08/0256cfbc-2407-4ddc-8d5b-7a3979fafe53_1788086395.webp\"]}', '{\"id\": 9, \"sku\": \"SUPERTES-5500\", \"tax\": 1, \"name\": \"Super  TEST\", \"slug\": \"super-test-lx3Dx\", \"tags\": [\"hello\", \"melody\", \"uncle\"], \"unit\": \"KG\", \"images\": [\"products/gallery/2026/08/34ad7cd4-1115-4cd9-bc7d-fbd6e6e32fc7_1788086395.webp\", \"products/gallery/2026/08/55adc9ba-f85a-44f8-964a-2513c606f82d_1788086395.webp\", \"products/gallery/2026/08/e05c56e8-2bd5-4143-bec9-0bb56ce58f7b_1788086395.webp\", \"products/gallery/2026/08/287c524c-8595-4b6c-8708-dee41edd0a23_1788086395.webp\", \"products/gallery/2026/08/0256cfbc-2407-4ddc-8d5b-7a3979fafe53_1788086395.webp\"], \"status\": \"approved\", \"brand_id\": 2, \"discount\": 0, \"tax_type\": \"flat\", \"published\": false, \"seller_id\": 2, \"thumbnail\": \"products/thumbnails/2026/08/898a351c-ddfc-4690-acb8-52f54aaf4042_1788086395.webp\", \"created_at\": \"2026-08-30T10:39:55.000000Z\", \"deleted_at\": null, \"meta_image\": \"products/meta/2026/08/c03ae5cd-da5c-4815-a84b-5b0bbfa6a063_1788086395.webp\", \"meta_title\": \"Hello we are ready now\", \"unit_price\": 200, \"updated_at\": \"2026-08-30T10:39:55.000000Z\", \"variations\": [], \"category_id\": 3, \"description\": \"Hello We are Here Now Hello We are Here Now Hello We are Here Now Hello We are Here Now Hello We are Here Now\", \"is_featured\": true, \"digital_file\": null, \"multiply_qty\": true, \"product_type\": \"physical\", \"stock_status\": \"in_stock\", \"current_stock\": 10, \"denied_reason\": null, \"discount_type\": \"flat\", \"shipping_cost\": 0, \"is_todays_deal\": true, \"purchase_price\": 500, \"sub_category_id\": null, \"meta_description\": \"Hello We are Here NowHello We are Here NowHello We are Here NowHello We are Here Now\", \"digital_file_type\": null, \"minimum_order_qty\": 1, \"short_description\": \"Hello We are Here Now\", \"low_stock_threshold\": 5}', '{\"id\": 9, \"sku\": \"SUPERTES-5500\", \"tax\": 1, \"name\": \"Super  TEST\", \"slug\": \"super-test-lx3Dx\", \"tags\": [\"hello\", \"melody\", \"uncle\"], \"unit\": \"KG\", \"images\": [\"products/gallery/2026/08/34ad7cd4-1115-4cd9-bc7d-fbd6e6e32fc7_1788086395.webp\", \"products/gallery/2026/08/55adc9ba-f85a-44f8-964a-2513c606f82d_1788086395.webp\", \"products/gallery/2026/08/e05c56e8-2bd5-4143-bec9-0bb56ce58f7b_1788086395.webp\", \"products/gallery/2026/08/287c524c-8595-4b6c-8708-dee41edd0a23_1788086395.webp\", \"products/gallery/2026/08/0256cfbc-2407-4ddc-8d5b-7a3979fafe53_1788086395.webp\"], \"status\": \"approved\", \"brand_id\": 2, \"discount\": 0, \"tax_type\": \"flat\", \"published\": false, \"seller_id\": 2, \"thumbnail\": \"products/thumbnails/2026/08/898a351c-ddfc-4690-acb8-52f54aaf4042_1788086395.webp\", \"created_at\": \"2026-08-30T10:39:55.000000Z\", \"deleted_at\": null, \"meta_image\": \"products/meta/2026/08/c03ae5cd-da5c-4815-a84b-5b0bbfa6a063_1788086395.webp\", \"meta_title\": \"Hello we are ready now\", \"unit_price\": 200, \"updated_at\": \"2026-08-30T10:39:55.000000Z\", \"variations\": [], \"category_id\": 3, \"description\": \"Hello We are Here Now Hello We are Here Now Hello We are Here Now Hello We are Here Now Hello We are Here Now\", \"is_featured\": true, \"digital_file\": null, \"multiply_qty\": true, \"product_type\": \"physical\", \"stock_status\": \"in_stock\", \"current_stock\": 10, \"denied_reason\": null, \"discount_type\": \"flat\", \"shipping_cost\": 0, \"is_todays_deal\": true, \"purchase_price\": 500, \"sub_category_id\": null, \"meta_description\": \"Hello We are Here NowHello We are Here NowHello We are Here NowHello We are Here Now\", \"digital_file_type\": null, \"minimum_order_qty\": 1, \"short_description\": \"Hello We are Here Now\", \"low_stock_threshold\": 5}', '2026-08-30 10:04:46', '2026-08-30 10:04:46'),
(36, 1, 'admin', 'product.update', 'Updated product \'Super  TEST\' (ID: 9)', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'Desktop', 'Chrome', 'macOS', '{\"sku\": \"SUPERTES-5500\", \"tax\": \"1\", \"name\": \"Super  TEST\", \"tags\": [\"hello\", \"melody\", \"uncle\"], \"unit\": \"KG\", \"status\": \"approved\", \"_method\": \"POST\", \"brand_id\": \"2\", \"discount\": \"0\", \"tax_type\": \"flat\", \"published\": \"0\", \"seller_id\": \"2\", \"meta_title\": \"Hello we are ready now\", \"unit_price\": \"200\", \"category_id\": \"3\", \"description\": \"Hello We are Here Now Hello We are Here Now Hello We are Here Now Hello We are Here Now Hello We are Here Now\", \"is_featured\": \"1\", \"multiply_qty\": \"1\", \"product_type\": \"physical\", \"stock_status\": \"in_stock\", \"current_stock\": \"10\", \"discount_type\": \"flat\", \"shipping_cost\": \"0\", \"is_todays_deal\": \"1\", \"purchase_price\": \"500\", \"meta_description\": \"Hello We are Here NowHello We are Here NowHello We are Here NowHello We are Here Now\", \"minimum_order_qty\": \"1\", \"short_description\": \"Hello We are Here Now\", \"low_stock_threshold\": \"5\", \"existing_gallery_images\": [\"products/gallery/2026/08/34ad7cd4-1115-4cd9-bc7d-fbd6e6e32fc7_1788086395.webp\", \"products/gallery/2026/08/55adc9ba-f85a-44f8-964a-2513c606f82d_1788086395.webp\", \"products/gallery/2026/08/e05c56e8-2bd5-4143-bec9-0bb56ce58f7b_1788086395.webp\", \"products/gallery/2026/08/287c524c-8595-4b6c-8708-dee41edd0a23_1788086395.webp\", \"products/gallery/2026/08/0256cfbc-2407-4ddc-8d5b-7a3979fafe53_1788086395.webp\"]}', '{\"id\": 9, \"sku\": \"SUPERTES-5500\", \"tax\": 1, \"name\": \"Super  TEST\", \"slug\": \"super-test-lx3Dx\", \"tags\": [\"hello\", \"melody\", \"uncle\"], \"unit\": \"KG\", \"images\": [\"products/gallery/2026/08/34ad7cd4-1115-4cd9-bc7d-fbd6e6e32fc7_1788086395.webp\", \"products/gallery/2026/08/55adc9ba-f85a-44f8-964a-2513c606f82d_1788086395.webp\", \"products/gallery/2026/08/e05c56e8-2bd5-4143-bec9-0bb56ce58f7b_1788086395.webp\", \"products/gallery/2026/08/287c524c-8595-4b6c-8708-dee41edd0a23_1788086395.webp\", \"products/gallery/2026/08/0256cfbc-2407-4ddc-8d5b-7a3979fafe53_1788086395.webp\"], \"status\": \"approved\", \"brand_id\": 2, \"discount\": 0, \"tax_type\": \"flat\", \"published\": false, \"seller_id\": 2, \"thumbnail\": \"products/thumbnails/2026/08/898a351c-ddfc-4690-acb8-52f54aaf4042_1788086395.webp\", \"created_at\": \"2026-08-30T10:39:55.000000Z\", \"deleted_at\": null, \"meta_image\": \"products/meta/2026/08/c03ae5cd-da5c-4815-a84b-5b0bbfa6a063_1788086395.webp\", \"meta_title\": \"Hello we are ready now\", \"unit_price\": 200, \"updated_at\": \"2026-08-30T10:39:55.000000Z\", \"variations\": [], \"category_id\": 3, \"description\": \"Hello We are Here Now Hello We are Here Now Hello We are Here Now Hello We are Here Now Hello We are Here Now\", \"is_featured\": true, \"digital_file\": null, \"multiply_qty\": true, \"product_type\": \"physical\", \"stock_status\": \"in_stock\", \"current_stock\": 10, \"denied_reason\": null, \"discount_type\": \"flat\", \"shipping_cost\": 0, \"is_todays_deal\": true, \"purchase_price\": 500, \"sub_category_id\": null, \"meta_description\": \"Hello We are Here NowHello We are Here NowHello We are Here NowHello We are Here Now\", \"digital_file_type\": null, \"minimum_order_qty\": 1, \"short_description\": \"Hello We are Here Now\", \"low_stock_threshold\": 5}', '{\"id\": 9, \"sku\": \"SUPERTES-5500\", \"tax\": 1, \"name\": \"Super  TEST\", \"slug\": \"super-test-lx3Dx\", \"tags\": [\"hello\", \"melody\", \"uncle\"], \"unit\": \"KG\", \"images\": [\"products/gallery/2026/08/34ad7cd4-1115-4cd9-bc7d-fbd6e6e32fc7_1788086395.webp\", \"products/gallery/2026/08/55adc9ba-f85a-44f8-964a-2513c606f82d_1788086395.webp\", \"products/gallery/2026/08/e05c56e8-2bd5-4143-bec9-0bb56ce58f7b_1788086395.webp\", \"products/gallery/2026/08/287c524c-8595-4b6c-8708-dee41edd0a23_1788086395.webp\", \"products/gallery/2026/08/0256cfbc-2407-4ddc-8d5b-7a3979fafe53_1788086395.webp\"], \"status\": \"approved\", \"brand_id\": 2, \"discount\": 0, \"tax_type\": \"flat\", \"published\": false, \"seller_id\": 2, \"thumbnail\": \"products/thumbnails/2026/08/2e22e22f-9a35-4ddd-bf26-fa84ae3f479b_1788087899.webp\", \"created_at\": \"2026-08-30T10:39:55.000000Z\", \"deleted_at\": null, \"meta_image\": \"products/meta/2026/08/c03ae5cd-da5c-4815-a84b-5b0bbfa6a063_1788086395.webp\", \"meta_title\": \"Hello we are ready now\", \"unit_price\": 200, \"updated_at\": \"2026-08-30T11:04:59.000000Z\", \"variations\": [], \"category_id\": 3, \"description\": \"Hello We are Here Now Hello We are Here Now Hello We are Here Now Hello We are Here Now Hello We are Here Now\", \"is_featured\": true, \"digital_file\": null, \"multiply_qty\": true, \"product_type\": \"physical\", \"stock_status\": \"in_stock\", \"current_stock\": 10, \"denied_reason\": null, \"discount_type\": \"flat\", \"shipping_cost\": 0, \"is_todays_deal\": true, \"purchase_price\": 500, \"sub_category_id\": null, \"meta_description\": \"Hello We are Here NowHello We are Here NowHello We are Here NowHello We are Here Now\", \"digital_file_type\": null, \"minimum_order_qty\": 1, \"short_description\": \"Hello We are Here Now\", \"low_stock_threshold\": 5}', '2026-08-30 10:04:59', '2026-08-30 10:04:59'),
(37, 1, 'admin', 'product.update', 'Updated product \'Super  TEST\' (ID: 9)', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'Desktop', 'Chrome', 'macOS', '{\"sku\": \"SUPERTES-5500\", \"tax\": \"1\", \"name\": \"Super  TEST\", \"tags\": [\"hello\", \"melody\", \"uncle\"], \"unit\": \"KG\", \"status\": \"approved\", \"_method\": \"POST\", \"brand_id\": \"2\", \"discount\": \"0\", \"tax_type\": \"flat\", \"published\": \"0\", \"seller_id\": \"2\", \"meta_title\": \"Hello we are ready now\", \"unit_price\": \"200\", \"category_id\": \"3\", \"description\": \"Hello We are Here Now Hello We are Here Now Hello We are Here Now Hello We are Here Now Hello We are Here Now\", \"is_featured\": \"1\", \"multiply_qty\": \"1\", \"product_type\": \"physical\", \"stock_status\": \"in_stock\", \"current_stock\": \"10\", \"discount_type\": \"flat\", \"shipping_cost\": \"0\", \"is_todays_deal\": \"1\", \"purchase_price\": \"500\", \"meta_description\": \"Hello We are Here NowHello We are Here NowHello We are Here NowHello We are Here Now\", \"minimum_order_qty\": \"1\", \"short_description\": \"Hello We are Here Now\", \"low_stock_threshold\": \"5\", \"existing_gallery_images\": [\"products/gallery/2026/08/55adc9ba-f85a-44f8-964a-2513c606f82d_1788086395.webp\", \"products/gallery/2026/08/e05c56e8-2bd5-4143-bec9-0bb56ce58f7b_1788086395.webp\", \"products/gallery/2026/08/287c524c-8595-4b6c-8708-dee41edd0a23_1788086395.webp\", \"products/gallery/2026/08/0256cfbc-2407-4ddc-8d5b-7a3979fafe53_1788086395.webp\"]}', '{\"id\": 9, \"sku\": \"SUPERTES-5500\", \"tax\": 1, \"name\": \"Super  TEST\", \"slug\": \"super-test-lx3Dx\", \"tags\": [\"hello\", \"melody\", \"uncle\"], \"unit\": \"KG\", \"images\": [\"products/gallery/2026/08/34ad7cd4-1115-4cd9-bc7d-fbd6e6e32fc7_1788086395.webp\", \"products/gallery/2026/08/55adc9ba-f85a-44f8-964a-2513c606f82d_1788086395.webp\", \"products/gallery/2026/08/e05c56e8-2bd5-4143-bec9-0bb56ce58f7b_1788086395.webp\", \"products/gallery/2026/08/287c524c-8595-4b6c-8708-dee41edd0a23_1788086395.webp\", \"products/gallery/2026/08/0256cfbc-2407-4ddc-8d5b-7a3979fafe53_1788086395.webp\"], \"status\": \"approved\", \"brand_id\": 2, \"discount\": 0, \"tax_type\": \"flat\", \"published\": false, \"seller_id\": 2, \"thumbnail\": \"products/thumbnails/2026/08/2e22e22f-9a35-4ddd-bf26-fa84ae3f479b_1788087899.webp\", \"created_at\": \"2026-08-30T10:39:55.000000Z\", \"deleted_at\": null, \"meta_image\": \"products/meta/2026/08/c03ae5cd-da5c-4815-a84b-5b0bbfa6a063_1788086395.webp\", \"meta_title\": \"Hello we are ready now\", \"unit_price\": 200, \"updated_at\": \"2026-08-30T11:04:59.000000Z\", \"variations\": [], \"category_id\": 3, \"description\": \"Hello We are Here Now Hello We are Here Now Hello We are Here Now Hello We are Here Now Hello We are Here Now\", \"is_featured\": true, \"digital_file\": null, \"multiply_qty\": true, \"product_type\": \"physical\", \"stock_status\": \"in_stock\", \"current_stock\": 10, \"denied_reason\": null, \"discount_type\": \"flat\", \"shipping_cost\": 0, \"is_todays_deal\": true, \"purchase_price\": 500, \"sub_category_id\": null, \"meta_description\": \"Hello We are Here NowHello We are Here NowHello We are Here NowHello We are Here Now\", \"digital_file_type\": null, \"minimum_order_qty\": 1, \"short_description\": \"Hello We are Here Now\", \"low_stock_threshold\": 5}', '{\"id\": 9, \"sku\": \"SUPERTES-5500\", \"tax\": 1, \"name\": \"Super  TEST\", \"slug\": \"super-test-lx3Dx\", \"tags\": [\"hello\", \"melody\", \"uncle\"], \"unit\": \"KG\", \"images\": [\"products/gallery/2026/08/34ad7cd4-1115-4cd9-bc7d-fbd6e6e32fc7_1788086395.webp\", \"products/gallery/2026/08/55adc9ba-f85a-44f8-964a-2513c606f82d_1788086395.webp\", \"products/gallery/2026/08/e05c56e8-2bd5-4143-bec9-0bb56ce58f7b_1788086395.webp\", \"products/gallery/2026/08/287c524c-8595-4b6c-8708-dee41edd0a23_1788086395.webp\", \"products/gallery/2026/08/0256cfbc-2407-4ddc-8d5b-7a3979fafe53_1788086395.webp\"], \"status\": \"approved\", \"brand_id\": 2, \"discount\": 0, \"tax_type\": \"flat\", \"published\": false, \"seller_id\": 2, \"thumbnail\": \"products/thumbnails/2026/08/2e22e22f-9a35-4ddd-bf26-fa84ae3f479b_1788087899.webp\", \"created_at\": \"2026-08-30T10:39:55.000000Z\", \"deleted_at\": null, \"meta_image\": \"products/meta/2026/08/c03ae5cd-da5c-4815-a84b-5b0bbfa6a063_1788086395.webp\", \"meta_title\": \"Hello we are ready now\", \"unit_price\": 200, \"updated_at\": \"2026-08-30T11:04:59.000000Z\", \"variations\": [], \"category_id\": 3, \"description\": \"Hello We are Here Now Hello We are Here Now Hello We are Here Now Hello We are Here Now Hello We are Here Now\", \"is_featured\": true, \"digital_file\": null, \"multiply_qty\": true, \"product_type\": \"physical\", \"stock_status\": \"in_stock\", \"current_stock\": 10, \"denied_reason\": null, \"discount_type\": \"flat\", \"shipping_cost\": 0, \"is_todays_deal\": true, \"purchase_price\": 500, \"sub_category_id\": null, \"meta_description\": \"Hello We are Here NowHello We are Here NowHello We are Here NowHello We are Here Now\", \"digital_file_type\": null, \"minimum_order_qty\": 1, \"short_description\": \"Hello We are Here Now\", \"low_stock_threshold\": 5}', '2026-08-30 10:05:10', '2026-08-30 10:05:10'),
(38, 1, 'admin', 'product.update', 'Updated product \'Super  TEST\' (ID: 9)', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'Desktop', 'Chrome', 'macOS', '{\"sku\": \"SUPERTES-5500\", \"tax\": \"1\", \"name\": \"Super  TEST\", \"tags\": [\"hello\", \"melody\", \"uncle\"], \"unit\": \"KG\", \"status\": \"approved\", \"_method\": \"POST\", \"brand_id\": \"2\", \"discount\": \"0\", \"tax_type\": \"flat\", \"published\": \"0\", \"seller_id\": \"2\", \"meta_image\": {}, \"meta_title\": \"Hello we are ready now\", \"unit_price\": \"200\", \"category_id\": \"3\", \"description\": \"Hello We are Here Now Hello We are Here Now Hello We are Here Now Hello We are Here Now Hello We are Here Now\", \"is_featured\": \"1\", \"multiply_qty\": \"1\", \"product_type\": \"physical\", \"stock_status\": \"in_stock\", \"current_stock\": \"10\", \"discount_type\": \"flat\", \"shipping_cost\": \"0\", \"is_todays_deal\": \"1\", \"purchase_price\": \"500\", \"meta_description\": \"Hello We are Here NowHello We are Here NowHello We are Here NowHello We are Here Now\", \"minimum_order_qty\": \"1\", \"short_description\": \"Hello We are Here Now\", \"low_stock_threshold\": \"5\", \"existing_gallery_images\": [\"products/gallery/2026/08/34ad7cd4-1115-4cd9-bc7d-fbd6e6e32fc7_1788086395.webp\", \"products/gallery/2026/08/55adc9ba-f85a-44f8-964a-2513c606f82d_1788086395.webp\", \"products/gallery/2026/08/e05c56e8-2bd5-4143-bec9-0bb56ce58f7b_1788086395.webp\", \"products/gallery/2026/08/287c524c-8595-4b6c-8708-dee41edd0a23_1788086395.webp\", \"products/gallery/2026/08/0256cfbc-2407-4ddc-8d5b-7a3979fafe53_1788086395.webp\"]}', '{\"id\": 9, \"sku\": \"SUPERTES-5500\", \"tax\": 1, \"name\": \"Super  TEST\", \"slug\": \"super-test-lx3Dx\", \"tags\": [\"hello\", \"melody\", \"uncle\"], \"unit\": \"KG\", \"images\": [\"products/gallery/2026/08/34ad7cd4-1115-4cd9-bc7d-fbd6e6e32fc7_1788086395.webp\", \"products/gallery/2026/08/55adc9ba-f85a-44f8-964a-2513c606f82d_1788086395.webp\", \"products/gallery/2026/08/e05c56e8-2bd5-4143-bec9-0bb56ce58f7b_1788086395.webp\", \"products/gallery/2026/08/287c524c-8595-4b6c-8708-dee41edd0a23_1788086395.webp\", \"products/gallery/2026/08/0256cfbc-2407-4ddc-8d5b-7a3979fafe53_1788086395.webp\"], \"status\": \"approved\", \"brand_id\": 2, \"discount\": 0, \"tax_type\": \"flat\", \"published\": false, \"seller_id\": 2, \"thumbnail\": \"products/thumbnails/2026/08/2e22e22f-9a35-4ddd-bf26-fa84ae3f479b_1788087899.webp\", \"created_at\": \"2026-08-30T10:39:55.000000Z\", \"deleted_at\": null, \"meta_image\": \"products/meta/2026/08/c03ae5cd-da5c-4815-a84b-5b0bbfa6a063_1788086395.webp\", \"meta_title\": \"Hello we are ready now\", \"unit_price\": 200, \"updated_at\": \"2026-08-30T11:04:59.000000Z\", \"variations\": [], \"category_id\": 3, \"description\": \"Hello We are Here Now Hello We are Here Now Hello We are Here Now Hello We are Here Now Hello We are Here Now\", \"is_featured\": true, \"digital_file\": null, \"multiply_qty\": true, \"product_type\": \"physical\", \"stock_status\": \"in_stock\", \"current_stock\": 10, \"denied_reason\": null, \"discount_type\": \"flat\", \"shipping_cost\": 0, \"is_todays_deal\": true, \"purchase_price\": 500, \"sub_category_id\": null, \"meta_description\": \"Hello We are Here NowHello We are Here NowHello We are Here NowHello We are Here Now\", \"digital_file_type\": null, \"minimum_order_qty\": 1, \"short_description\": \"Hello We are Here Now\", \"low_stock_threshold\": 5}', '{\"id\": 9, \"sku\": \"SUPERTES-5500\", \"tax\": 1, \"name\": \"Super  TEST\", \"slug\": \"super-test-lx3Dx\", \"tags\": [\"hello\", \"melody\", \"uncle\"], \"unit\": \"KG\", \"images\": [\"products/gallery/2026/08/34ad7cd4-1115-4cd9-bc7d-fbd6e6e32fc7_1788086395.webp\", \"products/gallery/2026/08/55adc9ba-f85a-44f8-964a-2513c606f82d_1788086395.webp\", \"products/gallery/2026/08/e05c56e8-2bd5-4143-bec9-0bb56ce58f7b_1788086395.webp\", \"products/gallery/2026/08/287c524c-8595-4b6c-8708-dee41edd0a23_1788086395.webp\", \"products/gallery/2026/08/0256cfbc-2407-4ddc-8d5b-7a3979fafe53_1788086395.webp\"], \"status\": \"approved\", \"brand_id\": 2, \"discount\": 0, \"tax_type\": \"flat\", \"published\": false, \"seller_id\": 2, \"thumbnail\": \"products/thumbnails/2026/08/2e22e22f-9a35-4ddd-bf26-fa84ae3f479b_1788087899.webp\", \"created_at\": \"2026-08-30T10:39:55.000000Z\", \"deleted_at\": null, \"meta_image\": \"products/meta/2026/08/a5bf164d-1dec-483d-8230-431b2de7a60b_1788087934.webp\", \"meta_title\": \"Hello we are ready now\", \"unit_price\": 200, \"updated_at\": \"2026-08-30T11:05:34.000000Z\", \"variations\": [], \"category_id\": 3, \"description\": \"Hello We are Here Now Hello We are Here Now Hello We are Here Now Hello We are Here Now Hello We are Here Now\", \"is_featured\": true, \"digital_file\": null, \"multiply_qty\": true, \"product_type\": \"physical\", \"stock_status\": \"in_stock\", \"current_stock\": 10, \"denied_reason\": null, \"discount_type\": \"flat\", \"shipping_cost\": 0, \"is_todays_deal\": true, \"purchase_price\": 500, \"sub_category_id\": null, \"meta_description\": \"Hello We are Here NowHello We are Here NowHello We are Here NowHello We are Here Now\", \"digital_file_type\": null, \"minimum_order_qty\": 1, \"short_description\": \"Hello We are Here Now\", \"low_stock_threshold\": 5}', '2026-08-30 10:05:34', '2026-08-30 10:05:34'),
(39, 1, 'admin', 'product.update', 'Updated product \'Super  TEST\' (ID: 8)', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'Desktop', 'Chrome', 'macOS', '{\"sku\": \"S-3319\", \"tax\": \"10\", \"name\": \"Super  TEST\", \"status\": \"approved\", \"_method\": \"POST\", \"brand_id\": \"2\", \"discount\": \"2\", \"tax_type\": \"flat\", \"published\": \"0\", \"seller_id\": \"2\", \"meta_title\": \"Hello we are ready now\", \"unit_price\": \"100\", \"category_id\": \"3\", \"description\": \"This is the best of them all This is the best of them all This is the best of them all This is the best of them all This is the best of them all This is the best of them all This is the best of them all\", \"is_featured\": \"1\", \"multiply_qty\": \"0\", \"product_type\": \"physical\", \"stock_status\": \"in_stock\", \"current_stock\": \"10\", \"discount_type\": \"flat\", \"shipping_cost\": \"0\", \"is_todays_deal\": \"0\", \"purchase_price\": \"1000\", \"sub_category_id\": \"2\", \"meta_description\": \"This is the best of them all\", \"minimum_order_qty\": \"1\", \"short_description\": \"This is the best of them all\", \"low_stock_threshold\": \"5\", \"existing_gallery_images\": [\"products/gallery/2026/08/c2e97580-0f5a-4182-ac6e-cbfa640c918c_1788085894.webp\", \"products/gallery/2026/08/773c3990-b86c-43c6-a04a-052c95cfe465_1788085894.webp\", \"products/gallery/2026/08/87ffed81-19d0-4842-b8b7-1fa351293004_1788085894.webp\", \"products/gallery/2026/08/8afe6702-7913-402a-84d7-a89b31ba2b25_1788085894.webp\", \"products/gallery/2026/08/4af9e845-9c8e-43ff-96da-4615cbb9e900_1788085894.webp\"]}', '{\"id\": 8, \"sku\": \"S-3319\", \"tax\": 10, \"name\": \"Super  TEST\", \"slug\": \"super-test-H6Krp\", \"tags\": [], \"unit\": null, \"images\": [\"products/gallery/2026/08/c2e97580-0f5a-4182-ac6e-cbfa640c918c_1788085894.webp\", \"products/gallery/2026/08/773c3990-b86c-43c6-a04a-052c95cfe465_1788085894.webp\", \"products/gallery/2026/08/87ffed81-19d0-4842-b8b7-1fa351293004_1788085894.webp\", \"products/gallery/2026/08/8afe6702-7913-402a-84d7-a89b31ba2b25_1788085894.webp\", \"products/gallery/2026/08/4af9e845-9c8e-43ff-96da-4615cbb9e900_1788085894.webp\"], \"status\": \"pending\", \"brand_id\": 2, \"discount\": 2, \"tax_type\": \"flat\", \"published\": false, \"seller_id\": 2, \"thumbnail\": \"products/thumbnails/2026/08/d069f540-9450-465d-b616-1c173f79410e_1788085894.webp\", \"created_at\": \"2026-08-30T10:31:34.000000Z\", \"deleted_at\": null, \"meta_image\": \"products/meta/2026/08/fc86ee15-e2f0-40b1-8c76-7c5e8c3b52ea_1788085894.webp\", \"meta_title\": \"Hello we are ready now\", \"unit_price\": 100, \"updated_at\": \"2026-08-30T10:43:47.000000Z\", \"variations\": [], \"category_id\": 3, \"description\": \"This is the best of them all This is the best of them all This is the best of them all This is the best of them all This is the best of them all This is the best of them all This is the best of them all\", \"is_featured\": true, \"digital_file\": null, \"multiply_qty\": false, \"product_type\": \"physical\", \"stock_status\": \"in_stock\", \"current_stock\": 10, \"denied_reason\": null, \"discount_type\": \"flat\", \"shipping_cost\": 0, \"is_todays_deal\": false, \"purchase_price\": 1000, \"sub_category_id\": 2, \"meta_description\": \"This is the best of them all\", \"digital_file_type\": null, \"minimum_order_qty\": 1, \"short_description\": \"This is the best of them all\", \"low_stock_threshold\": 5}', '{\"id\": 8, \"sku\": \"S-3319\", \"tax\": 10, \"name\": \"Super  TEST\", \"slug\": \"super-test-H6Krp\", \"tags\": [], \"unit\": null, \"images\": [\"products/gallery/2026/08/c2e97580-0f5a-4182-ac6e-cbfa640c918c_1788085894.webp\", \"products/gallery/2026/08/773c3990-b86c-43c6-a04a-052c95cfe465_1788085894.webp\", \"products/gallery/2026/08/87ffed81-19d0-4842-b8b7-1fa351293004_1788085894.webp\", \"products/gallery/2026/08/8afe6702-7913-402a-84d7-a89b31ba2b25_1788085894.webp\", \"products/gallery/2026/08/4af9e845-9c8e-43ff-96da-4615cbb9e900_1788085894.webp\"], \"status\": \"approved\", \"brand_id\": 2, \"discount\": 2, \"tax_type\": \"flat\", \"published\": false, \"seller_id\": 2, \"thumbnail\": \"products/thumbnails/2026/08/d069f540-9450-465d-b616-1c173f79410e_1788085894.webp\", \"created_at\": \"2026-08-30T10:31:34.000000Z\", \"deleted_at\": null, \"meta_image\": \"products/meta/2026/08/fc86ee15-e2f0-40b1-8c76-7c5e8c3b52ea_1788085894.webp\", \"meta_title\": \"Hello we are ready now\", \"unit_price\": 100, \"updated_at\": \"2026-08-30T11:06:01.000000Z\", \"variations\": [], \"category_id\": 3, \"description\": \"This is the best of them all This is the best of them all This is the best of them all This is the best of them all This is the best of them all This is the best of them all This is the best of them all\", \"is_featured\": true, \"digital_file\": null, \"multiply_qty\": false, \"product_type\": \"physical\", \"stock_status\": \"in_stock\", \"current_stock\": 10, \"denied_reason\": null, \"discount_type\": \"flat\", \"shipping_cost\": 0, \"is_todays_deal\": false, \"purchase_price\": 1000, \"sub_category_id\": 2, \"meta_description\": \"This is the best of them all\", \"digital_file_type\": null, \"minimum_order_qty\": 1, \"short_description\": \"This is the best of them all\", \"low_stock_threshold\": 5}', '2026-08-30 10:06:01', '2026-08-30 10:06:01'),
(40, 1, 'admin', 'category.create', 'Created category \'Land Phones\' (ID: 4)', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'Desktop', 'Chrome', 'macOS', '{\"icon\": {}, \"name\": \"Land Phones\", \"banner\": {}, \"status\": \"1\", \"priority\": \"1\", \"meta_title\": \"Super\", \"meta_description\": \"Super Ones\"}', NULL, '{\"id\": 4, \"icon\": \"categories/icons/2026/08/c68285ed-96ea-4180-8d94-0bd9cfc32c25_1788091894.webp\", \"name\": \"Land Phones\", \"slug\": \"land-phones\", \"banner\": \"categories/banners/2026/08/33c3b7da-cf90-4e42-ad96-374662a25d5b_1788091894.webp\", \"status\": true, \"priority\": 1, \"created_at\": \"2026-08-30T12:11:34.000000Z\", \"updated_at\": \"2026-08-30T12:11:34.000000Z\"}', '2026-08-30 11:11:34', '2026-08-30 11:11:34');
INSERT INTO `audit_logs` (`id`, `user_id`, `user_type`, `action`, `description`, `ip_address`, `user_agent`, `device`, `browser`, `platform`, `payload`, `old_values`, `new_values`, `created_at`, `updated_at`) VALUES
(41, 1, 'admin', 'category.update', 'Updated category \'Land Phones\' (ID: 4)', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'Desktop', 'Chrome', 'macOS', '{\"name\": \"Land Phones\", \"status\": \"0\", \"_method\": \"POST\", \"priority\": \"1\"}', '{\"id\": 4, \"icon\": \"categories/icons/2026/08/c68285ed-96ea-4180-8d94-0bd9cfc32c25_1788091894.webp\", \"name\": \"Land Phones\", \"slug\": \"land-phones\", \"banner\": \"categories/banners/2026/08/33c3b7da-cf90-4e42-ad96-374662a25d5b_1788091894.webp\", \"status\": \"inactive\", \"priority\": 1, \"created_at\": \"2026-08-30T12:11:34.000000Z\", \"updated_at\": \"2026-08-30T12:11:34.000000Z\"}', '{\"id\": 4, \"icon\": \"categories/icons/2026/08/c68285ed-96ea-4180-8d94-0bd9cfc32c25_1788091894.webp\", \"name\": \"Land Phones\", \"slug\": \"land-phones\", \"banner\": \"categories/banners/2026/08/33c3b7da-cf90-4e42-ad96-374662a25d5b_1788091894.webp\", \"status\": \"\", \"priority\": 1, \"created_at\": \"2026-08-30T12:11:34.000000Z\", \"updated_at\": \"2026-08-30T12:19:50.000000Z\"}', '2026-08-30 11:19:50', '2026-08-30 11:19:50'),
(42, 1, 'admin', 'category.delete', 'Deleted category \'Land Phones\' (ID: 4)', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'Desktop', 'Chrome', 'macOS', NULL, '{\"id\": 4, \"icon\": \"categories/icons/2026/08/c68285ed-96ea-4180-8d94-0bd9cfc32c25_1788091894.webp\", \"name\": \"Land Phones\", \"slug\": \"land-phones\", \"banner\": \"categories/banners/2026/08/33c3b7da-cf90-4e42-ad96-374662a25d5b_1788091894.webp\", \"status\": \"\", \"priority\": 1, \"created_at\": \"2026-08-30T12:11:34.000000Z\", \"updated_at\": \"2026-08-30T12:19:50.000000Z\"}', NULL, '2026-08-30 11:20:08', '2026-08-30 11:20:08'),
(43, 1, 'admin', 'category.update', 'Updated category \'Home Gadgets\' (ID: 2)', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'Desktop', 'Chrome', 'macOS', '{\"name\": \"Home Gadgets\", \"status\": \"1\", \"_method\": \"POST\", \"priority\": \"1\"}', '{\"id\": 2, \"icon\": \"categoriesicons/2026/08/6566f4e4-21ef-4b62-950b-c6ab8ce349f4_1787667567.webp\", \"name\": \"Home Gadgets\", \"slug\": \"home-gadgets\", \"banner\": \"categoriesbanners/2026/08/d9c19614-e583-4f80-98d5-58dab5f09c02_1787667567.webp\", \"status\": \"inactive\", \"priority\": 1, \"created_at\": \"2026-08-25T14:19:27.000000Z\", \"updated_at\": \"2026-08-25T14:19:27.000000Z\"}', '{\"id\": 2, \"icon\": \"categoriesicons/2026/08/6566f4e4-21ef-4b62-950b-c6ab8ce349f4_1787667567.webp\", \"name\": \"Home Gadgets\", \"slug\": \"home-gadgets\", \"banner\": \"categoriesbanners/2026/08/d9c19614-e583-4f80-98d5-58dab5f09c02_1787667567.webp\", \"status\": \"inactive\", \"priority\": 1, \"created_at\": \"2026-08-25T14:19:27.000000Z\", \"updated_at\": \"2026-08-30T12:26:21.000000Z\"}', '2026-08-30 11:26:21', '2026-08-30 11:26:21'),
(44, 1, 'admin', 'category.update', 'Updated category \'Home Gadgets\' (ID: 2)', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'Desktop', 'Chrome', 'macOS', '{\"name\": \"Home Gadgets\", \"status\": \"1\", \"_method\": \"POST\", \"priority\": \"1\"}', '{\"id\": 2, \"icon\": \"categoriesicons/2026/08/6566f4e4-21ef-4b62-950b-c6ab8ce349f4_1787667567.webp\", \"name\": \"Home Gadgets\", \"slug\": \"home-gadgets\", \"banner\": \"categoriesbanners/2026/08/d9c19614-e583-4f80-98d5-58dab5f09c02_1787667567.webp\", \"status\": \"inactive\", \"priority\": 1, \"created_at\": \"2026-08-25T14:19:27.000000Z\", \"updated_at\": \"2026-08-30T12:26:21.000000Z\"}', '{\"id\": 2, \"icon\": \"categoriesicons/2026/08/6566f4e4-21ef-4b62-950b-c6ab8ce349f4_1787667567.webp\", \"name\": \"Home Gadgets\", \"slug\": \"home-gadgets\", \"banner\": \"categoriesbanners/2026/08/d9c19614-e583-4f80-98d5-58dab5f09c02_1787667567.webp\", \"status\": \"inactive\", \"priority\": 1, \"created_at\": \"2026-08-25T14:19:27.000000Z\", \"updated_at\": \"2026-08-30T12:26:46.000000Z\"}', '2026-08-30 11:26:46', '2026-08-30 11:26:46'),
(45, 1, 'admin', 'category.update', 'Updated category \'Local Electronics\' (ID: 3)', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'Desktop', 'Chrome', 'macOS', '{\"name\": \"Local Electronics\", \"status\": \"0\", \"_method\": \"POST\", \"priority\": \"2\"}', '{\"id\": 3, \"icon\": \"categories/icons/2026/08/d5479097-01ee-4e30-9092-0b3b1d6fb373_1787668611.webp\", \"name\": \"Local Electronics\", \"slug\": \"local-electronics\", \"banner\": \"categoriesbanners/2026/08/cca8a1f6-9a95-4d51-b2e7-f01c94a971ee_1787668323.webp\", \"status\": \"active\", \"priority\": 2, \"created_at\": \"2026-08-25T14:32:03.000000Z\", \"updated_at\": \"2026-08-25T14:36:51.000000Z\"}', '{\"id\": 3, \"icon\": \"categories/icons/2026/08/d5479097-01ee-4e30-9092-0b3b1d6fb373_1787668611.webp\", \"name\": \"Local Electronics\", \"slug\": \"local-electronics\", \"banner\": \"categoriesbanners/2026/08/cca8a1f6-9a95-4d51-b2e7-f01c94a971ee_1787668323.webp\", \"status\": \"\", \"priority\": 2, \"created_at\": \"2026-08-25T14:32:03.000000Z\", \"updated_at\": \"2026-08-30T12:27:22.000000Z\"}', '2026-08-30 11:27:22', '2026-08-30 11:27:22'),
(46, 1, 'admin', 'category.update', 'Updated category \'Local Electronics\' (ID: 3)', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'Desktop', 'Chrome', 'macOS', '{\"name\": \"Local Electronics\", \"status\": \"1\", \"_method\": \"POST\", \"priority\": \"2\"}', '{\"id\": 3, \"icon\": \"categories/icons/2026/08/d5479097-01ee-4e30-9092-0b3b1d6fb373_1787668611.webp\", \"name\": \"Local Electronics\", \"slug\": \"local-electronics\", \"banner\": \"categoriesbanners/2026/08/cca8a1f6-9a95-4d51-b2e7-f01c94a971ee_1787668323.webp\", \"status\": \"\", \"priority\": 2, \"created_at\": \"2026-08-25T14:32:03.000000Z\", \"updated_at\": \"2026-08-30T12:27:22.000000Z\"}', '{\"id\": 3, \"icon\": \"categories/icons/2026/08/d5479097-01ee-4e30-9092-0b3b1d6fb373_1787668611.webp\", \"name\": \"Local Electronics\", \"slug\": \"local-electronics\", \"banner\": \"categoriesbanners/2026/08/cca8a1f6-9a95-4d51-b2e7-f01c94a971ee_1787668323.webp\", \"status\": \"inactive\", \"priority\": 2, \"created_at\": \"2026-08-25T14:32:03.000000Z\", \"updated_at\": \"2026-08-30T12:27:29.000000Z\"}', '2026-08-30 11:27:29', '2026-08-30 11:27:29'),
(47, 1, 'admin', 'category.update', 'Updated category \'Local Electronics\' (ID: 3)', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'Desktop', 'Chrome', 'macOS', '{\"name\": \"Local Electronics\", \"status\": \"1\", \"_method\": \"POST\", \"priority\": \"2\"}', '{\"id\": 3, \"icon\": \"categories/icons/2026/08/d5479097-01ee-4e30-9092-0b3b1d6fb373_1787668611.webp\", \"name\": \"Local Electronics\", \"slug\": \"local-electronics\", \"banner\": \"categoriesbanners/2026/08/cca8a1f6-9a95-4d51-b2e7-f01c94a971ee_1787668323.webp\", \"status\": \"inactive\", \"priority\": 2, \"created_at\": \"2026-08-25T14:32:03.000000Z\", \"updated_at\": \"2026-08-30T12:27:29.000000Z\"}', '{\"id\": 3, \"icon\": \"categories/icons/2026/08/d5479097-01ee-4e30-9092-0b3b1d6fb373_1787668611.webp\", \"name\": \"Local Electronics\", \"slug\": \"local-electronics\", \"banner\": \"categoriesbanners/2026/08/cca8a1f6-9a95-4d51-b2e7-f01c94a971ee_1787668323.webp\", \"status\": \"inactive\", \"priority\": 2, \"created_at\": \"2026-08-25T14:32:03.000000Z\", \"updated_at\": \"2026-08-30T12:27:35.000000Z\"}', '2026-08-30 11:27:35', '2026-08-30 11:27:35'),
(48, 1, 'admin', 'category.update', 'Updated category \'Home Gadgets\' (ID: 2)', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'Desktop', 'Chrome', 'macOS', '{\"name\": \"Home Gadgets\", \"status\": \"0\", \"_method\": \"POST\", \"priority\": \"1\"}', '{\"id\": 2, \"icon\": \"categoriesicons/2026/08/6566f4e4-21ef-4b62-950b-c6ab8ce349f4_1787667567.webp\", \"name\": \"Home Gadgets\", \"slug\": \"home-gadgets\", \"banner\": \"categoriesbanners/2026/08/d9c19614-e583-4f80-98d5-58dab5f09c02_1787667567.webp\", \"status\": \"inactive\", \"priority\": 1, \"created_at\": \"2026-08-25T14:19:27.000000Z\", \"updated_at\": \"2026-08-30T12:26:46.000000Z\"}', '{\"id\": 2, \"icon\": \"categoriesicons/2026/08/6566f4e4-21ef-4b62-950b-c6ab8ce349f4_1787667567.webp\", \"name\": \"Home Gadgets\", \"slug\": \"home-gadgets\", \"banner\": \"categoriesbanners/2026/08/d9c19614-e583-4f80-98d5-58dab5f09c02_1787667567.webp\", \"status\": \"\", \"priority\": 1, \"created_at\": \"2026-08-25T14:19:27.000000Z\", \"updated_at\": \"2026-08-30T12:28:49.000000Z\"}', '2026-08-30 11:28:50', '2026-08-30 11:28:50'),
(49, 1, 'admin', 'category.update', 'Updated category \'Home Gadgets\' (ID: 2)', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'Desktop', 'Chrome', 'macOS', '{\"name\": \"Home Gadgets\", \"status\": \"0\", \"_method\": \"POST\", \"priority\": \"1\"}', '{\"id\": 2, \"icon\": \"categoriesicons/2026/08/6566f4e4-21ef-4b62-950b-c6ab8ce349f4_1787667567.webp\", \"name\": \"Home Gadgets\", \"slug\": \"home-gadgets\", \"banner\": \"categoriesbanners/2026/08/d9c19614-e583-4f80-98d5-58dab5f09c02_1787667567.webp\", \"status\": \"\", \"priority\": 1, \"created_at\": \"2026-08-25T14:19:27.000000Z\", \"updated_at\": \"2026-08-30T12:28:49.000000Z\"}', '{\"id\": 2, \"icon\": \"categoriesicons/2026/08/6566f4e4-21ef-4b62-950b-c6ab8ce349f4_1787667567.webp\", \"name\": \"Home Gadgets\", \"slug\": \"home-gadgets\", \"banner\": \"categoriesbanners/2026/08/d9c19614-e583-4f80-98d5-58dab5f09c02_1787667567.webp\", \"status\": \"\", \"priority\": 1, \"created_at\": \"2026-08-25T14:19:27.000000Z\", \"updated_at\": \"2026-08-30T12:28:56.000000Z\"}', '2026-08-30 11:28:56', '2026-08-30 11:28:56'),
(50, 1, 'admin', 'category.update', 'Updated category \'Home Gadgets\' (ID: 2)', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'Desktop', 'Chrome', 'macOS', '{\"name\": \"Home Gadgets\", \"status\": \"active\", \"_method\": \"POST\", \"priority\": \"1\"}', '{\"id\": 2, \"icon\": \"categoriesicons/2026/08/6566f4e4-21ef-4b62-950b-c6ab8ce349f4_1787667567.webp\", \"name\": \"Home Gadgets\", \"slug\": \"home-gadgets\", \"banner\": \"categoriesbanners/2026/08/d9c19614-e583-4f80-98d5-58dab5f09c02_1787667567.webp\", \"status\": \"\", \"priority\": 1, \"created_at\": \"2026-08-25T14:19:27.000000Z\", \"updated_at\": \"2026-08-30T12:28:56.000000Z\"}', '{\"id\": 2, \"icon\": \"categoriesicons/2026/08/6566f4e4-21ef-4b62-950b-c6ab8ce349f4_1787667567.webp\", \"name\": \"Home Gadgets\", \"slug\": \"home-gadgets\", \"banner\": \"categoriesbanners/2026/08/d9c19614-e583-4f80-98d5-58dab5f09c02_1787667567.webp\", \"status\": \"active\", \"priority\": 1, \"created_at\": \"2026-08-25T14:19:27.000000Z\", \"updated_at\": \"2026-08-30T12:29:55.000000Z\"}', '2026-08-30 11:29:55', '2026-08-30 11:29:55'),
(51, 1, 'admin', 'category.update', 'Updated category \'Home Gadgets\' (ID: 2)', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'Desktop', 'Chrome', 'macOS', '{\"name\": \"Home Gadgets\", \"status\": \"active\", \"_method\": \"POST\", \"priority\": \"1\"}', '{\"id\": 2, \"icon\": \"categoriesicons/2026/08/6566f4e4-21ef-4b62-950b-c6ab8ce349f4_1787667567.webp\", \"name\": \"Home Gadgets\", \"slug\": \"home-gadgets\", \"banner\": \"categoriesbanners/2026/08/d9c19614-e583-4f80-98d5-58dab5f09c02_1787667567.webp\", \"status\": \"active\", \"priority\": 1, \"created_at\": \"2026-08-25T14:19:27.000000Z\", \"updated_at\": \"2026-08-30T12:29:55.000000Z\"}', '{\"id\": 2, \"icon\": \"categoriesicons/2026/08/6566f4e4-21ef-4b62-950b-c6ab8ce349f4_1787667567.webp\", \"name\": \"Home Gadgets\", \"slug\": \"home-gadgets\", \"banner\": \"categoriesbanners/2026/08/d9c19614-e583-4f80-98d5-58dab5f09c02_1787667567.webp\", \"status\": \"active\", \"priority\": 1, \"created_at\": \"2026-08-25T14:19:27.000000Z\", \"updated_at\": \"2026-08-30T12:29:55.000000Z\"}', '2026-08-30 11:30:09', '2026-08-30 11:30:09'),
(52, 1, 'admin', 'subcategory.update', 'Updated subcategory \'Digital Illustrations\' (ID: 2)', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'Desktop', 'Chrome', 'macOS', '{\"name\": \"Digital Illustrations\", \"status\": \"active\", \"priority\": 1, \"category_id\": 2}', '{\"id\": 2, \"name\": \"Digital Illustrations\", \"slug\": \"digital-illustrations-pObm\", \"status\": null, \"priority\": 1, \"created_at\": \"2026-08-25T15:25:13.000000Z\", \"updated_at\": \"2026-08-25T15:25:13.000000Z\", \"category_id\": 2}', '{\"id\": 2, \"name\": \"Digital Illustrations\", \"slug\": \"digital-illustrations-pObm\", \"status\": \"active\", \"priority\": 1, \"created_at\": \"2026-08-25T15:25:13.000000Z\", \"updated_at\": \"2026-08-30T12:44:38.000000Z\", \"category_id\": 2}', '2026-08-30 11:44:38', '2026-08-30 11:44:38'),
(53, 1, 'admin', 'subcategory.update', 'Updated subcategory \'Digital Illustrations\' (ID: 2)', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'Desktop', 'Chrome', 'macOS', '{\"name\": \"Digital Illustrations\", \"status\": \"inactive\", \"priority\": 1, \"category_id\": 2}', '{\"id\": 2, \"name\": \"Digital Illustrations\", \"slug\": \"digital-illustrations-pObm\", \"status\": \"active\", \"priority\": 1, \"created_at\": \"2026-08-25T15:25:13.000000Z\", \"updated_at\": \"2026-08-30T12:44:38.000000Z\", \"category_id\": 2}', '{\"id\": 2, \"name\": \"Digital Illustrations\", \"slug\": \"digital-illustrations-pObm\", \"status\": \"inactive\", \"priority\": 1, \"created_at\": \"2026-08-25T15:25:13.000000Z\", \"updated_at\": \"2026-08-30T12:44:45.000000Z\", \"category_id\": 2}', '2026-08-30 11:44:45', '2026-08-30 11:44:45'),
(54, 1, 'admin', 'subcategory.create', 'Created subcategory \'Apple Juice\' (ID: 3) under Category ID 2', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'Desktop', 'Chrome', 'macOS', '{\"name\": \"Apple Juice\", \"status\": \"active\", \"priority\": 1, \"category_id\": 2}', NULL, '{\"id\": 3, \"name\": \"Apple Juice\", \"slug\": \"apple-juice-8oe9\", \"status\": \"active\", \"priority\": 1, \"created_at\": \"2026-08-30T12:45:09.000000Z\", \"updated_at\": \"2026-08-30T12:45:09.000000Z\", \"category_id\": 2}', '2026-08-30 11:45:09', '2026-08-30 11:45:09'),
(55, 1, 'admin', 'subcategory.delete', 'Deleted subcategory \'Apple Juice\' (ID: 3)', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'Desktop', 'Chrome', 'macOS', NULL, '{\"id\": 3, \"name\": \"Apple Juice\", \"slug\": \"apple-juice-8oe9\", \"status\": \"active\", \"priority\": 1, \"created_at\": \"2026-08-30T12:45:09.000000Z\", \"updated_at\": \"2026-08-30T12:45:09.000000Z\", \"category_id\": 2}', NULL, '2026-08-30 11:45:14', '2026-08-30 11:45:14'),
(56, 1, NULL, 'create_role', 'Created new system role: Finance Manager', '127.0.0.1', 'PostmanRuntime/2.4.0', NULL, NULL, NULL, NULL, NULL, '{\"id\": 1, \"name\": \"Finance Manager\", \"slug\": \"finance-manager\", \"created_at\": \"2026-08-31T08:43:59.000000Z\", \"updated_at\": \"2026-08-31T08:43:59.000000Z\", \"description\": \"Manages settlements, seller payouts, and refunds.\", \"permissions\": [{\"id\": 1, \"name\": \"View Dashboard\", \"slug\": \"dashboard.view\", \"group\": \"dashboard\", \"pivot\": {\"role_id\": 1, \"permission_id\": 1}, \"created_at\": \"2026-08-28T00:27:12.000000Z\", \"updated_at\": \"2026-08-28T00:27:12.000000Z\", \"description\": \"Access main system dashboard analytics\"}, {\"id\": 2, \"name\": \"View Categories\", \"slug\": \"categories.view\", \"group\": \"categories\", \"pivot\": {\"role_id\": 1, \"permission_id\": 2}, \"created_at\": \"2026-08-28T00:27:12.000000Z\", \"updated_at\": \"2026-08-28T00:27:12.000000Z\", \"description\": \"View product categories and details\"}, {\"id\": 5, \"name\": \"Delete Categories\", \"slug\": \"categories.delete\", \"group\": \"categories\", \"pivot\": {\"role_id\": 1, \"permission_id\": 5}, \"created_at\": \"2026-08-28T00:27:12.000000Z\", \"updated_at\": \"2026-08-28T00:27:12.000000Z\", \"description\": \"Delete product categories\"}, {\"id\": 8, \"name\": \"Edit Sub-Categories\", \"slug\": \"subcategories.edit\", \"group\": \"subcategories\", \"pivot\": {\"role_id\": 1, \"permission_id\": 8}, \"created_at\": \"2026-08-28T00:27:12.000000Z\", \"updated_at\": \"2026-08-28T00:27:12.000000Z\", \"description\": \"Update existing sub-categories\"}]}', '2026-08-31 07:43:59', '2026-08-31 07:43:59'),
(57, 1, NULL, 'invite_admin_user', 'Sent invitation to newstaff@example.com for role ID 1', '127.0.0.1', 'PostmanRuntime/2.4.0', NULL, NULL, NULL, NULL, NULL, '{\"id\": 1, \"email\": \"newstaff@example.com\", \"token\": \"JpXhXKStbkaSSwrwvuDt9BTjEl63JMfMN0F1vyzq\", \"status\": \"pending\", \"role_id\": 1, \"created_at\": \"2026-08-31T08:44:38.000000Z\", \"expires_at\": \"2026-09-07T08:44:38.000000Z\", \"invited_by\": 1, \"updated_at\": \"2026-08-31T08:44:38.000000Z\"}', '2026-08-31 07:44:38', '2026-08-31 07:44:38'),
(58, 1, NULL, 'toggle_staff_status', 'Changed status of staff member #4 (newstaff@example.com) to disabled', '127.0.0.1', 'PostmanRuntime/2.4.0', NULL, NULL, NULL, NULL, '{\"status\": \"active\"}', '{\"status\": \"disabled\"}', '2026-08-31 07:55:04', '2026-08-31 07:55:04'),
(59, 1, NULL, 'toggle_staff_status', 'Changed status of staff member #4 (newstaff@example.com) to disabled', '127.0.0.1', 'PostmanRuntime/2.4.0', NULL, NULL, NULL, NULL, '{\"status\": \"active\"}', '{\"status\": \"disabled\"}', '2026-08-31 07:55:07', '2026-08-31 07:55:07'),
(60, 1, NULL, 'toggle_staff_status', 'Changed status of staff member #4 (newstaff@example.com) to disabled', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, '{\"status\": \"active\"}', '{\"status\": \"disabled\"}', '2026-08-31 08:01:09', '2026-08-31 08:01:09'),
(61, 1, NULL, 'toggle_staff_status', 'Changed status of staff member #4 (newstaff@example.com) to disabled', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, '{\"status\": \"active\"}', '{\"status\": \"disabled\"}', '2026-08-31 08:01:13', '2026-08-31 08:01:13'),
(62, 1, NULL, 'toggle_staff_status', 'Changed status of staff member #4 (newstaff@example.com) to active', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, '{\"status\": \"active\"}', '{\"status\": \"active\"}', '2026-08-31 08:01:15', '2026-08-31 08:01:15'),
(63, 1, NULL, 'toggle_staff_status', 'Changed status of staff member #4 (newstaff@example.com) to disabled', '127.0.0.1', 'PostmanRuntime/2.4.0', NULL, NULL, NULL, NULL, '{\"status\": \"active\"}', '{\"status\": \"disabled\"}', '2026-08-31 08:02:11', '2026-08-31 08:02:11'),
(64, 1, NULL, 'toggle_staff_status', 'Changed status of staff member #4 (newstaff@example.com) to disabled', '127.0.0.1', 'Mozilla/5.0 (Linux; Android 15; Pixel 9) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', NULL, NULL, NULL, NULL, '{\"status\": \"active\"}', '{\"status\": \"disabled\"}', '2026-08-31 08:03:32', '2026-08-31 08:03:32'),
(65, 1, NULL, 'toggle_staff_status', 'Changed status of staff member #4 (newstaff@example.com) to active', '127.0.0.1', 'Mozilla/5.0 (Linux; Android 15; Pixel 9) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', NULL, NULL, NULL, NULL, '{\"status\": \"active\"}', '{\"status\": \"active\"}', '2026-08-31 08:03:42', '2026-08-31 08:03:42'),
(66, 1, NULL, 'toggle_staff_status', 'Changed status of staff member #4 (newstaff@example.com) to disabled', '127.0.0.1', 'Mozilla/5.0 (Linux; Android 15; Pixel 9) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', NULL, NULL, NULL, NULL, '{\"status\": \"active\"}', '{\"status\": \"disabled\"}', '2026-08-31 08:04:36', '2026-08-31 08:04:36'),
(67, 1, NULL, 'toggle_staff_status', 'Changed status of staff member #4 (newstaff@example.com) to active', '127.0.0.1', 'Mozilla/5.0 (Linux; Android 15; Pixel 9) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', NULL, NULL, NULL, NULL, '{\"status\": \"disabled\"}', '{\"status\": \"active\"}', '2026-08-31 08:04:43', '2026-08-31 08:04:43'),
(68, 1, NULL, 'update_staff_profile', 'Updated profile details for staff member #4 (newstaff@example.com)', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, '{\"name\": \"New Staff\", \"email\": \"newstaff@example.com\", \"phone\": null, \"avatar\": \"inclusive HRMs-1 (1)_1753282162.jpg\"}', '{\"name\": \"New Staff\", \"email\": \"newstaff@example.com\", \"phone\": \"08034334334\", \"avatar\": \"inclusive HRMs-1 (1)_1753282162.jpg\"}', '2026-08-31 08:48:14', '2026-08-31 08:48:14'),
(69, 1, NULL, 'update_staff_profile', 'Updated profile details for staff member #4 (newstaff@example.com)', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, '{\"name\": \"New Staff\", \"email\": \"newstaff@example.com\", \"phone\": \"08034334334\", \"avatar\": \"inclusive HRMs-1 (1)_1753282162.jpg\"}', '{\"name\": \"New Staff\", \"email\": \"newstaff@example.com\", \"phone\": \"08034334334\", \"avatar\": \"avatars/b9yIcHenQ0xkDHxNjwyaKl1shL6l0dq7XYdXV5eh.png\"}', '2026-08-31 08:48:31', '2026-08-31 08:48:31'),
(70, 1, NULL, 'toggle_staff_status', 'Changed status of staff member #4 (newstaff@example.com) to disabled', '127.0.0.1', 'Mozilla/5.0 (Linux; Android 15; Pixel 9) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', NULL, NULL, NULL, NULL, '{\"status\": \"active\"}', '{\"status\": \"disabled\"}', '2026-08-31 08:49:59', '2026-08-31 08:49:59'),
(71, 1, NULL, 'toggle_staff_status', 'Changed status of staff member #4 (newstaff@example.com) to active', '127.0.0.1', 'Mozilla/5.0 (Linux; Android 15; Pixel 9) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', NULL, NULL, NULL, NULL, '{\"status\": \"disabled\"}', '{\"status\": \"active\"}', '2026-08-31 08:50:03', '2026-08-31 08:50:03'),
(72, 1, NULL, 'update_staff_password', 'Admin reset password for staff member #4 (newstaff@example.com)', '127.0.0.1', 'Mozilla/5.0 (Linux; Android 15; Pixel 9) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', NULL, NULL, NULL, NULL, NULL, NULL, '2026-08-31 08:50:44', '2026-08-31 08:50:44'),
(73, 1, NULL, 'invite_admin_user', 'Sent invitation to newstaff@examples.com for role ID 1', '127.0.0.1', 'PostmanRuntime/2.4.0', NULL, NULL, NULL, NULL, NULL, '{\"id\": 2, \"email\": \"newstaff@examples.com\", \"token\": \"MnB8RLB0vQ4qoAhWtL8LVfnQfWMkSCiMj3qe01J0\", \"status\": \"pending\", \"role_id\": 1, \"created_at\": \"2026-08-31T10:04:04.000000Z\", \"expires_at\": \"2026-09-07T10:04:04.000000Z\", \"invited_by\": 1, \"updated_at\": \"2026-08-31T10:04:04.000000Z\"}', '2026-08-31 09:04:04', '2026-08-31 09:04:04'),
(74, 1, NULL, 'invite_admin_user', 'Sent invitation to mariam@mai.com for role ID 1', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '{\"id\": 3, \"email\": \"mariam@mai.com\", \"token\": \"jY58gvJHRd1jdDnTfmjc6I6Aaa7TMFnkXnT1hGk9\", \"status\": \"pending\", \"role_id\": 1, \"created_at\": \"2026-08-31T10:23:53.000000Z\", \"expires_at\": \"2026-09-07T10:23:53.000000Z\", \"invited_by\": 1, \"updated_at\": \"2026-08-31T10:23:53.000000Z\"}', '2026-08-31 09:23:53', '2026-08-31 09:23:53'),
(75, 1, NULL, 'invite_admin_user', 'Created staff account #44 (adetunjioluwakayode@gmail.com) and issued role ID 1', '127.0.0.1', 'Mozilla/5.0 (Linux; Android 15; Pixel 9) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', NULL, NULL, NULL, NULL, NULL, '{\"user\": {\"id\": 44, \"name\": \"John Doe\", \"type\": null, \"email\": \"adetunjioluwakayode@gmail.com\", \"phone\": \"08034334334\", \"status\": \"pending\"}, \"invitation\": {\"id\": 10, \"email\": \"adetunjioluwakayode@gmail.com\", \"token\": \"fHzokxnzwqyOmpwL4FoHgZEUab4na2wLoDU13Kwx\", \"status\": \"pending\", \"role_id\": 1, \"created_at\": \"2026-08-31T10:38:23.000000Z\", \"expires_at\": \"2026-09-07T10:38:23.000000Z\", \"invited_by\": 1, \"updated_at\": \"2026-08-31T10:38:23.000000Z\"}}', '2026-08-31 09:38:23', '2026-08-31 09:38:23'),
(76, 1, NULL, 'invite_admin_user', 'Created staff account #45 (adetunjioluwakayode@gmail.comw) and issued role ID 1', '127.0.0.1', 'Mozilla/5.0 (Linux; Android 15; Pixel 9) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', NULL, NULL, NULL, NULL, NULL, '{\"user\": {\"id\": 45, \"name\": \"John Doe\", \"type\": null, \"email\": \"adetunjioluwakayode@gmail.comw\", \"phone\": \"08034334334\", \"status\": \"pending\"}, \"invitation\": {\"id\": 11, \"email\": \"adetunjioluwakayode@gmail.comw\", \"token\": \"Yw3t3Lslvzz3W58QH3QbFrMM7hZN8twDj8uUU41r\", \"status\": \"pending\", \"role_id\": 1, \"created_at\": \"2026-08-31T10:39:05.000000Z\", \"expires_at\": \"2026-09-07T10:39:05.000000Z\", \"invited_by\": 1, \"updated_at\": \"2026-08-31T10:39:05.000000Z\"}}', '2026-08-31 09:39:05', '2026-08-31 09:39:05'),
(77, 1, NULL, 'invite_admin_user', 'Created staff account #46 (adetunjioluwakayode@gmail.comws) and issued role ID 1', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '{\"user\": {\"id\": 46, \"name\": \"John Doe\", \"type\": null, \"email\": \"adetunjioluwakayode@gmail.comws\", \"phone\": \"08034334334\", \"status\": \"pending\"}, \"invitation\": {\"id\": 12, \"email\": \"adetunjioluwakayode@gmail.comws\", \"token\": \"w6vp8veIuc1qvxLhbX709kxsUqGeObQxDRdlGHBZ\", \"status\": \"pending\", \"role_id\": 1, \"created_at\": \"2026-08-31T10:40:52.000000Z\", \"expires_at\": \"2026-09-07T10:40:52.000000Z\", \"invited_by\": 1, \"updated_at\": \"2026-08-31T10:40:52.000000Z\"}}', '2026-08-31 09:40:52', '2026-08-31 09:40:52'),
(78, 1, NULL, 'toggle_staff_status', 'Changed status of staff member #44 (adetunjioluwakayode@gmail.com) to active', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, '{\"status\": \"pending\"}', '{\"status\": \"active\"}', '2026-08-31 10:14:25', '2026-08-31 10:14:25'),
(79, 1, NULL, 'toggle_staff_status', 'Changed status of staff member #44 (adetunjioluwakayode@gmail.com) to disabled', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, '{\"status\": \"active\"}', '{\"status\": \"disabled\"}', '2026-08-31 10:14:28', '2026-08-31 10:14:28'),
(80, 1, NULL, 'toggle_staff_status', 'Changed status of staff member #44 (adetunjioluwakayode@gmail.com) to active', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, '{\"status\": \"disabled\"}', '{\"status\": \"active\"}', '2026-08-31 10:14:30', '2026-08-31 10:14:30'),
(81, 1, NULL, 'toggle_staff_status', 'Changed status of staff member #44 (adetunjioluwakayode@gmail.com) to disabled', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, '{\"status\": \"active\"}', '{\"status\": \"disabled\"}', '2026-08-31 10:14:33', '2026-08-31 10:14:33'),
(82, 1, NULL, 'toggle_staff_status', 'Changed status of staff member #44 (adetunjioluwakayode@gmail.com) to active', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, '{\"status\": \"disabled\"}', '{\"status\": \"active\"}', '2026-08-31 10:16:49', '2026-08-31 10:16:49'),
(83, 1, NULL, 'toggle_staff_status', 'Changed status of staff member #44 (adetunjioluwakayode@gmail.com) to disabled', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, '{\"status\": \"active\"}', '{\"status\": \"disabled\"}', '2026-08-31 10:17:01', '2026-08-31 10:17:01'),
(84, 1, NULL, 'toggle_staff_status', 'Changed status of staff member #44 (adetunjioluwakayode@gmail.com) to active', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, '{\"status\": \"disabled\"}', '{\"status\": \"active\"}', '2026-08-31 10:17:02', '2026-08-31 10:17:02'),
(85, 1, NULL, 'toggle_staff_status', 'Changed status of staff member #44 (adetunjioluwakayode@gmail.com) to disabled', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, '{\"status\": \"active\"}', '{\"status\": \"disabled\"}', '2026-08-31 10:17:04', '2026-08-31 10:17:04'),
(86, 1, NULL, 'delete_staff_user', 'Deleted staff user #44 (adetunjioluwakayode@gmail.com)', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, NULL, '2026-08-31 10:17:14', '2026-08-31 10:17:14'),
(87, 1, NULL, 'update_seller_status', 'Updated seller status (#2 - John Doe) from active to disabled. Reason: N/A', '127.0.0.1', 'Mozilla/5.0 (Linux; Android 15; Pixel 9) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', NULL, NULL, NULL, NULL, '{\"status\": \"active\"}', '{\"status\": \"disabled\"}', '2026-08-31 10:54:37', '2026-08-31 10:54:37'),
(88, 1, NULL, 'update_seller_status', 'Updated seller status (#2 - John Doe) from disabled to active. Reason: N/A', '127.0.0.1', 'Mozilla/5.0 (Linux; Android 15; Pixel 9) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', NULL, NULL, NULL, NULL, '{\"status\": \"disabled\"}', '{\"status\": \"active\"}', '2026-08-31 10:55:25', '2026-08-31 10:55:25'),
(89, 1, NULL, 'update_seller_status', 'Updated seller status (#2 - John Doe) from active to disabled. Reason: N/A', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, '{\"status\": \"active\"}', '{\"status\": \"disabled\"}', '2026-08-31 11:43:46', '2026-08-31 11:43:46'),
(90, 1, NULL, 'update_seller_status', 'Updated seller status (#2 - John Doe) from disabled to active. Reason: N/A', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, '{\"status\": \"disabled\"}', '{\"status\": \"active\"}', '2026-08-31 11:43:49', '2026-08-31 11:43:49'),
(91, 1, NULL, 'update_seller_status', 'Updated seller status (#2 - John Doe) from active to disabled. Reason: N/A', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, '{\"status\": \"active\"}', '{\"status\": \"disabled\"}', '2026-08-31 11:43:52', '2026-08-31 11:43:52'),
(92, 1, NULL, 'update_seller_status', 'Updated seller status (#2 - John Doe) from disabled to active. Reason: N/A', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, '{\"status\": \"disabled\"}', '{\"status\": \"active\"}', '2026-08-31 11:46:11', '2026-08-31 11:46:11'),
(93, 1, NULL, 'update_seller_status', 'Updated seller status (#2 - John Doe) from active to disabled. Reason: N/A', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, '{\"status\": \"active\"}', '{\"status\": \"disabled\"}', '2026-08-31 11:46:14', '2026-08-31 11:46:14'),
(94, 1, NULL, 'update_seller_status', 'Updated seller status (#2 - John Doe) from disabled to active. Reason: N/A', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, '{\"status\": \"disabled\"}', '{\"status\": \"active\"}', '2026-08-31 12:03:31', '2026-08-31 12:03:31'),
(95, 1, NULL, 'update_seller_status', 'Updated seller status (#2 - John Doe) from active to disabled. Reason: N/A', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, '{\"status\": \"active\"}', '{\"status\": \"disabled\"}', '2026-08-31 12:09:35', '2026-08-31 12:09:35'),
(96, 1, NULL, 'update_seller_status', 'Updated seller status (#2 - John Doe) from disabled to active. Reason: N/A', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, '{\"status\": \"disabled\"}', '{\"status\": \"active\"}', '2026-08-31 12:09:38', '2026-08-31 12:09:38'),
(97, 1, NULL, 'update_seller_status', 'Updated seller status (#2 - John Doe) from active to disabled. Reason: N/A', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, '{\"status\": \"active\"}', '{\"status\": \"disabled\"}', '2026-08-31 12:18:35', '2026-08-31 12:18:35'),
(98, 1, NULL, 'update_seller_status', 'Updated seller status (#2 - John Doe) from disabled to active. Reason: N/A', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, '{\"status\": \"disabled\"}', '{\"status\": \"active\"}', '2026-08-31 12:18:38', '2026-08-31 12:18:38'),
(99, 1, NULL, 'update_seller_status', 'Updated seller status (#2 - John Doe) from active to disabled. Reason: N/A', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, '{\"status\": \"active\"}', '{\"status\": \"disabled\"}', '2026-08-31 13:19:07', '2026-08-31 13:19:07'),
(100, 1, NULL, 'update_seller_status', 'Updated seller status (#2 - John Doe) from disabled to active. Reason: N/A', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, '{\"status\": \"disabled\"}', '{\"status\": \"active\"}', '2026-08-31 13:19:13', '2026-08-31 13:19:13'),
(101, 1, NULL, 'update_seller_status', 'Updated seller status (#2 - John Doe) from active to disabled. Reason: N/A', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, '{\"status\": \"active\"}', '{\"status\": \"disabled\"}', '2026-08-31 13:20:52', '2026-08-31 13:20:52'),
(102, 1, NULL, 'update_seller_status', 'Updated seller status (#2 - John Doe) from disabled to active. Reason: N/A', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, '{\"status\": \"disabled\"}', '{\"status\": \"active\"}', '2026-08-31 13:20:55', '2026-08-31 13:20:55'),
(103, 1, NULL, 'delete_customer', 'Deleted customer account (#3 - buyer@buyer.com).', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, '{\"id\": 3, \"name\": \"John Dillion\", \"type\": \"buyer\", \"email\": \"buyer@buyer.com\", \"phone\": null, \"avatar\": \"inclusive HRMs-1 (1)_1753282162.jpg\", \"status\": \"active\", \"created_at\": \"2025-07-04T06:25:44.000000Z\", \"created_by\": null, \"deleted_at\": null, \"last_login\": \"2026-08-25 11:17:57\", \"updated_at\": \"2026-08-25T11:54:09.000000Z\", \"login_attempts\": 0, \"email_verified_at\": \"2025-07-04T06:25:44.000000Z\"}', NULL, '2026-08-31 14:21:52', '2026-08-31 14:21:52'),
(104, 1, NULL, 'update_customer_status', 'Changed customer (#3 - John Dillion) status from active to active. Reason: We are not ready', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, '{\"status\": \"active\"}', '{\"status\": \"active\"}', '2026-08-31 15:06:11', '2026-08-31 15:06:11'),
(105, 1, NULL, 'update_customer_status', 'Changed customer (#3 - John Dillion) status from active to disabled. Reason: None', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, '{\"status\": \"active\"}', '{\"status\": \"disabled\"}', '2026-08-31 15:06:30', '2026-08-31 15:06:30'),
(106, 1, NULL, 'update_customer_status', 'Changed customer (#3 - John Dillion) status from disabled to active. Reason: N/A', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, '{\"status\": \"disabled\"}', '{\"status\": \"active\"}', '2026-08-31 15:06:37', '2026-08-31 15:06:37'),
(107, 1, NULL, 'update_customer_status', 'Changed customer (#3 - John Dillion) status from active to active. Reason: N/A', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, '{\"status\": \"active\"}', '{\"status\": \"active\"}', '2026-08-31 15:07:46', '2026-08-31 15:07:46'),
(108, 1, NULL, 'update_customer_status', 'Changed customer (#3 - John Dillion) status from active to pending. Reason: None', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, '{\"status\": \"active\"}', '{\"status\": \"pending\"}', '2026-08-31 15:07:53', '2026-08-31 15:07:53'),
(109, 1, NULL, 'send_customer_email', 'Sent notification email to customer (#3 - John Dillion). Subject: Hello', '127.0.0.1', 'Mozilla/5.0 (Linux; Android 15; Pixel 9) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', NULL, NULL, NULL, NULL, NULL, NULL, '2026-08-31 15:13:37', '2026-08-31 15:13:37'),
(110, 1, NULL, 'update_customer_status', 'Changed customer (#3 - John Dillion) status from pending to active. Reason: N/A', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, '{\"status\": \"pending\"}', '{\"status\": \"active\"}', '2026-08-31 15:13:57', '2026-08-31 15:13:57'),
(111, 1, NULL, 'update_general_settings', 'Updated system general settings (site name, email, phone, currency).', '127.0.0.1', 'PostmanRuntime/2.4.3', NULL, NULL, NULL, NULL, '{\"site_name\": \"My E-Commerce Platform\", \"site_email\": \"support@example.com\", \"site_phone\": \"+2348000000000\", \"site_currency\": \"USD\", \"currency_symbol\": \"$\"}', '{\"site_name\": \"Market My Art Platform\", \"site_email\": \"support@marketmyart.com\", \"site_phone\": \"+2348000001111\", \"site_currency\": \"USD\", \"currency_symbol\": \"$\"}', '2026-09-01 15:18:50', '2026-09-01 15:18:50'),
(112, 1, NULL, 'update_general_settings', 'Updated system general settings (site name, email, phone, currency).', '127.0.0.1', 'PostmanRuntime/2.4.3', NULL, NULL, NULL, NULL, '{\"site_name\": \"Market My Art Platform\", \"site_email\": \"support@marketmyart.com\", \"site_phone\": \"+2348000001111\", \"site_currency\": \"USD\", \"currency_symbol\": \"$\"}', '{\"site_name\": \"Market My Art Platform\", \"site_email\": \"support@marketmyart.com\", \"site_phone\": \"+2348000001111\", \"site_currency\": \"USD\", \"currency_symbol\": \"$\"}', '2026-09-01 15:19:03', '2026-09-01 15:19:03'),
(113, 1, NULL, 'update_general_settings', 'Updated system general settings (site name, email, phone, currency).', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, '{\"site_name\": \"Market My Art Platform\", \"site_email\": \"support@marketmyart.com\", \"site_phone\": \"+2348000001111\", \"site_currency\": \"USD\", \"currency_symbol\": \"$\"}', '{\"site_name\": \"Market My Art Platform\", \"site_email\": \"support@marketmyart.com\", \"site_phone\": \"+2348000001111\", \"site_currency\": \"USD\", \"currency_symbol\": \"#\"}', '2026-09-01 15:24:26', '2026-09-01 15:24:26'),
(114, 1, NULL, 'update_general_settings', 'Updated system general settings (site name, email, phone, currency).', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, '{\"site_name\": \"Market My Art Platform\", \"site_email\": \"support@marketmyart.com\", \"site_phone\": \"+2348000001111\", \"site_currency\": \"USD\", \"currency_symbol\": \"#\"}', '{\"site_name\": \"Market My Art Platform\", \"site_email\": \"support@marketmyart.com\", \"site_phone\": \"+2348000001111\", \"site_currency\": \"NGN\", \"currency_symbol\": \"₦\"}', '2026-09-01 15:24:40', '2026-09-01 15:24:40'),
(115, 1, NULL, 'update_general_settings', 'Updated system general settings (site name, email, phone, currency).', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, '{\"site_name\": \"Market My Art Platform\", \"site_email\": \"support@marketmyart.com\", \"site_phone\": \"+2348000001111\", \"site_currency\": \"NGN\", \"currency_symbol\": \"₦\"}', '{\"site_name\": \"Market My Art Platform\", \"site_email\": \"support@marketmyart.com\", \"site_phone\": \"+23480000011113\", \"site_currency\": \"NGN\", \"currency_symbol\": \"₦\"}', '2026-09-01 15:31:35', '2026-09-01 15:31:35'),
(116, 1, NULL, 'update_general_settings', 'Updated system general settings (site name, email, phone, currency).', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, '{\"site_name\": \"Market My Art Platform\", \"site_email\": \"support@marketmyart.com\", \"site_phone\": \"+23480000011113\", \"site_currency\": \"NGN\", \"currency_symbol\": \"₦\"}', '{\"site_name\": \"Market My Art Platform\", \"site_email\": \"support@marketmyart.com\", \"site_phone\": \"+23480000011113\", \"site_currency\": \"NGN\", \"currency_symbol\": \"₦\"}', '2026-09-01 15:51:35', '2026-09-01 15:51:35'),
(117, 1, NULL, 'update_homepage_seo', 'Updated landing page SEO meta parameters.', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, '{\"meta_title\": \"Welcome to Our Store - Exclusive Deals Today\", \"meta_keywords\": \"home deals, trending items, shop now\", \"meta_description\": \"Shop our exclusive landing page collection with flash sales and top brands.\"}', '{\"meta_title\": \"Welcome to Our Store - Exclusive Deals Today\", \"meta_keywords\": \"home deals, trending items, shop now\", \"meta_description\": \"Shop our exclusive landing page collection with flash sales and top brands.s\"}', '2026-09-01 16:01:56', '2026-09-01 16:01:56'),
(118, 1, NULL, 'update_global_seo', 'Updated system global SEO meta parameters.', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, '{\"meta_image\": \"https://storage.example.com/settings/global-og.png\", \"meta_title\": \"Best Online Store - Shop Top Quality Products\", \"meta_keywords\": \"ecommerce, online shopping, electronics, deals\", \"meta_description\": \"Discover amazing deals on top products across electronics, fashion, and home items.\"}', '{\"meta_image\": \"https://storage.example.com/settings/global-og.png\", \"meta_title\": \"Best Online Store - Shop Top Quality Products\", \"meta_keywords\": \"ecommerce, online shopping, electronics, deals\", \"meta_description\": \"Discover amazing deals on top products across electronics, fashion, and home items.s\"}', '2026-09-01 16:02:07', '2026-09-01 16:02:07'),
(119, 1, NULL, 'update_maintenance_mode', 'System maintenance mode was enabled.', '127.0.0.1', 'PostmanRuntime/2.4.3', NULL, NULL, NULL, NULL, '{\"maintenance_mode\": \"0\", \"maintenance_message\": \"We are currently performing scheduled maintenance. Please check back soon.\"}', '{\"maintenance_mode\": true, \"maintenance_message\": \"We are performing a major upgrade. Back in 30 minutes!\"}', '2026-09-01 20:37:56', '2026-09-01 20:37:56'),
(120, 1, NULL, 'update_maintenance_mode', 'System maintenance mode was disabled.', '127.0.0.1', 'PostmanRuntime/2.4.3', NULL, NULL, NULL, NULL, '{\"maintenance_mode\": \"1\", \"maintenance_message\": \"We are performing a major upgrade. Back in 30 minutes!\"}', '{\"maintenance_mode\": false, \"maintenance_message\": \"We are performing a major upgrade. Back in 30 minutes!\"}', '2026-09-01 20:38:02', '2026-09-01 20:38:02'),
(121, 1, NULL, 'update_maintenance_mode', 'System maintenance mode was disabled.', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, '{\"maintenance_mode\": \"0\", \"maintenance_message\": \"We are performing a major upgrade. Back in 30 minutes!\"}', '{\"maintenance_mode\": false, \"maintenance_message\": \"We are performing a major upgrade. Back in 30 minutes!\"}', '2026-09-01 20:39:22', '2026-09-01 20:39:22'),
(122, 1, NULL, 'update_maintenance_mode', 'System maintenance mode was enabled.', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, '{\"maintenance_mode\": \"0\", \"maintenance_message\": \"We are performing a major upgrade. Back in 30 minutes!\"}', '{\"maintenance_mode\": true, \"maintenance_message\": \"We are performing a major upgrade. Back in 30 minutes!\"}', '2026-09-01 20:39:27', '2026-09-01 20:39:27'),
(123, 1, NULL, 'update_maintenance_mode', 'System maintenance mode was enabled.', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, '{\"maintenance_mode\": \"1\", \"maintenance_message\": \"We are performing a major upgrade. Back in 30 minutes!\"}', '{\"maintenance_mode\": true, \"maintenance_message\": \"We are performing a major upgrade. Back in 30 minutes!\"}', '2026-09-01 20:40:04', '2026-09-01 20:40:04'),
(124, 1, NULL, 'update_maintenance_mode', 'System maintenance mode was enabled.', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, '{\"maintenance_mode\": \"1\", \"maintenance_message\": \"We are performing a major upgrade. Back in 30 minutes!\"}', '{\"maintenance_mode\": true, \"maintenance_message\": \"We are performing a major upgrade. Back in 30 minutes!\"}', '2026-09-01 20:40:12', '2026-09-01 20:40:12'),
(125, 1, NULL, 'update_maintenance_mode', 'System maintenance mode was disabled.', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, '{\"maintenance_mode\": \"1\", \"maintenance_message\": \"We are performing a major upgrade. Back in 30 minutes!\"}', '{\"maintenance_mode\": false, \"maintenance_message\": \"We are performing a major upgrade. Back in 30 minutes!\"}', '2026-09-01 20:40:15', '2026-09-01 20:40:15'),
(126, 1, 'admin', 'subcategory.create', 'Created subcategory \'Smack Down\' (ID: 4) under Category ID 2', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'Desktop', 'Chrome', 'macOS', '{\"name\": \"Smack Down\", \"status\": \"active\", \"priority\": 1, \"category_id\": 2}', NULL, '{\"id\": 4, \"name\": \"Smack Down\", \"slug\": \"smack-down-UZTT\", \"status\": \"active\", \"priority\": 1, \"created_at\": \"2026-09-02T08:34:40.000000Z\", \"updated_at\": \"2026-09-02T08:34:40.000000Z\", \"category_id\": 2}', '2026-09-02 07:34:40', '2026-09-02 07:34:40');
INSERT INTO `audit_logs` (`id`, `user_id`, `user_type`, `action`, `description`, `ip_address`, `user_agent`, `device`, `browser`, `platform`, `payload`, `old_values`, `new_values`, `created_at`, `updated_at`) VALUES
(127, 1, 'admin', 'subcategory.update', 'Updated subcategory \'Digital Illustrations\' (ID: 2)', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'Desktop', 'Chrome', 'macOS', '{\"name\": \"Digital Illustrations\", \"status\": \"active\", \"priority\": 1, \"category_id\": 2}', '{\"id\": 2, \"name\": \"Digital Illustrations\", \"slug\": \"digital-illustrations-pObm\", \"status\": \"inactive\", \"priority\": 1, \"created_at\": \"2026-08-25T15:25:13.000000Z\", \"updated_at\": \"2026-08-30T12:44:45.000000Z\", \"category_id\": 2}', '{\"id\": 2, \"name\": \"Digital Illustrations\", \"slug\": \"digital-illustrations-pObm\", \"status\": \"active\", \"priority\": 1, \"created_at\": \"2026-08-25T15:25:13.000000Z\", \"updated_at\": \"2026-09-02T08:34:48.000000Z\", \"category_id\": 2}', '2026-09-02 07:34:48', '2026-09-02 07:34:48'),
(128, 1, 'admin', 'category.update', 'Updated category \'Home Gadgets\' (ID: 2)', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'Desktop', 'Chrome', 'macOS', '{\"name\": \"Home Gadgets\", \"status\": \"inactive\", \"_method\": \"POST\", \"priority\": \"1\"}', '{\"id\": 2, \"icon\": \"categoriesicons/2026/08/6566f4e4-21ef-4b62-950b-c6ab8ce349f4_1787667567.webp\", \"name\": \"Home Gadgets\", \"slug\": \"home-gadgets\", \"banner\": \"categoriesbanners/2026/08/d9c19614-e583-4f80-98d5-58dab5f09c02_1787667567.webp\", \"status\": \"active\", \"priority\": 1, \"created_at\": \"2026-08-25T14:19:27.000000Z\", \"updated_at\": \"2026-08-30T12:29:55.000000Z\"}', '{\"id\": 2, \"icon\": \"categoriesicons/2026/08/6566f4e4-21ef-4b62-950b-c6ab8ce349f4_1787667567.webp\", \"name\": \"Home Gadgets\", \"slug\": \"home-gadgets\", \"banner\": \"categoriesbanners/2026/08/d9c19614-e583-4f80-98d5-58dab5f09c02_1787667567.webp\", \"status\": \"inactive\", \"priority\": 1, \"created_at\": \"2026-08-25T14:19:27.000000Z\", \"updated_at\": \"2026-09-02T08:34:57.000000Z\"}', '2026-09-02 07:34:57', '2026-09-02 07:34:57'),
(129, 1, 'admin', 'category.update', 'Updated category \'Home Gadgets\' (ID: 2)', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'Desktop', 'Chrome', 'macOS', '{\"name\": \"Home Gadgets\", \"status\": \"active\", \"_method\": \"POST\", \"priority\": \"1\"}', '{\"id\": 2, \"icon\": \"categoriesicons/2026/08/6566f4e4-21ef-4b62-950b-c6ab8ce349f4_1787667567.webp\", \"name\": \"Home Gadgets\", \"slug\": \"home-gadgets\", \"banner\": \"categoriesbanners/2026/08/d9c19614-e583-4f80-98d5-58dab5f09c02_1787667567.webp\", \"status\": \"inactive\", \"priority\": 1, \"created_at\": \"2026-08-25T14:19:27.000000Z\", \"updated_at\": \"2026-09-02T08:34:57.000000Z\"}', '{\"id\": 2, \"icon\": \"categoriesicons/2026/08/6566f4e4-21ef-4b62-950b-c6ab8ce349f4_1787667567.webp\", \"name\": \"Home Gadgets\", \"slug\": \"home-gadgets\", \"banner\": \"categoriesbanners/2026/08/d9c19614-e583-4f80-98d5-58dab5f09c02_1787667567.webp\", \"status\": \"active\", \"priority\": 1, \"created_at\": \"2026-08-25T14:19:27.000000Z\", \"updated_at\": \"2026-09-02T08:35:04.000000Z\"}', '2026-09-02 07:35:04', '2026-09-02 07:35:04'),
(130, 1, 'admin', 'product.create', 'Created product \'Wireless Noise-Canceling Headphones\' (ID: 10)', '127.0.0.1', 'PostmanRuntime/2.4.3', 'Desktop', 'Unknown', 'Unknown', '{\"sku\": \"HP-ANC-0013267\", \"name\": \"Wireless Noise-Canceling Headphones\", \"colors\": [\"2\"], \"brand_id\": \"1\", \"discount\": \"10\", \"seller_id\": \"2\", \"attributes\": {\"2\": [\"3\"]}, \"meta_image\": {}, \"unit_price\": \"199.99\", \"category_id\": \"2\", \"description\": \"Experience studio-grade sound with ultra-comfortable ear cushions and up to 30 hours of battery life.\", \"product_type\": \"physical\", \"current_stock\": \"50\", \"discount_type\": \"percent\", \"gallery_images\": [{}, {}, {}, {}, {}], \"purchase_price\": \"120.00\", \"sub_category_id\": \"1\", \"short_description\": \"High-fidelity audio with active noise cancellation.\"}', NULL, '{\"id\": 10, \"sku\": \"HP-ANC-0013267\", \"tax\": 0, \"name\": \"Wireless Noise-Canceling Headphones\", \"slug\": \"wireless-noise-canceling-headphones-rns8i\", \"tags\": [], \"unit\": null, \"images\": [\"products/gallery/2026/09/24c9582f-f167-4553-bc72-610f1d568061_1788453894.webp\", \"products/gallery/2026/09/58d7c0e2-0bec-4a63-87c6-843f084f225c_1788453894.webp\", \"products/gallery/2026/09/c1c1d1dd-874c-45d9-be0c-6c0a259943af_1788453894.webp\", \"products/gallery/2026/09/c0b6280b-d53d-431c-84f0-10181387b6d4_1788453894.webp\", \"products/gallery/2026/09/25ad4d2a-5b85-4bfc-9113-821cf216bf60_1788453894.webp\"], \"status\": \"approved\", \"brand_id\": \"1\", \"discount\": 10, \"tax_type\": \"flat\", \"published\": true, \"seller_id\": \"2\", \"thumbnail\": \"products/thumbnails/2026/09/fcd37b8d-2944-4300-99b7-72b65b46fbd4_1788453894.webp\", \"created_at\": \"2026-09-03T16:44:54.000000Z\", \"meta_image\": \"products/meta/2026/09/bbbec0a1-a136-4619-8d73-c0370bb783e4_1788453894.webp\", \"meta_title\": null, \"unit_price\": 199.99, \"updated_at\": \"2026-09-03T16:44:54.000000Z\", \"category_id\": \"2\", \"description\": \"Experience studio-grade sound with ultra-comfortable ear cushions and up to 30 hours of battery life.\", \"is_featured\": false, \"digital_file\": null, \"multiply_qty\": false, \"product_type\": \"physical\", \"stock_status\": \"in_stock\", \"current_stock\": \"50\", \"denied_reason\": null, \"discount_type\": \"percent\", \"shipping_cost\": 0, \"is_todays_deal\": false, \"purchase_price\": 120, \"sub_category_id\": \"1\", \"meta_description\": null, \"digital_file_type\": null, \"minimum_order_qty\": 1, \"short_description\": \"High-fidelity audio with active noise cancellation.\", \"low_stock_threshold\": 5}', '2026-09-03 15:44:54', '2026-09-03 15:44:54'),
(131, 1, 'admin', 'product.create', 'Created product \'Premium Valor\' (ID: 11)', '127.0.0.1', 'PostmanRuntime/2.4.3', 'Desktop', 'Unknown', 'Unknown', '{\"sku\": \"HP-ANC-00132673\", \"name\": \"Premium Valor\", \"colors\": [\"2\"], \"brand_id\": \"1\", \"discount\": \"10\", \"seller_id\": \"2\", \"attributes\": {\"2\": [\"3\"]}, \"meta_image\": {}, \"unit_price\": \"199.99\", \"category_id\": \"2\", \"description\": \"Experience studio-grade sound with ultra-comfortable ear cushions and up to 30 hours of battery life.\", \"product_type\": \"physical\", \"current_stock\": \"50\", \"discount_type\": \"percent\", \"gallery_images\": [{}, {}, {}, {}, {}], \"purchase_price\": \"120.00\", \"sub_category_id\": \"1\", \"short_description\": \"High-fidelity audio with active noise cancellation.\"}', NULL, '{\"id\": 11, \"sku\": \"HP-ANC-00132673\", \"tax\": 0, \"name\": \"Premium Valor\", \"slug\": \"premium-valor-lBaSP\", \"tags\": [], \"unit\": null, \"images\": [\"products/gallery/2026/09/0d94221d-5bb7-4711-b398-dbba301b24cb_1788454241.webp\", \"products/gallery/2026/09/a583ab7a-ca85-4ee9-9e98-3cddab8ce529_1788454241.webp\", \"products/gallery/2026/09/e6d59e57-20cb-405d-b210-4f770049f8ab_1788454241.webp\", \"products/gallery/2026/09/d0c3a051-a1a7-4f0e-9ca9-42647504cc68_1788454241.webp\", \"products/gallery/2026/09/473bad28-2514-406f-8a08-7a5f54142981_1788454241.webp\"], \"status\": \"approved\", \"brand_id\": \"1\", \"discount\": 10, \"tax_type\": \"flat\", \"published\": true, \"seller_id\": \"2\", \"thumbnail\": \"products/thumbnails/2026/09/d7395e12-0121-43cc-99fb-7964af8b51ac_1788454241.webp\", \"created_at\": \"2026-09-03T16:50:41.000000Z\", \"meta_image\": \"products/meta/2026/09/bcf11a0c-e430-4e16-b8fd-f8361502c30c_1788454241.webp\", \"meta_title\": null, \"unit_price\": 199.99, \"updated_at\": \"2026-09-03T16:50:41.000000Z\", \"category_id\": \"2\", \"description\": \"Experience studio-grade sound with ultra-comfortable ear cushions and up to 30 hours of battery life.\", \"is_featured\": false, \"digital_file\": null, \"multiply_qty\": false, \"product_type\": \"physical\", \"stock_status\": \"in_stock\", \"current_stock\": \"50\", \"denied_reason\": null, \"discount_type\": \"percent\", \"shipping_cost\": 0, \"is_todays_deal\": false, \"purchase_price\": 120, \"sub_category_id\": \"1\", \"meta_description\": null, \"digital_file_type\": null, \"minimum_order_qty\": 1, \"short_description\": \"High-fidelity audio with active noise cancellation.\", \"low_stock_threshold\": 5}', '2026-09-03 15:50:41', '2026-09-03 15:50:41'),
(132, 1, 'admin', 'category.update', 'Updated category \'Art & Paintings\' (ID: 1)', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'Desktop', 'Chrome', 'macOS', '{\"icon\": {}, \"name\": \"Art & Paintings\", \"status\": \"active\", \"_method\": \"POST\", \"priority\": \"1\"}', '{\"id\": 1, \"icon\": null, \"name\": \"Art & Paintings\", \"slug\": \"art-and-paintings\", \"banner\": null, \"status\": \"active\", \"priority\": 1, \"created_at\": \"2026-09-03T17:26:15.000000Z\", \"updated_at\": \"2026-09-04T09:18:44.000000Z\"}', '{\"id\": 1, \"icon\": \"categories/icons/2026/09/ad43e3b5-2269-4ce5-ae92-207dae4a23cc_1788510513.webp\", \"name\": \"Art & Paintings\", \"slug\": \"art-and-paintings\", \"banner\": null, \"status\": \"active\", \"priority\": 1, \"created_at\": \"2026-09-03T17:26:15.000000Z\", \"updated_at\": \"2026-09-04T08:28:33.000000Z\"}', '2026-09-04 07:28:33', '2026-09-04 07:28:33'),
(133, 1, 'admin', 'category.update', 'Updated category \'Sculptures & 3D Art\' (ID: 2)', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'Desktop', 'Chrome', 'macOS', '{\"icon\": {}, \"name\": \"Sculptures & 3D Art\", \"status\": \"active\", \"_method\": \"POST\", \"priority\": \"2\"}', '{\"id\": 2, \"icon\": null, \"name\": \"Sculptures & 3D Art\", \"slug\": \"sculptures-and-3d-art\", \"banner\": null, \"status\": \"active\", \"priority\": 2, \"created_at\": \"2026-09-03T17:26:15.000000Z\", \"updated_at\": \"2026-09-04T09:18:51.000000Z\"}', '{\"id\": 2, \"icon\": \"categories/icons/2026/09/515cee6b-25f9-489a-ad7d-c9f16999069a_1788510560.webp\", \"name\": \"Sculptures & 3D Art\", \"slug\": \"sculptures-and-3d-art\", \"banner\": null, \"status\": \"active\", \"priority\": 2, \"created_at\": \"2026-09-03T17:26:15.000000Z\", \"updated_at\": \"2026-09-04T08:29:20.000000Z\"}', '2026-09-04 07:29:20', '2026-09-04 07:29:20'),
(134, 1, 'admin', 'category.update', 'Updated category \'Sculptures & 3D Art\' (ID: 2)', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'Desktop', 'Chrome', 'macOS', '{\"icon\": {}, \"name\": \"Sculptures & 3D Art\", \"status\": \"active\", \"_method\": \"POST\", \"priority\": \"2\"}', '{\"id\": 2, \"icon\": \"categories/icons/2026/09/515cee6b-25f9-489a-ad7d-c9f16999069a_1788510560.webp\", \"name\": \"Sculptures & 3D Art\", \"slug\": \"sculptures-and-3d-art\", \"banner\": null, \"status\": \"active\", \"priority\": 2, \"created_at\": \"2026-09-03T17:26:15.000000Z\", \"updated_at\": \"2026-09-04T08:29:20.000000Z\"}', '{\"id\": 2, \"icon\": \"categories/icons/2026/09/707c35a2-df00-4d56-a316-042d8c4faf84_1788510595.webp\", \"name\": \"Sculptures & 3D Art\", \"slug\": \"sculptures-and-3d-art\", \"banner\": null, \"status\": \"active\", \"priority\": 2, \"created_at\": \"2026-09-03T17:26:15.000000Z\", \"updated_at\": \"2026-09-04T08:29:55.000000Z\"}', '2026-09-04 07:29:55', '2026-09-04 07:29:55'),
(135, 1, 'admin', 'category.update', 'Updated category \'Home Décor & Interior\' (ID: 3)', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'Desktop', 'Chrome', 'macOS', '{\"icon\": {}, \"name\": \"Home Décor & Interior\", \"status\": \"active\", \"_method\": \"POST\", \"priority\": \"3\"}', '{\"id\": 3, \"icon\": null, \"name\": \"Home Décor & Interior\", \"slug\": \"home-decor-and-interior\", \"banner\": null, \"status\": \"active\", \"priority\": 3, \"created_at\": \"2026-09-03T17:26:15.000000Z\", \"updated_at\": \"2026-09-04T09:18:55.000000Z\"}', '{\"id\": 3, \"icon\": \"categories/icons/2026/09/e08d04f0-3371-4d9d-b30d-3a9f81e93abf_1788510627.webp\", \"name\": \"Home Décor & Interior\", \"slug\": \"home-decor-and-interior\", \"banner\": null, \"status\": \"active\", \"priority\": 3, \"created_at\": \"2026-09-03T17:26:15.000000Z\", \"updated_at\": \"2026-09-04T08:30:27.000000Z\"}', '2026-09-04 07:30:27', '2026-09-04 07:30:27'),
(136, 1, 'admin', 'category.update', 'Updated category \'Furniture & Woodcraft\' (ID: 4)', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'Desktop', 'Chrome', 'macOS', '{\"icon\": {}, \"name\": \"Furniture & Woodcraft\", \"status\": \"active\", \"_method\": \"POST\", \"priority\": \"4\"}', '{\"id\": 4, \"icon\": null, \"name\": \"Furniture & Woodcraft\", \"slug\": \"furniture-and-woodcraft\", \"banner\": null, \"status\": \"active\", \"priority\": 4, \"created_at\": \"2026-09-03T17:26:15.000000Z\", \"updated_at\": \"2026-09-04T09:18:58.000000Z\"}', '{\"id\": 4, \"icon\": \"categories/icons/2026/09/9d94288a-2f63-4d90-9343-9b640bc2590c_1788510661.webp\", \"name\": \"Furniture & Woodcraft\", \"slug\": \"furniture-and-woodcraft\", \"banner\": null, \"status\": \"active\", \"priority\": 4, \"created_at\": \"2026-09-03T17:26:15.000000Z\", \"updated_at\": \"2026-09-04T08:31:01.000000Z\"}', '2026-09-04 07:31:01', '2026-09-04 07:31:01'),
(137, 1, 'admin', 'category.update', 'Updated category \'Fashion & Textiles\' (ID: 5)', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'Desktop', 'Chrome', 'macOS', '{\"icon\": {}, \"name\": \"Fashion & Textiles\", \"status\": \"active\", \"_method\": \"POST\", \"priority\": \"5\"}', '{\"id\": 5, \"icon\": null, \"name\": \"Fashion & Textiles\", \"slug\": \"fashion-and-textiles\", \"banner\": null, \"status\": \"active\", \"priority\": 5, \"created_at\": \"2026-09-03T17:26:15.000000Z\", \"updated_at\": \"2026-09-04T09:19:02.000000Z\"}', '{\"id\": 5, \"icon\": \"categories/icons/2026/09/23305ab1-488b-4280-b491-31c28cb30b04_1788510695.webp\", \"name\": \"Fashion & Textiles\", \"slug\": \"fashion-and-textiles\", \"banner\": null, \"status\": \"active\", \"priority\": 5, \"created_at\": \"2026-09-03T17:26:15.000000Z\", \"updated_at\": \"2026-09-04T08:31:35.000000Z\"}', '2026-09-04 07:31:35', '2026-09-04 07:31:35'),
(138, 1, 'admin', 'category.update', 'Updated category \'Jewellery & Accessories\' (ID: 6)', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'Desktop', 'Chrome', 'macOS', '{\"icon\": {}, \"name\": \"Jewellery & Accessories\", \"status\": \"active\", \"_method\": \"POST\", \"priority\": \"6\"}', '{\"id\": 6, \"icon\": null, \"name\": \"Jewellery & Accessories\", \"slug\": \"jewellery-and-accessories\", \"banner\": null, \"status\": \"active\", \"priority\": 6, \"created_at\": \"2026-09-03T17:26:15.000000Z\", \"updated_at\": \"2026-09-04T09:19:05.000000Z\"}', '{\"id\": 6, \"icon\": \"categories/icons/2026/09/03e3515d-a1c4-49eb-bee7-24dfffcc7147_1788510729.webp\", \"name\": \"Jewellery & Accessories\", \"slug\": \"jewellery-and-accessories\", \"banner\": null, \"status\": \"active\", \"priority\": 6, \"created_at\": \"2026-09-03T17:26:15.000000Z\", \"updated_at\": \"2026-09-04T08:32:09.000000Z\"}', '2026-09-04 07:32:09', '2026-09-04 07:32:09'),
(139, 1, 'admin', 'category.update', 'Updated category \'Bags, Shoes & Leather\' (ID: 7)', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'Desktop', 'Chrome', 'macOS', '{\"icon\": {}, \"name\": \"Bags, Shoes & Leather\", \"status\": \"active\", \"_method\": \"POST\", \"priority\": \"7\"}', '{\"id\": 7, \"icon\": null, \"name\": \"Bags, Shoes & Leather\", \"slug\": \"bags-shoes-and-leather\", \"banner\": null, \"status\": \"active\", \"priority\": 7, \"created_at\": \"2026-09-03T17:26:15.000000Z\", \"updated_at\": \"2026-09-04T09:19:08.000000Z\"}', '{\"id\": 7, \"icon\": \"categories/icons/2026/09/5a6d9415-b2f8-4075-bd47-558665472300_1788510763.webp\", \"name\": \"Bags, Shoes & Leather\", \"slug\": \"bags-shoes-and-leather\", \"banner\": null, \"status\": \"active\", \"priority\": 7, \"created_at\": \"2026-09-03T17:26:15.000000Z\", \"updated_at\": \"2026-09-04T08:32:43.000000Z\"}', '2026-09-04 07:32:43', '2026-09-04 07:32:43'),
(140, 1, 'admin', 'category.update', 'Updated category \'Pottery, Ceramics & Glass\' (ID: 8)', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'Desktop', 'Chrome', 'macOS', '{\"icon\": {}, \"name\": \"Pottery, Ceramics & Glass\", \"status\": \"active\", \"_method\": \"POST\", \"priority\": \"8\"}', '{\"id\": 8, \"icon\": null, \"name\": \"Pottery, Ceramics & Glass\", \"slug\": \"pottery-ceramics-and-glass\", \"banner\": null, \"status\": \"active\", \"priority\": 8, \"created_at\": \"2026-09-03T17:26:15.000000Z\", \"updated_at\": \"2026-09-04T09:18:47.000000Z\"}', '{\"id\": 8, \"icon\": \"categories/icons/2026/09/6b4a5c94-422b-4130-978c-d3f8558470d9_1788510786.webp\", \"name\": \"Pottery, Ceramics & Glass\", \"slug\": \"pottery-ceramics-and-glass\", \"banner\": null, \"status\": \"active\", \"priority\": 8, \"created_at\": \"2026-09-03T17:26:15.000000Z\", \"updated_at\": \"2026-09-04T08:33:06.000000Z\"}', '2026-09-04 07:33:06', '2026-09-04 07:33:06'),
(141, 1, 'admin', 'category.update', 'Updated category \'Baskets, Fibre & Natural Crafts\' (ID: 9)', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'Desktop', 'Chrome', 'macOS', '{\"icon\": {}, \"name\": \"Baskets, Fibre & Natural Crafts\", \"status\": \"active\", \"_method\": \"POST\", \"priority\": \"9\"}', '{\"id\": 9, \"icon\": null, \"name\": \"Baskets, Fibre & Natural Crafts\", \"slug\": \"baskets-fibre-and-natural-crafts\", \"banner\": null, \"status\": \"active\", \"priority\": 9, \"created_at\": \"2026-09-03T17:26:15.000000Z\", \"updated_at\": \"2026-09-04T09:19:15.000000Z\"}', '{\"id\": 9, \"icon\": \"categories/icons/2026/09/17bcc9cf-e109-4634-a63d-6330ba53f731_1788510815.webp\", \"name\": \"Baskets, Fibre & Natural Crafts\", \"slug\": \"baskets-fibre-and-natural-crafts\", \"banner\": null, \"status\": \"active\", \"priority\": 9, \"created_at\": \"2026-09-03T17:26:15.000000Z\", \"updated_at\": \"2026-09-04T08:33:35.000000Z\"}', '2026-09-04 07:33:35', '2026-09-04 07:33:35'),
(142, 1, 'admin', 'category.update', 'Updated category \'Gifts, Souvenirs & Events\' (ID: 10)', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'Desktop', 'Chrome', 'macOS', '{\"icon\": {}, \"name\": \"Gifts, Souvenirs & Events\", \"status\": \"active\", \"_method\": \"POST\", \"priority\": \"10\"}', '{\"id\": 10, \"icon\": null, \"name\": \"Gifts, Souvenirs & Events\", \"slug\": \"gifts-souvenirs-and-events\", \"banner\": null, \"status\": \"active\", \"priority\": 10, \"created_at\": \"2026-09-03T17:26:15.000000Z\", \"updated_at\": \"2026-09-04T09:19:18.000000Z\"}', '{\"id\": 10, \"icon\": \"categories/icons/2026/09/b5b5763b-8618-4e2e-81bc-25c8d457ecf4_1788510973.webp\", \"name\": \"Gifts, Souvenirs & Events\", \"slug\": \"gifts-souvenirs-and-events\", \"banner\": null, \"status\": \"active\", \"priority\": 10, \"created_at\": \"2026-09-03T17:26:15.000000Z\", \"updated_at\": \"2026-09-04T08:36:13.000000Z\"}', '2026-09-04 07:36:13', '2026-09-04 07:36:13'),
(143, 1, 'admin', 'category.update', 'Updated category \'Cultural, Traditional & Collectibles\' (ID: 11)', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'Desktop', 'Chrome', 'macOS', '{\"icon\": {}, \"name\": \"Cultural, Traditional & Collectibles\", \"status\": \"active\", \"_method\": \"POST\", \"priority\": \"11\"}', '{\"id\": 11, \"icon\": null, \"name\": \"Cultural, Traditional & Collectibles\", \"slug\": \"cultural-traditional-and-collectibles\", \"banner\": null, \"status\": \"active\", \"priority\": 11, \"created_at\": \"2026-09-03T17:26:15.000000Z\", \"updated_at\": \"2026-09-04T09:19:22.000000Z\"}', '{\"id\": 11, \"icon\": \"categories/icons/2026/09/fd52a6d0-eb34-4fe5-b203-4d05fe843749_1788511007.webp\", \"name\": \"Cultural, Traditional & Collectibles\", \"slug\": \"cultural-traditional-and-collectibles\", \"banner\": null, \"status\": \"active\", \"priority\": 11, \"created_at\": \"2026-09-03T17:26:15.000000Z\", \"updated_at\": \"2026-09-04T08:36:47.000000Z\"}', '2026-09-04 07:36:47', '2026-09-04 07:36:47'),
(144, 1, 'admin', 'category.update', 'Updated category \'Toys, Lifestyle & Other Crafts\' (ID: 12)', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'Desktop', 'Chrome', 'macOS', '{\"icon\": {}, \"name\": \"Toys, Lifestyle & Other Crafts\", \"status\": \"active\", \"_method\": \"POST\", \"priority\": \"12\"}', '{\"id\": 12, \"icon\": null, \"name\": \"Toys, Lifestyle & Other Crafts\", \"slug\": \"toys-lifestyle-and-other-crafts\", \"banner\": null, \"status\": \"active\", \"priority\": 12, \"created_at\": \"2026-09-03T17:26:15.000000Z\", \"updated_at\": \"2026-09-04T09:19:25.000000Z\"}', '{\"id\": 12, \"icon\": \"categories/icons/2026/09/0ec421c3-666d-4328-8d78-892b48a15cd0_1788511034.webp\", \"name\": \"Toys, Lifestyle & Other Crafts\", \"slug\": \"toys-lifestyle-and-other-crafts\", \"banner\": null, \"status\": \"active\", \"priority\": 12, \"created_at\": \"2026-09-03T17:26:15.000000Z\", \"updated_at\": \"2026-09-04T08:37:14.000000Z\"}', '2026-09-04 07:37:14', '2026-09-04 07:37:14'),
(145, 1, 'admin', 'category.update', 'Updated category \'Custom Art & Creative Services\' (ID: 13)', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'Desktop', 'Chrome', 'macOS', '{\"icon\": {}, \"name\": \"Custom Art & Creative Services\", \"status\": \"active\", \"_method\": \"POST\", \"priority\": \"13\"}', '{\"id\": 13, \"icon\": null, \"name\": \"Custom Art & Creative Services\", \"slug\": \"custom-art-and-creative-services\", \"banner\": null, \"status\": \"active\", \"priority\": 13, \"created_at\": \"2026-09-03T17:26:15.000000Z\", \"updated_at\": \"2026-09-04T09:19:28.000000Z\"}', '{\"id\": 13, \"icon\": \"categories/icons/2026/09/2a26290c-688a-438c-93fb-81b9cfbf0a6d_1788511075.webp\", \"name\": \"Custom Art & Creative Services\", \"slug\": \"custom-art-and-creative-services\", \"banner\": null, \"status\": \"active\", \"priority\": 13, \"created_at\": \"2026-09-03T17:26:15.000000Z\", \"updated_at\": \"2026-09-04T08:37:55.000000Z\"}', '2026-09-04 07:37:55', '2026-09-04 07:37:55'),
(146, 1, 'admin', 'category.update', 'Updated category \'Music\' (ID: 14)', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'Desktop', 'Chrome', 'macOS', '{\"icon\": {}, \"name\": \"Music\", \"status\": \"active\", \"_method\": \"POST\", \"priority\": \"14\"}', '{\"id\": 14, \"icon\": null, \"name\": \"Music\", \"slug\": \"music\", \"banner\": null, \"status\": \"active\", \"priority\": 14, \"created_at\": \"2026-09-03T17:26:15.000000Z\", \"updated_at\": \"2026-09-04T09:19:34.000000Z\"}', '{\"id\": 14, \"icon\": \"categories/icons/2026/09/acd159ea-fb9f-4d74-a753-2ccbf461c8a3_1788511274.webp\", \"name\": \"Music\", \"slug\": \"music\", \"banner\": null, \"status\": \"active\", \"priority\": 14, \"created_at\": \"2026-09-03T17:26:15.000000Z\", \"updated_at\": \"2026-09-04T08:41:14.000000Z\"}', '2026-09-04 07:41:14', '2026-09-04 07:41:14'),
(147, 1, 'admin', 'category.update', 'Updated category \'Furniture & Woodcraft\' (ID: 4)', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'Desktop', 'Chrome', 'macOS', '{\"icon\": {}, \"name\": \"Furniture & Woodcraft\", \"status\": \"active\", \"_method\": \"POST\", \"priority\": \"4\"}', '{\"id\": 4, \"icon\": \"categories/icons/2026/09/9d94288a-2f63-4d90-9343-9b640bc2590c_1788510661.webp\", \"name\": \"Furniture & Woodcraft\", \"slug\": \"furniture-and-woodcraft\", \"banner\": null, \"status\": \"active\", \"priority\": 4, \"created_at\": \"2026-09-03T17:26:15.000000Z\", \"updated_at\": \"2026-09-04T08:31:01.000000Z\"}', '{\"id\": 4, \"icon\": \"categories/icons/2026/09/c8f11ec4-b572-4c93-94db-313c97d5703b_1788511308.webp\", \"name\": \"Furniture & Woodcraft\", \"slug\": \"furniture-and-woodcraft\", \"banner\": null, \"status\": \"active\", \"priority\": 4, \"created_at\": \"2026-09-03T17:26:15.000000Z\", \"updated_at\": \"2026-09-04T08:41:48.000000Z\"}', '2026-09-04 07:41:48', '2026-09-04 07:41:48'),
(148, 1, 'admin', 'product.update', 'Updated product \'Supre Model\' (ID: 11)', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'Desktop', 'Chrome', 'macOS', '{\"sku\": \"HP-ANC-00132673\", \"tax\": \"0\", \"name\": \"Supre Model\", \"unit\": \"1\", \"status\": \"approved\", \"_method\": \"POST\", \"discount\": \"10\", \"tax_type\": \"flat\", \"published\": \"1\", \"seller_id\": \"2\", \"meta_image\": {}, \"unit_price\": \"199.99\", \"category_id\": \"2\", \"description\": \"Experience studio-grade sound with ultra-comfortable ear cushions and up to 30 hours of battery life.\", \"is_featured\": \"1\", \"multiply_qty\": \"0\", \"product_type\": \"physical\", \"stock_status\": \"in_stock\", \"current_stock\": \"50\", \"discount_type\": \"percent\", \"shipping_cost\": \"0\", \"is_todays_deal\": \"1\", \"purchase_price\": \"120\", \"sub_category_id\": \"1\", \"minimum_order_qty\": \"1\", \"short_description\": \"High-fidelity audio with active noise cancellation.\", \"low_stock_threshold\": \"5\"}', '{\"id\": 11, \"sku\": \"HP-ANC-00132673\", \"tax\": 0, \"name\": \"Premium Valor\", \"slug\": \"premium-valor-lBaSP\", \"tags\": [], \"unit\": null, \"images\": [\"products/gallery/2026/09/0d94221d-5bb7-4711-b398-dbba301b24cb_1788454241.webp\", \"products/gallery/2026/09/a583ab7a-ca85-4ee9-9e98-3cddab8ce529_1788454241.webp\", \"products/gallery/2026/09/e6d59e57-20cb-405d-b210-4f770049f8ab_1788454241.webp\", \"products/gallery/2026/09/d0c3a051-a1a7-4f0e-9ca9-42647504cc68_1788454241.webp\", \"products/gallery/2026/09/473bad28-2514-406f-8a08-7a5f54142981_1788454241.webp\"], \"status\": \"approved\", \"brand_id\": null, \"discount\": 10, \"tax_type\": \"flat\", \"published\": true, \"seller_id\": 2, \"thumbnail\": \"products/thumbnails/2026/09/d7395e12-0121-43cc-99fb-7964af8b51ac_1788454241.webp\", \"created_at\": \"2026-09-03T16:50:41.000000Z\", \"deleted_at\": null, \"meta_image\": \"products/meta/2026/09/bcf11a0c-e430-4e16-b8fd-f8361502c30c_1788454241.webp\", \"meta_title\": null, \"unit_price\": 199.99, \"updated_at\": \"2026-09-03T16:50:41.000000Z\", \"variations\": [], \"category_id\": 2, \"description\": \"Experience studio-grade sound with ultra-comfortable ear cushions and up to 30 hours of battery life.\", \"is_featured\": false, \"digital_file\": null, \"multiply_qty\": false, \"product_type\": \"physical\", \"stock_status\": \"in_stock\", \"current_stock\": 50, \"denied_reason\": null, \"discount_type\": \"percent\", \"shipping_cost\": 0, \"is_todays_deal\": false, \"purchase_price\": 120, \"sub_category_id\": 1, \"meta_description\": null, \"digital_file_type\": null, \"minimum_order_qty\": 1, \"short_description\": \"High-fidelity audio with active noise cancellation.\", \"low_stock_threshold\": 5}', '{\"id\": 11, \"sku\": \"HP-ANC-00132673\", \"tax\": 0, \"name\": \"Supre Model\", \"slug\": \"supre-model-OJ3vX\", \"tags\": [], \"unit\": \"1\", \"images\": [\"products/gallery/2026/09/0d94221d-5bb7-4711-b398-dbba301b24cb_1788454241.webp\", \"products/gallery/2026/09/a583ab7a-ca85-4ee9-9e98-3cddab8ce529_1788454241.webp\", \"products/gallery/2026/09/e6d59e57-20cb-405d-b210-4f770049f8ab_1788454241.webp\", \"products/gallery/2026/09/d0c3a051-a1a7-4f0e-9ca9-42647504cc68_1788454241.webp\", \"products/gallery/2026/09/473bad28-2514-406f-8a08-7a5f54142981_1788454241.webp\"], \"status\": \"approved\", \"brand_id\": null, \"discount\": 10, \"tax_type\": \"flat\", \"published\": true, \"seller_id\": 2, \"thumbnail\": \"products/thumbnails/2026/09/035ca177-d273-4b0e-937b-1cf8b9c3344a_1788515939.webp\", \"created_at\": \"2026-09-03T16:50:41.000000Z\", \"deleted_at\": null, \"meta_image\": \"products/meta/2026/09/43e3c5b1-25cd-49a7-a5a2-ba2d303dac9e_1788515939.webp\", \"meta_title\": null, \"unit_price\": 199.99, \"updated_at\": \"2026-09-04T09:58:59.000000Z\", \"variations\": [], \"category_id\": 2, \"description\": \"Experience studio-grade sound with ultra-comfortable ear cushions and up to 30 hours of battery life.\", \"is_featured\": true, \"digital_file\": null, \"multiply_qty\": false, \"product_type\": \"physical\", \"stock_status\": \"in_stock\", \"current_stock\": 50, \"denied_reason\": null, \"discount_type\": \"percent\", \"shipping_cost\": 0, \"is_todays_deal\": true, \"purchase_price\": 120, \"sub_category_id\": 1, \"meta_description\": null, \"digital_file_type\": null, \"minimum_order_qty\": 1, \"short_description\": \"High-fidelity audio with active noise cancellation.\", \"low_stock_threshold\": 5}', '2026-09-04 08:58:59', '2026-09-04 08:58:59'),
(149, 1, 'admin', 'product.update', 'Updated product \'Wooden Model\' (ID: 10)', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'Desktop', 'Chrome', 'macOS', '{\"sku\": \"WD-DEC-0013267\", \"tax\": \"0\", \"name\": \"Wooden Model\", \"status\": \"approved\", \"_method\": \"POST\", \"discount\": \"10\", \"tax_type\": \"flat\", \"published\": \"1\", \"seller_id\": \"2\", \"unit_price\": \"199.99\", \"category_id\": \"2\", \"description\": \"Experience studio-grade sound with ultra-comfortable ear cushions and up to 30 hours of battery life.\", \"is_featured\": \"1\", \"multiply_qty\": \"0\", \"product_type\": \"physical\", \"stock_status\": \"in_stock\", \"current_stock\": \"50\", \"discount_type\": \"percent\", \"shipping_cost\": \"0\", \"is_todays_deal\": \"1\", \"purchase_price\": \"120\", \"sub_category_id\": \"1\", \"minimum_order_qty\": \"1\", \"short_description\": \"High-fidelity audio with active noise cancellation.\", \"low_stock_threshold\": \"5\"}', '{\"id\": 10, \"sku\": \"HP-ANC-0013267\", \"tax\": 0, \"name\": \"Wireless Noise-Canceling Headphones\", \"slug\": \"wireless-noise-canceling-headphones-rns8i\", \"tags\": [], \"unit\": null, \"images\": [\"products/gallery/2026/09/24c9582f-f167-4553-bc72-610f1d568061_1788453894.webp\", \"products/gallery/2026/09/58d7c0e2-0bec-4a63-87c6-843f084f225c_1788453894.webp\", \"products/gallery/2026/09/c1c1d1dd-874c-45d9-be0c-6c0a259943af_1788453894.webp\", \"products/gallery/2026/09/c0b6280b-d53d-431c-84f0-10181387b6d4_1788453894.webp\", \"products/gallery/2026/09/25ad4d2a-5b85-4bfc-9113-821cf216bf60_1788453894.webp\"], \"status\": \"approved\", \"brand_id\": null, \"discount\": 10, \"tax_type\": \"flat\", \"published\": true, \"seller_id\": 2, \"thumbnail\": \"products/thumbnails/2026/09/fcd37b8d-2944-4300-99b7-72b65b46fbd4_1788453894.webp\", \"created_at\": \"2026-09-03T16:44:54.000000Z\", \"deleted_at\": null, \"meta_image\": \"products/meta/2026/09/bbbec0a1-a136-4619-8d73-c0370bb783e4_1788453894.webp\", \"meta_title\": null, \"unit_price\": 199.99, \"updated_at\": \"2026-09-03T16:44:54.000000Z\", \"variations\": [], \"category_id\": 2, \"description\": \"Experience studio-grade sound with ultra-comfortable ear cushions and up to 30 hours of battery life.\", \"is_featured\": false, \"digital_file\": null, \"multiply_qty\": false, \"product_type\": \"physical\", \"stock_status\": \"in_stock\", \"current_stock\": 50, \"denied_reason\": null, \"discount_type\": \"percent\", \"shipping_cost\": 0, \"is_todays_deal\": false, \"purchase_price\": 120, \"sub_category_id\": 1, \"meta_description\": null, \"digital_file_type\": null, \"minimum_order_qty\": 1, \"short_description\": \"High-fidelity audio with active noise cancellation.\", \"low_stock_threshold\": 5}', '{\"id\": 10, \"sku\": \"WD-DEC-0013267\", \"tax\": 0, \"name\": \"Wooden Model\", \"slug\": \"wooden-model-ppISz\", \"tags\": [], \"unit\": null, \"images\": [\"products/gallery/2026/09/24c9582f-f167-4553-bc72-610f1d568061_1788453894.webp\", \"products/gallery/2026/09/58d7c0e2-0bec-4a63-87c6-843f084f225c_1788453894.webp\", \"products/gallery/2026/09/c1c1d1dd-874c-45d9-be0c-6c0a259943af_1788453894.webp\", \"products/gallery/2026/09/c0b6280b-d53d-431c-84f0-10181387b6d4_1788453894.webp\", \"products/gallery/2026/09/25ad4d2a-5b85-4bfc-9113-821cf216bf60_1788453894.webp\"], \"status\": \"approved\", \"brand_id\": null, \"discount\": 10, \"tax_type\": \"flat\", \"published\": true, \"seller_id\": 2, \"thumbnail\": \"products/thumbnails/2026/09/538fe8c5-eca7-4a6a-8d5b-72cca3edad15_1788516052.webp\", \"created_at\": \"2026-09-03T16:44:54.000000Z\", \"deleted_at\": null, \"meta_image\": \"products/meta/2026/09/bbbec0a1-a136-4619-8d73-c0370bb783e4_1788453894.webp\", \"meta_title\": null, \"unit_price\": 199.99, \"updated_at\": \"2026-09-04T10:00:52.000000Z\", \"variations\": [], \"category_id\": 2, \"description\": \"Experience studio-grade sound with ultra-comfortable ear cushions and up to 30 hours of battery life.\", \"is_featured\": true, \"digital_file\": null, \"multiply_qty\": false, \"product_type\": \"physical\", \"stock_status\": \"in_stock\", \"current_stock\": 50, \"denied_reason\": null, \"discount_type\": \"percent\", \"shipping_cost\": 0, \"is_todays_deal\": true, \"purchase_price\": 120, \"sub_category_id\": 1, \"meta_description\": null, \"digital_file_type\": null, \"minimum_order_qty\": 1, \"short_description\": \"High-fidelity audio with active noise cancellation.\", \"low_stock_threshold\": 5}', '2026-09-04 09:00:52', '2026-09-04 09:00:52'),
(150, 1, 'admin', 'product.create', 'Created product \'Super Harp\' (ID: 12)', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'Desktop', 'Chrome', 'macOS', '{\"sku\": \"S-3288\", \"tax\": \"1\", \"name\": \"Super Harp\", \"tags\": [\"Premium\", \"super\", \"musiv\", \"lover\"], \"unit\": \"200\", \"status\": \"approved\", \"tax_type\": \"flat\", \"published\": \"1\", \"seller_id\": \"2\", \"meta_image\": {}, \"meta_title\": \"Prime Music Only\", \"unit_price\": \"100\", \"category_id\": \"14\", \"description\": \"This is the best harp you will find in the market This is the best harp you will find in the market This is the best harp you will find in the marketThis is the best harp you will find in the market This is the best harp you will find in the market This is the best harp you will find in the marketThis is the best harp you will find in the market This is the best harp you will find in the market This is the best harp you will find in the marketThis is the best harp you will find in the market This is the best harp you will find in the market This is the best harp you will find in the marketThis is the best harp you will find in the market This is the best harp you will find in the market This is the best harp you will find in the market\", \"is_featured\": \"0\", \"multiply_qty\": \"0\", \"product_type\": \"physical\", \"stock_status\": \"in_stock\", \"current_stock\": \"10\", \"discount_type\": \"flat\", \"shipping_cost\": \"0\", \"gallery_images\": [{}, {}], \"is_todays_deal\": \"0\", \"purchase_price\": \"100\", \"minimum_order_qty\": \"1\", \"short_description\": \"This is the best harp you will find in the market\", \"low_stock_threshold\": \"5\"}', NULL, '{\"id\": 12, \"sku\": \"S-3288\", \"tax\": 1, \"name\": \"Super Harp\", \"slug\": \"super-harp-TbrQa\", \"tags\": [\"Premium\", \"super\", \"musiv\", \"lover\"], \"unit\": \"200\", \"images\": [\"products/gallery/2026/09/6d5038e0-4dd2-4556-8f12-a795b8c1fa7e_1788516213.webp\", \"products/gallery/2026/09/c2c170b1-db39-4c3e-b247-eccc1944349b_1788516213.webp\"], \"status\": \"approved\", \"brand_id\": null, \"discount\": 0, \"tax_type\": \"flat\", \"published\": true, \"seller_id\": \"2\", \"thumbnail\": \"products/thumbnails/2026/09/2c812293-e5a6-4915-bd35-3763849ec1ea_1788516213.webp\", \"created_at\": \"2026-09-04T10:03:33.000000Z\", \"meta_image\": \"products/meta/2026/09/72786463-3738-4349-bb0d-9e899ac0e927_1788516213.webp\", \"meta_title\": \"Prime Music Only\", \"unit_price\": 100, \"updated_at\": \"2026-09-04T10:03:33.000000Z\", \"category_id\": \"14\", \"description\": \"This is the best harp you will find in the market This is the best harp you will find in the market This is the best harp you will find in the marketThis is the best harp you will find in the market This is the best harp you will find in the market This is the best harp you will find in the marketThis is the best harp you will find in the market This is the best harp you will find in the market This is the best harp you will find in the marketThis is the best harp you will find in the market This is the best harp you will find in the market This is the best harp you will find in the marketThis is the best harp you will find in the market This is the best harp you will find in the market This is the best harp you will find in the market\", \"is_featured\": false, \"digital_file\": null, \"multiply_qty\": false, \"product_type\": \"physical\", \"stock_status\": \"in_stock\", \"current_stock\": \"10\", \"denied_reason\": null, \"discount_type\": \"flat\", \"shipping_cost\": 0, \"is_todays_deal\": false, \"purchase_price\": 100, \"sub_category_id\": null, \"meta_description\": null, \"digital_file_type\": null, \"minimum_order_qty\": \"1\", \"short_description\": \"This is the best harp you will find in the market\", \"low_stock_threshold\": \"5\"}', '2026-09-04 09:03:33', '2026-09-04 09:03:33'),
(151, 1, 'admin', 'product.create', 'Created product \'Versace Pendant\' (ID: 13)', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'Desktop', 'Chrome', 'macOS', '{\"sku\": \"H-3266\", \"name\": \"Versace Pendant\", \"unit\": \"1\", \"status\": \"approved\", \"tax_type\": \"flat\", \"published\": \"1\", \"seller_id\": \"2\", \"unit_price\": \"200\", \"category_id\": \"6\", \"description\": \"This is the best in town This is the best in town This is the best in townThis is the best in town This is the best in town This is the best in townThis is the best in town This is the best in town This is the best in townThis is the best in town This is the best in town This is the best in townThis is the best in town This is the best in town This is the best in townThis is the best in town This is the best in town This is the best in town\", \"is_featured\": \"0\", \"multiply_qty\": \"0\", \"product_type\": \"physical\", \"stock_status\": \"in_stock\", \"current_stock\": \"10\", \"discount_type\": \"flat\", \"shipping_cost\": \"0\", \"is_todays_deal\": \"0\", \"purchase_price\": \"200\", \"minimum_order_qty\": \"1\", \"short_description\": \"This is the best in town\", \"low_stock_threshold\": \"5\"}', NULL, '{\"id\": 13, \"sku\": \"H-3266\", \"tax\": 0, \"name\": \"Versace Pendant\", \"slug\": \"versace-pendant-VbgMt\", \"tags\": [], \"unit\": \"1\", \"images\": [], \"status\": \"approved\", \"brand_id\": null, \"discount\": 0, \"tax_type\": \"flat\", \"published\": true, \"seller_id\": \"2\", \"thumbnail\": \"products/thumbnails/2026/09/b3c01dbc-087c-4cec-ae9e-64019c3c5a6a_1788516352.webp\", \"created_at\": \"2026-09-04T10:05:52.000000Z\", \"meta_image\": null, \"meta_title\": null, \"unit_price\": 200, \"updated_at\": \"2026-09-04T10:05:52.000000Z\", \"category_id\": \"6\", \"description\": \"This is the best in town This is the best in town This is the best in townThis is the best in town This is the best in town This is the best in townThis is the best in town This is the best in town This is the best in townThis is the best in town This is the best in town This is the best in townThis is the best in town This is the best in town This is the best in townThis is the best in town This is the best in town This is the best in town\", \"is_featured\": false, \"digital_file\": null, \"multiply_qty\": false, \"product_type\": \"physical\", \"stock_status\": \"in_stock\", \"current_stock\": \"10\", \"denied_reason\": null, \"discount_type\": \"flat\", \"shipping_cost\": 0, \"is_todays_deal\": false, \"purchase_price\": 200, \"sub_category_id\": null, \"meta_description\": null, \"digital_file_type\": null, \"minimum_order_qty\": \"1\", \"short_description\": \"This is the best in town\", \"low_stock_threshold\": \"5\"}', '2026-09-04 09:05:52', '2026-09-04 09:05:52'),
(152, 1, 'admin', 'product.create', 'Created product \'Full Moon\' (ID: 14)', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'Desktop', 'Chrome', 'macOS', '{\"sku\": \"F-6174\", \"name\": \"Full Moon\", \"tags\": [\"moon\", \"decor\", \"vibes\", \"ruper\"], \"unit\": \"1\", \"status\": \"approved\", \"tax_type\": \"flat\", \"published\": \"1\", \"seller_id\": \"2\", \"meta_image\": {}, \"meta_title\": \"Vibes of the best\", \"unit_price\": \"1000\", \"category_id\": \"3\", \"description\": \"This is the full moon over you This is the full moon over you This is the full moon over youThis is the full moon over you This is the full moon over you This is the full moon over youThis is the full moon over you This is the full moon over you This is the full moon over youThis is the full moon over you This is the full moon over you This is the full moon over youThis is the full moon over you This is the full moon over you This is the full moon over you\", \"is_featured\": \"0\", \"multiply_qty\": \"0\", \"product_type\": \"physical\", \"stock_status\": \"in_stock\", \"current_stock\": \"10\", \"discount_type\": \"flat\", \"shipping_cost\": \"0\", \"is_todays_deal\": \"1\", \"purchase_price\": \"1000\", \"minimum_order_qty\": \"1\", \"short_description\": \"This is the full moon over you\", \"low_stock_threshold\": \"5\"}', NULL, '{\"id\": 14, \"sku\": \"F-6174\", \"tax\": 0, \"name\": \"Full Moon\", \"slug\": \"full-moon-jXb3R\", \"tags\": [\"moon\", \"decor\", \"vibes\", \"ruper\"], \"unit\": \"1\", \"images\": [], \"status\": \"approved\", \"brand_id\": null, \"discount\": 0, \"tax_type\": \"flat\", \"published\": true, \"seller_id\": \"2\", \"thumbnail\": \"products/thumbnails/2026/09/2a5ee47d-3d23-45c8-8018-9b2f07ae2c95_1788516439.webp\", \"created_at\": \"2026-09-04T10:07:19.000000Z\", \"meta_image\": \"products/meta/2026/09/43741069-0e9f-4820-8d42-fe57c9c71c1d_1788516439.webp\", \"meta_title\": \"Vibes of the best\", \"unit_price\": 1000, \"updated_at\": \"2026-09-04T10:07:19.000000Z\", \"category_id\": \"3\", \"description\": \"This is the full moon over you This is the full moon over you This is the full moon over youThis is the full moon over you This is the full moon over you This is the full moon over youThis is the full moon over you This is the full moon over you This is the full moon over youThis is the full moon over you This is the full moon over you This is the full moon over youThis is the full moon over you This is the full moon over you This is the full moon over you\", \"is_featured\": false, \"digital_file\": null, \"multiply_qty\": false, \"product_type\": \"physical\", \"stock_status\": \"in_stock\", \"current_stock\": \"10\", \"denied_reason\": null, \"discount_type\": \"flat\", \"shipping_cost\": 0, \"is_todays_deal\": true, \"purchase_price\": 1000, \"sub_category_id\": null, \"meta_description\": null, \"digital_file_type\": null, \"minimum_order_qty\": \"1\", \"short_description\": \"This is the full moon over you\", \"low_stock_threshold\": \"5\"}', '2026-09-04 09:07:19', '2026-09-04 09:07:19'),
(153, 1, 'admin', 'product.create', 'Created product \'Magic Labooboo\' (ID: 15)', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'Desktop', 'Chrome', 'macOS', '{\"sku\": \"M-9692\", \"name\": \"Magic Labooboo\", \"unit\": \"2\", \"status\": \"approved\", \"tax_type\": \"flat\", \"published\": \"1\", \"seller_id\": \"2\", \"unit_price\": \"122\", \"category_id\": \"12\", \"description\": \"Best\", \"is_featured\": \"0\", \"multiply_qty\": \"0\", \"product_type\": \"physical\", \"stock_status\": \"in_stock\", \"current_stock\": \"10\", \"discount_type\": \"flat\", \"shipping_cost\": \"0\", \"is_todays_deal\": \"0\", \"purchase_price\": \"122\", \"minimum_order_qty\": \"1\", \"short_description\": \"Best\", \"low_stock_threshold\": \"5\"}', NULL, '{\"id\": 15, \"sku\": \"M-9692\", \"tax\": 0, \"name\": \"Magic Labooboo\", \"slug\": \"magic-labooboo-EOYvL\", \"tags\": [], \"unit\": \"2\", \"images\": [], \"status\": \"approved\", \"brand_id\": null, \"discount\": 0, \"tax_type\": \"flat\", \"published\": true, \"seller_id\": \"2\", \"thumbnail\": \"products/thumbnails/2026/09/00df2f97-3331-4ce5-b25a-0dfa565c55a6_1788516764.webp\", \"created_at\": \"2026-09-04T10:12:45.000000Z\", \"meta_image\": null, \"meta_title\": null, \"unit_price\": 122, \"updated_at\": \"2026-09-04T10:12:45.000000Z\", \"category_id\": \"12\", \"description\": \"Best\", \"is_featured\": false, \"digital_file\": null, \"multiply_qty\": false, \"product_type\": \"physical\", \"stock_status\": \"in_stock\", \"current_stock\": \"10\", \"denied_reason\": null, \"discount_type\": \"flat\", \"shipping_cost\": 0, \"is_todays_deal\": false, \"purchase_price\": 122, \"sub_category_id\": null, \"meta_description\": null, \"digital_file_type\": null, \"minimum_order_qty\": \"1\", \"short_description\": \"Best\", \"low_stock_threshold\": \"5\"}', '2026-09-04 09:12:45', '2026-09-04 09:12:45'),
(154, 1, 'admin', 'product.create', 'Created product \'Super Leather Gem\' (ID: 16)', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'Desktop', 'Chrome', 'macOS', '{\"sku\": \"S-8490\", \"name\": \"Super Leather Gem\", \"tags\": [\"leather\"], \"unit\": \"pc\", \"status\": \"approved\", \"tax_type\": \"flat\", \"published\": \"1\", \"seller_id\": \"2\", \"unit_price\": \"2000\", \"category_id\": \"7\", \"description\": \"Super\", \"is_featured\": \"0\", \"multiply_qty\": \"0\", \"product_type\": \"physical\", \"stock_status\": \"in_stock\", \"current_stock\": \"10\", \"discount_type\": \"flat\", \"shipping_cost\": \"0\", \"is_todays_deal\": \"1\", \"purchase_price\": \"2000\", \"minimum_order_qty\": \"1\", \"short_description\": \"Super\", \"low_stock_threshold\": \"5\"}', NULL, '{\"id\": 16, \"sku\": \"S-8490\", \"tax\": 0, \"name\": \"Super Leather Gem\", \"slug\": \"super-leather-gem-0Hla5\", \"tags\": [\"leather\"], \"unit\": \"pc\", \"images\": [], \"status\": \"approved\", \"brand_id\": null, \"discount\": 0, \"tax_type\": \"flat\", \"published\": true, \"seller_id\": \"2\", \"thumbnail\": \"products/thumbnails/2026/09/9b7e9380-f3e2-4bff-8a69-bae2303af69f_1788516901.webp\", \"created_at\": \"2026-09-04T10:15:01.000000Z\", \"meta_image\": null, \"meta_title\": null, \"unit_price\": 2000, \"updated_at\": \"2026-09-04T10:15:01.000000Z\", \"category_id\": \"7\", \"description\": \"Super\", \"is_featured\": false, \"digital_file\": null, \"multiply_qty\": false, \"product_type\": \"physical\", \"stock_status\": \"in_stock\", \"current_stock\": \"10\", \"denied_reason\": null, \"discount_type\": \"flat\", \"shipping_cost\": 0, \"is_todays_deal\": true, \"purchase_price\": 2000, \"sub_category_id\": null, \"meta_description\": null, \"digital_file_type\": null, \"minimum_order_qty\": \"1\", \"short_description\": \"Super\", \"low_stock_threshold\": \"5\"}', '2026-09-04 09:15:01', '2026-09-04 09:15:01');
INSERT INTO `audit_logs` (`id`, `user_id`, `user_type`, `action`, `description`, `ip_address`, `user_agent`, `device`, `browser`, `platform`, `payload`, `old_values`, `new_values`, `created_at`, `updated_at`) VALUES
(155, 1, 'admin', 'product.create', 'Created product \'Potters Ville\' (ID: 17)', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'Desktop', 'Chrome', 'macOS', '{\"sku\": \"P-3753\", \"name\": \"Potters Ville\", \"tags\": [\"clay\", \"sand\", \"best\"], \"unit\": \"kg\", \"status\": \"approved\", \"tax_type\": \"flat\", \"published\": \"1\", \"seller_id\": \"2\", \"unit_price\": \"3000\", \"category_id\": \"8\", \"description\": \"Premium Clay Premium Clay Premium ClayPremium Clay Premium Clay Premium ClayPremium Clay Premium Clay Premium ClayPremium Clay Premium Clay Premium ClayPremium Clay Premium Clay Premium ClayPremium Clay Premium Clay Premium ClayPremium Clay Premium Clay Premium ClayPremium Clay Premium Clay Premium ClayPremium Clay Premium Clay Premium ClayPremium Clay Premium Clay Premium ClayPremium Clay Premium Clay Premium ClayPremium Clay Premium Clay Premium ClayPremium Clay Premium Clay Premium ClayPremium Clay Premium Clay Premium ClayPremium Clay Premium Clay Premium Clay\", \"is_featured\": \"1\", \"multiply_qty\": \"0\", \"product_type\": \"physical\", \"stock_status\": \"in_stock\", \"current_stock\": \"10\", \"discount_type\": \"flat\", \"shipping_cost\": \"0\", \"is_todays_deal\": \"0\", \"purchase_price\": \"3000\", \"minimum_order_qty\": \"1\", \"short_description\": \"Premium Clay\", \"low_stock_threshold\": \"5\"}', NULL, '{\"id\": 17, \"sku\": \"P-3753\", \"tax\": 0, \"name\": \"Potters Ville\", \"slug\": \"potters-ville-1Tbjj\", \"tags\": [\"clay\", \"sand\", \"best\"], \"unit\": \"kg\", \"images\": [], \"status\": \"approved\", \"brand_id\": null, \"discount\": 0, \"tax_type\": \"flat\", \"published\": true, \"seller_id\": \"2\", \"thumbnail\": \"products/thumbnails/2026/09/63b49dfe-71c7-4f5c-8478-4271a2c30133_1788516988.webp\", \"created_at\": \"2026-09-04T10:16:28.000000Z\", \"meta_image\": null, \"meta_title\": null, \"unit_price\": 3000, \"updated_at\": \"2026-09-04T10:16:28.000000Z\", \"category_id\": \"8\", \"description\": \"Premium Clay Premium Clay Premium ClayPremium Clay Premium Clay Premium ClayPremium Clay Premium Clay Premium ClayPremium Clay Premium Clay Premium ClayPremium Clay Premium Clay Premium ClayPremium Clay Premium Clay Premium ClayPremium Clay Premium Clay Premium ClayPremium Clay Premium Clay Premium ClayPremium Clay Premium Clay Premium ClayPremium Clay Premium Clay Premium ClayPremium Clay Premium Clay Premium ClayPremium Clay Premium Clay Premium ClayPremium Clay Premium Clay Premium ClayPremium Clay Premium Clay Premium ClayPremium Clay Premium Clay Premium Clay\", \"is_featured\": true, \"digital_file\": null, \"multiply_qty\": false, \"product_type\": \"physical\", \"stock_status\": \"in_stock\", \"current_stock\": \"10\", \"denied_reason\": null, \"discount_type\": \"flat\", \"shipping_cost\": 0, \"is_todays_deal\": false, \"purchase_price\": 3000, \"sub_category_id\": null, \"meta_description\": null, \"digital_file_type\": null, \"minimum_order_qty\": \"1\", \"short_description\": \"Premium Clay\", \"low_stock_threshold\": \"5\"}', '2026-09-04 09:16:28', '2026-09-04 09:16:28'),
(156, 1, 'admin', 'product.update', 'Updated product \'Supre Model\' (ID: 11)', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'Desktop', 'Chrome', 'macOS', '{\"sku\": \"HP-ANC-00132673\", \"tax\": \"0\", \"name\": \"Supre Model\", \"unit\": \"1\", \"status\": \"approved\", \"_method\": \"POST\", \"discount\": \"10\", \"tax_type\": \"flat\", \"published\": \"1\", \"seller_id\": \"2\", \"unit_price\": \"199.99\", \"category_id\": \"2\", \"description\": \"Experience studio-grade sound with ultra-comfortable ear cushions and up to 30 hours of battery life.\", \"is_featured\": \"1\", \"multiply_qty\": \"0\", \"product_type\": \"physical\", \"stock_status\": \"in_stock\", \"current_stock\": \"50\", \"discount_type\": \"percent\", \"shipping_cost\": \"0\", \"is_todays_deal\": \"1\", \"purchase_price\": \"120\", \"sub_category_id\": \"1\", \"minimum_order_qty\": \"1\", \"short_description\": \"High-fidelity audio with active noise cancellation.\", \"low_stock_threshold\": \"5\"}', '{\"id\": 11, \"sku\": \"HP-ANC-00132673\", \"tax\": 0, \"name\": \"Supre Model\", \"slug\": \"supre-model-OJ3vX\", \"tags\": [], \"unit\": \"1\", \"images\": [\"products/gallery/2026/09/0d94221d-5bb7-4711-b398-dbba301b24cb_1788454241.webp\", \"products/gallery/2026/09/a583ab7a-ca85-4ee9-9e98-3cddab8ce529_1788454241.webp\", \"products/gallery/2026/09/e6d59e57-20cb-405d-b210-4f770049f8ab_1788454241.webp\", \"products/gallery/2026/09/d0c3a051-a1a7-4f0e-9ca9-42647504cc68_1788454241.webp\", \"products/gallery/2026/09/473bad28-2514-406f-8a08-7a5f54142981_1788454241.webp\"], \"status\": \"approved\", \"brand_id\": null, \"discount\": 10, \"tax_type\": \"flat\", \"published\": true, \"seller_id\": 2, \"thumbnail\": \"products/thumbnails/2026/09/035ca177-d273-4b0e-937b-1cf8b9c3344a_1788515939.webp\", \"created_at\": \"2026-09-03T16:50:41.000000Z\", \"deleted_at\": null, \"meta_image\": \"products/meta/2026/09/43e3c5b1-25cd-49a7-a5a2-ba2d303dac9e_1788515939.webp\", \"meta_title\": null, \"unit_price\": 199.99, \"updated_at\": \"2026-09-04T09:58:59.000000Z\", \"variations\": [], \"category_id\": 2, \"description\": \"Experience studio-grade sound with ultra-comfortable ear cushions and up to 30 hours of battery life.\", \"is_featured\": true, \"digital_file\": null, \"multiply_qty\": false, \"product_type\": \"physical\", \"stock_status\": \"in_stock\", \"current_stock\": 50, \"denied_reason\": null, \"discount_type\": \"percent\", \"shipping_cost\": 0, \"is_todays_deal\": true, \"purchase_price\": 120, \"sub_category_id\": 1, \"meta_description\": null, \"digital_file_type\": null, \"minimum_order_qty\": 1, \"short_description\": \"High-fidelity audio with active noise cancellation.\", \"low_stock_threshold\": 5}', '{\"id\": 11, \"sku\": \"HP-ANC-00132673\", \"tax\": 0, \"name\": \"Supre Model\", \"slug\": \"supre-model-OJ3vX\", \"tags\": [], \"unit\": \"1\", \"images\": [\"products/gallery/2026/09/0d94221d-5bb7-4711-b398-dbba301b24cb_1788454241.webp\", \"products/gallery/2026/09/a583ab7a-ca85-4ee9-9e98-3cddab8ce529_1788454241.webp\", \"products/gallery/2026/09/e6d59e57-20cb-405d-b210-4f770049f8ab_1788454241.webp\", \"products/gallery/2026/09/d0c3a051-a1a7-4f0e-9ca9-42647504cc68_1788454241.webp\", \"products/gallery/2026/09/473bad28-2514-406f-8a08-7a5f54142981_1788454241.webp\"], \"status\": \"approved\", \"brand_id\": null, \"discount\": 10, \"tax_type\": \"flat\", \"published\": true, \"seller_id\": 2, \"thumbnail\": \"products/thumbnails/2026/09/035ca177-d273-4b0e-937b-1cf8b9c3344a_1788515939.webp\", \"created_at\": \"2026-09-03T16:50:41.000000Z\", \"deleted_at\": null, \"meta_image\": \"products/meta/2026/09/43e3c5b1-25cd-49a7-a5a2-ba2d303dac9e_1788515939.webp\", \"meta_title\": null, \"unit_price\": 199.99, \"updated_at\": \"2026-09-04T09:58:59.000000Z\", \"variations\": [], \"category_id\": 2, \"description\": \"Experience studio-grade sound with ultra-comfortable ear cushions and up to 30 hours of battery life.\", \"is_featured\": true, \"digital_file\": null, \"multiply_qty\": false, \"product_type\": \"physical\", \"stock_status\": \"in_stock\", \"current_stock\": 50, \"denied_reason\": null, \"discount_type\": \"percent\", \"shipping_cost\": 0, \"is_todays_deal\": true, \"purchase_price\": 120, \"sub_category_id\": 1, \"meta_description\": null, \"digital_file_type\": null, \"minimum_order_qty\": 1, \"short_description\": \"High-fidelity audio with active noise cancellation.\", \"low_stock_threshold\": 5}', '2026-09-04 09:48:36', '2026-09-04 09:48:36'),
(157, 1, NULL, 'update_general_settings', 'Updated system general settings (site name, email, phone, currency).', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, '{\"site_name\": \"Market My Art Platform\", \"site_email\": \"support@marketmyart.com\", \"site_phone\": \"+23480000011113\", \"site_currency\": \"NGN\", \"currency_symbol\": \"₦\"}', '{\"site_name\": \"Market My Art Platform\", \"site_email\": \"support@marketmyart.com\", \"site_phone\": \"+23480000011113\", \"site_currency\": \"NGN\", \"currency_symbol\": \"₦\"}', '2026-09-05 14:00:35', '2026-09-05 14:00:35'),
(158, 1, NULL, 'update_general_settings', 'Updated system general settings (site name, email, phone, currency).', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, '{\"site_name\": \"Market My Art Platform\", \"site_email\": \"support@marketmyart.com\", \"site_phone\": \"+23480000011113\", \"site_currency\": \"NGN\", \"currency_symbol\": \"₦\"}', '{\"site_name\": \"Market My Art Platform\", \"site_email\": \"support@marketmyart.com\", \"site_phone\": \"+23480000011113\", \"site_currency\": \"EUR\", \"currency_symbol\": \"€\"}', '2026-09-05 16:11:31', '2026-09-05 16:11:31'),
(159, 1, NULL, 'update_general_settings', 'Updated system general settings (site name, email, phone, currency).', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, '{\"site_name\": \"Market My Art Platform\", \"site_email\": \"support@marketmyart.com\", \"site_phone\": \"+23480000011113\", \"site_currency\": \"EUR\", \"currency_symbol\": \"€\"}', '{\"site_name\": \"Market My Art Platform\", \"site_email\": \"support@marketmyart.com\", \"site_phone\": \"+23480000011113\", \"site_currency\": \"NGN\", \"currency_symbol\": \"₦\"}', '2026-09-05 16:11:52', '2026-09-05 16:11:52'),
(160, 1, NULL, 'update_general_settings', 'Updated system general settings (site name, email, phone, currency).', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, '{\"site_name\": \"Market My Art Platform\", \"site_email\": \"support@marketmyart.com\", \"site_phone\": \"+23480000011113\", \"site_currency\": \"NGN\", \"currency_symbol\": \"₦\"}', '{\"site_name\": \"Market My Art Platform\", \"site_email\": \"support@marketmyart.com\", \"site_phone\": \"+23480000011113\", \"site_currency\": \"USD\", \"currency_symbol\": \"$\"}', '2026-09-05 20:09:44', '2026-09-05 20:09:44'),
(161, 1, NULL, 'update_general_settings', 'Updated system general settings (site name, email, phone, currency).', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, '{\"site_name\": \"Market My Art Platform\", \"site_email\": \"support@marketmyart.com\", \"site_phone\": \"+23480000011113\", \"site_currency\": \"USD\", \"currency_symbol\": \"$\"}', '{\"site_name\": \"Market My Art Platform\", \"site_email\": \"support@marketmyart.com\", \"site_phone\": \"+23480000011113\", \"site_currency\": \"NGN\", \"currency_symbol\": \"₦\"}', '2026-09-05 20:10:14', '2026-09-05 20:10:14'),
(162, 1, NULL, 'update_general_settings', 'Updated system general settings (site name, email, phone, currency).', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, '{\"site_name\": \"Market My Art Platform\", \"site_email\": \"support@marketmyart.com\", \"site_phone\": \"+23480000011113\", \"site_currency\": \"NGN\", \"currency_symbol\": \"₦\"}', '{\"site_name\": \"Market My Art Platform\", \"site_email\": \"support@marketmyart.com\", \"site_phone\": \"+23480000011113\", \"site_currency\": \"NGN\", \"currency_symbol\": \"₦\"}', '2026-09-05 20:11:19', '2026-09-05 20:11:19'),
(163, 1, 'admin', 'category.create', 'Created category \'Test Category\' (ID: 15)', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'Desktop', 'Chrome', 'macOS', '{\"icon\": {}, \"name\": \"Test Category\", \"status\": \"1\", \"priority\": \"2\"}', NULL, '{\"id\": 15, \"icon\": \"categories/icons/2026/09/22609e7b-df8f-4a9a-9b8c-8cd9e34fd6b3_1788708772.webp\", \"name\": \"Test Category\", \"slug\": \"test-category\", \"banner\": null, \"status\": true, \"priority\": 2, \"created_at\": \"2026-09-06T15:32:52.000000Z\", \"updated_at\": \"2026-09-06T15:32:52.000000Z\"}', '2026-09-06 14:32:52', '2026-09-06 14:32:52'),
(164, 1, 'admin', 'category.delete', 'Deleted category \'Test Category\' (ID: 15)', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'Desktop', 'Chrome', 'macOS', NULL, '{\"id\": 15, \"icon\": \"categories/icons/2026/09/22609e7b-df8f-4a9a-9b8c-8cd9e34fd6b3_1788708772.webp\", \"name\": \"Test Category\", \"slug\": \"test-category\", \"banner\": null, \"status\": \"inactive\", \"priority\": 2, \"created_at\": \"2026-09-06T15:32:52.000000Z\", \"updated_at\": \"2026-09-06T15:32:52.000000Z\"}', NULL, '2026-09-06 14:33:06', '2026-09-06 14:33:06'),
(165, 1, NULL, 'invite_admin_user', 'Created staff account #51 (adele@mma.com) and issued role ID 1', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '{\"user\": {\"id\": 51, \"name\": \"Adele\", \"type\": \"staff\", \"email\": \"adele@mma.com\", \"phone\": \"080267834\", \"status\": \"pending\"}, \"invitation\": {\"id\": 13, \"email\": \"adele@mma.com\", \"token\": \"YApr8KdQQM3bTHsFQINbLSOPNiqIT33qFOHbsG0r\", \"status\": \"pending\", \"role_id\": 1, \"created_at\": \"2026-09-06T15:39:03.000000Z\", \"expires_at\": \"2026-09-13T15:39:03.000000Z\", \"invited_by\": 1, \"updated_at\": \"2026-09-06T15:39:03.000000Z\"}}', '2026-09-06 14:39:03', '2026-09-06 14:39:03'),
(166, 1, NULL, 'update_customer_status', 'Changed customer (#3 - John Dillion) status from active to blocked. Reason: Hello I dont like this', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, '{\"status\": \"active\"}', '{\"status\": \"blocked\"}', '2026-09-06 14:42:27', '2026-09-06 14:42:27'),
(167, 1, NULL, 'update_customer_status', 'Changed customer (#3 - John Dillion) status from blocked to active. Reason: N/A', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, '{\"status\": \"blocked\"}', '{\"status\": \"active\"}', '2026-09-06 14:42:37', '2026-09-06 14:42:37'),
(168, 1, NULL, 'update_role', 'Updated role permissions for: Finance Manager', '127.0.0.1', 'PostmanRuntime/2.4.3', NULL, NULL, NULL, NULL, NULL, '{\"id\": 1, \"name\": \"Finance Manager\", \"slug\": \"finance-manager\", \"created_at\": \"2026-08-31T08:43:59.000000Z\", \"updated_at\": \"2026-09-07T10:10:32.000000Z\", \"description\": \"Updated scope for finance operations.\", \"permissions\": [{\"id\": 1, \"name\": \"View Dashboard\", \"slug\": \"dashboard.view\", \"group\": \"dashboard\", \"pivot\": {\"role_id\": 1, \"permission_id\": 1}, \"created_at\": \"2026-08-28T00:27:12.000000Z\", \"updated_at\": \"2026-08-28T00:27:12.000000Z\", \"description\": \"Access main system dashboard analytics\"}, {\"id\": 2, \"name\": \"View Categories\", \"slug\": \"categories.view\", \"group\": \"categories\", \"pivot\": {\"role_id\": 1, \"permission_id\": 2}, \"created_at\": \"2026-08-28T00:27:12.000000Z\", \"updated_at\": \"2026-08-28T00:27:12.000000Z\", \"description\": \"View product categories and details\"}, {\"id\": 5, \"name\": \"Delete Categories\", \"slug\": \"categories.delete\", \"group\": \"categories\", \"pivot\": {\"role_id\": 1, \"permission_id\": 5}, \"created_at\": \"2026-08-28T00:27:12.000000Z\", \"updated_at\": \"2026-08-28T00:27:12.000000Z\", \"description\": \"Delete product categories\"}, {\"id\": 8, \"name\": \"Edit Sub-Categories\", \"slug\": \"subcategories.edit\", \"group\": \"subcategories\", \"pivot\": {\"role_id\": 1, \"permission_id\": 8}, \"created_at\": \"2026-08-28T00:27:12.000000Z\", \"updated_at\": \"2026-08-28T00:27:12.000000Z\", \"description\": \"Update existing sub-categories\"}, {\"id\": 12, \"name\": \"Edit Brands\", \"slug\": \"brands.edit\", \"group\": \"brands\", \"pivot\": {\"role_id\": 1, \"permission_id\": 12}, \"created_at\": \"2026-08-28T00:27:12.000000Z\", \"updated_at\": \"2026-08-28T00:27:12.000000Z\", \"description\": \"Update existing product brands\"}]}', '2026-09-07 09:10:32', '2026-09-07 09:10:32'),
(169, 1, NULL, 'update_role', 'Updated role permissions for: Finance Manager', '127.0.0.1', 'PostmanRuntime/2.4.3', NULL, NULL, NULL, NULL, NULL, '{\"id\": 1, \"name\": \"Finance Manager\", \"slug\": \"finance-manager\", \"created_at\": \"2026-08-31T08:43:59.000000Z\", \"updated_at\": \"2026-09-07T10:10:32.000000Z\", \"description\": \"Updated scope for finance operations.\", \"permissions\": [{\"id\": 1, \"name\": \"View Dashboard\", \"slug\": \"dashboard.view\", \"group\": \"dashboard\", \"pivot\": {\"role_id\": 1, \"permission_id\": 1}, \"created_at\": \"2026-08-28T00:27:12.000000Z\", \"updated_at\": \"2026-08-28T00:27:12.000000Z\", \"description\": \"Access main system dashboard analytics\"}, {\"id\": 2, \"name\": \"View Categories\", \"slug\": \"categories.view\", \"group\": \"categories\", \"pivot\": {\"role_id\": 1, \"permission_id\": 2}, \"created_at\": \"2026-08-28T00:27:12.000000Z\", \"updated_at\": \"2026-08-28T00:27:12.000000Z\", \"description\": \"View product categories and details\"}, {\"id\": 5, \"name\": \"Delete Categories\", \"slug\": \"categories.delete\", \"group\": \"categories\", \"pivot\": {\"role_id\": 1, \"permission_id\": 5}, \"created_at\": \"2026-08-28T00:27:12.000000Z\", \"updated_at\": \"2026-08-28T00:27:12.000000Z\", \"description\": \"Delete product categories\"}, {\"id\": 8, \"name\": \"Edit Sub-Categories\", \"slug\": \"subcategories.edit\", \"group\": \"subcategories\", \"pivot\": {\"role_id\": 1, \"permission_id\": 8}, \"created_at\": \"2026-08-28T00:27:12.000000Z\", \"updated_at\": \"2026-08-28T00:27:12.000000Z\", \"description\": \"Update existing sub-categories\"}, {\"id\": 12, \"name\": \"Edit Brands\", \"slug\": \"brands.edit\", \"group\": \"brands\", \"pivot\": {\"role_id\": 1, \"permission_id\": 12}, \"created_at\": \"2026-08-28T00:27:12.000000Z\", \"updated_at\": \"2026-08-28T00:27:12.000000Z\", \"description\": \"Update existing product brands\"}]}', '2026-09-07 09:10:39', '2026-09-07 09:10:39'),
(170, 1, NULL, 'delete_role', 'Deleted system role: Finance Manager', '127.0.0.1', 'PostmanRuntime/2.4.3', NULL, NULL, NULL, NULL, NULL, NULL, '2026-09-07 09:11:14', '2026-09-07 09:11:14'),
(171, 1, NULL, 'create_role', 'Created new system role: Finance Manager', '127.0.0.1', 'PostmanRuntime/2.4.3', NULL, NULL, NULL, NULL, NULL, '{\"id\": 2, \"name\": \"Finance Manager\", \"slug\": \"finance-manager\", \"created_at\": \"2026-09-07T10:16:14.000000Z\", \"updated_at\": \"2026-09-07T10:16:14.000000Z\", \"description\": \"Manages settlements, seller payouts, and refunds.\", \"permissions\": [{\"id\": 1, \"name\": \"View Dashboard\", \"slug\": \"dashboard.view\", \"group\": \"dashboard\", \"pivot\": {\"role_id\": 2, \"permission_id\": 1}, \"created_at\": \"2026-08-28T00:27:12.000000Z\", \"updated_at\": \"2026-08-28T00:27:12.000000Z\", \"description\": \"Access main system dashboard analytics\"}, {\"id\": 2, \"name\": \"View Categories\", \"slug\": \"categories.view\", \"group\": \"categories\", \"pivot\": {\"role_id\": 2, \"permission_id\": 2}, \"created_at\": \"2026-08-28T00:27:12.000000Z\", \"updated_at\": \"2026-08-28T00:27:12.000000Z\", \"description\": \"View product categories and details\"}, {\"id\": 5, \"name\": \"Delete Categories\", \"slug\": \"categories.delete\", \"group\": \"categories\", \"pivot\": {\"role_id\": 2, \"permission_id\": 5}, \"created_at\": \"2026-08-28T00:27:12.000000Z\", \"updated_at\": \"2026-08-28T00:27:12.000000Z\", \"description\": \"Delete product categories\"}, {\"id\": 8, \"name\": \"Edit Sub-Categories\", \"slug\": \"subcategories.edit\", \"group\": \"subcategories\", \"pivot\": {\"role_id\": 2, \"permission_id\": 8}, \"created_at\": \"2026-08-28T00:27:12.000000Z\", \"updated_at\": \"2026-08-28T00:27:12.000000Z\", \"description\": \"Update existing sub-categories\"}]}', '2026-09-07 09:16:14', '2026-09-07 09:16:14'),
(172, 1, NULL, 'delete_role', 'Deleted system role: Finance Manager', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, NULL, '2026-09-07 09:17:31', '2026-09-07 09:17:31'),
(173, 1, NULL, 'create_role', 'Created new system role: Compliance Team', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '{\"id\": 3, \"name\": \"Compliance Team\", \"slug\": \"compliance-team\", \"created_at\": \"2026-09-07T10:25:07.000000Z\", \"updated_at\": \"2026-09-07T10:25:07.000000Z\", \"description\": \"Test Meal\", \"permissions\": [{\"id\": 1, \"name\": \"View Dashboard\", \"slug\": \"dashboard.view\", \"group\": \"dashboard\", \"pivot\": {\"role_id\": 3, \"permission_id\": 1}, \"created_at\": \"2026-08-28T00:27:12.000000Z\", \"updated_at\": \"2026-08-28T00:27:12.000000Z\", \"description\": \"Access main system dashboard analytics\"}, {\"id\": 3, \"name\": \"Create Categories\", \"slug\": \"categories.create\", \"group\": \"categories\", \"pivot\": {\"role_id\": 3, \"permission_id\": 3}, \"created_at\": \"2026-08-28T00:27:12.000000Z\", \"updated_at\": \"2026-08-28T00:27:12.000000Z\", \"description\": \"Create new product categories\"}, {\"id\": 4, \"name\": \"Edit Categories\", \"slug\": \"categories.edit\", \"group\": \"categories\", \"pivot\": {\"role_id\": 3, \"permission_id\": 4}, \"created_at\": \"2026-08-28T00:27:12.000000Z\", \"updated_at\": \"2026-08-28T00:27:12.000000Z\", \"description\": \"Update existing product categories\"}, {\"id\": 5, \"name\": \"Delete Categories\", \"slug\": \"categories.delete\", \"group\": \"categories\", \"pivot\": {\"role_id\": 3, \"permission_id\": 5}, \"created_at\": \"2026-08-28T00:27:12.000000Z\", \"updated_at\": \"2026-08-28T00:27:12.000000Z\", \"description\": \"Delete product categories\"}, {\"id\": 57, \"name\": \"View Staff\", \"slug\": \"staff.view\", \"group\": \"staff\", \"pivot\": {\"role_id\": 3, \"permission_id\": 57}, \"created_at\": \"2026-08-28T00:27:12.000000Z\", \"updated_at\": \"2026-08-28T00:27:12.000000Z\", \"description\": \"View administrative staff user list\"}, {\"id\": 58, \"name\": \"Manage Staff\", \"slug\": \"staff.manage\", \"group\": \"staff\", \"pivot\": {\"role_id\": 3, \"permission_id\": 58}, \"created_at\": \"2026-08-28T00:27:12.000000Z\", \"updated_at\": \"2026-08-28T00:27:12.000000Z\", \"description\": \"Invite, update, reset password, and change staff roles\"}, {\"id\": 59, \"name\": \"Delete Staff\", \"slug\": \"staff.delete\", \"group\": \"staff\", \"pivot\": {\"role_id\": 3, \"permission_id\": 59}, \"created_at\": \"2026-08-28T00:27:12.000000Z\", \"updated_at\": \"2026-08-28T00:27:12.000000Z\", \"description\": \"Delete administrative staff user accounts\"}]}', '2026-09-07 09:25:07', '2026-09-07 09:25:07'),
(174, 1, NULL, 'create_role', 'Created new system role: Meta Base', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '{\"id\": 4, \"name\": \"Meta Base\", \"slug\": \"meta-base\", \"created_at\": \"2026-09-07T10:26:18.000000Z\", \"updated_at\": \"2026-09-07T10:26:18.000000Z\", \"description\": \"test\", \"permissions\": [{\"id\": 2, \"name\": \"View Categories\", \"slug\": \"categories.view\", \"group\": \"categories\", \"pivot\": {\"role_id\": 4, \"permission_id\": 2}, \"created_at\": \"2026-08-28T00:27:12.000000Z\", \"updated_at\": \"2026-08-28T00:27:12.000000Z\", \"description\": \"View product categories and details\"}, {\"id\": 3, \"name\": \"Create Categories\", \"slug\": \"categories.create\", \"group\": \"categories\", \"pivot\": {\"role_id\": 4, \"permission_id\": 3}, \"created_at\": \"2026-08-28T00:27:12.000000Z\", \"updated_at\": \"2026-08-28T00:27:12.000000Z\", \"description\": \"Create new product categories\"}, {\"id\": 4, \"name\": \"Edit Categories\", \"slug\": \"categories.edit\", \"group\": \"categories\", \"pivot\": {\"role_id\": 4, \"permission_id\": 4}, \"created_at\": \"2026-08-28T00:27:12.000000Z\", \"updated_at\": \"2026-08-28T00:27:12.000000Z\", \"description\": \"Update existing product categories\"}, {\"id\": 5, \"name\": \"Delete Categories\", \"slug\": \"categories.delete\", \"group\": \"categories\", \"pivot\": {\"role_id\": 4, \"permission_id\": 5}, \"created_at\": \"2026-08-28T00:27:12.000000Z\", \"updated_at\": \"2026-08-28T00:27:12.000000Z\", \"description\": \"Delete product categories\"}]}', '2026-09-07 09:26:18', '2026-09-07 09:26:18'),
(175, 1, NULL, 'update_own_profile', 'User updated their profile details', '127.0.0.1', 'PostmanRuntime/2.4.3', NULL, NULL, NULL, NULL, '{\"name\": \"Oluwakayode Adetunji\", \"email\": \"admin@admin.com\", \"phone\": \"+2348012345678\"}', '{\"name\": \"Oluwakayode Adetunji\", \"email\": \"admin@admin.com\", \"phone\": \"+2348012345678\"}', '2026-09-07 10:08:58', '2026-09-07 10:08:58'),
(176, 1, NULL, 'update_role', 'Updated role permissions for: Compliance Team', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '{\"id\": 3, \"name\": \"Compliance Team\", \"slug\": \"compliance-team\", \"created_at\": \"2026-09-07T10:25:07.000000Z\", \"updated_at\": \"2026-09-07T10:25:07.000000Z\", \"description\": \"Test Meal\", \"permissions\": [{\"id\": 1, \"name\": \"View Dashboard\", \"slug\": \"dashboard.view\", \"group\": \"dashboard\", \"pivot\": {\"role_id\": 3, \"permission_id\": 1}, \"created_at\": \"2026-08-28T00:27:12.000000Z\", \"updated_at\": \"2026-08-28T00:27:12.000000Z\", \"description\": \"Access main system dashboard analytics\"}, {\"id\": 3, \"name\": \"Create Categories\", \"slug\": \"categories.create\", \"group\": \"categories\", \"pivot\": {\"role_id\": 3, \"permission_id\": 3}, \"created_at\": \"2026-08-28T00:27:12.000000Z\", \"updated_at\": \"2026-08-28T00:27:12.000000Z\", \"description\": \"Create new product categories\"}, {\"id\": 4, \"name\": \"Edit Categories\", \"slug\": \"categories.edit\", \"group\": \"categories\", \"pivot\": {\"role_id\": 3, \"permission_id\": 4}, \"created_at\": \"2026-08-28T00:27:12.000000Z\", \"updated_at\": \"2026-08-28T00:27:12.000000Z\", \"description\": \"Update existing product categories\"}, {\"id\": 5, \"name\": \"Delete Categories\", \"slug\": \"categories.delete\", \"group\": \"categories\", \"pivot\": {\"role_id\": 3, \"permission_id\": 5}, \"created_at\": \"2026-08-28T00:27:12.000000Z\", \"updated_at\": \"2026-08-28T00:27:12.000000Z\", \"description\": \"Delete product categories\"}, {\"id\": 57, \"name\": \"View Staff\", \"slug\": \"staff.view\", \"group\": \"staff\", \"pivot\": {\"role_id\": 3, \"permission_id\": 57}, \"created_at\": \"2026-08-28T00:27:12.000000Z\", \"updated_at\": \"2026-08-28T00:27:12.000000Z\", \"description\": \"View administrative staff user list\"}, {\"id\": 58, \"name\": \"Manage Staff\", \"slug\": \"staff.manage\", \"group\": \"staff\", \"pivot\": {\"role_id\": 3, \"permission_id\": 58}, \"created_at\": \"2026-08-28T00:27:12.000000Z\", \"updated_at\": \"2026-08-28T00:27:12.000000Z\", \"description\": \"Invite, update, reset password, and change staff roles\"}, {\"id\": 59, \"name\": \"Delete Staff\", \"slug\": \"staff.delete\", \"group\": \"staff\", \"pivot\": {\"role_id\": 3, \"permission_id\": 59}, \"created_at\": \"2026-08-28T00:27:12.000000Z\", \"updated_at\": \"2026-08-28T00:27:12.000000Z\", \"description\": \"Delete administrative staff user accounts\"}]}', '2026-09-07 13:09:45', '2026-09-07 13:09:45'),
(177, 1, NULL, 'update_role', 'Updated role permissions for: Compliance Teamj', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '{\"id\": 3, \"name\": \"Compliance Teamj\", \"slug\": \"compliance-teamj\", \"created_at\": \"2026-09-07T10:25:07.000000Z\", \"updated_at\": \"2026-09-07T14:09:56.000000Z\", \"description\": \"Test Mealf\", \"permissions\": [{\"id\": 1, \"name\": \"View Dashboard\", \"slug\": \"dashboard.view\", \"group\": \"dashboard\", \"pivot\": {\"role_id\": 3, \"permission_id\": 1}, \"created_at\": \"2026-08-28T00:27:12.000000Z\", \"updated_at\": \"2026-08-28T00:27:12.000000Z\", \"description\": \"Access main system dashboard analytics\"}, {\"id\": 3, \"name\": \"Create Categories\", \"slug\": \"categories.create\", \"group\": \"categories\", \"pivot\": {\"role_id\": 3, \"permission_id\": 3}, \"created_at\": \"2026-08-28T00:27:12.000000Z\", \"updated_at\": \"2026-08-28T00:27:12.000000Z\", \"description\": \"Create new product categories\"}, {\"id\": 4, \"name\": \"Edit Categories\", \"slug\": \"categories.edit\", \"group\": \"categories\", \"pivot\": {\"role_id\": 3, \"permission_id\": 4}, \"created_at\": \"2026-08-28T00:27:12.000000Z\", \"updated_at\": \"2026-08-28T00:27:12.000000Z\", \"description\": \"Update existing product categories\"}, {\"id\": 5, \"name\": \"Delete Categories\", \"slug\": \"categories.delete\", \"group\": \"categories\", \"pivot\": {\"role_id\": 3, \"permission_id\": 5}, \"created_at\": \"2026-08-28T00:27:12.000000Z\", \"updated_at\": \"2026-08-28T00:27:12.000000Z\", \"description\": \"Delete product categories\"}, {\"id\": 57, \"name\": \"View Staff\", \"slug\": \"staff.view\", \"group\": \"staff\", \"pivot\": {\"role_id\": 3, \"permission_id\": 57}, \"created_at\": \"2026-08-28T00:27:12.000000Z\", \"updated_at\": \"2026-08-28T00:27:12.000000Z\", \"description\": \"View administrative staff user list\"}, {\"id\": 58, \"name\": \"Manage Staff\", \"slug\": \"staff.manage\", \"group\": \"staff\", \"pivot\": {\"role_id\": 3, \"permission_id\": 58}, \"created_at\": \"2026-08-28T00:27:12.000000Z\", \"updated_at\": \"2026-08-28T00:27:12.000000Z\", \"description\": \"Invite, update, reset password, and change staff roles\"}, {\"id\": 59, \"name\": \"Delete Staff\", \"slug\": \"staff.delete\", \"group\": \"staff\", \"pivot\": {\"role_id\": 3, \"permission_id\": 59}, \"created_at\": \"2026-08-28T00:27:12.000000Z\", \"updated_at\": \"2026-08-28T00:27:12.000000Z\", \"description\": \"Delete administrative staff user accounts\"}]}', '2026-09-07 13:09:56', '2026-09-07 13:09:56');
INSERT INTO `audit_logs` (`id`, `user_id`, `user_type`, `action`, `description`, `ip_address`, `user_agent`, `device`, `browser`, `platform`, `payload`, `old_values`, `new_values`, `created_at`, `updated_at`) VALUES
(178, 1, NULL, 'update_role', 'Updated role permissions for: Compliance Teamj', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '{\"id\": 3, \"name\": \"Compliance Teamj\", \"slug\": \"compliance-teamj\", \"created_at\": \"2026-09-07T10:25:07.000000Z\", \"updated_at\": \"2026-09-07T14:09:56.000000Z\", \"description\": \"Test Mealf\", \"permissions\": [{\"id\": 1, \"name\": \"View Dashboard\", \"slug\": \"dashboard.view\", \"group\": \"dashboard\", \"pivot\": {\"role_id\": 3, \"permission_id\": 1}, \"created_at\": \"2026-08-28T00:27:12.000000Z\", \"updated_at\": \"2026-08-28T00:27:12.000000Z\", \"description\": \"Access main system dashboard analytics\"}, {\"id\": 2, \"name\": \"View Categories\", \"slug\": \"categories.view\", \"group\": \"categories\", \"pivot\": {\"role_id\": 3, \"permission_id\": 2}, \"created_at\": \"2026-08-28T00:27:12.000000Z\", \"updated_at\": \"2026-08-28T00:27:12.000000Z\", \"description\": \"View product categories and details\"}, {\"id\": 3, \"name\": \"Create Categories\", \"slug\": \"categories.create\", \"group\": \"categories\", \"pivot\": {\"role_id\": 3, \"permission_id\": 3}, \"created_at\": \"2026-08-28T00:27:12.000000Z\", \"updated_at\": \"2026-08-28T00:27:12.000000Z\", \"description\": \"Create new product categories\"}, {\"id\": 4, \"name\": \"Edit Categories\", \"slug\": \"categories.edit\", \"group\": \"categories\", \"pivot\": {\"role_id\": 3, \"permission_id\": 4}, \"created_at\": \"2026-08-28T00:27:12.000000Z\", \"updated_at\": \"2026-08-28T00:27:12.000000Z\", \"description\": \"Update existing product categories\"}, {\"id\": 5, \"name\": \"Delete Categories\", \"slug\": \"categories.delete\", \"group\": \"categories\", \"pivot\": {\"role_id\": 3, \"permission_id\": 5}, \"created_at\": \"2026-08-28T00:27:12.000000Z\", \"updated_at\": \"2026-08-28T00:27:12.000000Z\", \"description\": \"Delete product categories\"}, {\"id\": 6, \"name\": \"View Sub-Categories\", \"slug\": \"subcategories.view\", \"group\": \"subcategories\", \"pivot\": {\"role_id\": 3, \"permission_id\": 6}, \"created_at\": \"2026-08-28T00:27:12.000000Z\", \"updated_at\": \"2026-08-28T00:27:12.000000Z\", \"description\": \"View sub-categories and details\"}, {\"id\": 7, \"name\": \"Create Sub-Categories\", \"slug\": \"subcategories.create\", \"group\": \"subcategories\", \"pivot\": {\"role_id\": 3, \"permission_id\": 7}, \"created_at\": \"2026-08-28T00:27:12.000000Z\", \"updated_at\": \"2026-08-28T00:27:12.000000Z\", \"description\": \"Create new sub-categories\"}, {\"id\": 8, \"name\": \"Edit Sub-Categories\", \"slug\": \"subcategories.edit\", \"group\": \"subcategories\", \"pivot\": {\"role_id\": 3, \"permission_id\": 8}, \"created_at\": \"2026-08-28T00:27:12.000000Z\", \"updated_at\": \"2026-08-28T00:27:12.000000Z\", \"description\": \"Update existing sub-categories\"}, {\"id\": 9, \"name\": \"Delete Sub-Categories\", \"slug\": \"subcategories.delete\", \"group\": \"subcategories\", \"pivot\": {\"role_id\": 3, \"permission_id\": 9}, \"created_at\": \"2026-08-28T00:27:12.000000Z\", \"updated_at\": \"2026-08-28T00:27:12.000000Z\", \"description\": \"Delete sub-categories\"}, {\"id\": 10, \"name\": \"View Brands\", \"slug\": \"brands.view\", \"group\": \"brands\", \"pivot\": {\"role_id\": 3, \"permission_id\": 10}, \"created_at\": \"2026-08-28T00:27:12.000000Z\", \"updated_at\": \"2026-08-28T00:27:12.000000Z\", \"description\": \"View product brands\"}, {\"id\": 11, \"name\": \"Create Brands\", \"slug\": \"brands.create\", \"group\": \"brands\", \"pivot\": {\"role_id\": 3, \"permission_id\": 11}, \"created_at\": \"2026-08-28T00:27:12.000000Z\", \"updated_at\": \"2026-08-28T00:27:12.000000Z\", \"description\": \"Create new product brands\"}, {\"id\": 12, \"name\": \"Edit Brands\", \"slug\": \"brands.edit\", \"group\": \"brands\", \"pivot\": {\"role_id\": 3, \"permission_id\": 12}, \"created_at\": \"2026-08-28T00:27:12.000000Z\", \"updated_at\": \"2026-08-28T00:27:12.000000Z\", \"description\": \"Update existing product brands\"}, {\"id\": 13, \"name\": \"Delete Brands\", \"slug\": \"brands.delete\", \"group\": \"brands\", \"pivot\": {\"role_id\": 3, \"permission_id\": 13}, \"created_at\": \"2026-08-28T00:27:12.000000Z\", \"updated_at\": \"2026-08-28T00:27:12.000000Z\", \"description\": \"Delete product brands\"}, {\"id\": 14, \"name\": \"View Attributes\", \"slug\": \"attributes.view\", \"group\": \"attributes\", \"pivot\": {\"role_id\": 3, \"permission_id\": 14}, \"created_at\": \"2026-08-28T00:27:12.000000Z\", \"updated_at\": \"2026-08-28T00:27:12.000000Z\", \"description\": \"View product attributes and values\"}, {\"id\": 15, \"name\": \"Create Attributes\", \"slug\": \"attributes.create\", \"group\": \"attributes\", \"pivot\": {\"role_id\": 3, \"permission_id\": 15}, \"created_at\": \"2026-08-28T00:27:12.000000Z\", \"updated_at\": \"2026-08-28T00:27:12.000000Z\", \"description\": \"Create new product attributes and values\"}, {\"id\": 16, \"name\": \"Edit Attributes\", \"slug\": \"attributes.edit\", \"group\": \"attributes\", \"pivot\": {\"role_id\": 3, \"permission_id\": 16}, \"created_at\": \"2026-08-28T00:27:12.000000Z\", \"updated_at\": \"2026-08-28T00:27:12.000000Z\", \"description\": \"Update product attributes and values\"}, {\"id\": 17, \"name\": \"Delete Attributes\", \"slug\": \"attributes.delete\", \"group\": \"attributes\", \"pivot\": {\"role_id\": 3, \"permission_id\": 17}, \"created_at\": \"2026-08-28T00:27:12.000000Z\", \"updated_at\": \"2026-08-28T00:27:12.000000Z\", \"description\": \"Delete product attributes and values\"}, {\"id\": 18, \"name\": \"View Products\", \"slug\": \"products.view\", \"group\": \"products\", \"pivot\": {\"role_id\": 3, \"permission_id\": 18}, \"created_at\": \"2026-08-28T00:27:12.000000Z\", \"updated_at\": \"2026-08-28T00:27:12.000000Z\", \"description\": \"View all products\"}, {\"id\": 19, \"name\": \"Create Products\", \"slug\": \"products.create\", \"group\": \"products\", \"pivot\": {\"role_id\": 3, \"permission_id\": 19}, \"created_at\": \"2026-08-28T00:27:12.000000Z\", \"updated_at\": \"2026-08-28T00:27:12.000000Z\", \"description\": \"Create new products\"}, {\"id\": 20, \"name\": \"Edit Products\", \"slug\": \"products.edit\", \"group\": \"products\", \"pivot\": {\"role_id\": 3, \"permission_id\": 20}, \"created_at\": \"2026-08-28T00:27:12.000000Z\", \"updated_at\": \"2026-08-28T00:27:12.000000Z\", \"description\": \"Update products and publish status\"}, {\"id\": 21, \"name\": \"Delete Products\", \"slug\": \"products.delete\", \"group\": \"products\", \"pivot\": {\"role_id\": 3, \"permission_id\": 21}, \"created_at\": \"2026-08-28T00:27:12.000000Z\", \"updated_at\": \"2026-08-28T00:27:12.000000Z\", \"description\": \"Delete products\"}, {\"id\": 22, \"name\": \"View Orders\", \"slug\": \"orders.view\", \"group\": \"orders\", \"pivot\": {\"role_id\": 3, \"permission_id\": 22}, \"created_at\": \"2026-08-28T00:27:12.000000Z\", \"updated_at\": \"2026-08-28T00:27:12.000000Z\", \"description\": \"View order listings and details\"}, {\"id\": 23, \"name\": \"Manage Orders\", \"slug\": \"orders.manage\", \"group\": \"orders\", \"pivot\": {\"role_id\": 3, \"permission_id\": 23}, \"created_at\": \"2026-08-28T00:27:12.000000Z\", \"updated_at\": \"2026-08-28T00:27:12.000000Z\", \"description\": \"Update order, item, and payment status\"}, {\"id\": 24, \"name\": \"View Abandoned Carts\", \"slug\": \"abandoned_carts.view\", \"group\": \"abandoned_carts\", \"pivot\": {\"role_id\": 3, \"permission_id\": 24}, \"created_at\": \"2026-08-28T00:27:12.000000Z\", \"updated_at\": \"2026-08-28T00:27:12.000000Z\", \"description\": \"View abandoned cart lists\"}, {\"id\": 25, \"name\": \"Delete Abandoned Carts\", \"slug\": \"abandoned_carts.delete\", \"group\": \"abandoned_carts\", \"pivot\": {\"role_id\": 3, \"permission_id\": 25}, \"created_at\": \"2026-08-28T00:27:12.000000Z\", \"updated_at\": \"2026-08-28T00:27:12.000000Z\", \"description\": \"Remove abandoned cart records\"}, {\"id\": 26, \"name\": \"Send Recovery Notifications\", \"slug\": \"abandoned_carts.notify\", \"group\": \"abandoned_carts\", \"pivot\": {\"role_id\": 3, \"permission_id\": 26}, \"created_at\": \"2026-08-28T00:27:12.000000Z\", \"updated_at\": \"2026-08-28T00:27:12.000000Z\", \"description\": \"Send single/bulk cart recovery notifications\"}, {\"id\": 27, \"name\": \"View Transactions\", \"slug\": \"transactions.view\", \"group\": \"transactions\", \"pivot\": {\"role_id\": 3, \"permission_id\": 27}, \"created_at\": \"2026-08-28T00:27:12.000000Z\", \"updated_at\": \"2026-08-28T00:27:12.000000Z\", \"description\": \"View transaction records and tax logs\"}, {\"id\": 28, \"name\": \"Manage Transactions\", \"slug\": \"transactions.manage\", \"group\": \"transactions\", \"pivot\": {\"role_id\": 3, \"permission_id\": 28}, \"created_at\": \"2026-08-28T00:27:12.000000Z\", \"updated_at\": \"2026-08-28T00:27:12.000000Z\", \"description\": \"Update transaction status\"}, {\"id\": 29, \"name\": \"View Platform Earnings\", \"slug\": \"platform_earnings.view\", \"group\": \"platform_earnings\", \"pivot\": {\"role_id\": 3, \"permission_id\": 29}, \"created_at\": \"2026-08-28T00:27:12.000000Z\", \"updated_at\": \"2026-08-28T00:27:12.000000Z\", \"description\": \"View platform revenue metrics\"}, {\"id\": 30, \"name\": \"View Refunds\", \"slug\": \"refunds.view\", \"group\": \"refunds\", \"pivot\": {\"role_id\": 3, \"permission_id\": 30}, \"created_at\": \"2026-08-28T00:27:12.000000Z\", \"updated_at\": \"2026-08-28T00:27:12.000000Z\", \"description\": \"View customer refund requests\"}, {\"id\": 31, \"name\": \"Manage Refunds\", \"slug\": \"refunds.manage\", \"group\": \"refunds\", \"pivot\": {\"role_id\": 3, \"permission_id\": 31}, \"created_at\": \"2026-08-28T00:27:12.000000Z\", \"updated_at\": \"2026-08-28T00:27:12.000000Z\", \"description\": \"Approve or decline refund requests\"}, {\"id\": 32, \"name\": \"View Withdrawals\", \"slug\": \"withdrawals.view\", \"group\": \"withdrawals\", \"pivot\": {\"role_id\": 3, \"permission_id\": 32}, \"created_at\": \"2026-08-28T00:27:12.000000Z\", \"updated_at\": \"2026-08-28T00:27:12.000000Z\", \"description\": \"View seller withdrawal requests\"}, {\"id\": 33, \"name\": \"Manage Withdrawals\", \"slug\": \"withdrawals.manage\", \"group\": \"withdrawals\", \"pivot\": {\"role_id\": 3, \"permission_id\": 33}, \"created_at\": \"2026-08-28T00:27:12.000000Z\", \"updated_at\": \"2026-08-28T00:27:12.000000Z\", \"description\": \"Approve or decline seller payout requests\"}, {\"id\": 34, \"name\": \"View Coupons\", \"slug\": \"coupons.view\", \"group\": \"coupons\", \"pivot\": {\"role_id\": 3, \"permission_id\": 34}, \"created_at\": \"2026-08-28T00:27:12.000000Z\", \"updated_at\": \"2026-08-28T00:27:12.000000Z\", \"description\": \"View discount coupons\"}, {\"id\": 35, \"name\": \"Create Coupons\", \"slug\": \"coupons.create\", \"group\": \"coupons\", \"pivot\": {\"role_id\": 3, \"permission_id\": 35}, \"created_at\": \"2026-08-28T00:27:12.000000Z\", \"updated_at\": \"2026-08-28T00:27:12.000000Z\", \"description\": \"Create new discount coupons\"}, {\"id\": 36, \"name\": \"Edit Coupons\", \"slug\": \"coupons.edit\", \"group\": \"coupons\", \"pivot\": {\"role_id\": 3, \"permission_id\": 36}, \"created_at\": \"2026-08-28T00:27:12.000000Z\", \"updated_at\": \"2026-08-28T00:27:12.000000Z\", \"description\": \"Update coupon details and toggle status\"}, {\"id\": 37, \"name\": \"Delete Coupons\", \"slug\": \"coupons.delete\", \"group\": \"coupons\", \"pivot\": {\"role_id\": 3, \"permission_id\": 37}, \"created_at\": \"2026-08-28T00:27:12.000000Z\", \"updated_at\": \"2026-08-28T00:27:12.000000Z\", \"description\": \"Delete discount coupons\"}, {\"id\": 38, \"name\": \"View Flash Sales\", \"slug\": \"flash_sales.view\", \"group\": \"flash_sales\", \"pivot\": {\"role_id\": 3, \"permission_id\": 38}, \"created_at\": \"2026-08-28T00:27:12.000000Z\", \"updated_at\": \"2026-08-28T00:27:12.000000Z\", \"description\": \"View promotional flash sales\"}, {\"id\": 39, \"name\": \"Create Flash Sales\", \"slug\": \"flash_sales.create\", \"group\": \"flash_sales\", \"pivot\": {\"role_id\": 3, \"permission_id\": 39}, \"created_at\": \"2026-08-28T00:27:12.000000Z\", \"updated_at\": \"2026-08-28T00:27:12.000000Z\", \"description\": \"Create new flash sale campaigns\"}, {\"id\": 40, \"name\": \"Edit Flash Sales\", \"slug\": \"flash_sales.edit\", \"group\": \"flash_sales\", \"pivot\": {\"role_id\": 3, \"permission_id\": 40}, \"created_at\": \"2026-08-28T00:27:12.000000Z\", \"updated_at\": \"2026-08-28T00:27:12.000000Z\", \"description\": \"Update flash sale details and toggle status\"}, {\"id\": 41, \"name\": \"Delete Flash Sales\", \"slug\": \"flash_sales.delete\", \"group\": \"flash_sales\", \"pivot\": {\"role_id\": 3, \"permission_id\": 41}, \"created_at\": \"2026-08-28T00:27:12.000000Z\", \"updated_at\": \"2026-08-28T00:27:12.000000Z\", \"description\": \"Delete flash sale campaigns\"}, {\"id\": 42, \"name\": \"View Frontend Contents\", \"slug\": \"frontend_contents.view\", \"group\": \"frontend_contents\", \"pivot\": {\"role_id\": 3, \"permission_id\": 42}, \"created_at\": \"2026-08-28T00:27:12.000000Z\", \"updated_at\": \"2026-08-28T00:27:12.000000Z\", \"description\": \"View landing page sections and content\"}, {\"id\": 43, \"name\": \"Create Frontend Contents\", \"slug\": \"frontend_contents.create\", \"group\": \"frontend_contents\", \"pivot\": {\"role_id\": 3, \"permission_id\": 43}, \"created_at\": \"2026-08-28T00:27:12.000000Z\", \"updated_at\": \"2026-08-28T00:27:12.000000Z\", \"description\": \"Create new landing page content blocks\"}, {\"id\": 44, \"name\": \"Edit Frontend Contents\", \"slug\": \"frontend_contents.edit\", \"group\": \"frontend_contents\", \"pivot\": {\"role_id\": 3, \"permission_id\": 44}, \"created_at\": \"2026-08-28T00:27:12.000000Z\", \"updated_at\": \"2026-08-28T00:27:12.000000Z\", \"description\": \"Update landing page content blocks\"}, {\"id\": 45, \"name\": \"Delete Frontend Contents\", \"slug\": \"frontend_contents.delete\", \"group\": \"frontend_contents\", \"pivot\": {\"role_id\": 3, \"permission_id\": 45}, \"created_at\": \"2026-08-28T00:27:12.000000Z\", \"updated_at\": \"2026-08-28T00:27:12.000000Z\", \"description\": \"Delete landing page content blocks\"}, {\"id\": 46, \"name\": \"View Support Tickets\", \"slug\": \"tickets.view\", \"group\": \"tickets\", \"pivot\": {\"role_id\": 3, \"permission_id\": 46}, \"created_at\": \"2026-08-28T00:27:12.000000Z\", \"updated_at\": \"2026-08-28T00:27:12.000000Z\", \"description\": \"View customer support tickets\"}, {\"id\": 47, \"name\": \"Reply Support Tickets\", \"slug\": \"tickets.reply\", \"group\": \"tickets\", \"pivot\": {\"role_id\": 3, \"permission_id\": 47}, \"created_at\": \"2026-08-28T00:27:12.000000Z\", \"updated_at\": \"2026-08-28T00:27:12.000000Z\", \"description\": \"Reply to and close customer support tickets\"}, {\"id\": 48, \"name\": \"View Settings\", \"slug\": \"settings.view\", \"group\": \"settings\", \"pivot\": {\"role_id\": 3, \"permission_id\": 48}, \"created_at\": \"2026-08-28T00:27:12.000000Z\", \"updated_at\": \"2026-08-28T00:27:12.000000Z\", \"description\": \"View platform global settings\"}, {\"id\": 49, \"name\": \"Manage Settings\", \"slug\": \"settings.manage\", \"group\": \"settings\", \"pivot\": {\"role_id\": 3, \"permission_id\": 49}, \"created_at\": \"2026-08-28T00:27:12.000000Z\", \"updated_at\": \"2026-08-28T00:27:12.000000Z\", \"description\": \"Modify system settings, SEO, and maintenance mode\"}, {\"id\": 50, \"name\": \"View Customers\", \"slug\": \"customers.view\", \"group\": \"customers\", \"pivot\": {\"role_id\": 3, \"permission_id\": 50}, \"created_at\": \"2026-08-28T00:27:12.000000Z\", \"updated_at\": \"2026-08-28T00:27:12.000000Z\", \"description\": \"View buyer profiles and activity\"}, {\"id\": 51, \"name\": \"Manage Customers\", \"slug\": \"customers.manage\", \"group\": \"customers\", \"pivot\": {\"role_id\": 3, \"permission_id\": 51}, \"created_at\": \"2026-08-28T00:27:12.000000Z\", \"updated_at\": \"2026-08-28T00:27:12.000000Z\", \"description\": \"Update buyer active status\"}, {\"id\": 52, \"name\": \"Delete Customers\", \"slug\": \"customers.delete\", \"group\": \"customers\", \"pivot\": {\"role_id\": 3, \"permission_id\": 52}, \"created_at\": \"2026-08-28T00:27:12.000000Z\", \"updated_at\": \"2026-08-28T00:27:12.000000Z\", \"description\": \"Delete buyer accounts\"}, {\"id\": 53, \"name\": \"View Sellers\", \"slug\": \"sellers.view\", \"group\": \"sellers\", \"pivot\": {\"role_id\": 3, \"permission_id\": 53}, \"created_at\": \"2026-08-28T00:27:12.000000Z\", \"updated_at\": \"2026-08-28T00:27:12.000000Z\", \"description\": \"View seller profiles, products, and metrics\"}, {\"id\": 54, \"name\": \"Manage Sellers\", \"slug\": \"sellers.manage\", \"group\": \"sellers\", \"pivot\": {\"role_id\": 3, \"permission_id\": 54}, \"created_at\": \"2026-08-28T00:27:12.000000Z\", \"updated_at\": \"2026-08-28T00:27:12.000000Z\", \"description\": \"Update seller active/disabled status\"}, {\"id\": 55, \"name\": \"View Roles\", \"slug\": \"roles.view\", \"group\": \"roles\", \"pivot\": {\"role_id\": 3, \"permission_id\": 55}, \"created_at\": \"2026-08-28T00:27:12.000000Z\", \"updated_at\": \"2026-08-28T00:27:12.000000Z\", \"description\": \"View system roles and permission matrices\"}, {\"id\": 56, \"name\": \"Manage Roles\", \"slug\": \"roles.manage\", \"group\": \"roles\", \"pivot\": {\"role_id\": 3, \"permission_id\": 56}, \"created_at\": \"2026-08-28T00:27:12.000000Z\", \"updated_at\": \"2026-08-28T00:27:12.000000Z\", \"description\": \"Create and modify system roles and permissions\"}, {\"id\": 57, \"name\": \"View Staff\", \"slug\": \"staff.view\", \"group\": \"staff\", \"pivot\": {\"role_id\": 3, \"permission_id\": 57}, \"created_at\": \"2026-08-28T00:27:12.000000Z\", \"updated_at\": \"2026-08-28T00:27:12.000000Z\", \"description\": \"View administrative staff user list\"}, {\"id\": 58, \"name\": \"Manage Staff\", \"slug\": \"staff.manage\", \"group\": \"staff\", \"pivot\": {\"role_id\": 3, \"permission_id\": 58}, \"created_at\": \"2026-08-28T00:27:12.000000Z\", \"updated_at\": \"2026-08-28T00:27:12.000000Z\", \"description\": \"Invite, update, reset password, and change staff roles\"}, {\"id\": 59, \"name\": \"Delete Staff\", \"slug\": \"staff.delete\", \"group\": \"staff\", \"pivot\": {\"role_id\": 3, \"permission_id\": 59}, \"created_at\": \"2026-08-28T00:27:12.000000Z\", \"updated_at\": \"2026-08-28T00:27:12.000000Z\", \"description\": \"Delete administrative staff user accounts\"}, {\"id\": 60, \"name\": \"View Audit Logs\", \"slug\": \"audit_logs.view\", \"group\": \"audit_logs\", \"pivot\": {\"role_id\": 3, \"permission_id\": 60}, \"created_at\": \"2026-08-28T00:27:12.000000Z\", \"updated_at\": \"2026-08-28T00:27:12.000000Z\", \"description\": \"View system audit trail logs\"}]}', '2026-09-07 13:10:04', '2026-09-07 13:10:04'),
(179, 1, NULL, 'update_general_settings', 'Updated system general settings (site name, email, phone, currency).', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, '{\"site_name\": \"Market My Art Platform\", \"site_email\": \"support@marketmyart.com\", \"site_phone\": \"+23480000011113\", \"site_currency\": \"NGN\", \"currency_symbol\": \"₦\"}', '{\"site_name\": \"Market My Art Platform\", \"site_email\": \"support@marketmyart.com\", \"site_phone\": \"+23480000011113\", \"site_currency\": \"NGN\", \"currency_symbol\": \"₦\"}', '2026-09-07 13:11:36', '2026-09-07 13:11:36'),
(180, 1, NULL, 'update_general_settings', 'Updated system general settings (site name, email, phone, currency, and/or logo).', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, '{\"logo\": \"1\", \"site_name\": \"Market My Art Platform\", \"site_email\": \"support@marketmyart.com\", \"site_phone\": \"+23480000011113\", \"site_currency\": \"NGN\", \"currency_symbol\": \"₦\"}', '{\"logo\": \"logos/tD7ApjHSszvgeBzkZVHhgyPRtUSfpzuifo7rUv46.jpg\", \"site_name\": \"Market My Art Platform\", \"site_email\": \"support@marketmyart.com\", \"site_phone\": \"+23480000011113\", \"site_currency\": \"NGN\", \"currency_symbol\": \"₦\"}', '2026-09-07 18:05:46', '2026-09-07 18:05:46'),
(181, 1, NULL, 'update_general_settings', 'Updated system general settings (site name, email, phone, currency, and/or logo).', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, '{\"logo\": \"logos/tD7ApjHSszvgeBzkZVHhgyPRtUSfpzuifo7rUv46.jpg\", \"site_name\": \"Market My Art Platform\", \"site_email\": \"support@marketmyart.com\", \"site_phone\": \"+23480000011113\", \"site_currency\": \"NGN\", \"currency_symbol\": \"₦\"}', '{\"logo\": \"logos/EmCCVz6BcNkdgZgimDbsnkwjwK53DzoMssAX8pBQ.png\", \"site_name\": \"Market My Art Platform\", \"site_email\": \"support@marketmyart.com\", \"site_phone\": \"+23480000011113\", \"site_currency\": \"NGN\", \"currency_symbol\": \"₦\"}', '2026-09-07 18:15:46', '2026-09-07 18:15:46');

-- --------------------------------------------------------

--
-- Table structure for table `blogs`
--

CREATE TABLE `blogs` (
  `id` bigint UNSIGNED NOT NULL,
  `title` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `slug` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `body` longtext COLLATE utf8mb4_general_ci NOT NULL,
  `image` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `status` tinyint(1) DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `brands`
--

CREATE TABLE `brands` (
  `id` bigint UNSIGNED NOT NULL,
  `name` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `slug` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `logo` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` enum('inactive','active') COLLATE utf8mb4_unicode_ci DEFAULT 'active',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `brands`
--

INSERT INTO `brands` (`id`, `name`, `slug`, `logo`, `status`, `created_at`, `updated_at`) VALUES
(4, 'Adire Lagos', 'adire-lagos', 'brands/2026/09/eb6b22bb-8dcf-42bc-b399-911c2e75381b_1788708817.webp', 'active', '2026-09-06 14:33:37', '2026-09-06 14:33:37');

-- --------------------------------------------------------

--
-- Table structure for table `carts`
--

CREATE TABLE `carts` (
  `id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED DEFAULT NULL COMMENT 'Null for guest carts',
  `guest_token` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Guest user cookie/session tracker',
  `coupon_code` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Applied promo code if any',
  `subtotal` decimal(12,2) NOT NULL DEFAULT '0.00',
  `discount_amount` decimal(12,2) NOT NULL DEFAULT '0.00',
  `grand_total` decimal(12,2) NOT NULL DEFAULT '0.00',
  `status` enum('active','converted','abandoned') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'active',
  `abandoned_notification_sent_at` timestamp NULL DEFAULT NULL COMMENT 'Tracks when recovery email was sent',
  `recovered_at` timestamp NULL DEFAULT NULL COMMENT 'Tracks when user eventually completes checkout',
  `last_activity_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Key for 24h lookup',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `carts`
--

INSERT INTO `carts` (`id`, `user_id`, `guest_token`, `coupon_code`, `subtotal`, `discount_amount`, `grand_total`, `status`, `abandoned_notification_sent_at`, `recovered_at`, `last_activity_at`, `created_at`, `updated_at`) VALUES
(155, 1, NULL, NULL, 3199.99, 0.00, 3199.99, 'active', NULL, NULL, '2026-09-08 04:58:32', '2026-09-06 15:01:50', '2026-09-08 04:58:32'),
(156, 3, NULL, NULL, 199.99, 0.00, 199.99, 'active', NULL, NULL, '2026-09-07 20:57:53', '2026-09-07 19:56:18', '2026-09-07 19:57:53'),
(157, NULL, '0c67fd12-e1dc-423a-99d6-3da7b4ee2d10', NULL, 0.00, 0.00, 0.00, 'active', NULL, NULL, '2026-09-07 20:00:37', '2026-09-07 20:00:29', '2026-09-07 20:00:37'),
(158, NULL, '01d4d166-c0f1-4aec-8bf4-59ef2ffb522b', NULL, 0.00, 0.00, 0.00, 'active', NULL, NULL, '2026-09-08 10:17:56', '2026-09-08 10:11:45', '2026-09-08 10:17:56');

-- --------------------------------------------------------

--
-- Table structure for table `cart_items`
--

CREATE TABLE `cart_items` (
  `id` bigint UNSIGNED NOT NULL,
  `cart_id` bigint UNSIGNED NOT NULL,
  `product_id` bigint UNSIGNED NOT NULL,
  `seller_id` bigint UNSIGNED DEFAULT NULL COMMENT 'For multi-vendor cart tracking',
  `quantity` int UNSIGNED NOT NULL DEFAULT '1',
  `unit_price` decimal(10,2) NOT NULL DEFAULT '0.00',
  `total_price` decimal(12,2) NOT NULL DEFAULT '0.00',
  `variation_options` json DEFAULT NULL COMMENT 'Size, Color, etc.',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `cart_items`
--

INSERT INTO `cart_items` (`id`, `cart_id`, `product_id`, `seller_id`, `quantity`, `unit_price`, `total_price`, `variation_options`, `created_at`, `updated_at`) VALUES
(74, 155, 11, NULL, 2, 199.99, 399.98, NULL, '2026-09-07 18:35:51', '2026-09-08 04:58:32'),
(75, 155, 17, NULL, 1, 3000.00, 3000.00, NULL, '2026-09-07 18:52:38', '2026-09-07 18:52:38'),
(76, 156, 10, NULL, 1, 199.99, 199.99, NULL, '2026-09-07 19:56:27', '2026-09-07 19:56:27'),
(77, 157, 15, NULL, 1, 122.00, 122.00, NULL, '2026-09-07 20:00:29', '2026-09-07 20:00:29'),
(78, 157, 14, NULL, 1, 1000.00, 1000.00, NULL, '2026-09-07 20:00:37', '2026-09-07 20:00:37'),
(79, 155, 12, NULL, 1, 100.00, 100.00, NULL, '2026-09-07 20:03:43', '2026-09-07 20:03:43'),
(80, 155, 16, NULL, 2, 2000.00, 4000.00, NULL, '2026-09-07 20:04:49', '2026-09-07 20:04:49'),
(81, 158, 16, NULL, 4, 2000.00, 8000.00, NULL, '2026-09-08 10:17:56', '2026-09-08 10:17:56');

-- --------------------------------------------------------

--
-- Table structure for table `categories`
--

CREATE TABLE `categories` (
  `id` bigint UNSIGNED NOT NULL,
  `name` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `slug` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `icon` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `banner` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `priority` int DEFAULT '0',
  `status` enum('inactive','active') COLLATE utf8mb4_unicode_ci DEFAULT 'active',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `categories`
--

INSERT INTO `categories` (`id`, `name`, `slug`, `icon`, `banner`, `priority`, `status`, `created_at`, `updated_at`) VALUES
(1, 'Art & Paintings', 'art-and-paintings', 'categories/icons/2026/09/ad43e3b5-2269-4ce5-ae92-207dae4a23cc_1788510513.webp', NULL, 1, 'active', '2026-09-03 16:26:15', '2026-09-04 07:28:33'),
(2, 'Sculptures & 3D Art', 'sculptures-and-3d-art', 'categories/icons/2026/09/707c35a2-df00-4d56-a316-042d8c4faf84_1788510595.webp', NULL, 2, 'active', '2026-09-03 16:26:15', '2026-09-04 07:29:55'),
(3, 'Home Décor & Interior', 'home-decor-and-interior', 'categories/icons/2026/09/e08d04f0-3371-4d9d-b30d-3a9f81e93abf_1788510627.webp', NULL, 3, 'active', '2026-09-03 16:26:15', '2026-09-04 07:30:27'),
(4, 'Furniture & Woodcraft', 'furniture-and-woodcraft', 'categories/icons/2026/09/c8f11ec4-b572-4c93-94db-313c97d5703b_1788511308.webp', NULL, 4, 'active', '2026-09-03 16:26:15', '2026-09-04 07:41:48'),
(5, 'Fashion & Textiles', 'fashion-and-textiles', 'categories/icons/2026/09/23305ab1-488b-4280-b491-31c28cb30b04_1788510695.webp', NULL, 5, 'active', '2026-09-03 16:26:15', '2026-09-04 07:31:35'),
(6, 'Jewellery & Accessories', 'jewellery-and-accessories', 'categories/icons/2026/09/03e3515d-a1c4-49eb-bee7-24dfffcc7147_1788510729.webp', NULL, 6, 'active', '2026-09-03 16:26:15', '2026-09-04 07:32:09'),
(7, 'Bags, Shoes & Leather', 'bags-shoes-and-leather', 'categories/icons/2026/09/5a6d9415-b2f8-4075-bd47-558665472300_1788510763.webp', NULL, 7, 'active', '2026-09-03 16:26:15', '2026-09-04 07:32:43'),
(8, 'Pottery, Ceramics & Glass', 'pottery-ceramics-and-glass', 'categories/icons/2026/09/6b4a5c94-422b-4130-978c-d3f8558470d9_1788510786.webp', NULL, 8, 'active', '2026-09-03 16:26:15', '2026-09-04 07:33:06'),
(9, 'Baskets, Fibre & Natural Crafts', 'baskets-fibre-and-natural-crafts', 'categories/icons/2026/09/17bcc9cf-e109-4634-a63d-6330ba53f731_1788510815.webp', NULL, 9, 'active', '2026-09-03 16:26:15', '2026-09-04 07:33:35'),
(10, 'Gifts, Souvenirs & Events', 'gifts-souvenirs-and-events', 'categories/icons/2026/09/b5b5763b-8618-4e2e-81bc-25c8d457ecf4_1788510973.webp', NULL, 10, 'active', '2026-09-03 16:26:15', '2026-09-04 07:36:13'),
(11, 'Cultural, Traditional & Collectibles', 'cultural-traditional-and-collectibles', 'categories/icons/2026/09/fd52a6d0-eb34-4fe5-b203-4d05fe843749_1788511007.webp', NULL, 11, 'active', '2026-09-03 16:26:15', '2026-09-04 07:36:47'),
(12, 'Toys, Lifestyle & Other Crafts', 'toys-lifestyle-and-other-crafts', 'categories/icons/2026/09/0ec421c3-666d-4328-8d78-892b48a15cd0_1788511034.webp', NULL, 12, 'active', '2026-09-03 16:26:15', '2026-09-04 07:37:14'),
(13, 'Custom Art & Creative Services', 'custom-art-and-creative-services', 'categories/icons/2026/09/2a26290c-688a-438c-93fb-81b9cfbf0a6d_1788511075.webp', NULL, 13, 'active', '2026-09-03 16:26:15', '2026-09-04 07:37:55'),
(14, 'Music', 'music', 'categories/icons/2026/09/acd159ea-fb9f-4d74-a753-2ccbf461c8a3_1788511274.webp', NULL, 14, 'active', '2026-09-03 16:26:15', '2026-09-04 07:41:14');

-- --------------------------------------------------------

--
-- Table structure for table `coupons`
--

CREATE TABLE `coupons` (
  `id` bigint UNSIGNED NOT NULL,
  `name` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `code` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `discount_type` enum('flat','percentage') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'flat',
  `discount` decimal(10,2) NOT NULL DEFAULT '0.00',
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `product_ids` json DEFAULT NULL COMMENT 'Array of eligible product IDs',
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `coupons`
--

INSERT INTO `coupons` (`id`, `name`, `code`, `discount_type`, `discount`, `start_date`, `end_date`, `product_ids`, `is_active`, `created_at`, `updated_at`) VALUES
(1, 'Updated Summer Flash Sale', 'WELCOME10', 'percentage', 20.00, '2026-01-01', '2026-09-30', '[1, 2, 4]', 1, '2026-08-27 15:44:41', '2026-09-01 13:01:06'),
(3, 'VIP Tech Promo', 'VIPTECH15', 'percentage', 15.00, '2026-08-15', '2026-09-15', '[1, 2, 4, 7]', 1, '2026-08-27 15:44:41', '2026-08-27 15:44:41'),
(4, 'End of Season Sale', 'EOS2026', 'percentage', 20.00, '2026-09-01', '2026-09-30', '[1, 2, 4, 7]', 1, '2026-08-27 15:44:41', '2026-08-27 15:44:41'),
(5, 'Mega Saver Flat', 'MEGASAVE2000', 'flat', 2000.00, '2026-08-20', '2026-09-10', '[1, 2, 4, 7]', 1, '2026-08-27 15:44:41', '2026-08-27 15:44:41'),
(6, 'Mid-Year Deal', 'MIDYEAR25', 'percentage', 25.00, '2026-06-01', '2026-07-31', '[1, 2, 4, 7]', 1, '2026-08-27 15:44:41', '2026-09-01 13:08:26'),
(7, 'Super September', 'SUPERSEP', 'flat', 1500.00, '2026-09-01', '2026-09-20', '[1, 2, 4, 7]', 1, '2026-08-27 15:44:41', '2026-08-27 15:44:41'),
(8, 'Black Friday Early', 'BFEARLY30', 'percentage', 30.00, '2026-11-01', '2026-11-15', '[1, 2, 4, 7]', 1, '2026-08-27 15:44:41', '2026-08-27 15:44:41'),
(9, 'Weekend Special', 'WEEKEND500', 'flat', 500.00, '2026-08-28', '2026-08-31', '[1, 2, 4, 7]', 0, '2026-08-27 15:44:41', '2026-09-01 13:08:24'),
(10, 'Loyalty Discount', 'LOYAL5', 'percentage', 5.00, '2026-01-01', '2026-12-31', '[1, 2, 4, 7]', 1, '2026-08-27 15:44:41', '2026-08-27 15:44:41'),
(11, 'Back to School', 'BACK2SCHOOL', 'flat', 1000.00, '2026-08-15', '2026-09-15', '[1, 2, 4, 7]', 1, '2026-08-27 15:44:41', '2026-08-27 15:44:41'),
(12, 'Clearance Blowout', 'CLEAR40', 'percentage', 40.00, '2026-08-01', '2026-08-25', '[1, 2, 4, 7]', 0, '2026-08-27 15:44:41', '2026-08-27 15:44:41'),
(17, 'Store Anniversary', 'ANNIV22', 'percentage', 22.00, '2026-10-10', '2026-10-20', '[1, 2, 4, 7]', 1, '2026-08-27 15:44:41', '2026-08-27 15:44:41'),
(18, 'Quick Saver', 'QUICK8', 'percentage', 8.00, '2026-08-20', '2026-09-20', '[1, 2, 4, 7]', 1, '2026-08-27 15:44:41', '2026-08-27 15:44:41'),
(19, 'Mega Flat Bonus', 'FLAT2500', 'flat', 2500.00, '2026-09-15', '2026-10-15', '[1, 2, 4, 7]', 1, '2026-08-27 15:44:41', '2026-08-27 15:44:41'),
(20, 'Year End Special', 'YEAREND50', 'percentage', 50.00, '2026-12-20', '2026-12-31', '[1, 2, 4, 7]', 1, '2026-08-27 15:44:41', '2026-08-27 15:44:41'),
(23, 'Hello', 'WILLOW', 'percentage', 1.00, '2026-09-23', '2026-09-30', '[8]', 1, '2026-09-01 13:25:29', '2026-09-01 13:32:10'),
(24, 'Valentine\'s Day', 'VAL2026', 'percentage', 9.85, '2026-09-01', '2026-09-30', '[14, 13, 12]', 1, '2026-09-06 14:46:20', '2026-09-06 14:46:34');

-- --------------------------------------------------------

--
-- Table structure for table `failed_jobs`
--

CREATE TABLE `failed_jobs` (
  `id` bigint UNSIGNED NOT NULL,
  `uuid` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `connection` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `queue` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `exception` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `flash_sales`
--

CREATE TABLE `flash_sales` (
  `id` bigint UNSIGNED NOT NULL,
  `title` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `start_date` datetime NOT NULL,
  `end_date` datetime NOT NULL,
  `discount_type` enum('flat','percentage') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'percentage',
  `discount` decimal(10,2) NOT NULL DEFAULT '0.00',
  `product_ids` json DEFAULT NULL COMMENT 'Array of eligible product IDs',
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `flash_sales`
--

INSERT INTO `flash_sales` (`id`, `title`, `start_date`, `end_date`, `discount_type`, `discount`, `product_ids`, `is_active`, `created_at`, `updated_at`) VALUES
(2, 'Updated Midnight Flash Sale', '2026-09-01 00:00:00', '2026-09-24 23:59:59', 'flat', 40.00, '[1, 7]', 1, '2026-09-01 13:56:27', '2026-09-01 14:03:43'),
(3, 'Best', '2026-09-02 00:00:00', '2026-09-25 23:59:59', 'percentage', 10.00, '[13, 14, 12]', 1, '2026-09-06 14:47:31', '2026-09-06 14:47:31');

-- --------------------------------------------------------

--
-- Table structure for table `frontend_contents`
--

CREATE TABLE `frontend_contents` (
  `id` bigint UNSIGNED NOT NULL,
  `component` enum('slider','banner','faq','terms','policy','hero','testimonial','feature','about_us') COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` enum('image','text','question','multi') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'text',
  `slug` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `value` longtext COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Contains raw text, HTML content, or image URL/path',
  `status` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `frontend_contents`
--

INSERT INTO `frontend_contents` (`id`, `component`, `type`, `slug`, `value`, `status`, `created_at`, `updated_at`) VALUES
(3, 'about_us', 'text', 'about-us', 'We need to be here now now now now', 1, '2026-09-01 14:57:46', '2026-09-01 14:57:46'),
(4, 'about_us', 'image', 'prime', 'http://localhost/mma/storage/frontend/acSdrqmfQu8h8Od2QzUron9MghmaSmzgYfX7zcLm.png', 1, '2026-09-01 14:59:46', '2026-09-01 14:59:46'),
(5, 'slider', 'image', 'home-banner', 'http://localhost/mma/storage/frontend/93KnA8Ybhvm8910w27v0jZPNQaT6WhGKVOg20IYN.png', 1, '2026-09-04 10:46:20', '2026-09-04 10:46:20'),
(7, 'faq', 'question', 'faq', '[{\"question\":\"How long does my order take\",\"answer\":\"Most orders arrive within 1-3 business days depending on your location and the vendor you order from. Express delivery is available at checkout for select areas.\\n\"},{\"question\":\"Can i return a defaulted order ?\",\"answer\":\"Yes, we offer a 14-day return policy on most items. Perishable goods must be reported within 24 hours of delivery for a refund or replacement.\"},{\"question\":\"Do you support multi vendor order ?\",\"answer\":\"Absolutely. Storly is a multi-vendor marketplace, so your cart can contain items from several sellers, each shipped and tracked separately.\\n\"}]', 1, '2026-09-05 14:32:50', '2026-09-05 14:33:09'),
(8, 'policy', 'text', 'policy', 'Information We Collect\nWe collect account login credentials, billing and payment information, and delivery details you provide when creating an account or placing an order. We also automatically collect device, browser, and IP address information, along with cookies and usage analytics data to help us improve the platform.\n\nHow We Use Your Information\nYour information is used to process orders, provide customer support, personalize your shopping experience, analyze traffic and performance, and run fraud prevention checks. We never sell your personal data to third parties.\n\nWho We Share Data With\nWe share only what\'s necessary with delivery and logistics partners, payment processors, analytics providers, and customer support tools — each bound by strict data protection agreements.\n\nYour Rights\nYou can access your personal data, request corrections, or delete your account at any time from your dashboard settings. Contact our support team if you need help exercising any of these rights.\n\nCookies\nWe use cookies to keep you signed in, remember your cart, and understand how our storefront is used so we can keep improving it.', 1, '2026-09-05 14:48:15', '2026-09-05 14:48:15'),
(9, 'terms', 'text', 'terms', 'Account Responsibilities\nYou\'re responsible for maintaining the confidentiality of your account login credentials and for all activity under your account. Notify us immediately of any unauthorized access.\n\nAcceptable Use\nYou agree not to attempt unauthorized access to our systems, abuse promotional offers or discount codes, or use the marketplace for any unlawful purpose.\n\nOrders & Delivery\nDelivery dates shown at checkout are estimates, not guarantees. While we work closely with our delivery and logistics partners to minimize delayed deliveries, occasional delays can occur due to circumstances outside our control.\n\nVendor Marketplace\nStorly is a multi-vendor marketplace. Individual vendors are responsible for the accuracy of their own product listings, pricing, and fulfillment, though we monitor for quality and genuine reviews across the platform.\n\nChanges to These Terms\nWe may update these terms from time to time. Continued use of the platform after changes are posted constitutes acceptance of the revised terms.', 1, '2026-09-05 15:02:24', '2026-09-05 15:02:24');

-- --------------------------------------------------------

--
-- Table structure for table `jobs`
--

CREATE TABLE `jobs` (
  `id` bigint UNSIGNED NOT NULL,
  `queue` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `attempts` tinyint UNSIGNED NOT NULL,
  `reserved_at` int UNSIGNED DEFAULT NULL,
  `available_at` int UNSIGNED NOT NULL,
  `created_at` int UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `jobs`
--

INSERT INTO `jobs` (`id`, `queue`, `payload`, `attempts`, `reserved_at`, `available_at`, `created_at`) VALUES
(1, 'default', '{\"uuid\":\"48f68a86-e815-4fd0-90e7-e9460cd625c7\",\"displayName\":\"App\\\\Notifications\\\\StaffInvitationNotification\",\"job\":\"Illuminate\\\\Queue\\\\CallQueuedHandler@call\",\"maxTries\":null,\"maxExceptions\":null,\"failOnTimeout\":false,\"backoff\":null,\"timeout\":null,\"retryUntil\":null,\"data\":{\"commandName\":\"Illuminate\\\\Notifications\\\\SendQueuedNotifications\",\"command\":\"O:48:\\\"Illuminate\\\\Notifications\\\\SendQueuedNotifications\\\":3:{s:11:\\\"notifiables\\\";O:45:\\\"Illuminate\\\\Contracts\\\\Database\\\\ModelIdentifier\\\":5:{s:5:\\\"class\\\";s:15:\\\"App\\\\Models\\\\User\\\";s:2:\\\"id\\\";a:1:{i:0;i:46;}s:9:\\\"relations\\\";a:0:{}s:10:\\\"connection\\\";s:5:\\\"mysql\\\";s:15:\\\"collectionClass\\\";N;}s:12:\\\"notification\\\";O:45:\\\"App\\\\Notifications\\\\StaffInvitationNotification\\\":2:{s:11:\\\"credentials\\\";a:4:{s:4:\\\"name\\\";s:8:\\\"John Doe\\\";s:5:\\\"email\\\";s:31:\\\"adetunjioluwakayode@gmail.comws\\\";s:8:\\\"password\\\";s:12:\\\"RP2ewXJIUMJo\\\";s:5:\\\"token\\\";s:40:\\\"w6vp8veIuc1qvxLhbX709kxsUqGeObQxDRdlGHBZ\\\";}s:2:\\\"id\\\";s:36:\\\"d1c1752e-39f1-4923-ba5d-7ada15828fa3\\\";}s:8:\\\"channels\\\";a:1:{i:0;s:4:\\\"mail\\\";}}\"},\"createdAt\":1788172852,\"delay\":null}', 0, NULL, 1788172852, 1788172852),
(2, 'default', '{\"uuid\":\"cc8d2d32-b5df-4233-9f4e-c2f095a5941c\",\"displayName\":\"App\\\\Notifications\\\\CustomerMail\",\"job\":\"Illuminate\\\\Queue\\\\CallQueuedHandler@call\",\"maxTries\":null,\"maxExceptions\":null,\"failOnTimeout\":false,\"backoff\":null,\"timeout\":null,\"retryUntil\":null,\"data\":{\"commandName\":\"Illuminate\\\\Notifications\\\\SendQueuedNotifications\",\"command\":\"O:48:\\\"Illuminate\\\\Notifications\\\\SendQueuedNotifications\\\":3:{s:11:\\\"notifiables\\\";O:45:\\\"Illuminate\\\\Contracts\\\\Database\\\\ModelIdentifier\\\":5:{s:5:\\\"class\\\";s:15:\\\"App\\\\Models\\\\User\\\";s:2:\\\"id\\\";a:1:{i:0;i:3;}s:9:\\\"relations\\\";a:0:{}s:10:\\\"connection\\\";s:5:\\\"mysql\\\";s:15:\\\"collectionClass\\\";N;}s:12:\\\"notification\\\";O:30:\\\"App\\\\Notifications\\\\CustomerMail\\\":3:{s:7:\\\"subject\\\";s:5:\\\"Hello\\\";s:14:\\\"messageContent\\\";s:11:\\\"We dey here\\\";s:2:\\\"id\\\";s:36:\\\"ef98dfc7-c909-462a-ab34-095a97b20574\\\";}s:8:\\\"channels\\\";a:1:{i:0;s:4:\\\"mail\\\";}}\"},\"createdAt\":1788192817,\"delay\":null}', 0, NULL, 1788192817, 1788192817),
(3, 'default', '{\"uuid\":\"45811ac7-2902-4fb4-97d0-ff94422624b7\",\"displayName\":\"App\\\\Notifications\\\\OrderSuccessfulNotification\",\"job\":\"Illuminate\\\\Queue\\\\CallQueuedHandler@call\",\"maxTries\":null,\"maxExceptions\":null,\"failOnTimeout\":false,\"backoff\":null,\"timeout\":null,\"retryUntil\":null,\"data\":{\"commandName\":\"Illuminate\\\\Notifications\\\\SendQueuedNotifications\",\"command\":\"O:48:\\\"Illuminate\\\\Notifications\\\\SendQueuedNotifications\\\":3:{s:11:\\\"notifiables\\\";O:45:\\\"Illuminate\\\\Contracts\\\\Database\\\\ModelIdentifier\\\":5:{s:5:\\\"class\\\";s:15:\\\"App\\\\Models\\\\User\\\";s:2:\\\"id\\\";a:1:{i:0;i:3;}s:9:\\\"relations\\\";a:0:{}s:10:\\\"connection\\\";s:5:\\\"mysql\\\";s:15:\\\"collectionClass\\\";N;}s:12:\\\"notification\\\";O:45:\\\"App\\\\Notifications\\\\OrderSuccessfulNotification\\\":2:{s:5:\\\"order\\\";O:45:\\\"Illuminate\\\\Contracts\\\\Database\\\\ModelIdentifier\\\":5:{s:5:\\\"class\\\";s:16:\\\"App\\\\Models\\\\Order\\\";s:2:\\\"id\\\";i:36;s:9:\\\"relations\\\";a:1:{i:0;s:4:\\\"user\\\";}s:10:\\\"connection\\\";s:5:\\\"mysql\\\";s:15:\\\"collectionClass\\\";N;}s:2:\\\"id\\\";s:36:\\\"ec5be028-673f-4e66-9098-29cf56e82d81\\\";}s:8:\\\"channels\\\";a:1:{i:0;s:4:\\\"mail\\\";}}\"},\"createdAt\":1788614944,\"delay\":null}', 0, NULL, 1788614944, 1788614944),
(4, 'default', '{\"uuid\":\"5ee27bb2-6bbe-42e2-b719-2442d89d26b1\",\"displayName\":\"App\\\\Notifications\\\\OrderSuccessfulNotification\",\"job\":\"Illuminate\\\\Queue\\\\CallQueuedHandler@call\",\"maxTries\":null,\"maxExceptions\":null,\"failOnTimeout\":false,\"backoff\":null,\"timeout\":null,\"retryUntil\":null,\"data\":{\"commandName\":\"Illuminate\\\\Notifications\\\\SendQueuedNotifications\",\"command\":\"O:48:\\\"Illuminate\\\\Notifications\\\\SendQueuedNotifications\\\":3:{s:11:\\\"notifiables\\\";O:45:\\\"Illuminate\\\\Contracts\\\\Database\\\\ModelIdentifier\\\":5:{s:5:\\\"class\\\";s:15:\\\"App\\\\Models\\\\User\\\";s:2:\\\"id\\\";a:1:{i:0;i:3;}s:9:\\\"relations\\\";a:0:{}s:10:\\\"connection\\\";s:5:\\\"mysql\\\";s:15:\\\"collectionClass\\\";N;}s:12:\\\"notification\\\";O:45:\\\"App\\\\Notifications\\\\OrderSuccessfulNotification\\\":2:{s:5:\\\"order\\\";O:45:\\\"Illuminate\\\\Contracts\\\\Database\\\\ModelIdentifier\\\":5:{s:5:\\\"class\\\";s:16:\\\"App\\\\Models\\\\Order\\\";s:2:\\\"id\\\";i:36;s:9:\\\"relations\\\";a:1:{i:0;s:4:\\\"user\\\";}s:10:\\\"connection\\\";s:5:\\\"mysql\\\";s:15:\\\"collectionClass\\\";N;}s:2:\\\"id\\\";s:36:\\\"c68e7943-8ea8-4d73-80f7-3ec72d29558d\\\";}s:8:\\\"channels\\\";a:1:{i:0;s:4:\\\"mail\\\";}}\"},\"createdAt\":1788615627,\"delay\":null}', 0, NULL, 1788615627, 1788615627),
(5, 'default', '{\"uuid\":\"0d44f4cc-76b5-49e3-aac8-199c574a85b7\",\"displayName\":\"App\\\\Notifications\\\\OrderSuccessfulNotification\",\"job\":\"Illuminate\\\\Queue\\\\CallQueuedHandler@call\",\"maxTries\":null,\"maxExceptions\":null,\"failOnTimeout\":false,\"backoff\":null,\"timeout\":null,\"retryUntil\":null,\"data\":{\"commandName\":\"Illuminate\\\\Notifications\\\\SendQueuedNotifications\",\"command\":\"O:48:\\\"Illuminate\\\\Notifications\\\\SendQueuedNotifications\\\":3:{s:11:\\\"notifiables\\\";O:45:\\\"Illuminate\\\\Contracts\\\\Database\\\\ModelIdentifier\\\":5:{s:5:\\\"class\\\";s:15:\\\"App\\\\Models\\\\User\\\";s:2:\\\"id\\\";a:1:{i:0;i:3;}s:9:\\\"relations\\\";a:0:{}s:10:\\\"connection\\\";s:5:\\\"mysql\\\";s:15:\\\"collectionClass\\\";N;}s:12:\\\"notification\\\";O:45:\\\"App\\\\Notifications\\\\OrderSuccessfulNotification\\\":2:{s:5:\\\"order\\\";O:45:\\\"Illuminate\\\\Contracts\\\\Database\\\\ModelIdentifier\\\":5:{s:5:\\\"class\\\";s:16:\\\"App\\\\Models\\\\Order\\\";s:2:\\\"id\\\";i:37;s:9:\\\"relations\\\";a:1:{i:0;s:4:\\\"user\\\";}s:10:\\\"connection\\\";s:5:\\\"mysql\\\";s:15:\\\"collectionClass\\\";N;}s:2:\\\"id\\\";s:36:\\\"b0d1164a-ae94-4021-9b6e-c7b28917b109\\\";}s:8:\\\"channels\\\";a:1:{i:0;s:4:\\\"mail\\\";}}\"},\"createdAt\":1788616507,\"delay\":null}', 0, NULL, 1788616507, 1788616507),
(6, 'default', '{\"uuid\":\"db2b0eb3-cf66-4e0d-a2cb-20bcccdde47f\",\"displayName\":\"App\\\\Notifications\\\\OrderSuccessfulNotification\",\"job\":\"Illuminate\\\\Queue\\\\CallQueuedHandler@call\",\"maxTries\":null,\"maxExceptions\":null,\"failOnTimeout\":false,\"backoff\":null,\"timeout\":null,\"retryUntil\":null,\"data\":{\"commandName\":\"Illuminate\\\\Notifications\\\\SendQueuedNotifications\",\"command\":\"O:48:\\\"Illuminate\\\\Notifications\\\\SendQueuedNotifications\\\":3:{s:11:\\\"notifiables\\\";O:45:\\\"Illuminate\\\\Contracts\\\\Database\\\\ModelIdentifier\\\":5:{s:5:\\\"class\\\";s:15:\\\"App\\\\Models\\\\User\\\";s:2:\\\"id\\\";a:1:{i:0;i:3;}s:9:\\\"relations\\\";a:0:{}s:10:\\\"connection\\\";s:5:\\\"mysql\\\";s:15:\\\"collectionClass\\\";N;}s:12:\\\"notification\\\";O:45:\\\"App\\\\Notifications\\\\OrderSuccessfulNotification\\\":2:{s:5:\\\"order\\\";O:45:\\\"Illuminate\\\\Contracts\\\\Database\\\\ModelIdentifier\\\":5:{s:5:\\\"class\\\";s:16:\\\"App\\\\Models\\\\Order\\\";s:2:\\\"id\\\";i:38;s:9:\\\"relations\\\";a:1:{i:0;s:4:\\\"user\\\";}s:10:\\\"connection\\\";s:5:\\\"mysql\\\";s:15:\\\"collectionClass\\\";N;}s:2:\\\"id\\\";s:36:\\\"40d77c06-60be-4624-971d-9fd8492628f9\\\";}s:8:\\\"channels\\\";a:1:{i:0;s:4:\\\"mail\\\";}}\"},\"createdAt\":1788617500,\"delay\":null}', 0, NULL, 1788617500, 1788617500),
(7, 'default', '{\"uuid\":\"40d81a9f-841e-46c2-93a9-1821c5ff983e\",\"displayName\":\"App\\\\Notifications\\\\OrderSuccessfulNotification\",\"job\":\"Illuminate\\\\Queue\\\\CallQueuedHandler@call\",\"maxTries\":null,\"maxExceptions\":null,\"failOnTimeout\":false,\"backoff\":null,\"timeout\":null,\"retryUntil\":null,\"data\":{\"commandName\":\"Illuminate\\\\Notifications\\\\SendQueuedNotifications\",\"command\":\"O:48:\\\"Illuminate\\\\Notifications\\\\SendQueuedNotifications\\\":3:{s:11:\\\"notifiables\\\";O:45:\\\"Illuminate\\\\Contracts\\\\Database\\\\ModelIdentifier\\\":5:{s:5:\\\"class\\\";s:15:\\\"App\\\\Models\\\\User\\\";s:2:\\\"id\\\";a:1:{i:0;i:3;}s:9:\\\"relations\\\";a:0:{}s:10:\\\"connection\\\";s:5:\\\"mysql\\\";s:15:\\\"collectionClass\\\";N;}s:12:\\\"notification\\\";O:45:\\\"App\\\\Notifications\\\\OrderSuccessfulNotification\\\":2:{s:5:\\\"order\\\";O:45:\\\"Illuminate\\\\Contracts\\\\Database\\\\ModelIdentifier\\\":5:{s:5:\\\"class\\\";s:16:\\\"App\\\\Models\\\\Order\\\";s:2:\\\"id\\\";i:39;s:9:\\\"relations\\\";a:1:{i:0;s:4:\\\"user\\\";}s:10:\\\"connection\\\";s:5:\\\"mysql\\\";s:15:\\\"collectionClass\\\";N;}s:2:\\\"id\\\";s:36:\\\"a333477d-9ec8-4a90-bedd-1ad0c716672a\\\";}s:8:\\\"channels\\\";a:1:{i:0;s:4:\\\"mail\\\";}}\"},\"createdAt\":1788617739,\"delay\":null}', 0, NULL, 1788617739, 1788617739),
(8, 'default', '{\"uuid\":\"d68427af-3bc6-4c90-a139-3d8b05eca1d1\",\"displayName\":\"App\\\\Notifications\\\\OrderSuccessfulNotification\",\"job\":\"Illuminate\\\\Queue\\\\CallQueuedHandler@call\",\"maxTries\":null,\"maxExceptions\":null,\"failOnTimeout\":false,\"backoff\":null,\"timeout\":null,\"retryUntil\":null,\"data\":{\"commandName\":\"Illuminate\\\\Notifications\\\\SendQueuedNotifications\",\"command\":\"O:48:\\\"Illuminate\\\\Notifications\\\\SendQueuedNotifications\\\":3:{s:11:\\\"notifiables\\\";O:45:\\\"Illuminate\\\\Contracts\\\\Database\\\\ModelIdentifier\\\":5:{s:5:\\\"class\\\";s:15:\\\"App\\\\Models\\\\User\\\";s:2:\\\"id\\\";a:1:{i:0;i:3;}s:9:\\\"relations\\\";a:0:{}s:10:\\\"connection\\\";s:5:\\\"mysql\\\";s:15:\\\"collectionClass\\\";N;}s:12:\\\"notification\\\";O:45:\\\"App\\\\Notifications\\\\OrderSuccessfulNotification\\\":2:{s:5:\\\"order\\\";O:45:\\\"Illuminate\\\\Contracts\\\\Database\\\\ModelIdentifier\\\":5:{s:5:\\\"class\\\";s:16:\\\"App\\\\Models\\\\Order\\\";s:2:\\\"id\\\";i:40;s:9:\\\"relations\\\";a:1:{i:0;s:4:\\\"user\\\";}s:10:\\\"connection\\\";s:5:\\\"mysql\\\";s:15:\\\"collectionClass\\\";N;}s:2:\\\"id\\\";s:36:\\\"95f8cfed-ed32-4fdc-93e7-a2236d2c4aa9\\\";}s:8:\\\"channels\\\";a:1:{i:0;s:4:\\\"mail\\\";}}\"},\"createdAt\":1788617962,\"delay\":null}', 0, NULL, 1788617962, 1788617962),
(9, 'default', '{\"uuid\":\"05451188-d2ea-4a22-99de-006d97a63ffb\",\"displayName\":\"App\\\\Notifications\\\\OrderSuccessfulNotification\",\"job\":\"Illuminate\\\\Queue\\\\CallQueuedHandler@call\",\"maxTries\":null,\"maxExceptions\":null,\"failOnTimeout\":false,\"backoff\":null,\"timeout\":null,\"retryUntil\":null,\"data\":{\"commandName\":\"Illuminate\\\\Notifications\\\\SendQueuedNotifications\",\"command\":\"O:48:\\\"Illuminate\\\\Notifications\\\\SendQueuedNotifications\\\":3:{s:11:\\\"notifiables\\\";O:45:\\\"Illuminate\\\\Contracts\\\\Database\\\\ModelIdentifier\\\":5:{s:5:\\\"class\\\";s:15:\\\"App\\\\Models\\\\User\\\";s:2:\\\"id\\\";a:1:{i:0;i:1;}s:9:\\\"relations\\\";a:0:{}s:10:\\\"connection\\\";s:5:\\\"mysql\\\";s:15:\\\"collectionClass\\\";N;}s:12:\\\"notification\\\";O:45:\\\"App\\\\Notifications\\\\OrderSuccessfulNotification\\\":2:{s:5:\\\"order\\\";O:45:\\\"Illuminate\\\\Contracts\\\\Database\\\\ModelIdentifier\\\":5:{s:5:\\\"class\\\";s:16:\\\"App\\\\Models\\\\Order\\\";s:2:\\\"id\\\";i:41;s:9:\\\"relations\\\";a:1:{i:0;s:4:\\\"user\\\";}s:10:\\\"connection\\\";s:5:\\\"mysql\\\";s:15:\\\"collectionClass\\\";N;}s:2:\\\"id\\\";s:36:\\\"0f8a6cb8-7b54-4ba5-abf1-b55c8f6b3a0c\\\";}s:8:\\\"channels\\\";a:1:{i:0;s:4:\\\"mail\\\";}}\"},\"createdAt\":1788628704,\"delay\":null}', 0, NULL, 1788628704, 1788628704),
(10, 'default', '{\"uuid\":\"78de52d0-b319-4ab8-ae64-3c62bb000020\",\"displayName\":\"App\\\\Notifications\\\\StaffInvitationNotification\",\"job\":\"Illuminate\\\\Queue\\\\CallQueuedHandler@call\",\"maxTries\":null,\"maxExceptions\":null,\"failOnTimeout\":false,\"backoff\":null,\"timeout\":null,\"retryUntil\":null,\"data\":{\"commandName\":\"Illuminate\\\\Notifications\\\\SendQueuedNotifications\",\"command\":\"O:48:\\\"Illuminate\\\\Notifications\\\\SendQueuedNotifications\\\":3:{s:11:\\\"notifiables\\\";O:45:\\\"Illuminate\\\\Contracts\\\\Database\\\\ModelIdentifier\\\":5:{s:5:\\\"class\\\";s:15:\\\"App\\\\Models\\\\User\\\";s:2:\\\"id\\\";a:1:{i:0;i:51;}s:9:\\\"relations\\\";a:0:{}s:10:\\\"connection\\\";s:5:\\\"mysql\\\";s:15:\\\"collectionClass\\\";N;}s:12:\\\"notification\\\";O:45:\\\"App\\\\Notifications\\\\StaffInvitationNotification\\\":2:{s:11:\\\"credentials\\\";a:4:{s:4:\\\"name\\\";s:5:\\\"Adele\\\";s:5:\\\"email\\\";s:13:\\\"adele@mma.com\\\";s:8:\\\"password\\\";s:12:\\\"s8D8xxNcgljI\\\";s:5:\\\"token\\\";s:40:\\\"YApr8KdQQM3bTHsFQINbLSOPNiqIT33qFOHbsG0r\\\";}s:2:\\\"id\\\";s:36:\\\"fcd5da08-2cde-4a4f-9bff-2cde9698a856\\\";}s:8:\\\"channels\\\";a:1:{i:0;s:4:\\\"mail\\\";}}\"},\"createdAt\":1788709144,\"delay\":null}', 0, NULL, 1788709144, 1788709144),
(11, 'default', '{\"uuid\":\"8c8a04e0-fb02-4e96-83b9-8b43f6f8bece\",\"displayName\":\"App\\\\Notifications\\\\OrderSuccessfulNotification\",\"job\":\"Illuminate\\\\Queue\\\\CallQueuedHandler@call\",\"maxTries\":null,\"maxExceptions\":null,\"failOnTimeout\":false,\"backoff\":null,\"timeout\":null,\"retryUntil\":null,\"data\":{\"commandName\":\"Illuminate\\\\Notifications\\\\SendQueuedNotifications\",\"command\":\"O:48:\\\"Illuminate\\\\Notifications\\\\SendQueuedNotifications\\\":3:{s:11:\\\"notifiables\\\";O:45:\\\"Illuminate\\\\Contracts\\\\Database\\\\ModelIdentifier\\\":5:{s:5:\\\"class\\\";s:15:\\\"App\\\\Models\\\\User\\\";s:2:\\\"id\\\";a:1:{i:0;i:1;}s:9:\\\"relations\\\";a:0:{}s:10:\\\"connection\\\";s:5:\\\"mysql\\\";s:15:\\\"collectionClass\\\";N;}s:12:\\\"notification\\\";O:45:\\\"App\\\\Notifications\\\\OrderSuccessfulNotification\\\":2:{s:5:\\\"order\\\";O:45:\\\"Illuminate\\\\Contracts\\\\Database\\\\ModelIdentifier\\\":5:{s:5:\\\"class\\\";s:16:\\\"App\\\\Models\\\\Order\\\";s:2:\\\"id\\\";i:42;s:9:\\\"relations\\\";a:1:{i:0;s:4:\\\"user\\\";}s:10:\\\"connection\\\";s:5:\\\"mysql\\\";s:15:\\\"collectionClass\\\";N;}s:2:\\\"id\\\";s:36:\\\"8ba11757-f6c6-4f54-b58c-549f5135f396\\\";}s:8:\\\"channels\\\";a:1:{i:0;s:4:\\\"mail\\\";}}\"},\"createdAt\":1788710510,\"delay\":null}', 0, NULL, 1788710510, 1788710510);

-- --------------------------------------------------------

--
-- Table structure for table `notifications`
--

CREATE TABLE `notifications` (
  `id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `subject` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `details` text COLLATE utf8mb4_general_ci NOT NULL,
  `admin_read` tinyint(1) DEFAULT '0',
  `user_read` tinyint(1) DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `notifications`
--

INSERT INTO `notifications` (`id`, `user_id`, `subject`, `details`, `admin_read`, `user_read`, `created_at`, `updated_at`) VALUES
(1, 3, 'Wallet Funded Successfully', 'Your wallet has been credited with ₦50,000.00 via instant bank transfer.', 1, 0, '2026-09-07 11:03:16', '2026-09-07 11:03:16'),
(2, 3, 'Security Alert: New Login', 'We noticed a successful login to your account from a new device (Chrome on Windows, Lagos).', 1, 0, '2026-09-06 13:03:16', '2026-09-07 12:31:54'),
(3, 3, 'KYC Verification Approved', 'Your Level 2 identity verification documents have been reviewed and approved.', 1, 1, '2026-09-04 13:03:16', '2026-09-04 13:03:16'),
(4, 3, 'Virtual Card Issued', 'Your new USD virtual card ending in 4892 has been successfully generated and is ready for use.', 1, 0, '2026-09-02 13:03:16', '2026-09-02 13:03:16'),
(5, 3, 'Scheduled System Maintenance', 'Our platform will undergo brief scheduled maintenance on Sunday from 2:00 AM to 4:00 AM WAT.', 1, 1, '2026-08-31 13:03:16', '2026-09-07 12:32:06');

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `id` bigint UNSIGNED NOT NULL,
  `order_no` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `seller_id` bigint UNSIGNED DEFAULT NULL,
  `order_status` enum('pending','processing','confirmed','shipped','delivered','cancelled','returned') COLLATE utf8mb4_general_ci DEFAULT 'pending',
  `payment_status` enum('pending','paid','partially_paid','refunded','failed') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'pending',
  `payment_method` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `transaction_ref` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `subtotal` decimal(12,2) NOT NULL DEFAULT '0.00',
  `tax_amount` decimal(12,2) NOT NULL DEFAULT '0.00',
  `shipping_cost` decimal(12,2) NOT NULL DEFAULT '0.00',
  `discount_amount` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_amount` decimal(12,2) NOT NULL DEFAULT '0.00',
  `shipping_country` varchar(50) COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'Nigeria',
  `shipping_state` varchar(50) COLLATE utf8mb4_general_ci DEFAULT 'Lagos',
  `shipping_city` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `shipping_zip` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `shipping_address` json NOT NULL,
  `billing_address` json DEFAULT NULL,
  `notes` text COLLATE utf8mb4_general_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`id`, `order_no`, `user_id`, `seller_id`, `order_status`, `payment_status`, `payment_method`, `transaction_ref`, `subtotal`, `tax_amount`, `shipping_cost`, `discount_amount`, `total_amount`, `shipping_country`, `shipping_state`, `shipping_city`, `shipping_zip`, `shipping_address`, `billing_address`, `notes`, `created_at`, `updated_at`) VALUES
(38, 'ORD-6A9C21265BE4F', 3, NULL, 'processing', 'paid', 'paystack', 'TRX-6A9C21265BE51', 1399.98, 70.00, 0.00, 0.00, 0.00, 'Nigeria', 'Lagos', NULL, NULL, '\"12, Ikorodu Street\"', NULL, NULL, '2026-09-05 13:03:18', '2026-09-05 13:11:40'),
(39, 'ORD-6A9C23E593278', 3, NULL, 'processing', 'paid', 'paystack', 'TRX-6A9C23E59327A', 1000.00, 50.00, 0.00, 0.00, 10.50, 'Nigeria', 'Lagos', NULL, NULL, '\"12, Ikorodu Street\"', NULL, NULL, '2026-09-05 13:15:01', '2026-09-05 13:15:39'),
(40, 'ORD-6A9C24E13AF42', 3, NULL, 'delivered', 'paid', 'paystack', 'TRX-6A9C24E13AF44', 122.00, 6.10, 0.00, 0.00, 128.10, 'Nigeria', 'Lagos', NULL, NULL, '\"12, Ikorodu Street\"', NULL, NULL, '2026-09-05 13:19:13', '2026-09-05 13:20:56'),
(41, 'ORD-6A9C4ED888FDA', 1, NULL, 'processing', 'paid', 'paystack', 'TRX-6A9C4ED888FDC', 321.99, 16.10, 0.00, 0.00, 338.09, 'Nigeria', 'Lagos', NULL, NULL, '\"12, Adele Street\"', NULL, NULL, '2026-09-05 16:18:16', '2026-09-05 16:18:24'),
(42, 'ORD-6A9D8E5D7CE38', 1, NULL, 'processing', 'paid', 'paystack', 'TRX-6A9D8E5D7CE3B', 8399.99, 420.00, 0.00, 0.00, 8819.99, 'Nigeria', 'Lagos', NULL, NULL, '\"12, Adele Street\"', NULL, NULL, '2026-09-06 15:01:33', '2026-09-06 15:01:50');

-- --------------------------------------------------------

--
-- Table structure for table `order_items`
--

CREATE TABLE `order_items` (
  `id` bigint UNSIGNED NOT NULL,
  `order_id` bigint UNSIGNED NOT NULL,
  `product_id` bigint UNSIGNED DEFAULT NULL,
  `seller_id` bigint UNSIGNED DEFAULT NULL,
  `unit_price` decimal(12,2) NOT NULL,
  `quantity` int UNSIGNED NOT NULL,
  `tax` decimal(12,2) DEFAULT '0.00',
  `discount` decimal(12,2) DEFAULT '0.00',
  `total_price` decimal(12,2) NOT NULL,
  `variation_options` json DEFAULT NULL,
  `delivery_status` enum('pending','processing','shipped','delivered','cancelled') COLLATE utf8mb4_general_ci DEFAULT 'pending',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `order_items`
--

INSERT INTO `order_items` (`id`, `order_id`, `product_id`, `seller_id`, `unit_price`, `quantity`, `tax`, `discount`, `total_price`, `variation_options`, `delivery_status`, `created_at`, `updated_at`) VALUES
(38, 38, 11, NULL, 199.99, 2, 0.00, 0.00, 399.98, NULL, 'pending', '2026-09-05 13:03:18', '2026-09-05 13:03:18'),
(39, 38, 14, NULL, 1000.00, 1, 0.00, 0.00, 1000.00, NULL, 'pending', '2026-09-05 13:03:18', '2026-09-05 13:03:18'),
(40, 39, 14, NULL, 1000.00, 1, 0.00, 0.00, 1000.00, NULL, 'pending', '2026-09-05 13:15:01', '2026-09-05 13:15:01'),
(41, 40, 15, NULL, 122.00, 1, 0.00, 0.00, 122.00, NULL, 'delivered', '2026-09-05 13:19:13', '2026-09-05 13:20:56'),
(42, 41, 11, NULL, 199.99, 1, 0.00, 0.00, 199.99, NULL, 'pending', '2026-09-05 16:18:16', '2026-09-05 16:18:16'),
(43, 41, 15, NULL, 122.00, 1, 0.00, 0.00, 122.00, NULL, 'pending', '2026-09-05 16:18:16', '2026-09-05 16:18:16'),
(44, 42, 11, NULL, 199.99, 1, 0.00, 0.00, 199.99, NULL, 'pending', '2026-09-06 15:01:33', '2026-09-06 15:01:33'),
(45, 42, 13, NULL, 200.00, 1, 0.00, 0.00, 200.00, NULL, 'pending', '2026-09-06 15:01:33', '2026-09-06 15:01:33'),
(46, 42, 14, NULL, 1000.00, 2, 0.00, 0.00, 2000.00, NULL, 'pending', '2026-09-06 15:01:33', '2026-09-06 15:01:33'),
(47, 42, 16, NULL, 2000.00, 3, 0.00, 0.00, 6000.00, NULL, 'pending', '2026-09-06 15:01:33', '2026-09-06 15:01:33');

-- --------------------------------------------------------

--
-- Table structure for table `order_refunds`
--

CREATE TABLE `order_refunds` (
  `id` bigint UNSIGNED NOT NULL,
  `refund_no` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Unique refund tracking code, e.g. RFD-2026-001',
  `order_id` bigint UNSIGNED NOT NULL,
  `order_no` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `transaction_ref` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL COMMENT 'Buyer requesting the refund',
  `seller_id` bigint UNSIGNED NOT NULL COMMENT 'Vendor/Seller being requested from',
  `refund_amount` decimal(12,2) NOT NULL DEFAULT '0.00',
  `reason` text COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Buyer refund justification',
  `evidence_urls` json DEFAULT NULL COMMENT 'Array of image/file attachment links',
  `status` enum('pending','approved','declined') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `admin_notes` text COLLATE utf8mb4_unicode_ci COMMENT 'Reason for approval or rejection by admin',
  `processed_by_user_id` bigint UNSIGNED DEFAULT NULL COMMENT 'Admin user ID who handled the request',
  `processed_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `order_settlements`
--

CREATE TABLE `order_settlements` (
  `id` bigint UNSIGNED NOT NULL,
  `order_id` bigint UNSIGNED NOT NULL,
  `seller_id` bigint UNSIGNED NOT NULL,
  `gross_amount` decimal(15,2) NOT NULL,
  `platform_fee` decimal(15,2) NOT NULL DEFAULT '0.00',
  `net_settlement` decimal(15,2) NOT NULL,
  `status` enum('pending','settled','refunded','on_hold') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `settled_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `order_status_histories`
--

CREATE TABLE `order_status_histories` (
  `id` bigint UNSIGNED NOT NULL,
  `order_id` bigint UNSIGNED NOT NULL,
  `status` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `comment` text COLLATE utf8mb4_general_ci,
  `changed_by_user_id` bigint UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `order_status_histories`
--

INSERT INTO `order_status_histories` (`id`, `order_id`, `status`, `comment`, `changed_by_user_id`, `created_at`) VALUES
(24, 40, 'processing', 'Item \'\' (SKU: ) status updated from \'pending\' to \'delivered\'', 1, '2026-09-05 13:20:46'),
(25, 40, 'delivered', 'Overall order status updated from \'processing\' to \'delivered\'', 1, '2026-09-05 13:20:56');

-- --------------------------------------------------------

--
-- Table structure for table `order_transactions`
--

CREATE TABLE `order_transactions` (
  `id` bigint UNSIGNED NOT NULL,
  `order_id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `transaction_ref` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `payment_gateway` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'e.g., Paystack, Flutterwave, Stripe',
  `amount` decimal(12,2) NOT NULL DEFAULT '0.00',
  `fee` float(10,2) NOT NULL DEFAULT '0.00',
  `total_amount` float(10,2) NOT NULL DEFAULT '0.00',
  `tax` float(10,2) NOT NULL DEFAULT '0.00',
  `currency` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'NGN',
  `status` enum('success','pending','successful','failed','refunded') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `gateway_response` json DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `order_transactions`
--

INSERT INTO `order_transactions` (`id`, `order_id`, `user_id`, `transaction_ref`, `payment_gateway`, `amount`, `fee`, `total_amount`, `tax`, `currency`, `status`, `gateway_response`, `created_at`, `updated_at`, `deleted_at`) VALUES
(10, 38, 3, 'TRX-6A9C21265BE51', 'Paystack', 1469.98, 22.05, 1469.98, 0.00, 'NGN', 'success', '\"Successful\"', '2026-09-05 13:11:40', '2026-09-05 13:11:40', NULL),
(11, 39, 3, 'TRX-6A9C23E59327A', 'Paystack', 1050.00, 15.75, 1050.00, 0.00, 'NGN', 'success', '\"Successful\"', '2026-09-05 13:15:39', '2026-09-05 13:15:39', NULL),
(12, 40, 3, 'TRX-6A9C24E13AF44', 'Paystack', 128.10, 1.93, 128.10, 0.00, 'NGN', 'success', '\"Successful\"', '2026-09-05 13:19:22', '2026-09-05 13:19:22', NULL),
(13, 41, 1, 'TRX-6A9C4ED888FDC', 'Paystack', 338.09, 5.08, 338.09, 0.00, 'NGN', 'success', '\"Successful\"', '2026-09-05 16:18:24', '2026-09-05 16:18:24', NULL),
(14, 42, 1, 'TRX-6A9D8E5D7CE3B', 'Paystack', 8819.99, 232.30, 8819.99, 0.00, 'NGN', 'success', '\"Successful\"', '2026-09-06 15:01:50', '2026-09-06 15:01:50', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `payment_gateways`
--

CREATE TABLE `payment_gateways` (
  `id` int NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `slug` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `public_key` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `secret_key` text COLLATE utf8mb4_general_ci,
  `webhook_endpoint` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `payment_gateways`
--

INSERT INTO `payment_gateways` (`id`, `name`, `slug`, `public_key`, `secret_key`, `webhook_endpoint`, `is_active`, `created_at`, `updated_at`) VALUES
(1, 'Paystack', 'paystack', 'sk_test_ae65fab010dd2e551b8c9801528ed635c047baf2', 'sk_test_ae65fab010dd2e551b8c9801528ed635c047baf2', 'https://webhook.site/a15e9b83-c3cb-44bf-8628-ccb008764cf6', 1, '2026-09-01 21:06:24', '2026-09-05 12:33:19'),
(2, 'Flutterwave', 'flutterwave', 'FLWPUBK_test-sampleflutterwavekey123', 'FLWSECK_test-samplesecretkey123', 'https://api.example.com/webhook/flutterwave', 0, '2026-09-01 21:06:24', '2026-09-07 13:10:50'),
(3, 'Stripe', 'stripe', 'pk_test_samplestripepublickey98765', 'sk_test_samplestripesecretkey98765', 'https://api.example.com/webhook/stripe', 0, '2026-09-01 21:06:24', '2026-09-01 20:33:11'),
(4, 'Payment On Delivery', 'cod', '', '', '', 0, '2026-09-01 21:06:24', '2026-09-07 11:52:27');

-- --------------------------------------------------------

--
-- Table structure for table `permissions`
--

CREATE TABLE `permissions` (
  `id` bigint UNSIGNED NOT NULL,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `slug` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `group` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `permissions`
--

INSERT INTO `permissions` (`id`, `name`, `slug`, `group`, `description`, `created_at`, `updated_at`) VALUES
(1, 'View Dashboard', 'dashboard.view', 'dashboard', 'Access main system dashboard analytics', '2026-08-27 23:27:12', '2026-08-27 23:27:12'),
(2, 'View Categories', 'categories.view', 'categories', 'View product categories and details', '2026-08-27 23:27:12', '2026-08-27 23:27:12'),
(3, 'Create Categories', 'categories.create', 'categories', 'Create new product categories', '2026-08-27 23:27:12', '2026-08-27 23:27:12'),
(4, 'Edit Categories', 'categories.edit', 'categories', 'Update existing product categories', '2026-08-27 23:27:12', '2026-08-27 23:27:12'),
(5, 'Delete Categories', 'categories.delete', 'categories', 'Delete product categories', '2026-08-27 23:27:12', '2026-08-27 23:27:12'),
(6, 'View Sub-Categories', 'subcategories.view', 'subcategories', 'View sub-categories and details', '2026-08-27 23:27:12', '2026-08-27 23:27:12'),
(7, 'Create Sub-Categories', 'subcategories.create', 'subcategories', 'Create new sub-categories', '2026-08-27 23:27:12', '2026-08-27 23:27:12'),
(8, 'Edit Sub-Categories', 'subcategories.edit', 'subcategories', 'Update existing sub-categories', '2026-08-27 23:27:12', '2026-08-27 23:27:12'),
(9, 'Delete Sub-Categories', 'subcategories.delete', 'subcategories', 'Delete sub-categories', '2026-08-27 23:27:12', '2026-08-27 23:27:12'),
(10, 'View Brands', 'brands.view', 'brands', 'View product brands', '2026-08-27 23:27:12', '2026-08-27 23:27:12'),
(11, 'Create Brands', 'brands.create', 'brands', 'Create new product brands', '2026-08-27 23:27:12', '2026-08-27 23:27:12'),
(12, 'Edit Brands', 'brands.edit', 'brands', 'Update existing product brands', '2026-08-27 23:27:12', '2026-08-27 23:27:12'),
(13, 'Delete Brands', 'brands.delete', 'brands', 'Delete product brands', '2026-08-27 23:27:12', '2026-08-27 23:27:12'),
(14, 'View Attributes', 'attributes.view', 'attributes', 'View product attributes and values', '2026-08-27 23:27:12', '2026-08-27 23:27:12'),
(15, 'Create Attributes', 'attributes.create', 'attributes', 'Create new product attributes and values', '2026-08-27 23:27:12', '2026-08-27 23:27:12'),
(16, 'Edit Attributes', 'attributes.edit', 'attributes', 'Update product attributes and values', '2026-08-27 23:27:12', '2026-08-27 23:27:12'),
(17, 'Delete Attributes', 'attributes.delete', 'attributes', 'Delete product attributes and values', '2026-08-27 23:27:12', '2026-08-27 23:27:12'),
(18, 'View Products', 'products.view', 'products', 'View all products', '2026-08-27 23:27:12', '2026-08-27 23:27:12'),
(19, 'Create Products', 'products.create', 'products', 'Create new products', '2026-08-27 23:27:12', '2026-08-27 23:27:12'),
(20, 'Edit Products', 'products.edit', 'products', 'Update products and publish status', '2026-08-27 23:27:12', '2026-08-27 23:27:12'),
(21, 'Delete Products', 'products.delete', 'products', 'Delete products', '2026-08-27 23:27:12', '2026-08-27 23:27:12'),
(22, 'View Orders', 'orders.view', 'orders', 'View order listings and details', '2026-08-27 23:27:12', '2026-08-27 23:27:12'),
(23, 'Manage Orders', 'orders.manage', 'orders', 'Update order, item, and payment status', '2026-08-27 23:27:12', '2026-08-27 23:27:12'),
(24, 'View Abandoned Carts', 'abandoned_carts.view', 'abandoned_carts', 'View abandoned cart lists', '2026-08-27 23:27:12', '2026-08-27 23:27:12'),
(25, 'Delete Abandoned Carts', 'abandoned_carts.delete', 'abandoned_carts', 'Remove abandoned cart records', '2026-08-27 23:27:12', '2026-08-27 23:27:12'),
(26, 'Send Recovery Notifications', 'abandoned_carts.notify', 'abandoned_carts', 'Send single/bulk cart recovery notifications', '2026-08-27 23:27:12', '2026-08-27 23:27:12'),
(27, 'View Transactions', 'transactions.view', 'transactions', 'View transaction records and tax logs', '2026-08-27 23:27:12', '2026-08-27 23:27:12'),
(28, 'Manage Transactions', 'transactions.manage', 'transactions', 'Update transaction status', '2026-08-27 23:27:12', '2026-08-27 23:27:12'),
(29, 'View Platform Earnings', 'platform_earnings.view', 'platform_earnings', 'View platform revenue metrics', '2026-08-27 23:27:12', '2026-08-27 23:27:12'),
(30, 'View Refunds', 'refunds.view', 'refunds', 'View customer refund requests', '2026-08-27 23:27:12', '2026-08-27 23:27:12'),
(31, 'Manage Refunds', 'refunds.manage', 'refunds', 'Approve or decline refund requests', '2026-08-27 23:27:12', '2026-08-27 23:27:12'),
(32, 'View Withdrawals', 'withdrawals.view', 'withdrawals', 'View seller withdrawal requests', '2026-08-27 23:27:12', '2026-08-27 23:27:12'),
(33, 'Manage Withdrawals', 'withdrawals.manage', 'withdrawals', 'Approve or decline seller payout requests', '2026-08-27 23:27:12', '2026-08-27 23:27:12'),
(34, 'View Coupons', 'coupons.view', 'coupons', 'View discount coupons', '2026-08-27 23:27:12', '2026-08-27 23:27:12'),
(35, 'Create Coupons', 'coupons.create', 'coupons', 'Create new discount coupons', '2026-08-27 23:27:12', '2026-08-27 23:27:12'),
(36, 'Edit Coupons', 'coupons.edit', 'coupons', 'Update coupon details and toggle status', '2026-08-27 23:27:12', '2026-08-27 23:27:12'),
(37, 'Delete Coupons', 'coupons.delete', 'coupons', 'Delete discount coupons', '2026-08-27 23:27:12', '2026-08-27 23:27:12'),
(38, 'View Flash Sales', 'flash_sales.view', 'flash_sales', 'View promotional flash sales', '2026-08-27 23:27:12', '2026-08-27 23:27:12'),
(39, 'Create Flash Sales', 'flash_sales.create', 'flash_sales', 'Create new flash sale campaigns', '2026-08-27 23:27:12', '2026-08-27 23:27:12'),
(40, 'Edit Flash Sales', 'flash_sales.edit', 'flash_sales', 'Update flash sale details and toggle status', '2026-08-27 23:27:12', '2026-08-27 23:27:12'),
(41, 'Delete Flash Sales', 'flash_sales.delete', 'flash_sales', 'Delete flash sale campaigns', '2026-08-27 23:27:12', '2026-08-27 23:27:12'),
(42, 'View Frontend Contents', 'frontend_contents.view', 'frontend_contents', 'View landing page sections and content', '2026-08-27 23:27:12', '2026-08-27 23:27:12'),
(43, 'Create Frontend Contents', 'frontend_contents.create', 'frontend_contents', 'Create new landing page content blocks', '2026-08-27 23:27:12', '2026-08-27 23:27:12'),
(44, 'Edit Frontend Contents', 'frontend_contents.edit', 'frontend_contents', 'Update landing page content blocks', '2026-08-27 23:27:12', '2026-08-27 23:27:12'),
(45, 'Delete Frontend Contents', 'frontend_contents.delete', 'frontend_contents', 'Delete landing page content blocks', '2026-08-27 23:27:12', '2026-08-27 23:27:12'),
(46, 'View Support Tickets', 'tickets.view', 'tickets', 'View customer support tickets', '2026-08-27 23:27:12', '2026-08-27 23:27:12'),
(47, 'Reply Support Tickets', 'tickets.reply', 'tickets', 'Reply to and close customer support tickets', '2026-08-27 23:27:12', '2026-08-27 23:27:12'),
(48, 'View Settings', 'settings.view', 'settings', 'View platform global settings', '2026-08-27 23:27:12', '2026-08-27 23:27:12'),
(49, 'Manage Settings', 'settings.manage', 'settings', 'Modify system settings, SEO, and maintenance mode', '2026-08-27 23:27:12', '2026-08-27 23:27:12'),
(50, 'View Customers', 'customers.view', 'customers', 'View buyer profiles and activity', '2026-08-27 23:27:12', '2026-08-27 23:27:12'),
(51, 'Manage Customers', 'customers.manage', 'customers', 'Update buyer active status', '2026-08-27 23:27:12', '2026-08-27 23:27:12'),
(52, 'Delete Customers', 'customers.delete', 'customers', 'Delete buyer accounts', '2026-08-27 23:27:12', '2026-08-27 23:27:12'),
(53, 'View Sellers', 'sellers.view', 'sellers', 'View seller profiles, products, and metrics', '2026-08-27 23:27:12', '2026-08-27 23:27:12'),
(54, 'Manage Sellers', 'sellers.manage', 'sellers', 'Update seller active/disabled status', '2026-08-27 23:27:12', '2026-08-27 23:27:12'),
(55, 'View Roles', 'roles.view', 'roles', 'View system roles and permission matrices', '2026-08-27 23:27:12', '2026-08-27 23:27:12'),
(56, 'Manage Roles', 'roles.manage', 'roles', 'Create and modify system roles and permissions', '2026-08-27 23:27:12', '2026-08-27 23:27:12'),
(57, 'View Staff', 'staff.view', 'staff', 'View administrative staff user list', '2026-08-27 23:27:12', '2026-08-27 23:27:12'),
(58, 'Manage Staff', 'staff.manage', 'staff', 'Invite, update, reset password, and change staff roles', '2026-08-27 23:27:12', '2026-08-27 23:27:12'),
(59, 'Delete Staff', 'staff.delete', 'staff', 'Delete administrative staff user accounts', '2026-08-27 23:27:12', '2026-08-27 23:27:12'),
(60, 'View Audit Logs', 'audit_logs.view', 'audit_logs', 'View system audit trail logs', '2026-08-27 23:27:12', '2026-08-27 23:27:12');

-- --------------------------------------------------------

--
-- Table structure for table `personal_access_tokens`
--

CREATE TABLE `personal_access_tokens` (
  `id` bigint UNSIGNED NOT NULL,
  `tokenable_type` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `tokenable_id` bigint UNSIGNED NOT NULL,
  `name` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `abilities` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `personal_access_tokens`
--

INSERT INTO `personal_access_tokens` (`id`, `tokenable_type`, `tokenable_id`, `name`, `token`, `abilities`, `last_used_at`, `expires_at`, `created_at`, `updated_at`) VALUES
(234, 'App\\Models\\User', 1, 'postman', 'e61d32ed2ea733418763f0fb999a2af4d5df44bcda34eafa51761e21299d0bd5', '[\"*\"]', NULL, NULL, '2026-01-09 20:33:27', '2026-01-09 20:33:27'),
(235, 'App\\Models\\User', 1, 'postman', '46836ef66db177683cebc12e0bb214a9b157fe094f926e41649ef3d201692445', '[\"*\"]', NULL, NULL, '2026-01-09 20:38:07', '2026-01-09 20:38:07'),
(236, 'App\\Models\\User', 1, 'postman', '6fa27f1aa5dc97c5a65a8f738a34f164b26a0fec0e99513ce7d3c75c53ea536e', '[\"*\"]', NULL, NULL, '2026-01-09 20:38:52', '2026-01-09 20:38:52'),
(237, 'App\\Models\\User', 1, 'postman', 'cf3b589e95b9b35c222b1e8e855f54acc6712c964e6d07f50b76f92c0f5581cb', '[\"*\"]', NULL, NULL, '2026-01-09 20:42:29', '2026-01-09 20:42:29'),
(238, 'App\\Models\\User', 1, 'test@example.com', 'c959bc718eeeb85f5e01e4f096241eb34546d545a5ea7f3306923e48d401418f', '[\"role:admin\"]', NULL, NULL, '2026-08-25 10:17:57', '2026-08-25 10:17:57'),
(239, 'App\\Models\\User', 1, 'test@example.com', '91c6c734bbc31664e4dd8693524967767692873acf07aa55fb32ab2521be4fe0', '[\"role:admin\"]', NULL, NULL, '2026-08-25 10:24:46', '2026-08-25 10:24:46'),
(240, 'App\\Models\\User', 1, 'postman', '59209469319a648a36eafcccbefceae37a81df3d2db7aab2ae8042a470589ff4', '[\"role:admin\"]', NULL, NULL, '2026-08-25 10:31:21', '2026-08-25 10:31:21'),
(242, 'App\\Models\\User', 1, 'Unknown Platform (Unknown Browser)', '1c25befe795b3ff136109489ed1e37d556b25382e04d278749e20c4d66ee4b08', '[\"role:admin\"]', '2026-09-09 06:40:28', NULL, '2026-08-25 10:55:37', '2026-09-09 06:40:28'),
(243, 'App\\Models\\User', 1, 'Unknown Platform (Unknown Browser)', '7c82a713ed0a2023467424f21dcc95e75e48d34ee8ba34f7f887b80aeafcf8da', '[\"role:admin\"]', NULL, NULL, '2026-08-29 05:24:55', '2026-08-29 05:24:55'),
(244, 'App\\Models\\User', 1, 'macOS (Chrome)', '8dbf19d365a5986f7f2269aa0e0ec64a493a6f5d7866d6c2a48c642c0675f71b', '[\"role:admin\"]', NULL, NULL, '2026-08-29 06:41:31', '2026-08-29 06:41:31'),
(245, 'App\\Models\\User', 1, 'macOS (Chrome)', '996ccaad9b79c87bc725ba897f63b842ef424c0fbf6db50f6ce4031ceb7af0c4', '[\"role:admin\"]', NULL, NULL, '2026-08-29 06:42:13', '2026-08-29 06:42:13'),
(246, 'App\\Models\\User', 1, 'macOS (Chrome)', '3731cafa9b7bc13cafaea905354992dc7560aacc2b7e29037b15db0c287e4b81', '[\"role:admin\"]', NULL, NULL, '2026-08-29 06:45:25', '2026-08-29 06:45:25'),
(247, 'App\\Models\\User', 1, 'macOS (Chrome)', '1cb8d56d3d192ffa7c4ac07f4bfbeea9cccee2406498855f42e0e0d36b561141', '[\"role:admin\"]', NULL, NULL, '2026-08-29 06:45:32', '2026-08-29 06:45:32'),
(248, 'App\\Models\\User', 1, 'macOS (Chrome)', 'c627095ecef132f8210e99733fe0e2ab55a1d54b20a9b74c21be8dabe904caba', '[\"role:admin\"]', NULL, NULL, '2026-08-29 06:46:23', '2026-08-29 06:46:23'),
(249, 'App\\Models\\User', 1, 'macOS (Chrome)', '27ce3d947ca5dd9f5d85a64f33a0cfe2733ef3539ccaff91cb4242c0d9ce72a0', '[\"role:admin\"]', NULL, NULL, '2026-08-29 06:46:46', '2026-08-29 06:46:46'),
(250, 'App\\Models\\User', 1, 'macOS (Chrome)', 'a130c31a65da71cd131d9a97ebdcc20751b4b06b0f69280448bf150073a65c0e', '[\"role:admin\"]', NULL, NULL, '2026-08-29 06:54:49', '2026-08-29 06:54:49'),
(251, 'App\\Models\\User', 1, 'macOS (Chrome)', '2145b0b6821d1ef77bfa4af56fd7a2ab5d47c72a822d44587cbffa7df116a629', '[\"role:admin\"]', NULL, NULL, '2026-08-29 06:56:28', '2026-08-29 06:56:28'),
(252, 'App\\Models\\User', 1, 'macOS (Chrome)', 'd33049165373b619ca123850e080d0006f46348dcd3422d64e0acfc62a5a40fb', '[\"role:admin\"]', NULL, NULL, '2026-08-29 06:56:35', '2026-08-29 06:56:35'),
(253, 'App\\Models\\User', 1, 'macOS (Chrome)', 'c85ef68bd7f44582e659230eb1dd1302e066567b3f424bcd724d8c97024f8bc0', '[\"role:admin\"]', NULL, NULL, '2026-08-29 07:05:06', '2026-08-29 07:05:06'),
(254, 'App\\Models\\User', 1, 'macOS (Chrome)', 'e9f16cd4489b9a56bd836fe8c743d52792b6f2c880d1c1da05d3028967b31726', '[\"role:admin\"]', '2026-09-02 07:35:26', NULL, '2026-08-29 07:05:20', '2026-09-02 07:35:26'),
(255, 'App\\Models\\User', 3, 'Unknown Platform (Unknown Browser)', '50a1eafc1cef0a6245757a0a3316785beafcf5ccab288c1ad7015351b75f9d3b', '[\"role:buyer\"]', '2026-09-08 15:58:14', NULL, '2026-09-03 05:45:02', '2026-09-08 15:58:14'),
(256, 'App\\Models\\User', 3, 'macOS (Chrome)', 'c471b34addee445664cc2e1d8ad51976ab83f4217a9658032df8975ce5189a39', '[\"role:buyer\"]', NULL, NULL, '2026-09-03 12:55:56', '2026-09-03 12:55:56'),
(257, 'App\\Models\\User', 3, 'macOS (Chrome)', '3e2af5f1027a6a0cbb6361c015fdb5789c19a69d23a7b5f5f3282aa8547f4657', '[\"role:buyer\"]', NULL, NULL, '2026-09-03 12:59:21', '2026-09-03 12:59:21'),
(258, 'App\\Models\\User', 3, 'macOS (Chrome)', 'c488218f8cf1fe12b48ecc58dd18831f94210f5000f735b74936426d6447daa9', '[\"role:buyer\"]', NULL, NULL, '2026-09-03 13:13:08', '2026-09-03 13:13:08'),
(259, 'App\\Models\\User', 49, 'macOS (Chrome)', 'd57485c1330a2433cd67335d2da1867791ce6b12d7a725f9da9e2ad15a3a2907', '[\"role:buyer\"]', NULL, NULL, '2026-09-03 14:08:09', '2026-09-03 14:08:09'),
(260, 'App\\Models\\User', 1, 'macOS (Chrome)', '4692e9198e0f925f100a71c9286414c20308fbb98821e6e8c0985b1632dcea5c', '[\"role:admin\"]', '2026-09-05 13:27:45', NULL, '2026-09-04 07:28:12', '2026-09-05 13:27:45'),
(261, 'App\\Models\\User', 3, 'macOS (Chrome)', '8d66aafe09d777ffb0c9cc75af412f4664839d6c894d4b4a1498ee3bc49887ef', '[\"role:buyer\"]', NULL, NULL, '2026-09-04 19:03:29', '2026-09-04 19:03:29'),
(262, 'App\\Models\\User', 3, 'Unknown Platform (Unknown Browser)', '251859742f8dd7341cef4037e2f45b6233314ceae34daf30b9364b532cdf5b64', '[\"role:buyer\"]', NULL, NULL, '2026-09-04 20:05:14', '2026-09-04 20:05:14'),
(263, 'App\\Models\\User', 50, 'macOS (Chrome)', '908472c27006d02e9e9ee5f2ad3cf42a54878698b605c0ebcc094a1a2e0e32f5', '[\"role:buyer\"]', NULL, NULL, '2026-09-04 20:10:36', '2026-09-04 20:10:36'),
(264, 'App\\Models\\User', 3, 'macOS (Chrome)', '7b3d9552fecd33a8aee2c46ea35727766e636004da89be3950200fbf3a5dd301', '[\"role:buyer\"]', NULL, NULL, '2026-09-05 04:40:08', '2026-09-05 04:40:08'),
(265, 'App\\Models\\User', 3, 'macOS (Chrome)', 'e50dcff62e8f95f8187b42b9cb0a6fbc7edd8b78bb723b37878a9af801b02f55', '[\"role:buyer\"]', NULL, NULL, '2026-09-05 04:41:32', '2026-09-05 04:41:32'),
(266, 'App\\Models\\User', 3, 'macOS (Chrome)', 'cd34b1808f4bf1929ac7b607e8a67b1b38ac1ed5663359950ffbe5f3bcd801a6', '[\"role:buyer\"]', NULL, NULL, '2026-09-05 05:58:03', '2026-09-05 05:58:03'),
(267, 'App\\Models\\User', 3, 'macOS (Chrome)', '136c8dcfbc7b44e8b46fc534ae0ba4e19589907cfc3a1b99269c90c3a0bfdedc', '[\"role:buyer\"]', NULL, NULL, '2026-09-05 07:01:42', '2026-09-05 07:01:42'),
(268, 'App\\Models\\User', 3, 'Unknown Platform (Unknown Browser)', '1db857cf7e52641ffe31900876245678fe51403260d662930150383d9b9524fa', '[\"role:buyer\"]', NULL, NULL, '2026-09-05 07:03:03', '2026-09-05 07:03:03'),
(269, 'App\\Models\\User', 3, 'macOS (Chrome)', '71506edfe5b0121f348fbdf3d37dcad72856e283810dd36e54ee3f7cd432cc32', '[\"role:buyer\"]', '2026-09-05 13:19:22', NULL, '2026-09-05 07:03:54', '2026-09-05 13:19:22'),
(270, 'App\\Models\\User', 1, 'macOS (Chrome)', 'adbf1d0f2ca0d0486adb2c82044204b0254bbf1cc1ec4c3dafa955e70d0edb6e', '[\"role:admin\"]', '2026-09-05 14:02:30', NULL, '2026-09-05 13:29:15', '2026-09-05 14:02:30'),
(271, 'App\\Models\\User', 1, 'macOS (Chrome)', 'a258c07e7210cafadf868ae5e2a822ec6f61b28ae65f15ac28f4a8e4830edcf1', '[\"role:admin\"]', '2026-09-06 14:02:44', NULL, '2026-09-05 14:05:55', '2026-09-06 14:02:44'),
(272, 'App\\Models\\User', 3, 'macOS (Chrome)', 'faad499d3a0c1f8a96aae818bc72731471d395f7a4ba6b287177d6dd0377f06b', '[\"role:buyer\"]', NULL, NULL, '2026-09-06 12:45:17', '2026-09-06 12:45:17'),
(273, 'App\\Models\\User', 1, 'macOS (Chrome)', 'c6ef7a1a721c49597987fdad2254fa6762f400789c954ae816ae8c716f951ac5', '[\"role:admin\"]', '2026-09-06 14:10:09', NULL, '2026-09-06 14:10:09', '2026-09-06 14:10:09'),
(274, 'App\\Models\\User', 1, 'macOS (Chrome)', 'db5f62b1158429125ea81c051b43f53faf10cdcb4a24b7b62fae3b30f71b10ea', '[\"role:admin\"]', '2026-09-07 08:10:05', NULL, '2026-09-06 14:10:59', '2026-09-07 08:10:05'),
(275, 'App\\Models\\User', 3, 'macOS (Chrome)', '65755f1f36e38af32268ff0c79146afb683d8200275ec6c4881b78b36e5214db', '[\"role:buyer\"]', NULL, NULL, '2026-09-06 14:58:43', '2026-09-06 14:58:43'),
(276, 'App\\Models\\User', 1, 'macOS (Chrome)', '2f83f99a5ca0a8129689b48e63b1eacbfade519a1c2636ac2fd080647f75630f', '[\"role:admin\"]', '2026-09-07 15:15:27', NULL, '2026-09-07 08:10:14', '2026-09-07 15:15:27'),
(277, 'App\\Models\\User', 1, 'macOS (Chrome)', '60a65f4717ac665a9ecf297cf26cc55195f3a14fca12c2afc2c1956dbfcda4b7', '[\"role:admin\"]', '2026-09-07 15:44:59', NULL, '2026-09-07 15:15:32', '2026-09-07 15:44:59'),
(278, 'App\\Models\\User', 1, 'Unknown Platform (Unknown Browser)', '01fd863cb7aeeedce0657240050a842fd20d6ee98b14f053eb383e1287e73b36', '[\"role:admin\"]', NULL, NULL, '2026-09-07 15:48:25', '2026-09-07 15:48:25'),
(279, 'App\\Models\\User', 1, 'macOS (Chrome)', '7d17c0643d9ce7466a63022b8a303dc31add57a9e15d3fcb26cffe2c64362cad', '[\"role:admin\"]', '2026-09-07 18:20:04', NULL, '2026-09-07 17:41:25', '2026-09-07 18:20:04'),
(280, 'App\\Models\\User', 1, 'macOS (Chrome)', 'daaf6e966ebde8ffa8a776f33f04b037cd721d34a527607dbfb47a8b156ee228', '[\"role:admin\"]', '2026-09-07 20:06:03', NULL, '2026-09-07 18:26:09', '2026-09-07 20:06:03'),
(281, 'App\\Models\\User', 3, 'macOS (Chrome)', '1a459c68ba53ba42bf239918c9181adc7feb8a19a1f19fb0aa2e8d573e2b49f9', '[\"role:buyer\"]', '2026-09-07 19:57:53', NULL, '2026-09-07 19:57:18', '2026-09-07 19:57:53'),
(282, 'App\\Models\\User', 1, 'macOS (Chrome)', 'ff1b424ef8b53366a8bca74d6b7ccf7c816a8412a3ff9f028148a80b72895ef3', '[\"role:admin\"]', '2026-09-09 07:00:49', NULL, '2026-09-07 20:06:05', '2026-09-09 07:00:49'),
(283, 'App\\Models\\User', 3, 'macOS (Chrome)', '737319d005090b276a2ee82adeb7671a879f2266920ed8e1dc08f2b90fe48c94', '[\"role:buyer\"]', NULL, NULL, '2026-09-08 10:22:13', '2026-09-08 10:22:13'),
(284, 'App\\Models\\User', 3, 'macOS (Chrome)', 'ce5b93b3b53036e1b24d601d3d27ea797210c5780616221969756f7c59292992', '[\"role:buyer\"]', '2026-09-09 08:48:26', NULL, '2026-09-08 10:50:49', '2026-09-09 08:48:26');

-- --------------------------------------------------------

--
-- Table structure for table `products`
--

CREATE TABLE `products` (
  `id` bigint UNSIGNED NOT NULL,
  `seller_id` bigint UNSIGNED NOT NULL,
  `brand_id` bigint UNSIGNED DEFAULT NULL,
  `category_id` bigint UNSIGNED NOT NULL,
  `sub_category_id` bigint UNSIGNED DEFAULT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `slug` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `sku` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `product_type` enum('physical','digital') COLLATE utf8mb4_unicode_ci DEFAULT 'physical',
  `unit` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `tags` json DEFAULT NULL,
  `short_description` text COLLATE utf8mb4_unicode_ci,
  `description` longtext COLLATE utf8mb4_unicode_ci,
  `thumbnail` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `images` json DEFAULT NULL,
  `unit_price` decimal(12,2) NOT NULL DEFAULT '0.00',
  `purchase_price` decimal(12,2) DEFAULT '0.00',
  `tax` decimal(8,2) DEFAULT '0.00',
  `tax_type` enum('flat','percent') COLLATE utf8mb4_unicode_ci DEFAULT 'percent',
  `discount` decimal(12,2) DEFAULT '0.00',
  `discount_type` enum('flat','percent') COLLATE utf8mb4_unicode_ci DEFAULT 'flat',
  `current_stock` int NOT NULL DEFAULT '0',
  `minimum_order_qty` int NOT NULL DEFAULT '1',
  `low_stock_threshold` int DEFAULT '5',
  `stock_status` enum('in_stock','out_of_stock','backorder') COLLATE utf8mb4_unicode_ci DEFAULT 'in_stock',
  `shipping_cost` decimal(12,2) DEFAULT '0.00',
  `multiply_qty` tinyint(1) DEFAULT '0',
  `digital_file` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `digital_file_type` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_featured` tinyint(1) DEFAULT '0',
  `is_todays_deal` tinyint(1) DEFAULT '0',
  `published` tinyint(1) DEFAULT '0',
  `status` enum('pending','approved','rejected') COLLATE utf8mb4_unicode_ci DEFAULT 'pending',
  `denied_reason` text COLLATE utf8mb4_unicode_ci,
  `meta_title` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `meta_description` text COLLATE utf8mb4_unicode_ci,
  `meta_image` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `products`
--

INSERT INTO `products` (`id`, `seller_id`, `brand_id`, `category_id`, `sub_category_id`, `name`, `slug`, `sku`, `product_type`, `unit`, `tags`, `short_description`, `description`, `thumbnail`, `images`, `unit_price`, `purchase_price`, `tax`, `tax_type`, `discount`, `discount_type`, `current_stock`, `minimum_order_qty`, `low_stock_threshold`, `stock_status`, `shipping_cost`, `multiply_qty`, `digital_file`, `digital_file_type`, `is_featured`, `is_todays_deal`, `published`, `status`, `denied_reason`, `meta_title`, `meta_description`, `meta_image`, `created_at`, `updated_at`, `deleted_at`) VALUES
(10, 2, NULL, 2, 1, 'Wooden Model', 'wooden-model-ppISz', 'WD-DEC-0013267', 'physical', NULL, '[]', 'High-fidelity audio with active noise cancellation.', 'Experience studio-grade sound with ultra-comfortable ear cushions and up to 30 hours of battery life.', 'products/thumbnails/2026/09/538fe8c5-eca7-4a6a-8d5b-72cca3edad15_1788516052.webp', '[\"products/gallery/2026/09/24c9582f-f167-4553-bc72-610f1d568061_1788453894.webp\", \"products/gallery/2026/09/58d7c0e2-0bec-4a63-87c6-843f084f225c_1788453894.webp\", \"products/gallery/2026/09/c1c1d1dd-874c-45d9-be0c-6c0a259943af_1788453894.webp\", \"products/gallery/2026/09/c0b6280b-d53d-431c-84f0-10181387b6d4_1788453894.webp\", \"products/gallery/2026/09/25ad4d2a-5b85-4bfc-9113-821cf216bf60_1788453894.webp\"]', 199.99, 120.00, 0.00, 'flat', 10.00, 'percent', 46, 1, 5, 'in_stock', 0.00, 0, NULL, NULL, 1, 1, 1, 'approved', NULL, NULL, NULL, 'products/meta/2026/09/bbbec0a1-a136-4619-8d73-c0370bb783e4_1788453894.webp', '2026-09-03 15:44:54', '2026-09-05 11:32:46', NULL),
(11, 2, NULL, 2, 1, 'Supre Model', 'supre-model-OJ3vX', 'HP-ANC-00132673', 'physical', '1', '[]', 'High-fidelity audio with active noise cancellation.', 'Experience studio-grade sound with ultra-comfortable ear cushions and up to 30 hours of battery life.', 'products/thumbnails/2026/09/035ca177-d273-4b0e-937b-1cf8b9c3344a_1788515939.webp', '[\"products/gallery/2026/09/0d94221d-5bb7-4711-b398-dbba301b24cb_1788454241.webp\", \"products/gallery/2026/09/a583ab7a-ca85-4ee9-9e98-3cddab8ce529_1788454241.webp\", \"products/gallery/2026/09/e6d59e57-20cb-405d-b210-4f770049f8ab_1788454241.webp\", \"products/gallery/2026/09/d0c3a051-a1a7-4f0e-9ca9-42647504cc68_1788454241.webp\", \"products/gallery/2026/09/473bad28-2514-406f-8a08-7a5f54142981_1788454241.webp\"]', 199.99, 120.00, 0.00, 'flat', 10.00, 'percent', 46, 1, 5, 'in_stock', 0.00, 0, NULL, NULL, 1, 1, 1, 'approved', NULL, NULL, NULL, 'products/meta/2026/09/43e3c5b1-25cd-49a7-a5a2-ba2d303dac9e_1788515939.webp', '2026-09-03 15:50:41', '2026-09-06 15:01:33', NULL),
(12, 2, NULL, 14, NULL, 'Super Harp', 'super-harp-TbrQa', 'S-3288', 'physical', '200', '[\"Premium\", \"super\", \"musiv\", \"lover\"]', 'This is the best harp you will find in the market', 'This is the best harp you will find in the market This is the best harp you will find in the market This is the best harp you will find in the marketThis is the best harp you will find in the market This is the best harp you will find in the market This is the best harp you will find in the marketThis is the best harp you will find in the market This is the best harp you will find in the market This is the best harp you will find in the marketThis is the best harp you will find in the market This is the best harp you will find in the market This is the best harp you will find in the marketThis is the best harp you will find in the market This is the best harp you will find in the market This is the best harp you will find in the market', 'products/thumbnails/2026/09/2c812293-e5a6-4915-bd35-3763849ec1ea_1788516213.webp', '[\"products/gallery/2026/09/6d5038e0-4dd2-4556-8f12-a795b8c1fa7e_1788516213.webp\", \"products/gallery/2026/09/c2c170b1-db39-4c3e-b247-eccc1944349b_1788516213.webp\"]', 100.00, 100.00, 1.00, 'flat', 0.00, 'flat', 10, 1, 5, 'in_stock', 0.00, 0, NULL, NULL, 0, 0, 1, 'approved', NULL, 'Prime Music Only', NULL, 'products/meta/2026/09/72786463-3738-4349-bb0d-9e899ac0e927_1788516213.webp', '2026-09-04 09:03:33', '2026-09-04 09:03:33', NULL),
(13, 2, NULL, 6, NULL, 'Versace Pendant', 'versace-pendant-VbgMt', 'H-3266', 'physical', '1', '[]', 'This is the best in town', 'This is the best in town This is the best in town This is the best in townThis is the best in town This is the best in town This is the best in townThis is the best in town This is the best in town This is the best in townThis is the best in town This is the best in town This is the best in townThis is the best in town This is the best in town This is the best in townThis is the best in town This is the best in town This is the best in town', 'products/thumbnails/2026/09/b3c01dbc-087c-4cec-ae9e-64019c3c5a6a_1788516352.webp', '[]', 200.00, 200.00, 0.00, 'flat', 0.00, 'flat', 9, 1, 5, 'in_stock', 0.00, 0, NULL, NULL, 0, 0, 1, 'approved', NULL, NULL, NULL, NULL, '2026-09-04 09:05:52', '2026-09-06 15:01:33', NULL),
(14, 2, NULL, 3, NULL, 'Full Moon', 'full-moon-jXb3R', 'F-6174', 'physical', '1', '[\"moon\", \"decor\", \"vibes\", \"ruper\"]', 'This is the full moon over you', 'This is the full moon over you This is the full moon over you This is the full moon over youThis is the full moon over you This is the full moon over you This is the full moon over youThis is the full moon over you This is the full moon over you This is the full moon over youThis is the full moon over you This is the full moon over you This is the full moon over youThis is the full moon over you This is the full moon over you This is the full moon over you', 'products/thumbnails/2026/09/2a5ee47d-3d23-45c8-8018-9b2f07ae2c95_1788516439.webp', '[]', 1000.00, 1000.00, 0.00, 'flat', 0.00, 'flat', 6, 1, 5, 'in_stock', 0.00, 0, NULL, NULL, 0, 1, 1, 'approved', NULL, 'Vibes of the best', NULL, 'products/meta/2026/09/43741069-0e9f-4820-8d42-fe57c9c71c1d_1788516439.webp', '2026-09-04 09:07:19', '2026-09-06 15:01:33', NULL),
(15, 2, NULL, 12, NULL, 'Magic Labooboo', 'magic-labooboo-EOYvL', 'M-9692', 'physical', '2', '[]', 'Best', 'Best', 'products/thumbnails/2026/09/00df2f97-3331-4ce5-b25a-0dfa565c55a6_1788516764.webp', '[]', 122.00, 122.00, 0.00, 'flat', 0.00, 'flat', 7, 1, 5, 'in_stock', 0.00, 0, NULL, NULL, 0, 0, 1, 'approved', NULL, NULL, NULL, NULL, '2026-09-04 09:12:45', '2026-09-05 16:18:16', NULL),
(16, 2, NULL, 7, NULL, 'Super Leather Gem', 'super-leather-gem-0Hla5', 'S-8490', 'physical', 'pc', '[\"leather\"]', 'Super', 'Super', 'products/thumbnails/2026/09/9b7e9380-f3e2-4bff-8a69-bae2303af69f_1788516901.webp', '[]', 2000.00, 2000.00, 0.00, 'flat', 0.00, 'flat', 5, 1, 5, 'in_stock', 0.00, 0, NULL, NULL, 0, 1, 1, 'approved', NULL, NULL, NULL, NULL, '2026-09-04 09:15:01', '2026-09-06 15:01:33', NULL),
(17, 2, NULL, 8, NULL, 'Potters Ville', 'potters-ville-1Tbjj', 'P-3753', 'physical', 'kg', '[\"clay\", \"sand\", \"best\"]', 'Premium Clay', 'Premium Clay Premium Clay Premium ClayPremium Clay Premium Clay Premium ClayPremium Clay Premium Clay Premium ClayPremium Clay Premium Clay Premium ClayPremium Clay Premium Clay Premium ClayPremium Clay Premium Clay Premium ClayPremium Clay Premium Clay Premium ClayPremium Clay Premium Clay Premium ClayPremium Clay Premium Clay Premium ClayPremium Clay Premium Clay Premium ClayPremium Clay Premium Clay Premium ClayPremium Clay Premium Clay Premium ClayPremium Clay Premium Clay Premium ClayPremium Clay Premium Clay Premium ClayPremium Clay Premium Clay Premium Clay', 'products/thumbnails/2026/09/63b49dfe-71c7-4f5c-8478-4271a2c30133_1788516988.webp', '[]', 3000.00, 3000.00, 0.00, 'flat', 0.00, 'flat', 8, 1, 5, 'in_stock', 0.00, 0, NULL, NULL, 1, 0, 1, 'approved', NULL, NULL, NULL, NULL, '2026-09-04 09:16:28', '2026-09-05 11:47:00', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `product_reviews`
--

CREATE TABLE `product_reviews` (
  `id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `seller_id` bigint UNSIGNED DEFAULT NULL,
  `product_id` bigint UNSIGNED NOT NULL,
  `order_no` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `rating` tinyint UNSIGNED NOT NULL,
  `comment` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `product_variations`
--

CREATE TABLE `product_variations` (
  `id` bigint UNSIGNED NOT NULL,
  `product_id` bigint UNSIGNED NOT NULL,
  `attribute_id` int DEFAULT NULL,
  `attribute_value_ids` json DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `roles`
--

CREATE TABLE `roles` (
  `id` bigint UNSIGNED NOT NULL,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `slug` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `roles`
--

INSERT INTO `roles` (`id`, `name`, `slug`, `description`, `created_at`, `updated_at`) VALUES
(3, 'Compliance Teamj', 'compliance-teamj', 'Test Mealf', '2026-09-07 09:25:07', '2026-09-07 13:09:56'),
(4, 'Meta Base', 'meta-base', 'test', '2026-09-07 09:26:18', '2026-09-07 09:26:18');

-- --------------------------------------------------------

--
-- Table structure for table `role_has_permissions`
--

CREATE TABLE `role_has_permissions` (
  `role_id` bigint UNSIGNED NOT NULL,
  `permission_id` bigint UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `role_has_permissions`
--

INSERT INTO `role_has_permissions` (`role_id`, `permission_id`) VALUES
(3, 1),
(3, 2),
(4, 2),
(3, 3),
(4, 3),
(3, 4),
(4, 4),
(3, 5),
(4, 5),
(3, 6),
(3, 7),
(3, 8),
(3, 9),
(3, 10),
(3, 11),
(3, 12),
(3, 13),
(3, 14),
(3, 15),
(3, 16),
(3, 17),
(3, 18),
(3, 19),
(3, 20),
(3, 21),
(3, 22),
(3, 23),
(3, 24),
(3, 25),
(3, 26),
(3, 27),
(3, 28),
(3, 29),
(3, 30),
(3, 31),
(3, 32),
(3, 33),
(3, 34),
(3, 35),
(3, 36),
(3, 37),
(3, 38),
(3, 39),
(3, 40),
(3, 41),
(3, 42),
(3, 43),
(3, 44),
(3, 45),
(3, 46),
(3, 47),
(3, 48),
(3, 49),
(3, 50),
(3, 51),
(3, 52),
(3, 53),
(3, 54),
(3, 55),
(3, 56),
(3, 57),
(3, 58),
(3, 59),
(3, 60);

-- --------------------------------------------------------

--
-- Table structure for table `settings`
--

CREATE TABLE `settings` (
  `id` bigint UNSIGNED NOT NULL,
  `key` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `value` longtext COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `settings`
--

INSERT INTO `settings` (`id`, `key`, `value`, `created_at`, `updated_at`) VALUES
(1, 'site_name', 'Market My Art Platform', '2026-08-27 21:02:37', '2026-09-01 15:18:50'),
(2, 'site_email', 'support@marketmyart.com', '2026-08-27 21:02:37', '2026-09-01 15:18:50'),
(3, 'site_phone', '+23480000011113', '2026-08-27 21:02:37', '2026-09-01 15:31:35'),
(4, 'site_currency', 'NGN', '2026-08-27 21:02:37', '2026-09-05 20:10:14'),
(5, 'currency_symbol', '₦', '2026-08-27 21:02:37', '2026-09-05 20:10:14'),
(6, 'maintenance_mode', '0', '2026-08-27 21:02:37', '2026-09-01 20:40:15'),
(7, 'maintenance_message', 'We are performing a major upgrade. Back in 30 minutes!', '2026-08-27 21:02:37', '2026-09-01 20:37:56'),
(8, 'global_meta_title', 'Best Online Store - Shop Top Quality Products', '2026-08-27 21:02:37', '2026-08-27 21:02:37'),
(9, 'global_meta_description', 'Discover amazing deals on top products across electronics, fashion, and home items.s', '2026-08-27 21:02:37', '2026-09-01 16:02:07'),
(10, 'global_meta_keywords', 'ecommerce, online shopping, electronics, deals', '2026-08-27 21:02:37', '2026-08-27 21:02:37'),
(11, 'global_meta_image', 'https://storage.example.com/settings/global-og.png', '2026-08-27 21:02:37', '2026-08-27 21:02:37'),
(12, 'homepage_meta_title', 'Welcome to Our Store - Exclusive Deals Today', '2026-08-27 21:02:37', '2026-08-27 21:02:37'),
(13, 'homepage_meta_description', 'Shop our exclusive landing page collection with flash sales and top brands.s', '2026-08-27 21:02:37', '2026-09-01 16:01:56'),
(14, 'homepage_meta_keywords', 'home deals, trending items, shop now', '2026-08-27 21:02:37', '2026-08-27 21:02:37'),
(16, 'sms_notification', '1', '2026-08-27 21:02:37', '2026-09-05 15:51:19'),
(17, 'email_notification', '1', '2026-08-27 21:02:37', '2026-09-05 14:00:39'),
(18, 'push_notification', '1', '2026-08-27 21:02:37', '2026-09-01 16:28:12'),
(19, 'logo', 'logos/EmCCVz6BcNkdgZgimDbsnkwjwK53DzoMssAX8pBQ.png', '2026-08-27 21:02:37', '2026-09-07 18:15:46');

-- --------------------------------------------------------

--
-- Table structure for table `storefronts`
--

CREATE TABLE `storefronts` (
  `id` bigint UNSIGNED NOT NULL,
  `seller_id` bigint UNSIGNED NOT NULL,
  `name` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `slug` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `logo` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `banner` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `currency` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'USD',
  `status` enum('active','inactive','suspended') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'active',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `storefronts`
--

INSERT INTO `storefronts` (`id`, `seller_id`, `name`, `slug`, `logo`, `banner`, `description`, `currency`, `status`, `created_at`, `updated_at`) VALUES
(1, 2, 'Amelia', 'amelia', 'storefronts/logos/jDtDyxlsvLYHIi4CcxzHy28ZhYFTMTTyFuXbAnLt.jpg', 'storefronts/banners/oLEfuxVYaFqqwhSNnvOFhRuNSWKerdLOY6U93FYp.jpg', 'Thi sis the best of them all', 'NGN', 'active', '2026-08-27 22:42:20', '2026-09-06 14:40:57');

-- --------------------------------------------------------

--
-- Table structure for table `sub_categories`
--

CREATE TABLE `sub_categories` (
  `id` bigint UNSIGNED NOT NULL,
  `category_id` bigint UNSIGNED NOT NULL,
  `name` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `slug` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `priority` int DEFAULT '0',
  `status` enum('inactive','active') COLLATE utf8mb4_unicode_ci DEFAULT 'active',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `sub_categories`
--

INSERT INTO `sub_categories` (`id`, `category_id`, `name`, `slug`, `priority`, `status`, `created_at`, `updated_at`) VALUES
(1, 14, 'Old Music', 'old-music', 1, 'active', '2026-09-03 16:28:02', '2026-09-03 16:28:02');

-- --------------------------------------------------------

--
-- Table structure for table `tickets`
--

CREATE TABLE `tickets` (
  `id` bigint UNSIGNED NOT NULL,
  `ticket_id` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Human-readable ID e.g., TCK-984021',
  `user_id` bigint UNSIGNED NOT NULL,
  `subject` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `priority` enum('low','medium','high','urgent') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'medium',
  `status` enum('open','replied','closed') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'open',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `tickets`
--

INSERT INTO `tickets` (`id`, `ticket_id`, `user_id`, `subject`, `priority`, `status`, `created_at`, `updated_at`) VALUES
(1, 'TCK-849201', 3, 'Payment charged but order status still pending', 'high', 'closed', '2026-08-27 20:34:11', '2026-09-01 15:17:17'),
(2, 'TCK-392014', 3, 'Unable to apply promo code at checkout', 'medium', 'closed', '2026-08-27 20:34:11', '2026-09-06 14:49:16'),
(3, 'TCK-710492', 3, 'Requesting refund for damaged item', 'urgent', 'open', '2026-08-27 20:34:11', '2026-08-27 20:34:11'),
(4, 'TCK-109482', 3, 'How do I track my active delivery?', 'low', 'open', '2026-08-27 20:34:11', '2026-08-27 20:34:11'),
(5, 'TCK-654930', 3, 'Account login failing after password reset', 'medium', 'open', '2026-08-27 20:34:11', '2026-08-27 20:34:11');

-- --------------------------------------------------------

--
-- Table structure for table `ticket_messages`
--

CREATE TABLE `ticket_messages` (
  `id` bigint UNSIGNED NOT NULL,
  `ticket_id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL COMMENT 'ID of sender (User or Admin)',
  `message` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `attachments` json DEFAULT NULL COMMENT 'Array of file URLs/paths',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `ticket_messages`
--

INSERT INTO `ticket_messages` (`id`, `ticket_id`, `user_id`, `message`, `attachments`, `created_at`, `updated_at`) VALUES
(1, 1, 3, 'I was debited for my order #10024 via card payment, but my order status is still showing pending on the portal. Kindly check.', '[\"https://storage.example.com/tickets/debit_alert_proof.png\"]', '2026-08-27 20:34:11', '2026-08-27 20:34:11'),
(2, 2, 3, 'Whenever I enter the coupon code \"WELCOME10\" during checkout, it gives me an invalid code error even though it is active.', NULL, '2026-08-27 20:34:11', '2026-08-27 20:34:11'),
(3, 3, 3, 'The items delivered to me today arrived damaged. The outer packaging was crushed. I would like to request a full refund or immediate replacement.', '[\"https://storage.example.com/tickets/damaged_box1.jpg\", \"https://storage.example.com/tickets/damaged_box2.jpg\"]', '2026-08-27 20:34:11', '2026-08-27 20:34:11'),
(4, 4, 3, 'My order #10018 was marked as dispatched 2 days ago. Where can I view the live tracking link for the dispatch rider?', NULL, '2026-08-27 20:34:11', '2026-08-27 20:34:11'),
(5, 5, 3, 'I requested a password reset link earlier today and updated my credentials, but when I try signing in with the new password, it keeps saying invalid credentials.', NULL, '2026-08-27 20:34:11', '2026-08-27 20:34:11'),
(6, 1, 1, 'We are here now ready', '[]', '2026-09-01 15:17:08', '2026-09-01 15:17:08'),
(7, 2, 1, 'No issues', '[]', '2026-09-06 14:48:59', '2026-09-06 14:48:59');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `phone` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `google2fa_secret` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `google2fa_enabled` int NOT NULL DEFAULT '0',
  `avatar` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'avatar.png',
  `otp` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `otp_sent_at` datetime DEFAULT NULL,
  `type` enum('admin','seller','buyer','dispatch','staff') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'buyer',
  `last_login` timestamp NULL DEFAULT NULL,
  `status` enum('pending','active','blocked','disabled') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `login_attempts` int DEFAULT '0',
  `remember_token` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_by` int DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `email_verified_at`, `phone`, `password`, `google2fa_secret`, `google2fa_enabled`, `avatar`, `otp`, `otp_sent_at`, `type`, `last_login`, `status`, `login_attempts`, `remember_token`, `created_by`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 'Oluwakayode John', 'admin@admin.com', '2025-07-04 05:25:44', '+2348012345678', '$2y$12$9T.mwWRAyZoG/9ohlDJ06u39zJQZ7hilBoT6u5.Jp6U9UGklvqsrG', 'OUHE6D2E7CDKPYAY', 0, 'avatars/YP5vMXpplfjWnqS5glrhjQYjFe7u8k4715MwdALw.png', NULL, NULL, 'admin', '2026-08-25 10:17:57', 'active', 0, NULL, NULL, '2025-07-04 05:25:44', '2026-09-07 18:26:08', NULL),
(2, 'Mathew Andrew', 'amelia@test.com', '2025-07-04 05:25:44', '08023223223', '$2y$12$0.Zwrvvc3W1ZQTLAwDb.DeWbO5jQ4qWAt1sivi5lJI2XA7GX6vLKi', NULL, 0, 'inclusive HRMs-1 (1)_1753282162.jpg', NULL, NULL, 'seller', '2026-08-25 10:17:57', 'active', 0, 'KWtBeiYgWWcmLlmdmligoAE5FANM7j4cwu7G0LdA', NULL, '2025-07-04 05:25:44', '2026-09-06 13:34:16', NULL),
(3, 'Oluwakayode Adetunji', 'buyer@buyer.com', '2025-07-04 05:25:44', '+2348000000000', '$2y$12$WipKF5PB70tpsmCsJMSnJucrYTXUPyVcQ0bNgYeiI1M/uzEttXUvK', 'VH25Q2ROVUWTZ4QJ', 0, '/storage/app/public/avatars/o3UHGmRXuPAPGWfnp1pc9plDOxn5sWuixEUjqBVF.png', NULL, NULL, 'buyer', '2026-08-25 10:17:57', 'active', 0, 'KWtBeiYgWWcmLlmdmligoAE5FANM7j4cwu7G0LdA', NULL, '2025-07-04 05:25:44', '2026-09-08 15:58:00', NULL),
(4, 'New Staff', 'newstaff@example.com', '2025-07-04 05:25:44', '08034334334', '$2y$12$ChY6Th0gWER86lS8TPuHuO/r3TtKyly8UqNlbPYc8FphTrQo.IMom', NULL, 0, 'avatars/b9yIcHenQ0xkDHxNjwyaKl1shL6l0dq7XYdXV5eh.png', NULL, NULL, 'staff', '2026-08-25 10:17:57', 'active', 0, 'KWtBeiYgWWcmLlmdmligoAE5FANM7j4cwu7G0LdA', NULL, '2025-07-04 05:25:44', '2026-08-31 08:50:44', NULL),
(44, 'John Doe', 'teser@gmail.com', NULL, '08034334334', '$2y$12$vbyrqJ78vWjF7d0mxxUV4Otad6ASIJXOHEbLrUTOM9LCy7RqbulQu', NULL, 0, 'avatar.png', NULL, NULL, 'staff', NULL, 'disabled', 0, NULL, NULL, '2026-08-31 09:38:23', '2026-08-31 10:17:14', '2026-08-31 11:17:14'),
(45, 'John Doe', 'sdsa@gmail.comw', NULL, '08034334334', '$2y$12$eZtOFuZeL1s.GpsbFFO.b.FA6zhePsOfJ8pcrVWS3F/GEX5BproAG', NULL, 0, 'avatar.png', NULL, NULL, 'staff', NULL, 'pending', 0, NULL, NULL, '2026-08-31 09:39:05', '2026-08-31 09:39:05', NULL),
(46, 'John Doe', '32w@gmail.comws', NULL, '08034334334', '$2y$12$NKHu.pZuxRhZ3/P39X3bve82Jhia10y5.5VG.3NJo78T8CsSYGljG', NULL, 0, 'avatar.png', NULL, NULL, 'staff', NULL, 'pending', 0, NULL, NULL, '2026-08-31 09:40:52', '2026-08-31 09:40:52', NULL),
(47, 'Mr Parker', 'buyer2@buye2r.com', NULL, '08012112112', '$2y$12$mX/LIZ4NZFDLe4ndc1xX3uJ8zQpMLouBw39CoomXHzIeXJEOQbsmu', NULL, 0, 'avatar.png', '$2y$12$cDerL19jbNDnG3RatBZZq.W9HwCG/IfPgau0aO5R5wXjshs/nSjfW', NULL, 'buyer', NULL, 'pending', 0, NULL, NULL, '2026-09-03 13:48:06', '2026-09-03 13:48:06', NULL),
(48, 'James Parker', 'buyer2@mail.com', NULL, '123234234324', '$2y$12$UK36fvemYKEnjtV1egBgAePDnhVUj1KqUHKY6NU5YVLcr7KYiiR7y', NULL, 0, 'avatar.png', '$2y$12$Jzk57dXad1X838NbcY95UuG9W0b97AnQZ08Uov91oVl0RjyYUyCMS', '2026-09-03 15:05:08', 'buyer', NULL, 'pending', 0, NULL, NULL, '2026-09-03 13:59:15', '2026-09-03 14:05:08', NULL),
(49, 'Dele Frio', 'buyer@sdeq.com', '2026-09-03 14:08:09', '334523234', '$2y$12$imQddhynmbJ6mRv7I.lJve69cpsQbwyCbvjy81XgIWBhqOfp0zQhm', NULL, 0, 'avatar.png', NULL, NULL, 'buyer', NULL, 'active', 0, NULL, NULL, '2026-09-03 14:07:56', '2026-09-03 14:08:09', NULL),
(50, 'John Doe', 'buyer@buyer.comms', '2026-09-04 20:10:36', '23432432432432', '$2y$12$Xxn4D8yhGY/Dg2b09SYfQe/upo7E1J732VR8SevGITvtS5.Aa4btm', NULL, 0, 'avatar.png', NULL, '2026-09-04 21:10:22', 'buyer', NULL, 'active', 0, NULL, NULL, '2026-09-04 19:58:55', '2026-09-04 20:10:36', NULL),
(51, 'Adele', 'adele@mma.com', NULL, '080267834', '$2y$12$YZrrjMh51Ue0dtl/ko0oYevoDNrvdqjFTV3zzOgmOmFYFxm7ZSEQ.', NULL, 0, 'avatar.png', NULL, NULL, 'staff', NULL, 'pending', 0, NULL, 1, '2026-09-06 14:39:03', '2026-09-06 14:39:03', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `user_addresses`
--

CREATE TABLE `user_addresses` (
  `id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `address` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `city` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `zip` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `state` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `country` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_default` tinyint(1) DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `user_addresses`
--

INSERT INTO `user_addresses` (`id`, `user_id`, `address`, `city`, `zip`, `state`, `country`, `is_default`, `created_at`, `updated_at`) VALUES
(2, 1, '12, Adele Street', 'Ikeja', '234', 'Ogba', 'Nigeria', 1, '2026-09-05 07:50:24', '2026-09-05 07:50:24'),
(3, 3, '123 Lekki Phase 1', 'Lagos', NULL, 'Lagos State', 'Nigeria', 1, '2026-09-08 15:52:40', '2026-09-08 15:52:40');

-- --------------------------------------------------------

--
-- Table structure for table `user_bank_details`
--

CREATE TABLE `user_bank_details` (
  `id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `bank_code` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `bank_name` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `account_number` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `account_name` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_active` tinyint(1) DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `user_bank_details`
--

INSERT INTO `user_bank_details` (`id`, `user_id`, `bank_code`, `bank_name`, `account_number`, `account_name`, `is_active`, `created_at`, `updated_at`) VALUES
(1, 2, '058', 'GTBank', '0123456789', 'James Alex', 1, '2026-08-27 14:47:53', '2026-09-01 10:53:10'),
(2, 3, '033', 'United Bank for Africa', '9876543210', 'July Hammed', 1, '2026-08-27 14:47:53', '2026-09-01 10:53:15');

-- --------------------------------------------------------

--
-- Table structure for table `user_has_roles`
--

CREATE TABLE `user_has_roles` (
  `user_id` bigint UNSIGNED NOT NULL,
  `role_id` bigint UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `user_invitations`
--

CREATE TABLE `user_invitations` (
  `id` bigint UNSIGNED NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `role_id` bigint UNSIGNED NOT NULL,
  `token` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` enum('pending','accepted','expired','revoked') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `invited_by` bigint UNSIGNED NOT NULL,
  `expires_at` timestamp NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `user_logins`
--

CREATE TABLE `user_logins` (
  `id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `ip_address` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `country` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `city` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `browser` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `platform` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `device_type` enum('desktop','mobile','tablet','bot','unknown') COLLATE utf8mb4_unicode_ci DEFAULT 'unknown',
  `device_name` varchar(150) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_agent` text COLLATE utf8mb4_unicode_ci,
  `logged_in_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `user_logins`
--

INSERT INTO `user_logins` (`id`, `user_id`, `ip_address`, `country`, `city`, `browser`, `platform`, `device_type`, `device_name`, `user_agent`, `logged_in_at`) VALUES
(1, 1, '127.0.0.1', 'United States', 'Ashburn', 'Unknown Browser', 'Unknown Platform', 'desktop', 'Unknown Platform (Unknown Browser)', 'PostmanRuntime/2.3.0', '2026-08-25 10:47:14'),
(2, 1, '127.0.0.1', 'United States', 'Ashburn', 'Unknown Browser', 'Unknown Platform', 'desktop', 'Unknown Platform (Unknown Browser)', 'PostmanRuntime/2.3.0', '2026-08-25 10:55:37'),
(3, 1, '127.0.0.1', 'United States', 'Ashburn', 'Unknown Browser', 'Unknown Platform', 'desktop', 'Unknown Platform (Unknown Browser)', 'PostmanRuntime/2.4.0', '2026-08-29 05:24:55'),
(4, 1, '127.0.0.1', 'United States', 'Ashburn', 'Chrome', 'macOS', 'desktop', 'macOS (Chrome)', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-29 06:41:31'),
(5, 1, '127.0.0.1', 'United States', 'Ashburn', 'Chrome', 'macOS', 'desktop', 'macOS (Chrome)', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-29 06:42:13'),
(6, 1, '127.0.0.1', 'United States', 'Ashburn', 'Chrome', 'macOS', 'desktop', 'macOS (Chrome)', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-29 06:45:25'),
(7, 1, '127.0.0.1', 'United States', 'Ashburn', 'Chrome', 'macOS', 'desktop', 'macOS (Chrome)', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-29 06:45:32'),
(8, 1, '127.0.0.1', 'United States', 'Ashburn', 'Chrome', 'macOS', 'desktop', 'macOS (Chrome)', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-29 06:46:23'),
(9, 1, '127.0.0.1', 'United States', 'Ashburn', 'Chrome', 'macOS', 'desktop', 'macOS (Chrome)', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-29 06:46:46'),
(10, 1, '127.0.0.1', 'United States', 'Ashburn', 'Chrome', 'macOS', 'desktop', 'macOS (Chrome)', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-29 06:54:49'),
(11, 1, '127.0.0.1', 'United States', 'Ashburn', 'Chrome', 'macOS', 'desktop', 'macOS (Chrome)', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-29 06:56:28'),
(12, 1, '127.0.0.1', 'United States', 'Ashburn', 'Chrome', 'macOS', 'desktop', 'macOS (Chrome)', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-29 06:56:35'),
(13, 1, '127.0.0.1', 'United States', 'Ashburn', 'Chrome', 'macOS', 'desktop', 'macOS (Chrome)', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-29 07:05:06'),
(14, 1, '127.0.0.1', 'United States', 'Ashburn', 'Chrome', 'macOS', 'desktop', 'macOS (Chrome)', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-29 07:05:20'),
(15, 3, '127.0.0.1', 'United States', 'Ashburn', 'Unknown Browser', 'Unknown Platform', 'desktop', 'Unknown Platform (Unknown Browser)', 'PostmanRuntime/2.4.3', '2026-09-03 05:45:02'),
(16, 3, '127.0.0.1', 'United States', 'Ashburn', 'Chrome', 'macOS', 'desktop', 'macOS (Chrome)', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-09-03 12:55:56'),
(17, 3, '127.0.0.1', 'United States', 'Ashburn', 'Chrome', 'macOS', 'desktop', 'macOS (Chrome)', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-09-03 12:59:21'),
(18, 3, '127.0.0.1', 'United States', 'Ashburn', 'Chrome', 'macOS', 'desktop', 'macOS (Chrome)', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-09-03 13:13:08'),
(19, 49, '127.0.0.1', 'United States', 'Ashburn', 'Chrome', 'macOS', 'desktop', 'macOS (Chrome)', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-09-03 14:08:09'),
(20, 1, '127.0.0.1', 'United States', 'Ashburn', 'Chrome', 'macOS', 'desktop', 'macOS (Chrome)', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-09-04 07:28:12'),
(21, 3, '127.0.0.1', 'United States', 'Ashburn', 'Chrome', 'macOS', 'desktop', 'macOS (Chrome)', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '2026-09-04 19:03:29'),
(22, 3, '127.0.0.1', 'United States', 'Ashburn', 'Unknown Browser', 'Unknown Platform', 'desktop', 'Unknown Platform (Unknown Browser)', 'PostmanRuntime/2.4.3', '2026-09-04 20:05:14'),
(23, 50, '127.0.0.1', 'United States', 'Ashburn', 'Chrome', 'macOS', 'desktop', 'macOS (Chrome)', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '2026-09-04 20:10:36'),
(24, 3, '127.0.0.1', 'United States', 'Ashburn', 'Chrome', 'macOS', 'desktop', 'macOS (Chrome)', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '2026-09-05 04:40:08'),
(25, 3, '127.0.0.1', 'United States', 'Ashburn', 'Chrome', 'macOS', 'desktop', 'macOS (Chrome)', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '2026-09-05 04:41:32'),
(26, 3, '127.0.0.1', 'United States', 'Ashburn', 'Chrome', 'macOS', 'desktop', 'macOS (Chrome)', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '2026-09-05 05:58:03'),
(27, 3, '127.0.0.1', 'United States', 'Ashburn', 'Chrome', 'macOS', 'desktop', 'macOS (Chrome)', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '2026-09-05 07:01:42'),
(28, 3, '127.0.0.1', 'United States', 'Ashburn', 'Unknown Browser', 'Unknown Platform', 'desktop', 'Unknown Platform (Unknown Browser)', 'PostmanRuntime/2.4.3', '2026-09-05 07:03:03'),
(29, 3, '127.0.0.1', 'United States', 'Ashburn', 'Chrome', 'macOS', 'desktop', 'macOS (Chrome)', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '2026-09-05 07:03:54'),
(30, 1, '127.0.0.1', 'United States', 'Ashburn', 'Chrome', 'macOS', 'desktop', 'macOS (Chrome)', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '2026-09-05 13:29:15'),
(31, 1, '127.0.0.1', 'United States', 'Ashburn', 'Chrome', 'macOS', 'desktop', 'macOS (Chrome)', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '2026-09-05 14:05:55'),
(32, 3, '127.0.0.1', 'United States', 'Ashburn', 'Chrome', 'macOS', 'desktop', 'macOS (Chrome)', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '2026-09-06 12:45:17'),
(33, 1, '127.0.0.1', 'United States', 'Ashburn', 'Chrome', 'macOS', 'desktop', 'macOS (Chrome)', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '2026-09-06 14:10:09'),
(34, 1, '127.0.0.1', 'United States', 'Ashburn', 'Chrome', 'macOS', 'desktop', 'macOS (Chrome)', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '2026-09-06 14:10:59'),
(35, 3, '127.0.0.1', 'United States', 'Ashburn', 'Chrome', 'macOS', 'desktop', 'macOS (Chrome)', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '2026-09-06 14:58:43'),
(36, 1, '127.0.0.1', 'United States', 'Ashburn', 'Chrome', 'macOS', 'desktop', 'macOS (Chrome)', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '2026-09-07 08:10:14'),
(37, 1, '127.0.0.1', 'United States', 'Ashburn', 'Chrome', 'macOS', 'desktop', 'macOS (Chrome)', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '2026-09-07 15:15:32'),
(38, 1, '127.0.0.1', 'United States', 'Ashburn', 'Unknown Browser', 'Unknown Platform', 'desktop', 'Unknown Platform (Unknown Browser)', 'PostmanRuntime/2.4.3', '2026-09-07 15:48:25'),
(39, 1, '127.0.0.1', 'United States', 'Ashburn', 'Chrome', 'macOS', 'desktop', 'macOS (Chrome)', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '2026-09-07 17:41:25'),
(40, 1, '127.0.0.1', 'United States', 'Ashburn', 'Chrome', 'macOS', 'desktop', 'macOS (Chrome)', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '2026-09-07 18:26:09'),
(41, 3, '127.0.0.1', 'United States', 'Ashburn', 'Chrome', 'macOS', 'desktop', 'macOS (Chrome)', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '2026-09-07 19:57:18'),
(42, 1, '127.0.0.1', 'United States', 'Ashburn', 'Chrome', 'macOS', 'desktop', 'macOS (Chrome)', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '2026-09-07 20:06:05'),
(43, 3, '127.0.0.1', 'United States', 'Ashburn', 'Chrome', 'macOS', 'desktop', 'macOS (Chrome)', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '2026-09-08 10:22:13'),
(44, 3, '127.0.0.1', 'United States', 'Ashburn', 'Chrome', 'macOS', 'desktop', 'macOS (Chrome)', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '2026-09-08 10:50:49');

-- --------------------------------------------------------

--
-- Table structure for table `user_wallets`
--

CREATE TABLE `user_wallets` (
  `id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `balance` decimal(15,2) NOT NULL DEFAULT '0.00',
  `pending_balance` decimal(15,2) NOT NULL DEFAULT '0.00',
  `withdraw_lock` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `user_wallets`
--

INSERT INTO `user_wallets` (`id`, `user_id`, `balance`, `pending_balance`, `withdraw_lock`, `created_at`, `updated_at`) VALUES
(1, 2, 1000.00, 500.00, 0, '2026-08-27 22:43:16', '2026-08-27 22:43:40');

-- --------------------------------------------------------

--
-- Table structure for table `withdrawals`
--

CREATE TABLE `withdrawals` (
  `id` bigint UNSIGNED NOT NULL,
  `reference` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `user_bank_detail_id` bigint UNSIGNED NOT NULL,
  `amount` decimal(15,2) NOT NULL DEFAULT '0.00',
  `fee` decimal(15,2) NOT NULL DEFAULT '0.00',
  `net_amount` decimal(15,2) NOT NULL DEFAULT '0.00',
  `status` enum('pending','approved','declined','processing') COLLATE utf8mb4_unicode_ci DEFAULT 'pending',
  `admin_notes` text COLLATE utf8mb4_unicode_ci,
  `processed_by_user_id` bigint UNSIGNED DEFAULT NULL,
  `processed_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `attributes`
--
ALTER TABLE `attributes`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `attribute_values`
--
ALTER TABLE `attribute_values`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_attribute_values_attribute` (`attribute_id`);

--
-- Indexes for table `audit_logs`
--
ALTER TABLE `audit_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_user_id` (`user_id`),
  ADD KEY `idx_action` (`action`);

--
-- Indexes for table `blogs`
--
ALTER TABLE `blogs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `slug` (`slug`);

--
-- Indexes for table `brands`
--
ALTER TABLE `brands`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `slug` (`slug`);

--
-- Indexes for table `carts`
--
ALTER TABLE `carts`
  ADD PRIMARY KEY (`id`),
  ADD KEY `carts_user_id_foreign` (`user_id`),
  ADD KEY `carts_session_id_index` (`guest_token`),
  ADD KEY `carts_status_last_activity_index` (`status`,`last_activity_at`);

--
-- Indexes for table `cart_items`
--
ALTER TABLE `cart_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `cart_items_cart_id_foreign` (`cart_id`),
  ADD KEY `cart_items_product_id_foreign` (`product_id`);

--
-- Indexes for table `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `slug` (`slug`);

--
-- Indexes for table `coupons`
--
ALTER TABLE `coupons`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `code` (`code`);

--
-- Indexes for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`);

--
-- Indexes for table `flash_sales`
--
ALTER TABLE `flash_sales`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `frontend_contents`
--
ALTER TABLE `frontend_contents`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `slug` (`slug`);

--
-- Indexes for table `jobs`
--
ALTER TABLE `jobs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `jobs_queue_index` (`queue`);

--
-- Indexes for table `notifications`
--
ALTER TABLE `notifications`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_notifications_user_read` (`user_id`,`user_read`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `order_no` (`order_no`),
  ADD KEY `idx_orders_user_id` (`user_id`);

--
-- Indexes for table `order_items`
--
ALTER TABLE `order_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `order_id` (`order_id`);

--
-- Indexes for table `order_refunds`
--
ALTER TABLE `order_refunds`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `order_refunds_refund_no_unique` (`refund_no`),
  ADD KEY `order_refunds_order_id_foreign` (`order_id`),
  ADD KEY `order_refunds_user_id_foreign` (`user_id`),
  ADD KEY `order_refunds_seller_id_foreign` (`seller_id`),
  ADD KEY `order_refunds_status_index` (`status`);

--
-- Indexes for table `order_settlements`
--
ALTER TABLE `order_settlements`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_order_settlements_seller` (`seller_id`,`status`);

--
-- Indexes for table `order_status_histories`
--
ALTER TABLE `order_status_histories`
  ADD PRIMARY KEY (`id`),
  ADD KEY `order_id` (`order_id`);

--
-- Indexes for table `order_transactions`
--
ALTER TABLE `order_transactions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `order_transactions_ref_unique` (`transaction_ref`),
  ADD KEY `order_transactions_order_id_foreign` (`order_id`),
  ADD KEY `order_transactions_user_id_foreign` (`user_id`),
  ADD KEY `order_transactions_status_index` (`status`),
  ADD KEY `idx_transactions_user_id` (`user_id`);

--
-- Indexes for table `payment_gateways`
--
ALTER TABLE `payment_gateways`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `slug` (`slug`);

--
-- Indexes for table `permissions`
--
ALTER TABLE `permissions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `slug` (`slug`);

--
-- Indexes for table `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `personal_access_tokens_token_unique` (`token`),
  ADD KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`);

--
-- Indexes for table `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `slug` (`slug`),
  ADD UNIQUE KEY `sku` (`sku`),
  ADD KEY `idx_products_seller` (`seller_id`),
  ADD KEY `idx_products_category` (`category_id`),
  ADD KEY `idx_products_sub_category` (`sub_category_id`),
  ADD KEY `idx_products_brand` (`brand_id`),
  ADD KEY `idx_products_status` (`status`,`published`);

--
-- Indexes for table `product_reviews`
--
ALTER TABLE `product_reviews`
  ADD PRIMARY KEY (`id`),
  ADD KEY `product_reviews_order_no_index` (`order_no`),
  ADD KEY `product_reviews_user_id_foreign` (`user_id`),
  ADD KEY `product_reviews_seller_id_foreign` (`seller_id`),
  ADD KEY `product_reviews_product_id_foreign` (`product_id`);

--
-- Indexes for table `product_variations`
--
ALTER TABLE `product_variations`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_variations_product` (`product_id`);

--
-- Indexes for table `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `slug` (`slug`);

--
-- Indexes for table `role_has_permissions`
--
ALTER TABLE `role_has_permissions`
  ADD PRIMARY KEY (`role_id`,`permission_id`),
  ADD KEY `fk_rhp_permission` (`permission_id`);

--
-- Indexes for table `settings`
--
ALTER TABLE `settings`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `key` (`key`);

--
-- Indexes for table `storefronts`
--
ALTER TABLE `storefronts`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `seller_id` (`seller_id`),
  ADD UNIQUE KEY `slug` (`slug`);

--
-- Indexes for table `sub_categories`
--
ALTER TABLE `sub_categories`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `slug` (`slug`),
  ADD KEY `fk_sub_categories_category` (`category_id`);

--
-- Indexes for table `tickets`
--
ALTER TABLE `tickets`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `ticket_id` (`ticket_id`);

--
-- Indexes for table `ticket_messages`
--
ALTER TABLE `ticket_messages`
  ADD PRIMARY KEY (`id`),
  ADD KEY `ticket_id` (`ticket_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_email_unique` (`email`),
  ADD KEY `idx_type_status` (`type`,`status`);

--
-- Indexes for table `user_addresses`
--
ALTER TABLE `user_addresses`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_user_addresses_user_id` (`user_id`);

--
-- Indexes for table `user_bank_details`
--
ALTER TABLE `user_bank_details`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `user_has_roles`
--
ALTER TABLE `user_has_roles`
  ADD PRIMARY KEY (`user_id`,`role_id`),
  ADD KEY `fk_uhr_role` (`role_id`);

--
-- Indexes for table `user_invitations`
--
ALTER TABLE `user_invitations`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `token` (`token`),
  ADD KEY `fk_inv_role` (`role_id`),
  ADD KEY `fk_inv_user` (`invited_by`);

--
-- Indexes for table `user_logins`
--
ALTER TABLE `user_logins`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_users_logins_user_id` (`user_id`);

--
-- Indexes for table `user_wallets`
--
ALTER TABLE `user_wallets`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `user_id` (`user_id`);

--
-- Indexes for table `withdrawals`
--
ALTER TABLE `withdrawals`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `reference` (`reference`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `user_bank_detail_id` (`user_bank_detail_id`),
  ADD KEY `processed_by_user_id` (`processed_by_user_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `attributes`
--
ALTER TABLE `attributes`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `attribute_values`
--
ALTER TABLE `attribute_values`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `audit_logs`
--
ALTER TABLE `audit_logs`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=182;

--
-- AUTO_INCREMENT for table `blogs`
--
ALTER TABLE `blogs`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `brands`
--
ALTER TABLE `brands`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `carts`
--
ALTER TABLE `carts`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=160;

--
-- AUTO_INCREMENT for table `cart_items`
--
ALTER TABLE `cart_items`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=82;

--
-- AUTO_INCREMENT for table `categories`
--
ALTER TABLE `categories`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `coupons`
--
ALTER TABLE `coupons`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `flash_sales`
--
ALTER TABLE `flash_sales`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `frontend_contents`
--
ALTER TABLE `frontend_contents`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `jobs`
--
ALTER TABLE `jobs`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `notifications`
--
ALTER TABLE `notifications`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=43;

--
-- AUTO_INCREMENT for table `order_items`
--
ALTER TABLE `order_items`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=48;

--
-- AUTO_INCREMENT for table `order_refunds`
--
ALTER TABLE `order_refunds`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `order_settlements`
--
ALTER TABLE `order_settlements`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `order_status_histories`
--
ALTER TABLE `order_status_histories`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT for table `order_transactions`
--
ALTER TABLE `order_transactions`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `payment_gateways`
--
ALTER TABLE `payment_gateways`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `permissions`
--
ALTER TABLE `permissions`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=61;

--
-- AUTO_INCREMENT for table `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=285;

--
-- AUTO_INCREMENT for table `products`
--
ALTER TABLE `products`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT for table `product_reviews`
--
ALTER TABLE `product_reviews`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `product_variations`
--
ALTER TABLE `product_variations`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `roles`
--
ALTER TABLE `roles`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `settings`
--
ALTER TABLE `settings`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `storefronts`
--
ALTER TABLE `storefronts`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `sub_categories`
--
ALTER TABLE `sub_categories`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `tickets`
--
ALTER TABLE `tickets`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `ticket_messages`
--
ALTER TABLE `ticket_messages`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=52;

--
-- AUTO_INCREMENT for table `user_addresses`
--
ALTER TABLE `user_addresses`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `user_bank_details`
--
ALTER TABLE `user_bank_details`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `user_invitations`
--
ALTER TABLE `user_invitations`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `user_logins`
--
ALTER TABLE `user_logins`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=45;

--
-- AUTO_INCREMENT for table `user_wallets`
--
ALTER TABLE `user_wallets`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `withdrawals`
--
ALTER TABLE `withdrawals`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `attribute_values`
--
ALTER TABLE `attribute_values`
  ADD CONSTRAINT `fk_attribute_values_attribute` FOREIGN KEY (`attribute_id`) REFERENCES `attributes` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `audit_logs`
--
ALTER TABLE `audit_logs`
  ADD CONSTRAINT `audit_logs_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `carts`
--
ALTER TABLE `carts`
  ADD CONSTRAINT `carts_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `cart_items`
--
ALTER TABLE `cart_items`
  ADD CONSTRAINT `cart_items_cart_id_foreign` FOREIGN KEY (`cart_id`) REFERENCES `carts` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `notifications`
--
ALTER TABLE `notifications`
  ADD CONSTRAINT `fk_notifications_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `order_items`
--
ALTER TABLE `order_items`
  ADD CONSTRAINT `order_items_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `order_refunds`
--
ALTER TABLE `order_refunds`
  ADD CONSTRAINT `order_refunds_order_id_foreign` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `order_refunds_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `order_settlements`
--
ALTER TABLE `order_settlements`
  ADD CONSTRAINT `fk_settlements_seller` FOREIGN KEY (`seller_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `order_status_histories`
--
ALTER TABLE `order_status_histories`
  ADD CONSTRAINT `order_status_histories_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `order_transactions`
--
ALTER TABLE `order_transactions`
  ADD CONSTRAINT `order_transactions_order_id_foreign` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `order_transactions_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `products`
--
ALTER TABLE `products`
  ADD CONSTRAINT `fk_products_brand` FOREIGN KEY (`brand_id`) REFERENCES `brands` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_products_category` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_products_seller` FOREIGN KEY (`seller_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_products_sub_category` FOREIGN KEY (`sub_category_id`) REFERENCES `sub_categories` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `product_reviews`
--
ALTER TABLE `product_reviews`
  ADD CONSTRAINT `product_reviews_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `product_reviews_seller_id_foreign` FOREIGN KEY (`seller_id`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `product_reviews_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `product_variations`
--
ALTER TABLE `product_variations`
  ADD CONSTRAINT `fk_variations_product` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `role_has_permissions`
--
ALTER TABLE `role_has_permissions`
  ADD CONSTRAINT `fk_rhp_permission` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_rhp_role` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `storefronts`
--
ALTER TABLE `storefronts`
  ADD CONSTRAINT `fk_storefronts_seller_id` FOREIGN KEY (`seller_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `sub_categories`
--
ALTER TABLE `sub_categories`
  ADD CONSTRAINT `fk_sub_categories_category` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `ticket_messages`
--
ALTER TABLE `ticket_messages`
  ADD CONSTRAINT `ticket_messages_ibfk_1` FOREIGN KEY (`ticket_id`) REFERENCES `tickets` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `user_addresses`
--
ALTER TABLE `user_addresses`
  ADD CONSTRAINT `fk_user_addresses_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `user_bank_details`
--
ALTER TABLE `user_bank_details`
  ADD CONSTRAINT `user_bank_details_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `user_has_roles`
--
ALTER TABLE `user_has_roles`
  ADD CONSTRAINT `fk_uhr_role` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_uhr_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `user_invitations`
--
ALTER TABLE `user_invitations`
  ADD CONSTRAINT `fk_inv_role` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_inv_user` FOREIGN KEY (`invited_by`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `user_logins`
--
ALTER TABLE `user_logins`
  ADD CONSTRAINT `fk_users_logins_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `user_wallets`
--
ALTER TABLE `user_wallets`
  ADD CONSTRAINT `fk_user_wallets_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `withdrawals`
--
ALTER TABLE `withdrawals`
  ADD CONSTRAINT `withdrawals_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `withdrawals_ibfk_2` FOREIGN KEY (`user_bank_detail_id`) REFERENCES `user_bank_details` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `withdrawals_ibfk_3` FOREIGN KEY (`processed_by_user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
