# tools
alias ll='ls -alhF --color=auto'
alias la='ls -aF --color=auto'
alias l='ls -ahF --color=none'
alias gdb='gdb -q'

# git
alias gitl='git log'
alias gitlg='git log --graph'
alias gitlo='git log --oneline'
alias gitlog='git log --oneline --graph'

# convinence
alias PATH='echo $PATH | xargs -d: -n1'
alias cman='man -M /usr/share/man/zh_CN'
alias sb='source ~/.bashrc'
alias sz='source ~/.zshrc'
alias sv='source ~/.vimrc > /dev/null 2>&1'
alias vimb='vim ~/.bashrc'
alias vimz='vim ~/.zshrc'
alias vimv='vim ~/.vimrc'
alias vima='vim ~/.bash_aliases'
alias vimal='vim ~/.bash_aliases_local'
alias vime='vim ~/.bash_env'

# 彩色的less（彩色man手册）
export LESS_TERMCAP_mb=$'\e[01;31m'    # 开始加粗（红色）
export LESS_TERMCAP_md=$'\e[01;31m'    # 加粗（红色）
export LESS_TERMCAP_me=$'\e[0m'        # 结束加粗
export LESS_TERMCAP_so=$'\e[01;44;33m' # 高亮背景（黄色文字，蓝色背景）
export LESS_TERMCAP_se=$'\e[0m'        # 结束高亮
export LESS_TERMCAP_us=$'\e[01;32m'    # 下划线（绿色）
export LESS_TERMCAP_ue=$'\e[0m'        # 结束下划线
export LESS_TERMCAP_mr=$'\e[01;31m'    # 反显（红色）
export LESS_TERMCAP_mh=$'\e[01;34m'    # 半高亮（蓝色）

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

color() {
    local colors=({30..37} {40..47})
    for code in ${colors[@]}; do
        echo -en "\e[${code}m"'\\e['"$code"'m'"\e[0m"
        echo -en "\e[$code;1m"'\\e['"$code"';1m'"\e[0m"
        echo -en "\e[$code;3m"'\\e['"$code"';3m'"\e[0m"
        echo -en "\e[$code;4m"'\\e['"$code"';4m'"\e[0m"
        echo -e "\e[$((code + 60))m"'\\e['"$((code + 60))"'m'"\e[0m"
    done
}

install() {
    sudo mv $@ /usr/local/bin/
}

# 编译运行
mk() {
    if [ "$#" -ne 1 ]; then
        echo "Usage: mk <filename>"
        return 1
    fi

    local file="$1"
    local extension="${file##*.}"
    local base="${file%.*}"

    if [ ! -f "$file" ]; then
        echo "File '$file' does not exist."
        return 1
    fi

    case "$extension" in
    cpp)
        echo "Compiling C++ file '$file'..."
        g++ "$file" -o "$base" -std=c++20 -g
        if [ $? -eq 0 ]; then
            echo "Running executable '$base'..."
            ./"$base"
        else
            echo "Compilation failed."
        fi
        ;;
    c)
        echo "Compiling C file '$file'..."
        gcc "$file" -o "$base" -g
        if [ $? -eq 0 ]; then
            echo "Running executable '$base'..."
            ./"$base"
        else
            echo "Compilation failed."
        fi
        ;;
    py)
        echo "Running Python file '$file'..."
        python3 "$file"
        ;;
    sh)
        echo "Running shell script '$file'..."
        bash "$file"
        ;;
    lua)
        echo "Running Lua script '$file'..."
        lua "$file"
        ;;
    go)
        echo "Compiling Go file '$file'..."
        go build -o "$base" "$file"
        if [ $? -eq 0 ]; then
            echo "Running executable '$base'..."
            ./"$base"
        else
            echo "Compilation failed."
        fi
        ;;
    *)
        echo "Unsupported file type: .$extension"
        return 1
        ;;
    esac
}

## quick tmux

alias tmuxkillall='tmux kill-server'
# alias tmuxkillall="tmux list-sessions | awk -F: '{print $1}' | xargs -n 1 tmux kill-session -t"

tmux2() {
    if [ $# -ne 2 ]; then
        echo "Give me TWO executables to split the tmux"
        return
    fi

    session_name="$(basename "$1" .${1##*.})_$(basename "$2" .${2##*.})"
    tmux kill-session -t ${session_name} 2>/dev/null
    tmux new-session -d -s "cs_${session_name}"
    tmux split-window -h
    tmux select-pane -t 1
    tmux send-keys "$1" C-m
    tmux select-pane -t 2
    tmux send-keys "$2" C-m
    tmux attach-session -t "cs_${session_name}"
}

tmux3() {
    if [ $# -ne 3 ]; then
        echo "Give me THREE executables to split the tmux"
        return
    fi

    session_name="$(basename "$1" .${1##*.})_$(basename "$2" .${2##*.})_$(basename "$3" .${3##*.})"
    tmux kill-session -t ${session_name} 2>/dev/null
    tmux new-session -d -s "cs_${session_name}"
    tmux split-window -h
    tmux select-pane -t 2
    tmux split-window -v
    tmux select-pane -t 1
    tmux send-keys "$1" C-m
    tmux select-pane -t 2
    tmux send-keys "$2" C-m
    tmux select-pane -t 3
    tmux send-keys "$3" C-m
    tmux attach-session -t "cs_${session_name}"
}

## rg + fzf
rvim() {
    local file
    file=$(rg $@ -l | fzf) && vim "$file"
}

rnvim() {
    local file
    file=$(rg $@ -l | fzf) && nvim "$file"
}

## locate + fzf
lnvim() {
    local file
    file=$(locate $@ | fzf) && nvim $file
}

## fd + fzf
ftmux2() {
    local server client
    server=$(fd -t f -uu . $@ | fzf)
    client=$(fd -t f -uu . $@ | fzf)
    tmux2 ${server} ${client}
}

ftmux3() {
    local server client1 client2
    server=$(fd -t f -uu . $@ | fzf)
    client1=$(fd -t f -uu . $@ | fzf)
    client2=$(fd -t f -uu . $@ | fzf)
    tmux3 ${server} ${client1} ${client2}
}

fcd() {
    local dir
    dir=$(fd . $@ | fzf)
    if [ -d $dir ]; then
        cd $dir
    else
        cd $(dirname "$dir")
    fi
}

fpwd() {
    local dir
    dir=$(fd . $@ | fzf) && echo $(realpath "$dir")
}

fvim() {
    local file
    file=$(fd . $@ | fzf) && vim "$file"
}

fnvim() {
    local file
    file=$(fd . $@ | fzf) && nvim $file
}

fbat() {
    local file
    file=$(fd . $@ | fzf) && bat $file
}

fcat() {
    local file
    file=$(fd . $@ | fzf) && cat $file
}

fkill() {
    local pid
    pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')

    if [ "x$pid" != "x" ]; then
        echo $pid | xargs kill -${1:-9}
    fi
}

### software manage (only for linux)
update-nvim() {
	wget -O /tmp/nvim.tar.gz https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
	sudo rm -rf /opt/nvim-linux-x86_64
	sudo tar xf /tmp/nvim.tar.gz -C /opt
	rm /tmp/nvim.tar.gz
	echo "DONE!"
}

### perf
#（1） perf report：一步到位
perf_report() {
    sudo perf record -g -- $1 && sudo perf report
}

#（2） 生成火焰图，并可通过浏览器进行访问（主要针对虚拟机，没在正常平台上试验过）
#       $1:命令, $2:svg文件无后缀名称, $3:port, $4:网卡名，如ens33
perf_flame() {
    local SvgPath=$(pwd)
    local FlameGraphSvgPath=/opt/FlameGraph
    local filename=${2:-perf-flamegraph}.svg
    local vm_ip=$(ip address show ${4:-eth0} | /usr/bin/grep -oP '(?<=inet\s)\d+\.\d+\.\d+\.\d+' | awk 'NR==1{print $1}')
    local vm_port=${3:-8000}
    local svg_link="http://${vm_ip}:${vm_port}/${filename}"

    sudo perf record -F 99 -g -- $1
    sudo perf script -f >perf.out

    perl ${FlameGraphSvgPath}/stackcollapse-perf.pl ${SvgPath}/perf.out | grep -v '^#' | perl ${FlameGraphSvgPath}/flamegraph.pl >${SvgPath}/${filename}

    echo -e "\n-----------------------------= PERF FLAME GRAPH =-----------------------------\n"
    echo -e "\e[1;33m Now you can view the SVG file by clicking \e[4;34m${svg_link}\e[0m"
    echo -e "\n------------------------------------------------------------------------------\n"

    python3 -m http.server --directory ${SvgPath} --bind ${vm_ip} ${vm_port}
}

########################################
# DEPRECATED
########################################

### redis : redisc [host] [port]  &  redisrun  &  redisstop
AUTH=shuaikaisredis
alias redisrun='redis-server /home/shuaikai/.redis/redis.conf'
alias redisstop='redis-cli -a shuaikaisredis SHUTDOWN'
alias redisc='redis-cli -h localhost -p 6379 -a $AUTH'

### aliyun-oss : ossup ossupdate ossupdateall ossdowndate ossdowndateall osslsv osslsb ossls ossmkdir ossrm osscat ossdu
BUCKET=oss://shuaikai-bucket0001
ossup() {
    ossutil cp -r $1 $BUCKET/$2 -u
}
ossdown() {
    ossutil cp -r $BUCKET/$1 $2 -u
}
ossls() {
    ossutil ls $BUCKET/$1 -s $2 $3 | sed 's#^oss://shuaikai-bucket0001#https://shuaikai-bucket0001.oss-cn-shanghai.aliyuncs.com#'
}
ossla() {
    ossutil ls $BUCKET -d | sed 's#^oss://shuaikai-bucket0001#https://shuaikai-bucket0001.oss-cn-shanghai.aliyuncs.com#'
}
ossmkdir() {
    ossutil mkdir $BUCKET/$1
}
ossrm() {
    # 兼容下面的 grep
    ossutil rm $BUCKET/$1 $2 $3 $4
}
ossrm-grep() {
    # 删除所有满足 $2 条件的对象
    ossutil rm $BUCKET/$1 --include "$2" -r
}
osscat() {
    ossutil cat $BUCKET/$1
}
ossdu() {
    ossutil du $BUCKET/$1 --block-size MB
}
