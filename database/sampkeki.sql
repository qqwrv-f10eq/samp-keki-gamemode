-- phpMyAdmin SQL Dump
-- version 4.9.2
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jul 08, 2020 at 10:38 PM
-- Server version: 10.4.11-MariaDB
-- PHP Version: 7.2.26

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `sampkeki`
--
CREATE DATABASE IF NOT EXISTS `sampkeki` DEFAULT CHARACTER SET tis620 COLLATE tis620_thai_ci;
USE `sampkeki`;

-- --------------------------------------------------------

--
-- Table structure for table `entrance`
--

DROP TABLE IF EXISTS `entrance`;
CREATE TABLE `entrance` (
  `id` int(11) NOT NULL,
  `name` varchar(60) NOT NULL,
  `extX` float NOT NULL,
  `extY` float NOT NULL,
  `extZ` float NOT NULL,
  `extA` float NOT NULL,
  `extInterior` int(11) NOT NULL,
  `extWorld` int(11) NOT NULL,
  `intX` float NOT NULL,
  `intY` float NOT NULL,
  `intZ` float NOT NULL,
  `intA` float NOT NULL,
  `Interior` int(11) NOT NULL,
  `World` int(11) NOT NULL,
  `intPickup` int(11) NOT NULL DEFAULT 0,
  `extPickup` int(11) NOT NULL DEFAULT 0,
  `extName` varchar(60) NOT NULL,
  `intName` varchar(60) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `faction`
--

DROP TABLE IF EXISTS `faction`;
CREATE TABLE `faction` (
  `id` int(11) NOT NULL,
  `name` varchar(60) NOT NULL,
  `short_name` varchar(15) NOT NULL,
  `type` int(11) NOT NULL,
  `color` int(11) NOT NULL,
  `spawnX` float NOT NULL,
  `spawnY` float NOT NULL,
  `spawnZ` float NOT NULL,
  `spawnA` float NOT NULL,
  `spawnInt` int(11) NOT NULL,
  `spawnWorld` int(11) NOT NULL,
  `cash` int(11) NOT NULL DEFAULT 0,
  `max_skin` int(11) NOT NULL DEFAULT 0,
  `max_rank` int(11) NOT NULL DEFAULT 5,
  `max_veh` int(11) NOT NULL DEFAULT 0,
  `rank0` varchar(30) NOT NULL,
  `rank1` varchar(30) NOT NULL,
  `rank2` varchar(30) NOT NULL,
  `rank3` varchar(30) NOT NULL,
  `rank4` varchar(30) NOT NULL,
  `rank5` varchar(30) NOT NULL,
  `rank6` varchar(30) NOT NULL,
  `rank7` varchar(30) NOT NULL,
  `rank8` varchar(30) NOT NULL,
  `rank9` varchar(30) NOT NULL,
  `rank10` varchar(30) NOT NULL,
  `rank11` varchar(30) NOT NULL,
  `rank12` varchar(30) NOT NULL,
  `rank13` varchar(30) NOT NULL,
  `rank14` varchar(30) NOT NULL,
  `rank15` varchar(30) NOT NULL,
  `rank16` varchar(30) NOT NULL,
  `rank17` varchar(30) NOT NULL,
  `rank18` varchar(30) NOT NULL,
  `rank19` varchar(30) NOT NULL,
  `rank20` varchar(30) NOT NULL,
  `skin1` int(11) NOT NULL,
  `skin2` int(11) NOT NULL,
  `skin3` int(11) NOT NULL,
  `skin4` int(11) NOT NULL,
  `skin5` int(11) NOT NULL,
  `skin6` int(11) NOT NULL,
  `skin7` int(11) NOT NULL,
  `skin8` int(11) NOT NULL,
  `skin9` int(11) NOT NULL,
  `skin10` int(11) NOT NULL,
  `skin11` int(11) NOT NULL,
  `skin12` int(11) NOT NULL,
  `skin13` int(11) NOT NULL,
  `skin14` int(11) NOT NULL,
  `skin15` int(11) NOT NULL,
  `skin16` int(11) NOT NULL,
  `skin17` int(11) NOT NULL,
  `skin18` int(11) NOT NULL,
  `skin19` int(11) NOT NULL,
  `skin20` int(11) NOT NULL,
  `weapon1` int(11) NOT NULL,
  `weapon2` int(11) NOT NULL,
  `weapon3` int(11) NOT NULL,
  `weapon4` int(11) NOT NULL,
  `weapon5` int(11) NOT NULL,
  `weapon6` int(11) NOT NULL,
  `weapon7` int(11) NOT NULL,
  `weapon8` int(11) NOT NULL,
  `weapon9` int(11) NOT NULL,
  `weapon10` int(11) NOT NULL,
  `ammo1` int(11) NOT NULL,
  `ammo2` int(11) NOT NULL,
  `ammo3` int(11) NOT NULL,
  `ammo4` int(11) NOT NULL,
  `ammo5` int(11) NOT NULL,
  `ammo6` int(11) NOT NULL,
  `ammo7` int(11) NOT NULL,
  `ammo8` int(11) NOT NULL,
  `ammo9` int(11) NOT NULL,
  `ammo10` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `players`
--

DROP TABLE IF EXISTS `players`;
CREATE TABLE `players` (
  `id` int(11) NOT NULL,
  `name` varchar(24) NOT NULL,
  `pass` varchar(129) NOT NULL,
  `phonenumber` int(11) NOT NULL DEFAULT 0,
  `level` int(11) NOT NULL DEFAULT 1,
  `model` int(11) NOT NULL DEFAULT 264,
  `cash` int(11) NOT NULL DEFAULT 0,
  `donaterank` int(11) NOT NULL DEFAULT 0,
  `armour` float DEFAULT 0,
  `health` float NOT NULL DEFAULT 0,
  `shealth` float NOT NULL DEFAULT 0,
  `interior` int(11) NOT NULL DEFAULT 0,
  `vworld` int(11) NOT NULL DEFAULT 0,
  `spawntype` int(11) NOT NULL DEFAULT 0,
  `medicbill` int(11) NOT NULL DEFAULT 0,
  `posx` float NOT NULL DEFAULT 0,
  `posy` float NOT NULL DEFAULT 0,
  `posz` float NOT NULL DEFAULT 0,
  `posa` float NOT NULL DEFAULT 0,
  `admin` int(11) NOT NULL DEFAULT 0,
  `last_login` int(11) NOT NULL DEFAULT 0,
  `last_ip` varchar(16) NOT NULL DEFAULT '0',
  `created` int(11) NOT NULL DEFAULT 0,
  `faction` int(11) NOT NULL DEFAULT 0,
  `faction_rank` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `players`
--

INSERT INTO `players` (`id`, `name`, `pass`, `phonenumber`, `level`, `model`, `cash`, `donaterank`, `armour`, `health`, `shealth`, `interior`, `vworld`, `spawntype`, `medicbill`, `posx`, `posy`, `posz`, `posa`, `admin`, `last_login`, `last_ip`, `created`, `faction`, `faction_rank`) VALUES
(7, 'Sarah_Candy', '192A9B0C5BD4BD019557A710025953525F60692C07F99E18F3AB82EB707D65C0EB8F1564AE8D315D378D7019B6E42FE906FBFD6C11E9B8F1330EC44C398F72D5', 0, 0, 264, 0, 0, 0, 50, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0', 0, 0, 0),
(8, 'srysgag', 'BA45AFD0E7AE99D6C30975F8DB213BEEAEC23F27F6845F666A8702AE265A6091297FFEB7083654F6C454C72303539624492F8AC0125CA266549E3BA7EA7FE50C', 0, 0, 264, 5000, 0, 0, 50, 0, 0, 0, 2, 0, 0, 0, 0, 0, 6, 0, '0', 0, 0, 1);

-- --------------------------------------------------------

--
-- Table structure for table `vehicle`
--

DROP TABLE IF EXISTS `vehicle`;
CREATE TABLE `vehicle` (
  `vehicleID` int(11) NOT NULL,
  `vehicleModelID` int(11) NOT NULL DEFAULT 0,
  `vehiclePosX` varchar(255) NOT NULL DEFAULT '0',
  `vehiclePosY` varchar(255) NOT NULL DEFAULT '0',
  `vehiclePosZ` varchar(255) NOT NULL DEFAULT '0',
  `vehiclePosRotation` varchar(255) NOT NULL DEFAULT '0',
  `vehicleFaction` int(12) NOT NULL DEFAULT 0,
  `vehicleCol1` int(4) NOT NULL DEFAULT -1,
  `vehicleCol2` int(4) NOT NULL DEFAULT -1,
  `vehicleWorld` int(11) NOT NULL DEFAULT 0,
  `vehicleInterior` int(11) NOT NULL DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `entrance`
--
ALTER TABLE `entrance`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `faction`
--
ALTER TABLE `faction`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `players`
--
ALTER TABLE `players`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `vehicle`
--
ALTER TABLE `vehicle`
  ADD PRIMARY KEY (`vehicleID`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `entrance`
--
ALTER TABLE `entrance`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `faction`
--
ALTER TABLE `faction`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `players`
--
ALTER TABLE `players`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `vehicle`
--
ALTER TABLE `vehicle`
  MODIFY `vehicleID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
