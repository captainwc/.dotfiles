# 七牛云-------------------------------------------------------------------------------------------------
## - qossls
## - qossla
## - qossup
## - qossdown
## - qossfetch

alias qshell='/d/tools/qshell.exe'
alias hs='hugo server -D'

qossls(){
	/d/tools/qshell.exe listbucket shuaikai-me-oss -p $1| awk '{print $1}' | sed 's#^#http://shuaikai.me/#' 
}
qossla(){
	/d/tools/qshell.exe listbucket shuaikai-me-oss | awk '{print $1}' | sed 's#^#http://shuaikai.me/#'
}
qossup(){
	/d/tools/qshell.exe fput shuaikai-me-oss $2 $1
}
qossdown(){
	/d/tools/qshell.exe get shuaikai-me-oss $1 $2 $3
}
qossfetch(){
	/d/tools/qshell.exe fetch $1 shuaikai-me-oss -k $2 
}

alias sshvlab='ssh -i ~/.ssh/vlab-vm5941.pem shuaikai@vlab.ustc.edu.cn'

export C_INCLUDE_PATH="/c/ENV/box/include:$C_INCLUDE_PATH"
export LIBRARY_PATH="/c/ENV/box/libs:$LIBRARY_PATH"

# export VIM="/c/Users/wddjwk"
# export HOME="/c/Users/wddjwk"
# export VIMRUNTIME="/d/env/editor/vim"


# build() {
#     local line_number=${1:-1}  # 获取第一个参数，默认为1
#     local mk_file=$(find . -maxdepth 1 -type f -name "mk" -print -quit)
#
#     if [ -n "$mk_file" ]; then
#         local command=$(sed "${line_number}q;d" "$mk_file")  # 获取指定行的命令
#         echo "[CMD $line_number]: $command"
#         eval "$command"
#     else
#         echo "No mk file found in the current directory."
#     fi
# }

build() {
    # 检查是否存在"mk"文件
    if [ -f "mk" ]; then
        command=$(head -n 1 mk)
        eval "$command"
        return
    fi

    # 检查是否存在"Makefile"文件
    if [ -f "Makefile" ]; then
        make -j8
        return
    fi

    # 根据文件后缀名执行相应的命令
    for file in *
    do
        if [ -f "$file" ]; then
            case "${file##*.}" in
                c)
                    gcc "$file" -o "${file%.*} -g -Wall"
                    if [ $? -eq 0 ]; then
                        ./"${file%.*}"
                    fi
                    ;;
                cpp)
                    g++ "$file" -o "${file%.*} -std=c++20 -g -Wall"
                    if [ $? -eq 0 ]; then
                        ./"${file%.*}"
                    fi
                    ;;
                py)
                    python -u "$file"
                    ;;
                sh)
                    bash "$file"
                    ;;
                lua)
                    lua "$file"
                    ;;
                *)
                    echo "Unsupported file type: ${file##*.}"
                    ;;
            esac
        fi
    done
}

run_in_vscode(){
    echo $1 $2
}
