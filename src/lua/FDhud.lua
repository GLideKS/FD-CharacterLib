local d
local dnum
local dscaled
local getSprite2Patch
local getColormap
local cachePatch

local customfontstring = customhud.CustomFontString

customhud.SetupFont("FDNAM", 0, 4) --Font for the alternate name graphic to be used

local function FDLives(v, p)
	if (p.powers[pw_carry] == CR_NIGHTSMODE) then return end
	if (maptol & TOL_NIGHTS) then return end
	if G_RingSlingerGametype() then return end

	--Assign drawing functions to locals for optimization
	if d == nil then d = v.draw end
	if dnum == nil then dnum = v.drawNum end
	if dscaled == nil then dscaled = v.drawScaled end
	if getSprite2Patch == nil then getSprite2Patch = v.getSprite2Patch end
	if getColormap == nil then getColormap = v.getColormap end
	if cachePatch == nil then cachePatch = v.cachePatch end

	local minimal = CV_FindVar("fdlib_minimalhud").value
	local skin = skins[p.skin].name
	local fdchar = FDChar[skin]
	local flags = V_SNAPTOLEFT|V_SNAPTOBOTTOM|V_PERPLAYER|V_HUDTRANS

	--Face graphic
	local fpatch = {
		x = 16,
		y = 161+(minimal and 16 or 0)
	}

	local face = getSprite2Patch(skin, SPR2_XTRA, (p.powers[pw_super] != 0), 0, 0)
	dscaled(fpatch.x*FU, fpatch.y*FU, (minimal and FU/2) or FU, face, flags, getColormap(skin, p.skincolor or p.mo.color))

	--Graphic Name
	local gname = {
		x = 53-(minimal and 37 or 0),
		y = 161+(minimal and 6 or 0)
	}

	local graphic_name = fdchar and fdchar.name_graphic and cachePatch(fdchar.name_graphic)
	local alt_name = skins[skin].hudname or skins[skin].realname or skins[skin].name

	if graphic_name then
		d(gname.x, gname.y, cachePatch(fdchar.name_graphic), flags) --Draw the character's name graphic if any
	else
		customfontstring(v, gname.x, gname.y, string.upper(alt_name), "FDNAM", flags) --If not, let Custom HUD draw one
	end

	--Lives X
	local livex = cachePatch("STFINLX")
	d(57-(minimal and 21 or 0), 185, livex, flags)

	--Lives count
	local x,y = 89-(minimal and 21 or 0),182
	local infinite_lives = p.lives == INFLIVES or (multiplayer and CV_FindVar("cooplives").value == 0)

	local livenum = (infinite_lives and 99) or p.lives or 0
	dnum(x, y, livenum, flags|V_OLDSPACING)
end

addHook("HUD", function(v, p)
	local forcehud = CV_FindVar("fdlib_forceliveshud").value
	local skin = skins[p.skin].name

	if (FDChar[skin] and FDChar[skin].fdhud != false) or forcehud then
		if customhud.CheckType("lives") == "vanilla" then
			customhud.SetupItem("lives", "FDFeatures")
		end
	elseif customhud.CheckType("lives") == "FDFeatures" then
		customhud.SetupItem("lives", "vanilla")
	end
end)

customhud.SetupItem("lives", "FDFeatures", FDLives)