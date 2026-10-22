# Client files (optional, not used by the server)

Login screen of the CoA Custom client, shipped in the client archive `patch-ZZZD.MPQ` of release coa-custom-1.8.3.

- `Interface/GlueXML/AccountLogin.lua` / `.xml`: the Discord button opens https://discord.gg/BhEYuYYqFN and the GitHub button opens https://github.com/ilusixn/azerothcore-wotlk-coa. Put them in an MPQ (path `Interface\GlueXML\`) that loads after patch-B.
- `logo/ilusixn-custom-races-logo.png`: source of the logo. `make_blp.py` + `blp.py` turn it into the two textures the client uses (`Interface\GLUES\COMMON\Glues-WoW-WotLKLogo_AS.blp` and `Interface\GLUES\MainMenu\AscensionLogo.blp`); no BLP or MPQ binary is stored in this repository. They read the original textures from a client folder, edit the paths at the top.
