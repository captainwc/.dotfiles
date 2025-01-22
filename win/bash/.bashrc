# # oh-my-bash
# ## Enable the subsequent settings only in interactive sessions
# case $- in
#   *i*) ;;
#     *) return;;
# esac
#
# ## Path to your oh-my-bash installation.
# export OSH='/c/Users/wddjwk/.oh-my-bash'
#
# ##  vscode edsonarios agnoster
# OSH_THEME="powerbash10k"
#
# ## If you set OSH_THEME to "random", you can ignore themes you don't like.
# # OMB_THEME_RANDOM_IGNORED=("powerbash10k" "wanelo")
#
# # * 'mm/dd/yyyy'     # mm/dd/yyyy + time
# # * 'dd.mm.yyyy'     # dd.mm.yyyy + time
# # * 'yyyy-mm-dd'     # yyyy-mm-dd + time
# # * '[mm/dd/yyyy]'   # [mm/dd/yyyy] + [time] with colors
# # * '[dd.mm.yyyy]'   # [dd.mm.yyyy] + [time] with colors
# # * '[yyyy-mm-dd]'   # [yyyy-mm-dd] + [time] with colors
# ## If not set, the default value is 'yyyy-mm-dd'.
# # HIST_STAMPS='yyyy-mm-dd'
#
# OMB_USE_SUDO=true
#
# ## To enable/disable display of Python virtualenv and condaenv
# # OMB_PROMPT_SHOW_PYTHON_VENV=true  # enable
# # OMB_PROMPT_SHOW_PYTHON_VENV=false # disable
#
# plugins=(
#   git
#   bashmarks
# )
#
# source "$OSH"/oh-my-bash.sh
#
## windows bash 特有alias
export PS1="\[\e[32;1m\][\[\e[33;1m\]\u\[\e[31;1m\]@\[\e[33;1m\]\h \[\e[36;1m\]\w\[\e[32;1m\]]\[\e[34;1m\]\$ \[\e[0m\]"
# export PS1="|\[$(tput sgr0)\]\[$(tput setab 4)\]\[$(tput setaf 0)\] \u \[$(tput sgr0)\]\[$(tput setab 6)\]\[$(tput setaf 0)\]\[$(tput setaf 7)\]\w \[$(tput sgr0)\]\[$(tput setab 2)\]\[$(tput setaf 0)\]\[$(tput sgr0)\] \[$(tput bold)\]\[$(tput setaf 2)\]➜  \[$(tput sgr0)\]"

alias make='mingw32-make.exe'
alias jupyter='python -m notebook'

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

if [ -f ~/.bash_aliases_local ]; then
    . ~/.bash_aliases_local
fi

if [ -f ~/.bash_env ]; then
    . ~/.bash_env
fi

# aliases
# alias ls='ls -F --color=auto'
alias ls='lsd'
alias ll='ls -alhF --color=auto'
alias l='ls'
alias mkdir='mkdir -p'
alias gdb='gdb -q'
alias PATH='echo $PATH | xargs -d: -n1'
alias vimv='vim ~/.vimrc'
alias vime='vim ~/.bash_env'
alias sv='source ~/.vimrc > /dev/null 2>&1'
alias vimb='vim ~/.bashrc'
alias sb='source ~/.bashrc'
alias vima='vim ~/.bash_aliases'
alias vimal='vim ~/.bash_aliases_local'
alias hxv='hx ~/AppData/Roaming/helix/config.toml'

alias gits='git status'
alias gita='git add .'
alias gitb='git branch'
alias gitc='git checkout'
alias gitl='git log'
alias gitlg='git log --graph'
alias gitlo='git log --oneline'
alias gitlog='git log --oneline --graph'
alias gitr='git reset'
alias gitrh='git reset --hard'
alias gitrs='git reset --soft'
alias gitcm='git commit'

alias mk='mk.bat'

# alias du='du . -h -d 1'
alias du='dust'
alias dns='dog'
alias ps='procs'
alias diff='delta'
alias df='duf'
alias tree='broot'

#vlab
alias cpv='scp -i ~/.ssh/vlab-vm5941.pem'
alias vlab='shuaikai@vlab.ustc.edu.cn'

# 阿里云oss----------------------------------------------------------------------------------------------
ossdowndatevim() {
    curl -o ~/.vimrc https://shuaikai-bucket0001.oss-cn-shanghai.aliyuncs.com/config/vim/.vimrc.mine
    source ~/.vimrc
}
ossdowndatevimall() {
    cd ~
    curl -o .vimrc https://shuaikai-bucket0001.oss-cn-shanghai.aliyuncs.com/config/vim/.vimrc.mine
    curl -o vim-mine.tar.gz https://shuaikai-bucket0001.oss-cn-shanghai.aliyuncs.com/config/vim/vim-mine.tar.gz
    rm -rf .vim
    tar xf vim-mine.tar.gz
    source ~/.vimrc
    cd -
}
ossdowndatevscode() {
    cd /c/Users/wddjwk/AppData/Roaming/Code/User
    curl -o settings.json https://shuaikai-bucket0001.oss-cn-shanghai.aliyuncs.com/config/vscode/settings.json
    curl -o keybindings.json https://shuaikai-bucket0001.oss-cn-shanghai.aliyuncs.com/config/vscode/keybindings.json
    curl -o snippets/cpp.json https://shuaikai-bucket0001.oss-cn-shanghai.aliyuncs.com/config/vscode/snippets/cpp.json
    curl -o snippets/plantuml.json https://shuaikai-bucket0001.oss-cn-shanghai.aliyuncs.com/config/vscode/snippets/plantuml.json
    curl -o snippets/universal.code-snippets https://shuaikai-bucket0001.oss-cn-shanghai.aliyuncs.com/config/vscode/snippets/universal.code-snippets
    cd -
}

# functions

ipshow() {
    echo -en '[IPV4]: '
    curl 4.ipw.cn
    echo -en '\n[IPV6]: '
    curl 6.ipw.cn
    echo -en '\n[PREFERRED]: '
    curl test.ipw.cn
    echo ''
} 

bak() {
    for file in "$@"; do
        if [ -d ${file} ]; then
            cp -r "${file}" "${file}.bak"
        else
            cp "${file}" "${file}.bak"
        fi
    done
}

# windows的路径转换为bash的路径
# vscode用法 "cpp": "cd `chpath '$dir'`，注意单引号的妙处
chpath() {
  local tmp=${1#\"}
  local win_path=${tmp%\"}

  local unix_path="${win_path//\\//}"
  unix_path="${unix_path/:/}"

  unix_path="/${unix_path}"

  echo "$unix_path"
}

runc(){
    local file=chpath $1
}


## 快速编译运行java
class_path=.build_class
rjava() {
    if [[ $1 == *.java ]]; then
        if [[ ! -d $class_path ]]; then
            mkdir $class_path
        fi
        javac -encoding UTF-8 -d $class_path $1
        cd $class_path
        # class=${1#*\/}
        class=${1%.java}
        java $class ${@:2}
        cd - >/dev/null
    elif [[ $1 == *.class ]]; then
        cd $class_path
        class=${1#${class_path}/}
        class=${class%.class}
        java $class ${@:2}
        cd - >/dev/null
    elif [[ $1 == *.java. ]]; then
        cd $class_path
        class=${1%.java.}
        java $class ${@:2}
        cd - >/dev/null
    else
        echo "Invalid argument. Please provide a .java or . file."
    fi
}

cjava() {
    if [[ -e $class_path ]]; then
        rm -rf $class_path
    fi
}

cljava() {
    find *.class -delete
}

## cmake cpp 运行
BUILD=/d/projects/develop/leetcode/leetcode-cpp/build
run() {
    cd ${BUILD}
    cmake -DBUILD_SRC=ON .. >/dev/null
    make -j8 $1 >/dev/null
    ./bin/$1 -ni -nv
    cd - >/dev/null
}

## fzf

alias fls='fd -uu | fzf'

fcd() {
	local dir
	dir=$(fd ${1:-.} -uu --exclude "software" | fzf +m)
	if [ -d "$dir" ]; then
		cd "$dir"
	else
		cd "$(dirname "$dir")"
	fi
}

fopen() {
    local dir
	dir=$(fd $@ -uu --exclude "software" | fzf +m)
	if [ -d "$dir" ]; then
		cd "$dir"
	else
		cd "$(dirname "$dir")"
	fi
	explorer .
}
alias fexplorer=fopen

fpwd() {
    local dir
	dir=$(fd $@ -uu | fzf +m) && echo $(realpath $dir)
}

ff() {
    fd  $@ | fzf
}

fvim() {
    local file
	file=$(fd $@ --exclude "software" -t f | fzf +m) && vim $file
}
fsublime(){
	local file
	sublime_exe='/d/software/Sublime/sublime_text.exe'
	file=$(fd $@ --exclude "software" -t f | fzf +m) && ${sublime_exe} "${file}" 
}
fnvim() {
    local file
	file=$(fd $@ -t f | fzf +m) && nvim $file
}

fkill() {
    local pid
    pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')

    if [ "x$pid" != "x" ]; then
        echo $pid | xargs kill -${1:-9}
    fi
}

[ ! -f "$HOME/.x-cmd.root/X" ] || . "$HOME/.x-cmd.root/X" # boot up x-cmd.
