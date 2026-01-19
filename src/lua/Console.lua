local commandprefix = "fdlib_"

--Switch between pre-2.0 and 2.0 lives style
CV_RegisterVar({
	name = commandprefix.."minimalhud",
	defaultvalue = "off",
	PossibleValue = CV_OnOff
})

--Force the FD Hud lives to be shown
CV_RegisterVar({
	name = commandprefix.."forceliveshud",
	defaultvalue = "off",
	PossibleValue = CV_OnOff
})