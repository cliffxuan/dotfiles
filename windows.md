## WSL

### wslu
wslu 
`curl -OL https://github.com/wslutilities/wslu/archive/refs/tags/v4.1.3.tar.gz`

use wslview from wslu for BROWSER envvar
`export BROWSER='/usr/bin/wslview'`

this allows the commands in terminal to open browers, e.g. AWS sso login, git github auth


## pip.ini
```
# path: c:\Users\<name>\AppData\Roaming\pip\pip.ini
[global]
cert = C:/Users/<name>/<cert_file>
index-url = https://<registry>/artifactory/api/pypi/pypi/simple
index = https://<registry>/artifactory/api/pypi/pypi/simple
trusted-host = <host>
```

## npmrc
```
# path c:\Users\<name>\.npmrc
registry = "https://<registry>/artifactory/api/npm/npm-new/"
save-exact = true
save-prefix = ""
strict-ssl = false
```

## scoop

 ``` Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
iex (new-object net.webclient).downloadstring('https://get.scoop.sh')

scoop install neovim fd ripgrep bat fzf delta lf cmake

# important!
scoop config '7ZIPEXTRACT_USE_EXTERNAL' $true


## vscode
```
~/AppData/Roaming/Code/User/keybindings.json
~/AppData/Roaming/Code/User/settings.json
```

## link
cmd
directory:  
`mklink /J new old `
`mklink /J C:\home\.config\nvim C:\home\dev\dotfiles\nvim-config`
file
`mklink /H new old`

powershell
```
New-Item -Path C:\Users\<user>\scoop\apps\vscode\current\data\user-data\User\settings.json -ItemType HardLink -Value C:\Users\<user>\dev\dotfiles\config\vscode\settings.json
New-Item -Path C:\Users\<user>\scoop\apps\vscode\current\data\user-data\User\keybindings.json -ItemType HardLink -Value C:\Users\<user>\dev\dotfiles\config\vscode\keybindings.json
```


# profile

## six powershell profiles

```
> $profile
```
https://devblogs.microsoft.com/scripting/understanding-the-six-powershell-profiles/

## setting

C:\Users\<user>\Documents\PowerShell\Microsoft.PowerShell_profile.ps1

```
Set-PSReadLineOption -EditMode Vi
Set-PSReadLineKeyHandler -Chord Ctrl-w -Function BackwardKillWord -ViMode Insert
Set-PSReadLineKeyHandler -Chord Ctrl-p -Function PreviousHistory -ViMode Insert
Set-PSReadLineKeyHandler -Chord Ctrl-n -Function NextHistory -ViMode Insert
Set-PSReadLineKeyHandler -Chord Ctrl-k -Function ForwardDeleteInput -ViMode Insert
Set-PSReadLineKeyHandler -Chord Ctrl-a -Function BeginningOfLine -ViMode Insert
Set-PSReadLineKeyHandler -Chord Ctrl-e -Function EndOfLine -ViMode Insert

#Set-PSReadLineKeyHandler -Chord Tab -Function Complete
#Set-PSReadLineKeyHandler -Key Tab -ScriptBlock { Invoke-FzfTabCompletion }
#Set-PsFzfOption -TabExpansion
#Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'
# Invoke-Expression (& {(zoxide init powershell | Out-String)})
Invoke-Expression (&starship init powershell)


# alias
New-Alias which Get-Command
New-Alias n nvim


function gs {
  git status
}

function gd {
  git diff
}

$Env:STARSHIP_LOG="trace starship timings"

```

## change profile

To change the user folder change this value:
Item: HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders
Property: Personal

https://learn.microsoft.com/en-us/answers/questions/846079/how-to-change-profile-value-in-powershell


## fzf

https://github.com/kelleyma49/PSFzf?tab=readme-ov-file
