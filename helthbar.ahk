
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~;
;~~~~~~~~~~~~ GUI STUFF, UNIMPORTANT FOR THE BOT ~~~~~~~~~~~~~~~~~~~;
Gui, Add, Progress, x62 y10 w120 h20 vP1 +border, % hp1:=100
Gui, Add, Progress, x62 y40 w120 h20 vP2 +border, % hp2:=100
Gui, Add, Progress, x62 y70 w120 h20 vP3 +border, % hp3:=100
Gui, Add, Progress, x62 y100 w120 h20 vP4 +border, % hp4:=100
Gui, Add, Text, x12 y10 w50 h20 , Hero 1
Gui, Add, Text, x12 y40 w50 h20 , Hero 2
Gui, Add, Text, x12 y70 w50 h20 , Hero 3
Gui, Add, Text, x12 y100 w50 h20 , Hero 4
Gui, Add, Button, x182 y10 w50 h20 gHeal vH1, Heal
Gui, Add, Button, x182 y40 w50 h20 gHeal vH2, Heal
Gui, Add, Button, x182 y70 w50 h20 gHeal vH3, Heal
Gui, Add, Button, x182 y100 w50 h20 gHeal vH4, Heal
Gui, Add, Button, x12 y130 w230 h20 gActivateBot, Activate "Game" and Bot
Gui, Show, w250 h165, BestGameEver
return

Heal:
rH := substr(A_GuiControl,2,1)
hp := "hp" rH
guicontrol,, % "P" rH, % %hp% += 100
return

damage:
rH := r(1,4)
hp := "hp" rH
guicontrol,, % "P" rH, % %hp% -= r(5,40)
return

r(l,h) {
	random,r,%l%,%h%
	return r
}
;~~~~~~~~~~~~ GUI STUFF, UNIMPORTANT FOR THE BOT ~~~~~~~~~~~~~~~~~~~;
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~;

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~;
;~~~~~~~~~~~~              BOT STUFF             ~~~~~~~~~~~~~~~~~~~;
ActivateBot:
settimer,damage, 100 			;Starts the damaging "sequenece" in the gui
mousemoveSpeed := 1 			;The speed at which the mouse will move in this "demo" (higher value makes it slower)
showAllSearches := false		;swap this to true so that the mouse moves to every seach loc to see how it searches
winactivate, BestGameEver
hero_count := 4				;How many hp bars need to be checked assuming the hp bars are "stacked" on top of each other
horizontal_checks := 5			;How many many "segments" the hp bar will be split into, the less the faster
hpBars_x := 86 				;This holds the position of the first X to check in the game window, i.e. first hp bars "minimum" hp value
hpBars_y := 50  			;Same as above except it's Y
x_pad := 5				;The distance along the X axis between the segments in "horizontal_checks"
y_pad := 40				;The distance between the HP bars along the Y axis

loop 50 { 				;The main loop, which should be an infinity loop but, for testing they are bad so this loop 50 times only
	loop, % horizontal_checks {	;loop for the amount of segments in "horizontal_checks" 
		x_index := A_Index		;set the index of the horizontal check loop to a variable so we can use it inside the next loop
	
		loop, % hero_count {	;loop for the amount of individual hp bars on top of each other
			
			curr_x := hpBars_x + (x_pad * (x_index-1)) ;set the x location for the pixelgetcolor
			curr_y := hpBars_y + (y_pad * (A_Index-1)) ;set the x location for the pixelgetcolor
			
			pixelgetcolor,result, % curr_x, % curr_y,rgb	;Check the color of the current x and y and assign to "result"
			
			if (result != "0x0078D7") { 					;if the color of the pixelgetcolor isn't the color of the "hp", then proceed to heal 
				;!!!!! if the mouse doesn't start moving and doing it's thing then change the "0x3399FF" to the color of the progressbar's progress!!!!!
				
				earlyBreak := true 							;this is to restart the health checks from 0 position once done with the current "depth" instead of finishing the whole "grid"
				
				;~~ here you will write your healing sequence ~~;
				;mousemove, % curr_x, % curr_y, %mousemoveSpeed%
				mousemove, 250, % curr_y, %mousemoveSpeed%
				Click
				;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~;
				
			}
		}
		if (earlyBreak) { ;if earlyBreak was true then set it to false and break the loop
			earlyBreak := false
			break
		}
	}
}
return
rshift::exitapp