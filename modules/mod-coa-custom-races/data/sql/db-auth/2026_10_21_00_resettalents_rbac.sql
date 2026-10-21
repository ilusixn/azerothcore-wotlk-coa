DELETE FROM `rbac_permissions` WHERE `id` = 6001;
INSERT INTO `rbac_permissions` (`id`, `name`) VALUES (6001, 'Command: resettalents (CoA Custom Races)');
DELETE FROM `rbac_linked_permissions` WHERE `linkedId` = 6001;
INSERT INTO `rbac_linked_permissions` (`id`, `linkedId`) VALUES (192, 6001), (193, 6001), (194, 6001), (195, 6001);
