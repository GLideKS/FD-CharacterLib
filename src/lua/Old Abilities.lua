local function JumpThinker(p)
	if not (p.mo and p.mo.valid) then return end
	local mo = p.mo
	if not (FDChar[mo.skin] and FDChar[mo.skin].old_ability) then return end

	--Old CA_GLIDEANDCLIMB from Ugly Knuckles v4.1 by GXP3000
	if p.charability == CA_GLIDEANDCLIMB then
		if (p.pflags & PF_GLIDING) then
			local leeway

			if (mo.momz == (-2*FRACUNIT)/TICRATE) then
				mo.momz = (-2*FRACUNIT)/TICRATE
			elseif (mo.momz < (-2*FRACUNIT)/TICRATE) then
				mo.momz = $ + (3*(FRACUNIT/4))/TICRATE
			end

			-- Strafing while gliding.
			leeway = FixedAngle(p.cmd.sidemove * (FRACUNIT/2))

			if ((mo.eflags & MFE_UNDERWATER)) then
				P_InstaThrust(mo, mo.angle - leeway, ((p.actionspd*(p.powers[pw_super] and 40 or 20)) + p.glidetime * 750)/TICRATE)
			else
				P_InstaThrust(mo, mo.angle - leeway, ((p.actionspd*(p.powers[pw_super] and 80 or 40)) + p.glidetime * 1500)/TICRATE)
			end

			p.glidetime = $ + 1

			if not (p.pflags & PF_JUMPDOWN) then -- If not holding the jump button
				P_ResetPlayer(p) -- down, stop gliding.
				if ((p.charflags == SF_MULTIABILITY)
				or p.charability2 == CA2_MULTIABILITY --This one does not exists but whatever. it was in the script.
				or (p.powers[pw_super] and All7Emeralds(p.powers[pw_emeralds]))
				) then
					p.pflags = $ | PF_JUMPED
					mo.state = S_PLAY_ROLL
				else
					mo.momx = $ >> 1
					mo.momy = $ >> 1
					mo.state = S_PLAY_FALL
				end
			end
		elseif p.climbing then -- 'Deceleration' for climbing on walls.
			if (mo.momz > 0) then
				mo.momz = $ - FRACUNIT/(TICRATE*2)
			elseif (mo.momz < 0) then
				mo.momz = $ + FRACUNIT/(TICRATE*2)
			end
		end
	-- Pre 2.2 old CA_FLOAT coded by GLide KS.
	elseif p.charability == CA_FLOAT then
		if (p.pflags & PF_JUMPDOWN) and (p.pflags & PF_THOKKED) then
			mo.momz = 0
			return true
		end
	end
end

local function AbilitySpecial(p)
	if not (p.mo and p.mo.valid) then return end
	local mo = p.mo
	if not (FDChar[mo.skin] and FDChar[mo.skin].old_ability) then return end

	if p.charability == CA_FLOAT then
		if not (p.pflags & PF_THOKKED) then
			if not mo.fdlib_abilityused then p.pflags = $1 | PF_THOKKED end
		elseif not (p.charflags & SF_MULTIABILITY) then
			p.pflags = $ & ~ PF_THOKKED
			mo.fdlib_abilityused = true
		end
		return true
    end
end

local function PreThinkFrame()
	if gamestate != GS_LEVEL then return end
    for p in players.iterate do
        if not (p.mo and p.mo.valid) then continue end
		local mo = p.mo
		if p.exiting then continue end
		if not (FDChar[mo.skin] and FDChar[mo.skin].old_ability) then continue end

		-- Old CA_GLIDEANDCLIMB
		if p.charability == CA_GLIDEANDCLIMB then
			if p.climbing == 1 and not p.powers[pw_super] then --Bruh how tf is he still slower than the other one (okay so I'm a literal dumbass for thinking that testing this with another Ugly present would be a good idea)
				p.cmd.forwardmove = $*3/4
				p.cmd.sidemove = $*9/10
			elseif p.climbing == 1 and p.powers[pw_super] then --Super buffs just because he needs them.
				p.cmd.forwardmove = $*2
				p.cmd.sidemove = $*2
			end

			if P_IsObjectOnGround(mo) and p.pflags & PF_GLIDING then
				P_ResetPlayer(p)
				p.pflags = $ & ~(PF_GLIDING|PF_JUMPED|PF_NOJUMPDAMAGE)
				mo.state = S_PLAY_WALK
			end
			if mo.state == S_PLAY_GLIDE_LANDING then
				mo.state = S_PLAY_STND
			end
			if mo.state != S_PLAY_GLIDE
			and (p.pflags & PF_THOKKED) then
				p.pflags = $ & ~PF_THOKKED
			end

			if (p.climbing > 1) then
				p.pflags = (p.pflags | PF_FORCESTRAFE)
			elseif (p.climbing) then
				mo.angle = mo.angle
			elseif (p.climbing == 0)
			and (p.pflags & PF_FORCESTRAFE) then
				p.pflags = (p.pflags & ~PF_FORCESTRAFE)
			end
		elseif p.charability == CA_FLOAT then
			if mo.fdlib_abilityused and P_IsObjectOnGround(mo) then
				mo.fdlib_abilityused = false
			end
		end
    end
end

local function PostThink()
	if gamestate != GS_LEVEL then return end
    for p in players.iterate do
        if not (p.mo and p.mo.valid) then continue end
		local mo = p.mo
		if p.exiting then continue end
		if not (FDChar[mo.skin] and FDChar[mo.skin].old_ability) then continue end

		-- CA_SLOWFALL and CA_FLOAT doesn't switch to walk/run animations when using the ability
		if (p.charability == CA_SLOWFALL or p.charability == CA_FLOAT) then
			if (p.pflags & PF_THOKKED) then
				if (p.charflags & SF_NOJUMPSPIN) then
					if mo.momz <= 0 then
						if mo.state != S_PLAY_FALL then mo.state = S_PLAY_FALL end
					else mo.state = S_PLAY_SPRING end
				elseif mo.state != S_PLAY_ROLL then mo.state = S_PLAY_ROLL
				end
			end
		end
	end
end

local function CanDamage(p)
	if not (p.mo and p.mo.valid) then return end
	local mo = p.mo
	if not (FDChar[mo.skin] and FDChar[mo.skin].old_ability) then return end

	--Slowfall is still able to damage pre 2.2
	if p.charability == CA_SLOWFALL then
		if not (p.charflags & SF_NOJUMPDAMAGE)
		and (p.pflags & PF_THOKKED) then
			return true
		end
	end
end

addHook("PreThinkFrame", PreThinkFrame)
addHook("PostThinkFrame", PostThink)
addHook("JumpSpecial", JumpThinker)
addHook("AbilitySpecial", AbilitySpecial)
addHook("PlayerCanDamage", CanDamage)