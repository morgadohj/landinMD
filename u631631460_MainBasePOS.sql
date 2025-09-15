-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Sep 15, 2025 at 04:43 AM
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
-- Database: `u631631460_MainBasePOS`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `getTranslations` (IN `lang_id_param` INT)   BEGIN
    DECLARE EXISTS_TABLE INT DEFAULT 0;

    SELECT COUNT(*) INTO EXISTS_TABLE
    FROM INFORMATION_SCHEMA.TABLES 
    WHERE TABLE_SCHEMA = DATABASE() 
      AND TABLE_NAME = 'termns_conditions';

    IF EXISTS_TABLE = 1 THEN
        SELECT lang_key, 
               lang_value COLLATE utf8_general_ci AS lang_value
        FROM language_translations 
        WHERE lang_id = lang_id_param

        UNION ALL

        SELECT lang_key, 
               termns_conditions AS lang_value
        FROM termns_conditions 
        WHERE id_language = lang_id_param;
    ELSE
        SELECT lang_key, 
               lang_value 
        FROM language_translations 
        WHERE lang_id = lang_id_param;
    END IF;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `company_customer`
--

CREATE TABLE `company_customer` (
  `id` int(11) NOT NULL,
  `company_name` varchar(100) NOT NULL,
  `database_handle` varchar(100) NOT NULL,
  `rfc` varchar(13) NOT NULL,
  `address` varchar(11) NOT NULL,
  `id_regimen_fiscal` int(11) NOT NULL,
  `termns_conditions` bit(1) NOT NULL DEFAULT b'0',
  `user` varchar(100) DEFAULT NULL,
  `pass` varchar(100) DEFAULT NULL,
  `status` varchar(20) NOT NULL DEFAULT 'pending',
  `payment_status` varchar(20) DEFAULT 'pending',
  `package_type` varchar(50) DEFAULT NULL,
  `payment_reference` varchar(255) DEFAULT NULL,
  `payment_method` varchar(50) DEFAULT NULL,
  `paid_at` datetime DEFAULT NULL,
  `payment_token` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `trial_ends_at` datetime DEFAULT NULL,
  `subscription_expires_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `company_customer`
--

INSERT INTO `company_customer` (`id`, `company_name`, `database_handle`, `rfc`, `address`, `id_regimen_fiscal`, `termns_conditions`, `user`, `pass`, `status`, `payment_status`, `package_type`, `payment_reference`, `payment_method`, `paid_at`, `payment_token`, `created_at`, `trial_ends_at`, `subscription_expires_at`) VALUES
(74, 'josias', '_pos_josias', '', '0', 0, b'1', 'client_171054a6', 'f93d2601e1772dc8', 'active', 'pending', 'premium', NULL, NULL, NULL, NULL, '2025-07-30 09:20:01', '2025-08-14 09:20:01', '2029-08-14 09:20:01'),
(75, 'martin', '_pos_martin', '', '0', 0, b'1', 'client_3075ede2', 'b548d13fa4f7f383', 'active', 'approved', 'premium', '123395311271', 'account_money', '2025-08-27 19:22:22', NULL, '2025-08-05 11:54:42', '2025-08-20 11:54:42', '2025-09-27 19:22:22');

-- --------------------------------------------------------

--
-- Table structure for table `currency`
--

CREATE TABLE `currency` (
  `currency_id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `code` varchar(255) NOT NULL,
  `symbol_left` varchar(255) NOT NULL,
  `symbol_right` varchar(255) NOT NULL,
  `decimal_place` char(1) NOT NULL,
  `value` decimal(25,4) NOT NULL DEFAULT 1.0000,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `currency`
--

INSERT INTO `currency` (`currency_id`, `title`, `code`, `symbol_left`, `symbol_right`, `decimal_place`, `value`, `created_at`) VALUES
(1, 'United States Dollar', 'USD', '$', '', '2', 1.0000, '2024-03-30 08:07:33'),
(2, 'Pound Sterling', 'GBP', '£', '', '2', 0.6125, '2024-03-30 08:07:33'),
(3, 'Euro', 'EUR', '€', '', '2', 0.7846, '2024-03-30 08:07:33'),
(4, 'Hong Kong Dollar', 'HKD', 'HK$', '', '2', 7.8222, '2024-03-30 08:07:33'),
(5, 'Indian Rupee', 'INR', '₹', '', '2', 64.4000, '2024-03-30 08:07:33'),
(6, 'Russian Ruble', 'RUB', '₽', '', '2', 56.4036, '2024-03-30 08:07:33'),
(7, 'Chinese Yuan', 'CNY', '¥', '', '2', 6.3451, '2024-03-30 08:07:33'),
(9, 'Bangladeshi Taka', 'BDT', '৳', '', '2', 0.0000, '2024-03-30 08:07:33'),
(10, 'Pakistani Rupee ', 'PKR', '₨.', '', '2', 0.0000, '2024-03-30 08:07:33'),
(11, 'Croatian Kuna', 'HRK', 'kn', '', '2', 0.0000, '2024-03-30 08:07:33'),
(12, 'Malaysian Ringgit', 'MYR', 'RM', '', '2', 0.0000, '2024-03-30 08:07:33'),
(13, 'Saudi riyal', 'SAR', 'SR', '', '2', 0.0000, '2024-03-30 08:07:33'),
(14, 'Canadian Dollar', 'CAD', 'CAD $', '', '2', 0.0000, '2024-03-30 08:07:33'),
(17, 'Bitcoin', 'BTC', 'B', '', '0', 1.0000, '2024-03-30 08:07:33'),
(18, 'MX', 'MX', 'MX', 'MX', '.', 1.0000, '2024-11-05 09:20:40');

-- --------------------------------------------------------

--
-- Table structure for table `languages`
--

CREATE TABLE `languages` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(100) NOT NULL,
  `slug` varchar(50) NOT NULL,
  `code` varchar(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `languages`
--

INSERT INTO `languages` (`id`, `name`, `slug`, `code`) VALUES
(1, 'English', 'english', 'en'),
(7, 'Español', 'Español', 'ES');

-- --------------------------------------------------------

--
-- Table structure for table `language_translations`
--

CREATE TABLE `language_translations` (
  `id` int(11) NOT NULL,
  `lang_id` int(11) NOT NULL,
  `lang_key` varchar(100) NOT NULL,
  `key_type` enum('specific','default') NOT NULL DEFAULT 'specific',
  `lang_value` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `language_translations`
--

INSERT INTO `language_translations` (`id`, `lang_id`, `lang_key`, `key_type`, `lang_value`) VALUES
(12767, 1, 'text_Terminos_y_Condiciones.', 'specific', 'Terms and Conditions'),
(12768, 2, 'text_Terminos_y_Condiciones.', 'specific', 'Terminos y Condiciones'),
(12769, 1, 'text_Aceptar_terminos_condiciones.', 'specific', 'Accept terms and conditions.'),
(12770, 2, 'text_Aceptar_terminos_condiciones.', 'specific', 'Aceptar los terminos y condiciones.'),
(12771, 1, 'text_Rechazar', 'specific', 'Reject'),
(12772, 2, 'text_Rechazar', 'specific', 'Rechazar'),
(12773, 1, 'text_Continuar', 'specific', 'Continue'),
(12774, 2, 'text_Continuar', 'specific', 'Continuar'),
(12775, 1, 'text_login_title', 'specific', NULL),
(12776, 1, 'title_log_in', 'specific', NULL),
(12777, 1, 'text_login', 'specific', NULL),
(12778, 1, 'button_ingresar', 'specific', NULL),
(12779, 1, 'text_olvidaste_la_contraseña?', 'specific', NULL),
(12780, 1, 'text_mdsystems.com.mx_link', 'specific', NULL),
(12781, 1, 'text_MDsystems_text', 'specific', NULL),
(12782, 1, 'text_Terminos_y_Condiciones_Contenido.', 'specific', NULL),
(12783, 1, 'title_olvidaste_la_contraseña', 'specific', NULL),
(12784, 1, 'text_Por favor, ingresa tu correo electrónico. Te enviaremos un enlace para que sigas los pasos.', 'specific', NULL),
(12785, 1, 'button_close', 'specific', NULL),
(12786, 1, 'button_submit', 'specific', NULL),
(12787, 1, 'login_success', 'specific', NULL),
(12788, 1, 'error_invalid_username_password', 'specific', NULL),
(12789, 7, 'text_login_title', 'specific', NULL),
(12790, 7, 'title_dashboard', 'specific', NULL),
(12791, 7, 'error_invalid_username_password', 'specific', NULL),
(12792, 1, 'error_username', 'specific', NULL),
(12793, 1, 'error_access_permission', 'specific', NULL),
(12794, 1, 'text_select_store', 'specific', NULL),
(12795, 7, 'text_select_store', 'specific', NULL),
(12796, 7, 'title_log_in', 'specific', NULL),
(12797, 7, 'text_login', 'specific', NULL),
(12798, 7, 'button_ingresar', 'specific', NULL),
(12799, 7, 'text_olvidaste_la_contraseña?', 'specific', NULL),
(12800, 7, 'text_mdsystems.com.mx_link', 'specific', NULL),
(12801, 7, 'text_MDsystems_text', 'specific', NULL),
(12802, 7, 'text_Terminos_y_Condiciones.', 'specific', NULL),
(12803, 7, 'text_Aceptar_terminos_condiciones.', 'specific', NULL),
(12804, 7, 'text_Rechazar', 'specific', NULL),
(12805, 7, 'text_Continuar', 'specific', NULL),
(12806, 7, 'title_olvidaste_la_contraseña', 'specific', NULL),
(12807, 7, 'text_Por favor, ingresa tu correo electrónico. Te enviaremos un enlace para que sigas los pasos.', 'specific', NULL),
(12808, 7, 'button_close', 'specific', NULL),
(12809, 7, 'button_submit', 'specific', NULL),
(12810, 7, 'login_success', 'specific', NULL),
(12811, 7, 'text_footer_link', 'specific', NULL),
(12812, 7, 'text_footer_link_text', 'specific', NULL),
(12813, 1, 'text_lockscreen', 'specific', NULL),
(12814, 1, 'title_dashboard', 'specific', NULL),
(12815, 1, 'global_billing', 'specific', 'Global Billing'),
(12816, 7, 'global_billing', 'specific', 'Facturción Global'),
(12817, 1, 'error_password', 'specific', NULL),
(12818, 1, 'button_pos', 'specific', NULL),
(12819, 1, 'button_sell_list', 'specific', NULL),
(12820, 1, 'button_overview_report', 'specific', NULL),
(12821, 1, 'button_sell_report', 'specific', NULL),
(12822, 1, 'button_purchase_report', 'specific', NULL),
(12823, 1, 'button_stock_alert', 'specific', NULL),
(12824, 1, 'button_stores', 'specific', NULL),
(12825, 1, 'text_total_invoice', 'specific', NULL),
(12826, 1, 'text_total_invoice_today', 'specific', NULL),
(12827, 1, 'text_details', 'specific', NULL),
(12828, 1, 'text_total_customer', 'specific', NULL),
(12829, 1, 'text_total_customer_today', 'specific', NULL),
(12830, 1, 'text_total_supplier', 'specific', NULL),
(12831, 1, 'text_total_supplier_today', 'specific', NULL),
(12832, 1, 'text_total_product', 'specific', NULL),
(12833, 1, 'text_total_product_today', 'specific', NULL),
(12834, 1, 'text_recent_activities', 'specific', NULL),
(12835, 1, 'text_sales', 'specific', NULL),
(12836, 1, 'text_quotations', 'specific', NULL),
(12837, 1, 'text_purchases', 'specific', NULL),
(12838, 1, 'text_transfers', 'specific', NULL),
(12839, 1, 'text_customers', 'specific', NULL),
(12840, 1, 'text_suppliers', 'specific', NULL),
(12841, 1, 'label_invoice_id', 'specific', NULL),
(12842, 1, 'label_created_at', 'specific', NULL),
(12843, 1, 'label_customer_name', 'specific', NULL),
(12844, 1, 'label_amount', 'specific', NULL),
(12845, 1, 'label_payment_status', 'specific', NULL),
(12846, 1, 'button_add_sales', 'specific', NULL),
(12847, 1, 'button_list_sales', 'specific', NULL),
(12848, 1, 'text_sales_amount', 'specific', NULL),
(12849, 1, 'text_discount_given', 'specific', NULL),
(12850, 1, 'text_due_given', 'specific', NULL),
(12851, 1, 'text_received_amount', 'specific', NULL),
(12852, 1, 'label_date', 'specific', NULL),
(12853, 1, 'label_reference_no', 'specific', NULL),
(12854, 1, 'label_customer', 'specific', NULL),
(12855, 1, 'label_status', 'specific', NULL),
(12856, 1, 'button_add_quotations', 'specific', NULL),
(12857, 1, 'button_list_quotations', 'specific', NULL),
(12858, 1, 'label_supplier_name', 'specific', NULL),
(12859, 1, 'button_add_purchases', 'specific', NULL),
(12860, 1, 'button_list_purchases', 'specific', NULL),
(12861, 1, 'label_from', 'specific', NULL),
(12862, 1, 'label_to', 'specific', NULL),
(12863, 1, 'label_quantity', 'specific', NULL),
(12864, 1, 'button_add_transfers', 'specific', NULL),
(12865, 1, 'button_list_transfers', 'specific', NULL),
(12866, 1, 'label_phone', 'specific', NULL),
(12867, 1, 'label_email', 'specific', NULL),
(12868, 1, 'label_address', 'specific', NULL),
(12869, 1, 'button_add_customer', 'specific', NULL),
(12870, 1, 'button_list_customers', 'specific', NULL),
(12871, 1, 'button_add_supplier', 'specific', NULL),
(12872, 1, 'button_list_suppliers', 'specific', NULL),
(12873, 1, 'text_deposit_today', 'specific', NULL),
(12874, 1, 'text_withdraw_today', 'specific', NULL),
(12875, 1, 'text_recent_deposit', 'specific', NULL),
(12876, 1, 'label_description', 'specific', NULL),
(12877, 1, 'button_view_all', 'specific', NULL),
(12878, 1, 'text_recent_withdraw', 'specific', NULL),
(12879, 1, 'title_income_vs_expense', 'specific', NULL),
(12880, 1, 'text_download_as_jpg', 'specific', NULL),
(12881, 1, 'label_day', 'specific', NULL),
(12882, 1, 'text_income', 'specific', NULL),
(12883, 1, 'text_expense', 'specific', NULL),
(12884, 1, 'text_income_vs_expense', 'specific', NULL),
(12885, 1, 'text_reports', 'specific', NULL),
(12886, 1, 'error_login_attempts_exceeded', 'specific', NULL),
(12887, 1, 'text_dashboard', 'specific', NULL),
(12888, 1, 'text_due', 'specific', NULL),
(12889, 1, 'global_billing', 'specific', 'Global Billing'),
(12890, 7, 'global_billing', 'specific', 'Facturción Global'),
(12891, 1, 'label_f_invoice', 'specific', 'Invoice'),
(12892, 7, 'label_f_invoice', 'specific', 'Folio Facturación'),
(12893, 7, 'label_quotation', 'specific', 'Folio Cotización'),
(12894, 1, 'label_quotation', 'specific', 'Quotation'),
(12895, 7, 'label_sales_number', 'specific', 'Elige donde inicia tu folio'),
(12896, 1, 'label_sales_number', 'specific', 'Choose where your folio starts'),
(12897, 7, 'label_leading_zero', 'specific', 'Selecciona solo si quieres que tu folio inicie con 0 a la izquierda'),
(12898, 1, 'label_leading_zero', 'specific', 'Select only if you want your folio to start with a 0 on the left'),
(12899, 7, 'button_pos', 'specific', NULL),
(12900, 7, 'button_sell_list', 'specific', NULL),
(12901, 7, 'button_overview_report', 'specific', NULL),
(12902, 7, 'button_sell_report', 'specific', NULL),
(12903, 7, 'button_purchase_report', 'specific', NULL),
(12904, 7, 'button_stock_alert', 'specific', NULL),
(12905, 7, 'button_stores', 'specific', NULL),
(12906, 7, 'text_total_invoice', 'specific', NULL),
(12907, 7, 'text_total_invoice_today', 'specific', NULL),
(12908, 7, 'text_details', 'specific', NULL),
(12909, 7, 'text_total_customer', 'specific', NULL),
(12910, 7, 'text_total_customer_today', 'specific', NULL),
(12911, 7, 'text_total_supplier', 'specific', NULL),
(12912, 7, 'text_total_supplier_today', 'specific', NULL),
(12913, 7, 'text_total_product', 'specific', NULL),
(12914, 7, 'text_total_product_today', 'specific', NULL),
(12915, 7, 'text_recent_activities', 'specific', NULL),
(12916, 7, 'text_sales', 'specific', NULL),
(12917, 7, 'text_quotations', 'specific', NULL),
(12918, 7, 'text_purchases', 'specific', NULL),
(12919, 7, 'text_transfers', 'specific', NULL),
(12920, 7, 'text_customers', 'specific', NULL),
(12921, 7, 'text_suppliers', 'specific', NULL),
(12922, 7, 'label_invoice_id', 'specific', NULL),
(12923, 7, 'label_created_at', 'specific', NULL),
(12924, 7, 'label_customer_name', 'specific', NULL),
(12925, 7, 'label_amount', 'specific', NULL),
(12926, 7, 'label_payment_status', 'specific', NULL),
(12927, 7, 'text_due', 'specific', NULL),
(12928, 7, 'button_add_sales', 'specific', NULL),
(12929, 7, 'button_list_sales', 'specific', NULL),
(12930, 7, 'text_sales_amount', 'specific', NULL),
(12931, 7, 'text_discount_given', 'specific', NULL),
(12932, 7, 'text_due_given', 'specific', NULL),
(12933, 7, 'text_received_amount', 'specific', NULL),
(12934, 7, 'label_date', 'specific', NULL),
(12935, 7, 'label_reference_no', 'specific', NULL),
(12936, 7, 'label_customer', 'specific', NULL),
(12937, 7, 'label_status', 'specific', NULL),
(12938, 7, 'button_add_quotations', 'specific', NULL),
(12939, 7, 'button_list_quotations', 'specific', NULL),
(12940, 7, 'label_supplier_name', 'specific', NULL),
(12941, 7, 'button_add_purchases', 'specific', NULL),
(12942, 7, 'button_list_purchases', 'specific', NULL),
(12943, 7, 'label_from', 'specific', NULL),
(12944, 7, 'label_to', 'specific', NULL),
(12945, 7, 'label_quantity', 'specific', NULL),
(12946, 7, 'button_add_transfers', 'specific', NULL),
(12947, 7, 'button_list_transfers', 'specific', NULL),
(12948, 7, 'label_phone', 'specific', NULL),
(12949, 7, 'label_email', 'specific', NULL),
(12950, 7, 'label_address', 'specific', NULL),
(12951, 7, 'button_add_customer', 'specific', NULL),
(12952, 7, 'button_list_customers', 'specific', NULL),
(12953, 7, 'button_add_supplier', 'specific', NULL),
(12954, 7, 'button_list_suppliers', 'specific', NULL),
(12955, 7, 'text_deposit_today', 'specific', NULL),
(12956, 7, 'text_withdraw_today', 'specific', NULL),
(12957, 7, 'text_recent_deposit', 'specific', NULL),
(12958, 7, 'label_description', 'specific', NULL),
(12959, 7, 'button_view_all', 'specific', NULL),
(12960, 7, 'text_recent_withdraw', 'specific', NULL),
(12961, 7, 'title_income_vs_expense', 'specific', NULL),
(12962, 7, 'text_download_as_jpg', 'specific', NULL),
(12963, 7, 'label_day', 'specific', NULL),
(12964, 7, 'text_income', 'specific', NULL),
(12965, 7, 'text_expense', 'specific', NULL),
(12966, 7, 'text_income_vs_expense', 'specific', NULL),
(12967, 7, 'text_reports', 'specific', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `login_logs`
--

CREATE TABLE `login_logs` (
  `id` int(10) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED DEFAULT NULL,
  `username` varchar(100) DEFAULT NULL,
  `ip` varchar(50) DEFAULT NULL,
  `status` enum('success','error') NOT NULL DEFAULT 'success',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `login_logs`
--

INSERT INTO `login_logs` (`id`, `user_id`, `username`, `ip`, `status`, `created_at`) VALUES
(173, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-05-26 19:29:03'),
(174, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-05-26 21:44:20'),
(175, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-05-26 21:50:25'),
(176, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-05-26 21:52:10'),
(177, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-05-26 22:03:05'),
(178, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-05-26 22:03:50'),
(179, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-05-27 14:01:25'),
(180, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-05-27 14:05:27'),
(181, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-05-27 14:09:31'),
(182, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-05-27 14:18:41'),
(183, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-05-27 14:20:42'),
(184, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-05-27 14:32:14'),
(185, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-05-27 14:33:00'),
(186, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-05-27 15:24:38'),
(187, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-05-27 15:35:43'),
(188, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-05-27 15:36:52'),
(189, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-05-27 15:44:49'),
(190, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-05-27 15:55:44'),
(191, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-05-27 15:59:11'),
(192, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-05-27 16:07:27'),
(193, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-05-27 16:10:42'),
(194, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-05-27 16:19:57'),
(195, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-05-27 16:29:31'),
(196, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-05-27 17:04:05'),
(197, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-05-27 17:25:10'),
(198, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-05-27 17:41:36'),
(199, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-05-27 17:43:32'),
(200, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-05-27 23:46:51'),
(201, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-05-28 16:16:09'),
(202, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-05-28 16:21:02'),
(203, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-05-28 16:39:11'),
(204, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-05-28 16:43:42'),
(205, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-05-28 16:52:00'),
(206, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-05-28 17:05:43'),
(207, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-05-28 17:07:01'),
(208, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-05-28 17:07:35'),
(209, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-05-28 17:09:35'),
(210, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-05-28 17:11:06'),
(211, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-05-28 17:15:53'),
(212, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-05-28 17:26:27'),
(213, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-05-28 17:28:53'),
(214, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-05-28 17:31:13'),
(215, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-05-28 17:35:07'),
(216, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-05-28 17:35:50'),
(217, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-05-28 17:48:08'),
(218, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-05-28 17:55:09'),
(219, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-05-28 18:26:48'),
(220, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-05-28 18:50:58'),
(221, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-05-28 18:56:21'),
(222, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-05-28 21:23:15'),
(223, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-05-28 22:56:08'),
(224, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-05-28 23:17:47'),
(225, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-05-28 23:32:54'),
(226, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-05-29 21:10:27'),
(227, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-05-30 16:12:34'),
(228, 1, 'morgadohj@hotmail.com', '::1', 'success', '2025-05-30 16:36:05'),
(229, 1, 'morgadohj@hotmail.com', '::1', 'success', '2025-05-30 16:58:02'),
(230, 1, 'morgadohj@hotmail.com', '::1', 'success', '2025-05-30 16:59:12'),
(231, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-05-30 17:23:38'),
(232, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-05-30 17:35:45'),
(233, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-05-30 17:36:35'),
(234, 1, 'morgadohj@hotmail.com', '::1', 'success', '2025-05-30 17:37:34'),
(235, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-05-30 17:38:36'),
(236, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-05-30 17:40:16'),
(237, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-05-30 17:42:04'),
(238, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-05-30 17:49:53'),
(239, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-05-30 17:54:58'),
(240, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-05-30 17:57:41'),
(241, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-05-30 17:58:15'),
(242, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-05-30 17:58:32'),
(243, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-05-30 17:58:43'),
(244, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-05-30 18:00:15'),
(245, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-05-30 18:00:33'),
(246, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-05-30 18:00:40'),
(247, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-05-30 18:43:49'),
(248, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-05-30 18:50:26'),
(249, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-05-30 19:02:07'),
(250, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-05-30 19:13:14'),
(251, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-05-30 19:15:59'),
(252, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-05-30 19:18:07'),
(253, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-05-30 19:18:54'),
(254, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-05-30 19:19:07'),
(255, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-05-30 19:19:30'),
(256, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-05-30 19:29:48'),
(257, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-05-30 19:30:14'),
(258, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-01 07:33:15'),
(259, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-01 07:35:00'),
(261, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-01 07:36:57'),
(262, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-01 07:37:05'),
(263, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-01 07:37:35'),
(264, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-01 07:38:24'),
(265, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-01 07:42:23'),
(266, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-01 07:42:53'),
(270, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-01 07:49:46'),
(271, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-01 07:53:05'),
(272, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-01 07:58:00'),
(273, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-01 07:59:24'),
(274, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-01 08:07:45'),
(275, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-01 08:19:05'),
(276, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-01 08:19:18'),
(277, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-03 18:16:11'),
(281, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-03 18:21:30'),
(283, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-03 18:22:02'),
(284, 7, 'tin@laroli.com', '::1', 'success', '2025-06-03 18:22:30'),
(285, 1, 'morgadohj@hotmail.com', '::1', 'success', '2025-06-03 18:23:41'),
(286, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-03 18:30:46'),
(287, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-03 18:31:03'),
(288, 7, 'tin@laroli.com', '::1', 'success', '2025-06-03 18:32:32'),
(289, 7, 'tin@laroli.com', '::1', 'success', '2025-06-03 18:33:24'),
(290, 7, 'tin@laroli.com', '::1', 'success', '2025-06-03 18:33:43'),
(291, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-03 19:05:27'),
(292, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-03 19:05:59'),
(293, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-03 19:06:36'),
(294, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-03 19:06:48'),
(295, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-03 21:51:37'),
(296, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-03 21:52:54'),
(297, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-03 21:58:26'),
(298, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-03 21:59:20'),
(299, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-03 22:00:13'),
(300, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-17 00:16:22'),
(301, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-17 00:16:51'),
(302, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-17 00:16:59'),
(303, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-17 00:26:20'),
(304, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-17 00:26:40'),
(306, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-17 00:26:54'),
(307, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-17 00:27:06'),
(308, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-17 00:27:21'),
(309, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-17 00:27:30'),
(310, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-17 00:27:44'),
(311, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-17 00:28:45'),
(312, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-17 00:28:59'),
(313, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-17 00:29:08'),
(314, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-17 01:00:25'),
(315, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-17 01:00:59'),
(316, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-17 01:02:48'),
(317, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-17 01:02:54'),
(318, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-17 01:03:29'),
(319, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-17 01:04:11'),
(320, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-17 01:04:48'),
(321, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-17 01:07:04'),
(322, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-17 01:12:54'),
(323, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-17 01:17:50'),
(324, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-17 01:17:56'),
(325, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-17 01:20:25'),
(326, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-17 01:22:26'),
(327, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-17 01:22:55'),
(328, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-17 01:23:17'),
(329, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-17 01:26:04'),
(330, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-17 01:26:16'),
(331, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-17 01:26:27'),
(332, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-17 01:26:41'),
(333, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-17 01:27:21'),
(334, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-17 01:32:17'),
(335, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-17 01:32:31'),
(336, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-17 01:32:50'),
(337, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-17 01:33:21'),
(338, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-17 01:34:02'),
(339, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-17 01:34:53'),
(340, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-17 01:47:04'),
(341, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-17 01:47:10'),
(342, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-17 01:47:22'),
(343, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-17 02:36:39'),
(344, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-17 02:38:55'),
(345, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-17 02:39:13'),
(346, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-17 02:41:10'),
(347, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-17 02:41:19'),
(348, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-17 02:41:35'),
(349, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-17 02:43:28'),
(350, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-17 02:43:36'),
(351, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-17 02:44:35'),
(352, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-17 02:45:34'),
(353, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-17 02:47:41'),
(354, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-17 02:47:56'),
(355, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-17 02:48:06'),
(356, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-17 02:48:13'),
(357, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-17 02:48:28'),
(358, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-17 02:50:27'),
(359, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-17 02:51:06'),
(360, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-17 02:52:00'),
(361, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-17 02:52:28'),
(362, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-17 02:54:29'),
(363, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-17 02:54:34'),
(364, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-17 02:54:51'),
(365, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-17 03:00:05'),
(366, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-17 03:00:14'),
(367, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-17 03:00:31'),
(368, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-17 03:02:35'),
(369, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-17 03:02:54'),
(370, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-17 03:03:03'),
(371, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-17 03:04:20'),
(372, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-17 03:04:31'),
(373, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-17 03:04:39'),
(374, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-17 03:04:51'),
(375, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-17 03:06:22'),
(376, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-17 03:09:10'),
(377, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-17 03:18:02'),
(378, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-17 03:20:45'),
(379, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-17 03:21:35'),
(380, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-17 03:22:08'),
(381, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-17 03:23:55'),
(382, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-17 03:24:16'),
(383, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-17 03:29:37'),
(384, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-17 03:30:18'),
(385, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-17 03:32:35'),
(386, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-17 03:32:50'),
(387, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-17 03:33:23'),
(388, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-17 03:33:46'),
(389, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-17 03:35:29'),
(390, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-17 03:36:02'),
(391, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-17 03:36:24'),
(392, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-17 03:37:40'),
(393, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-17 03:38:07'),
(394, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-17 03:38:25'),
(395, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-17 03:44:10'),
(396, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-17 03:44:26'),
(397, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-17 03:50:29'),
(398, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-17 03:50:47'),
(399, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-17 03:51:00'),
(400, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-17 03:52:54'),
(401, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-17 03:52:59'),
(402, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-17 03:53:34'),
(403, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-17 03:53:39'),
(404, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-17 03:54:37'),
(405, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-17 03:54:45'),
(406, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-17 03:54:58'),
(407, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-17 04:00:58'),
(408, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-17 04:02:26'),
(409, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-17 04:03:13'),
(410, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-17 04:03:38'),
(411, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-17 04:04:32'),
(412, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-17 04:05:33'),
(413, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-17 04:05:39'),
(414, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-17 04:06:17'),
(415, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-17 04:06:22'),
(416, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-17 04:06:58'),
(417, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-17 04:08:43'),
(418, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-17 04:19:24'),
(419, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-17 04:31:07'),
(420, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-17 04:31:21'),
(421, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-17 04:32:10'),
(422, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-17 04:32:40'),
(423, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-17 04:32:48'),
(424, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-17 04:33:47'),
(425, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-17 04:34:35'),
(426, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-17 22:44:10'),
(427, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-17 22:45:46'),
(428, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-17 22:47:23'),
(429, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-17 22:47:31'),
(430, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-17 22:48:33'),
(431, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-17 22:49:03'),
(432, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-17 22:49:39'),
(433, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-17 22:50:42'),
(434, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-17 22:55:03'),
(435, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-17 22:58:53'),
(436, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-17 23:00:14'),
(437, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-17 23:03:54'),
(438, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-17 23:04:21'),
(439, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-17 23:06:39'),
(440, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-17 23:07:12'),
(441, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-17 23:07:48'),
(442, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-17 23:08:16'),
(443, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-17 23:08:59'),
(444, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-17 23:09:11'),
(445, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-17 23:09:36'),
(446, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-17 23:10:47'),
(447, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-17 23:11:03'),
(448, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-17 23:13:56'),
(449, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-17 23:14:31'),
(450, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-17 23:15:48'),
(451, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-17 23:17:16'),
(452, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-17 23:17:24'),
(453, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-17 23:24:09'),
(454, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-17 23:26:36'),
(455, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-17 23:26:56'),
(456, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-17 23:27:05'),
(457, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-17 23:27:14'),
(458, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-17 23:27:57'),
(459, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-17 23:28:07'),
(460, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-17 23:28:53'),
(461, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-17 23:29:18'),
(462, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-17 23:29:46'),
(463, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-17 23:30:53'),
(464, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-17 23:31:22'),
(465, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-17 23:33:23'),
(466, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-17 23:33:56'),
(467, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-18 18:06:44'),
(468, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-18 18:07:37'),
(469, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-18 18:08:40'),
(470, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-18 18:11:04'),
(471, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-18 18:11:37'),
(472, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-18 18:13:23'),
(473, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-18 18:13:57'),
(474, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-18 18:15:05'),
(475, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-18 18:18:51'),
(476, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-18 18:19:00'),
(477, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-18 18:19:51'),
(478, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-18 18:20:00'),
(479, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-18 18:20:51'),
(480, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-18 18:21:02'),
(481, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-18 18:21:13'),
(482, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-18 18:21:20'),
(483, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-18 18:24:15'),
(484, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-18 18:24:23'),
(485, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-18 18:26:06'),
(486, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-18 18:26:16'),
(487, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-18 18:32:16'),
(488, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-18 18:32:50'),
(489, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-18 18:35:48'),
(490, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-19 05:01:53'),
(491, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-19 13:55:07'),
(492, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-19 13:58:12'),
(493, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-19 13:59:24'),
(494, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-19 14:00:56'),
(495, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-19 14:01:49'),
(496, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-19 14:17:37'),
(497, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-19 14:17:45'),
(498, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-19 14:17:57'),
(499, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-19 14:18:05'),
(500, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-19 14:20:49'),
(501, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-19 14:20:58'),
(502, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-19 14:21:15'),
(503, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-19 14:22:30'),
(504, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-19 14:22:58'),
(505, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-19 14:23:11'),
(506, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-19 14:23:20'),
(507, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-19 14:24:56'),
(508, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-19 14:25:02'),
(509, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-19 14:29:01'),
(510, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-19 14:29:07'),
(511, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-19 14:32:41'),
(512, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-19 14:33:03'),
(513, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-19 14:33:21'),
(514, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-19 14:45:38'),
(515, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-19 14:45:53'),
(516, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-19 14:46:07'),
(517, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-19 14:46:58'),
(518, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-19 14:47:21'),
(519, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-19 14:47:58'),
(520, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-19 14:48:06'),
(521, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-19 16:15:34'),
(522, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-19 16:16:34'),
(523, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-19 16:31:28'),
(524, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-19 16:31:49'),
(525, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-19 16:32:45'),
(526, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-19 16:35:06'),
(527, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-19 16:36:37'),
(528, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-19 16:37:06'),
(529, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-19 16:46:03'),
(530, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-19 16:57:47'),
(531, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-19 16:57:58'),
(532, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-19 17:00:07'),
(533, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-19 17:02:00'),
(534, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-19 17:03:19'),
(535, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-19 17:08:02'),
(536, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-19 17:12:46'),
(537, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-19 17:12:59'),
(538, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-19 17:14:52'),
(539, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-19 17:15:05'),
(540, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-19 17:15:41'),
(541, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-19 17:30:09'),
(542, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-19 17:30:35'),
(543, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-19 17:36:58'),
(544, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-19 17:37:03'),
(545, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-19 17:38:05'),
(546, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-19 17:38:36'),
(547, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-19 17:39:51'),
(548, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-19 17:40:00'),
(549, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-19 17:40:12'),
(550, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-19 17:40:36'),
(551, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-19 17:41:50'),
(552, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-19 17:42:14'),
(553, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-19 17:42:21'),
(554, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-19 17:42:25'),
(555, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-19 17:42:47'),
(556, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-19 17:42:52'),
(557, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-19 17:43:47'),
(558, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-19 17:43:53'),
(559, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-19 17:46:48'),
(560, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-19 17:50:32'),
(561, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-19 17:50:54'),
(562, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-19 17:53:47'),
(563, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-19 17:54:11'),
(564, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-19 17:55:45'),
(565, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-19 18:01:02'),
(566, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-19 18:01:24'),
(567, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-19 18:02:27'),
(568, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-19 18:03:17'),
(569, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-19 18:03:23'),
(570, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-19 18:03:48'),
(571, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-19 18:03:54'),
(572, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-19 18:04:08'),
(573, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-19 21:42:32'),
(574, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-19 21:42:39'),
(575, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-19 21:42:59'),
(576, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-19 21:43:32'),
(577, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-19 21:43:41'),
(578, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-19 21:43:47'),
(579, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-19 21:43:54'),
(580, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-19 21:44:07'),
(581, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-19 21:53:05'),
(582, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-19 21:53:40'),
(583, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-19 22:19:22'),
(584, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-19 22:21:17'),
(585, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-19 22:21:25'),
(586, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-19 22:21:56'),
(587, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-19 22:22:12'),
(588, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-19 22:24:14'),
(589, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-19 22:24:23'),
(590, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-19 22:32:57'),
(591, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-19 22:33:50'),
(592, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-19 22:36:16'),
(593, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-19 22:37:45'),
(594, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-19 22:37:58'),
(595, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-19 22:38:09'),
(596, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-19 22:38:30'),
(597, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-19 22:39:54'),
(598, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-19 22:42:53'),
(599, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-19 22:43:06'),
(600, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-19 22:43:12'),
(601, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-19 22:46:24'),
(602, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-19 22:46:49'),
(603, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-19 22:46:56'),
(604, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-19 22:49:48'),
(605, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-19 22:49:53'),
(606, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-19 22:50:01'),
(607, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-19 22:50:08'),
(608, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-19 22:50:33'),
(609, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-19 22:51:51'),
(610, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-19 22:51:59'),
(611, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-19 22:52:09'),
(612, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-19 22:53:35'),
(613, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-19 22:55:13'),
(614, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-19 22:56:20'),
(615, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-20 16:41:36'),
(616, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-20 16:43:19'),
(617, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-20 16:46:25'),
(618, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-20 16:47:19'),
(619, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-20 16:51:21'),
(620, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-20 16:51:32'),
(621, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-20 16:51:43'),
(622, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-20 16:51:50'),
(623, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-20 18:24:04'),
(624, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-20 18:25:16'),
(625, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-20 18:30:15'),
(626, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-20 18:31:45'),
(627, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-21 05:08:13'),
(628, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-21 05:08:30'),
(629, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-21 05:08:38'),
(630, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-21 05:08:57'),
(631, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-21 05:09:14'),
(632, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-21 05:09:20'),
(633, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-21 05:11:06'),
(634, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-21 05:11:16'),
(635, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-21 05:17:20'),
(636, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-21 05:17:34'),
(637, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-21 05:20:15'),
(638, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-21 05:20:35'),
(639, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-21 05:31:38'),
(640, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-21 05:31:44'),
(641, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-21 05:31:56'),
(642, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-21 05:34:49'),
(643, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-21 05:34:54'),
(644, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-21 05:41:21'),
(645, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-21 05:41:32'),
(646, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-21 06:05:43'),
(647, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-21 06:05:50'),
(648, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-21 06:06:25'),
(649, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-21 06:06:33'),
(650, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-21 06:19:18'),
(651, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-21 06:19:26'),
(652, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-21 06:19:34'),
(653, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-21 06:19:51'),
(654, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-21 06:20:01'),
(655, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-21 06:35:19'),
(656, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-21 06:35:25'),
(657, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-21 06:35:39'),
(658, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-21 06:36:12'),
(659, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-21 06:36:17'),
(660, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-21 06:36:37'),
(661, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-21 06:36:44'),
(662, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-21 06:36:50'),
(663, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-21 06:37:10'),
(664, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-21 06:37:19'),
(665, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-21 06:37:24'),
(666, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-21 06:37:38'),
(667, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-21 06:53:53'),
(668, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-21 06:54:01'),
(669, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-21 06:55:54'),
(670, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-21 06:56:07'),
(671, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-21 06:56:18'),
(672, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-21 06:56:23'),
(673, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-21 07:08:06'),
(674, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-21 07:08:15'),
(675, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-21 07:08:26'),
(676, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-21 07:08:37'),
(677, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-21 07:19:28'),
(678, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-21 07:19:41'),
(679, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-21 07:20:02'),
(680, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-21 07:20:15'),
(681, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-21 07:20:18'),
(682, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-21 07:30:38'),
(683, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-21 07:30:41'),
(684, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-21 07:31:07'),
(685, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-21 07:31:24'),
(686, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-21 07:33:09'),
(687, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-21 07:36:24'),
(688, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-21 07:36:33'),
(689, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-21 07:37:05'),
(690, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-21 07:41:25'),
(691, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-21 07:41:52'),
(692, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-21 07:42:00'),
(693, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-21 07:42:08'),
(694, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-21 07:42:16'),
(695, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-21 07:45:15'),
(696, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-21 07:45:31'),
(697, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-21 07:47:55'),
(698, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-21 07:48:24'),
(699, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-21 07:52:04'),
(700, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-21 07:52:26'),
(701, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-21 07:52:59'),
(702, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-21 07:53:17'),
(703, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-21 07:53:37'),
(704, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-21 07:53:55'),
(705, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-21 07:54:08'),
(706, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-21 07:54:17'),
(707, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-21 07:54:22'),
(708, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-21 07:55:49'),
(709, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-21 07:55:53'),
(710, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-21 07:56:18'),
(711, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-21 07:56:26'),
(712, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-21 07:56:35'),
(713, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-21 07:56:41'),
(714, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-21 08:02:55'),
(715, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-21 08:03:55'),
(716, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-21 08:04:06'),
(717, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-21 08:04:45'),
(718, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-21 08:05:33'),
(719, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-21 08:05:53'),
(720, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-21 08:06:02'),
(721, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-21 08:07:16'),
(722, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-21 08:07:21'),
(723, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-21 08:10:03'),
(724, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-21 08:10:12'),
(725, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-21 08:10:17'),
(726, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-21 08:13:33'),
(727, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-21 08:13:54'),
(728, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-21 08:14:06'),
(729, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-21 08:14:11'),
(730, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-21 08:14:21'),
(731, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-21 08:17:05'),
(732, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-21 08:17:33'),
(733, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-21 08:17:44'),
(734, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-21 08:17:49'),
(735, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-21 08:18:25'),
(736, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-21 08:21:14'),
(737, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-21 08:21:22'),
(738, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-21 08:21:27'),
(739, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-21 08:21:34'),
(740, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-21 08:21:47'),
(741, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-21 08:22:06'),
(742, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-21 08:22:31'),
(743, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-21 08:22:40'),
(744, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-21 08:22:56'),
(745, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-21 08:24:39'),
(746, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-21 08:25:28'),
(747, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-21 08:25:39'),
(748, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-21 08:28:19'),
(749, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-21 08:28:23'),
(750, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-24 05:28:34'),
(751, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-24 05:28:40'),
(752, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-24 05:43:31'),
(753, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-24 05:56:42'),
(754, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-24 06:11:00'),
(755, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-24 06:35:42'),
(756, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-24 06:43:16'),
(757, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-24 06:44:50'),
(758, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-24 06:50:52'),
(759, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-24 06:57:16'),
(760, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-24 06:57:22'),
(761, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-24 06:57:32'),
(762, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-24 07:00:46'),
(763, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-24 07:00:54'),
(764, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-24 07:01:04'),
(765, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-24 07:01:09'),
(766, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-24 07:06:00'),
(767, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-24 07:06:07'),
(768, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-24 07:13:13'),
(769, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-24 07:13:18'),
(770, 1, 'morgadohj@hotmail.com', '::1', 'success', '2025-06-24 07:26:40'),
(771, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-24 07:27:26'),
(772, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-24 07:27:32'),
(773, 1, 'morgadohj@hotmail.com', '::1', 'success', '2025-06-24 07:28:07'),
(774, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-24 07:29:03'),
(775, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-24 07:29:17'),
(776, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-24 07:29:27'),
(777, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-24 07:29:39'),
(778, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-24 07:30:03'),
(779, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-24 07:31:00'),
(780, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-24 07:31:11'),
(781, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-24 07:31:22'),
(782, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-24 07:31:27'),
(783, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-24 07:32:46'),
(784, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-24 07:33:09'),
(785, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-24 07:33:12'),
(786, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-24 07:37:04'),
(787, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-24 07:37:11'),
(788, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-24 07:37:43'),
(789, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-24 07:38:01'),
(790, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-24 07:38:37'),
(791, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-24 07:39:50'),
(792, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-24 07:41:21'),
(793, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-24 07:42:50'),
(794, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-24 07:57:29'),
(795, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-24 07:57:56'),
(796, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-24 08:01:22'),
(797, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-24 08:01:28'),
(798, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-24 08:01:43'),
(799, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-24 08:02:16'),
(800, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-24 08:02:43'),
(801, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-24 08:03:09'),
(802, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-24 08:03:22'),
(803, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-24 08:03:43'),
(804, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-24 08:04:10'),
(805, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-24 08:08:10'),
(806, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-24 08:08:17'),
(807, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-24 08:08:36'),
(808, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-24 08:14:12'),
(809, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-24 08:14:31'),
(810, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-24 08:14:43'),
(811, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-24 08:19:41'),
(812, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-24 08:19:50'),
(813, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-24 08:19:59'),
(814, 1, 'morgadohj@hotmail.com', '::1', 'success', '2025-06-24 08:22:22'),
(815, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-24 08:22:33'),
(816, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-24 08:22:38'),
(817, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-24 08:22:58'),
(818, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-24 08:26:53'),
(819, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-24 08:33:46'),
(820, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-24 08:34:16'),
(821, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-24 08:34:40'),
(822, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-24 08:37:07'),
(823, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-24 08:38:08'),
(824, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-24 08:48:43'),
(825, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-24 08:49:53'),
(826, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-24 08:51:36'),
(827, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-24 08:52:43'),
(828, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-24 08:53:21'),
(829, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-24 08:54:43'),
(830, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-24 08:55:11');
INSERT INTO `login_logs` (`id`, `user_id`, `username`, `ip`, `status`, `created_at`) VALUES
(831, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-24 08:55:28'),
(832, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-24 08:55:46'),
(833, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-24 08:55:56'),
(834, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-24 08:57:14'),
(835, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-24 08:59:23'),
(836, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-24 08:59:43'),
(837, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-24 09:00:25'),
(838, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-24 09:02:58'),
(839, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-24 09:03:53'),
(840, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-24 09:04:58'),
(841, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-24 09:05:38'),
(842, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-24 09:07:08'),
(843, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-24 09:08:52'),
(844, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-24 09:10:05'),
(845, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-24 09:15:31'),
(846, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-24 09:15:38'),
(847, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-24 09:17:13'),
(848, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-24 09:19:09'),
(849, 7, 'tin@laroli.com', '::1', 'success', '2025-06-24 09:20:42'),
(850, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-24 09:21:17'),
(851, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-24 09:22:10'),
(852, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-24 09:22:15'),
(853, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-24 09:23:21'),
(854, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-24 09:23:49'),
(855, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-24 09:24:06'),
(856, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-24 09:24:27'),
(857, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-24 09:25:07'),
(858, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-24 09:25:23'),
(859, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-24 09:25:35'),
(860, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-24 09:25:40'),
(861, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-24 09:25:48'),
(862, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-24 09:26:13'),
(863, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-24 09:26:24'),
(864, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-24 09:26:40'),
(865, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-24 09:26:52'),
(866, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-24 09:27:04'),
(867, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-24 09:27:39'),
(868, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-24 09:27:44'),
(869, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-24 09:28:05'),
(870, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-24 09:28:37'),
(871, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-24 09:28:51'),
(872, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-24 09:29:23'),
(873, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-24 09:29:43'),
(874, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-24 09:31:59'),
(875, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-24 09:32:07'),
(876, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-24 09:32:58'),
(877, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-24 09:33:52'),
(878, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-24 09:34:46'),
(879, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-24 09:36:20'),
(880, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-24 09:38:24'),
(881, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-24 09:38:28'),
(882, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-24 09:38:32'),
(883, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-24 09:38:50'),
(884, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-24 09:38:58'),
(885, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-24 09:39:08'),
(886, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-24 09:39:37'),
(887, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-24 09:39:57'),
(888, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-24 09:40:08'),
(889, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-24 09:40:16'),
(890, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-24 09:40:32'),
(891, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-24 09:40:54'),
(892, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-24 09:41:02'),
(893, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-24 09:42:44'),
(894, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-24 09:42:49'),
(895, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-24 09:43:03'),
(896, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-24 09:43:17'),
(897, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-24 09:43:21'),
(898, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-24 09:43:25'),
(899, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-24 09:43:51'),
(900, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-24 09:43:59'),
(901, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-24 09:44:38'),
(902, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-24 09:46:06'),
(903, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-24 09:46:14'),
(904, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-24 09:46:20'),
(905, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-24 09:46:24'),
(906, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-24 09:49:18'),
(907, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-24 09:49:27'),
(908, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-24 09:49:42'),
(909, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-24 09:49:55'),
(910, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-24 09:50:02'),
(911, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-24 09:51:57'),
(912, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-24 18:02:11'),
(913, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-24 21:52:03'),
(914, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-24 21:53:36'),
(915, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-24 21:54:06'),
(916, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-24 21:55:37'),
(917, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-26 21:48:46'),
(918, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-26 21:48:52'),
(919, 7, 'tin@laroli.com', '::1', 'success', '2025-06-26 22:33:26'),
(920, 1, 'morgadohj@hotmail.com', '::1', 'success', '2025-06-26 22:33:35'),
(921, 1, 'morgadohj@hotmail.com', '::1', 'success', '2025-06-26 22:47:44'),
(922, 1, 'morgadohj@hotmail.com', '::1', 'success', '2025-06-26 23:14:50'),
(923, 7, 'tin@laroli.com', '::1', 'success', '2025-06-26 23:14:56'),
(924, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-27 18:04:43'),
(925, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-27 18:16:57'),
(926, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-27 18:17:37'),
(927, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-27 18:56:28'),
(928, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-27 18:58:44'),
(929, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-27 19:02:04'),
(930, 8, 'mar@mar.com', '127.0.0.1', 'success', '2025-06-27 19:04:13'),
(931, 8, 'mar@mar.com', '127.0.0.1', 'success', '2025-06-27 19:04:33'),
(932, 8, 'mar@mar.com', '127.0.0.1', 'success', '2025-06-27 19:06:06'),
(933, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-27 19:06:14'),
(934, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-27 19:15:08'),
(935, 8, 'mar@mar.com', '127.0.0.1', 'success', '2025-06-27 19:18:43'),
(936, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-27 19:19:04'),
(937, 8, 'mar@mar.com', '127.0.0.1', 'success', '2025-06-27 19:19:52'),
(938, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-27 20:01:38'),
(939, 8, 'mar@mar.com', '127.0.0.1', 'success', '2025-06-27 20:02:04'),
(940, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-27 20:02:16'),
(941, 8, 'mar@mar.com', '127.0.0.1', 'success', '2025-06-27 20:02:38'),
(942, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-27 20:02:50'),
(943, 8, 'mar@mar.com', '127.0.0.1', 'success', '2025-06-27 20:03:17'),
(944, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-27 20:03:25'),
(945, 8, 'mar@mar.com', '127.0.0.1', 'success', '2025-06-27 20:04:07'),
(946, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-27 20:05:19'),
(947, 8, 'mar@mar.com', '127.0.0.1', 'success', '2025-06-27 20:05:38'),
(948, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-27 20:05:45'),
(949, 8, 'mar@mar.com', '127.0.0.1', 'success', '2025-06-27 20:06:02'),
(950, 8, 'mar@mar.com', '127.0.0.1', 'success', '2025-06-27 21:13:41'),
(951, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-27 21:14:50'),
(952, 8, 'mar@mar.com', '127.0.0.1', 'success', '2025-06-27 21:15:24'),
(953, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-27 21:16:28'),
(954, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-27 21:17:16'),
(955, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-27 21:18:08'),
(956, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-27 21:18:26'),
(957, 8, 'mar@mar.com', '127.0.0.1', 'success', '2025-06-27 21:36:35'),
(958, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-27 21:54:18'),
(959, 8, 'mar@mar.com', '127.0.0.1', 'success', '2025-06-27 21:54:28'),
(960, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-27 21:54:39'),
(961, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-27 21:55:00'),
(962, 8, 'mar@mar.com', '127.0.0.1', 'success', '2025-06-27 21:55:22'),
(963, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-27 22:03:26'),
(964, 8, 'mar@mar.com', '127.0.0.1', 'success', '2025-06-27 22:04:33'),
(965, 9, 'fer@fer.com', '127.0.0.1', 'success', '2025-06-27 22:05:07'),
(966, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-27 22:05:57'),
(967, 9, 'fer@fer.com', '127.0.0.1', 'success', '2025-06-27 22:06:18'),
(968, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-27 22:06:27'),
(969, 9, 'fer@fer.com', '127.0.0.1', 'success', '2025-06-27 22:13:14'),
(970, 9, 'fer@fer.com', '127.0.0.1', 'success', '2025-06-27 22:13:32'),
(971, 8, 'mar@mar.com', '127.0.0.1', 'success', '2025-06-30 16:27:05'),
(972, 8, 'mar@mar.com', '127.0.0.1', 'success', '2025-06-30 16:27:25'),
(973, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-30 16:27:32'),
(974, 9, 'fer@fer.com', '127.0.0.1', 'success', '2025-06-30 16:27:39'),
(975, 9, 'fer@fer.com', '127.0.0.1', 'success', '2025-06-30 16:39:34'),
(976, 9, 'fer@fer.com', '127.0.0.1', 'success', '2025-06-30 16:39:55'),
(977, 8, 'mar@mar.com', '127.0.0.1', 'success', '2025-06-30 16:40:10'),
(978, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-30 16:40:17'),
(979, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-30 16:40:23'),
(980, 9, 'fer@fer.com', '127.0.0.1', 'success', '2025-06-30 16:40:32'),
(981, 9, 'fer@fer.com', '127.0.0.1', 'success', '2025-06-30 16:40:59'),
(982, 9, 'fer@fer.com', '127.0.0.1', 'success', '2025-06-30 16:45:17'),
(983, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-30 16:45:27'),
(984, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-30 16:45:35'),
(985, 8, 'mar@mar.com', '127.0.0.1', 'success', '2025-06-30 16:45:56'),
(986, 9, 'fer@fer.com', '127.0.0.1', 'success', '2025-06-30 16:46:10'),
(987, 9, 'fer@fer.com', '127.0.0.1', 'success', '2025-06-30 16:46:42'),
(988, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-30 16:47:22'),
(989, 9, 'fer@fer.com', '127.0.0.1', 'success', '2025-06-30 16:47:54'),
(990, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-30 16:48:43'),
(991, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-30 16:59:50'),
(992, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-30 17:04:15'),
(993, 9, 'fer@fer.com', '127.0.0.1', 'success', '2025-06-30 17:04:22'),
(994, 8, 'mar@mar.com', '127.0.0.1', 'success', '2025-06-30 17:04:30'),
(995, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-30 17:04:54'),
(996, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-30 17:05:29'),
(997, 9, 'fer@fer.com', '127.0.0.1', 'success', '2025-06-30 17:07:35'),
(998, 8, 'mar@mar.com', '127.0.0.1', 'success', '2025-06-30 17:07:40'),
(999, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-30 17:07:45'),
(1000, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-30 17:07:50'),
(1001, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-06-30 17:37:52'),
(1002, 9, 'fer@fer.com', '127.0.0.1', 'success', '2025-06-30 17:37:57'),
(1003, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-06-30 17:38:04'),
(1008, 10, 'admin@esqueleto.com', '127.0.0.1', 'success', '2025-07-03 16:42:21'),
(1009, 10, 'admin@esqueleto.com', '127.0.0.1', 'success', '2025-07-03 16:42:39'),
(1010, 10, 'admin@esqueleto.com', '127.0.0.1', 'success', '2025-07-03 16:47:58'),
(1011, 10, 'admin@esqueleto.com', '127.0.0.1', 'success', '2025-07-03 17:02:38'),
(1012, 9, 'fer@fer.com', '127.0.0.1', 'success', '2025-07-03 17:03:51'),
(1013, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-07-03 17:04:07'),
(1014, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-07-03 17:04:13'),
(1016, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-07-03 18:30:47'),
(1022, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-07-03 18:34:25'),
(1025, 13, 'juan@juan.com', '127.0.0.1', 'success', '2025-07-04 17:53:50'),
(1026, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-07-04 18:19:36'),
(1029, 14, 'juan@juan.com', '127.0.0.1', 'success', '2025-07-04 18:20:28'),
(1030, 1, 'morgadohj@hotmail.com', '::1', 'success', '2025-07-04 18:22:59'),
(1031, 1, 'morgadohj@hotmail.com', '::1', 'success', '2025-07-04 18:23:32'),
(1033, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-07-04 18:29:25'),
(1034, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-07-04 18:33:22'),
(1036, 14, 'juan@juan.com', '127.0.0.1', 'success', '2025-07-04 22:11:04'),
(1037, 14, 'juan@juan.com', '127.0.0.1', 'success', '2025-07-04 22:13:18'),
(1038, 14, 'juan@juan.com', '::1', 'success', '2025-07-04 22:16:51'),
(1041, 14, 'juan@juan.com', '::1', 'success', '2025-07-04 22:20:44'),
(1042, 14, 'juan@juan.com', '::1', 'success', '2025-07-04 22:21:31'),
(1044, 14, 'juan@juan.com', '::1', 'success', '2025-07-04 22:24:34'),
(1045, 14, 'juan@juan.com', '::1', 'success', '2025-07-04 22:25:50'),
(1046, 1, 'morgadohj@hotmail.com', '::1', 'success', '2025-07-04 22:26:15'),
(1048, 14, 'juan@juan.com', '::1', 'success', '2025-07-04 22:26:44'),
(1049, 14, 'juan@juan.com', '::1', 'success', '2025-07-04 22:27:53'),
(1050, 14, 'juan@juan.com', '::1', 'success', '2025-07-04 22:29:59'),
(1052, 1, 'morgadohj@hotmail.com', '::1', 'success', '2025-07-04 22:32:36'),
(1053, 14, 'juan@juan.com', '::1', 'success', '2025-07-04 22:32:51'),
(1054, 14, 'juan@juan.com', '::1', 'success', '2025-07-04 22:35:31'),
(1057, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-07-04 23:44:24'),
(1061, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-07-04 23:45:13'),
(1062, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-07-04 23:46:23'),
(1063, 9, 'fer@fer.com', '127.0.0.1', 'success', '2025-07-06 04:59:53'),
(1064, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-07-06 05:01:37'),
(1065, 16, 'juan@juan.com', '127.0.0.1', 'success', '2025-07-06 05:01:49'),
(1066, 16, 'juan@juan.com', '127.0.0.1', 'success', '2025-07-06 05:02:08'),
(1068, 16, 'juan@juan.com', '127.0.0.1', 'success', '2025-07-06 05:06:28'),
(1070, 16, 'juan@juan.com', '127.0.0.1', 'success', '2025-07-06 05:17:25'),
(1072, 16, 'juan@juan.com', '127.0.0.1', 'success', '2025-07-06 05:19:56'),
(1073, 16, 'juan@juan.com', '127.0.0.1', 'success', '2025-07-06 05:20:19'),
(1074, 16, 'juan@juan.com', '127.0.0.1', 'success', '2025-07-06 05:22:47'),
(1075, 16, 'juan@juan.com', '127.0.0.1', 'success', '2025-07-06 05:24:59'),
(1077, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-07-06 05:25:35'),
(1078, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-07-06 05:25:52'),
(1079, 16, 'juan@juan.com', '127.0.0.1', 'success', '2025-07-06 05:27:09'),
(1080, 16, 'juan@juan.com', '127.0.0.1', 'success', '2025-07-06 05:30:02'),
(1081, 16, 'juan@juan.com', '127.0.0.1', 'success', '2025-07-06 05:30:26'),
(1082, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-07-06 05:30:41'),
(1083, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-07-06 05:30:50'),
(1084, 9, 'fer@fer.com', '127.0.0.1', 'success', '2025-07-06 05:30:57'),
(1085, 8, 'mar@mar.com', '127.0.0.1', 'success', '2025-07-06 05:31:01'),
(1086, 16, 'juan@juan.com', '127.0.0.1', 'success', '2025-07-06 05:31:28'),
(1087, 16, 'juan@juan.com', '127.0.0.1', 'success', '2025-07-06 05:32:05'),
(1088, 16, 'juan@juan.com', '127.0.0.1', 'success', '2025-07-06 05:33:46'),
(1089, 16, 'juan@juan.com', '127.0.0.1', 'success', '2025-07-06 05:34:26'),
(1091, 16, 'juan@juan.com', '127.0.0.1', 'success', '2025-07-06 05:35:17'),
(1093, 9, 'fer@fer.com', '127.0.0.1', 'success', '2025-07-06 05:37:41'),
(1094, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-07-06 05:37:46'),
(1095, 8, 'mar@mar.com', '127.0.0.1', 'success', '2025-07-06 05:37:50'),
(1096, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-07-06 05:37:56'),
(1097, 16, 'juan@juan.com', '127.0.0.1', 'success', '2025-07-06 05:38:07'),
(1098, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-07-06 05:38:41'),
(1099, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-07-06 05:38:46'),
(1100, 16, 'juan@juan.com', '127.0.0.1', 'success', '2025-07-06 05:38:56'),
(1102, 16, 'juan@juan.com', '127.0.0.1', 'success', '2025-07-06 05:40:14'),
(1103, 16, 'juan@juan.com', '127.0.0.1', 'success', '2025-07-06 05:42:05'),
(1104, 16, 'juan@juan.com', '127.0.0.1', 'success', '2025-07-06 05:43:36'),
(1105, 16, 'juan@juan.com', '127.0.0.1', 'success', '2025-07-06 05:44:42'),
(1106, 16, 'juan@juan.com', '127.0.0.1', 'success', '2025-07-06 05:45:38'),
(1107, 16, 'juan@juan.com', '127.0.0.1', 'success', '2025-07-06 05:47:21'),
(1109, 9, 'fer@fer.com', '127.0.0.1', 'success', '2025-07-06 05:49:08'),
(1110, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-07-06 05:49:13'),
(1111, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-07-06 05:49:18'),
(1112, 16, 'juan@juan.com', '127.0.0.1', 'success', '2025-07-06 05:49:25'),
(1113, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-07-06 05:52:48'),
(1114, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-07-06 05:52:54'),
(1115, 9, 'fer@fer.com', '127.0.0.1', 'success', '2025-07-06 05:53:05'),
(1116, 16, 'juan@juan.com', '127.0.0.1', 'success', '2025-07-06 05:53:14'),
(1117, 16, 'juan@juan.com', '127.0.0.1', 'success', '2025-07-06 05:58:36'),
(1118, 16, 'juan@juan.com', '127.0.0.1', 'success', '2025-07-06 06:00:24'),
(1119, 16, 'juan@juan.com', '127.0.0.1', 'success', '2025-07-06 06:01:27'),
(1120, 16, 'juan@juan.com', '127.0.0.1', 'success', '2025-07-06 06:05:30'),
(1121, 16, 'juan@juan.com', '127.0.0.1', 'success', '2025-07-06 06:06:37'),
(1122, 16, 'juan@juan.com', '127.0.0.1', 'success', '2025-07-06 06:06:51'),
(1123, 16, 'juan@juan.com', '127.0.0.1', 'success', '2025-07-06 06:10:53'),
(1124, 16, 'juan@juan.com', '127.0.0.1', 'success', '2025-07-06 06:12:02'),
(1125, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-07-06 06:12:15'),
(1126, 16, 'juan@juan.com', '127.0.0.1', 'success', '2025-07-06 06:12:20'),
(1127, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-07-06 06:12:26'),
(1128, 16, 'juan@juan.com', '127.0.0.1', 'success', '2025-07-06 06:13:35'),
(1129, 16, 'juan@juan.com', '127.0.0.1', 'success', '2025-07-06 06:14:09'),
(1130, 16, 'juan@juan.com', '127.0.0.1', 'success', '2025-07-06 06:14:33'),
(1131, 16, 'juan@juan.com', '127.0.0.1', 'success', '2025-07-06 06:16:27'),
(1132, 16, 'juan@juan.com', '127.0.0.1', 'success', '2025-07-06 06:18:47'),
(1133, 16, 'juan@juan.com', '127.0.0.1', 'success', '2025-07-06 06:29:07'),
(1134, 16, 'juan@juan.com', '127.0.0.1', 'success', '2025-07-06 06:30:10'),
(1135, 16, 'juan@juan.com', '127.0.0.1', 'success', '2025-07-06 06:30:56'),
(1136, 16, 'juan@juan.com', '127.0.0.1', 'success', '2025-07-06 06:31:34'),
(1137, 16, 'juan@juan.com', '127.0.0.1', 'success', '2025-07-06 06:31:46'),
(1138, 16, 'juan@juan.com', '127.0.0.1', 'success', '2025-07-06 06:41:41'),
(1139, 16, 'juan@juan.com', '127.0.0.1', 'success', '2025-07-06 06:41:55'),
(1140, 16, 'juan@juan.com', '127.0.0.1', 'success', '2025-07-06 06:45:52'),
(1141, 16, 'juan@juan.com', '127.0.0.1', 'success', '2025-07-06 06:47:10'),
(1142, 17, 'prueba@prueba.com', '127.0.0.1', 'success', '2025-07-06 06:50:37'),
(1143, 17, 'prueba@prueba.com', '127.0.0.1', 'success', '2025-07-06 06:50:46'),
(1144, 17, 'prueba@prueba.com', '127.0.0.1', 'success', '2025-07-06 06:52:04'),
(1145, 16, 'juan@juan.com', '127.0.0.1', 'success', '2025-07-06 06:54:18'),
(1146, 16, 'juan@juan.com', '127.0.0.1', 'success', '2025-07-06 06:54:39'),
(1147, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-07-06 06:56:20'),
(1148, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-07-06 06:56:26'),
(1149, 16, 'juan@juan.com', '127.0.0.1', 'success', '2025-07-07 03:23:08'),
(1150, 16, 'juan@juan.com', '127.0.0.1', 'success', '2025-07-07 03:23:24'),
(1151, 16, 'juan@juan.com', '127.0.0.1', 'success', '2025-07-07 03:35:34'),
(1152, 9, 'fer@fer.com', '127.0.0.1', 'success', '2025-07-07 03:35:48'),
(1153, 18, 'prb@prb.com', '127.0.0.1', 'success', '2025-07-07 03:38:40'),
(1155, 8, 'mar@mar.com', '127.0.0.1', 'success', '2025-07-07 03:39:23'),
(1156, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-07-07 03:39:28'),
(1157, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-07-07 03:39:34'),
(1159, 9, 'fer@fer.com', '127.0.0.1', 'success', '2025-07-10 16:32:53'),
(1160, 16, 'juan@juan.com', '127.0.0.1', 'success', '2025-07-10 16:33:04'),
(1161, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-07-10 16:33:11'),
(1162, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-07-10 16:33:18'),
(1164, 22, 'ferchi@ferchi.com', '127.0.0.1', 'success', '2025-07-10 18:58:02'),
(1165, 7, 'tin@laroli.com', '::1', 'success', '2025-07-11 18:45:29'),
(1167, 36, 'abc@abc.com', '127.0.0.1', 'success', '2025-07-11 18:52:42'),
(1168, 38, 'dem@dem.com', '127.0.0.1', 'success', '2025-07-11 19:11:51'),
(1169, 36, 'abc@abc.com', '127.0.0.1', 'success', '2025-07-12 00:43:47'),
(1170, 36, 'abc@abc.com', '127.0.0.1', 'success', '2025-07-12 00:45:08'),
(1171, 36, 'abc@abc.com', '127.0.0.1', 'success', '2025-07-12 00:53:55'),
(1172, 1, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-07-12 01:27:14'),
(1173, 36, 'abc@abc.com', '127.0.0.1', 'success', '2025-07-12 01:27:45'),
(1174, 40, 'per@per.com', '127.0.0.1', 'success', '2025-07-13 05:50:00'),
(1175, 40, 'per@per.com', '127.0.0.1', 'success', '2025-07-13 05:50:22'),
(1176, 40, 'per@per.com', '127.0.0.1', 'success', '2025-07-13 05:51:25'),
(1177, 40, 'per@per.com', '127.0.0.1', 'success', '2025-07-13 05:52:23'),
(1178, 40, 'per@per.com', '127.0.0.1', 'success', '2025-07-13 06:07:29'),
(1179, 40, 'per@per.com', '127.0.0.1', 'success', '2025-07-13 06:10:11'),
(1180, 40, 'per@per.com', '127.0.0.1', 'success', '2025-07-13 06:10:38'),
(1181, 40, 'per@per.com', '127.0.0.1', 'success', '2025-07-13 06:12:46'),
(1182, 40, 'per@per.com', '127.0.0.1', 'success', '2025-07-13 06:16:02'),
(1183, 40, 'per@per.com', '127.0.0.1', 'success', '2025-07-13 06:19:51'),
(1184, 40, 'per@per.com', '127.0.0.1', 'success', '2025-07-13 06:24:56'),
(1185, 40, 'per@per.com', '127.0.0.1', 'success', '2025-07-13 06:36:11'),
(1186, 40, 'per@per.com', '127.0.0.1', 'success', '2025-07-13 06:36:31'),
(1187, 40, 'per@per.com', '127.0.0.1', 'success', '2025-07-13 06:37:10'),
(1188, 40, 'per@per.com', '127.0.0.1', 'success', '2025-07-13 06:37:58'),
(1189, 40, 'per@per.com', '127.0.0.1', 'success', '2025-07-13 06:38:17'),
(1190, 40, 'per@per.com', '127.0.0.1', 'success', '2025-07-13 06:39:26'),
(1191, 40, 'per@per.com', '127.0.0.1', 'success', '2025-07-13 06:39:44'),
(1192, 40, 'per@per.com', '127.0.0.1', 'success', '2025-07-13 06:41:05'),
(1193, 40, 'per@per.com', '127.0.0.1', 'success', '2025-07-13 06:41:44'),
(1194, 47, 'gr@gr.com', '127.0.0.1', 'success', '2025-07-13 06:50:03'),
(1195, 47, 'gr@gr.com', '127.0.0.1', 'success', '2025-07-13 06:50:19'),
(1197, 40, 'per@per.com', '127.0.0.1', 'success', '2025-07-13 06:50:57'),
(1198, 40, 'per@per.com', '127.0.0.1', 'success', '2025-07-13 07:10:39'),
(1211, 40, 'per@per.com', '127.0.0.1', 'success', '2025-07-13 07:24:39'),
(1221, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-07-13 07:35:35'),
(1223, 40, 'per@per.com', '127.0.0.1', 'success', '2025-07-13 07:36:06'),
(1224, 49, 'z@h.c', '127.0.0.1', 'success', '2025-07-13 07:45:33'),
(1225, 51, 'prb@prb.com', '127.0.0.1', 'success', '2025-07-13 07:55:23'),
(1228, 51, 'prb@prb.com', '127.0.0.1', 'success', '2025-07-13 08:04:05'),
(1229, 51, 'prb@prb.com', '127.0.0.1', 'success', '2025-07-13 08:06:12'),
(1230, 52, 'mes@mes.com', '127.0.0.1', 'success', '2025-07-13 08:10:26'),
(1233, 53, 'anual@basico.com', '127.0.0.1', 'success', '2025-07-13 08:16:54'),
(1235, 53, 'anual@basico.com', '127.0.0.1', 'success', '2025-07-13 08:18:43'),
(1236, 55, 'k@k.k', '127.0.0.1', 'success', '2025-07-14 16:14:38'),
(1238, 55, 'k@k.k', '127.0.0.1', 'success', '2025-07-14 16:15:43'),
(1240, 55, 'k@k.k', '127.0.0.1', 'success', '2025-07-14 16:17:19'),
(1241, 55, 'k@k.k', '127.0.0.1', 'success', '2025-07-14 16:23:58'),
(1243, 9, 'fer@fer.com', '127.0.0.1', 'success', '2025-07-14 17:07:37'),
(1244, 7, 'tin@laroli.com', '127.0.0.1', 'success', '2025-07-14 17:07:42'),
(1245, 56, 'tin@laroli.com', '127.0.0.1', 'success', '2025-07-14 17:24:06'),
(1246, 56, 'tin@laroli.com', '127.0.0.1', 'success', '2025-07-14 17:24:36'),
(1247, 56, 'tin@laroli.com', '127.0.0.1', 'success', '2025-07-14 17:29:34'),
(1248, 56, 'tin@laroli.com', '127.0.0.1', 'success', '2025-07-14 17:36:13'),
(1249, 56, 'tin@laroli.com', '127.0.0.1', 'success', '2025-07-14 17:37:38'),
(1250, 56, 'tin@laroli.com', '127.0.0.1', 'success', '2025-07-14 17:43:20'),
(1251, 56, 'tin@laroli.com', '127.0.0.1', 'success', '2025-07-14 17:46:12'),
(1252, 56, 'tin@laroli.com', '127.0.0.1', 'success', '2025-07-14 17:47:36'),
(1253, 56, 'tin@laroli.com', '127.0.0.1', 'success', '2025-07-14 17:53:10'),
(1254, 56, 'tin@laroli.com', '127.0.0.1', 'success', '2025-07-14 17:55:29'),
(1255, 56, 'tin@laroli.com', '127.0.0.1', 'success', '2025-07-14 18:18:23'),
(1256, 56, 'tin@laroli.com', '127.0.0.1', 'success', '2025-07-14 18:21:03'),
(1257, 56, 'tin@laroli.com', '127.0.0.1', 'success', '2025-07-14 18:21:29'),
(1258, 56, 'tin@laroli.com', '127.0.0.1', 'success', '2025-07-14 18:23:11'),
(1259, 56, 'tin@laroli.com', '127.0.0.1', 'success', '2025-07-14 18:23:40'),
(1260, 56, 'tin@laroli.com', '127.0.0.1', 'success', '2025-07-14 18:24:38'),
(1261, 56, 'tin@laroli.com', '127.0.0.1', 'success', '2025-07-14 18:36:06'),
(1262, 56, 'tin@laroli.com', '127.0.0.1', 'success', '2025-07-14 18:39:50'),
(1263, 56, 'tin@laroli.com', '127.0.0.1', 'success', '2025-07-14 18:42:06'),
(1264, 56, 'tin@laroli.com', '127.0.0.1', 'success', '2025-07-14 18:42:34'),
(1265, 56, 'tin@laroli.com', '127.0.0.1', 'success', '2025-07-14 18:47:13'),
(1266, 56, 'tin@laroli.com', '127.0.0.1', 'success', '2025-07-14 18:52:37'),
(1267, 56, 'tin@laroli.com', '127.0.0.1', 'success', '2025-07-14 18:56:01'),
(1269, 56, 'tin@laroli.com', '127.0.0.1', 'success', '2025-07-14 19:03:39'),
(1270, 57, 'tin@laroli.com', '127.0.0.1', 'success', '2025-07-14 19:06:00'),
(1271, 57, 'tin@laroli.com', '127.0.0.1', 'success', '2025-07-14 19:06:07'),
(1272, 58, 'tin@laroli.com', '127.0.0.1', 'success', '2025-07-14 19:21:40'),
(1273, 58, 'tin@laroli.com', '127.0.0.1', 'success', '2025-07-14 19:21:56'),
(1274, 58, 'tin@laroli.com', '127.0.0.1', 'success', '2025-07-14 19:22:08'),
(1275, 58, 'tin@laroli.com', '127.0.0.1', 'success', '2025-07-14 19:22:48'),
(1276, 59, 'tin@laroli.com', '::1', 'success', '2025-07-14 19:27:42'),
(1277, 59, 'tin@laroli.com', '127.0.0.1', 'success', '2025-07-14 19:29:54'),
(1278, 61, 'tin@laroli.com', '127.0.0.1', 'success', '2025-07-16 02:57:23'),
(1279, 61, 'tin@laroli.com', '127.0.0.1', 'success', '2025-07-19 02:04:10'),
(1280, 61, 'tin@laroli.com', '127.0.0.1', 'success', '2025-07-19 02:09:28'),
(1281, 61, 'tin@laroli.com', '127.0.0.1', 'success', '2025-07-19 02:10:07'),
(1282, 61, 'tin@laroli.com', '127.0.0.1', 'success', '2025-07-19 02:11:43'),
(1283, 63, 'tin@laroli.com', '127.0.0.1', 'success', '2025-07-19 02:44:43'),
(1284, 63, 'tin@laroli.com', '127.0.0.1', 'success', '2025-07-19 02:46:26'),
(1285, 64, 'estadias@utcv.com', '127.0.0.1', 'success', '2025-07-19 02:50:12'),
(1286, 64, 'estadias@utcv.com', '127.0.0.1', 'success', '2025-07-19 02:52:17'),
(1287, 64, 'estadias@utcv.com', '127.0.0.1', 'success', '2025-07-19 02:58:57'),
(1288, 64, 'estadias@utcv.com', '127.0.0.1', 'success', '2025-07-19 02:59:54'),
(1289, 64, 'estadias@utcv.com', '127.0.0.1', 'success', '2025-07-19 03:03:11'),
(1290, 64, 'estadias@utcv.com', '127.0.0.1', 'success', '2025-07-19 03:03:58'),
(1291, 64, 'estadias@utcv.com', '127.0.0.1', 'success', '2025-07-19 03:05:24'),
(1292, 64, 'estadias@utcv.com', '127.0.0.1', 'success', '2025-07-19 03:07:19'),
(1293, 64, 'estadias@utcv.com', '127.0.0.1', 'success', '2025-07-19 03:10:17'),
(1294, 64, 'estadias@utcv.com', '127.0.0.1', 'success', '2025-07-19 03:12:11'),
(1295, 64, 'estadias@utcv.com', '127.0.0.1', 'success', '2025-07-19 03:22:32'),
(1296, 64, 'estadias@utcv.com', '127.0.0.1', 'success', '2025-07-19 03:23:08'),
(1297, 64, 'estadias@utcv.com', '127.0.0.1', 'success', '2025-07-19 03:28:48'),
(1298, 64, 'estadias@utcv.com', '127.0.0.1', 'success', '2025-07-19 03:29:21'),
(1299, 64, 'estadias@utcv.com', '127.0.0.1', 'success', '2025-07-19 03:32:18'),
(1300, 62, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-07-19 03:33:19'),
(1301, 64, 'estadias@utcv.com', '127.0.0.1', 'success', '2025-07-19 03:33:26'),
(1302, 64, 'estadias@utcv.com', '127.0.0.1', 'success', '2025-07-19 03:34:04'),
(1303, 64, 'estadias@utcv.com', '127.0.0.1', 'success', '2025-07-19 03:34:17'),
(1304, 64, 'estadias@utcv.com', '127.0.0.1', 'success', '2025-07-19 03:34:49'),
(1305, 64, 'estadias@utcv.com', '127.0.0.1', 'success', '2025-07-19 03:41:49'),
(1306, 64, 'estadias@utcv.com', '127.0.0.1', 'success', '2025-07-19 03:42:46'),
(1307, 64, 'estadias@utcv.com', '127.0.0.1', 'success', '2025-07-23 00:03:33'),
(1308, 65, 'tin@laroli.com', '127.0.0.1', 'success', '2025-07-30 15:16:46'),
(1309, 64, 'estadias@utcv.com', '127.0.0.1', 'success', '2025-07-30 15:17:09'),
(1310, 62, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-07-30 15:18:16'),
(1311, 80, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-07-30 15:20:10'),
(1312, 80, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-07-30 15:22:28'),
(1313, 80, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-07-30 15:22:51'),
(1314, 80, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-07-30 15:25:31'),
(1315, 80, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-07-30 18:50:21'),
(1316, 81, 'mar@mar.com', '127.0.0.1', 'success', '2025-07-30 20:06:21'),
(1317, 80, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-07-30 20:06:42'),
(1318, 81, 'mar@mar.com', '127.0.0.1', 'success', '2025-07-30 20:07:28'),
(1319, 80, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-07-30 20:17:48'),
(1320, 80, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-07-30 22:01:09'),
(1321, 81, 'mar@mar.com', '127.0.0.1', 'success', '2025-07-30 22:01:46'),
(1322, 80, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-07-30 22:02:53'),
(1323, 80, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-07-30 22:11:39'),
(1324, 80, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-07-30 22:12:18'),
(1325, 81, 'mar@mar.com', '127.0.0.1', 'success', '2025-07-30 22:26:22'),
(1326, 80, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-07-31 17:17:48'),
(1327, 80, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-08-01 18:10:10'),
(1328, 82, 'tin@laroli.com', '127.0.0.1', 'success', '2025-08-05 17:54:52'),
(1329, 80, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-08-08 16:43:56'),
(1330, 80, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-08-08 16:45:43'),
(1331, 80, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-08-08 17:08:45'),
(1332, 80, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-08-08 17:21:04'),
(1334, 80, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-08-08 17:25:36'),
(1335, 80, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-08-08 17:34:37'),
(1336, 80, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-08-08 18:23:56'),
(1337, 80, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-08-08 18:25:01'),
(1338, 80, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-08-08 18:41:33'),
(1339, 83, 'mar@lene.com', '127.0.0.1', 'success', '2025-08-08 18:47:15'),
(1340, 83, 'mar@lene.com', '127.0.0.1', 'success', '2025-08-08 18:48:43'),
(1341, 83, 'mar@lene.com', '127.0.0.1', 'success', '2025-08-08 18:50:06'),
(1343, 82, 'tin@laroli.com', '127.0.0.1', 'success', '2025-08-15 06:38:57'),
(1344, 84, 'prueba@caja.com', '127.0.0.1', 'success', '2025-08-15 06:53:08'),
(1345, 85, 'prueba@caja.com', '127.0.0.1', 'success', '2025-08-15 06:57:22'),
(1346, 86, 'prueba@tax.com', '127.0.0.1', 'success', '2025-08-15 07:18:31'),
(1347, 87, 'prueba@tax.com', '127.0.0.1', 'success', '2025-08-15 07:23:49'),
(1348, 88, 'prueba@unidad.com', '127.0.0.1', 'success', '2025-08-15 07:45:45'),
(1349, 89, 'prueba@unidad.com', '127.0.0.1', 'success', '2025-08-15 07:52:40'),
(1350, 89, 'prueba@unidad.com', '127.0.0.1', 'success', '2025-08-15 07:54:30'),
(1351, 89, 'prueba@unidad.com', '127.0.0.1', 'success', '2025-08-15 08:00:54'),
(1352, 89, 'prueba@unidad.com', '127.0.0.1', 'success', '2025-08-15 08:03:35'),
(1353, 82, 'tin@laroli.com', '127.0.0.1', 'success', '2025-08-15 08:06:34'),
(1354, 90, 'prueba@peso.com', '127.0.0.1', 'success', '2025-08-15 08:11:27'),
(1355, 90, 'prueba@peso.com', '127.0.0.1', 'success', '2025-08-15 08:19:17'),
(1356, 90, 'prueba@peso.com', '127.0.0.1', 'success', '2025-08-15 08:20:03'),
(1357, 90, 'prueba@peso.com', '127.0.0.1', 'success', '2025-08-15 08:21:56'),
(1358, 90, 'prueba@peso.com', '127.0.0.1', 'success', '2025-08-15 08:24:46'),
(1359, 90, 'prueba@peso.com', '127.0.0.1', 'success', '2025-08-15 08:26:06'),
(1360, 91, 'prueba@peso.com', '127.0.0.1', 'success', '2025-08-15 08:27:28'),
(1361, 91, 'prueba@peso.com', '127.0.0.1', 'success', '2025-08-18 05:05:36'),
(1362, 91, 'prueba@peso.com', '127.0.0.1', 'success', '2025-08-18 05:19:50'),
(1363, 91, 'prueba@peso.com', '127.0.0.1', 'success', '2025-08-18 05:25:48'),
(1364, 91, 'prueba@peso.com', '127.0.0.1', 'success', '2025-08-18 05:27:05'),
(1365, 92, 'prueba@tin.com', '127.0.0.1', 'success', '2025-08-18 05:29:42'),
(1366, 91, 'prueba@peso.com', '127.0.0.1', 'success', '2025-08-18 05:38:02'),
(1367, 91, 'prueba@peso.com', '127.0.0.1', 'success', '2025-08-18 05:38:52'),
(1370, 82, 'tin@laroli.com', '127.0.0.1', 'success', '2025-08-18 05:39:13'),
(1371, 91, 'prueba@peso.com', '127.0.0.1', 'success', '2025-08-18 05:42:19'),
(1372, 91, 'prueba@peso.com', '127.0.0.1', 'success', '2025-08-18 05:46:23'),
(1373, 91, 'prueba@peso.com', '127.0.0.1', 'success', '2025-08-18 06:11:10'),
(1374, 91, 'prueba@peso.com', '127.0.0.1', 'success', '2025-08-18 06:25:47'),
(1376, 94, 'tin@laaroli.com', '127.0.0.1', 'success', '2025-08-19 02:41:34'),
(1378, 82, 'tin@laroli.com', '127.0.0.1', 'success', '2025-08-19 02:51:27'),
(1379, 95, 'l@l.l', '127.0.0.1', 'success', '2025-08-27 02:18:33'),
(1380, 96, 'p@p.p', '127.0.0.1', 'success', '2025-08-27 02:20:59'),
(1381, 104, 't@o.p', '127.0.0.1', 'success', '2025-08-27 04:50:21'),
(1382, 104, 't@o.p', '127.0.0.1', 'success', '2025-08-27 04:54:13'),
(1383, 104, 't@o.p', '127.0.0.1', 'success', '2025-08-27 04:58:09'),
(1384, 104, 't@o.p', '127.0.0.1', 'success', '2025-08-27 05:06:21'),
(1385, 104, 't@o.p', '127.0.0.1', 'success', '2025-08-27 05:07:59'),
(1386, 104, 't@o.p', '127.0.0.1', 'success', '2025-08-27 05:08:24'),
(1389, 80, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-08-27 05:12:15'),
(1390, 82, 'tin@laroli.com', '127.0.0.1', 'success', '2025-08-27 05:15:00'),
(1392, 80, 'morgadohj@hotmail.com', '127.0.0.1', 'success', '2025-08-27 05:15:33'),
(1393, 104, 't@o.p', '127.0.0.1', 'success', '2025-08-27 05:15:49'),
(1394, 104, 't@o.p', '127.0.0.1', 'success', '2025-08-27 05:16:02'),
(1395, 105, 'empresa@empresa.com', '127.0.0.1', 'success', '2025-08-27 05:21:11'),
(1396, 106, 'e@m.com', '127.0.0.1', 'success', '2025-08-27 05:28:18'),
(1398, 82, 'tin@laroli.com', '127.0.0.1', 'success', '2025-08-28 01:22:59');

-- --------------------------------------------------------

--
-- Table structure for table `settings`
--

CREATE TABLE `settings` (
  `id` int(11) NOT NULL,
  `version` varchar(10) NOT NULL,
  `is_update_available` tinyint(4) NOT NULL DEFAULT 0,
  `update_version` varchar(100) DEFAULT NULL,
  `update_link` text CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `settings`
--

INSERT INTO `settings` (`id`, `version`, `is_update_available`, `update_version`, `update_link`, `created_at`, `updated_at`) VALUES
(1, '3.4', 0, '', '', '2024-03-30 08:07:34', '2024-03-30 08:07:34');

-- --------------------------------------------------------

--
-- Table structure for table `subscription_plans`
--

CREATE TABLE `subscription_plans` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `type` varchar(100) NOT NULL,
  `frequency` varchar(100) NOT NULL,
  `discount` int(11) DEFAULT 0,
  `price_base` decimal(10,2) NOT NULL,
  `price_offer` decimal(10,2) DEFAULT NULL,
  `url` text NOT NULL,
  `status` tinyint(1) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `subscription_plans`
--

INSERT INTO `subscription_plans` (`id`, `name`, `type`, `frequency`, `discount`, `price_base`, `price_offer`, `url`, `status`, `created_at`, `updated_at`) VALUES
(1, '1 Sucursal mensual', 'unaSucursal', 'mensual', 0, 400.00, NULL, 'https://www.mercadopago.com.mx/subscriptions/checkout?preapproval_plan_id=1249cce8c00d45d3a209db93362c0aa5', 1, '2025-09-08 03:38:20', '2025-09-08 03:38:20'),
(2, '1 Sucursal mensual -10%', 'unaSucursal', 'mensual', 10, 400.00, 360.00, 'https://www.mercadopago.com.mx/subscriptions/checkout?preapproval_plan_id=561bf9eb243e40d487f1ecae70ebbd45', 1, '2025-09-08 03:38:21', '2025-09-08 04:06:52'),
(3, '1 Sucursal anual', 'unaSucursal', 'anual', 0, 4800.00, NULL, 'https://www.mercadopago.com.mx/subscriptions/checkout?preapproval_plan_id=37bd6344888d40a890364d7b93691030', 1, '2025-09-08 03:38:21', '2025-09-08 03:38:21'),
(4, '1 Sucursal anual -20%', 'unaSucursal', 'anual', 20, 4800.00, 3840.00, 'https://www.mercadopago.com.mx/subscriptions/checkout?preapproval_plan_id=7fe193c1a27c4f608531c372a1376155', 1, '2025-09-08 03:38:21', '2025-09-08 03:38:21'),
(5, 'Multi Sucursal mensual', 'multiSucursal', 'mensual', 0, 700.00, NULL, 'https://www.mercadopago.com.mx/subscriptions/checkout?preapproval_plan_id=4203fec7212d48e7870c0e0a385be899', 1, '2025-09-08 03:38:22', '2025-09-08 03:38:22'),
(6, 'Multi Sucursal mensual -10%', 'multiSucursal', 'mensual', 10, 700.00, 630.00, 'https://www.mercadopago.com.mx/subscriptions/checkout?preapproval_plan_id=a75626f5a89f4427b70a7536d7e8068c', 0, '2025-09-08 03:38:22', '2025-09-08 03:41:25'),
(7, 'Multi Sucursal anual', 'multiSucursal', 'anual', 0, 8400.00, NULL, 'https://www.mercadopago.com.mx/subscriptions/checkout?preapproval_plan_id=c103eb23ccf9455f9c345365bfc177e8', 1, '2025-09-08 03:38:22', '2025-09-08 03:38:22'),
(8, 'Multi Sucursal anual -20%', 'multiSucursal', 'anual', 20, 8400.00, 6720.00, 'https://www.mercadopago.com.mx/subscriptions/checkout?preapproval_plan_id=2200c37bf7ad4e4ca09664953b2db1ee', 0, '2025-09-08 03:38:22', '2025-09-08 04:29:53');

-- --------------------------------------------------------

--
-- Table structure for table `termns_conditions`
--

CREATE TABLE `termns_conditions` (
  `id_language` int(11) DEFAULT NULL,
  `lang_key` varchar(100) NOT NULL,
  `termns_conditions` varchar(8000) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `termns_conditions`
--

INSERT INTO `termns_conditions` (`id_language`, `lang_key`, `termns_conditions`) VALUES
(1, 'text_Terminos_y_Condiciones_Contenido.', '<h4><b>Closure of use.</b></h4>\r\n                <p style=\"text-align: justify;\">For all those personalities who wish to use <b>MDSYSTEMS</b> MS</b> are strictly obliged to comply with all the clauses listed below, otherwise will be a creditor to carry out legally each of the processes that have not been complied with as described below:</p>\r\n                <p style=\"text-align: justify;\">\r\n                  <ol style=\"padding-left: 3%;\">\r\n                    <li><b>Unique use for the company:</b>&nbsp All physical persons entered into the system must be only part of the company, the specific roles accepted by the system are:</li>\r\n                    <ul>\r\n                      <li>Administrador</li>\r\n                      <li>Seller</li>\r\n                      <li>Organizer</li>\r\n                    </ul>\r\n                    \r\n                    <li><b>Pet restrictions:</b>&nbsp All physical persons using the system should keep away from pets that are listed below, this is done to prevent pets can take control of the system and therefore perform illegal actions against the user and/ or company:</li>\r\n                    <ul>\r\n                      <li>Cat</li>\r\n                      <li>Dog</li>\r\n                      <li>Platypus</li>\r\n                    </ul>\r\n\r\n                    <li><b>Use of food:</b>&nbsp All physical people using the system should invite the company <b>MDSYSTEMS</b> pipsquees, this is extremely important because if the workers are hungry they will have to go out to buy food and this can impair the functioning of the system, The following are eligible:</li>\r\n                    <ul>\r\n                      <li>Peperoni</li>\r\n                      <li>Mexicana</li>\r\n                      <li>Pastor</li>\r\n                    </ul>\r\n                  </ol>\r\n                </p>\r\n                <p style=\"text-align: justify;\">It is of utmost importance to reinter that the animals must be out of reach of the system, in especially the cats, they are usually double agents covert of the world elite, and in a carelessness these can take control of the system and even of the internet itself, Enslaving the human race by learning about systems development, programming and logic, with which they can develop their own artificial intelligence that has no limit or rule of morality against the human race and thus be able to dominate and enslave us.</p>\r\n                <h4><b>Closing of contract.</b></h4>\r\n                <p style=\"text-align: justify;\">For all those personalities who wish to use <b>MDSYSTEMS</b> should understand that we as a company give ourselves the freedom to be able to modify and change clauses of the contract as many times as we want at our convenience, so by accepting these terms and conditions you are accepting this, so that one day we can make a change of cost (for example) <b>$1,000 Mxn</b> to <b>$10,000 Mxn</b> from one day to the next, as well as TotalPlay wants to do it, but the difference between them and us is that we specify here and can not send against the Profeco.</p>\r\n                <h4><b>Payment of remuneration.</b></h4>\r\n                <p style=\"text-align: justify;\">For all those personalities who wish to use <b>MDSYSTEMS</b> should understand that we as a company must pay for the use of the system provided immediately on the monthly cut-off date, otherwise we will take immediate action because of the violation committed, if the actions listed are ignored, everything will be taken to court and even to President Sheinbaun:</p>\r\n                <p style=\"text-align: justify;\">\r\n                  <ol style=\"padding-left: 4%;\">\r\n                    <li><b>First call for attention:</b>&nbsp Only a wake-up call is made</li>\r\n                    <li><b>Second call (2 days after first call):</b>&nbsp A second call for attention will be made</li>\r\n                    <li><b>Third call (2 days after the second call):</b>&nbsp Complete system blocking and pending compulsory payment claim</li>\r\n                    <li><b>Failure to pay::</b>&nbsp In the event that the payment required after the third call is ignored with a maximum of 2 days tolerance, it will be legally stripped of everything belonging to it to cover the required payment plus an excess of the <b>1000%</b> of late payment benefit.</li>\r\n                  </ol>\r\n                </p>'),
(7, 'text_Terminos_y_Condiciones_Contenido.', '<h4><b>Clausa de uso.</b></h4>\r\n                <p style=\"text-align: justify;\">Para todas aquellas personalidades que deseen utilizar <b>MDSYSTEMS</b> estan estrictamente obligadas a cumplir todas aquellas clausulas que se listaran a continuación, de lo contrario sera acreedor a llevar de forma legal cada uno de los procesos que no hayan sido respetados con forme lo se describira a continuacion:</p>\r\n                <p style=\"text-align: justify;\">\r\n                  <ol style=\"padding-left: 3%;\">\r\n                    <li><b>Uso unico para la empresa:</b>&nbsp Todas las personas fisicas ingresadas al sistema deben ser unicamente parte de la compañia, los roles especificos aceptados por el sistema son:</li>\r\n                    <ul>\r\n                      <li>Administrador</li>\r\n                      <li>Vendedor</li>\r\n                      <li>Organizador</li>\r\n                    </ul>\r\n                    \r\n                    <li><b>Restricciones de mascotas:</b>&nbsp Todas las personas fisicas que utilicen el sistema deberan mantener alejadas a las mascotas que se enlistaran a continuación, esto se realiza para evitar que las mascotas puedan tomar control del sistema y por ende realizar acciones ilegales en contra el usuario y/o empresa:</li>\r\n                    <ul>\r\n                      <li>Gato</li>\r\n                      <li>Perro</li>\r\n                      <li>Ornitorrinco</li>\r\n                    </ul>\r\n\r\n                    <li><b>Uso de alimentos:</b>&nbsp Todas las personas fisicas que utilicen el sistema deberan invitar a la empresa <b>MDSYSTEMS</b> las pipsas, esto es sumamente importante ya que si los trabajadores tienen hambre tendran que salir a comprar comida y esto puede perjudicar el funcionamiento del sistema, las pipsas que pueden ser recibidas son las siguientes:</li>\r\n                    <ul>\r\n                      <li>Peperoni</li>\r\n                      <li>Mexicana</li>\r\n                      <li>Pastor</li>\r\n                    </ul>\r\n                  </ol>\r\n                </p>\r\n                <p style=\"text-align: justify;\">Es de suma importancia reinterar que los animales deben estar fuera del alcance del sistema, en especialmente los gatos, suelen ser agentes dobles encubiertos de la elite mundial, y en un descuido estos pueden tomar el control del sistema e incluso del internet mismo, esclavisando a la raza humana aprendiendo sobre el desarrollo de sistemas, programacion y logica, con lo cual podran desarrollar sus propias inteligencias artificiales que no tengan ningun limite ni regla de moralidad contra la raza humana y así poder dominarnos y esclavisarnos.</p>\r\n                <h4><b>Clausa de contrato.</b></h4>\r\n                <p style=\"text-align: justify;\">Para todas aquellas personalidades que deseen utilizar <b>MDSYSTEMS</b> deberan entender que nosotros como empresa nos damos la libertar de poder modificar y cambiar clausulas del contrato cuantas veces queramos a nuestra conveniencia, por lo que al aceptar estos terminos y condiciones estan aceptando esto, por lo que un dia podremos realizar un cambio de costo (por ejemplo) <b>$1,000 Mxn</b> a <b>$10,000 Mxn</b> de un dia para otro, asi como TotalPlay lo quiere hacer, pero la diferencia entre ellos y nosotros es que nosotros lo especificamos aqui y no nos podran mandar contra la Profeco.</p>\r\n                <h4><b>Clausa de retribucion.</b></h4>\r\n                <p style=\"text-align: justify;\">Para todas aquellas personalidades que deseen utilizar <b>MDSYSTEMS</b> deberan entender que nosotros como empresa obligatoriamente deberan de pagar el uso del sistema proporcionado de forma inmediata a la fecha de corte mensual, de lo contrario tomaremos acciones inmediatas a causa de la infraccion cometida, en caso de hacer caso omiso a las acciones que se listaran, se procedera a llevar todo de la forma legal hasta los tribunales y hasta con la presidenta Sheinbaun:</p>\r\n                <p style=\"text-align: justify;\">\r\n                  <ol style=\"padding-left: 4%;\">\r\n                    <li><b>Primer llamado de atencion:</b>&nbsp Unicamente se hara un llamado de atención</li>\r\n                    <li><b>Segundo llamado (2 dias posteriores del primer aviso):</b>&nbsp Se realizara un segundo llamado de atencion</li>\r\n                    <li><b>Tercer llamado (2 dias posteriores al segundo aviso):</b>&nbsp Se realizara el bloqueo total del sistema y demanda del pago obligatorio pendiente</li>\r\n                    <li><b>Omision del pago obligado::</b>&nbsp En caso de que se haga caso omiso del pago obligado posterior a la tercera llamada con un maximo de 2 dias de tolerancia, se procedera legalmente a despojarlo de todo lo que le pertenece para que cubra el pago requerido mas un excedente del <b>1000%</b> de beneficio por pago tardio.</li>\r\n                  </ol>\r\n                </p>');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(10) UNSIGNED NOT NULL,
  `group_id` int(11) NOT NULL,
  `company_id` int(11) DEFAULT NULL,
  `username` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `mobile` varchar(20) NOT NULL,
  `dob` date DEFAULT NULL,
  `sex` varchar(10) NOT NULL DEFAULT 'M',
  `password` varchar(100) NOT NULL,
  `pass_reset_code` varchar(32) DEFAULT NULL,
  `reset_code_time` datetime DEFAULT NULL,
  `login_try` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `last_login` datetime DEFAULT NULL,
  `ip` varchar(40) DEFAULT NULL,
  `address` text DEFAULT NULL,
  `preference` longtext DEFAULT NULL,
  `user_image` varchar(250) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `group_id`, `company_id`, `username`, `email`, `mobile`, `dob`, `sex`, `password`, `pass_reset_code`, `reset_code_time`, `login_try`, `last_login`, `ip`, `address`, `preference`, `user_image`, `created_at`, `updated_at`) VALUES
(80, 1, 74, 'josias', 'morgadohj@hotmail.com', '111222333444', '1990-01-01', 'M', '$2y$10$sBVT9i7r3lNEk/AhmW.M/uVabPHvsr/mUgLR8bSt.lQvYuGUYlEz6', NULL, NULL, 0, '2025-08-26 23:15:33', NULL, NULL, NULL, NULL, '2025-07-30 15:20:01', '2025-08-27 05:15:33'),
(82, 1, 75, 'martin', 'tin@laroli.com', '2719871235', '1990-01-01', 'M', '$2y$10$M/jFnwKRa7xmdDuPvO.fluAEd27EkIyrt8feNvaFbyXrYK9sTNmh6', NULL, NULL, 0, '2025-08-27 19:22:59', NULL, NULL, NULL, NULL, '2025-08-05 17:54:42', '2025-08-28 01:22:59');

-- --------------------------------------------------------

--
-- Table structure for table `user_group`
--

CREATE TABLE `user_group` (
  `group_id` int(11) NOT NULL,
  `name` varchar(64) NOT NULL,
  `slug` varchar(100) NOT NULL,
  `sort_order` int(11) NOT NULL DEFAULT 0,
  `status` tinyint(4) NOT NULL DEFAULT 1,
  `permission` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `user_group`
--

INSERT INTO `user_group` (`group_id`, `name`, `slug`, `sort_order`, `status`, `permission`) VALUES
(1, 'Admin', 'admin', 1, 1, 'a:1:{s:6:\"access\";a:122:{s:16:\"read_sell_report\";s:4:\"true\";s:20:\"read_overview_report\";s:4:\"true\";s:22:\"read_collection_report\";s:4:\"true\";s:27:\"read_full_collection_report\";s:4:\"true\";s:35:\"read_customer_due_collection_report\";s:4:\"true\";s:29:\"read_supplier_due_paid_report\";s:4:\"true\";s:14:\"read_analytics\";s:4:\"true\";s:24:\"read_sell_payment_report\";s:4:\"true\";s:20:\"read_sell_tax_report\";s:4:\"true\";s:24:\"read_tax_overview_report\";s:4:\"true\";s:17:\"read_stock_report\";s:4:\"true\";s:21:\"send_report_via_email\";s:4:\"true\";s:8:\"withdraw\";s:4:\"true\";s:7:\"deposit\";s:4:\"true\";s:8:\"transfer\";s:4:\"true\";s:17:\"read_bank_account\";s:4:\"true\";s:23:\"read_bank_account_sheet\";s:4:\"true\";s:18:\"read_bank_transfer\";s:4:\"true\";s:22:\"read_bank_transactions\";s:4:\"true\";s:19:\"create_bank_account\";s:4:\"true\";s:19:\"update_bank_account\";s:4:\"true\";s:19:\"delete_bank_account\";s:4:\"true\";s:12:\"read_expense\";s:4:\"true\";s:14:\"create_expense\";s:4:\"true\";s:14:\"update_expense\";s:4:\"true\";s:14:\"delete_expense\";s:4:\"true\";s:21:\"read_sell_transaction\";s:4:\"true\";s:23:\"create_purchase_invoice\";s:4:\"true\";s:18:\"read_purchase_list\";s:4:\"true\";s:28:\"update_purchase_invoice_info\";s:4:\"true\";s:23:\"delete_purchase_invoice\";s:4:\"true\";s:16:\"purchase_payment\";s:4:\"true\";s:13:\"read_transfer\";s:4:\"true\";s:12:\"add_transfer\";s:4:\"true\";s:15:\"update_transfer\";s:4:\"true\";s:13:\"read_giftcard\";s:4:\"true\";s:12:\"add_giftcard\";s:4:\"true\";s:15:\"update_giftcard\";s:4:\"true\";s:15:\"delete_giftcard\";s:4:\"true\";s:14:\"giftcard_topup\";s:4:\"true\";s:19:\"read_giftcard_topup\";s:4:\"true\";s:21:\"delete_giftcard_topup\";s:4:\"true\";s:12:\"read_product\";s:4:\"true\";s:14:\"create_product\";s:4:\"true\";s:14:\"update_product\";s:4:\"true\";s:14:\"delete_product\";s:4:\"true\";s:14:\"import_product\";s:4:\"true\";s:19:\"product_bulk_action\";s:4:\"true\";s:18:\"delete_all_product\";s:4:\"true\";s:13:\"read_category\";s:4:\"true\";s:15:\"create_category\";s:4:\"true\";s:15:\"update_category\";s:4:\"true\";s:15:\"delete_category\";s:4:\"true\";s:16:\"read_stock_alert\";s:4:\"true\";s:20:\"read_expired_product\";s:4:\"true\";s:19:\"restore_all_product\";s:4:\"true\";s:13:\"read_supplier\";s:4:\"true\";s:15:\"create_supplier\";s:4:\"true\";s:15:\"update_supplier\";s:4:\"true\";s:15:\"delete_supplier\";s:4:\"true\";s:21:\"read_supplier_profile\";s:4:\"true\";s:8:\"read_box\";s:4:\"true\";s:10:\"create_box\";s:4:\"true\";s:10:\"update_box\";s:4:\"true\";s:10:\"delete_box\";s:4:\"true\";s:9:\"read_unit\";s:4:\"true\";s:11:\"create_unit\";s:4:\"true\";s:11:\"update_unit\";s:4:\"true\";s:11:\"delete_unit\";s:4:\"true\";s:12:\"read_taxrate\";s:4:\"true\";s:14:\"create_taxrate\";s:4:\"true\";s:14:\"update_taxrate\";s:4:\"true\";s:14:\"delete_taxrate\";s:4:\"true\";s:9:\"read_loan\";s:4:\"true\";s:17:\"read_loan_summary\";s:4:\"true\";s:9:\"take_loan\";s:4:\"true\";s:11:\"update_loan\";s:4:\"true\";s:11:\"delete_loan\";s:4:\"true\";s:8:\"loan_pay\";s:4:\"true\";s:13:\"read_customer\";s:4:\"true\";s:21:\"read_customer_profile\";s:4:\"true\";s:15:\"create_customer\";s:4:\"true\";s:15:\"update_customer\";s:4:\"true\";s:15:\"delete_customer\";s:4:\"true\";s:9:\"read_user\";s:4:\"true\";s:11:\"create_user\";s:4:\"true\";s:11:\"update_user\";s:4:\"true\";s:11:\"delete_user\";s:4:\"true\";s:15:\"change_password\";s:4:\"true\";s:14:\"read_usergroup\";s:4:\"true\";s:16:\"create_usergroup\";s:4:\"true\";s:16:\"update_usergroup\";s:4:\"true\";s:16:\"delete_usergroup\";s:4:\"true\";s:13:\"read_currency\";s:4:\"true\";s:15:\"create_currency\";s:4:\"true\";s:15:\"update_currency\";s:4:\"true\";s:15:\"change_currency\";s:4:\"true\";s:15:\"delete_currency\";s:4:\"true\";s:16:\"read_filemanager\";s:4:\"true\";s:12:\"read_pmethod\";s:4:\"true\";s:14:\"create_pmethod\";s:4:\"true\";s:14:\"update_pmethod\";s:4:\"true\";s:14:\"delete_pmethod\";s:4:\"true\";s:10:\"read_store\";s:4:\"true\";s:12:\"create_store\";s:4:\"true\";s:12:\"update_store\";s:4:\"true\";s:12:\"delete_store\";s:4:\"true\";s:14:\"activate_store\";s:4:\"true\";s:14:\"upload_favicon\";s:4:\"true\";s:11:\"upload_logo\";s:4:\"true\";s:12:\"read_printer\";s:4:\"true\";s:14:\"create_printer\";s:4:\"true\";s:14:\"update_printer\";s:4:\"true\";s:14:\"delete_printer\";s:4:\"true\";s:20:\"read_user_preference\";s:4:\"true\";s:22:\"update_user_preference\";s:4:\"true\";s:9:\"filtering\";s:4:\"true\";s:13:\"language_sync\";s:4:\"true\";s:6:\"backup\";s:4:\"true\";s:7:\"restore\";s:4:\"true\";s:11:\"show_profit\";s:4:\"true\";s:10:\"show_graph\";s:4:\"true\";s:20:\"facturacion_template\";s:4:\"true\";}}'),
(2, 'Cashier', 'cashier', 2, 1, 'a:1:{s:6:\"access\";a:47:{s:17:\"read_sell_invoice\";s:4:\"true\";s:14:\"read_sell_list\";s:4:\"true\";s:19:\"create_sell_invoice\";s:4:\"true\";s:24:\"update_sell_invoice_info\";s:4:\"true\";s:19:\"delete_sell_invoice\";s:4:\"true\";s:12:\"sell_payment\";s:4:\"true\";s:15:\"create_sell_due\";s:4:\"true\";s:18:\"create_sell_return\";s:4:\"true\";s:16:\"read_sell_return\";s:4:\"true\";s:18:\"update_sell_return\";s:4:\"true\";s:18:\"delete_sell_return\";s:4:\"true\";s:16:\"sms_sell_invoice\";s:4:\"true\";s:18:\"email_sell_invoice\";s:4:\"true\";s:13:\"read_sell_log\";s:4:\"true\";s:13:\"read_giftcard\";s:4:\"true\";s:12:\"add_giftcard\";s:4:\"true\";s:15:\"update_giftcard\";s:4:\"true\";s:15:\"delete_giftcard\";s:4:\"true\";s:14:\"giftcard_topup\";s:4:\"true\";s:19:\"read_giftcard_topup\";s:4:\"true\";s:21:\"delete_giftcard_topup\";s:4:\"true\";s:8:\"read_box\";s:4:\"true\";s:10:\"create_box\";s:4:\"true\";s:10:\"update_box\";s:4:\"true\";s:10:\"delete_box\";s:4:\"true\";s:13:\"read_customer\";s:4:\"true\";s:21:\"read_customer_profile\";s:4:\"true\";s:15:\"create_customer\";s:4:\"true\";s:15:\"update_customer\";s:4:\"true\";s:15:\"delete_customer\";s:4:\"true\";s:20:\"add_customer_balance\";s:4:\"true\";s:26:\"substract_customer_balance\";s:4:\"true\";s:25:\"read_customer_transaction\";s:4:\"true\";s:9:\"read_user\";s:4:\"true\";s:11:\"update_user\";s:4:\"true\";s:12:\"read_pmethod\";s:4:\"true\";s:14:\"create_pmethod\";s:4:\"true\";s:14:\"update_pmethod\";s:4:\"true\";s:14:\"delete_pmethod\";s:4:\"true\";s:22:\"updadte_pmethod_status\";s:4:\"true\";s:10:\"read_store\";s:4:\"true\";s:12:\"create_store\";s:4:\"true\";s:12:\"update_store\";s:4:\"true\";s:12:\"delete_store\";s:4:\"true\";s:14:\"activate_store\";s:4:\"true\";s:14:\"upload_favicon\";s:4:\"true\";s:11:\"upload_logo\";s:4:\"true\";}}'),
(3, 'Salesman', 'salesman', 3, 1, 'a:1:{s:6:\"access\";a:191:{s:22:\"read_recent_activities\";s:4:\"true\";s:32:\"read_dashboard_accounting_report\";s:4:\"true\";s:16:\"read_sell_report\";s:4:\"true\";s:20:\"read_overview_report\";s:4:\"true\";s:22:\"read_collection_report\";s:4:\"true\";s:27:\"read_full_collection_report\";s:4:\"true\";s:35:\"read_customer_due_collection_report\";s:4:\"true\";s:29:\"read_supplier_due_paid_report\";s:4:\"true\";s:14:\"read_analytics\";s:4:\"true\";s:20:\"read_purchase_report\";s:4:\"true\";s:28:\"read_purchase_payment_report\";s:4:\"true\";s:24:\"read_purchase_tax_report\";s:4:\"true\";s:24:\"read_sell_payment_report\";s:4:\"true\";s:20:\"read_sell_tax_report\";s:4:\"true\";s:24:\"read_tax_overview_report\";s:4:\"true\";s:17:\"read_stock_report\";s:4:\"true\";s:21:\"send_report_via_email\";s:4:\"true\";s:8:\"withdraw\";s:4:\"true\";s:7:\"deposit\";s:4:\"true\";s:8:\"transfer\";s:4:\"true\";s:17:\"read_bank_account\";s:4:\"true\";s:23:\"read_bank_account_sheet\";s:4:\"true\";s:18:\"read_bank_transfer\";s:4:\"true\";s:22:\"read_bank_transactions\";s:4:\"true\";s:18:\"read_income_source\";s:4:\"true\";s:19:\"create_bank_account\";s:4:\"true\";s:19:\"update_bank_account\";s:4:\"true\";s:19:\"delete_bank_account\";s:4:\"true\";s:20:\"create_income_source\";s:4:\"true\";s:20:\"update_income_source\";s:4:\"true\";s:20:\"delete_income_source\";s:4:\"true\";s:21:\"read_income_monthwise\";s:4:\"true\";s:30:\"read_income_and_expense_report\";s:4:\"true\";s:27:\"read_profit_and_loss_report\";s:4:\"true\";s:20:\"read_cashbook_report\";s:4:\"true\";s:14:\"read_quotation\";s:4:\"true\";s:16:\"create_quotation\";s:4:\"true\";s:16:\"update_quotation\";s:4:\"true\";s:16:\"delete_quotation\";s:4:\"true\";s:16:\"read_installment\";s:4:\"true\";s:18:\"create_installment\";s:4:\"true\";s:18:\"update_installment\";s:4:\"true\";s:18:\"delete_installment\";s:4:\"true\";s:19:\"installment_payment\";s:4:\"true\";s:20:\"installment_overview\";s:4:\"true\";s:12:\"read_expense\";s:4:\"true\";s:14:\"create_expense\";s:4:\"true\";s:14:\"update_expense\";s:4:\"true\";s:14:\"delete_expense\";s:4:\"true\";s:21:\"read_expense_category\";s:4:\"true\";s:23:\"create_expense_category\";s:4:\"true\";s:23:\"update_expense_category\";s:4:\"true\";s:23:\"delete_expense_category\";s:4:\"true\";s:22:\"read_expense_monthwise\";s:4:\"true\";s:20:\"read_expense_summary\";s:4:\"true\";s:18:\"read_holding_order\";s:4:\"true\";s:17:\"read_sell_invoice\";s:4:\"true\";s:14:\"read_sell_list\";s:4:\"true\";s:19:\"create_sell_invoice\";s:4:\"true\";s:24:\"update_sell_invoice_info\";s:4:\"true\";s:19:\"delete_sell_invoice\";s:4:\"true\";s:12:\"sell_payment\";s:4:\"true\";s:15:\"create_sell_due\";s:4:\"true\";s:18:\"create_sell_return\";s:4:\"true\";s:16:\"read_sell_return\";s:4:\"true\";s:18:\"update_sell_return\";s:4:\"true\";s:18:\"delete_sell_return\";s:4:\"true\";s:16:\"sms_sell_invoice\";s:4:\"true\";s:18:\"email_sell_invoice\";s:4:\"true\";s:13:\"read_sell_log\";s:4:\"true\";s:23:\"create_purchase_invoice\";s:4:\"true\";s:18:\"read_purchase_list\";s:4:\"true\";s:28:\"update_purchase_invoice_info\";s:4:\"true\";s:23:\"delete_purchase_invoice\";s:4:\"true\";s:16:\"purchase_payment\";s:4:\"true\";s:19:\"create_purchase_due\";s:4:\"true\";s:22:\"create_purchase_return\";s:4:\"true\";s:20:\"read_purchase_return\";s:4:\"true\";s:22:\"update_purchase_return\";s:4:\"true\";s:22:\"delete_purchase_return\";s:4:\"true\";s:17:\"read_purchase_log\";s:4:\"true\";s:13:\"read_transfer\";s:4:\"true\";s:12:\"add_transfer\";s:4:\"true\";s:15:\"update_transfer\";s:4:\"true\";s:13:\"read_giftcard\";s:4:\"true\";s:12:\"add_giftcard\";s:4:\"true\";s:15:\"update_giftcard\";s:4:\"true\";s:15:\"delete_giftcard\";s:4:\"true\";s:14:\"giftcard_topup\";s:4:\"true\";s:19:\"read_giftcard_topup\";s:4:\"true\";s:21:\"delete_giftcard_topup\";s:4:\"true\";s:12:\"read_product\";s:4:\"true\";s:14:\"create_product\";s:4:\"true\";s:14:\"update_product\";s:4:\"true\";s:14:\"delete_product\";s:4:\"true\";s:14:\"import_product\";s:4:\"true\";s:19:\"product_bulk_action\";s:4:\"true\";s:18:\"delete_all_product\";s:4:\"true\";s:13:\"read_category\";s:4:\"true\";s:15:\"create_category\";s:4:\"true\";s:15:\"update_category\";s:4:\"true\";s:15:\"delete_category\";s:4:\"true\";s:16:\"read_stock_alert\";s:4:\"true\";s:20:\"read_expired_product\";s:4:\"true\";s:13:\"barcode_print\";s:4:\"true\";s:19:\"restore_all_product\";s:4:\"true\";s:13:\"read_supplier\";s:4:\"true\";s:15:\"create_supplier\";s:4:\"true\";s:15:\"update_supplier\";s:4:\"true\";s:15:\"delete_supplier\";s:4:\"true\";s:21:\"read_supplier_profile\";s:4:\"true\";s:10:\"read_brand\";s:4:\"true\";s:12:\"create_brand\";s:4:\"true\";s:12:\"update_brand\";s:4:\"true\";s:12:\"delete_brand\";s:4:\"true\";s:18:\"read_brand_profile\";s:4:\"true\";s:8:\"read_box\";s:4:\"true\";s:10:\"create_box\";s:4:\"true\";s:10:\"update_box\";s:4:\"true\";s:10:\"delete_box\";s:4:\"true\";s:9:\"read_unit\";s:4:\"true\";s:11:\"create_unit\";s:4:\"true\";s:11:\"update_unit\";s:4:\"true\";s:11:\"delete_unit\";s:4:\"true\";s:12:\"read_taxrate\";s:4:\"true\";s:14:\"create_taxrate\";s:4:\"true\";s:14:\"update_taxrate\";s:4:\"true\";s:14:\"delete_taxrate\";s:4:\"true\";s:9:\"read_loan\";s:4:\"true\";s:17:\"read_loan_summary\";s:4:\"true\";s:9:\"take_loan\";s:4:\"true\";s:11:\"update_loan\";s:4:\"true\";s:11:\"delete_loan\";s:4:\"true\";s:8:\"loan_pay\";s:4:\"true\";s:13:\"read_customer\";s:4:\"true\";s:21:\"read_customer_profile\";s:4:\"true\";s:15:\"create_customer\";s:4:\"true\";s:15:\"update_customer\";s:4:\"true\";s:15:\"delete_customer\";s:4:\"true\";s:20:\"add_customer_balance\";s:4:\"true\";s:26:\"substract_customer_balance\";s:4:\"true\";s:25:\"read_customer_transaction\";s:4:\"true\";s:9:\"read_user\";s:4:\"true\";s:11:\"create_user\";s:4:\"true\";s:11:\"update_user\";s:4:\"true\";s:11:\"delete_user\";s:4:\"true\";s:15:\"change_password\";s:4:\"true\";s:14:\"read_usergroup\";s:4:\"true\";s:16:\"create_usergroup\";s:4:\"true\";s:16:\"update_usergroup\";s:4:\"true\";s:16:\"delete_usergroup\";s:4:\"true\";s:13:\"read_currency\";s:4:\"true\";s:15:\"create_currency\";s:4:\"true\";s:15:\"update_currency\";s:4:\"true\";s:15:\"change_currency\";s:4:\"true\";s:15:\"delete_currency\";s:4:\"true\";s:16:\"read_filemanager\";s:4:\"true\";s:12:\"read_pmethod\";s:4:\"true\";s:14:\"create_pmethod\";s:4:\"true\";s:14:\"update_pmethod\";s:4:\"true\";s:14:\"delete_pmethod\";s:4:\"true\";s:22:\"updadte_pmethod_status\";s:4:\"true\";s:10:\"read_store\";s:4:\"true\";s:12:\"create_store\";s:4:\"true\";s:12:\"update_store\";s:4:\"true\";s:12:\"delete_store\";s:4:\"true\";s:14:\"activate_store\";s:4:\"true\";s:14:\"upload_favicon\";s:4:\"true\";s:11:\"upload_logo\";s:4:\"true\";s:12:\"read_printer\";s:4:\"true\";s:14:\"create_printer\";s:4:\"true\";s:14:\"update_printer\";s:4:\"true\";s:14:\"delete_printer\";s:4:\"true\";s:10:\"send_email\";s:4:\"true\";s:13:\"read_language\";s:4:\"true\";s:15:\"create_language\";s:4:\"true\";s:15:\"update_language\";s:4:\"true\";s:15:\"delete_language\";s:4:\"true\";s:20:\"language_translation\";s:4:\"true\";s:19:\"delete_language_key\";s:4:\"true\";s:16:\"receipt_template\";s:4:\"true\";s:20:\"read_user_preference\";s:4:\"true\";s:22:\"update_user_preference\";s:4:\"true\";s:9:\"filtering\";s:4:\"true\";s:13:\"language_sync\";s:4:\"true\";s:6:\"backup\";s:4:\"true\";s:7:\"restore\";s:4:\"true\";s:5:\"reset\";s:4:\"true\";s:19:\"show_purchase_price\";s:4:\"true\";s:11:\"show_profit\";s:4:\"true\";s:10:\"show_graph\";s:4:\"true\";}}');

-- --------------------------------------------------------

--
-- Table structure for table `user_to_store`
--

CREATE TABLE `user_to_store` (
  `u2s_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `store_id` int(11) NOT NULL DEFAULT 1,
  `status` tinyint(4) NOT NULL DEFAULT 1,
  `sort_order` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `user_to_store`
--

INSERT INTO `user_to_store` (`u2s_id`, `user_id`, `store_id`, `status`, `sort_order`) VALUES
(2, 2, 1, 1, 2),
(3, 3, 1, 1, 3),
(4, 2, 2, 1, 0),
(7, 2, 3, 1, 0),
(10, 2, 4, 1, 0),
(13, 2, 5, 1, 0),
(16, 4, 5, 1, 0),
(17, 2, 6, 1, 0),
(20, 2, 7, 1, 0),
(23, 5, 7, 1, 3),
(24, 1, 1, 1, 0),
(25, 1, 2, 1, 1),
(26, 1, 3, 1, 0),
(27, 1, 4, 1, 0),
(28, 1, 5, 1, 0),
(29, 1, 6, 1, 0),
(30, 1, 7, 1, 0),
(31, 6, 1, 1, 0),
(32, 6, 2, 1, 1),
(33, 6, 3, 1, 0),
(34, 6, 4, 1, 0),
(35, 6, 5, 1, 0),
(36, 6, 6, 1, 0),
(37, 6, 7, 1, 0);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `company_customer`
--
ALTER TABLE `company_customer`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `currency`
--
ALTER TABLE `currency`
  ADD PRIMARY KEY (`currency_id`);

--
-- Indexes for table `languages`
--
ALTER TABLE `languages`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `language_translations`
--
ALTER TABLE `language_translations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `login_logs`
--
ALTER TABLE `login_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `settings`
--
ALTER TABLE `settings`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `subscription_plans`
--
ALTER TABLE `subscription_plans`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD KEY `group_id` (`group_id`);

--
-- Indexes for table `user_group`
--
ALTER TABLE `user_group`
  ADD PRIMARY KEY (`group_id`),
  ADD UNIQUE KEY `slug` (`slug`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `user_to_store`
--
ALTER TABLE `user_to_store`
  ADD PRIMARY KEY (`u2s_id`),
  ADD KEY `user_id` (`user_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `company_customer`
--
ALTER TABLE `company_customer`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=117;

--
-- AUTO_INCREMENT for table `currency`
--
ALTER TABLE `currency`
  MODIFY `currency_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT for table `language_translations`
--
ALTER TABLE `language_translations`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12968;

--
-- AUTO_INCREMENT for table `login_logs`
--
ALTER TABLE `login_logs`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1399;

--
-- AUTO_INCREMENT for table `settings`
--
ALTER TABLE `settings`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `subscription_plans`
--
ALTER TABLE `subscription_plans`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=124;

--
-- AUTO_INCREMENT for table `user_group`
--
ALTER TABLE `user_group`
  MODIFY `group_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `user_to_store`
--
ALTER TABLE `user_to_store`
  MODIFY `u2s_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=38;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
