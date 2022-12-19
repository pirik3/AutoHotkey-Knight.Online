;=============================================
;~ Hotkeys (all can be modified in Coloretta.ini):


;~ Exit: Shift+Esc
;~ Anchor Magnifier: Shift+Control+LeftClick
;~ Show Tray Tip: Shift+F1
;~ Show Welcome Message/Help: F1


;~ Color Picking Related Hotkeys:

;~ Pick Hex-RGB: Ctrl-RightClick
;~ Pick HumanReadable-RGB Shift-Control-RightClick
;~ Paste Red Channel 0-255 Value: Ctrl-1 (can only be done after you use the Pick HumanReadable-RGB hotkey)
;~ Paste Green Channel Value: Ctrl-2 (same as above)
;~ Paste Blue Channel Value: Ctrl-3 (same as above)
;~ Pick Hex-BGR: Ctrl-LeftClick
;==============================================
; Coloretta Viva v 1.6.1 by thebunnyrules
;
; Many thanks to Sumon and Nimda for their respective work on "Colorette" and "ColorPicker/Magnifyer" which were the foundations over which I built Coloretta Viva.
;
; History:
; v 1.6.1 - 3 June 2017
; 	- Fix DPI Scaling Issue when running coloretta in higher DPI setting like 200%. The script is now conscious of what DPI setting your windows is at and will adjust the geometry of the magnifier and it's placement accordingly. Tested on all Window DPI setting 100% to 200%. 
;
; v 1.5.1 - 3 June 2017 - Initial Release

;
#NoEnv
SetBatchLines -1
CoordMode Mouse
CoordMode Pixel
Gui -Caption +AlwaysOnTop +LastFound ;  +Owner
IfNotExist, Coloretta.ini
{
firstrun=true
}
else
{
firstrun=false
}


; =========================================
; Ini Preferences
IniRead, ShowUsageBoxINI,Coloretta.ini, Messages, ShowUsageBox, true
IniRead, ShowUsageTipINI,Coloretta.ini, Messages, ShowUsageTip, true
IniRead, PauseBetweenMagnifyerRefresh,Coloretta.ini, Magnifyer, PauseBetweenRefresh,17 
					; Tell script how much time (ms) to wait before next magnifier 
					; redraw & color sample. 17 give you a refresh rate of 60FPS, 
IniRead, Square,Coloretta.ini, Magnifyer, PixelScale,20 ; The size in pixels of each fake "pixel" in magnifyer windows
IniRead, Num,Coloretta.ini, Magnifyer, NumOfPixels, 9 ;Number of pixels per row and column
IniRead, CursorType,Coloretta.ini, User Interface,CursorType,IDC_IBEAM ;
IniRead, ChangeCursor,Coloretta.ini, User Interface,ChangeCursor,true
; HOTKEYS 
; Hotkeys will automatically update in help messages when changed in ini.
; On the other hand, if you add new hotkeys that did not exist before, 
; please add them to help message and tray tip in the functions: ShowTrayTip() and ShowHelp() 												  
IniRead, PickBGRKey,Coloretta.ini, Hotkeys, PickBGRKey,^LButton													  
IniRead, PickRGBKey,Coloretta.ini, Hotkeys, PickRGBKey,^RButton													  
IniRead, PickRGB255Key,Coloretta.ini, Hotkeys, PickRGB255Key,+^RButton												  
IniRead, PasteR255Key,Coloretta.ini, Hotkeys, PasteR255Key,^1													  
IniRead, PasteG255Key,Coloretta.ini, Hotkeys, PasteG255Key,^2													  
IniRead, PasteB255Key,Coloretta.ini, Hotkeys, PasteB255Key,^3													  
IniRead, PauseKey,Coloretta.ini, Hotkeys, PauseKey,+^LButton													  
IniRead, QuitAppKey,Coloretta.ini, Hotkeys, QuitAppKey,+Esc													  
IniRead, ShowHelpKey,Coloretta.ini, Hotkeys, ShowHelpKey,F1													  
IniRead, ShowTrayTipKey,Coloretta.ini, Hotkeys, ShowTrayTipKey,+F1													  
											  
													  


;============================================
; Write ini file if it doesn't exist

;write comments in the ini file but only if it doesn't exist already
if (%firstrun%=true)
{
_iniwrite("Coloretta.ini","User Interface","ChangeCursor",ChangeCursor,"The most useful cursors: are IDC_IBEAM and IDC_CROSS, you can lookup the rest on MS's website:`n`;https://msdn.microsoft.com/en-us/library/windows/desktop/ms648391%28v=vs.85%29.aspx","Set to false if you don't want Coloretta to change your curse")

_iniwrite("Coloretta.ini","Magnifyer","PauseBetweenRefresh",PauseBetweenRefresh,"PixelScale resprensents how many times each pixel is being magnified. NumOfPixels is how many magnified pixels are represented in magnifier box. Always used ODD NUMBERS for NumOfPixels or the color picker will be off","Magnifier FPS = 1000/PauseBetweenRefresh. A 17ms pause gives you 60FPS. Adjust Accordingly if you want to.")

_iniwrite("Coloretta.ini","Hotkeys","PickBGRKey",PickBGRKey,"","Use the AutoHotkey standard for modding the hotkeys`: `n`; + `= Shift`n`; `^ `= Control`n`; `# `= WindowsKey`n`; `! `= Alt`n`; LButton `= Left Mouse Key`n`; MButton `= Middle Click`n`; RButton `= Rigt Click")
}

;write out the rest of settings
IniWrite,%ShowUsageBoxINI%,Coloretta.ini, Messages, ShowUsageBox
IniWrite,%ShowUsageTipINI%,Coloretta.ini, Messages, ShowUsageTip
IniWrite,%PauseBetweenMagnifyerRefresh%,Coloretta.ini, Magnifyer, PauseBetweenRefresh
IniWrite,%Square%,Coloretta.ini, Magnifyer, PixelScale
IniWrite,%Num%,Coloretta.ini, Magnifyer, NumOfPixels
IniWrite,%CursorType%,Coloretta.ini, User Interface, CursorType
IniWrite,%ChangeCursor%,Coloretta.ini, User Interface, ChangeCursor

IniWrite,%PickBGRKey%,Coloretta.ini, Hotkeys, PickBGRKey
IniWrite,%PickRGBKey%,Coloretta.ini, Hotkeys, PickRGBKey
IniWrite,%PickRGB255Key%,Coloretta.ini, Hotkeys, PickRGB255Key
IniWrite,%PasteR255Key%,Coloretta.ini, Hotkeys, PasteR255Key
IniWrite,%PasteG255Key%,Coloretta.ini, Hotkeys, PasteG255Key
IniWrite,%PasteB255Key%,Coloretta.ini, Hotkeys, PasteB255Key
IniWrite,%PauseKey%,Coloretta.ini, Hotkeys, PauseKey
IniWrite,%QuitAppKey%,Coloretta.ini, Hotkeys, QuitAppKey
IniWrite,%ShowHelpKey%,Coloretta.ini, Hotkeys, ShowHelpKey
IniWrite,%ShowTrayTipKey%,Coloretta.ini, Hotkeys, ShowTrayTipKey



; ===========================================
; Preferences

Gui Margin, 1, 1
Gui Color, 000000, 000000
DPImult := getDPImultiplier()
hGui := WinExist()  ; Gui Handle used in color picking

;width and height of magnifier
width := Num * Square 
height := Num * Square

Running := 1          ; used to stop the loop
mobile := true      ; magnifier follows cursor while this is true

UsageTipTime := 15  ;DOESN'T WORK, Windows ignores it
SetWorkingDir %A_ScriptDir%
		
Hotkey,%PauseKey%, Pause, On
Hotkey %PickRGBKey%, PickRGB, On
Hotkey %PickBGRKey%, PickBGR, On
Hotkey %PickRGB255Key%, PickRGB255, On
Hotkey %PasteR255Key%, PasteR255, On
Hotkey %PasteG255Key%, PasteG255, On
Hotkey %PasteB255Key%, PasteB255, On
Hotkey %ShowHelpKey%, ShowHelp, On
Hotkey %ShowTrayTipKey%, ShowTrayTip, On
Hotkey %QuitAppKey%, QuitApp, On



; Change Cursor Style
If (%ChangeCursor%=true)
{
SetSystemCursor(CursorType)
}

; USAGE INSTRUCTIONS - Give a tray-tip on how to use picker in case they
; are too lazy to read the script. ;p
If (%ShowUsageTipINI%=true)
{
ShowTrayTip("Coloretta Viva")
}

If (%ShowUsageBoxINI%=true)
{
ShowHelp("Coloretta Viva") ; goto functions if you want to modify it's content
IniWrite,false,Coloretta.ini, Messages, ShowUsageBox ;disables the messageBox after first run
}


; Create the Gui:
CreateGUI:


Loop % Num
{
	;written by Nimda
   Index := A_Index ; y
   Loop % Num       ; x
   {
	  Gui Add, Progress, % "x" (Square * (A_Index-1)) " y" (Square * (Index-1)) " w" (Square+1) " h" (Square+1) " vProg" A_Index "_" Index
      GuiControl,, Prog%A_Index%_%Index%, 100 ; Set it to 100%
   }
}

Gui Show,, AutoHotkey Magnifyer

; Continually get pixels
Loop
{	
	; This section keeps track of mouse position, calculates and displays color
	; and tracks the magnifier close to cursor.
	MouseGetPos mx, my, Win
   ;correct XY to center of magnifier box
   px := mx + 1
   py := my + 1 
   
   ; Automatically get current Monitor Dimensions (scrh x scrw)
   CurrentMon := GetCurrentMonitorNum()
   SysGet, currentMonitor, Monitor, %CurrentMon%
   scrh := currentMonitorBottom
   scrw := currentMonitorRight   
   
   
   ; the if statements below decide on where to
   ; draw magnifier. takes into account screen edges.
   if (px > scrw - width*DPImult)
   {
	 wX := Floor(pX - 48*DPImult - width*DPImult - 1.6 * Num * DPImult)
   }
   else
   {
	 wX := Floor(pX + 13*DPImult)
   }
   
    if (py < height*DPImult)
   {
	 wY := Floor(pY + 80*DPImult)
   }
   else if (py > scrh - 80*DPImult)
   {
	 wY := Floor(pY - 20 * Num * DPImult - 80*DPImult)
   }  
	else
	{
	  wY := Floor(pY - (20 * Num)*DPImult)	
	}
   
	if (mobile)
	{

		WinMove,AutoHotkey Magnifyer, , %wX%, %wY%
		Xhoriz := Floor(wx + (height*DPImult)/2 -1)
		Yhoriz := Floor(wY + (height*DPImult) / 2)

		;This if statement below draws a little dot
		;in the center of the magnifier and alternates
		;between black and white to keep visible over
		;both light and dark colors. damn I'm good.
				if (n < 1)
			   {
			   n += 1
			   CreateDOT("2e2e2e")
			   DOT(Xhoriz, Yhoriz, 2, 2, 1,0,0,0)
			   }
			   else
			   {
			   n := 0
			   CreateDOT("e2e2e2")
			   DOT(Xhoriz, Yhoriz, 2, 2, 1,0,0,0)
			   }
	}		
   
   ; Samples color under cursor in RGB, human readable RGB and BGR and displays it 
   ; as a tool tip near the cursor. Will also display the cursor position.
   ; Position displayed corresponds to center of Magnifyer Box.
   PixelGetColor, ColorxRGB, % px, % py, RGB
   PixelGetColor, ColorxBGR, % px, % py
   ColorRGB := SubStr(ColorxRGB,3 ) ; ColorxRGB: color with 0x, ColorRGB has no 0x
   ColorBGR := SubStr(ColorxBGR,3 )
   ColorRGB255 := HexToRGB(ColorRGB)
	ToolTip,
(Join LTrim
    RGB:	%ColorRGB%`n
    RGBh:	%ColorRGB255%`n
    BGR:	%ColorBGR%`n
	XY:	%px% %py% 
)
   
   ; Sleeps for x amount of milliseconds so that the poll isn't running constantly.
   Sleep, %PauseBetweenMagnifyerRefresh%
	RemoveDOT()
   
   If (Win = hGui)
   {   
	; This section of the if statement, executes code if you hover cursor over
	; magnifier. not using but might as well keep it.
   }
   Else If (Running)
   {
      Loop % Num ; This loop refreshes contents of magnifier box 
      {
		;written by Nimda
         Index := A_Index ; y
         Loop % Num       ; x
         {
            PixelGetColor, color, % mx + A_Index-(Floor(Num/2)), % my + Index-(Floor(Num/2)), RGB
            GuiControl, % a := "+c" SubStr(Color,3 ) , Prog%A_Index%_%Index% ; SubStr removes the 0x
         }
      }
   }
}
PickRGB:
   PixelGetColor, ColorxRGB, % px, % py, RGB
   ColorRGB := SubStr(ColorxRGB,3 )
   clipboard = %ColorRGB%
   TrayTip Copied Color, % "RGB: 0x" ColorRGB
return

PickBGR:
   PixelGetColor, ColorxBGR, % px, % py
   ColorBGR := SubStr(ColorxBGR,3 )
   clipboard = %ColorBGR%
   TrayTip Copied Color, % "BGR: 0x" ColorBGR
return

PickRGB255:
   PixelGetColor, ColorxRGB, % px, % py, RGB
   ColorRGB := SubStr(ColorxRGB,3 )
   ColorRGB255 := HexToRGB(ColorRGB)
   clipboard = %ColorRGB255% 
   TrayTip Copied Color, % "RGB (Human Readable): " ColorRGB255
   R255 := HexToR(ColorRGB)
   G255 := HexToG(ColorRGB)
   B255 := HexToB(ColorRGB)
return

PasteR255:
send, %R255%
return

PasteG255:
send, %G255%
return

PasteB255:
send, %B255%
return

TT:
 ToolTip
return

QuitApp:
RestoreCursors()
GuiClose:
   ExitApp

Pause:
 mobile := !mobile
 Running := !Running
 TrayTip % RunPause := !Running ? "Paused" : "Resumed", % "The magnifyer was " RunPause
return

ShowHelp:
ShowHelp("Coloretta Viva")
return

ShowTrayTip:
;Loop, 3
;{
    ShowTrayTip("Coloretta Viva")
 ;   Sleep, 5000
;}
return

#IfWinActive AutoHotkey Magnifyer
+LButton::MoveWin("LButton")
#IfWinActive ; Otherwise the above declaration affects the hotkey command.




;====================================================================
; Functions



ShowHelp(PickerName)
{			
		
		IniRead, PickBGRKey,Coloretta.ini, Hotkeys, PickBGRKey,^LButton												  
		IniRead, PickRGBKey,Coloretta.ini, Hotkeys, PickRGBKey,^RButton												  
		IniRead, PickRGB255Key,Coloretta.ini, Hotkeys, PickRGB255Key,+^RButton										  
		IniRead, PasteR255Key,Coloretta.ini, Hotkeys, PasteR255Key,^1												  
		IniRead, PasteG255Key,Coloretta.ini, Hotkeys, PasteG255Key,^2												  
		IniRead, PasteB255Key,Coloretta.ini, Hotkeys, PasteB255Key,^3												  
		IniRead, PauseKey,Coloretta.ini, Hotkeys, PauseKey,+^LButton												  
		IniRead, QuitAppKey,Coloretta.ini, Hotkeys, QuitAppKey,+Esc													  
		IniRead, ShowHelpKey,Coloretta.ini, Hotkeys, ShowHelpKey,F1													  
		IniRead, ShowTrayTipKey,Coloretta.ini, Hotkeys, ShowTrayTipKey,+F1		
		
		PickBGRKeyFull := HotkeyFullFormat(PickBGRKey)													  
		PickRGBKeyFull := HotkeyFullFormat(PickRGBKey)												  
		PickRGB255KeyFull := HotkeyFullFormat(PickRGB255Key)												  
		PasteR255KeyFull := HotkeyFullFormat(PasteR255Key)													  
		PasteG255KeyFull := HotkeyFullFormat(PasteG255Key)													  
		PasteB255KeyFull := HotkeyFullFormat(PasteB255Key)													  
		PauseKeyFull := HotkeyFullFormat(PauseKey)													  
		QuitAppKeyFull := HotkeyFullFormat(QuitAppKey)													  
		ShowHelpKeyFull := HotkeyFullFormat(ShowHelpKey)													  
		ShowTrayTipKeyFull := HotkeyFullFormat(ShowTrayTipKey)
	
		MsgBox,4, %PickerName% Color-Picker Usage:,`Welcome to %PickerName%.`n`n This is a one time message to explain how the picker works. You can always access this message again by pressing %ShowHelpKeyFull% while the color picker is active. Tray tip can be accessed via %ShowTrayTipKeyFull% (please note that you can keep Tray Tip from fading by hovering the mouse cursors over it).`n`nHere is a list of the picker's functions and their Hotkeys:`n______________________________________________________________________`n`nExit:			%QuitAppKeyFull%`nAnchor Magnifier:		%PauseKeyFull%`n`nPick Hex-RGB:		%PickRGBKeyFull%`nPick Hex-BGR:		%PickBGRKeyFull%`n`nPick HumanReadable-RGB:	%PickRGB255KeyFull%`n`nShow Tray Tip:		%ShowTrayTipKeyFull%`nShow This Message:	%ShowHelpKeyFull%`n`nNote:Picking a color will save it to clipboard. Picking the human readable RGB format will also save it's individual channels within the picker's buffer. Use %PasteR255KeyFull%`(to paste the Red value`)`,%PasteG255KeyFull%`(for Green`) and %PasteB255KeyFull%`(for Blue`).`n`n______________________________________________________________________`n`nKeep Startup Tray Tip?`n`nA short 5 second tray notification has been setup to run during startup in order to remind you of the Hotkeys.`n`n Would you like to keep it active/re-enable it '(Yes - recommended`)? Press `(No`) to disable it or to keep it disabled`.

		IfMsgBox Yes
		IniWrite,true,Coloretta.ini, Messages, ShowUsageTip
		else
		IniWrite,false,Coloretta.ini, Messages, ShowUsageTip
		
}



ShowTrayTip(PickerName)
{
		
		IniRead, PickBGRKey,Coloretta.ini, Hotkeys, PickBGRKey,^LButton												  
		IniRead, PickRGBKey,Coloretta.ini, Hotkeys, PickRGBKey,^RButton												  
		IniRead, PickRGB255Key,Coloretta.ini, Hotkeys, PickRGB255Key,+^RButton										  
		IniRead, PasteR255Key,Coloretta.ini, Hotkeys, PasteR255Key,^1												  
		IniRead, PasteG255Key,Coloretta.ini, Hotkeys, PasteG255Key,^2												  
		IniRead, PasteB255Key,Coloretta.ini, Hotkeys, PasteB255Key,^3												  
		IniRead, PauseKey,Coloretta.ini, Hotkeys, PauseKey,+^LButton												  
		IniRead, QuitAppKey,Coloretta.ini, Hotkeys, QuitAppKey,+Esc													  
		IniRead, ShowHelpKey,Coloretta.ini, Hotkeys, ShowHelpKey,F1													  
		IniRead, ShowTrayTipKey,Coloretta.ini, Hotkeys, ShowTrayTipKey,+F1		
		
		PickBGRKeyFull := HotkeyFullFormat(PickBGRKey)													  
		PickRGBKeyFull := HotkeyFullFormat(PickRGBKey)												  
		PickRGB255KeyFull := HotkeyFullFormat(PickRGB255Key)												  
		PasteR255KeyFull := HotkeyFullFormat(PasteR255Key)													  
		PasteG255KeyFull := HotkeyFullFormat(PasteG255Key)													  
		PasteB255KeyFull := HotkeyFullFormat(PasteB255Key)													  
		PauseKeyFull := HotkeyFullFormat(PauseKey)													  
		QuitAppKeyFull := HotkeyFullFormat(QuitAppKey)													  
		ShowHelpKeyFull := HotkeyFullFormat(ShowHelpKey)													  
		ShowTrayTipKeyFull := HotkeyFullFormat(ShowTrayTipKey)
		
		Traytip, %PickerName% Color-Picker Usage:,`(%ShowTrayTipKeyFull% Shows this Message Again`)`n`nExit:			%QuitAppKeyFull%`nAnchor Magnifier:		%PauseKeyFull%`n`nPick Hex-RGB:		%PickRGBKeyFull%`nPick Hex-BGR:		%PickBGRKeyFull%`n`nPick RGB255:		%PickRGB255KeyFull%`n`(follow by %PasteR255KeyFull%`,%PasteG255KeyFull%`,%PasteB255KeyFull% to paste R`,G or B`), 10
}





HotkeyFullFormat(HKey)
{
		 StringReplace,HKey,HKey,+,Shift+,All
		 StringReplace,HKey,HKey,^,Ctrl+,All
		 StringReplace,HKey,HKey,#,Win+,All
		 StringReplace,HKey,HKey,!,Alt+,All
		 StringReplace,HKey,HKey,RButton,RightClick,All
		 StringReplace,HKey,HKey,MButton,MiddleClick,All
		 StringReplace,HKey,HKey,LButton,LeftClick,All
		 StringReplace,HKey,HKey,{,,All
		 StringReplace,HKey,HKey,},,All
		 ;MsgBox,%HKey%
		 Return HKey
}	





getDPImultiplier()
{
		RegRead, DPI_value, HKEY_CURRENT_USER, Control Panel\Desktop\WindowMetrics, AppliedDPI
		if errorlevel=1 ; the reg key was not found - it means default settings
		   return 1
		if DPI_value=96 ; 96 is the default font size setting
		   return 1
		if DPI_value>96 ; A higher value should mean LARGE font size setting
		   return DPI_value/96
}



; Nimda
MoveWin(Button)
{
	   SetWinDelay, 0
	   CoordMode, Mouse
	   KeyWait, %Button%, D
	   MouseGetPos,mX,mY,Win
	   WinGetPos, wX, wY, , ,AutoHotkey Magnifyer
	   oX := mX-wX, oY := mY-wY
	   While GetKeyState(Button, "P")
	   {
		  MouseGetPos, X, Y
		  zX := X-oX, zY := Y-oY
		  WinMove, ahk_id %Win%, , %zX%, %zY%
	   }
}




;====================================================================
; Functions Copied from Colorette

SetSystemCursor( Cursor = "", cx = 0, cy = 0 )
{
		BlankCursor := 0, SystemCursor := 0, FileCursor := 0 ; init
		SystemCursors = 32512IDC_ARROW,32513IDC_IBEAM,32514IDC_WAIT,32515IDC_CROSS
		,32516IDC_UPARROW,32640IDC_SIZE,32641IDC_ICON,32642IDC_SIZENWSE
		,32643IDC_SIZENESW,32644IDC_SIZEWE,32645IDC_SIZENS,32646IDC_SIZEALL
		,32648IDC_NO,32649IDC_HAND,32650IDC_APPSTARTING,32651IDC_HELP
		If Cursor = ; empty, so create blank cursor
		{
		VarSetCapacity( AndMask, 32*4, 0xFF ), VarSetCapacity( XorMask, 32*4, 0 )
		BlankCursor = 1 ; flag for later
		}
		Else If SubStr( Cursor,1,4 ) = "IDC_" ; load system cursor
		{
		Loop, Parse, SystemCursors, `,
		{
		CursorName := SubStr( A_Loopfield, 6, 15 ) ; get the cursor name, no trailing space with substr
		CursorID := SubStr( A_Loopfield, 1, 5 ) ; get the cursor id
		SystemCursor = 1
		If ( CursorName = Cursor )
		{
		CursorHandle := DllCall( "LoadCursor", Uint,0, Int,CursorID )
		Break
		}
		}
		If CursorHandle = ; invalid cursor name given
		{
		Msgbox,, SetCursor, Error: Invalid cursor name
		CursorHandle = Error
		}
		}
		Else If FileExist( Cursor )
		{
		SplitPath, Cursor,,, Ext ; auto-detect type
		If Ext = ico
		uType := 0x1
		Else If Ext in cur,ani
		uType := 0x2
		Else ; invalid file ext
		{
		Msgbox,, SetCursor, Error: Invalid file type
		CursorHandle = Error
		}
		FileCursor = 1
		}
		Else
		{
		Msgbox,, SetCursor, Error: Invalid file path or cursor name
		CursorHandle = Error ; raise for later
		}
		If CursorHandle != Error
		{
		Loop, Parse, SystemCursors, `,
		{
		If BlankCursor = 1
		{
		Type = BlankCursor
		%Type%%A_Index% := DllCall( "CreateCursor"
		, Uint,0, Int,0, Int,0, Int,32, Int,32, Uint,&AndMask, Uint,&XorMask )
		CursorHandle := DllCall( "CopyImage", Uint,%Type%%A_Index%, Uint,0x2, Int,0, Int,0, Int,0 )
		DllCall( "SetSystemCursor", Uint,CursorHandle, Int,SubStr( A_Loopfield, 1, 5 ) )
		}
		Else If SystemCursor = 1
		{
		Type = SystemCursor
		CursorHandle := DllCall( "LoadCursor", Uint,0, Int,CursorID )
		%Type%%A_Index% := DllCall( "CopyImage"
		, Uint,CursorHandle, Uint,0x2, Int,cx, Int,cy, Uint,0 )
		CursorHandle := DllCall( "CopyImage", Uint,%Type%%A_Index%, Uint,0x2, Int,0, Int,0, Int,0 )
		DllCall( "SetSystemCursor", Uint,CursorHandle, Int,SubStr( A_Loopfield, 1, 5 ) )
		}
		Else If FileCursor = 1
		{
		Type = FileCursor
		%Type%%A_Index% := DllCall( "LoadImageA"
		, UInt,0, Str,Cursor, UInt,uType, Int,cx, Int,cy, UInt,0x10 )
		DllCall( "SetSystemCursor", Uint,%Type%%A_Index%, Int,SubStr( A_Loopfield, 1, 5 ) )
		}
		}
		}
}







RestoreCursors()
{
		SPI_SETCURSORS := 0x57
		DllCall( "SystemParametersInfo", UInt,SPI_SETCURSORS, UInt,0, UInt,0, UInt,0 )
}







HexToRGB(Color, Message="") ; Input: 6 letters
{
		; If df, d is *16 and f is *1. Thus, Rx = R*16 while Rn = R*1
		Rx := SubStr(Color, 1,1)
		Rn := SubStr(Color, 2,1)
		Gx := SubStr(Color, 3,1)
		Gn := SubStr(Color, 4, 1)
		Bx := SubStr(Color, 5,1)
		Bn := SubStr(Color, 6,1)
		AllVars := "Rx|Rn|Gx|Gn|Bx|Bn"
		Loop, Parse, Allvars, |
		{
			StringReplace, %A_LoopField%, %A_LoopField%, a, 10
			StringReplace, %A_LoopField%, %A_LoopField%, b, 11
			StringReplace, %A_LoopField%, %A_LoopField%, c, 12
			StringReplace, %A_LoopField%, %A_LoopField%, d, 13
			StringReplace, %A_LoopField%, %A_LoopField%, e, 14
			StringReplace, %A_LoopField%, %A_LoopField%, f, 15
		}
		R := Rx*16+Rn
		G := Gx*16+Gn
		B := Bx*16+Bn
		;If (Message)
		Out := "R:" . R . " G:" . G . " B:" . B
		;else
		;Out := R . G . B
		return Out
}



; Colorette's HexToRGB Modded by me for invidual color channels
HexToR(Color, Message="") ; Input: 6 letters
{
		Rx := SubStr(Color, 1,1)
		Rn := SubStr(Color, 2,1)

		AllVars := "Rx|Rn"
		Loop, Parse, Allvars, |
		{
			StringReplace, %A_LoopField%, %A_LoopField%, a, 10
			StringReplace, %A_LoopField%, %A_LoopField%, b, 11
			StringReplace, %A_LoopField%, %A_LoopField%, c, 12
			StringReplace, %A_LoopField%, %A_LoopField%, d, 13
			StringReplace, %A_LoopField%, %A_LoopField%, e, 14
			StringReplace, %A_LoopField%, %A_LoopField%, f, 15
		}
		R := Rx*16+Rn

		Out := R
		return Out
}






HexToG(Color, Message="") ; Input: 6 letters
{
		Gx := SubStr(Color, 3,1)
		Gn := SubStr(Color, 4, 1)
		AllVars := "Gx|Gn"
		Loop, Parse, Allvars, |
		{
			StringReplace, %A_LoopField%, %A_LoopField%, a, 10
			StringReplace, %A_LoopField%, %A_LoopField%, b, 11
			StringReplace, %A_LoopField%, %A_LoopField%, c, 12
			StringReplace, %A_LoopField%, %A_LoopField%, d, 13
			StringReplace, %A_LoopField%, %A_LoopField%, e, 14
			StringReplace, %A_LoopField%, %A_LoopField%, f, 15
		}
		G := Gx*16+Gn

		Out := G
		return Out
}






HexToB(Color, Message="") ; Input: 6 letters
{
		Bx := SubStr(Color, 5,1)
		Bn := SubStr(Color, 6,1)
		AllVars := "Bx|Bn"
		Loop, Parse, Allvars, |
		{
			StringReplace, %A_LoopField%, %A_LoopField%, a, 10
			StringReplace, %A_LoopField%, %A_LoopField%, b, 11
			StringReplace, %A_LoopField%, %A_LoopField%, c, 12
			StringReplace, %A_LoopField%, %A_LoopField%, d, 13
			StringReplace, %A_LoopField%, %A_LoopField%, e, 14
			StringReplace, %A_LoopField%, %A_LoopField%, f, 15
		}
		B := Bx*16+Bn

		Out := B
		return Out
}




; ==============================================
; GetCurrentMonitorNum written by FuzzicalLogic
GetCurrentMonitorNum(hwnd := 0) {
			; If no hwnd is provided, use the Active Window
			if (hwnd)
				WinGetPos, winX, winY, winW, winH, ahk_id %hwnd%
			else
				WinGetActiveStats, winTitle, winW, winH, winX, winY

			SysGet, numDisplays, MonitorCount
			SysGet, idxPrimary, MonitorPrimary

			Loop %numDisplays%
			{	SysGet, mon, MonitorWorkArea, %a_index%
			; Left may be skewed on Monitors past 1
				if (a_index > 1)
					monLeft -= 10
			; Right overlaps Left on Monitors past 1
				else if (numDisplays > 1)
					monRight -= 10
			; Tracked based on X. Cannot properly sense on Windows "between" monitors
				if (winX >= monLeft && winX < monRight)
					return %a_index%
			}
		; Return Primary Monitor if can't sense
			return idxPrimary
}







;======================================================
; Center DOT, used to mark the central pixel in magnifier


CreateDOT(Color)
{
		Gui 85:color, %Color%
		Gui 85:+ToolWindow -SysMenu -Caption +AlwaysOnTop 
}

DOT(XCor, YCor, Width, Height, Thickness,DPI, XOffset, YOffset)
{
		x := XCor+XOffset
		y := YCor+YOffset
		w := Width
		h := Height
		Gui 85:Show, x%x% y%y% w%w% h%h% NA,CenterDOT 
}

RemoveDOT()
{
		Gui 85:destroy
}





;======================================================
; CrossBox inspired by Box Functions written by berban


CreateCrossBox(Color)
{
		Gui 81:color, %Color%
		Gui 81:+ToolWindow -SysMenu -Caption +AlwaysOnTop ; Left
		Gui 82:color, %Color%
		Gui 82:+ToolWindow -SysMenu -Caption +AlwaysOnTop ; Top
		Gui 83:color, %Color%
		Gui 83:+ToolWindow -SysMenu -Caption +AlwaysOnTop ; Right
		Gui 84:color, %Color%
		Gui 84:+ToolWindow -SysMenu -Caption +AlwaysOnTop ; Bottom
		Gui 85:color, %Color%
		Gui 85:+ToolWindow -SysMenu -Caption +AlwaysOnTop ; Cross Horiz
		Gui 86:color, %Color%
		Gui 86:+ToolWindow -SysMenu -Caption +AlwaysOnTop ; Cross Vert
	
}

CrossBox(XCor, YCor, Width, Height, Thickness,DPI, Offset)
{
		If InStr(Offset, "In")
		{
			StringTrimLeft, offset, offset, 2
			If not Offset
				Offset = 0
			Side = -1
		} Else {
			StringTrimLeft, offset, offset, 3
			If not Offset
				Offset = 0
			Side = 1
		}
		x := XCor
		y := YCor
		h := Height
		w := Thickness
		Gui 81:Show, x%x% y%y% w%w% h%h% NA
		x := XCor
		y := YCor
		w := Width
		h := Thickness
		Gui 82:Show, x%x% y%y% w%w% h%h% NA
		x := XCor+Width*DPI
		y := YCor
		h := Height
		w := Thickness
		Gui 83:Show, x%x% y%y% w%w% h%h% NA
		x := XCor
		y := YCor + Height*DPI
		w := Width+Thickness
		h := Thickness
		Gui 84:Show, x%x% y%y% w%w% h%h% NA
		x := XCor
		y := Floor(YCor + Height / 2 * DPI)
		w := Width + Side * Thickness + Side * Offset * 2
		h := Thickness
		Gui 85:Show, x%x% y%y% w%w% h%h% NA
		x := Floor(XCor + Width / 2 * DPI) 
		y := YCor
		h := Height
		w := Thickness
		Gui 86:Show, x%x% y%y% w%w% h%h% NA
}

RemoveCrossBox()
{
		Gui 81:destroy
		Gui 82:destroy
		Gui 83:destroy
		Gui 84:destroy
		Gui 85:destroy
		Gui 86:destroy
}





;============================================================
; _iniwrite by Avi

_IniWrite(Inipath, section, key, value, Keycomment="", Sectioncomment=""){

		If !(FileExist(Inipath))	;create file
			FileAppend,%emptyvar%,%Inipath%
		FileRead,ini,%Inipath%
		if !(Instr(ini, "`r`n[" section "]") or Instr(ini, "[" section "]") = 1)	;create section
			ini .= (ini == "") ? "[" section "]" : "`r`n[" section "]"

		tempabovesection := Substr(ini, 1, (tempabovesection := Instr(ini,"`r`n[" section "]")) ? tempabovesection+1 : 1 )	;section will always exist
		StringReplace,tempabovesection,tempabovesection,`r`n,`r`n,UseErrorLevel
		lineofsection := ErrorLevel + 1 	;get line of starting of section
		tempabovesection := (tempabovesection == "[") ? "[" Section "]" : tempabovesection "[" section "]"
		StringReplace,tempbelow,ini,%tempabovesection%		;Remove above section.... Now, tempbelow has key1=value1.....
		tempbelow := Ltrim(tempbelow, "`r`n")

		loop,parse,tempbelow,`n,`r
		{
			if Instr(A_LoopField, key) = 1
			{
				keyline := lineofsection + A_index
				break
			}
			if Instr(A_LoopField, "[") = 1
			{
				lastkeyline := lineofsection+A_index	;if key doesnt exist
				break
			}
			lastkeyline := lineofsection + A_index + 1
		}
		;Keyline empty then create
		tempbelow .= "`r`n"	;last entry
		if (keyline == "")
		{
			keyline := lastkeyline+1 , keynotadd := true , lineins .= key "=" value "`r`n"	;value for key
			if (keycomment != "")
				lineins .= ";" keycomment "`r`n"
			tempbelow := Substr(tempbelow, 1, Instr(tempbelow, "`n", false, 1, lastkeyline-lineofsection-1)) lineins Substr(tempbelow, Instr(tempbelow, "`n", false, 1, lastkeyline-lineofsection-1) + 1)
		}
		else	;if keyline is something, check for comment
		{
			if (Keycomment != "")
			{
			FileReadLine,tempkey,%Inipath%,% keyline + 1
			if !(Instr(Ltrim(tempkey), ";") == 1)
				tempbelow := Substr(tempbelow, 1, Instr(tempbelow, "`n", false, 1, keyline-lineofsection)) "`r`n" Substr(tempbelow, Instr(tempbelow, "`n", false, 1, keyline-lineofsection) + 1)
			}
		}
		;Section comment
		seccomment := false

		if (Sectioncomment != "")
		{
			FileReadLine,tempsec,%Inipath%,% lineofsection+1
			if !(Instr(Ltrim(tempsec), ";") = 1)
				tempabovesection .= "`r`n" , seccomment := true	;seccomment can change keyline
		}
		;Lines filled , adding to file
		FileDelete, %inipath%
		if ((keynotadd) and Sectioncomment == "")
		{
			Fileappend,% tempabovesection "`r`n" Rtrim(tempbelow, "`r`n"), %inipath%
			return
		}
		FileAppend, %tempabovesection%`r`n%tempbelow%, %inipath%
		;Adding Data
		if !(keynotadd)
		{
			Fileatline(inipath, key "=" value, keyline+seccomment)
			if (keycomment != "")
				Fileatline(inipath, ";" keycomment, keyline+1+seccomment)
		}
		if (Sectioncomment != "")
			Fileatline(inipath, ";" sectioncomment, lineofsection+1)
		return
}



; Also written by Avi
Fileatline(file, what="", linenum=1){
		FileRead,filedata,%file%
		file1 := Substr(filedata, 1, Instr(filedata, "`r`n", false, 1, linenum-1)-1)	;dont take `r`n

		if (var := Instr(filedata, "`r`n", false, 1, linenum))
			file2 := Substr(filedata,var)	;take leading 'r'n (

		if (what != "")
			file1 .= "`r`n" what
		FileDelete, %file%
		filedata := Rtrim(file1 . file2, "`r`n")
		FileAppend, %filedata%, %file%
}