#NoEnv 
#SingleInstance force
SendMode Input  
SetWorkingDir %A_ScriptDir%  
if not A_IsAdmin ; admin is needed to make sure it can kill off the connection. 
{
    Run *RunAs "%A_ScriptFullPath%"
    ExitApp
}

^End::
	SoundPlay *64 
	ExitApp
Return


; Storage Tools 
; =============================================================================
#Ifwinactive, Path of Exile
~RButton & WheelDown::
	Send {Right}
return

#Ifwinactive, Path of Exile
~RButton & WheelUp::
	Send {Left}
return

#Ifwinactive, Path of Exile
~a::
	SendInput, {Left}
	SendInput, {End}
return

#Ifwinactive, Path of Exile
~d::
	SendInput, {Right}
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
