# forcely recommend use subl instead all other editor in windows
alias vim='subl'
alias nvim='subl'

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

fsubl() {
    local file
    file=$(fd . $@ | fzf) && subl $file
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
