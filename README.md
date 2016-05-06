# ahk git password

#### First up, give [this StackOverflow question](http://stackoverflow.com/questions/11506124/how-to-enter-command-with-password-for-git-pull) a _very very_ good read, and ask yourself if you _really really_ want to walk down this treacherous path.

#### Why

- Working on a project.
- Have no access to Git server.
- People with access did not give SSH access (yet).
- Somehow `_netrc` and [Windows Git Credential](https://github.com/Microsoft/Git-Credential-Manager-for-Windows) did not work.
- Sick of typing passwords on every `git pull`.
- [AHK](https://autohotkey.com/) is the easiest language available on system to code GUI.

#### GUI Usage

![capture](https://cloud.githubusercontent.com/assets/3540471/15065513/19a9762e-1393-11e6-9db1-3ac2496c7180.png)

| Field | Default | Description |
| --- | --- | --- |
| Project Path | `C:\` | The path to your Git project that you would like to execute commands to. |
| Git Command | `git pull` | The string of command you would like to execute. Do note that you can use `&&` to chain commands. |
| Git Username | `Username` | The username for the Git repository. This will most likely be left blank for most of the time, included it just because. |
| Git Password | `Password` | The password for the Git repository. |
| Repeat | 1 | The number of times you want to repeat the username/password for long, chained commands. |
| CMD Prompt | `cmd.exe` | Choose between using Windows CMD or Git Bash. |
| Exit after command completed? | False | Close console after command completion, regardless of error or success. |

#### CLI Usage

AHK was not exactly designed for CLI use, but since I spend more time on CLI, I decided to make this as well.

| Field | Default | Description |
| --- | --- | --- |
| username | `Username` | The username for the Git repository. This will most likely be left blank for most of the time, included it just because. |
| password | `Password` | The password for the Git repository. |
| prompt | `cmd.exe` | Choose between using Windows CMD (cmd.exe) or Git Bash (bash.exe). |
| force | False | Close console after command completion, regardless of error or success (0 or 1). |

```bat
:: To change the configuration
ahk_git_password config username "john_doe"
ahk_git_password config password "Shiny New Password"
ahk_git_password config prompt bash.exe
ahk_git_password config force 1

:: To show all configurations
ahk_git_password config show

:: For help message
ahk_git_password help

:: To run this exe with Git calls
ahk_git_password git checkout master && git pull
```

#### Warning

1. This was written with non-destructive Git commands in mind. **If one decides to type in `rm -rf ./* && git push --force` in the Git Command field, then it will be executed**. No filters, no safenets.

2. It will create a `settings.ini` file to **store all previous inputs, including the Git Password**. Which means the password security is as good as plain text. I did mention something about being treacherous.

#### Notes

1. As mentioned, the `settings.ini` will store all previous inputs. It is to prevent typing in the fields again on the next startup. The **Git Command** field in GUI is more unique, as it will store the previous 20 commands.

2. If `bash.exe` is selected, it will attempt to open `bash.exe` in `C:\Program Files\Git\bin\bash.exe`. This should be accurate if Git is installed with the right architecture (32 bit or 64 bit).

3. Binaries or downloads? Check the [releases](https://github.com/altbdoor/ahk-git-password/releases) page.
