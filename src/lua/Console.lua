rawset(_G, "minimal", false)
rawset(_G, "forcehud", false)
local commandprefix = "fdlib_"

--Switch between pre-2.0 and 2.0 lives style
local function minimal_command(p)
    if minimal == false then minimal = true
        CONS_Printf(p, "Lives HUD changed to SRB2 v2.0 style")
    else minimal = false
        CONS_Printf(p, "Lives HUD changed back to Final Demo style")
    end
end
COM_AddCommand(commandprefix.."minimalhud", minimal_command, COM_LOCAL)

--Force the FD Hud lives to be shown
local function force_liveshud(p)
    if forcehud == false then forcehud = true
        CONS_Printf(p, "F.D Lives HUD forced to all characters")
    else forcehud = false
        CONS_Printf(p, "F.D Lives HUD force disabled")
    end
end
COM_AddCommand(commandprefix.."forceliveshud", force_liveshud, COM_LOCAL)