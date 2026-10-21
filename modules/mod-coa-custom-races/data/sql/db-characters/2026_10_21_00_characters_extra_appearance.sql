SET @coa_extra_appearance_ddl = IF(EXISTS(SELECT 1 FROM `information_schema`.`COLUMNS` WHERE `TABLE_SCHEMA` = DATABASE() AND `TABLE_NAME` = 'characters' AND `COLUMN_NAME` = 'extraAppearance'), 'DO 0', 'ALTER TABLE `characters` ADD COLUMN `extraAppearance` BIGINT UNSIGNED NOT NULL DEFAULT 0');
PREPARE `coa_extra_appearance_stmt` FROM @coa_extra_appearance_ddl;
EXECUTE `coa_extra_appearance_stmt`;
DEALLOCATE PREPARE `coa_extra_appearance_stmt`;
