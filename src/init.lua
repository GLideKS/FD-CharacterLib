/*---F.D Character Library v1.1 by GLide KS---*/

--set this if you have FD Char Lib inside a subfolder. 
--remember to end it with /
local FDCharLib_root = ""

/*
Custom HUD Library v4.6

In case your addon already counts with Custom HUD Library
remove this dofile line, but make sure to load it BEFORE FD Character Lib
*/
dofile(FDCharLib_root.."Libraries/Lib_CustomHUD")

if not FDChar then rawset(_G, "FDChar", {}) end
if not FDLib_loaded then rawset(_G, "FDLib_loaded", false) end

if not FDLib_loaded then
	dofile(FDCharLib_root.."Font")
	dofile(FDCharLib_root.."FDhud")
	dofile(FDCharLib_root.."Old Anims")
	dofile(FDCharLib_root.."Slingitem")
	dofile(FDCharLib_root.."Taunts")
	
	print("\131F.D Character Library loaded sucessfully!")
	FDLib_loaded = true
else
	print("\x82\WARNING: F.D Character Library already loaded, skipping.")
end