-- phpMyAdmin SQL Dump
-- version 4.9.5deb2
-- https://www.phpmyadmin.net/
--
-- Servidor: localhost:3306
-- Tiempo de generación: 21-10-2020 a las 08:41:28
-- Versión del servidor: 8.0.21-0ubuntu0.20.04.4
-- Versión de PHP: 7.4.3

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `my_videos`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `categories`
--

CREATE TABLE `categories` (
  `id` int NOT NULL,
  `parent_id` int DEFAULT NULL,
  `name` varchar(45) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `categories`
--

INSERT INTO `categories` (`id`, `parent_id`, `name`) VALUES
(1, NULL, 'Electronics'),
(2, NULL, 'Toys'),
(3, NULL, 'Books'),
(4, NULL, 'Movies'),
(5, 1, 'Cameras'),
(6, 1, 'Computers'),
(7, 1, 'Cell Phones'),
(8, 6, 'Laptops'),
(9, 6, 'Desktops'),
(10, 8, 'Apple'),
(11, 8, 'Asus'),
(12, 8, 'Dell'),
(13, 8, 'Lenovo'),
(14, 8, 'HP'),
(15, 3, 'Children\'s Books'),
(16, 3, 'Kindle eBooks'),
(17, 4, 'Family'),
(18, 4, 'Romance'),
(19, 18, 'Romantic Comedy'),
(20, 18, 'Romantic Drama');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `comments`
--

CREATE TABLE `comments` (
  `id` int NOT NULL,
  `user_id` int NOT NULL,
  `video_id` int NOT NULL,
  `content` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `comments`
--

INSERT INTO `comments` (`id`, `user_id`, `video_id`, `content`, `created_at`) VALUES
(1, 1, 5, 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.', '2020-10-08 12:34:45'),
(2, 1, 5, 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.', '2020-10-08 12:34:45'),
(3, 1, 5, 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.', '2020-10-08 12:34:45'),
(4, 1, 5, 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.', '2020-10-08 12:34:45'),
(5, 1, 5, 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.', '2020-10-08 12:34:45'),
(6, 1, 5, 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.', '2020-10-08 12:34:45');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `dislikes`
--

CREATE TABLE `dislikes` (
  `video_id` int NOT NULL,
  `user_id` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `doctrine_migration_versions`
--

CREATE TABLE `doctrine_migration_versions` (
  `version` varchar(191) COLLATE utf8_unicode_ci NOT NULL,
  `executed_at` datetime DEFAULT NULL,
  `execution_time` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Volcado de datos para la tabla `doctrine_migration_versions`
--

INSERT INTO `doctrine_migration_versions` (`version`, `executed_at`, `execution_time`) VALUES
('DoctrineMigrations\\Version20200921191953', '2020-09-21 21:19:54', 11559);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `likes`
--

CREATE TABLE `likes` (
  `video_id` int NOT NULL,
  `user_id` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `subscriptions`
--

CREATE TABLE `subscriptions` (
  `id` int NOT NULL,
  `plan` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `valid_to` datetime NOT NULL,
  `payment_status` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `free_plan_used` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `subscriptions`
--

INSERT INTO `subscriptions` (`id`, `plan`, `valid_to`, `payment_status`, `free_plan_used`) VALUES
(1, 'enterprise', '2020-09-26 01:20:07', 'paid', 0),
(2, 'enterprise', '2120-09-21 21:20:07', 'paid', 0),
(3, 'enterprise', '2120-09-21 21:20:07', 'paid', 0);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `users`
--

CREATE TABLE `users` (
  `id` int NOT NULL,
  `subscription_id` int DEFAULT NULL,
  `email` varchar(180) COLLATE utf8mb4_unicode_ci NOT NULL,
  `roles` json NOT NULL,
  `password` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(45) COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_name` varchar(45) COLLATE utf8mb4_unicode_ci NOT NULL,
  `vimeo_api_key` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `users`
--

INSERT INTO `users` (`id`, `subscription_id`, `email`, `roles`, `password`, `name`, `last_name`, `vimeo_api_key`) VALUES
(1, 3, 'jm@symf5.loc', '[\"ROLE_ADMIN\"]', '$argon2id$v=19$m=65536,t=4,p=1$32N6z3fyBT3fyrPktWFUIg$j/uioCTTp3lbRMjGeezNia9dh3wELToPBAx50OY3FIw', 'John', 'Malkovich', 'dsLWELdsm'),
(2, NULL, 'ar@symf5.loc', '[\"ROLE_ADMIN\"]', '$argon2id$v=19$m=65536,t=4,p=1$uYQ8BEZqEBOHhZYHHNEt0Q$pl64XCxRnrx/1bts+i92O+B71uJswvPvVUVdlnzYTNA', 'Alex', 'Ramstehd', 'dsLWELdsm'),
(3, 1, 'mg@symf5.loc', '[\"ROLE_USER\"]', '$argon2id$v=19$m=65536,t=4,p=1$AvrBF0sa5B7lAzil3+TwGA$Oa2ZGYv3SRsHq12Q8tPle/ZH76kl0DYVWasmBjRg9ps', 'Mika', 'Goldben', 'dsLWELdsm'),
(4, NULL, 'tb@symf5.loc', '[\"ROLE_USER\"]', '$argon2id$v=19$m=65536,t=4,p=1$itnM/VY0TnCc/8l9Z1or9w$34Ijuj9/OVTVhXZC3SMXi3+kuIQHXt+vUofrzktE+lQ', 'Ted', 'Bundy', 'dsLWELdsm');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `videos`
--

CREATE TABLE `videos` (
  `id` int NOT NULL,
  `category_id` int DEFAULT NULL,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `path` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `duration` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `videos`
--

INSERT INTO `videos` (`id`, `category_id`, `title`, `path`, `duration`) VALUES
(1, 4, 'Movies 1', 'https://player.vimeo.com/video/289729765', 207),
(2, 4, 'Movies 2', 'https://player.vimeo.com/video/238902809', 231),
(3, 4, 'Movies 3', 'https://player.vimeo.com/video/150870038', 133),
(4, 4, 'Movies 4', 'https://player.vimeo.com/video/219727723', 49),
(5, 4, 'Movies 5', 'https://player.vimeo.com/video/289879647', 48),
(6, 4, 'Movies 6', 'https://player.vimeo.com/video/261379936', 229),
(7, 4, 'Movies 7', 'https://player.vimeo.com/video/289029793', 131),
(8, 4, 'Movies 8', 'https://player.vimeo.com/video/60594348', 232),
(9, 4, 'Movies 9', 'https://player.vimeo.com/video/290253648', 124),
(10, 17, 'Family 1', 'https://player.vimeo.com/video/289729765', 189),
(11, 17, 'Family 2', 'https://player.vimeo.com/video/289729765', 123),
(12, 17, 'Family 3', 'https://player.vimeo.com/video/289729765', 286),
(13, 19, 'Romantic comedy 1', 'https://player.vimeo.com/video/289729765', 105),
(14, 19, 'Romantic comedy 2', 'https://player.vimeo.com/video/289729765', 244),
(15, 20, 'Romantic drama 1', 'https://player.vimeo.com/video/289729765', 74),
(16, 2, 'Toys  1', 'https://player.vimeo.com/video/289729765', 58),
(17, 2, 'Toys  2', 'https://player.vimeo.com/video/289729765', 109),
(18, 2, 'Toys  3', 'https://player.vimeo.com/video/289729765', 125),
(19, 2, 'Toys  4', 'https://player.vimeo.com/video/289729765', 257),
(20, 2, 'Toys  5', 'https://player.vimeo.com/video/289729765', 105),
(21, 2, 'Toys  6', 'https://player.vimeo.com/video/289729765', 152);

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `UNIQ_3AF346685E237E06` (`name`),
  ADD KEY `IDX_3AF34668727ACA70` (`parent_id`);

--
-- Indices de la tabla `comments`
--
ALTER TABLE `comments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `IDX_5F9E962AA76ED395` (`user_id`),
  ADD KEY `IDX_5F9E962A29C1004E` (`video_id`);

--
-- Indices de la tabla `dislikes`
--
ALTER TABLE `dislikes`
  ADD PRIMARY KEY (`video_id`,`user_id`),
  ADD KEY `IDX_2DF3BE1129C1004E` (`video_id`),
  ADD KEY `IDX_2DF3BE11A76ED395` (`user_id`);

--
-- Indices de la tabla `doctrine_migration_versions`
--
ALTER TABLE `doctrine_migration_versions`
  ADD PRIMARY KEY (`version`);

--
-- Indices de la tabla `likes`
--
ALTER TABLE `likes`
  ADD PRIMARY KEY (`video_id`,`user_id`),
  ADD KEY `IDX_49CA4E7D29C1004E` (`video_id`),
  ADD KEY `IDX_49CA4E7DA76ED395` (`user_id`);

--
-- Indices de la tabla `subscriptions`
--
ALTER TABLE `subscriptions`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `UNIQ_1483A5E9E7927C74` (`email`),
  ADD UNIQUE KEY `UNIQ_1483A5E99A1887DC` (`subscription_id`);

--
-- Indices de la tabla `videos`
--
ALTER TABLE `videos`
  ADD PRIMARY KEY (`id`),
  ADD KEY `IDX_29AA643212469DE2` (`category_id`),
  ADD KEY `title_idx` (`title`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `categories`
--
ALTER TABLE `categories`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT de la tabla `comments`
--
ALTER TABLE `comments`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `subscriptions`
--
ALTER TABLE `subscriptions`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `users`
--
ALTER TABLE `users`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `videos`
--
ALTER TABLE `videos`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `categories`
--
ALTER TABLE `categories`
  ADD CONSTRAINT `FK_3AF34668727ACA70` FOREIGN KEY (`parent_id`) REFERENCES `categories` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `comments`
--
ALTER TABLE `comments`
  ADD CONSTRAINT `FK_5F9E962A29C1004E` FOREIGN KEY (`video_id`) REFERENCES `videos` (`id`),
  ADD CONSTRAINT `FK_5F9E962AA76ED395` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Filtros para la tabla `dislikes`
--
ALTER TABLE `dislikes`
  ADD CONSTRAINT `FK_2DF3BE1129C1004E` FOREIGN KEY (`video_id`) REFERENCES `videos` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `FK_2DF3BE11A76ED395` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `likes`
--
ALTER TABLE `likes`
  ADD CONSTRAINT `FK_49CA4E7D29C1004E` FOREIGN KEY (`video_id`) REFERENCES `videos` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `FK_49CA4E7DA76ED395` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `FK_1483A5E99A1887DC` FOREIGN KEY (`subscription_id`) REFERENCES `subscriptions` (`id`);

--
-- Filtros para la tabla `videos`
--
ALTER TABLE `videos`
  ADD CONSTRAINT `FK_29AA643212469DE2` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
