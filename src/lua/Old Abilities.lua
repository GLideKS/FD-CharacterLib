local function JumpThinker(p)
	if not (p.mo and p.mo.valid) then return end
	if not (FDChar[p.mo.skin] and FDChar[p.mo.skin].old_ability) then return end

	local mo = p.mo
	
	--Old CA_GLIDEANDCLIMB from Ugly Knuckles v4.1 by GXP3000
	if p.charability == CA_GLIDEANDCLIMB then
		if (p.pflags & PF_GLIDING) then
			local leeway

			if (p.mo.momz == (-2*FRACUNIT)/TICRATE) then
				p.mo.momz = (-2*FRACUNIT)/TICRATE
			elseif (p.mo.momz < (-2*FRACUNIT)/TICRATE) then
				p.mo.momz = $ + (3*(FRACUNIT/4))/TICRATE
			end

			-- Strafing while gliding.
			leeway = FixedAngle(p.cmd.sidemove * (FRACUNIT/2))

			if ((p.mo.eflags & MFE_UNDERWATER)) then
				P_InstaThrust(p.mo, p.mo.angle - leeway, ((p.actionspd*(p.powers[pw_super] and 40 or 20)) + p.glidetime * 750)/TICRATE)
			else
				P_InstaThrust(p.mo, p.mo.angle - leeway, ((p.actionspd*(p.powers[pw_super] and 80 or 40)) + p.glidetime * 1500)/TICRATE)
			end
				
			p.glidetime = $ + 1

			if not (p.pflags & PF_JUMPDOWN) then -- If not holding the jump button
				P_ResetPlayer(p) -- down, stop gliding.
				if ((p.charflags == SF_MULTIABILITY)
				or p.charability2 == CA2_MULTIABILITY --This one does not exists but whatever. it was in the script.
				or (p.powers[pw_super] and All7Emeralds(p.powers[pw_emeralds]))
				) then
					p.pflags = $ | PF_JUMPED
					p.mo.state = S_PLAY_ROLL
				else
					p.mo.momx = $ >> 1
					p.mo.momy = $ >> 1
					p.mo.state = S_PLAY_FALL
				end
			end
		elseif p.climbing then -- 'Deceleration' for climbing on walls.
			if (p.mo.momz > 0) then
				p.mo.momz = $ - FRACUNIT/(TICRATE*2)
			elseif (p.mo.momz < 0) then
				p.mo.momz = $ + FRACUNIT/(TICRATE*2)
			end
		end
	-- Pre 2.2 old CA_FLOAT coded by GLide KS.
	elseif p.charability == CA_FLOAT then
		if (p.pflags & PF_JUMPDOWN) and (p.pflags & PF_THOKKED) then
			p.mo.momz = 0
			return true
		end
	end
end

local function AbilitySpecial(p)
	if not (p.mo and p.mo.valid) then return end
	if not (FDChar[p.mo.skin] and FDChar[p.mo.skin].old_ability) then return end

	if p.charability == CA_FLOAT then
		if not (p.pflags & PF_THOKKED) then
			if not p.mo.fdlib_abilityused then p.pflags = $1 | PF_THOKKED end
		elseif not (p.charflags & SF_MULTIABILITY) then
			p.pflags = $ & ~ PF_THOKKED
			p.mo.fdlib_abilityused = true
		end
		return true
    end
end

local function PreThinkFrame()
	if gamestate != GS_LEVEL then return end
    for p in players.iterate do
        if not (p.mo and p.mo.valid) then continue end
		if p.exiting then continue end
		if not (FDChar[p.mo.skin] and FDChar[p.mo.skin].old_ability) then continue end

		-- Old CA_GLIDEANDCLIMB
		if p.charability == CA_GLIDEANDCLIMB then
			if p.climbing == 1 and not p.powers[pw_super] then --Bruh how tf is he still slower than the other one (okay so I'm a literal dumbass for thinking that testing this with another Ugly present would be a good idea)
				p.cmd.forwardmove = $*3/4
				p.cmd.sidemove = $*9/10
			elseif p.climbing == 1 and p.powers[pw_super] then --Super buffs just because he needs them.
				p.cmd.forwardmove = $*2
				p.cmd.sidemove = $*2
			end

			if P_IsObjectOnGround(p.mo) and p.pflags & PF_GLIDING then
				P_ResetPlayer(p)
				p.pflags = $ & ~(PF_GLIDING|PF_JUMPED|PF_NOJUMPDAMAGE)
				p.mo.state = S_PLAY_WALK
			end
			if p.mo.state == S_PLAY_GLIDE_LANDING then
				p.mo.state = S_PLAY_STND
			end
			if p.mo.state != S_PLAY_GLIDE
			and (p.pflags & PF_THOKKED) then
				p.pflags = $ & ~PF_THOKKED
			end

			if (p.climbing > 1) then
				p.pflags = (p.pflags | PF_FORCESTRAFE)
			elseif (p.climbing) then
				p.mo.angle = p.mo.angle
			elseif (p.climbing == 0)
			and (p.pflags & PF_FORCESTRAFE) then
				p.pflags = (p.pflags & ~PF_FORCESTRAFE)
			end
		elseif p.charability == CA_FLOAT then
			if p.mo.fdlib_abilityused and P_IsObjectOnGround(p.mo) then
				p.mo.fdlib_abilityused = false
			end
		end
    end
end

local function PostThink()
	if gamestate != GS_LEVEL then return end
    for p in players.iterate do
        if not (p.mo and p.mo.valid) then continue end
		if p.exiting then continue end
		if not (FDChar[p.mo.skin] and FDChar[p.mo.skin].old_ability) then continue end

		-- CA_SLOWFALL and CA_FLOAT doesn't switch to walk/run animations when using the ability
		if (p.charability == CA_SLOWFALL or p.charability == CA_FLOAT) then
			if (p.pflags & PF_THOKKED) then
				if (p.charflags & SF_NOJUMPSPIN) then
					if p.mo.momz <= 0 then
						if p.mo.state != S_PLAY_FALL then p.mo.state = S_PLAY_FALL end
					else p.mo.state = S_PLAY_SPRING end
				elseif p.mo.state != S_PLAY_ROLL then p.mo.state = S_PLAY_ROLL
				end
			end
		end
	end
end

local function CanDamage(p)
	if not (p.mo and p.mo.valid) then return end
	if not (FDChar[p.mo.skin] and FDChar[p.mo.skin].old_ability) then return end

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