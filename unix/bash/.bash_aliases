# alias gdb='gdb -q'
alias ls='lsd'
alias ll='ls -alhF --color=auto'
alias la='ls -aF --color=auto'
alias l='ls -ahF --color=none'
alias python='python3'

# git
alias gita='git add'
alias gitb='git branch'
alias gitc='git checkout'
alias gitl='git log'
alias gitlg='git log --graph'
alias gitlo='git log --oneline'
alias gitlog='git log --oneline --graph'
alias gitr='git reset'
alias gitrh='git reset --hard'
# alias gitcnt='git ls-files| xargs wc -l 2>&1 | grep -v wc | sort -n'
alias gitrs='git reset --soft'
alias gits='git status'
alias gitd='git diff --color | diff-so-fancy'

# convinence
alias PATH='echo $PATH | xargs -d: -n1'
alias sb='source ~/.bashrc'
alias sz='source ~/.zshrc'
alias sv='source ~/.vimrc > /dev/null 2>&1'
alias vimb='vim ~/.bashrc'
alias vimz='vim ~/.zshrc'
alias vimv='vim ~/.vimrc'
alias vima='vim ~/.bash_aliases'
alias vimal='vim ~/.bash_aliases_local'
alias vime='vim ~/.bash_env'

alias tmuxkillall="tmux ls | awk -F ':' '{print \$1}' | tee >(xargs -I{} echo 'kill session: {}') | xargs -I{} tmux kill-session -t {}"

# some tools
alias diff='icdiff'
alias ct=cheat
alias cman='man -M /usr/share/man/zh_CN'
alias gdb='cgdb -q'
alias sqlite='sqlite3'

# modern unix
alias top='btop'
alias fd='fdfind'
alias grep='rg'
alias du='dust'
alias df='duf'
alias bench='hyperfine'
alias bat='batcat'

# 需要高版本glibc
# alias diff='delta'
# alias tree='broot'

# ------------小工具备忘----------
# proc     类似 ps
# mycli    mysql 命令行带自动补全
# --------------------------------

# functions

gitcntt() {
    git log --author="${1:-shuaikai}" --pretty=tformat: --numstat | awk '{add+=$1;sub+=$2} END {printf "add: %s sub: %s total: %s\n", add, sub, add - sub}'
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
        \  echo -en "\e[${code}m"'\\e['"$code"'m'"\e[0m"
        echo -en "  \e[$code;1m"'\\e['"$code"';1m'"\e[0m"
        echo -en "  \e[$code;3m"'\\e['"$code"';3m'"\e[0m"
        echo -en "  \e[$code;4m"'\\e['"$code"';4m'"\e[0m"
        echo -e "  \e[$((code + 60))m"'\\e['"$((code + 60))"'m'"\e[0m"
    done
}

install() {
    sudo mv $@ /usr/local/bin/
}

sshvlab() {
    expect /home/shuaikai/.files/ssh_vlab.exp
}
getvlab() {
    expect /home/shuaikai/.files/get_vlab.exp $@
}
putvlab() {
    expect /home/shuaikai/.files/put_vlab.exp $@
}

neo() {
    if [ $1 -n ]; then
        neofetch --ascii_distro ubuntu
    else
        neofetch --ascii_distro $1
    fi
}

topk() {
    cat $1 | tr -s ' ' '\n' | sort | uniq -c | sort -nr | awk '{print $1, $2}' | head -$2
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

# 快速编译运行java
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

## fzf
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

pyserver() {
    path=$(pwd)
    vm_ip=localhost
    port=8081
    /usr/bin/python3 -m http.server --directory ${path} --bind ${vm_ip} ${port}
}

### perf
#（1） perf report：一步到位
perf_report() {
    sudo perf record -g -- $1 && sudo perf report
}

#（2） 生成火焰图，并可通过浏览器进行访问（主要针对虚拟机，没在正常平台上试验过）
#       $1:命令, $2:svg文件无后缀名称, $3:port, $4:网卡名，如ens33
perf_flame() {
    path=$(pwd)
    FlameGraphPath=/opt/FlameGraph
    filename=${2:-perf-flamegraph}.svg
    vm_ip=$(ip address show ${4:-eth0} | /usr/bin/grep -oP '(?<=inet\s)\d+\.\d+\.\d+\.\d+' | awk 'NR==1{print $1}')
    vm_port=${3:-8000}
    svg_link="http://${vm_ip}:${vm_port}/${filename}"

    sudo perf record -F 99 -g -- $1
    sudo perf script -f >perf.out

    perl ${FlameGraphPath}/stackcollapse-perf.pl ${path}/perf.out | grep -v '^#' | perl ${FlameGraphPath}/flamegraph.pl >${path}/${filename}

    echo -e "\n-----------------------------= PERF FLAME GRAPH =-----------------------------\n"
    echo -e "\e[1;33m Now you can view the SVG file by clicking \e[4;34m${svg_link}\e[0m"
    echo -e "\n------------------------------------------------------------------------------\n"

    python3 -m http.server --directory ${path} --bind ${vm_ip} ${port}
}

### redis : redisc [host] [port]  &  redisrun  &  redisstop
AUTH=shuaikaisredis
alias redisrun='redis-server /home/shuaikai/.redis/redis.conf'
alias redisstop='redis-cli -a shuaikaisredis SHUTDOWN'
alias redisc='redis-cli -h localhost -p 6379 -a $AUTH'
alias rediscloud='redis-cli -u redis://default:USppjE8AGVgCbLsHnn2VEYJEpTZlswMt@redis-13557.c290.ap-northeast-1-2.ec2.redns.redis-cloud.com:13557'
# redisc(){
#     if [ $# -eq 0 ] ;
#     then
#         redis-cli -h kkcloud -p 6379 -a $AUTH
#     elif [ $# -eq 1 ] ;
#     then
#         redis-cli -h kkcloud -p $1 -a $AUTH
#     elif [ $# -eq 2 ] ;
#     then
#         redis-cli -h $1 -p $2
#     else
#         echo 'usage: redis [hostname] [port]'
#     fi
# }

### aliyun-oss : ossup ossupdate ossupdateall ossdowndate ossdowndateall osslsv osslsb ossls ossmkdir ossrm osscat ossdu
BUCKET=oss://shuaikai-bucket0001
VSCODE=/home/shuaikai/.local/share/code-server/User
# 更新oss配置文件
ossupdate() {
    ossutil cp ~/.bash_aliases $BUCKET/config/bash/.bash_aliases
    ossutil cp ~/.vimrc $BUCKET/config/vim/.vimrc
}
ossupdateall() {
    cd ~
    tar czf vim-mine.tar.gz .vim
    ossutil cp .bash_aliases $BUCKET/config/bash/.bash_aliases
    ossutil cp .vimrc $BUCKET/config/vim/.vimrc
    ossutil cp vim-mine.tar.gz $BUCKET/config/vim/vim-mine.tar.gz
    rm vim-mine.tar.gz
    cd -
}
# 更新本地配置文件
ossdowndate() {
    mv .bash_aliases .bash_aliases.bak
    wget -O ~/.bash_aliases https://shuaikai-bucket0001.oss-cn-shanghai.aliyuncs.com/config/bash/.bash_aliases
    wget -O ~/.vimrc https://shuaikai-bucket0001.oss-cn-shanghai.aliyuncs.com/config/vim/.vimrc
    echo ".bash_aliases has been backed up, you can run rm .bash_aliases.bak if you want"
}
ossdowndateall() {
    cd ~
    mv .vim .vim.bak
    mv .vimrc .vimrc.bak
    mv .bash_aliases .bash_aliases.bak
    wget -O ~/.bash_aliases https://shuaikai-bucket0001.oss-cn-shanghai.aliyuncs.com/config/bash/.bash_aliases
    wget -O ~/.vimrc https://shuaikai-bucket0001.oss-cn-shanghai.aliyuncs.com/config/vim/.vimrc
    wget https://shuaikai-bucket0001.oss-cn-shanghai.aliyuncs.com/config/vim/vim-mine.tar.gz
    tar xf vim-mine.tar.gz
    rm vim-mine.tar.gz
    cd -
    echo ".bash_aliases & .vimrc & .vim/ has been backed up, you can rm -rf ~/.vim.bak .vimrc.bak .bash_aliases.bak if you want"
}
ossupdatevscode() {
    ossutil cp $VSCODE/settings.json $BUCKET/config/vscode/settings.json
    ossutil cp $VSCODE/keybindings.json $BUCKET/config/vscode/keybindings.json
    ossutil cp $VSCODE/snippets $BUCKET/config/vscode/snippets -r
}
ossdowndatevscode() {
    mv $VSCODE/settings.json $VSCODE/settings.json.bak
    mv $VSCODE/keybindings.json $VSCODE/keybindings.json.bak
    wget -O $VSCODE/settings.json https://shuaikai-bucket0001.oss-cn-shanghai.aliyuncs.com/config/vscode/settings.json
    wget -O $VSCODE/snippets/cpp.json https://shuaikai-bucket0001.oss-cn-shanghai.aliyuncs.com/config/vscode/snippets/cpp.json
    wget -O $VSCODE/snippets/plantuml.json https://shuaikai-bucket0001.oss-cn-shanghai.aliyuncs.com/config/vscode/snippets/plantuml.json
    wget -O $VSCODE/snippets/universal.code-snippets https://shuaikai-bucket0001.oss-cn-shanghai.aliyuncs.com/config/vscode/snippets/universal.code-snippets
}
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
alias osslsv="ossutil ls \$BUCKET/config/vim/ -s | sed 's#^oss://shuaikai-bucket0001#https://shuaikai-bucket0001.oss-cn-shanghai.aliyuncs.com#'"
alias osslsb="ossutil ls \$BUCKET/config/bash/ -s | sed 's#^oss://shuaikai-bucket0001#https://shuaikai-bucket0001.oss-cn-shanghai.aliyuncs.com#'"
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
