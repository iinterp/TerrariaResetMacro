global version := 0.9
author := "interp"

global terrariaDir := A_MyDocuments "\My Games\Terraria"
global playerDir := terrariaDir "\Players"
global worldDir := terrariaDir "\Worlds"

#SingleInstance Force
CoordMode, Mouse, Client

global resetKeybind
global passthrough
global downpatch
global keyDuration
global waitMultiplier
global keyWait
global resetMode
global charDifficulty
global charStyle
global worldDifficulty
global worldSize
global worldEvil
global worldSeed
global multiplayer
global host
global join
global terrariaFolder
global IP
global moveFiles
global ignoreThisUpdate
global remindMeLater
global downloadUpdate
global ignoredVersion
global changelogLink

OnExit("Exit")

FileDelete, resets/session.txt

if (!FileExist(settings.ini)) {
	FileAppend,, settings.ini
}

iniRead, resetKeybind, settings.ini, macro, resetKeybind, %A_Space%
iniRead, passthrough, settings.ini, macro, passthrough, 1
iniRead, downpatch, settings.ini, macro, downpatch, 0
iniRead, showOnStart, settings.ini, macro, showOnStart, 1
iniRead, keyDuration, settings.ini, macro, keyDuration, 10
iniRead, waitMultiplier, settings.ini, macro, waitMultiplier, 1.0
iniRead, keyWait, settings.ini, macro, keyWait, 25
iniRead, moveFiles, settings.ini, macro, moveFiles, 1
iniRead, resetMode, settings.ini, macro, resetMode, Mouse
iniRead, ignoredVersion, settings.ini, macro, ignoredVersion

iniRead, charName, settings.ini, character, charName, TOTALRESETS
iniRead, charDifficulty, settings.ini, character, charDifficulty, 1
iniRead, charStyle, settings.ini, character, charStyle, 0

iniRead, worldName, settings.ini, world, worldName, %A_Space%
iniRead, worldDifficulty, settings.ini, world, worldDifficulty, 1
iniRead, worldSize, settings.ini, world, worldSize, 1
iniRead, worldEvil, settings.ini, world, worldEvil, 3
iniRead, worldSeed, settings.ini, world, worldSeed, %A_Space%

iniRead, multiplayer, settings.ini, multiplayer, multiplayer, 0
iniRead, host, settings.ini, multiplayer, host, 1
iniRead, terrariaFolder, settings.ini, multiplayer, terrariaFolder, C:\Program Files (x86)\Steam\steamapps\common\Terraria
iniRead, IP, settings.ini, multiplayer, IP, %A_Space%

FileRead, totalResets, resets/total.txt
sessionResets := 0

if (charStyle!=0 && charStyle!=1) {
	charStylePaste := charStyle
}

requiredFields := "resetKeybind,keyDuration,waitMultiplier,keyWait,charName"

if (moveFiles = 1 || moveFiles = 2) {
	MoveFiles()
}

If (WinExist(terraria.exe)) {
terrariaHasExisted := 1
}

Menu, Tray, Icon, assets/icon.png
Menu, Tray, NoStandard
Menu, Tray, Add, Open Menu, OpenConfig
Menu, Tray, Default, Open Menu
Menu, Tray, Click, 1
Menu, Tray, Tip, Terraria Reset Macro v%version%
Menu, Tray, Add, Show Menu On Start, ShowOnStart
if (showOnStart = 1) {
Menu, Tray, Check, Show Menu On Start
}
Menu, Tray, Add, Exit, Exit
if (showOnStart = 0) {
	Goto Hotkey
}
OpenConfig:
SetTimer, AutoClose, Off
Gui, Settings:Submit
Gui, Main:New

	Gui, Add, GroupBox, Section h60 w290 Center, Reset Mode:
		Gui, Add, Button, xs+15 ys+18 w120 h30 vmouseResetMode gMouseResetMode, Mouse
		Gui, Add, Button, xp+140 yp w120 h30 vkeyboardResetMode gKeyboardResetMode, Keyboard

	Gui, Add, GroupBox, xs ys+70 Section Center w290 h120, Macro Settings:
		Gui, Add, Text, xs+15 ys+18, Keybind:
		Gui, Add, Hotkey, w110 vresetKeybind gResetKeybind, %resetKeybind%
		resetKeybind_TT := "The keybind to press to activate the macro."
		Gui, Add, Text, xp yp+26, Key Duration:
		Gui, Add, Edit, w110 vkeyDuration gKeyDuration, %keyDuration%
		keyDuration_TT := "The time keys are held down for. Increase if the macro is missing inputs."
		Gui, Add, Text, xp+150 ys+18, Wait Multiplier:
		Gui, Add, Edit, w110 vwaitMultiplier gWaitMultiplier, %waitMultiplier%
		waitMultiplier_TT := "How long the macro should wait for loads. Increase if the macro is continuing too fast."
		Gui, Add, Text, xp yp+26, Key Buffer:
		Gui, Add, Edit, w110 vkeyWait gKeyWait, %keyWait%
		keyWait_TT := "The time between key presses. Increase if the macro is missing inputs."

	Gui, Add, GroupBox, Center Section xs ys+130 h50, Character Name:
		Gui, Add, Edit, xp+15 yp+18 r1 w110 vcharName gCharName, %charName%
		charName_TT := "Can use TOTALRESETS and SESSIONRESETS variables."

	Gui, Add, GroupBox, Center Section xs ys+60 h50, Character Difficulty:
		Gui, Add, Button, xp+15 yp+18 w20 vcharDifficultyJourney gCharDifficultyJourney, J
		Gui, Add, Button, x+m w20 vcharDifficultyClassic gCharDifficultyClassic, C
		Gui, Add, Button, x+m w20 vcharDifficultyMedium gCharDifficultyMedium, M
		Gui, Add, Button, x+m w20 vcharDifficultyHard gCharDifficultyHard, H

	Gui, Add, GroupBox, Center Section xs ys+60 h110, Character Style:
		Gui, Add, Button, xp+15 yp+18 w50 vcharStyleDefault gCharStyleDefault, Default
		Gui, Add, Button, x+m w50 vcharStyleRandom gCharStyleRandom, Random
		Gui, Add, Text,xs+15 yp+26, Paste Template:
		Gui, Add, Edit, r2 w110 vcharStylePaste gCharStylePaste, %charStylePaste%
		charStylePaste_TT := "Paste character template to use as style."

		Gui, Add, GroupBox, Center Section xs ys+120 h50, Multiplayer:
			Gui, Add, Checkbox, vmultiplayer gMultiplayer xs+15 yp+22 checked%multiplayer%, Multiplayer
		Gui, Add, Button, xs ys+66 w140 h40 vsettings gSettings, Settings
		Gui, Add, GroupBox, Center Section xs ys+60 h100 vmultiplayerSettings, Multiplayer Settings:
			Gui, Add, Button, xs+15 yp+22 w50 vhost gHost, Host
			Gui, Add, Button, x+m yp w50 vjoin gJoin, Join
			Gui, Add, Text, xs+15 yp+26 vIPText, IP:
			Gui, Add, Edit, xp yp+18 r1 w110 vIP gIP, %IP%

;----

	Gui, Add, GroupBox, Center xs+150 ym+200 Section h50, World Name:
		Gui, Add, Edit,r1 vworldName gWorldName w110 xp+15 yp+18, %worldName%
		worldName_TT := "Leave blank for random. Can use TOTALRESETS and SESSIONRESETS variables."
	Gui, Add, GroupBox, Center Section xs ys+60 h50, World Difficulty:
		Gui, Add, Button, xp+15 yp+18 w20 vworldDifficultyJourney gWorldDifficultyJourney, J
		Gui, Add, Button, x+m w20 vworldDifficultyClassic gWorldDifficultyClassic, C
		Gui, Add, Button, x+m w20 vworldDifficultyExpert gWorldDifficultyExpert, E
		Gui, Add, Button, x+m w20 vworldDifficultyMaster gWorldDifficultyMaster, M
	Gui, Add, GroupBox, Center Section xs ys+60 h50, World Size:
		Gui, Add, Button, xp+15 yp+18 w30 vworldSizeSmall gWorldSizeSmall, S
		Gui, Add, Button, x+m w30 vworldSizeMedium gWorldSizeMedium, M
		Gui, Add, Button, x+m w30 vworldSizeLarge gWorldSizeLarge, L
	Gui, Add, GroupBox, Center Section xs ys+60 h50, World Evil:
		Gui, Add, Button, xp+15 yp+18 w30 vworldEvilRandom gWorldEvilRandom, Ran
		Gui, Add, Button, x+m w30 vworldEvilCrimson gWorldEvilCrimson, Crim
		Gui, Add, Button, x+m w30 vworldEvilCorruption gWorldEvilCorruption, Corr
	Gui, Add, GroupBox, Center Section xs ys+60 h50, World Seed:
		Gui, Add, Edit,r1 vworldSeed gWorldSeed w110 xp+15 yp+18, %worldSeed%
		worldSeed_TT := "Leave blank for random."
	Gui, Add, Button, xs ys+66 w140 h40 vSnQ gSnQ, Save
	Gui, Add, Button, xs ys+66 w140 h40 vsettings2 gSettings, Settings
	Gui, Add, Button, xs yp+54 w140 h40 vSnQ2 gSnQ, Save

	if (resetMode = "Mouse") {
		GuiControl, Disable, mouseResetMode
	} else if (resetMode = "Keyboard") {
		GuiControl, Disable, keyboardResetMode
	}

	if (charDifficulty=1) {
		GuiControl, Disable, charDifficultyClassic
	} else if (charDifficulty=2) {
		GuiControl, Disable, charDifficultyMedium
	} else if (charDifficulty=3) {
		GuiControl, Disable, charDifficultyHard
	} else if (charDifficulty=4) {
		GuiControl, Disable, charDifficultyJourney
	}

	if (charStyle=0) {
		GuiControl, Disable, charStyleDefault
	} else if (charStyle=1) {
		GuiControl, Disable, charStyleRandom
	}

	if (worldDifficulty=1) {
		GuiControl, Disable, worldDifficultyClassic
	} else if (worldDifficulty=2) {
		GuiControl, Disable, worldDifficultyExpert
	} else if (worldDifficulty=3) {
		GuiControl, Disable, worldDifficultyMaster
	} else if (worldDifficulty=4) {
		GuiControl, Disable, worldDifficultyJourney
	}

	if (worldSize=1) {
		GuiControl, Disable, worldSizeSmall
	} else if (worldSize=2) {
		GuiControl, Disable, worldSizeMedium
	} else if (worldSize=3) {
		GuiControl, Disable, worldSizeLarge
	}

	if (worldEvil=1) {
		GuiControl, Disable, worldEvilRandom
	} else if (worldEvil=2) {
		GuiControl, Disable, worldEvilCorruption
	} else if (worldEvil=3) {
		GuiControl, Disable, worldEvilCrimson
	}

	if (host=1) {
		GuiControl, Disable, host
	}
		if (host=0) {
		GuiControl, Disable, join
	}

	GuiControl, Disable%host%, IPText
	GuiControl, Disable%host%, IP

	If (multiplayer!=1) {
	GuiControl, Hide, multiplayerSettings
	GuiControl, Hide, host
	GuiControl, Hide, join
	GuiControl, Hide, terrariaFolderText
	GuiControl, Hide, terrariaFolder
	GuiControl, Hide, IPText
	GuiControl, Hide, IP
	GuiControl, Hide, Settings2
	GuiControl, Hide, SnQ2
}
	If (multiplayer=1) {
	GuiControl, Hide, Settings
	GuiControl, Hide, SnQ
	}

Gui, Add, StatusBar,vstatusBar, Terraria Reset Macro v%version%
Gui, Show, AutoSize Center, Terraria Reset Macro
OnMessage(0x0200, "WM_MOUSEMOVE")

if (checkedForUpdate != 1) {
	updateChecker()
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

MouseResetMode:
	resetMode := "Mouse"
	GuiControl, Disable, mouseResetMode
	GuiControl, Enable, keyboardResetMode
	iniWrite, %resetMode%, settings.ini, macro, resetMode
Return

KeyboardResetMode:
	resetMode := "Keyboard"
	GuiControl, Disable, keyboardResetMode
	GuiControl, Enable, mouseResetMode
	iniWrite, %resetMode%, settings.ini, macro, resetMode
Return

CharName:
Gui, Submit, NoHide
iniWrite, %charName%, settings.ini, character, charName
SB_SetText("Character name set to " charName)
Return

CharDifficultyJourney:
charDifficulty := 4
charDifficultyMouse := 2.3
iniWrite, %charDifficulty%, settings.ini, character, charDifficulty
GuiControl, Disable, charDifficultyJourney 
GuiControl, Enable, charDifficultyClassic 
GuiControl, Enable, charDifficultyMedium 
GuiControl, Enable, charDifficultyHard
SB_SetText("Character difficulty set to Journey")
Return

CharDifficultyClassic:
charDifficulty := 1

iniWrite, %charDifficulty%, settings.ini, character, charDifficulty
GuiControl, Enable, charDifficultyJourney 
GuiControl, Disable, charDifficultyClassic 
GuiControl, Enable, charDifficultyMedium 
GuiControl, Enable, charDifficultyHard
SB_SetText("Character difficulty set to Classic")
Return

CharDifficultyMedium:
charDifficulty := 2

iniWrite, %charDifficulty%, settings.ini, character, charDifficulty
GuiControl, Enable, charDifficultyJourney 
GuiControl, Enable, charDifficultyClassic 
GuiControl, Disable, charDifficultyMedium 
GuiControl, Enable, charDifficultyHard
SB_SetText("Character difficulty set to Mediumcore")
Return

CharDifficultyHard:
charDifficulty := 3

iniWrite, %charDifficulty%, settings.ini, character, charDifficulty
GuiControl, Enable, charDifficultyJourney 
GuiControl, Enable, charDifficultyClassic 
GuiControl, Enable, charDifficultyMedium 
GuiControl, Disable, charDifficultyHard
SB_SetText("Character difficulty set to Hardcore")
Return

CharStyleDefault:
charStyle := 0
iniWrite, %charStyle%, settings.ini, character, charStyle
GuiControl, Disable, charStyleDefault
GuiControl, Enable, charStyleRandom
SB_SetText("Character style set to Default")
Return

CharStyleRandom:
charStyle := 1

iniWrite, %charStyle%, settings.ini, character, charStyle
GuiControl, Enable, charStyleDefault
GuiControl, Disable, charStyleRandom
SB_SetText("Character style set to Random")
Return

CharStylePaste:
Gui, Submit, Nohide
charStylePaste := StrReplace(charStylePaste, "`n")
charStyleMouse := 2
charStyle := charStylePaste
if (charStyle = "") {
	charStyle = 0
	iniWrite, %charStyle%, settings.ini, character, charStyle
	GuiControl, Disable, charStyleDefault
	GuiControl, Enable, charStyleRandom
	SB_SetText("Character style set to Default")
} else {
charStyle := charStylePaste
iniWrite, %charStyle%, settings.ini, character, charStyle
GuiControl, Enable, charStyleDefault
GuiControl, Enable, charStyleRandom
SB_SetText("Character style set to Custom")
}
Return

ResetKeybind:
Gui, Submit, Nohide
iniWrite, %resetKeybind%, settings.ini, macro, resetKeybind
SB_SetText("Keybind set to " resetKeybind)
Return

KeyWait:
Gui, Submit, Nohide
iniWrite, %keyWait%, settings.ini, macro, keyWait
SB_SetText("Key Buffer set to " keyWait)
Return

KeyDuration:
Gui, Submit, Nohide
iniWrite, %keyDuration%, settings.ini, macro, keyDuration
SB_SetText("Key Duration set to " keyDuration)
Return

WaitMultiplier:
Gui, Submit, Nohide
iniWrite, %waitMultiplier%, settings.ini, macro, waitMultiplier
SB_SetText("Key Modifier set to " waitMultiplier)
Return

WorldName:
Gui, Submit, NoHide
iniWrite, %worldName%, settings.ini, world, worldName
SB_SetText("World name set to " worldName)
Return

WorldDifficultyJourney:
worldDifficulty := 4

iniWrite, %worldDifficulty%, settings.ini, world, worldDifficulty
GuiControl, Disable, worldDifficultyJourney 
GuiControl, Enable, worldDifficultyClassic 
GuiControl, Enable, worldDifficultyExpert 
GuiControl, Enable, worldDifficultyMaster
SB_SetText("World difficulty set to Journey")
Return

WorldDifficultyClassic:
worldDifficulty := 1

iniWrite, %worldDifficulty%, settings.ini, world, worldDifficulty
GuiControl, Enable, worldDifficultyJourney 
GuiControl, Disable, worldDifficultyClassic 
GuiControl, Enable, worldDifficultyExpert 
GuiControl, Enable, worldDifficultyMaster
SB_SetText("World difficulty set to Classic")
Return

WorldDifficultyExpert:
worldDifficulty := 2

iniWrite, %worldDifficulty%, settings.ini, world, worldDifficulty
GuiControl, Enable, worldDifficultyJourney 
GuiControl, Enable, worldDifficultyClassic 
GuiControl, Disable, worldDifficultyExpert 
GuiControl, Enable, worldDifficultyMaster
SB_SetText("World difficulty set to Expert")
Return

WorldDifficultyMaster:
worldDifficulty := 3

iniWrite, %worldDifficulty%, settings.ini, world, worldDifficulty
GuiControl, Enable, worldDifficultyJourney 
GuiControl, Enable, worldDifficultyClassic 
GuiControl, Enable, worldDifficultyExpert 
GuiControl, Disable, worldDifficultyMaster
SB_SetText("World difficulty set to Master")
Return

WorldSizeSmall:
worldSize := 1
iniWrite, %worldSize%, settings.ini, world, worldSize
GuiControl, Disable, worldSizeSmall
GuiControl, Enable, worldSizeMedium
GuiControl, Enable, worldSizeLarge
SB_SetText("World size set to Small")
Return

WorldSizeMedium:
worldSize := 2

iniWrite, %worldSize%, settings.ini, world, worldSize
GuiControl, Enable, worldSizeSmall
GuiControl, Disable, worldSizeMedium
GuiControl, Enable, worldSizeLarge
SB_SetText("World size set to Medium")
Return

WorldSizeLarge:
worldSize := 3

iniWrite, %worldSize%, settings.ini, world, worldSize
GuiControl, Enable, worldSizeSmall
GuiControl, Enable, worldSizeMedium
GuiControl, Disable, worldSizeLarge
SB_SetText("World size set to Large")
Return

WorldEvilRandom:
worldEvil := 1
iniWrite, %worldEvil%, settings.ini, world, worldEvil
GuiControl, Disable, worldEvilRandom
GuiControl, Enable, worldEvilCorruption
GuiControl, Enable, worldEvilCrimson
SB_SetText("World size set to Random")
Return

WorldEvilCorruption:
worldEvil := 2
iniWrite, %worldEvil%, settings.ini, world, worldEvil
GuiControl, Enable, worldEvilRandom
GuiControl, Disable, worldEvilCorruption
GuiControl, Enable, worldEvilCrimson
SB_SetText("World size set to Corruption")
Return

WorldEvilCrimson:
worldEvil := 3
iniWrite, %worldEvil%, settings.ini, world, worldEvil
GuiControl, Enable, worldEvilRandom
GuiControl, Enable, worldEvilCorruption
GuiControl, Disable, worldEvilCrimson
SB_SetText("World size set to Crimson")
Return

WorldSeed:
Gui, Submit, NoHide
iniWrite, %worldSeed%, settings.ini, world, worldSeed
SB_SetText("World seed set to " worldSeed)
Return

Multiplayer:
Gui, Submit, NoHide
iniWrite, %multiplayer%, settings.ini, multiplayer, multiplayer
	GuiControl, Show%multiplayer%, multiplayerSettings
	GuiControl, Show%multiplayer%, host
	GuiControl, Show%multiplayer%, join
	GuiControl, Show%multiplayer%, IPText
	GuiControl, Show%multiplayer%, IP
	if (host=1) {
		GuiControl, Disable, IPText
		GuiControl, Disable, IP
	} else if (host=0) {
		GuiControl, Enable, IPText
		GuiControl, Enable, IP
	} else {
		GuiControl, Hide, IPText
		GuiControl, Hide, IP
	}

	GuiControl, Hide%multiplayer%, settings
	GuiControl, Hide%multiplayer%, SnQ
	GuiControl, Show%multiplayer%, settings2
	GuiControl, Show%multiplayer%, SnQ2
Gui, Show, AutoSize Center, Terraria Reset Macro
if (multiplayer) {
SB_SetText("Multiplayer Enabled")
} else {
SB_SetText("Multiplayer Disabled")
}
Return

Host:
host := 1
join := 0
iniWrite, %host%, settings.ini, multiplayer, host
GuiControl, Disable, host
GuiControl, Enable, join
GuiControl, Disable, IPText
GuiControl, Disable, IP
SB_SetText("Multiplayer mode set to Host")
Return

Join:
host := 0
join := 1
iniWrite, %host%, settings.ini, multiplayer, host
GuiControl, Enable, host
GuiControl, Disable, join
GuiControl, Enable, IPText
GuiControl, Enable, IP
SB_SetText("Multiplayer mode set to Join")
Return

TerrariaFolder:
Gui, Submit, Nohide
iniWrite, %terrariaFolder%, settings.ini, multiplayer, terrariaFolder
SB_SetText("Terraria Folder set to " terrariaFolder)
Return

IP:
Gui, Submit, Nohide
iniWrite, %IP%, settings.ini, multiplayer, IP
SB_SetText("IP set to " IP)
Return

Settings:
;Gui, Destroy
Gui, Settings:New, +OwnerMain
Gui, Main:+Disabled

Gui, Add, GroupBox, h162 w170 Center Section, Settings
	Gui, Add, Checkbox, vpassthrough xs+15 yp+22 checked%passthrough%, Keybind passthrough
	passthrough_TT := "Whether your keybind will still be recognized by other programs. Especially useful when binding your macro and livesplit reset keys to the same key."
	Gui, Add, Checkbox, vdownpatch xs+15 yp+22 checked%downpatch%, Downpatched (<v1.4.4)
	downpatch_TT := "Enable for the macro to function on versions before 1.4.4."
	Gui, Add, Checkbox, vshowOnStart gShowOnStart xs+15 yp+22 checked%showOnStart%, Show menu on start
	showOnStart_TT := "Whether the macro GUI shows on start. The GUI can be opened at any time from the tray icon."
	Gui, Add, Checkbox, vmoveFiles xs+15 yp+22 checked%moveFiles%, Move files
	moveFiles_TT := "Moves your players and worlds to a new folder while the macro is running to avoid deleting them."
	Gui, Add, Checkbox, vclearServers xs+15 yp+22 checked%clearServers%, Clear server history
	clearServers_TT := "Clear server history when running multiplayer (only takes effect after game restart)"
	Gui, Add, Checkbox, vautoClose xs+15 yp+22 checked%autoClose%, Close macro with Terraria
	autoClose_TT := "Automatically close the macro when Terraria is no longer running."
Gui, Add, GroupBox, h100 w170 Section Center xs ys+172, Resets
	Gui, Add, Text, xs+15 yp+22 vtotalResetsText, Total Resets: %totalResets%
	Gui, Add, Text, xp yp+22 vsessionResetsText, Session Resets: %sessionResets%
	Gui, Add, Button, xp yp+22 vwipeResets gWipeResets w140 h25, Wipe Resets
Gui, Add, Button, vsettingsSave gSettingsSave xs w170 h30, Save
Gui, Show, AutoSize Center, Settings
Return

WipeResets:
	totalResets := 0
	sessionResets := 0
	FileDelete, resets/total.txt
	FileAppend, 0, resets/total.txt
	FileDelete, resets/session.txt
	FileAppend, 0, resets/session.txt
	GuiControl, Text, totalResetsText, Total Resets: %totalResets%
	GuiControl, Text, sessionResetsText, Session Resets: %sessionResets%
	Gui, Submit, Nohide
Return

SnQ:
loop, parse, requiredFields, `,
{
	if (%A_LoopField% == "") {
		MsgBox, %A_LoopField% cannot be empty.
		Return
	}
}
Gui, Submit
Gui, Destroy
goto Hotkey
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
SettingsSave:
Gui, Main:-Disabled
Gui, Submit
iniWrite, %passthrough%, settings.ini, macro, passthrough
iniWrite, %downpatch%, settings.ini, macro, downpatch
SB_SetText("Updated Settings")
Return

ShowOnStart:
if (A_GuiControl != showOnStart) {
	if (showOnStart = 1) {
		showOnStart = 0
	} else {
		showOnStart = 1
		}
}
Gui, Submit, Nohide
Menu, Tray, ToggleCheck, Show Menu On Start
iniWrite, %showOnStart%, settings.ini, macro, showOnStart
Return

MoveFiles() {
	OutputDebug, % "Running MoveFiles() " moveFiles
if !FileExist("%playerDir%\_Temp") {
	FileCreateDir, %playerDir%\_Temp
}
if !FileExist("%worldDir%\_Temp") {
	FileCreateDir, %worldDir%\_Temp
}
if !FileExist("%playerDir%\_LastSession") {
	FileCreateDir, %playerDir%\_LastSession
}
if !FileExist("%worldDir%\_LastSession") {
	FileCreateDir, %worldDir%\_LastSession
}
if (moveFiles = 1) {

	OutputDebug, % "Running MoveFiles() 1!"
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
		OutputDebug, % "Running MoveFiles() 2!"
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
IniWrite, %moveFiles%, settings.ini, macro, moveFiles
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
	global newVersion := whr.responseText
	if (newVersion !> version || newVersion = ignoredVersion) {
		Return
	}
		Gui, Updater:New, +OwnerMain
			Gui, Add, Text,, There is a new update available.
			Gui, Add, Text,center, v%version% > v%newVersion%
			if (changeloglink != "") {
				Gui, Add, Link, vchangelogLink, <a href="%changelogLink%">changelog</a>
			}
			Gui, Add, Button, h30 w100 vignoreThisUpdate gIgnoreThisUpdate, Ignore this update
			Gui, Add, Button, h30 w100 x+m vremindMeLater gRemindMeLater, Remind me later
			Gui, Add, Button, h30 w100 x+m +Default vdownloadUpdate gDownloadUpdate, Download update
			Gui, Updater:Show, Autosize Center, Update Checker
			Gui, Main:+Disabled
		Return
	
		IgnoreThisUpdate:
		ignoredVersion := newVersion
		iniWrite, %ignoredVersion%, settings.ini, macro, ignoredVersion
		Gui, Main:-Disabled
		Gui, Updater:Submit
		Return
	
		RemindMeLater:
		Gui, Main:-Disabled
		Gui, Updater:Submit
		Return
	
		DownloadUpdate:
		UrlDownloadToFile, https://raw.githubusercontent.com/iinterp/TerrariaResetMacro/main/TerrariaResetMacro.ahk, %A_ScriptName%
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
OutputDebug, % "Ran Hotkey label"
if (autoClose = 1) {
	SetTimer, AutoClose, 10000
}
#IfWinActive ahk_exe Terraria.exe
if (passthrough = 1) {
Hotkey, ~%resetKeybind%, Reset
} else if (passthrough = 0) {
Hotkey, %resetKeybind%, Reset
}
Return

Reset:
splitCleanup()
charExist := FileExist(playerDir "\*.plr")
worldExist := FileExist(worldDir "\*.wld")
if (multiplayer = 1 && host = 0 && clearServers = 1) {
	FileDelete, C:/Users/interp/Documents/My Games/Terraria/servers.dat
}
global oldClipboard := ClipboardAll

reset%resetMode%(charName, worldName, charExist, worldExist)
Return

resetMouse(charName, worldName, charExist, worldExist) {
	global totalResets := resetCount("total")
	global sessionResets := resetCount("session")
	charName := StrReplace(charName, "TOTALRESETS", totalResets)
	charName := StrReplace(charName, "SESSIONRESETS", sessionResets)
	worldName := StrReplace(worldName, "TOTALRESETS", totalResets)
	worldName := StrReplace(worldName, "SESSIONRESETS", sessionResets)
	if (multiplayer = 1) {
		sendMouse(2, 2.95)
		if (host) {
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

		if (charDifficulty != 1 || worldDifficulty = 4) { ;classic is pre selected
		if (charDifficulty = 4 || worldDifficulty = 4) { ;override and select journey if world difficulty is journey
			sendMouse(2.44, 2.3) ;journey
		} else if (charDifficulty = 2) {
			sendMouse(2.44, 2) ;mediumcore
		} else if (charDifficulty = 3) {
			sendMouse(2.44, 1.9) ;hardcore
		}
	}
	if (charStyle != 0) {
		sendMouse(2.56, 3, 75) ;character style
		if (charStyle = 1) {
			sendMouse(1.88, 1.95) ;random style
		} else {
			sendMouse(2, 1.95) ;paste style
		}
	}
	sendMouse(1.72, 1.7) ;create
	paste(charName)
	sendKey("enter", 1, 150)
	sendMouse(3.15, 2.88, 200) ;select character
	if (multiplayer = 1 && host = 0) {
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
	if (worldEvil != 1) { ;random is pre selected
		if (worldEvil = 2) {
			sendMouse(2, 2.15) ;corruption
		} else {
			sendMouse(1.65, 2.15) ;crimson
			}
	}
	if (worldDifficulty != 1 && charDifficulty != 4) { ;classic is preselected & journey is preselected for journey characters ;world difficulty / J = 2.5 / C = 2.15 / E = 1.85 / M = 1.65
		if (worldDifficulty = 2) {
			sendMouse(1.85, 2.45) ;expert
		} 
		if (worldDifficulty = 3) {
			sendMouse(1.65, 2.45) ;master
		}
		if (worldDifficulty = 4) {
			sendMouse(2.55, 2.45)
		}

	}

	if (worldSize = 1 && downpatch != 1) { ;small is preselected on downpatch
		sendMouse(2.4, 2.8) ;small
	} else if (worldSize = 2 && downpatch = 1) { ;medium is preselected on current patch
		sendMouse(2, 2.8) ;medium
	} else if (worldSize = 3) {
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
	keyWaitOld := keyWait
	keyWait := wait * waitMultiplier
	}
	MouseMove, %X%, %Y%, 0
	Send, {click down}
	Sleep, %keyDuration%
	Send, {click up}
	Sleep, %keyWait%
	if (wait != "") {
		keyWait := keyWaitOld
	}
}




GetClientSize(hWnd, ByRef w := "", ByRef h := "")
{
    VarSetCapacity(rect, 16)
    DllCall("GetClientRect", "ptr", hWnd, "ptr", &rect)
    w := NumGet(rect, 8, "int")
    h := NumGet(rect, 12, "int")
}


ResetKeyboard(charName, worldName, charExist, worldExist) {
	global totalResets := resetCount("total")
	global sessionResets := resetCount("session")
	charName := StrReplace(charName, "TOTALRESETS", totalResets)
	charName := StrReplace(charName, "SESSIONRESETS", sessionResets)
	worldName := StrReplace(worldName, "TOTALRESETS", totalResets)
	worldName := StrReplace(worldName, "SESSIONRESETS", sessionResets)

	if (multiplayer = 1) {
		sendKey("down") ;move to multiplayer
		sendKey("space")
		if (host = 1) {
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
	if (charDifficulty != 1 || worldDifficulty = 4) { ;classic is preselected
		if (charDifficulty = 4 || worldDifficulty = 4) { ;override and select journey if world difficulty is journey
			sendKey("up", 4)
			sendKey("space")
			if (charStyle = 0) {
			sendKey("down", 4)
			} else {
				sendKey("up", 2)
			}
		} else if (charDifficulty = 2) {
			sendKey("up", 2)
			sendKey("space")
			if (charStyle = 0) {
			sendKey("down", 2)
			} else {
				sendKey("up", 4)
			}
		} else if (charDifficulty = 3) {
			sendKey("up")
			sendKey("space")
			if (charStyle = 0) {
			sendKey("down", 1)
			} else {
				sendKey("up", 5)
			}
		}
		sendKey("right")
	}

	if (charStyle != 0) {

		if (charDifficulty = 1) {
			sendKey("up", 6)
			sendKey("right")
		} 
		if (charStyle != 0) {
			sendKey("space")
			sendKey("down", 2)
		}
		if (charStyle = 1) {
			sendKey("right", 3)
		} else {
			sendKey("right", 2)
			clipboard := charStyle
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
	if (multiplayer = 1 && host = 0) {
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
	if (worldEvil = 2) {
		sendKey("left")
		sendKey("space") ;select corruption
		sendKey("right")
	} else if (worldEvil = 3) {
		sendKey("space", 1) ;select crimson
		}
	sendKey("up")
	if (worldDifficulty != 1 && charDifficulty != 4) {
		if (worldDifficulty = 2) {
			sendKey("left")
			sendKey("space")
			sendKey("right")
		}
		if (worldDifficulty = 3) {
			sendKey("space")
		}
	}
	sendKey("up")
	if (worldSize = 3) {
		sendKey("space")
	}
	if (worldSize = 2 && downpatch = 1)
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
	if (worldSize = 1 && downpatch = 0) {
		sendKey("space") ;select small
	}
		if (worldDifficulty = 4 && charDifficulty = 4) {
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
	keyWaitOld := keyWait
	keyWait := wait * waitMultiplier
	}
	loop, %times% {
		send, %modifier%{%key% down}
		sleep, %keyDuration%
		send, %modifier%{%key% up}
		sleep, %keyWait%
	}
	if (wait != "") {
		keyWait := keyWaitOld
	}
}

resetCount(resetType) {
	filePath := Format("resets/{1}.txt", resetType)
	if (!FileExist(resets)) {
		FileCreateDir, resets
	}
	if (!FileExist(filePath)) {
		FileAppend, 0, %filePath%
	}

	FileRead num, %filePath%
	num++
	fileDelete, %filePath%
	fileAppend, %num%, %filePath%
	return num
}

splitCleanup() {
	FileDelete, %A_MyDocuments%/LiveSplit/_Terraria.log
	FileAppend,, %A_MyDocuments%/LiveSplit/_Terraria.log
}