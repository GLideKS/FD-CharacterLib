/*
Replica of Final Demo's S_SKIN slingitem functionality for EMW5 port.
Coded by: GLide KS

A custom slingitem in final demo acts as an Object replace for MT_REDRING
and you're able to shoot it on non-ringslinger modes if desired
*/

--we gotta play this sound manually if we want to use custom slingitem's seesound
--Since there's no way to directly replace MT_REDRING completely on spawn.
mobjinfo[MT_REDRING].seesound = sfx_none

--Shoot the character's slingitem if defined instead
addHook("PostThinkFrame", function()
if gamestate != GS_LEVEL then return end
for mo in mobjs.iterate() do
	if mo.type != MT_REDRING then continue end
	if mo.valid and mo.target then
		local fdchar = FDChar[mo.target.skin]
		local has_slingitem = (fdchar and fdchar.slingitem)
		if has_slingitem then
			if not fdchar.ringslinger then continue end
			P_SpawnPlayerMissile(mo.target, fdchar.slingitem)
			P_RemoveMobj(mo)
		end
	end
end
end)

--Play the usual MT_REDRING shoot sound for non-slingitem characters
addHook("MobjSpawn", function(mo)
	if (mo.target and (FDChar[mo.target.skin] and FDChar[mo.target.skin].slingitem)) then return end
	S_StartSound(mo, sfx_thok)
end, MT_REDRING)

--Do ringslinger in non-ringslinger gamemodes for slingitem characters
--Or those who has ringslinger enabled
--That's how it works in Final Demo
addHook("PlayerThink", function(p)
	if not (p and p.mo and p.mo.valid and p.playerstate == PST_LIVE and p.rings) then return end
	local pmo = p.mo
	local cmd = p.cmd
	local fdchar = FDChar[pmo.skin]
	local slingitem = fdchar and fdchar.slingitem
	
	if not (fdchar and fdchar.ringslinger) then return end
	if G_RingSlingerGametype() then return end
	if p.exiting then return end
	
	--Shoot it
	if not p.weapondelay
	and ((cmd.buttons & BT_ATTACK) and not (p.lastbuttons & BT_ATTACK)) then
		P_SpawnPlayerMissile(pmo, slingitem or MT_REDRING)
		p.rings = $-1
		p.weapondelay = TICRATE/4
	end
end)