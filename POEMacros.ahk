#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#SingleInstance force
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
if not A_IsAdmin
{
    Run *RunAs "%A_ScriptFullPath%"
    ExitApp
}
; adam's mods for his storage usage.
~RButton & WheelDown::Send {Right}
~RButton & WheelUp::Send {Left}

#Ifwinactive, Path of Exile
~a::
SendInput, {Left}
SendInput, {End}
return

#Ifwinactive, Path of Exile
~d::
SendInput, {Right}
return


#Ifwinactive, Path of Exile
`::
	string:= "cports.exe /close * * * * PathOfExileSteam.exe"
	ltime := lastlogout + 1000
	if ( ltime < A_TickCount ) {
		Run, %string%
		lastlogout := A_TickCount
	}
return