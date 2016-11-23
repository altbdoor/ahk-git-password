;========================================
;   Main GUI
;========================================
GUI:
	IniPath := ReadSettings("path", "C:\")
	IniCommand := ReadSettings("command", A_Space)
	IniUsername := ReadSettings("username", "Username")
	IniPassword := ReadSettings("password", "Password")
	IniRepeat := ReadSettings("repeat", "1")
	IniPrompt := ReadSettings("prompt", "cmd.exe")
	IniForce := ReadSettings("force", "0")
	
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
	
	Gui, Add, Text, w110 h24 x10 y74, Git Username:
	Gui, Add, Edit, Text w270 h24 x120 y70 vInputUsername, %IniUsername%
	
	Gui, Add, Text, w110 h24 x10 y104, Git Password:
	Gui, Add, Edit, Text w270 h24 x120 y100 vInputPassword, %IniPassword%
	
	Gui, Add, Text, w110 h24 x10 y134, Repeat:
	Gui, Add, Edit, Number w70 h24 x120 y130 vInputRepeat, %IniRepeat%
	
	Gui, Add, Text, w380 h1 x10 y161 0x5
	
	Gui, Add, Text, w110 h24 x10 y174, CMD Prompt:
	Gui, Add, DropDownList, w270 x120 y170 vInputPrompt, cmd.exe||bash.exe
	
	If (IniPrompt == "bash.exe")
	{
		GuiControl, Choose, InputPrompt, 2
	}
	
	Gui, Add, Checkbox, w270 h24 x120 y200 vInputForce, Exit after command completed?
	GuiControl, , InputForce, %IniForce%
	
	Gui, Add, Button, Center w70 h40 x10 y230 gExecuteHelp, Help
	Gui, Add, Button, Default Center w305 h40 x85 y230 gExecuteSubmit, Execute
	
	Gui, Show, Center w400, AHK Git Password
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

Git Username : The username for the Git repository. This will most likely be left blank for most of the time, included it just because.

Git Password : The password for the Git repository.

Repeat : The number of times you want to repeat the username/password for long, chained commands.

CMD Prompt : Choose between using Windows CMD or Git Bash.

Exit after command completed? : Close console after command completion, regardless of error or success.
)
	
	ShowHelp(HelpText)
Return

;========================================
;   ExecuteSubmit
;========================================
ExecuteSubmit:
	Gui, Submit, NoHide
	
	ExecuteGitCommand(InputUsername, InputPassword, InputRepeat, InputPath, InputPrompt, InputCommand, InputForce)
	
	WriteSettings("path", InputPath)
	
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
		WriteSettings("command", TempCommandList)
		
		TempCommandList := JoinArray(SettingsCommandList, "|")
		GuiControl, , InputCommand, %TempCommandList%
	}
	
	WriteSettings("username", InputUsername)
	WriteSettings("password", InputPassword)
	WriteSettings("repeat", InputRepeat)
	WriteSettings("prompt", InputPrompt)
	WriteSettings("force", InputForce)
Return

;========================================
;   GuiClose
;========================================
GuiClose:
	ExitApp
Return
