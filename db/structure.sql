-- MySQL dump 10.13  Distrib 5.5.28, for osx10.6 (i386)
--
-- Host: localhost    Database: madbooker_development
-- ------------------------------------------------------
-- Server version	5.5.28

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `add_ons`
--

DROP TABLE IF EXISTS `add_ons`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `add_ons` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `hotel_id` int(11) DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `description` text COLLATE utf8_unicode_ci,
  `price` decimal(15,4) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `active` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `bookings`
--

DROP TABLE IF EXISTS `bookings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `bookings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `hotel_id` int(11) DEFAULT NULL,
  `customer_id` int(11) DEFAULT NULL,
  `bookable_id` int(11) DEFAULT NULL,
  `arrive` date DEFAULT NULL,
  `depart` date DEFAULT NULL,
  `rate` decimal(15,4) DEFAULT NULL,
  `discounted_rate` decimal(15,4) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `first_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `last_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `made_by_first_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `made_by_last_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `email` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `email_confirmation` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `sms_confirmation` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `encrypted_cc_number` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `cc_month` int(11) DEFAULT NULL,
  `cc_year` int(11) DEFAULT NULL,
  `encrypted_cc_cvv` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `cc_zipcode` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `guid` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `state` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `bookable_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `paid` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `bundles`
--

DROP TABLE IF EXISTS `bundles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `bundles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `package_id` int(11) DEFAULT NULL,
  `add_on_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `currencies`
--

DROP TABLE IF EXISTS `currencies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `currencies` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `html_symbol` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1000 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `hotels`
--

DROP TABLE IF EXISTS `hotels`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `hotels` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `owner_id` int(11) DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `url` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `phone` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `fax` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `room_rates_display` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `subdomain` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `address` text COLLATE utf8_unicode_ci,
  `google_analytics_code` text COLLATE utf8_unicode_ci,
  `fine_print` text COLLATE utf8_unicode_ci,
  `logo_file_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `logo_content_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `logo_file_size` int(11) DEFAULT NULL,
  `logo_updated_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `time_zone` varchar(255) COLLATE utf8_unicode_ci DEFAULT 'Eastern Time (US & Canada)',
  `minimal_inventory_notification_threshold` int(11) DEFAULT '0',
  `currency_id` int(11) DEFAULT '840',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `inventories`
--

DROP TABLE IF EXISTS `inventories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `inventories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `hotel_id` int(11) DEFAULT NULL,
  `room_type_id` int(11) DEFAULT NULL,
  `available_rooms` int(11) DEFAULT NULL,
  `rate` decimal(15,4) DEFAULT NULL,
  `discounted_rate` decimal(15,4) DEFAULT NULL,
  `date` date DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `sales_count` int(11) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2024 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `memberships`
--

DROP TABLE IF EXISTS `memberships`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `memberships` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `hotel_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `email` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `packages`
--

DROP TABLE IF EXISTS `packages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `packages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `hotel_id` int(11) DEFAULT NULL,
  `room_type_id` int(11) DEFAULT NULL,
  `additional_price` decimal(15,4) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `active` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `room_types`
--

DROP TABLE IF EXISTS `room_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `room_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `hotel_id` int(11) DEFAULT NULL,
  `number_of_rooms` int(11) DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `default_rate` decimal(15,4) DEFAULT NULL,
  `discounted_rate` decimal(15,4) DEFAULT NULL,
  `description` text COLLATE utf8_unicode_ci,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sales`
--

DROP TABLE IF EXISTS `sales`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sales` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `inventory_id` int(11) DEFAULT NULL,
  `booking_id` int(11) DEFAULT NULL,
  `hotel_id` int(11) DEFAULT NULL,
  `rate` decimal(15,4) DEFAULT NULL,
  `discounted_rate` decimal(15,4) DEFAULT NULL,
  `date` date DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `price` decimal(15,4) DEFAULT NULL,
  `state` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `device_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_sales_on_inventory_id` (`inventory_id`),
  KEY `index_sales_on_booking_id` (`booking_id`),
  KEY `index_sales_on_hotel_id` (`hotel_id`),
  KEY `index_sales_on_state` (`state`),
  KEY `index_sales_on_device_type` (`device_type`)
) ENGINE=InnoDB AUTO_INCREMENT=83 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `schema_migrations`
--

DROP TABLE IF EXISTS `schema_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `schema_migrations` (
  `version` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  UNIQUE KEY `unique_schema_migrations` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `stats`
--

DROP TABLE IF EXISTS `stats`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `stats` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `hotel_id` int(11) DEFAULT NULL,
  `start` date DEFAULT NULL,
  `end` date DEFAULT NULL,
  `user_bug` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `kind` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `url` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `subdomain` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `data` text COLLATE utf8_unicode_ci,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `device_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_stats_on_hotel_id` (`hotel_id`),
  KEY `index_stats_on_subdomain` (`subdomain`),
  KEY `index_stats_on_user_bug` (`user_bug`),
  KEY `index_stats_on_url` (`url`),
  KEY `index_stats_on_start_and_end` (`start`,`end`),
  KEY `index_stats_on_start` (`start`),
  KEY `index_stats_on_end` (`end`),
  KEY `index_stats_on_created_at` (`created_at`),
  KEY `index_stats_on_kind` (`kind`),
  KEY `deveice_type` (`device_type`)
) ENGINE=InnoDB AUTO_INCREMENT=176 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `encrypted_password` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `reset_password_token` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `reset_password_sent_at` datetime DEFAULT NULL,
  `remember_created_at` datetime DEFAULT NULL,
  `sign_in_count` int(11) DEFAULT '0',
  `current_sign_in_at` datetime DEFAULT NULL,
  `last_sign_in_at` datetime DEFAULT NULL,
  `current_sign_in_ip` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `last_sign_in_ip` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `time_zone` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `stripe_customer_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `payment_status` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_users_on_email` (`email`),
  UNIQUE KEY `index_users_on_reset_password_token` (`reset_password_token`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2013-08-09 14:22:50
INSERT INTO schema_migrations (version) VALUES ('20130608220721');

INSERT INTO schema_migrations (version) VALUES ('20130609135803');

INSERT INTO schema_migrations (version) VALUES ('20130609152456');

INSERT INTO schema_migrations (version) VALUES ('20130609195058');

INSERT INTO schema_migrations (version) VALUES ('20130610201041');

INSERT INTO schema_migrations (version) VALUES ('20130616153625');

INSERT INTO schema_migrations (version) VALUES ('20130616212107');

INSERT INTO schema_migrations (version) VALUES ('20130619201801');

INSERT INTO schema_migrations (version) VALUES ('20130620150846');

INSERT INTO schema_migrations (version) VALUES ('20130626142043');

INSERT INTO schema_migrations (version) VALUES ('20130627232217');

INSERT INTO schema_migrations (version) VALUES ('20130701190234');

INSERT INTO schema_migrations (version) VALUES ('20130702051013');

INSERT INTO schema_migrations (version) VALUES ('20130703183215');

INSERT INTO schema_migrations (version) VALUES ('20130705131931');

INSERT INTO schema_migrations (version) VALUES ('20130705135449');

INSERT INTO schema_migrations (version) VALUES ('20130705140244');

INSERT INTO schema_migrations (version) VALUES ('20130705142901');

INSERT INTO schema_migrations (version) VALUES ('20130705190217');

INSERT INTO schema_migrations (version) VALUES ('20130705204359');

INSERT INTO schema_migrations (version) VALUES ('20130708142835');

INSERT INTO schema_migrations (version) VALUES ('20130708153109');

INSERT INTO schema_migrations (version) VALUES ('20130708201024');

INSERT INTO schema_migrations (version) VALUES ('20130716205035');

INSERT INTO schema_migrations (version) VALUES ('20130718145554');

INSERT INTO schema_migrations (version) VALUES ('20130718171147');

INSERT INTO schema_migrations (version) VALUES ('20130718190102');

INSERT INTO schema_migrations (version) VALUES ('20130718201419');

INSERT INTO schema_migrations (version) VALUES ('20130722223428');

INSERT INTO schema_migrations (version) VALUES ('20130724153638');

INSERT INTO schema_migrations (version) VALUES ('20130724181819');

INSERT INTO schema_migrations (version) VALUES ('20130725123319');

INSERT INTO schema_migrations (version) VALUES ('20130725143101');

INSERT INTO schema_migrations (version) VALUES ('20130726160142');

INSERT INTO schema_migrations (version) VALUES ('20130806120313');

INSERT INTO schema_migrations (version) VALUES ('20130809175840');

INSERT INTO schema_migrations (version) VALUES ('20130809181051');
