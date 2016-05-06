;========================================
;   Help text
;========================================
If (ParamList[1] == "help")
{
	HelpText = 
(
There are four configurations, and the configuration file (settings.ini) is created at where the exe file lives.

username : The username for the Git repository.
password : The password for the Git repository.
prompt : Choose between using Windows CMD (cmd.exe) or Git Bash (bash.exe).
force : Close console after command completion, regardless of error or success (0 or 1).

To change the configuration:
ahk_git_password config username "john_doe"
ahk_git_password config password "Shiny New Password"
ahk_git_password config prompt cmd.exe
ahk_git_password config force 0

To show all configurations:
ahk_git_password config show

For this help message:
ahk_git_password help

To run this exe with Git calls:
ahk_git_password git pull

If this is too cryptic, please consider configuring your Git appropriately, before considering the GUI counterpart of this script.
)
	
	ShowHelp(HelpText)
}
;========================================
;   Config handling
;========================================
Else If (ParamList[1] == "config")
{
	If (ParamList[2] == "show")
	{
		MsgStr := ""
		
		For Index, Item in SettingsNameList
		{
			IniValue := ReadSettings(Item, "Not set")
			MsgStr := MsgStr . Item . ": " . IniValue . "`n"
		}
		
		MsgBox, 0x40, Settings, %MsgStr%
	}
	Else
	{
		IsConfigValid := 0
		
		For Index, Item in SettingsNameList
		{
			IsConfigValid := Item == ParamList[2]
			
			If (IsConfigValid)
			{
				WriteSettings(ParamList[2], ParamList[3])
				Break
			}
		}
	}
}
;========================================
;   Main execution
;========================================
Else
{
	IniUsername := ReadSettings("username", "Username")
	IniPassword := ReadSettings("password", "Password")
	IniPrompt := ReadSettings("prompt", "cmd.exe")
	IniForce := ReadSettings("force", "0")
	
	InputCommand := JoinArray(ParamList, " ")
	
	ExecuteGitCommand(IniUsername, IniPassword, 1, A_WorkingDir, IniPrompt, InputCommand, IniForce)
}
