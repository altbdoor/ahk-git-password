;========================================
;   Variables
;========================================
#SingleInstance force
#NoTrayIcon

SettingsFile := "settings.ini"
SettingsSection := "default"

SettingsCommandList := ["git pull", "git push", "git fetch"]

;========================================
;   Main GUI
;========================================
GUI:
	IniRead, IniPath, %SettingsFile%, %SettingsSection%, path, C:\
	IniRead, IniCommand, %SettingsFile%, %SettingsSection%, command, %A_Space%
	IniRead, IniPassword, %SettingsFile%, %SettingsSection%, password, Password
	IniRead, IniRepeat, %SettingsFile%, %SettingsSection%, repeat, 1
	IniRead, IniPrompt, %SettingsFile%, %SettingsSection%, prompt, cmd.exe
	IniRead, IniForce, %SettingsFile%, %SettingsSection%, force, 0
	
	Gui, Font, s10, Arial
	
	Gui, Add, Text, w110 h24 x10 y14, Project Path:
	Gui, Add, Edit, Text w195 h24 x120 y10 vInputPath, %IniPath%
	Gui, Add, Button, Center w70 h24 x320 y10 gExecutePathSelect, Select
	
	Gui, Add, Text, w110 h24 x10 y44, Git Command:
	Gui, Add, ComboBox, w270 x120 y40 vInputCommand
	
	If (IniCommand != "")
	{
		SettingsCommandList := []
		Loop, parse, IniCommand, `,
		{
			SettingsCommandList.Push(A_LoopField)
		}
	}
	
	TempInputCommand := JoinArray(SettingsCommandList, "|")
	GuiControl, , InputCommand, %TempInputCommand%
	GuiControl, Choose, InputCommand, 1
	
	Gui, Add, Text, w110 h24 x10 y74, Git Password:
	Gui, Add, Edit, Text w270 h24 x120 y70 vInputPassword, %IniPassword%
	
	Gui, Add, Text, w110 h24 x10 y104, Password Repeat:
	Gui, Add, Edit, Number w70 h24 x120 y100 vInputRepeat, %IniRepeat%
	
	Gui, Add, Text, w380 h1 x10 y131 0x5
	
	Gui, Add, Text, w110 h24 x10 y144, CMD Prompt:
	Gui, Add, DropDownList, w270 x120 y140 vInputPrompt, cmd.exe||bash.exe
	
	If (IniPrompt == "bash.exe")
	{
		GuiControl, Choose, InputPrompt, 2
	}
	
	Gui, Add, Checkbox, w270 h24 x120 y170 vInputForce, Exit after command completed?
	GuiControl, Choose, InputForce, %IniForce%, 
	
	Gui, Add, Button, Center w70 h40 x10 y200 gExecuteHelp, Help
	Gui, Add, Button, Default Center w305 h40 x85 y200 gExecuteSubmit, Execute
	
	Gui, Show, Center w400, Git Password
Return

;========================================
;   ExecutePathSelect
;========================================
ExecutePathSelect:
	GuiControlGet, InputPath
	FileSelectFolder, InputSelectedPath, *%InputPath%, , Select path to Git project
	
	If (InputSelectedPath != "")
	{
		GuiControl, , InputPath, %InputSelectedPath%
	}
Return

;========================================
;   ExecuteHelp
;========================================
ExecuteHelp:
	HelpText = 
(
Project Path : The path to your Git project that you would like to execute commands to.

Git Command : The string of command you would like to execute. Do note that you can use "&&" to chain commands.

Git Password : The password for the Git repository.

Password Repeat : The number of times you want to repeat the password for long, chained commands.

CMD Prompt : Choose between using Windows CMD or Git Bash.

Exit after command completed? : Close console after command completion, regardless of error or success.
)
	
	MsgBox, 0x40, Help, %HelpText%
Return

;========================================
;   ExecuteSubmit
;========================================
ExecuteSubmit:
	Gui, Submit, NoHide
	
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
		InputPath := "./"
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
	
	If (InputPrompt == "bash.exe")
	{
		StringReplace, TempInputPath, InputPath, :, , All
		StringReplace, TempInputPath, TempInputPath, \, /, All
		SendInput, cd "/%TempInputPath%"
	}
	Else
	{
		SendInput, cd /d "%InputPath%"
	}
	
	Send {Enter}
	
	SendInput, %InputCommand%
	Send {Enter}
	
	Loop, %InputRepeat%
	{
		Sleep 100
		SendInput, %InputPassword%
		Send {Enter}
	}
	
	SendInput, exit
	
	If (InputForce == 1) {
		Send {Enter}
	}
	
	IniWrite, %InputPath%, %SettingsFile%, %SettingsSection%, path
	
	If (InputCommand != "") and (InputCommand != SettingsCommandList[1])
	{
		SettingsCommandList.InsertAt(1, InputCommand)
		TempLength := SettingsCommandList.Length() - 20
		
		If (TempLength > 0)
		{
			Loop %TempLength%
			{
				SettingsCommandList.Pop(TempIndex)
			}
		}
		
		TempCommandList := JoinArray(SettingsCommandList, ",")
		IniWrite, %TempCommandList%, %SettingsFile%, %SettingsSection%, command
		
		TempCommandList := JoinArray(SettingsCommandList, "|")
		GuiControl, , InputCommand, %TempCommandList%
	}
	
	IniWrite, %InputPassword%, %SettingsFile%, %SettingsSection%, password
	IniWrite, %InputRepeat%, %SettingsFile%, %SettingsSection%, repeat
	IniWrite, %InputPrompt%, %SettingsFile%, %SettingsSection%, prompt
	IniWrite, %InputForce%, %SettingsFile%, %SettingsSection%, force
Return

;========================================
;   JoinArray
;========================================
JoinArray(Arr, Glue) {
	FinalString := ""
	
	Loop % Arr.Length()
	{
		FinalString .= Arr[A_Index] . Glue
	}
	
	Return SubStr(FinalString, 1, StrLen(FinalString) - 1)
}

;========================================
;   GuiClose
;========================================
GuiClose:
	ExitApp
Return
