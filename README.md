# ahk git password

#### First up, give [this StackOverflow question](http://stackoverflow.com/questions/11506124/how-to-enter-command-with-password-for-git-pull) a _very very_ good read, and ask yourself if you _really really_ want to walk down this treacherous path.

![capture](https://cloud.githubusercontent.com/assets/3540471/14739600/32e30d5e-08bb-11e6-9d51-46e1a41a4e41.png)

### Why

- Working on a project.
- Have no access to Git server.
- People with access did not give SSH access (yet).
- Somehow `_netrc` and [Windows Git Credential](https://github.com/Microsoft/Git-Credential-Manager-for-Windows) did not work.
- Sick of typing passwords on every `git pull`.
- [AHK](https://autohotkey.com/) is the easiest language available on system to code GUI.

### Usage

| Field | Default | Description |
| --- | --- | --- |
| Project Path | `C:\` | The path to your Git project that you would like to execute commands to. |
| Git Command | `git pull` | The string of command you would like to execute. Do note that you can use `&&` to chain commands. |
| Git Password | `Password` | The password for the Git repository. |
| Password Repeat | 1 | The number of times you want to repeat the password for long, chained commands. |
| CMD Prompt | `cmd.exe` | Choose between using Windows CMD or Git Bash. |
| Exit after command completed? | False | Close console after command completion, regardless of error or success. |

### Warning

1. This was written with non-destructive Git commands in mind. **If one decides to type in `rm -rf ./* && git push --force` in the Git Command field, then it will be executed**. No filters, no safenets.

2. It will create a `settings.ini` file to **store all previous inputs, including the Git Password**. Which means the password security is as good as plain text. I did mention something about being treacherous.

### Notes

1. As mentioned, the `settings.ini` will store all previous inputs. It is to prevent typing in the fields again on the next startup. The **Git Command** field is more unique, as it will store the previous 20 commands.

2. If `bash.exe` is selected, it will attempt to open `bash.exe` in `C:\Program Files\Git\bin\bash.exe`. This should be accurate if Git is installed with the right architecture (32 bit or 64 bit).

3. Binaries or downloads? Check the [releases](https://github.com/altbdoor/ahk-git-password/releases) page.
