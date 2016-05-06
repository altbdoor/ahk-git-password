;========================================
;   Settings
;========================================
#SingleInstance force
#NoTrayIcon
#Include utility.ahk

SettingsFile := A_ScriptDir . "/settings.ini"

SettingsCommandList := ["git pull", "git push", "git fetch"]
SettingsNameList := ["username", "password", "prompt", "force"]

;========================================
;   Load CLI arguments
;========================================
ParamList := []
Loop, %0%
{
	CurrentParam := %A_Index%
	ParamList.Insert(CurrentParam)
}

;========================================
;   Decide if GUI or CLI
;========================================
If (ParamList.Length() == 0)
{
	#Include gui.ahk
}
Else
{
	#Include cli.ahk
}

ExitApp
