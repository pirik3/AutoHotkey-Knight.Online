#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

;Credit: https://www.reddit.com/r/AutoHotkey/comments/gybnyu/discord_webhook_post_fancy_edition/
;User Settings -> Notifications -> Push Notification Inactive Timeout: 1 minute
;Turn on Discord Developer Mode: User Settings -> Appearance -> Scroll to bottom and check developer mode
;Make sure to disable streamer mode User Settings -> Streamer Mode -> Disable
		;This allows you to copy User/Server IDs when you right Click
		;Use that ID in your content message as <@USERID> to do @mentions
		;` Example: <@12345678910112> or <#channelID>
	  ;Generate webhook for channel


sendError("denem123")

sendError(msg){
	url:="" ; Discord uzerinden, Server Setting --> integration -> Web Hook 'dan yeni kanal icin link al.
	postdata=
	(
	{
	  "content": "%msg%"
	}
	) ;Use https://leovoel.github.io/embed-visualizer/ to generate above webhook code
	
	WebRequest := ComObjCreate("WinHttp.WinHttpRequest.5.1")
	WebRequest.Open("POST", url, false)
	WebRequest.SetRequestHeader("Content-Type", "application/json")
	WebRequest.Send(postdata)  
}
