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
global charStylePaste
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
global ignoredVersion
global changelogLink
global terrariaDir
global showOnStart

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

FileDelete, resets/session.txt

if (!FileExist(settings.ini)) {
	FileAppend,, settings.ini
}

iniRead, resetKeybind, settings.ini, settings, resetKeybind, %A_Space%
iniRead, passthrough, settings.ini, settings, passthrough, 1
iniRead, downpatch, settings.ini, settings, downpatch, 0
iniRead, showOnStart, settings.ini, settings, showOnStart, 1
iniRead, keyDuration, settings.ini, settings, keyDuration, 10
iniRead, waitMultiplier, settings.ini, settings, waitMultiplier, 1.0
iniRead, keyWait, settings.ini, settings, keyWait, 25
iniRead, moveFiles, settings.ini, settings, moveFiles, 1
iniRead, resetMode, settings.ini, settings, resetMode, Mouse
iniRead, ignoredVersion, settings.ini, settings, ignoredVersion
iniRead, terrariaDir, settings.ini, settings, terrariaDir, %A_MyDocuments%\My Games\Terraria
iniRead, clearServers, settings.ini, settings, clearServers, 0
iniRead, autoClose, settings.ini, settings, autoClose, 1

iniRead, charName, settings.ini, settings, charName, TOTALRESETS
iniRead, charDifficulty, settings.ini, settings, charDifficulty, Classic
iniRead, charStyle, settings.ini, settings, charStyle, Default
iniRead, charStylePaste, settings.ini, settings, charStylePaste, %A_Space%

iniRead, worldName, settings.ini, settings, worldName, %A_Space%
iniRead, worldDifficulty, settings.ini, settings, worldDifficulty, Classic
iniRead, worldSize, settings.ini, settings, worldSize, Small
iniRead, worldEvil, settings.ini, settings, worldEvil, Crimson
iniRead, worldSeed, settings.ini, settings, worldSeed, %A_Space%

iniRead, multiplayer, settings.ini, settings, multiplayer, 0
iniRead, multiplayerMethod, settings.ini, settings, multiplayerMethod, Host
iniRead, IP, settings.ini, settings, IP, %A_Space%

global playerDir := terrariaDir "\Players"
global worldDir := terrariaDir "\Worlds"

FileRead, totalResets, resets/total.txt
sessionResets := 0

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
Menu, Tray, Add, Show Menu On Start, MenuCheckToggle
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
		Gui, Add, Button, xs+15 ys+18 w120 h30 vresetMode_Mouse gGUISaver, Mouse
		Gui, Add, Button, xp+140 yp w120 h30 vresetMode_Keyboard gGUISaver, Keyboard

	Gui, Add, GroupBox, xs ys+70 Section Center w290 h120, Macro Settings:
		Gui, Add, Text, xs+15 ys+18, Keybind:
		Gui, Add, Hotkey, w110 vresetKeybind gGUISaver, %resetKeybind%
		resetKeybind_TT := "The keybind to press to activate the macro."
		Gui, Add, Text, xp yp+26, Key Duration:
		Gui, Add, Edit, w110 vkeyDuration gGUISaver, %keyDuration%
		keyDuration_TT := "The time keys are held down for. Increase if the macro is missing inputs."
		Gui, Add, Text, xp+150 ys+18, Wait Multiplier:
		Gui, Add, Edit, w110 vwaitMultiplier gGUISaver, %waitMultiplier%
		waitMultiplier_TT := "How long the macro should wait for loads. Increase if the macro is continuing too fast."
		Gui, Add, Text, xp yp+26, Key Buffer:
		Gui, Add, Edit, w110 vkeyWait gGUISaver, %keyWait%
		keyWait_TT := "The time between key presses. Increase if the macro is missing inputs."

	Gui, Add, GroupBox, Center Section xs ys+130 h50, Character Name:
		Gui, Add, Edit, xp+15 yp+18 r1 w110 vcharName gGUISaver, %charName%
		charName_TT := "Can use TOTALRESETS and SESSIONRESETS variables."

	Gui, Add, GroupBox, Center Section xs ys+60 h50, Character Difficulty:
		Gui, Add, Button, xp+15 yp+18 w20 vcharDifficulty_Journey gGUISaver, J
		Gui, Add, Button, x+m w20 vcharDifficulty_Classic gGUISaver, C
		Gui, Add, Button, x+m w20 vcharDifficulty_Mediumcore gGUISaver, M
		Gui, Add, Button, x+m w20 vcharDifficulty_Hardcore gGUISaver, H

	Gui, Add, GroupBox, Center Section xs ys+60 h110, Character Style:
		Gui, Add, Button, xp+15 yp+18 w50 vcharStyle_Default gGUISaver, Default
		Gui, Add, Button, x+m w50 vcharStyle_Random gGUISaver, Random
		Gui, Add, Text,xs+15 yp+26, Paste Template:
		Gui, Add, Edit, r2 w110 vcharStylePaste gGUISaver, %charStylePaste%
		charStylePaste_TT := "Paste character template to use as style."

		Gui, Add, GroupBox, Center Section xs ys+120 h50, Multiplayer:
			Gui, Add, Checkbox, vmultiplayer gMultiplayerToggler xs+15 yp+22 checked%multiplayer%, Multiplayer
		Gui, Add, Button, xs ys+66 w140 h40 vsettings gSettings, Settings
		Gui, Add, GroupBox, Center Section xs ys+60 h100 vmultiplayerSettings, Multiplayer Settings:
			Gui, Add, Button, xs+15 yp+22 w50 vmultiplayerMethod_Host gGUISaver, Host
			Gui, Add, Button, x+m yp w50 vmultiplayerMethod_Join gGUISaver, Join
			Gui, Add, Text, xs+15 yp+26 vIPText, IP:
			Gui, Add, Edit, xp yp+18 r1 w110 vIP gGUISaver, %IP%

;----

	Gui, Add, GroupBox, Center xs+150 ym+200 Section h50, World Name:
		Gui, Add, Edit,r1 vworldName gGUISaver w110 xp+15 yp+18, %worldName%
		worldName_TT := "Leave blank for random. Can use TOTALRESETS and SESSIONRESETS variables."
	Gui, Add, GroupBox, Center Section xs ys+60 h50, World Difficulty:
		Gui, Add, Button, xp+15 yp+18 w20 vworldDifficulty_Journey gGUISaver, J
		Gui, Add, Button, x+m w20 vworldDifficulty_Classic gGUISaver, C
		Gui, Add, Button, x+m w20 vworldDifficulty_Expert gGUISaver, E
		Gui, Add, Button, x+m w20 vworldDifficulty_Master gGUISaver, M
	Gui, Add, GroupBox, Center Section xs ys+60 h50, World Size:
		Gui, Add, Button, xp+15 yp+18 w30 vworldSize_Small gGUISaver, S
		Gui, Add, Button, x+m w30 vworldSize_Medium gGUISaver, M
		Gui, Add, Button, x+m w30 vworldSize_Large gGUISaver, L
	Gui, Add, GroupBox, Center Section xs ys+60 h50, World Evil:
		Gui, Add, Button, xp+15 yp+18 w30 vworldEvil_Random gGUISaver, Ran
		Gui, Add, Button, x+m w30 vworldEvil_Crimson gGUISaver, Crim
		Gui, Add, Button, x+m w30 vworldEvil_Corruption gGUISaver, Corr
	Gui, Add, GroupBox, Center Section xs ys+60 h50, World Seed:
		Gui, Add, Edit,r1 vworldSeed gGUISaver w110 xp+15 yp+18, %worldSeed%
		worldSeed_TT := "Leave blank for random."
	Gui, Add, Button, xs ys+66 w140 h40 vSnQ gSnQ, Save
	Gui, Add, Button, xs ys+66 w140 h40 vsettings2 gSettings, Settings
	Gui, Add, Button, xs yp+54 w140 h40 vSnQ2 gSnQ, Save

GUIInit()

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

Settings:
;Gui, Destroy
Gui, Settings:New, +OwnerMain
Gui, Main:+Disabled

Gui, Add, GroupBox, h162 w170 Center Section, Settings
	Gui, Add, Checkbox, vpassthrough gGUISaver xs+15 yp+22 checked%passthrough%, Keybind passthrough
	passthrough_TT := "Whether your keybind will still be recognized by other programs. Especially useful when binding your macro and livesplit reset keys to the same key."
	Gui, Add, Checkbox, vdownpatch gGUISaver xs+15 yp+22 checked%downpatch%, Downpatched (<v1.4.4)
	downpatch_TT := "Enable for the macro to function on versions before 1.4.4."
	Gui, Add, Checkbox, vshowOnStart gGUISaver xs+15 yp+22 checked%showOnStart%, Show menu on start
	showOnStart_TT := "Whether the macro GUI shows on start. The GUI can be opened at any time from the tray icon."
	Gui, Add, Checkbox, vmoveFiles gGUISaver xs+15 yp+22 checked%moveFiles%, Move files
	moveFiles_TT := "Moves your players and worlds to a new folder while the macro is running to avoid deleting them."
	Gui, Add, Checkbox, vclearServers gGUISaver xs+15 yp+22 checked%clearServers%, Clear server history
	clearServers_TT := "Clear server history when running multiplayer (only takes effect after game restart)"
	Gui, Add, Checkbox, vautoClose gGUISaver xs+15 yp+22 checked%autoClose%, Close macro with Terraria
	autoClose_TT := "Automatically close the macro when Terraria is no longer running."

Gui, Add, GroupBox, h80 w170 Section Center xs ys+172, Terraria Directory:
	Gui, Add, Edit, r1 xs+15 yp+22 w140 vterrariaDir gGUISaver, %terrariaDir%
	Gui, Add, Button, w140 gTerrariaDirectoryExplore, Explore

Gui, Add, GroupBox, h100 w170 Section Center xs ys+90, Resets
	Gui, Add, Text, xs+15 yp+22 vtotalResetsText, Total Resets: %totalResets%
	Gui, Add, Text, xp yp+22 vsessionResetsText, Session Resets: %sessionResets%
	Gui, Add, Button, xp yp+22 vwipeResets gWipeResets w140 h25, Wipe Resets

Gui, Add, Button, vsettingsSave gSettingsSave xs w170 h30, Save
Gui, Show, AutoSize Center, Settings
Return

TerrariaDirectoryExplore:
FileSelectFolder, terrariaDir,, Select root Terraria folder
GuiControl,, terrariaDir, %terrariaDir%
Gui, Submit, Nohide
IniWrite, %terrariaDir%, settings.ini, macro, terrariaDir
Return

MenuCheckToggle:
showOnStart := !showOnStart
Menu, Tray, ToggleCheck, Show Menu On Start
IniWrite, %showOnStart%, settings.ini, settings, showOnStart
GuiControl,, showOnStart, %showOnStart%
Gui, Submit, Nohide
Return

GUISaver() {
Gui, Submit, Nohide
OutputDebug, % "Variable to save: " A_GuiControl

varName := A_GuiControl
var := %varName%

if (varName = "charStylePaste") {
	var := StrReplace(charStylePaste, "`n")
	charStyle := "Paste"
	IniWrite, %charStyle%, settings.ini, settings, charStyle
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
} else if (varName = "showOnStart") {
	OutputDebug, % "Reversing variable" " > " var
	var := showOnStart
	Menu, Tray, ToggleCheck, Show Menu On Start
}

IniWrite, %var%, settings.ini, settings, %varName%
%varName% := var
OutputDebug, % "Set " varName " to " var
SB_SetText("Set " varName " to " var)
Return
}

GUIInit() {
	for buttonKey, buttonArray in (gui_Arrays) {
		buttonVarArray := StrSplit(buttonArray, "_")
		buttonVarName := buttonVarArray[1]
		buttonArray := %buttonArray%

		for buttonNestedKey, buttonNestedValue in (buttonArray) {
			buttonVar := %buttonVarName%
			if (buttonNestedValue != buttonVar) {
				GuiControl, Disable, %buttonVarName%_%buttonVar%
			}
		}
	}

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
	Gui, Submit, Nohide
	if (multiplayer = 1) {
		GuiControl, Hide, settings
		Guicontrol, Hide, SnQ
		GuiControl, Show, settings2
		GuiControl, Show, SnQ2
		for multiplayerKey, multiplayerValue in (multiplayerVisible_Array) {
			GuiControl, Show, %multiplayerValue%
		}
	} else {
		for multiplayerKey, multiplayerValue in (multiplayerVisible_Array) {
			GuiControl, Hide, %multiplayerValue%
		}
		GuiControl, Hide, settings2
		Guicontrol, Hide, SnQ2
		GuiControl, Show, settings
		GuiControl, Show, SnQ
	}
	Gui, Show, AutoSize Center, Terraria Reset Macro
	IniWrite, %multiplayer%, settings.ini, settings, multiplayer
}

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
		iniWrite, %ignoredVersion%, settings.ini, settings, ignoredVersion
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
if (multiplayer = 1 && multiplayerMethod = "Join" && clearServers = 1) {
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

	if (worldSize = "Small" && downpatch != 1) { ;small is preselected on downpatch
		sendMouse(2.4, 2.8) ;small
	} else if (worldSize = "Medium" && downpatch = 1) { ;medium is preselected on current patch
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
	if (worldSize = "Medium" && downpatch = 1)
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
	if (worldSize = "Small" && downpatch = 0) {
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