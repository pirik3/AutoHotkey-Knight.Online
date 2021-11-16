;TreeView List Creator vAlpha: Added to Reddit
;Project Halted (Tuesday May 25th 2021)
;Project continued (Sunday September 19th 2021)
;just me on the forums has saved my life, I owe it to you: https://www.autohotkey.com/boards/viewtopic.php?f=76&t=94814
;TreeView List Creator v1.0: Finished, and reposted on Reddit and added to the Forums
;TreeView List Creator, v1.1: Added Import and Export buttons, also made the second Edit control editable, so you can freely edit lines either way
;Finished, 155 lines
#SingleInstance, Force
Gui, New, , TreeViewCreator
Gui, Add, Button, w20 h20 gAdd, +
Gui, Add, Button, yp+25 w20 h20 gAddChild, +C
Gui, Add, Button, x+5 ym w50 h20 gDelete, Delete
Gui, Add, Button, yp+25 w50 h20 gModify, Modify
Gui, Add, Button, x+5 ym w50 h20 gImport, Import
Gui, Add, Button, yp+25 w50 h20 gExport, Export
Gui, Add, Button, x+5 ym w50 h20 gCopy, Copy
Gui, Add, Button, yp+25 w50 h20 gScreenShot, Screen
Gui, Add, Button, x+5 ym w50 h20 gReset, Reset
Gui, Add, Button, yp+25 w50 h20 gRedraw, Redraw
Gui, Add, Edit, x+6 ym+2 w115 h42 vName hwndHandle, 
Gui, Add, TreeView, xm W185 h250 -ReadOnly AltSubmit vTV
Gui, Add, Edit, x+6 w171 h250 gEdit vEdit
Gui, Show, , TreeView List Creator
Gui, TreeView, TV
Gosub, Redraw
return

Add:
Gui, Submit, NoHide
TV_Add(Name, , "Expand")
GuiControl, , Edit1
GoSub, Redraw
return

AddChild:
Selected := TV_GetSelection()
Gui, Submit, NoHide
TV_Add(Name, Selected, Options "Expand")
GuiControl, , Edit1
GoSub, Redraw
return

Delete:
Selected := TV_GetSelection()
if (Selected = 0)
	MsgBox, 8208, Sorry, Select an item first., 0
else
	TV_Delete(Selected)
GoSub, Redraw
return

Modify:
Selected := TV_GetSelection()
if (Selected = 0)
	MsgBox, 8208, Sorry, Select an item first., 0
else
{
	InputBox, Name, New Name, , , 140, 100
	if not ErrorLevel
		TV_Modify(Selected, , Name)
}
GoSub, Redraw
return

Reset:
MsgBox, 8500, Warning!, Are you sure? This will erase all items!
ifMsgBox, Yes
	Reload
ifMsgBox, No
	GoSub, Redraw
return

Redraw:
GuiControl, Text, Edit2, % TV_GetTree()
GuiControl, -Redraw, TV
GuiControl, +Redraw, TV
GuiControl, Focus, Edit1
SendMessage, 0xB1, -2, -1,, ahk_id %Handle%
SendMessage, 0xB7,,,, ahk_id %Handle%
return

Copy:
clipboard := TV_GetTree()
return

Edit:
Gui, Submit, NoHide
TV_Delete()
TV_MakeTree(Edit)
return

Import:
FileSelectFile, File, 3, %A_ScriptDir%, Import TreeView, (*.txt; *.ahk)
TV_Delete()
FileRead, Tree, %File%
TV_MakeTree(Tree)
GoSub, Redraw
return

Export:
FileSelectFile, File, S, %A_ScriptDir%, Export TreeView, (*.txt; *.ahk)
GuiControlGet, NewTV, , Edit2
FileAppend, %NewTV%, %File%
return

ScreenShot:
Send, ^!{PrintScreen}
TV_GetTree(ItemID := 0, Level := 0) { ; uses the default TreeView of the default Gui ;just me THANK YOU SO MUCH *hug*
   Text := ""
   If (ItemID = 0) {
      ItemID := TV_GetNext()
      Text := "ID0 := 0`r`n"
   }
   While (ItemID){
      TV_GetText(ItemText, ItemID)
      Text .= "ID" . (Level + 1) . " := TV_Add(""" . ItemText . """, ID" . Level . ")`r`n"
      If ChildID := TV_GetChild(ItemID)
         Text .= TV_GetTree(ChildID, Level + 1)
      ItemID := TV_GetNext(ItemID)
   }
   Return (Level = 0 ? RTrim(Text, "`r`n") : Text)
}
SubStrInBtw(String, StartingChar, EndingChar, OccurStartChar := 1, OccurEndChar := 1) {
	StartingPos := InStr(String, StartingChar, , , OccurStartChar)+1
	Length := InStr(String, EndingChar, , , OccurEndChar)-InStr(String, StartingChar, , , OccurStartChar)-1
	return SubStr(String, StartingPos, Length)
}
StrAmt(Haystack, Needle, casesense := false) {
	StringCaseSense % casesense
	StrReplace(Haystack, Needle, , Count)
	return Count
}
TV_MakeTree(List, Del := "`n") {
	ID0 := 0
	Loop, Parse, List, %Del%
	{
		if InStr(A_LoopField, "TV_Add")
		{
			StringSplit, TVAdd, A_LoopField, =
			AssignLevel := StrReplace(TVAdd1, " :")
			TV := SubStrInBtw(TVAdd2, "(", ")")
			Loop, Parse, TV, CSV
			{
				if (A_Index = 1)
					Name := A_LoopField
				if (A_Index = 2)
					Level := StrReplace(A_LoopField, " ")
				if (A_Index = 3)
					Options := A_LoopField
			}
			Options .= " Expand"
			%AssignLevel% := TV_Add(Name, %Level%, Options)
		}
	}
}