<#
 * FileName: Microsoft.PowerShell_profile.ps1
 * Author: Leyuan Jia
 * Email: Leyuan.Jia@outlook.com
 * Date: 2021, Aug. 24th
 * Copyright: No copyright. You can use this code for anything with no warranty.
#>


#------------------------------- Import Modules BEGIN -------------------------------
# 引入 posh-git
Import-Module posh-git

# 引入 oh-my-posh
Import-Module oh-my-posh

# 设置 PowerShell 主题
# Sorin/Agnoster/Paradox/half-life/material/pure/ys/spaceship/space
# Get-PoshThemes查看所有主题
Set-PoshPrompt -Theme truehappy
#------------------------------- Import Modules END   -------------------------------





#-------------------------------  Set Hot-keys BEGIN  -------------------------------
# 设置 Tab 键补全
# Set-PSReadlineKeyHandler -Key Tab -Function Complete

# 设置 Ctrl+d 为菜单补全和 Intellisense
Set-PSReadLineKeyHandler -Key "Tab" -Function MenuComplete

# 设置 Ctrl+d 为退出 PowerShell
Set-PSReadlineKeyHandler -Key "Ctrl+d" -Function ViExit

# 设置 Ctrl+z 为撤销
Set-PSReadLineKeyHandler -Key "Ctrl+z" -Function Undo

# 设置向上键为后向搜索历史记录
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward

# 设置向下键为前向搜索历史纪录
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
#-------------------------------  Set Hot-keys END    -------------------------------





#-------------------------------    Functions BEGIN   -------------------------------
# Python 直接执行
$env:PATHEXT += ";.py"

# 更新 pip 的方法
function Update-Packages {
    # update pip
    Write-Host "Step 1: 更新 pip" -ForegroundColor Magenta -BackgroundColor Cyan
    $a = pip list --outdated
    $num_package = $a.Length - 2
    for ($i = 0; $i -lt $num_package; $i++) {
        $tmp = ($a[2 + $i].Split(" "))[0]
        pip install -U $tmp
    }

    # update TeX Live
    $CurrentYear = Get-Date -Format yyyy
    Write-Host "Step 2: 更新 TeX Live" $CurrentYear -ForegroundColor Magenta -BackgroundColor Cyan
    tlmgr update --self
    tlmgr update --all
}

# ssh-copy-id 拷贝服务器公钥到本地
function ssh-copy-id([string]$userAtMachine, $args){   
    $publicKey = "$ENV:USERPROFILE" + "/.ssh/id_rsa.pub"
    if (!(Test-Path "$publicKey")){
        Write-Error "ERROR: failed to open ID file '$publicKey': No such file"            
    }
    else {
        & cat "$publicKey" | ssh $args $userAtMachine "umask 077; test -d .ssh || mkdir .ssh ; cat >> .ssh/authorized_keys || exit 1"      
    }
}
#-------------------------------    Functions END     -------------------------------





#-------------------------------   Set Alias Begin    -------------------------------
# 1. 编译函数 make
function MakeThings {
    nmake.exe $args -nologo
}
Set-Alias -Name make -Value MakeThings

# 2. 更新系统 os-update
Set-Alias -Name os-update -Value Update-Packages

# 3. 查看目录 ls & ll
function ListDirectory {
    (Get-ChildItem).Name
    Write-Host("")
}
Set-Alias -Name ls -Value ListDirectory
Set-Alias -Name ll -Value Get-ChildItem
#-------------------------------    Set Alias END     -------------------------------