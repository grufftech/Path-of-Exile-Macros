

; == Function Stuff =======================================

FunctionPostItemData(URL, ItemData, InteractiveCheck)
{
  ; This is for debug purposes, it should be commented out in normal use
  ; MsgBox, %URL%
  ; MsgBox, %ItemData%
  
  ; URI Encode ItemData to avoid any problem
  ItemData := FunctionUriEncode(ItemData)
  
  if (InteractiveCheck = "isInteractive") {
    temporaryContent = Submitting interactive search to exiletools.com...
    FunctionShowToolTipPriceInfo(temporaryContent)	
  } else {
    temporaryContent = Submitting item information to exiletools.com...
    FunctionShowToolTipPriceInfo(temporaryContent)
    ; Create PostData
    Global PostData = "v=" . runVersion . "&itemData=" . ItemData . "&league=" . LeagueName . "&showDays=" . showDays . ""  
  }
  
  ; Send the PostData to my server and check the response!
  whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
  whr.Open("POST", URL)
  whr.SetRequestHeader("Content-Type","application/x-www-form-urlencoded")
  whr.Send(PostData)
  rawcontent := whr.ResponseText
  
  ; The return data has a special line that can be pasted into chat/etc., this
  ; separates that out and copies it to the clipboard.
  StringSplit, responsecontent, rawcontent,^ 
  clipboard = %responsecontent2%
  
  FunctionShowToolTipPriceInfo(responsecontent1)    
}

; This is for the tooltip, so it shows it and starts a timer that watches mouse movement.
; I imagine there's a better way of doing this. The crazy long name is to avoid
; overlap with other scripts in case people try to combine these into one big script.

FunctionShowToolTipPriceInfo(responsecontent)
{
    ; Get position of mouse cursor
    Sleep, 2
	Global X
    Global Y
    MouseGetPos, X, Y	
	gui, font, s15, Verdana 
    ToolTip, %responsecontent%, X - 135, Y + 30
    SetTimer, SubWatchCursorPrice, 100     

}

; == The Goods =====================================

; Watches the mouse cursor to get rid of the tooltip after too much movement
SubWatchCursorPrice:
  MouseGetPos, CurrX, CurrY
  MouseMoved := (CurrX - X)**2 + (CurrY - Y)**2 > MouseMoveThreshold**2
  If (MouseMoved)
  {
    SetTimer, SubWatchCursorPrice, Off
    ToolTip
  }
return


FunctionReadItemFromClipboard() {
  ; Only does anything if POE is the window with focus
  IfWinActive, Path of Exile ahk_class Direct3DWindowClass
  {
    ; Send a ^C to copy the item information to the clipboard
	; Note: This will trigger any Item Info/etc. script that monitors the clipboard
    Send ^c
    ; Wait 250ms - without this the item information doesn't get to the clipboard in time
    Sleep 250
	; Get what's on the clipboard
    ClipBoardData = %clipboard%
    ; Split the clipboard data into strings to make sure it looks like a properly
	; formatted item, looking for the Rarity: tag in the first line. Just in case
	; something weird got copied to the clipboard.
	StringSplit, data, ClipBoardData, `n, `r
		
	; Strip out extra CR chars so my unix side server doesn't do weird things
	StringReplace RawItemData, ClipBoardData, `r, , A

	; If the first line on the clipboard has Rarity: it is probably some item
	; information from POE, so we'll send it to my server to process. Otherwise
	; we just don't do anything at all.
    IfInString, data1, Rarity:
    {
	  ; Do POST / etc.	  
	  FunctionPostItemData(URL, RawItemData, "notInteractive")
	
	} 	
  }  
}



; Stole this from here: http://www.autohotkey.com/board/topic/75390-ahk-l-unicode-uri-encode-url-encode-function/
; Hopefully it works right!
FunctionUriEncode(Uri, Enc = "UTF-8")
{
	StrPutVar(Uri, Var, Enc)
	f := A_FormatInteger
	SetFormat, IntegerFast, H
	Loop
	{
		Code := NumGet(Var, A_Index - 1, "UChar")
		If (!Code)
			Break
		If (Code >= 0x30 && Code <= 0x39 ; 0-9
			|| Code >= 0x41 && Code <= 0x5A ; A-Z
			|| Code >= 0x61 && Code <= 0x7A) ; a-z
			Res .= Chr(Code)
		Else
			Res .= "%" . SubStr(Code + 0x100, -1)
	}
	SetFormat, IntegerFast, %f%
	Return, Res
}
StrPutVar(Str, ByRef Var, Enc = "")
{
	Len := StrPut(Str, Enc) * (Enc = "UTF-16" || Enc = "CP1200" ? 2 : 1)
	VarSetCapacity(Var, Len, 0)
	Return, StrPut(Str, &Var, Enc)
}