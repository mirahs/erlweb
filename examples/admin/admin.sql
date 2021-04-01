-- phpMyAdmin SQL Dump
-- version 4.5.2
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: 2018-07-03 17:51:08
-- 服务器版本： 5.7.14
-- PHP Version: 7.0.9

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `admin`
--

-- ----------------------------
-- Table structure for adm_user
-- ----------------------------
DROP TABLE IF EXISTS `adm_user`;
CREATE TABLE IF NOT EXISTS `adm_user` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `account` varchar(32) NOT NULL COMMENT '帐号',
  `password` char(32) NOT NULL COMMENT '密码',
  `type` tinyint(3) unsigned NOT NULL COMMENT '类型 10:管理员|20:游客',

  `is_locked` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '是否被锁住 0:否|1:是',
  `remark` text NOT NULL COMMENT '备注',

  `login_times` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '登录次数',
  `login_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '登录时间',
  `login_ip` char(15) NOT NULL DEFAULT '' COMMENT '登录IP',
  PRIMARY KEY (`id`),
  UNIQUE KEY `account` (`account`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='后台账号';

-- ----------------------------
-- Records of adm_user
-- ----------------------------
INSERT INTO `adm_user` (`id`, `account`, `password`, `type`, `remark`) VALUES
(1, 'admin', 'c3284d0f94606de1fd2af172aba15bf3', 10, 'admin');

-- ----------------------------
-- Table structure for log_adm_user_login
-- ----------------------------
DROP TABLE IF EXISTS `log_adm_user_login`;
CREATE TABLE IF NOT EXISTS `log_adm_user_login` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `account` varchar(32) NOT NULL COMMENT '帐号',
  `time` int(10) unsigned NOT NULL COMMENT '时间',
  `status` tinyint(3) unsigned NOT NULL COMMENT '状态 0:失败|1:成功',
  `ip` char(15) NOT NULL COMMENT 'IP',
  `ip_segment` varchar(31) NOT NULL COMMENT 'IP段',
  `address` varchar(128) NOT NULL COMMENT '地址',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='日志-后台账号登录';
