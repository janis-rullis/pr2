CREATE DATABASE IF NOT EXISTS `pr2`;
CREATE DATABASE IF NOT EXISTS `pr2_testing`;
GRANT ALL PRIVILEGES ON `pr2`.* TO 'pr2-user'@'%';
GRANT ALL PRIVILEGES ON `pr2_testing`.* TO 'pr2-user'@'%';
FLUSH  PRIVILEGES;
CREATE TABLE IF NOT EXISTS `pr2`.`redirect`(
    `id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
    `from` VARCHAR(250) NOT NULL,
    `to` VARCHAR(250) NOT NULL,
    `is_public` ENUM('y', 'n') NOT NULL DEFAULT 'n' COMMENT 'ENUM is more readable, stricter and faster than VARCHAR.',
    `created_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Timestamp is readable and has supported default methods available',
    `updated_at` TIMESTAMP NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
    `deleted_at` timestamp NULL DEFAULT NULL,
    `sys_info` varchar(20) DEFAULT NULL COMMENT 'In case if You need to mark it or add some flag. For inner use. For example, edited 3 JSONs by hand and mark \"#1234 upd\", so they could be identified later.',             
    PRIMARY KEY(`id`),
    UNIQUE INDEX `from_pub`(`from`, `is_public`)
) ENGINE = INNODB DEFAULT CHARACTER SET = UTF8 COMMENT '#3';
CREATE TABLE IF NOT EXISTS `pr2_testing`.`redirect`(
    `id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
    `from` VARCHAR(250) NOT NULL,
    `to` VARCHAR(250) NOT NULL,
    `is_public` ENUM('y', 'n') NOT NULL DEFAULT 'n' COMMENT 'ENUM is more readable, stricter and faster than VARCHAR.',
    `created_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Timestamp is readable and has supported default methods available',
    `updated_at` TIMESTAMP NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
    `deleted_at` timestamp NULL DEFAULT NULL,
    `sys_info` varchar(20) DEFAULT NULL COMMENT 'In case if You need to mark it or add some flag. For inner use. For example, edited 3 JSONs by hand and mark \"#1234 upd\", so they could be identified later.',             
    PRIMARY KEY(`id`),
    UNIQUE INDEX `from_pub`(`from`, `is_public`)
) ENGINE = INNODB DEFAULT CHARACTER SET = UTF8 COMMENT '#3';