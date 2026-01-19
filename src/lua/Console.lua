rawset(_G, "minimal", false)
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