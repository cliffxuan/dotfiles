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
`mklink /J C:\home\.config\nvim C:\home\dev\dotfiles\vimfiles`
file
`mklink /H new old`

powershell
```
New-Item -Path C:\Users\<user>\scoop\apps\vscode\current\data\user-data\User\settings.json -ItemType HardLink -Value C:\Users\<user>\dev\dotfiles\config\vscode\settings.json
New-Item -Path C:\Users\<user>\scoop\apps\vscode\current\data\user-data\User\keybindings.json -ItemType HardLink -Value C:\Users\<user>\dev\dotfiles\config\vscode\keybindings.json
```
