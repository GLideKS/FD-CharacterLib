# F.D Character Library

This addon brings a list of scripts for Sonic Robo Blast 2 v2.2 that replicates character features removed since SRB2 v2.0 release. Such as:
- Taunts
- Custom slingitem. 
- Other replicas like skipping super transformation frames and using walking frames as the spring animation since those are present in Final Demo under certain modding conditions.

This asset also could be used as an standalone addon by the usage of `fdlib_forceliveshud` and `fdlib_minimalhud` commands.

And as an extra, **it replicates Final Demo lives counter by default. The addon already contains CustomHUD Library actually maintained by SkyDusk, and allows to handle the Final Demo lives HUD in a less conflictive way.** The Final Demo lives counter switches to SRB2's vanilla lives counter if the character is not defined for the script. And in general you can either disable or enable this hud.

The character's name is actually a graphic you need to give to the script later. Maximum lives in the HUD caps at 99 even with infinite lives.

## Usage

The character must include all F.D Character Library contents, along with an additional lua script that defines the character itself to use the library features.

Here's an example of the additional script that the character should include. we'll be using Sonic as an example (which carries the skin name "sonic")

```lua
FDChar["sonic"] = {
	name_graphic = "STSONIC",
	fdhud = true,
	slingitem = MT_THROWNEXPLOSION,
	ringslinger = true,
	skiptransform = true,
	nosuperspring = true
	taunts = {sfx_cdpcm2, sfx_cdpcm4, sfx_cdpcm5}
}
```
Meaning of the variables in the table

| Variable name        | Type           | Description  |
| ------------- | --------------------- | ----- |
| name_graphic  | string                | The graphic lump name to be shown.<br><br>If not set, it will show the character's name instead as an alternative. will search for `hudname` , `realname`, or `name` from the S_SKIN lump  |
| fdhud         | boolean               | Toggles Final Demo lives hud. the lives hud becomes invisible on ringslinger gametypes.<br><br>true by default. |
| slingitem     | MT_ constant (object) | Red Ring is replaced by the given object for the specified character.<br><br>MT_REDRING by default. |
| ringslinger   | boolean               | If enabled, allows the character to shoot on non-ringslinger gametypes and completely ignores `ringslinger` command<br><br>false by default |
| skiptransform | boolean               | If enabled, allows the character to skip the transformation frames.<br><br>false by default |
| nosuperspring | boolean               | If enabled, the character displays the walking frames instead of the spring/fall animations when using springs or similar.<br><br>false by default |
| taunts        | table                 | If sounds given, does any of the sounds [SFX_] with Button Custom 1 |

# Commands
| Command name        | Valid values           | Description  |
| ------------- | --------------------- | ----- |
| fdlib_minimalhud  | On/Off                | If enabled, the SRB2 Final Demo lives HUD switches to SRB2 v2.0 lives HUD style<br><br>Off by default |
| fdlib_forceliveshud | On/Off | If enabled, forces all the characters to use F.D Lives HUD<br><br>Off by default. |

# How to build

## Linux
**Requriements:**
- python3
- zopfli (or zlib although hashes were made with zopfil in mind)
- xxhash (For printing the checksum after file is made)

**Building:**
- Open up a terminal and run buildmain.sh

## Windows/Linux with SLADE3 (The easiest way)
- Open up [SLADE3](https://slade.mancubus.net/index.php?page=downloads)
- Go to File - Open Directory
- Navigate and open the **src** folder found in the repo
- Go to Archive - Build Archive
- Save the file as a **PK3** with a desired name
- **Ready to test it out!**

# Credits
- GLide KS (Lua Scripting, some replicated name fonts and addon owner)
- Romoney5 (Minor lua assistance)
- SkyDusk ([CustomHUD Library](https://gist.github.com/Ace-Lite/4e37de764474b7adc7d6d559696a11a0))
- Sonic Team Jr. (SRB2 Final Demo assets)

**Other tools**
- GenericHeroGuy (pk3make)
