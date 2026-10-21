-- CHANGES_UPSTREAM: Mastercraft (Mechagnome racial) summons gameobject 184911 under the player every 4 seconds.
-- Its go_flames script burns whoever stands in it and killed Mechagnomes; only players of the custom races
-- are affected by this, but the row belongs to upstream. Only needed while CoACustomRaces.Enable = 1.
UPDATE `gameobject_template` SET `ScriptName` = '' WHERE `entry` = 184911 AND `ScriptName` = 'go_flames';
