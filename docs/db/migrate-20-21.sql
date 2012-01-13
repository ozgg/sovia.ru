-- Переименование поля с адресом электронной почты
ALTER TABLE `user_item`
    CHANGE `mail` `email` VARCHAR(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL;

ALTER TABLE `user_item` ADD UNIQUE `user_email` (`email`);


-- Новый тип ключа пользователя
ALTER TABLE `user_key` DROP FOREIGN KEY `fk_user_key_owner`;

alter table `user_key` drop column `event_key`,
   add column `created_at` timestamp DEFAULT current_timestamp NOT NULL COMMENT 'Creation time' after `user_id`,
   add column `body` varchar(32) NOT NULL COMMENT 'Body' after `updated_at`,
   change `id` `id` mediumint(10) UNSIGNED NOT NULL AUTO_INCREMENT comment 'PK',
   change `type` `type_id` tinyint(3) UNSIGNED default '1' NOT NULL comment 'Key type',
   change `owner_id` `user_id` mediumint(8) UNSIGNED NULL  comment 'Owner',
   change `expires_at` `updated_at` datetime NULL  comment 'Update time';

ALTER TABLE `user_key`
    ADD CONSTRAINT `FK_user_key_owner` FOREIGN KEY (`user_id`) REFERENCES `user_item` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `sovia_dev`.`user_item`
  ADD COLUMN `avatar_id` INT(10) UNSIGNED NULL  COMMENT 'Default avatar' AFTER `password`,
  ADD COLUMN `max_avatars` TINYINT(3) UNSIGNED DEFAULT 3  NOT NULL  COMMENT 'Maximum number of avatars' AFTER `avatar_id`;
