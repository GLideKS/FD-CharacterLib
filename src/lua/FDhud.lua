local function FDLives(v, p)
	if (p.powers[pw_carry] == CR_NIGHTSMODE) then return end
	if (maptol & TOL_NIGHTS) then return end
	if G_RingSlingerGametype() then return end
	
	local fdchar = FDChar[p.mo.skin]
	local flags = V_SNAPTOLEFT|V_SNAPTOBOTTOM|V_PERPLAYER|V_HUDTRANS
	
	--Face graphic
	local fpatch = {
		x = 16,
		y = 161+(minimal and 16 or 0)
	}

	local face = v.getSprite2Patch(p.mo.skin, SPR2_XTRA, (p.powers[pw_super] != 0), 0, 0)
	v.drawScaled(fpatch.x*FU, fpatch.y*FU, (minimal and FU/2) or FU, face, flags, v.getColormap(p.mo.skin, p.mo.color))
	
	--Graphic Name
	local gname = {
		x = 53-(minimal and 37 or 0),
		y = 161+(minimal and 6 or 0)
	}
	
	local graphic_name = fdchar and fdchar.name_graphic and v.cachePatch(fdchar.name_graphic)
	local alt_name = skins[p.mo.skin].hudname or skins[p.mo.skin].realname or skins[p.mo.skin].name
	
	if graphic_name then
		v.draw(gname.x, gname.y, v.cachePatch(fdchar.name_graphic), flags)
	else
		customhud.CustomFontString(v, gname.x, gname.y, string.upper(alt_name), "FDNAM", flags)
	end
	
	--Lives X
	local livex = v.cachePatch("STFINLX")
	v.draw(57-(minimal and 21 or 0), 185, livex, flags)
	
	--Lives count
	local x,y = 89-(minimal and 21 or 0),182
	local spacing = x - 8
	
	if p.lives <= 99 then
		v.drawNum(x, y, p.lives, flags|V_OLDSPACING)
	elseif (p.lives == INFLIVES) then
		v.drawNum(x, y, 99, flags|V_OLDSPACING)
	elseif not p.lives then
		v.drawNum(x, y, 0, flags|V_OLDSPACING)
	end
end

addHook("HUD", function(v, p)
	if not p.mo then
		if customhud.CheckType("lives") == "FDFeatures" then
			customhud.SetupItem("lives", "vanilla")
		end
		return
	end
	
	if FDChar[p.mo.skin] and FDChar[p.mo.skin].fdhud != false then
		if customhud.CheckType("lives") == "vanilla" then
			customhud.SetupItem("lives", "FDFeatures")
		end
	elseif customhud.CheckType("lives") == "FDFeatures"
		customhud.SetupItem("lives", "vanilla")
	end
end)

customhud.SetupItem("lives", "FDFeatures", FDLives)