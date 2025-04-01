# ==============================================
#  ANSI 颜色变量组
# ==============================================

# ========== 基础定义 ==========
Set-Variable ESC "$([char]27)"
Set-Variable ANSI_RESET "$ESC[0m"

# ========== 基础颜色 ==========
Set-Variable ANSI_BLACK "$ESC[30m"
Set-Variable ANSI_RED "$ESC[31m"
Set-Variable ANSI_GREEN "$ESC[32m"
Set-Variable ANSI_YELLOW "$ESC[33m"
Set-Variable ANSI_BLUE "$ESC[34m"
Set-Variable ANSI_MAGENTA "$ESC[35m"
Set-Variable ANSI_CYAN "$ESC[36m"
Set-Variable ANSI_WHITE "$ESC[37m"

# ========== 亮色模式 ==========
Set-Variable ANSI_BRIGHT_BLACK "$ESC[90m"
Set-Variable ANSI_BRIGHT_RED "$ESC[91m"
Set-Variable ANSI_BRIGHT_GREEN "$ESC[92m"
Set-Variable ANSI_BRIGHT_YELLOW "$ESC[93m"
Set-Variable ANSI_BRIGHT_BLUE "$ESC[94m"
Set-Variable ANSI_BRIGHT_MAGENTA "$ESC[95m"
Set-Variable ANSI_BRIGHT_CYAN "$ESC[96m"
Set-Variable ANSI_BRIGHT_WHITE "$ESC[97m"

# ========== 背景颜色 ==========
Set-Variable ANSI_BG_BLACK "$ESC[40m"
Set-Variable ANSI_BG_RED "$ESC[41m"
Set-Variable ANSI_BG_GREEN "$ESC[42m"
Set-Variable ANSI_BG_YELLOW "$ESC[43m"
Set-Variable ANSI_BG_BLUE "$ESC[44m"
Set-Variable ANSI_BG_MAGENTA "$ESC[45m"
Set-Variable ANSI_BG_CYAN "$ESC[46m"
Set-Variable ANSI_BG_WHITE "$ESC[47m"

# ========== 256色扩展 ==========
Set-Variable ANSI_ORANGE "$ESC[38;5;208m"
Set-Variable ANSI_PURPLE "$ESC[38;5;93m"
Set-Variable ANSI_PINK "$ESC[38;5;205m"
Set-Variable ANSI_LIME "$ESC[38;5;154m"
Set-Variable ANSI_GRAY "$ESC[38;5;245m"

# ========== RGB真彩色 ==========
Set-Variable ANSI_RGB_EMERALD "$ESC[38;2;80;200;120m"
Set-Variable ANSI_RGB_SUNSET "$ESC[38;2;255;94;77m"
Set-Variable ANSI_RGB_OCEAN "$ESC[38;2;0;155;255m"

# ========== 样式控制 ==========
Set-Variable ANSI_BOLD "$ESC[1m"
Set-Variable ANSI_DIM "$ESC[2m"
Set-Variable ANSI_ITALIC "$ESC[3m"
Set-Variable ANSI_UNDERLINE "$ESC[4m"
Set-Variable ANSI_BLINK "$ESC[5m"

# ==============================================
#  快捷键映射
# ==============================================

Set-PSReadLineKeyHandler -Chord 'Ctrl+u' -Function BackwardDeleteLine
Set-PSReadLineKeyHandler -Chord 'Ctrl+k' -Function ForwardDeleteLine
Set-PSReadLineKeyHandler -Chord 'Ctrl+e' -Function EndOfLine
Set-PSReadLineKeyHandler -Chord 'Ctrl+a' -Function BeginningOfLine

# ==============================================
#   常用命令别名
# ==============================================

function List-AllItems {
    lsd.exe -alhF
}

function Open-ProfileInSublime {
    subl.exe $PROFILE
}

function Open-LocalProfileInSublime {
    subl.exe "$(Split-Path $PROFILE)\local_profile.ps1"
}


Set-Alias -Name ls -Value lsd.exe
Set-Alias -Name ll -Value List-AllItems
Set-Alias -Name rm -Value rm.exe
Set-Alias -Name du -Value dust.exe
Set-Alias -Name df -Value duf.exe

Set-Alias -Name vimb -Value Open-ProfileInSublime
Set-Alias -Name vima -Value Open-ProfileInSublime
Set-Alias -Name vimal -Value Open-LocalProfileInSublime
Set-Alias -Name sb -Value $PROFILE

Set-Alias -Name vim -Value subl.exe
Set-Alias -Name nvim -Value subl.exe
Set-Alias -Name subl -Value subl.exe

# ==============================================
#  功能函数
# ==============================================

function fcd {
    param (
        [Parameter(ValueFromRemainingArguments = $true)] # 将所有未明确声明的参数收集到一个数组中
        [string[]]$args                                  # 实现类似 $@ 的效果
    )
    $selected = fd @args -uu --exclude "software" | fzf +m
    if (-not $selected) {
        Write-Host "${ANSI_RGB_SUNSET}No selection made.$ANSI_RGB_EMERALD"
        return
    }
    if (Test-Path -Path $selected -PathType Container) {
        Set-Location $selected
    }
    else {
        $dir = Split-Path -Parent $selected
        Set-Location $dir
    }
}

function fsubl {
    param (
        [Parameter(ValueFromRemainingArguments = $true)] # 将所有未明确声明的参数收集到一个数组中
        [string[]]$args                                  # 实现类似 $@ 的效果
    )
    $selected = fd @args -uu --exclude "software" | fzf +m
    if (-not $selected) {
        Write-Host "${ANSI_RGB_SUNSET}No selection made.$ANSI_RGB_EMERALD"
        return
    }
    subl.exe $selected
}

function rsubl {
    param (
        [Parameter(ValueFromRemainingArguments = $true)] # 将所有未明确声明的参数收集到一个数组中
        [string[]]$args                                  # 实现类似 $@ 的效果
    )
    $selected = rg -l @args | fzf +m
    if (-not $selected) {
        Write-Host "${ANSI_RGB_SUNSET}No selection made.$ANSI_RGB_EMERALD"
        return
    }
    subl.exe $selected
}

Set-Alias -Name fvim -Value fsubl
Set-Alias -Name fnvim -Value fsubl
Set-Alias -Name rvim -Value rsubl
Set-Alias -Name rnvim -Value rsubl

# ==============================================
#  自定义函数
# ==============================================

function ErrorReducer {
    param (
        [Parameter(ValueFromPipeline = $true)]
        $InputObject
    )
    $InputObject | python $HOME\.dotfiles\scripts\py\ErrorReducer.py
}

# ==============================================
#  命令提示符主题
# ==============================================

function global:prompt {
    $userColor = $ANSI_BRIGHT_YELLOW   # 用户名
    $atColor = $ANSI_RGB_SUNSET        # @符号
    $hostColor = $ANSI_BRIGHT_YELLOW   # 主机名
    $pathColor = $ANSI_BRIGHT_CYAN     # 路径
    $bracketColor = $ANSI_BRIGHT_GREEN # 括号
    $promptColor = $ANSI_BRIGHT_BLUE   # 提示符

    $user = $env:USERNAME
    $hostname = $env:COMPUTERNAME
    $currentPath = (Get-Location).Path.Replace($HOME, '~')

    "$bracketColor[$userColor$user$atColor@$hostColor$hostname " +
    "$pathColor$currentPath$bracketColor]$promptColor`$$ANSI_RESET "
}

# Oh-my-posh, [Themes See](https://ohmyposh.dev/docs/themes)
# oh-my-posh init pwsh --config "C:\Users\wddjwk\AppData\Local\Programs\oh-my-posh\themes\pararussel.omp.json" | Invoke-Expression


# ==============================================
#  加载本地配置文件
# ==============================================

if (Test-Path "$(Split-Path $PROFILE)\local_profile.ps1") {
    . "$(Split-Path $PROFILE)\local_profile.ps1"
}
