ALTER TABLE `posting_tag`
  ADD COLUMN `post_id` INT(11) UNSIGNED NULL  COMMENT 'Post with description' AFTER `weight`,
  ADD CONSTRAINT `FK_posting_tag_post` FOREIGN KEY (`post_id`) REFERENCES `posting_item`(`id`) ON UPDATE CASCADE ON DELETE SET NULL;
