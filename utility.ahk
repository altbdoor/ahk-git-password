;========================================
;   JoinArray
;========================================
JoinArray(Arr, Glue)
{
	FinalString := ""
	
	Loop % Arr.Length()
	{
		FinalString .= Arr[A_Index] . Glue
	}
	
	Return SubStr(FinalString, 1, StrLen(FinalString) - 1)
}

;========================================
;   ShowHelp
;========================================
ShowHelp(Msg)
{
	MsgBox, 0x40, Help, %Msg%
	Return
}

;========================================
;   WriteSettings
;========================================
WriteSettings(Key, Value)
{
	global SettingsFile
	IniWrite, %Value%, %SettingsFile%, default, %Key%
	Return
}

;========================================
;   ReadSettings
;========================================
ReadSettings(Key, Default)
{
	global SettingsFile
	IniRead, Value, %SettingsFile%, default, %Key%, %Default%
	Return Value
}

;========================================
;   ExecuteGitCommand
;========================================
ExecuteGitCommand(InputUsername, InputPassword, InputRepeat, InputPath, InputPrompt, InputCommand, InputForce)
{
	If (InputPassword != "")
	{
		If (InputRepeat == "") or (InputRepeat == 0)
		{
			InputRepeat := 1
		}
	}
	Else
	{
		InputRepeat := 0
	}
	
	If (InputPath == "")
	{
		InputPath := A_WorkingDir
	}
	
	If (InputPrompt == "bash.exe")
	{
		Run, C:\Program Files\Git\bin\bash.exe, , , cmdpid
	}
	Else
	{
		Run, %comspec% /k, , , cmdpid
	}
	
	WinWait, ahk_pid %cmdpid%
	WinActivate, ahk_pid %cmdpid%
	
	KeypressesToSend := ""
	
	If (InputPrompt == "bash.exe")
	{
		StringReplace, TempPath, InputPath, :, , All
		StringReplace, TempPath, TempPath, \, /, All
		
		KeypressesToSend .= "cd """ . TempPath . """"
	}
	Else
	{
		KeypressesToSend .= "cd /d """ . InputPath . """"
	}
	
	KeypressesToSend .= "{Enter}" . InputCommand . "{Enter}"
	
	Loop, %InputRepeat%
	{
		If (InputUsername != "")
		{
			KeypressesToSend .= InputUsername . "{Enter}"
		}
		
		KeypressesToSend .= InputPassword . "{Enter}"
	}
	
	KeypressesToSend .= "exit"
	
	If (InputForce == 1) {
		KeypressesToSend .= "{Enter}"
	}
	
	SendInput, %KeypressesToSend%
	WinWaitClose, ahk_pid %cmdpid%
	
	Return
}
