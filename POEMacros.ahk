#SingleInstance force
#NoEnv 
#Persistent ; Stay open in background
SendMode Input 
StringCaseSense, On ; Match strings with case.
SetWorkingDir %A_ScriptDir%  
Menu, tray, Tip, Exile Tools Price Check

If (A_AhkVersion <= "1.1.22")
{
    msgbox, You need AutoHotkey v1.1.22 or later to run this script. `n`nPlease go to http://ahkscript.org/download and download a recent version.
    exit
}

if not A_IsAdmin ; admin is needed to make sure it can kill off the connection. 
{
    Run *RunAs "%A_ScriptFullPath%"
    ExitApp
}

global LeagueName := "darkshrinehc"
;global LeagueName := "tempest"
;global LeagueName := "standard"
;global LeagueName := "hardcore"

global showDays := "7"
global runVersion := "5.1"
Global URL = "http://api.exiletools.com/item-report-text"
MouseMoveThreshold := 40
CoordMode, Mouse, Screen
CoordMode, ToolTip, Screen


; Command Macros. 

^End::
  SoundPlay *64 
  Reload
Return

; Storage Tools 
; =============================================================================
#Ifwinactive, Path of Exile
~+WheelDown::
	Send {Right}
return

#Ifwinactive, Path of Exile
~+WheelUp::
	Send {Left}
return

#Ifwinactive, Path of Exile
~a::
	SendInput, {Left}{End}
return

#Ifwinactive, Path of Exile
~d::
	SendInput, {Right}
return


#Ifwinactive, Path of Exile
~q::
	SendInput, {Left 5}{End}
return

#Ifwinactive, Path of Exile
~e::
  SendInput, {Right 5}
return

#Ifwinactive, Path of Exile
~+a::
  SendInput, {Left 40}{End}
return

#Ifwinactive, Path of Exile
~+d::
  SendInput, {Right 40}
return



; Quick Disconnect. 
; ============================================================================
#Ifwinactive, Path of Exile
`::
	string:= "cports.exe /close * * * * PathOfExileSteam.exe"
	ltime := lastlogout + 1000
	if ( ltime < A_TickCount ) {
		Run, %string%
		lastlogout := A_TickCount
	}
return


; Utility Macros
; F2 = Hideout
; F3 = Remaining Monsters
; F4 = itemlevel
; F5 = Party Invite the last person who PM'ed you.
; ============================================================================
#Ifwinactive, Path of Exile
~F2::
	BlockInput On
	SendInput, {Enter}
	Sleep 2
	SendInput, {/}hideout
	SendInput, {Enter}
	BlockInput Off
	return
return

#Ifwinactive, Path of Exile
~F3::
	BlockInput On
	SendInput, {Enter}
	Sleep 2
	SendInput, {/}remaining
	SendInput, {Enter}
	BlockInput Off
	return
return

#Ifwinactive, Path of Exile
~F4::
	BlockInput On
	SendInput, {Enter}
	Sleep 2
	SendInput, {/}itemlevel
	SendInput, {Enter}
	BlockInput Off
	return
return

#Ifwinactive, Path of Exile
~F5::
	BlockInput On
	Send ^{Enter}{Home}{Delete}/invite {Enter}
	BlockInput Off
	return
return

; Chat Macros
; Alt + 1 tells the pm-er you're in a map. 
; Alt + 2 thanks the pm-er. 
; ============================================================================

#IfWinActive, Path of Exile
LAlt & 1::
	BlockInput On
	SendInput, ^{Enter}
	Sleep 2
	SendInput, one moment please, I'm in a map.
	SendInput, {Enter}
	BlockInput Off
	return
return

#IfWinActive, Path of Exile
LAlt & 2::
	BlockInput On
	SendInput, ^{Enter}
	Sleep 2
	SendInput, thanks for trade -- stay safe!
	SendInput, {Enter}
	BlockInput Off
	return
return




; Price check w/ auto filters
; default is shift+f
#Ifwinactive, Path of Exile
+f::
IfWinActive, Path of Exile ahk_class Direct3DWindowClass 
{
  FunctionReadItemFromClipboard()
}
return

#include poelib.ahk