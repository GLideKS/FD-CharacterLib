local taunttimer = 4*TICRATE

addHook("PlayerThink", function(p)
	if not (p and p.mo and FDChar[p.mo.skin] and FDChar[p.mo.skin].taunts) then return end
	local cmd = p.cmd
	local pmo = p.mo
	
	if p.taunttimer == nil then p.taunttimer = 0 end
	
	if (cmd.buttons & BT_CUSTOM1) and not (p.lastbuttons & BT_CUSTOM1)
	and not p.taunttimer then
		local voices = FDChar[p.mo.skin].taunts
		local randomtaunt = voices[P_RandomRange(1, #voices)]
		S_StartSound(pmo, randomtaunt)
		p.taunttimer = taunttimer
	end
	
	if p.taunttimer then p.taunttimer = $-1 end
end)