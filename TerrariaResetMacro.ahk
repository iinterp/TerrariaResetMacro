global macroVersion := 1.0.0
author := "interp"

#SingleInstance Force
CoordMode, Mouse, Client
SetWorkingDir %A_ScriptDir%

global resetKeybind
global passthrough
global keyDuration
global waitMultiplier
global keyWait
global resetMode
global charName
global charDifficulty
global charStyle
global charStylePaste
global worldName
global worldDifficulty
global worldSize
global worldEvil
global worldSeed
global multiplayer
global multiplayerMethod
global IP
global moveFiles
global ignoreThisUpdate
global remindMeLater
global downloadUpdate
global ignoredMacroVersion
global changelogLink
global terrariaDir
global terrariaGameDir
global showOnStart
global version

global firstMacroLaunch

global resetSelection
global presetResetsNum
global globalResets

global unsavedPresetName
global presetName
global preset_Array := []
global preset_ArrayString


global macroSettings_Array := ["runOnStart","terrariaGameDir","disableSeasons","dontShowUnsavedPopup","resetKeybind","passthrough","showOnStart","keyDuration","waitMultiplier","keyWait","moveFiles","resetMode","ignoredMacroVersion","terrariaDir","clearServers","autoClose"]
global categorySettings_Array := ["version","charName","charDifficulty","charStyle","charStylePaste","worldName","worldDifficulty","worldSize","worldEvil","worldSeed","multiplayer","multiplayerMethod","IP"]
global settings_Array := ["runOnStart","terrariaGameDir","disableSeasons","dontShowUnsavedPopup","resetKeybind","passthrough","showOnStart","keyDuration","waitMultiplier","keyWait","moveFiles","resetMode","ignoredMacroVersion","terrariaDir","clearServers","autoClose","version","charName","charDifficulty","charStyle","charStylePaste","worldName","worldDifficulty","worldSize","worldEvil","worldSeed","multiplayer","multiplayerMethod","IP"]

global resetMode_Array := ["Keyboard", "Mouse"]
global charDifficulty_Array := ["Journey", "Classic", "Mediumcore", "Hardcore"]
global charStyle_Array := ["Default", "Random"]
global worldDifficulty_Array := ["Journey", "Classic", "Expert", "Master"]
global worldSize_Array := ["Small", "Medium", "Large"]
global worldEvil_Array := ["Random", "Corruption", "Crimson"]
global multiplayerMethod_Array := ["Host", "Join"]

global multiplayerVisible_Array := ["multiplayerSettings","multiplayerMethod_Host","multiplayerMethod_Join","IPText","IP"]

global gui_Arrays := ["resetMode_Array","charDifficulty_Array","charStyle_Array","worldDifficulty_Array","worldSize_Array","worldEvil_Array","multiplayerMethod_Array"]

OnExit("Exit")

if (!FileExist(settings.ini)) {
	FileAppend,, settings.ini
}

if (A_MM A_DD >= 1010 && A_MM A_DD <= 1101 || A_MM A_DD >= 1215 && A_MM A_DD <= 1231) {
	global seasonalActive := 1
}

sessionResets := 0

LoadSettings()


requiredFields := "resetKeybind,keyDuration,waitMultiplier,keyWait,charName,version,presetName"

If (WinExist(terraria.exe)) {
terrariaHasExisted := 1
}

Menu, Tray, Icon, assets/icon.png
Menu, Tray, NoStandard
Menu, Tray, Add, Open Menu, OpenConfig
Menu, Tray, Default, Open Menu
Menu, Tray, Click, 1
Menu, Tray, Tip, Terraria Reset Macro v%macroVersion%
Menu, Tray, Add, Show Menu On Start, MenuCheckToggle
Menu, Tray, Add
if (showOnStart = 1) {
Menu, Tray, Check, Show Menu On Start
}

for key, value in (preset_Array) {
	Menu, PresetMenu, Add, %value%, TrayLoadPreset, +Radio
}

for key, value in (preset_Array) {
	if (presetName = value) {
		Menu, PresetMenu, Check, %value%
	} else {
			Menu, PresetMenu, Uncheck, %value%
	}
}

Menu, Tray, Add, Change Preset, :PresetMenu
Menu, Tray, Add

Menu, Tray, Add, Exit, Exit

if (showOnStart = 0) {
	Goto Hotkey
}

OpenConfig:
if (firstLaunch = 0) {
	LoadSettings()
}

SetTimer, AutoClose, Off

Gui, Settings:Submit
Gui, Main:New

	Gui, Add, GroupBox, Section h60 w290 Center, Reset Mode:
		resetMode_SB := "Reset Mode"
		Gui, Add, Button, xs+15 ys+18 w120 h30 vresetMode_Mouse gGUISaver, Mouse
		resetMode_Mouse_TT := "Uses the cursor to reset."
		Gui, Add, Button, xp+140 yp w120 h30 vresetMode_Keyboard gGUISaver, Keyboard
		resetMode_Keyboard_TT := "Uses the keyboard to reset."

	Gui, Add, GroupBox, xs ys+70 Section Center w290 h120, Macro Settings:
		Gui, Add, Text, xs+15 ys+18, Keybind:
		Gui, Add, Hotkey, w110 vresetKeybind gGUISaver, %resetKeybind%
		resetKeybind_TT := "The keybind to press to activate the macro."
		resetKeybind_SB := "Reset Keybind"
		Gui, Add, Text, xp yp+26, Key Duration:
		Gui, Add, Edit, w110 vkeyDuration gGUISaver, %keyDuration%
		keyDuration_TT := "The time keys are held down for. Increase if the macro is missing inputs."
		keyDuration_SB := "Key Duration"
		Gui, Add, Text, xp+150 ys+18, Wait Multiplier:
		Gui, Add, Edit, w110 vwaitMultiplier gGUISaver, %waitMultiplier%
		waitMultiplier_TT := "How long the macro should wait for loads. Increase if the macro is continuing too fast."
		waitMultiplier_SB := "Wait Multiplier"
		Gui, Add, Text, xp yp+26, Key Buffer:
		Gui, Add, Edit, w110 vkeyWait gGUISaver, %keyWait%
		keyWait_TT := "The time between key presses. Increase if the macro is missing inputs."
		keyWait_SB := "Key Buffer"

	Gui, Add, GroupBox, Center Section xs ys+130 w290 h75, Preset:
		Gui, Add, ComboBox, xs+15 yp+18 vpresetName gLoadPreset w260, %preset_ArrayString%
		Gui, Add, Text, xp yp+28, Version:
		Gui, Add, Edit, x+m yp-2 w60 vversion gGUISaver, %version%
		version_TT := "Terraria game version. Versions before 1.4.4 use a different version of the macro."
		version_SB := "Version"
		Gui, Add, Button, xp+100 yp w50 vdeletePreset gDeletePreset, Delete
		Gui, Add, Button, x+m yp w50 vsavePreset gSavePreset, Save
		
	Gui, Add, GroupBox, Center Section xs ym+285 h50, Character Name:
		Gui, Add, Edit, xp+15 yp+18 r1 w110 vcharName gGUISaver, %charName%
		charName_TT := "Can use GLOBALRESETS, PRESETRESETS and SESSIONRESETS variables."
		charName_SB := "Character Name"

	Gui, Add, GroupBox, Center Section xs ys+60 h50, Character Difficulty:
		charDifficulty_SB := "Character Difficulty"
		Gui, Add, Button, xp+15 yp+18 w20 vcharDifficulty_Journey gGUISaver, J
		charDifficulty_Journey_TT := "Journey"
		Gui, Add, Button, x+m w20 vcharDifficulty_Classic gGUISaver, C
		charDifficulty_Classic_TT := "Classic"
		Gui, Add, Button, x+m w20 vcharDifficulty_Mediumcore gGUISaver, M
		charDifficulty_Mediumcore_TT := "Mediumcore"
		Gui, Add, Button, x+m w20 vcharDifficulty_Hardcore gGUISaver, H
		charDifficulty_Hardcore_TT := "Hardcore"

	Gui, Add, GroupBox, Center Section xs ys+60 h110, Character Style:
		charStyle_SB := "Character Style"
		Gui, Add, Button, xp+15 yp+18 w50 vcharStyle_Default gGUISaver, Default
		Gui, Add, Button, x+m w50 vcharStyle_Random gGUISaver, Random
		Gui, Add, Text,xs+15 yp+26, Paste Template:
		Gui, Add, Edit, r2 w110 vcharStylePaste gGUISaver, %charStylePaste%
		charStylePaste_TT := "Paste character template to use as style."
		charStylePaste_SB := "Character Template"

		Gui, Add, GroupBox, Center Section xs ys+120 h50, Multiplayer:
			multiplayer_SB := "Multiplayer"
			multiplayerMethod_SB := "Multiplayer method"
			Gui, Add, Checkbox, vmultiplayer gGUISaver xs+15 yp+22 checked%multiplayer%, Multiplayer
		Gui, Add, Button, xs ys+66 w140 h40 vsettings gSettings, Settings
		Gui, Add, GroupBox, Center Section xs ys+60 h100 vmultiplayerSettings, Multiplayer Settings:
			Gui, Add, Button, xs+15 yp+22 w50 vmultiplayerMethod_Host gGUISaver, Host
			multiplayerMethod_Host_TT := "Makes you the host."
			Gui, Add, Button, x+m yp w50 vmultiplayerMethod_Join gGUISaver, Join
			multiplayerMethod_Join_TT := "Makes you join the IP set below."
			Gui, Add, Text, xs+15 yp+26 vIPText, IP:
			IP_SB := "IP"
			Gui, Add, Edit, xp yp+18 r1 w110 vIP gGUISaver, %IP%

;----

	Gui, Add, GroupBox, Center xs+150 ym+285 Section h50, World Name:
		worldName_SB := "World Name"
		Gui, Add, Edit,r1 vworldName gGUISaver w110 xp+15 yp+18, %worldName%
		worldName_TT := "Leave blank for random. Can use GLOBALRESETS, PRESETRESETS and SESSIONRESETS variables."
	Gui, Add, GroupBox, Center Section xs ys+60 h50, World Difficulty:
		worldDifficulty_SB := "World Difficulty"
		Gui, Add, Button, xp+15 yp+18 w20 vworldDifficulty_Journey gGUISaver, J
		worldDifficulty_Journey_TT := "Journey"
		Gui, Add, Button, x+m w20 vworldDifficulty_Classic gGUISaver, C
		worldDifficulty_Classic_TT := "Classic"
		Gui, Add, Button, x+m w20 vworldDifficulty_Expert gGUISaver, E
		worldDifficulty_Expert_TT := "Expert"
		Gui, Add, Button, x+m w20 vworldDifficulty_Master gGUISaver, M
		worldDifficulty_Master_TT := "Master"
	Gui, Add, GroupBox, Center Section xs ys+60 h50, World Size:
		worldSize_SB := "World Size"
		Gui, Add, Button, xp+15 yp+18 w30 vworldSize_Small gGUISaver, S
		worldSize_Small_TT := "Small"
		Gui, Add, Button, x+m w30 vworldSize_Medium gGUISaver, M
		worldSize_Medium_TT := "Medium"
		Gui, Add, Button, x+m w30 vworldSize_Large gGUISaver, L
		worldSize_Large_TT := "Large"
	Gui, Add, GroupBox, Center Section xs ys+60 h50, World Evil:
		worldEvil_SB := "World Evil"
		Gui, Add, Button, xp+15 yp+18 w30 vworldEvil_Random gGUISaver, Ran
		worldEvil_Random_TT := "Random"
		Gui, Add, Button, x+m w30 vworldEvil_Crimson gGUISaver, Crim
		worldEvil_Crimson_TT := "Crimson"
		Gui, Add, Button, x+m w30 vworldEvil_Corruption gGUISaver, Corr
		worldEvil_Corruption_TT := "Corruption"
	Gui, Add, GroupBox, Center Section xs ys+60 h50, World Seed:
		worldSeed_SB := "World Seed"
		Gui, Add, Edit,r1 vworldSeed gGUISaver w110 xp+15 yp+18, %worldSeed%
		worldSeed_TT := "Leave blank for random."
	Gui, Add, Button, xs ys+66 w140 h40 vSnQ gSnQ, Save
	Gui, Add, Button, xs ys+66 w140 h40 vsettings2 gSettings, Settings
	Gui, Add, Button, xs yp+54 w140 h40 vSnQ2 gSnQ, Save

GUIInit()

Gui, Add, StatusBar,vstatusBar, Terraria Reset Macro v%macroVersion%
Gui, Show, AutoSize Center, Terraria Reset Macro
OnMessage(0x0200, "WM_MOUSEMOVE")

if (checkedForUpdate != 1) {
	updateChecker()
}

if !InStr(FileExist(terrariaDir), "D") {
	Goto IncorrectDirectory
} else if !InStr(terrariaDir, "Terraria") {
	Goto IncorrectDirectory
} else if !InStr(FileExist(terrariaGameDir), "D") {
	Goto IncorrectDirectory
} else if !FileExist(terrariaGameDir "/Terraria.exe") {
	Goto IncorrectDirectory
}

Return

WM_MOUSEMOVE()
{
    static CurrControl, PrevControl, _TT  ; _TT is kept blank for use by the ToolTip command below.
    CurrControl := A_GuiControl
    if (CurrControl != PrevControl and not InStr(CurrControl, " "))
    {
        ToolTip  ; Turn off any previous tooltip.
        SetTimer, DisplayToolTip, 500
        PrevControl := CurrControl
    }
    return

    DisplayToolTip:
    SetTimer, DisplayToolTip, Off
    ToolTip % %CurrControl%_TT
		return
}

IncorrectDirectory:
Gui, IncorrectDirectory:New, +OwnerMain
Gui, -SysMenu

Gui, Add, GroupBox, h185 w350 Section Center, Terraria Directories:
	Gui, Add, Text, xs+15 ys+22 vterrariaSavesDirText, Saves Directory (My Games):
	Gui, Add, Edit, r1 xs+15 yp+22 w320 vterrariaDir gGUISaver, %terrariaDir%
	terrariaDir_TT := "Terraria saves directory. Usually in the 'My Games' folder. Selected folder should be 'Terraria'."
	Gui, Add, Button, w320 gTerrariaDirectoryExplore, Explore
	Gui, Add, Text, xs+15 yp+30 vterrariaGameDirText, Game Directory:
	Gui, Add, Edit, r1 xs+15 yp+22 w320 vterrariaGameDir gGUISaver, %terrariaGameDir%
	terrariaGameDir_TT := "Terraria game directory. Usually a Steam directory. Selected folder should be 'Terraria'."
	Gui, Add, Button, w320 gTerrariaGameDirectoryExplore, Explore

Gui, Add, Button, vsettingsSave gIncorrectDirectoryGuiClose xs yp+44 w350 h30, Save
Gui, Show, AutoSize Center
Gui, Main:+Disabled
Return


TerrariaDirectoryExplore:
FileSelectFolder, terrariaDir,, Select Terrarias save folder
GuiControl,, terrariaDir, %terrariaDir%
Gui, Submit, Nohide
IniWrite, %terrariaDir%, settings.ini, settings, terrariaDir
Return

TerrariaGameDirectoryExplore:
FileSelectFolder, terrariaGameDir,, Select Terrarias Game folder
GuiControl,, terrariaGameDir, %terrariaGameDir%
Gui, Submit, Nohide
IniWrite, %terrariaGameDir%, settings.ini, settings, terrariaGameDir
Return

MenuCheckToggle:
showOnStart := !showOnStart
Menu, Tray, ToggleCheck, Show Menu On Start
IniWrite, %showOnStart%, settings.ini, settings, showOnStart
GuiControl,, showOnStart, %showOnStart%
Gui, Submit, Nohide
Return

TrayLoadPreset(presetToLoad) {
	presetName := presetToLoad
	Gui, Main:Submit, Nohide
	for key, value in (preset_Array) {
		if (presetName = value) {
			for key, settingName in (categorySettings_Array) {
				setting := %settingName%
				IniRead, defaultSetting, settings.ini, defaults, %settingName%
				IniRead, %settingName%, settings.ini, %presetName%_Settings, %settingName%, %defaultSetting%
				if (setting = "ERROR") {
					setting := ""
				}
				%settingName% := setting
			}
			IniWrite, %presetName%, settings.ini, settings, presetName
		}
	}
	for key, value in (preset_Array) {
		if (presetName = value) {
			Menu, PresetMenu, Check, %value%
		} else {
			Menu, PresetMenu, Uncheck, %value%
		}
	}
	LoadPreset("tray")
}

LoadSettings() {
	OutputDebug, % "Loading settings..."
	IniRead, presetName, settings.ini, settings, presetName, Default
	IniRead, preset_Array, settings.ini, settings, preset_Array, Default

	if FileExist("resets/_globalresets.txt") {
		FileRead, globalResets, resets/_globalresets.txt
	} else {
		globalResets := 0
		FileAppend, %globalResets%, resets/_globalresets.txt
	}
	if FileExist("resets/" presetName "_resets.txt") {
		FileRead, presetResets, resets/%presetName%_resets.txt
	} else {
		presetResets := 0
		FileAppend, %presetResets%, resets/%presetName%_resets.txt
	}
	
	FileDelete, resets/_sessionresets.txt
	FileAppend, %sessionResets%, resets/_sessionresets.txt
	FileDelete, resets/_currentresets.txt
	FileAppend, %presetResets%, resets/_currentresets.txt
	FileDelete, resets/_category.txt
	FileAppend, %presetName%, resets/_category.txt
	
	preset_ArrayString := preset_Array
	preset_Array := StrSplit(preset_Array, "|")
	OutputDebug, % "Preset: " presetName
	for key, settingName in (categorySettings_Array) {
		setting := %settingName%
		IniRead, defaultSetting, settings.ini, defaults, %settingName%
		IniRead, setting, settings.ini, %presetName%_Settings, %settingName%, %defaultSetting%
		if (setting = "ERROR") {
			setting := ""
		}
		%settingName% := setting
	}
	for key, settingName in (macroSettings_Array) {
		setting := %settingName%
		IniRead, defaultSetting, settings.ini, defaults, %settingName%
		IniRead, setting, settings.ini, settings, %settingName%, %defaultSetting%
		if (setting = "ERROR") {
			setting := ""
		}
		%settingName% := setting
	}
	terrariaDir := StrReplace(terrariaDir, "A_MyDocuments", A_MyDocuments)
	global playerDir := terrariaDir "\Players"
	global worldDir := terrariaDir "\Worlds"
	SavePreset()
}

SavePreset() {
	if (A_GuiControl = "saveUnsaved") {
		presetName := unsavedPresetName
	}
	if (presetName ~= "\*|\|") {
		MsgBox % "Preset name cannot contain these characters: `n * |"
		Return
	}
		if (presetName = "") {
		presetName := "Default"
		OutputDebug, % "No preset found"
	}

	if (charStyle = "Default" || charStyle = "Random") {
		charStylePaste := ""
	} else {
		charStylePaste := StrReplace(charStylePaste, "`n")
		charStyle := "Paste"
	}

	for key, settingName in (categorySettings_Array) {
		setting := %settingName%
		IniWrite, %setting%, settings.ini, %presetName%_Settings, %settingName%
	}

	if (preset_Array.Length() = 0) {
		preset_Array.Push("Default")
	}

	preset_ArrayString := ""
	for index, preset in (preset_Array) {
		preset_ArrayString .= "|" . preset
		preset_ArrayString := LTrim(preset_ArrayString, "|")
		preset_ArrayString := LTrim(preset_ArrayString, A_Space)
	}

	for index, value in (preset_Array) {
		if (preset_Array[index] = presetName) {
			OutputDebug, % "Already saved " presetName
			SB_SetText("Saved Preset " presetName)
			Return
		}
	}

	preset_ArrayString .= "|" . presetName
	preset_Array.Push(presetName)

	for key, value in (preset_Array) {
		Menu, PresetMenu, Add, %value%, TrayLoadPreset, +Radio
	}

	OutputDebug, % "Saved " presetName

	if (presetResets = "") {
		presetResets := 0
	}

	FileAppend, %presetResets%, resets/%presetName%_resets.txt
	IniWrite, %preset_ArrayString%, settings.ini, settings, preset_Array
	GuiControl,,  presetName, |%preset_ArrayString%
	for index, preset in (preset_Array) {
		if (preset = presetName) {
			GuiControl, Choose, presetName, %index%
		}
	}
	LoadPreset()
}

LoadPreset(fromTray:=0) {
	Gui, Submit, Nohide
	for key, value in (preset_Array) {
		if (presetName = value) {
			OutputDebug, % "Setting preset to " presetName
			Menu, PresetMenu, Check, %value%
			for key, settingName in (categorySettings_Array) {
				setting := %settingName%
				IniRead, defaultSetting, settings.ini, defaults, %settingName%
				IniRead, %settingName%, settings.ini, %presetName%_Settings, %settingName%, %defaultSetting%
				if (setting = "ERROR") {
					setting := ""
				}
			}
			IniWrite, %presetName%, settings.ini, settings, presetName
			FileRead, presetResets, resets/%presetName%_resets.txt
			FileDelete, resets/_currentresets.txt
			FileAppend, %presetResets%, resets/_currentresets.txt
			FileDelete, resets/_category.txt
			FileAppend, %presetName%, resets/_category.txt
			if (fromTray != "tray") {
			GUIInit()
			}
			SB_SetText("Set Preset to " presetName)
		} else {
			Menu, PresetMenu, Uncheck, %value%
		}
	}
}

DeletePreset() {
	if (preset_Array[2] = "") {
		MsgBox % "You cannot delete all presets!"
		Return
	}

	Menu, PresetMenu, Delete, %presetName%

	for index, value in (preset_Array) {
		if (value = presetName) {
			preset_Array.RemoveAt(index)
		}
	}
	preset_ArrayString := ""
	for index, preset in (preset_Array) {
		preset_ArrayString .= "|" . preset
		preset_ArrayString := LTrim(preset_ArrayString, "|")
		preset_ArrayString := LTrim(preset_ArrayString, A_Space)
	}
	FileDelete, resets/%presetName%_resets.txt
	IniDelete, settings.ini, %presetName%_Settings
	IniWrite, %preset_ArrayString%, settings.ini, settings, preset_Array
	GuiControl,, presetName, |%preset_ArrayString%
	presetName := preset_Array[1]
	GuiControl, Choose, presetName, 1
	LoadPreset()
	for key, value in (preset_Array) {
		if (presetName = value) {
		Menu, PresetMenu, Check, %value%
	} else {
			Menu, PresetMenu, Uncheck, %value%
		}
	}
}

GUISaver() {
	Gui, Submit, Nohide
	if (presetName = "") {
		presetName := "Default"
		OutputDebug, % "No preset found"
	}

	varName := A_GuiControl
	var := %varName%

	if (varName = "multiplayer") {
		MultiplayerToggler()
	}

	if (varName = "charStylePaste") {
		var := StrReplace(charStylePaste, "`n")
		charStyle := "Paste"
		GuiControl, Enable, charStyle_Default
		GuiControl, Enable, charStyle_Random
	}

	if InStr(A_GuiControl, "_") {
		OutputDebug, % "Parsing..."
		varArray := StrSplit(A_GuiControl, "_")
		varName := varArray[1]
		var := varArray[2]
		varNameArray := varName "_Array"
		varNameArray := %varNameArray%

		OutputDebug, % "Split strings: " varName "," var

		if (varName = "multiplayerMethod") {
			if (var = "Host") {
				GuiControl, Disable, IPText
				GuiControl, Disable, IP
			} else {
				GuiControl, Enable, IPText
				GuiControl, Enable, IP
			}
		}

		for key, value in (varNameArray) {
			if (value != var) {
				GuiControl, Enable, %varName%_%value%
			} else if (value = var) {
				GuiControl, Disable, %varName%_%var%
			}
		}
	} 
	if (varName = "showOnStart") {
		OutputDebug, % "Reversing variable" " > " var
		var := showOnStart
		Menu, Tray, ToggleCheck, Show Menu On Start
	}

	%varName% := var

	for key, value in (macroSettings_Array) {
		if (varName = value) {
			IniWrite, %var%, settings.ini, settings, %varName%
		}
	}
	varNameLog := varName "_SB"
	OutputDebug, % "Set " varName " to " var
	SB_SetText("Set " %varNameLog% " to " var)
	Return
}

GUIInit() {
	OutputDebug, % "GUI Initialization..."
	OutputDebug, % presetName "!"
	for index, preset in (preset_Array) {
		if (preset = presetName) {
			GuiControl, Choose, presetName, %index%
		}
	}
	for key, varArray in (gui_Arrays) {
		varSplit := StrSplit(varArray, "_")
		varName := varSplit[1]
		var := %varName%
		for key, varSetting in (%varArray%) {
			if (varSetting = var) {
				GuiControl, Disable, %varName%_%varSetting%
			} else {
				GuiControl, Enable, %varName%_%varSetting%
			}
		}
	}
	GuiControl,, multiplayer, %multiplayer%
	GuiControl,, IP, %IP%
	GuiControl,, version, %version%
	GuiControl,, charName, %charName%
	GuiControl,, worldName, %worldName%
	GuiControl,, worldSeed, %worldSeed%
	GuiControl,, charStylePaste, %charStylePaste%

	if (multiplayerMethod = "Host") {
		GuiControl, Disable, IPText
		GuiControl, Disable, IP
	} else {
		GuiControl, Enable, IPText
		GuiControl, Enable, IP
	}
	MultiplayerToggler()
}

MultiplayerToggler() {
	if (multiplayer = 1) {
		GuiControl, Hide, settings
		Guicontrol, Hide, SnQ
		GuiControl, Show, settings2
		GuiControl, Show, SnQ2
		for key, value in (multiplayerVisible_Array) {
			GuiControl, Show, %value%
		}
	} else {
		for key, value in (multiplayerVisible_Array) {
			GuiControl, Hide, %value%
		}
		GuiControl, Hide, settings2
		Guicontrol, Hide, SnQ2
		GuiControl, Show, settings
		GuiControl, Show, SnQ
	}
	Gui, Main:Show, AutoSize, Terraria Reset Macro
}

Settings:
Gui, Settings:New, +OwnerMain
Gui, Main:+Disabled
Gui, -SysMenu

Gui, Add, GroupBox, h206 w170 Center Section, Settings
	Gui, Add, Checkbox, vpassthrough gGUISaver xs+15 yp+22 checked%passthrough%, Keybind passthrough
	passthrough_TT := "Whether your keybind will still be recognized by other programs. Especially useful when binding your macro and timer reset keys to the same key."
	Gui, Add, Checkbox, vshowOnStart gGUISaver xs+15 yp+22 checked%showOnStart%, Show menu on start
	showOnStart_TT := "Whether the macro GUI shows on start. The GUI can be opened at any time from the tray icon."
	Gui, Add, Checkbox, vmoveFiles gGUISaver xs+15 yp+22 checked%moveFiles%, Move player && world files
	moveFiles_TT := "Moves your players and worlds to a new folder while the macro is running to avoid deleting them."
	Gui, Add, Checkbox, vclearServers gGUISaver xs+15 yp+22 checked%clearServers%, Clear server history
	clearServers_TT := "Clear server history when running multiplayer. (only takes effect after game restart)"
	Gui, Add, Checkbox, vautoClose gGUISaver xs+15 yp+22 checked%autoClose%, Close macro with Terraria
	autoClose_TT := "Automatically close the macro when Terraria is no longer running."
	Gui, Add, Checkbox, vdontShowUnsavedPopup gGUISaver xs+15 yp+22 checked%dontShowUnsavedPopup%, Don't show unsaved popup
	dontShowUnsavedPopup_TT := "Skip the unsaved preset popup when your preset has unsaved changes."
	Gui, Add, Checkbox, vrunOnStart gGUISaver xs+15 yp+22 checked%runOnStart%, Run Terraria on start
	runOnStart_TT := "Run Terraria when the macro starts. (Requires game directory)"
	Gui, Add, Checkbox, vdisableSeasons gGUISaver xs+15 yp+22 checked%disableSeasons%, Disable seasonal events
	disableSeasons_TT := "Run Terraria as a different date if a seasonal event would be active. Does not effect other programs. (Requires game directory)"

	if (dontShowUnsavedPopup != 0) {
		GuiControl,, dontShowUnsavedPopup, 1
	}

Gui, Add, GroupBox, h185 w170 Section Center xs ys+214, Terraria Directories:
	Gui, Add, Text, xs+15 ys+22 vterrariaSavesDirText, Saves Directory (My Games):
	Gui, Add, Edit, r1 xs+15 yp+22 w140 vterrariaDir gGUISaver, %terrariaDir%
	terrariaDir_TT := "Terraria saves directory. Usually in the 'My Games' folder. Selected folder should be 'Terraria'."
	Gui, Add, Button, w140 gTerrariaDirectoryExplore, Explore
	Gui, Add, Text, xs+15 yp+30 vterrariaGameDirText, Game Directory:
	Gui, Add, Edit, r1 xs+15 yp+22 w140 vterrariaGameDir gGUISaver, %terrariaGameDir%
	terrariaGameDir_TT := "Terraria game directory. Usually a Steam directory. Selected folder should be 'Terraria'."
	Gui, Add, Button, w140 gTerrariaGameDirectoryExplore, Explore



Gui, Add, GroupBox, h148 w170 Section Center xs ys+193, Resets
	Gui, Add, Text, xs+15 ys+22 vglobalResetsText, Global Resets:
	Gui, Add, Text, xs+100 yp vglobalResetsNum w57, %globalResets%
	Gui, Add, Edit, xp-2 yp-2 vglobalResets w57 Hidden, %globalResets%
	Gui, Add, Text, xs+15 yp+22 vpresetResetsText, Preset Resets:
	Gui, Add, Text, xs+100 yp vpresetResetsNum w57, %presetResets%
	Gui, Add, Edit, xp-2 yp-2 vpresetResetsSettings w57 Hidden, %presetResets%
	Gui, Add, Text, xs+15 yp+22 vsessionResetsText, Session Resets:
	Gui, Add, Text, xs+100 yp vsessionResetsNum w57, %sessionResets%
	Gui, Add, Edit, xp-2 yp-2 vsessionResets w57 Hidden, %sessionResets%
	Gui, Add, DropDownList, xs+15 yp+26 w140 vresetSelection gResetSelection, %preset_ArrayString%
	Gui, Add, Button, xp yp+26 veditResets gEditResets w140, Edit Resets

	for index, preset in (preset_Array) {
		if (preset = presetName) {
			GuiControl, Choose, resetSelection, %index%
		}
	}
 	ResetSelection()
	
Gui, Add, Button, vsettingsSave gSettingsGuiClose xs yp+54 w170 h30, Save
Gui, Show, AutoSize Center, Settings
Return

ResetSelection() {
	Gui, Submit, Nohide
	FileRead, presetResets, resets/%resetSelection%_resets.txt
	GuiControl,, presetResetsNum, %presetResets%
	GuiControl,, presetResetsSettings, %presetResets%
}

EditResets:
editResetsVar := !editResetsVar

if (editResetsVar = 1) {
	GuiControl,, editResets, Save Resets
} else {
	GuiControl,, editResets, Edit Resets
	Gui, Submit, Nohide
	GuiControl,, globalResetsNum, %globalResets%
	GuiControl,, presetResetsNum, %presetResetsSettings%
	GuiControl,, sessionResetsNum, %sessionResets%

	FileDelete, resets/_globalresets.txt
	FileAppend, %globalResets%, resets/_globalresets.txt
	FileDelete, resets/%resetSelection%_resets.txt
	FileAppend, %presetResetsSettings%, resets/%resetSelection%_resets.txt
	FileDelete, resets/_sessionresets.txt
	FileAppend, %sessionResets%, resets/_sessionresets.txt

	if (presetName = resetSelection) {
		OutputDebug, % presetName " = " resetSelection
		presetResets := presetResetsSettings
	}
}

GuiControl, Hide%editResetsVar%, globalResetsNum
GuiControl, Hide%editResetsVar%, presetResetsNum
GuiControl, Hide%editResetsVar%, sessionResetsNum
GuiControl, Show%editResetsVar%, globalResets
GuiControl, Show%editResetsVar%, presetResetsSettings
GuiControl, Show%editResetsVar%, sessionResets
Return

SaveResets:
GuiControl, Show, editResets
GuiControl, Show, totalResetsNum
GuiControl, Show, sessionResetsNum
GuiControl, Hide, totalResetsEdit
GuiControl, Hide, sessionResetsEdit
GuiControl, Hide, saveEditResets
Gui, Submit, Nohide
FileDelete, resets/_globalresets.txt
FileAppend, %globalResets%, resets/_globalresets.txt
FileDelete, resets/%resetSelection%_resets.txt
FileAppend, %presetResets%, resets/%resetSelection%_resets.txt
FileDelete, resets/_sessionresets.txt
FileAppend, %sessionResets%, resets/_sessionresets.txt

Return

SnQ:
loop, parse, requiredFields, `,
{
	if (%A_LoopField% == "") {
		MsgBox, %A_LoopField% cannot be empty.
		Return
	}
}
for key, newSettingName in (categorySettings_Array) {
	newSetting := %newSettingName%
	IniRead, defaultSetting, settings.ini, defaults, %newSettingName%
	IniRead, oldSetting, settings.ini, %presetName%_Settings, %newSettingName%, %defaultSetting%
	if (oldSetting = "ERROR") {
		oldSetting := ""
	}
	
	if (newSetting != oldSetting) {
		OutputDebug, % newSettingName " " newSetting " != " oldSetting
		unsavedChanges := 1
	}
}
if (unsavedChanges != 1) {
	Gui, Main:Submit
	Gui, Main:Destroy
	goto Hotkey
	Return
}

if (dontShowUnsavedPopup = "Save" || dontShowUnsavedPopup = "1") {
	goto SaveUnsaved
	return
}
if (dontShowUnsavedPopup = "Load") {
	goto LoadUnsaved
	return
}
	Gui, Main:+Disabled
	Gui, UnsavedChanges:New, +OwnerMain
		Gui, Add, Text,, You have unsaved changes to your preset
		Gui, Add, ComboBox,vunsavedPresetName w242, %preset_ArrayString%

		for index, preset in (preset_Array) {
			if (preset = presetName) {
			GuiControl, Choose, unsavedPresetName, %index%
			}
		}

		Gui, Add, Checkbox, vdontShowUnsavedPopup, Don't show this again
		Gui, Add, Button,x+m yp-3 w50 vloadUnsaved gLoadUnsaved, Load
		Gui, Add, Button,x+m yp w50 vsaveUnsaved gSaveUnsaved, Save
		Gui, Show, Autosize Center, Unsaved Changes
	Return

SaveUnsaved:
Gui, Main:-Disabled
Gui, Submit
SavePreset()
unsavedChanges := 0
if (dontShowUnsavedPopup = 1) {
	dontShowUnsavedPopup := "Save"
	IniWrite, %dontShowUnsavedPopup%, settings.ini, settings, dontShowUnsavedPopup
}
Gui, Main:Submit
Gui, Main:Destroy
goto Hotkey
Return

LoadUnsaved:
Gui, Main:-Disabled
Gui, UnsavedChanges:Submit

presetName := unsavedPresetName
LoadPreset()
unsavedChanges := 0
if (dontShowUnsavedPopup = 1) {
	dontShowUnsavedPopup := "Load"
	IniWrite, %dontShowUnsavedPopup%, settings.ini, settings, dontShowUnsavedPopup
}
Gui, Main:Submit
Gui, Main:Destroy
goto Hotkey
Return

UnsavedChangesGuiClose:
Gui, Main:-Disabled
Gui, Submit
unsavedChanges := 0
Return

AutoClose:
OutputDebug, % "Ran AutoClose"
If (WinExist("ahk_exe terraria.exe")) {
	OutputDebug, % "Terraria exists"
	terrariaHasExisted := 1
	Return
}
if (!WinExist("ahk_exe terraria.exe") && terrariaHasExisted = 1) {
	OutputDebug, % "Terraria no longer exists. Exiting"
	ExitApp
}
OutputDebug, % "Terraria hasn't existed"
Return

IncorrectDirectoryGuiClose() {
	if !InStr(FileExist(terrariaDir), "D") {
		MsgBox, % "Error with Save Directory:`n" terrariaDir "`nis not a valid folder! Make sure the folder is correct and exists."
		Return
	}

	if !InStr(terrariaDir, "Terraria") {
		MsgBox % "Error with Save Directory:`n" terrariaDir "`nis not the Terraria saves directory! Make sure the directory is 'Terraria'"
		Return
	}

	if !InStr(FileExist(terrariaGameDir), "D") {
		MsgBox, % "Error with Game Directory:`n" terrariaGameDir "`nis not a valid folder! Make sure the folder is correct and exists."
		Return
	}

	if !FileExist(terrariaGameDir "/Terraria.exe") {
		MsgBox, % "Error with Game Directory:`n" terrariaGameDir "`ndoes not contain Terraria.exe!"
		Return
	}

	IniWrite, %terrariaDir%, settings.ini, settings, terrariaDir
	IniWrite, %terrariaGameDir%, settings.ini, settings, terrariaGameDir

	Gui, Main:-Disabled
	Gui, IncorrectDirectory:Submit
}

SettingsGuiClose() {
	if !InStr(FileExist(terrariaDir), "D") {
		MsgBox, % "Error with Save Directory:`n" terrariaDir "`nis not a valid folder! Make sure the folder is correct and exists."
		Return
	}

	if !InStr(terrariaDir, "Terraria") {
		MsgBox % "Error with Save Directory:`n" terrariaDir "`nis not the Terraria saves directory! Make sure the directory is 'Terraria'"
		Return
	}

	if !InStr(FileExist(terrariaGameDir), "D") {
		MsgBox, % "Error with Game Directory:`n" terrariaGameDir "`nis not a valid folder! Make sure the folder is correct and exists."
		Return
	}

	if !FileExist(terrariaGameDir "/Terraria.exe") {
		MsgBox, % "Error with Game Directory:`n" terrariaGameDir "`ndoes not contain Terraria.exe!"
		Return
	}

	for key, settingName in (macroSettings_Array) {
		setting := %settingName%
		IniWrite, %setting%, settings.ini, settings, %settingName%
	}
	Gui, Main:-Disabled
	Gui, Settings:Submit
}

MoveFiles() {
	global
	OutputDebug, % "Running MoveFiles() " moveFiles
	if !FileExist(playerDir "\_Temp") {
		FileCreateDir, %playerDir%\_Temp
	}
	if !FileExist(worldDir "\_Temp") {
		FileCreateDir, %worldDir%\_Temp
	}
	if !FileExist(playerDir "\_LastSession") {
		FileCreateDir, %playerDir%\_LastSession
	}
	if !FileExist(worldDir "\_LastSession") {
		FileCreateDir, %worldDir%\_LastSession
	}
	if (moveFiles = 1) {

	Loop, Files, %playerDir%\*, D F
	{
		if A_LoopFileName not in _Temp,_LastSession
		FileMoveDir, %playerDir%\%A_LoopFileName%, %playerDir%\_Temp\%A_LoopFileName%
		FileMove, %playerDir%\%A_LoopFileName%, %playerDir%\_Temp
	}
	Loop, Files, %playerDir%\_LastSession\*, D F
	{
		FileMoveDir, %playerDir%\_LastSession\%A_LoopFileName%, %playerDir%\%A_LoopFileName%
		FileMove, %playerDir%\_LastSession\%A_LoopFileName%, %playerDir%\
	}
		Loop, Files, %worldDir%\*, F
	{
		FileMove, %worldDir%\%A_LoopFileName%, %worldDir%\_Temp\
	}
			Loop, Files, %worldDir%\_LastSession\*, F
	{
		FileMove, %worldDir%\_LastSession\%A_LoopFileName%, %worldDir%\
	}
	moveFiles := 2
} else if (moveFiles = 2) {
		Loop, Files, %playerDir%\*, D F
	{
		if A_LoopFileName not in _Temp,_LastSession
		FileMoveDir, %playerDir%\%A_LoopFileName%, %playerDir%\_LastSession\%A_LoopFileName%
		FileMove, %playerDir%\%A_LoopFileName%, %playerDir%\_LastSession
	}
		Loop, Files, %playerDir%\_Temp\*, D F
	{
		FileMoveDir, %playerDir%\_Temp\%A_LoopFileName%, %playerDir%\%A_LoopFileName%
		FileMove, %playerDir%\_Temp\%A_LoopFileName%, %playerDir%\
	}
			Loop, Files, %worldDir%\*, F
	{
		FileMove, %worldDir%\%A_LoopFileName%, %worldDir%\_LastSession\
	}
			Loop, Files, %worldDir%\_Temp\*, F
	{
		FileMove, %worldDir%\_Temp\%A_LoopFileName%, %worldDir%\
	}
		moveFiles := 1
}
IniWrite, %moveFiles%, settings.ini, settings, moveFiles
Return
}

Exit:
ExitApp

MainGuiClose:
ExitApp

Exit() {
OutputDebug, % "Exit reason: " A_ExitReason
Gui, Submit
moveFiles()
Return
}

updateChecker() {
	global checkedForUpdate := 1
	
	whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
	whr.Open("GET", "https://raw.githubusercontent.com/iinterp/TerrariaResetMacro/main/version.txt", true)
	whr.Send()
	whr.WaitForResponse()
	global newMacroVersion := whr.responseText
	if (newMacroVersion !> macroVersion || newMacroVersion = ignoredMacroVersion) {
		Return
	}
		Gui, Updater:New, +OwnerMain
			Gui, Add, Text,, There is a new update available.
			Gui, Add, Text,center, v%macroVersion% > v%newMacroVersion%
			updateChangelogLink := "https://github.com/iinterp/TerrariaResetMacro/releases/tag/" newMacroVersion
			Gui, Add, Link, vchangelogLink, <a href="%updateChangelogLink%" >changelog</a>
			Gui, Add, Button, h30 w100 vignoreThisUpdate gIgnoreThisUpdate, Ignore this update
			Gui, Add, Button, h30 w100 x+m vremindMeLater gRemindMeLater, Remind me later
			Gui, Add, Button, h30 w100 x+m +Default vdownloadUpdate gDownloadUpdate, Download update
			Gui, Updater:Show, Autosize Center, Update Checker
			Gui, Main:+Disabled
		Return
	
		IgnoreThisUpdate:
		ignoredMacroVersion := newMacroVersion
		iniWrite, %ignoredMacroVersion%, settings.ini, settings, ignoredMacroVersion
		Gui, Main:-Disabled
		Gui, Updater:Submit
		Return
	
		RemindMeLater:
		Gui, Main:-Disabled
		Gui, Updater:Submit
		Return
	
		DownloadUpdate:
		updateDownloadLink := "https://raw.githubusercontent.com/iinterp/TerrariaResetMacro/release/" newMacroVersion "/TerrariaResetMacro.exe"
		UrlDownloadToFile, %updateDownloadLink%, %A_ScriptName%
		if (ErrorLevel != 0) {
			msgbox Failed to download update.
			}
		Gui, Main:-Disabled
		Gui, Updater:Submit
		Reload
		Return
}



;-----------------------------------------------------





Hotkey:
if (moveFiles = 1 && firstLaunch != 0 || moveFiles = 2 && firstLaunch != 0) {
	MoveFiles()
}
OutputDebug, % "Ran Hotkey label"
if (autoClose = 1) {
	SetTimer, AutoClose, 10000
}

if (!WinExist("ahk_exe terraria.exe")) {
	if (runOnStart = 1 && disableSeasons = 1 && seasonalActive = 1) {
		Run, %ComSpec% /c "RunAsDate.exe /movetime 01\01\2023 "%terrariaGameDir%\Terraria.exe"", %A_ScriptDir%/utils
		OutputDebug, % "Ran RunAsDate & " terrariaGameDir "\Terraria.exe"
	} else if (runOnStart = 1) {
		Run, "%terrariaGameDir%\Terraria.exe"
		OutputDebug, % "Ran " terrariaGameDir "\Terraria.exe"
	} else if (disableSeasons = 1 && seasonalActive = 1) {
		OutputDebug, % "waiting for terraria.exe"
		WinWait, ahk_exe terraria.exe
		sleep, 5000
		Run, %ComSpec% /c "RunAsDate.exe /movetime 01\01\2023 Attach:"%terrariaGameDir%\Terraria.exe"", %A_ScriptDir%/utils
		OutputDebug, % "ran RunAsDate:Attach"
	} 
} else if (disableSeasons = 1 && seasonalActive = 1 && hasLaunchedTerraria != 1) {
	Run, %ComSpec% /c "RunAsDate.exe /movetime 01\01\2023 Attach:"%terrariaGameDir%\Terraria.exe"", %A_ScriptDir%/utils
	OutputDebug, % "ran RunAsDate:Attach"
}

global hasLaunchedTerraria := 1
firstLaunch := 0

#IfWinActive ahk_exe Terraria.exe
if (passthrough = 1) {
Hotkey, ~%resetKeybind%, Reset
} else if (passthrough = 0) {
Hotkey, %resetKeybind%, Reset
}
Return

Reset:
charExist := FileExist(playerDir "\*.plr")
worldExist := FileExist(worldDir "\*.wld")
if (multiplayer = 1 && multiplayerMethod = "Join" && clearServers = 1) {
	FileDelete, %terrariaDir%/servers.dat
}
global oldClipboard := ClipboardAll

reset%resetMode%(charName, worldName, charExist, worldExist)
firstMacroLaunch := 0
Return

resetMouse(charName, worldName, charExist, worldExist) {
	global globalResets := resetCount("global")
	global presetResets := resetCount(presetName)
	global currentResets := presetResets
	global sessionResets := resetCount("session")
	charName := StrReplace(charName, "GLOBALRESETS", globalResets)
	charName := StrReplace(charName, "PRESETRESETS", presetResets)
	charName := StrReplace(charName, "SESSIONRESETS", sessionResets)
	worldName := StrReplace(worldName, "GLOBALRESETS", globalResets)
	worldName := StrReplace(worldName, "PRESETRESETS", presetResets)
	worldName := StrReplace(worldName, "SESSIONRESETS", sessionResets)
	if (multiplayer = 1) {
		sendMouse(2, 2.95)
		if (multiplayerMethod = "Host") {
			sendMouse(2, 2.05, 220)
		} else {
			sendMouse(2, 3.2, 220)
		}
	} else {
	sendMouse(2, 3.6, 220) ;singleplayer
	}
	if (charExist != "") {
	sendMouse(1.46, 2.88, 50) ;delete character
	sendMouse(2, 2.5, 200) ;delete character
	}
	sendMouse(1.66, 1.08, 200) ;new character

		if (charDifficulty != "Classic" || worldDifficulty = "Journey") { ;classic is pre selected
		if (charDifficulty = "Journey" || worldDifficulty = "Journey") { ;override and select journey if world difficulty is journey
			sendMouse(2.44, 2.3) ;journey
		} else if (charDifficulty = "Mediumcore") {
			sendMouse(2.44, 2) ;mediumcore
		} else if (charDifficulty = "Hardcore") {
			sendMouse(2.44, 1.9) ;hardcore
		}
	}
	if (charStyle != "Default") {
		sendMouse(2.56, 3, 75) ;character style
		if (charStyle = "Random") {
			sendMouse(1.88, 1.95) ;random style
		} else {
			clipboard := charStylePaste
			sendMouse(2, 1.95) ;paste style
		}
	}
	sendMouse(1.72, 1.7) ;create
	paste(charName)
	sendKey("enter", 1, 150)
	sendMouse(3.15, 2.88, 200) ;select character
	if (multiplayer = 1 && multiplayerMethod = "Join") {
		sendKey("z", 1,, "^")
		paste(IP)
		sendKey("enter", 2)
		sendMouse(2, 2)
		return
	}
	if (worldExist != "") {
	sendMouse(1.46, 2.9) ;delete world
	sendMouse(2, 2.5, 200) ;delete world
	}
	sendMouse(1.66, 1.08, 200) ;new world
	if (worldEvil != "Random") { ;random is pre selected
		if (worldEvil = "Corruption") {
			sendMouse(2, 2.15) ;corruption
		} else {
			sendMouse(1.65, 2.15) ;crimson
			}
	}
	if (worldDifficulty != "Classic" && charDifficulty != "Journey") { ;classic is preselected & journey is preselected for journey characters ;world difficulty / J = 2.5 / C = 2.15 / E = 1.85 / M = 1.65
		if (worldDifficulty = "Expert") {
			sendMouse(1.85, 2.45) ;expert
		} 
		if (worldDifficulty = "Master") {
			sendMouse(1.65, 2.45) ;master
		}
		if (worldDifficulty = "Journey") {
			sendMouse(2.55, 2.45)
		}

	}
	if (worldSize = "Small" && version >= "1.4.4") { ;small is preselected on <1.4.4
		sendMouse(2.4, 2.8) ;small
	} else if (worldSize = "Medium" && version < "1.4.4") { ;medium is preselected on 1.4.4+
		sendMouse(2, 2.8) ;medium
	} else if (worldSize = "Large") {
		sendMouse(1.67, 2.8) ;large
	}

	if (worldSeed != "") {
	sendMouse(2, 3.25) ;world seed
	paste(worldSeed)
	sendKey("enter", 1, 125)
	}
	if (worldName != "") {
	sendMouse(2, 3.9) ;world name
	paste(worldName)
	sendKey("enter", 1, 150)
	}
	sendMouse(1.72, 1.7) ;create
	sendMouse(2, 2)
	clipboard := oldClipboard
	oldClipboard := ""
}

sendMouse(X, Y, wait:="") {
	GetClientSize(WinExist(ahk_exe Terraria.exe), winWidth, winHeight)
	X := winWidth / X
	Y := winHeight / Y

	if (wait != "") {
	wait := wait * waitMultiplier
	} else {
		wait := keyWait
	}
	MouseMove, %X%, %Y%, 0
	Send, {click down}
	Sleep, %keyDuration%
	Send, {click up}
	Sleep, %wait%
}




GetClientSize(hWnd, ByRef w := "", ByRef h := "")
{
    VarSetCapacity(rect, 16)
    DllCall("GetClientRect", "ptr", hWnd, "ptr", &rect)
    w := NumGet(rect, 8, "int")
    h := NumGet(rect, 12, "int")
}


ResetKeyboard(charName, worldName, charExist, worldExist) {
	global globalResets := resetCount("global")
	global presetResets := resetCount(presetName)
	global currentResets := presetResets
	global sessionResets := resetCount("session")
	charName := StrReplace(charName, "GLOBALRESETS", globalResets)
	charName := StrReplace(charName, "PRESETRESETS", presetResets)
	charName := StrReplace(charName, "SESSIONRESETS", sessionResets)
	worldName := StrReplace(worldName, "GLOBALRESETS", globalResets)
	worldName := StrReplace(worldName, "PRESETRESETS", presetResets)
	worldName := StrReplace(worldName, "SESSIONRESETS", sessionResets)

	if (charExist = "" && firstMacroLaunch != 0) { ;fix for first time launch with no chars // goes to achievements and back
		sendKey("down", 2)
		sendKey("space", 1, 200)
		sendKey("down")
		sendKey("space", 1, 200)
	}

	if (multiplayer = 1) {
		sendKey("down") ;move to multiplayer
		sendKey("space")
		if (multiplayerMethod = "Host") {
			sendKey("down",2)
		}
	} else {
		sendKey("up") ;move to single player
	}
	sendKey("space", 1, 120) ;select
	if (charExist != "") {
		sendKey("right", 4) ;move to delete char
		sendKey("space", 2, 100) ;delete char
	}
	sendKey("down") ;move to back
	sendKey("right") ;move to new
	sendKey("space", 1, 200) ;new
	if (charDifficulty != "Classic" || worldDifficulty = "Journey") { ;classic is preselected
		if (charDifficulty = "Journey" || worldDifficulty = "Journey") { ;override and select journey if world difficulty is journey
			sendKey("up", 4)
			sendKey("space")
			if (charStyle = "Default") {
			sendKey("down", 4)
			} else {
				sendKey("up", 2)
			}
		} else if (charDifficulty = "Mediumcore") {
			sendKey("up", 2)
			sendKey("space")
			if (charStyle = "Default") {
			sendKey("down", 2)
			} else {
				sendKey("up", 4)
			}
		} else if (charDifficulty = "Hardcore") {
			sendKey("up")
			sendKey("space")
			if (charStyle = "Default") {
			sendKey("down", 1)
			} else {
				sendKey("up", 5)
			}
		}
		sendKey("right")
	}

	if (charStyle != "Default") {

		if (charDifficulty = "Classic") {
			sendKey("up", 6)
			sendKey("right")
		} 
		if (charStyle != "Default") {
			sendKey("space")
			sendKey("down", 2)
		}
		if (charStyle = "Random") {
			sendKey("right", 3)
		} else {
			sendKey("right", 2)
			clipboard := charStylePaste
		}
		sendKey("space")
		sendKey("down")
		sendKey("right")
	}
	sendKey("space", 1) ;name
	paste(charName) ;input name
	sendKey("enter") ;enter name
	sendKey("up", 1, 100) ;select char
	sendKey("space", 1, 100) ;select char
	if (multiplayer = 1 && multiplayerMethod = "Join") {
		sendKey("z", 1,, "^")
		paste(IP)
		sendKey("enter", 2)
		return
	}
	if (worldExist != "") {
	sendKey("right", 5) ;delete world
	sendKey("space", 1, 65) ;delete world
	sendKey("space", 1, 115) ;delete world
	}
	sendKey("down") ;move to back
	sendKey("right") ;move to new
	sendKey("space", 1, 160) ;open world
	sendKey("up") ;move to crimson
	if (worldEvil = "Corruption") {
		sendKey("left")
		sendKey("space") ;select corruption
		sendKey("right")
	} else if (worldEvil = "Crimson") {
		sendKey("space", 1) ;select crimson
		}
	sendKey("up")
	if (worldDifficulty != "Classic" && charDifficulty != "Journey") {
		if (worldDifficulty = "Expert") {
			sendKey("left")
			sendKey("space")
			sendKey("right")
		}
		if (worldDifficulty = "Master") {
			sendKey("space")
		}
	}
	sendKey("up")
	if (worldSize = "Large") {
		sendKey("space")
	}
	if (worldSize = "Medium" && version < "1.4.4")
	{
		sendKey("left")
		sendKey("space")
	}
	sendKey("up") ;move to seed
	if (worldSeed != "") {
		sendKey("space")
		paste(worldSeed)
		sendKey("enter", 1, 60)
	}
	if (worldName != "") {
		sendKey("up")
		sendKey("space")
		paste(worldName)
		sendKey("enter")
		sendKey("down")
	}
	sendKey("down") ;move to small
	if (worldSize = "Small" && version >= "1.4.4") {
		sendKey("space") ;select small
	}
		if (worldDifficulty = "Journey" && charDifficulty = "Journey") {
			sendKey("down")
			sendKey("space")
			sendKey("down", 2)
		} else {
		sendKey("down", 3) ;move to back
		}
	sendKey("right") ;move to create
	sendKey("space") ;create world
	clipboard := oldClipboard
	oldClipboard := ""
}
paste(paste, times:=1, wait:="") {
	if (wait != "") {
	keyWaitOld := keyWait
	keyWait := wait * waitMultiplier
	}
	loop, %times% {
		clipboard := paste
		send, ^{v down}
		sleep, %keyDuration%
		send, ^{v up}
		sleep, %keyWait%
	}
	if (wait != "") {
		keyWait := keyWaitOld
	}
}
sendKey(key, times:=1, wait:="", modifier:="") {
	if (wait != "") {
	wait := wait * waitMultiplier
	} else {
		wait := keyWait
	}
	loop, %times% {
		send, %modifier%{%key% down}
		sleep, %keyDuration%
		send, %modifier%{%key% up}
		sleep, %wait%
	}
}

resetCount(resetType) {
	currentPath := "resets/_currentresets.txt"
	filePath := Format("resets/{1}_resets.txt", resetType)
	if (!FileExist("resets")) {
		FileCreateDir, resets
	}
	if (!FileExist(filePath)) {
		FileAppend, 0, %filePath%
	}
	if (!FileExist(currentPath)) {
		FileAppend, 0, %currentPath%
	}

	FileRead resets, %filePath%
	resets++
	fileDelete, %filePath%
	fileAppend, %resets%, %filePath%
	if (resetType = presetName) {
		fileDelete, %currentPath%
		fileAppend, %resets%, %currentPath%
	}
	return resets
}