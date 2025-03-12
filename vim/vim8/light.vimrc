"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Bug fix
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Bug of [xtem&vim]: 避免打开 vim 的时候添加奇怪的 'g' ref: https://stackoverflow.com/questions/77685838/letter-g-added-to-beginning-of-line-when-editing-in-vim-and-using-xterm-cygwin
autocmd VimEnter * call timer_start(100, { tid -> execute(':u0')})

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 插件调用
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"【用法】 :Plugstatus 查看插件状态；直接在此加入[Plug]行然后 :PlugInstall 安装；去掉[Plug]行后sv，:PlugClean 删除
call plug#begin('~/.vim/plugged')

" <FZF> ：需要python
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" <AirLine>
Plug 'vim-airline/vim-airline'

" <NERDTREE> 目录
" [Usages] <leader>n
Plug 'scrooloose/nerdtree'
    " File tree manager
Plug 'jistr/vim-nerdtree-tabs'
    " enhance nerdtree's tabs
Plug 'ryanoasis/vim-devicons'
    " add beautiful icons besides files
Plug 'Xuyuanp/nerdtree-git-plugin'
    " display git status within Nerdtree
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
    " enhance devicons

" <Nerdcommenter> 自动识别文件类型并添加对应注释
"【用法】 先进入可视模式，然后：<leader>cc 注释；<leader>c<space> 切换注释状态
Plug 'scrooloose/nerdcommenter'

" <tag list> 显示源码大纲，要配合ctags使用
" [Usages] <leader>b
" Plug 'vim-scripts/taglist.vim'

" coc
" [Usages] CocInstall coc-cland等安装对不同语言的支持，CocCommand补全来查看各种命令
" Plug 'neoclide/coc.nvim', {'branch': 'release'}

" 浮动终端
Plug 'voldikss/vim-floaterm'

call plug#end()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 通用设置
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set nocompatible         " 设置不兼容原始vi模式
filetype on              " 设置开启文件类型侦测
filetype plugin on       " 设置加载对应文件类型的插件
filetype plugin indent on
set noeb                 " 关闭错误的提示
syntax enable            " 开启语法高亮功能
syntax on                " 自动语法高亮
set t_Co=256             " 开启256色支持
set vb t_vb=             " 设置不要响铃
set cmdheight=1          " 设置命令行的高度
set showcmd              " select模式下显示选中的行数
set textwidth=0          " 设置禁止自动断行
set wrap                 " 设置长行自动换行
set ruler                " 总是显示光标位置
set laststatus=2         " 总是显示状态栏
set number               " 开启行号显示
set relativenumber       " 展示相对行号
set cursorline           " 高亮显示当前行
" set colorcolumn=80
set whichwrap+=<,>,h,l   " 设置光标键跨行
set ttimeoutlen=0        " 设置<ESC>键响应时间
set virtualedit=block,onemore   " 允许光标出现在最后一个字符的后面
set noshowmode           " 设置不打开底部insert
set hidden               " 设置允许在未保存切换buffer
set background=dark      " 设置背景默认黑色
set mouse=a              " 设置允许使用鼠标
" set clipboard^=unnamedplus " 设置vim剪贴板（”寄存器）和系统剪切板（+寄存器）同步, 好像会使得复制失效
set linebreak
" 背景透明
" hi Normal guibg=NONE ctermbg=NONE

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 代码缩进和排版
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set autoindent           " 设置自动缩进
set cindent              " 设置使用C/C++语言的自动缩进方式
set cinoptions=g0,:0,N-s,(0    " 设置C/C++语言的具体缩进方式
set smartindent          " 智能的选择对其方式
filetype indent on       " 自适应不同语言的智能缩进
set noexpandtab          " 设置禁止空格替换tab,tab党
set tabstop=4            " 设置编辑时制表符占用空格数
set shiftwidth=4         " 设置格式化时制表符占用空格数
set softtabstop=4        " 设置4个空格为制表符
set smarttab             " 在行和段开始处使用制表符
set nowrap               " 禁止折行
set backspace=2          " 使用回车键正常处理indent,eol,start等
set sidescroll=10        " 设置向右滚动字符数
set nofoldenable         " 禁用折叠代码
" set list lcs=tab:¦\      " 设置默认开启对齐线
set nolist
set sidescroll=0         " 设置向右滑动距离
set sidescrolloff=4      " 设置右部距离
" set scrolloff=5          " 设置底部距离

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 代码补全
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set wildmenu                             " vim自身命名行模式智能补全
set completeopt=menuone,preview,noselect " 补全时不显示窗口，只显示补全列表
set omnifunc=syntaxcomplete#Complete     " 设置全能补全
set shortmess+=c                         " 设置补全静默
set cpt+=kspell                          " 设置补全单词

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 搜索设置
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set hlsearch            " 高亮显示搜索结果
set incsearch           " 开启实时搜索功能
set ignorecase          " 搜索时大小写不敏感
set smartcase           " 搜索智能匹配大小写

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 缓存设置
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set nobackup            " 设置不备份
set noswapfile          " 禁止生成临时文件
set autoread            " 文件在vim之外修改过，自动重新读入
set autowrite           " 设置自动保存
set confirm             " 在处理未保存或只读文件的时候，弹出确认

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 编码设置
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set langmenu=zh_CN.UTF-8
set helplang=cn
set termencoding=utf-8
set encoding=utf8
set fileencodings=utf8,ucs-bom,gbk,cp936,gb2312,gb18030
set langmenu=zh_CN.UTF-8

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 其他功能
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" (1): 代码折叠。退出时自动:mkview，进入时自动 :loadview，这样代码折叠功能就可用了
augroup remember_folds
    autocmd!
    autocmd BufWinLeave *.* mkview
    autocmd BufWinEnter *.* silent! loadview
augroup END


" (2): 检测文件类型并调用相应的格式化工具
" 创建一个名为 MyEnter 的映射组，避免与其他插件冲突
augroup format_on_enter
  autocmd!
  autocmd FileType c,cpp,h,hpp nnoremap <buffer> <CR> :CocCommand editor.action.formatDocument<CR>:w<cr>
  " autocmd FileType c,cpp,h,hpp nnoremap <buffer> <CR> :w<CR> :%! clang-format -style='file:C:/Users/wddjwk/.clang-format'<CR> :w<cr>
  autocmd FileType py,python nnoremap <buffer> <CR> :w<CR> :%! autopep8 %<CR> :w<CR>
augroup END

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 按键映射
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"let mapleader="\<space>"
let mapleader=","

" nnoremap <F5> :wa<CR>:!g++ % -o a.out -std=c++20 && ./a.out<CR>
nnoremap <F6> :wa<CR>:!g++ % -o a.out -std=c++20 -g && gdb a.out<CR>

map <c-s-v> <C-v>
map <s-h> <C-W>h
map <s-l> <C-W>l
map <s-j> <C-W>j
map <s-k> <C-W>k

nnoremap gh ^
nnoremap gl $<right>
inoremap {<CR> {}<ESC>i<CR><ESC>O
" inoremap {} {}
nnoremap < <<
nnoremap > >>


nnoremap <leader>e :edit<space><c-r>=getcwd()<cr>/
" nnoremap <cr> :CocCommand editor.action.formatDocument<CR>:w<cr>

nnoremap <leader>b :Tlist<CR>
nnoremap <leader>cs :Tlist<CR>
nnoremap <leader>ct :Tlist<CR>
nnoremap <leader><leader>c :set nonumber norelativenumber nolist wrap<CR>
nnoremap <leader><leader>v :set number relativenumber nowrap<CR>
nnoremap <leader>h :nohlsearch<CR>
nnoremap <leader>w :if &wrap \| set nowrap \| else \| set wrap \| endif<CR>
nnoremap <leader>q :wq<CR>
nnoremap <leader><leader>q :q!<CR>

" 插入模式下的光标移动
imap <c-j> <down>
imap <c-k> <up>
imap <c-l> <right>
imap <c-h> <left>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 窗口编辑
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"改变窗口大小
nnoremap <c-up> :resize+1<cr>
nnoremap <c-down> :resize-1<cr>
nnoremap <c-left> :vertical resize+1<cr>
nnoremap <c-right> :vertical resize-1<cr>
"改变当前窗口
nnoremap <s-up> <c-w>k
nnoremap <s-down> <c-w>j
nnoremap <s-left> <c-w>h
nnoremap <s-right> <c-w>l
"改变窗口位置
nnoremap <c-s-up> <c-w>K
nnoremap <c-s-down> <c-w>J
nnoremap <c-s-left> <c-w>H
nnoremap <c-s-right> <c-w>L

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 别处配置映射，此处汇总
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" "---------<NerdTree>----
" nnoremap <leader>n :NERDTreeToggle<CR>
"
" "---------<Comment>-----
" "<leader>cc 注释；<leader>c<space> 切换注释状态
"
" "---------<LeaderF>-----
" "<leader><leader>f
"
" "---------<Coc>--------
" "<leader>f

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 插件配置
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" <Nerdtree>-------------------{
"   >> Basic settings
"        let g:NERDTr:eChDirMode = 2  "Change current folder as root
"        autocmDTree:nter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) |cd %:p:h |endif
    nnoremap <leader>n :NERDTreeToggle<CR>
"   >> UI settings
        let NERDTreeQuitOnOpen=1   " Close NERDtree when files was opened
        let NERDTreeMinimalUI=1    " Start NERDTree in minimal UI mode (No help lines)
        let NERDTreeDirArrows=1    " Display arrows instead of ascii art in NERDTree
        let NERDTreeChDirMode=2    " Change current working directory based on root directory in NERDTree
        let g:NERDTreeHidden=1     " Don't show hidden files
        let NERDTreeWinSize=30     " Initial NERDTree width
        let NERDTreeAutoDeleteBuffer = 1  " Auto delete buffer deleted with NerdTree
        "let NERDTreeShowBookmarks=0   " Show NERDTree bookmarks
        let NERDTreeIgnore = ['\.pyc$', '\.swp', '\.swo', '__pycache__']   " Hide temp files in NERDTree
        "let g:NERDTreeShowLineNumbers=1  " Show Line Number
    " Open Nerdtree when there's no file opened
        autocmd vimenter * if !argc()|NERDTree|endif
    " Or, auto-open Nerdtree
        "autocmd vimenter * NERDTree
    " Close NERDTree when there's no other windows
        autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
    " Customize icons on Nerdtree
        let g:NERDTreeDirArrowExpandable = '▸'
        let g:NERDTreeDirArrowCollapsible = '▾'

"   >> NERDTREE-GIT
"   Special characters
    let g:NERDTreeGitStatusIndicatorMapCustom = {
        \ "Modified"  : "✹",
        \ "Staged"    : "✚",
        \ "Untracked" : "✭",
        \ "Renamed"   : "➜",
        \ "Unmerged"  : "═",
        \ "Deleted"   : "✖",
        \ "Dirty"     : "✗",
        \ "Clean"     : "✔︎",
        \ 'Ignored'   : '☒',
        \ "Unknown"   : "?"
    \ }

    ">> NERDTree-Tabs
        "let g:nerdtree_tabs_open_on_console_startup=1 "Auto-open Nerdtree-tabs on VIM enter
" }----<NerdTree>

" ===============================  NredCommenter  ==================================
" <NredCommenter>-----------{ // Copy from github directly //
    " Create default mappings
    let g:NERDCreateDefaultMappings = 1

    " Add spaces after comment delimiters by default
    let g:NERDSpaceDelims = 1

    " Use compact syntax for prettified multi-line comments
    let g:NERDCompactSexyComs = 1

    " Align line-wise comment delimiters flush left instead of following code indentation
    let g:NERDDefaultAlign = 'left'

    " Set a language to use its alternate delimiters by default
    let g:NERDAltDelims_java = 1

    " Add your own custom formats or override the defaults
    let g:NERDCustomDelimiters = { 'c': { 'left': '/**','right': '*/' } }

    " Allow commenting and inverting empty lines (useful when commenting a region)
    let g:NERDCommentEmptyLines = 1

    " Enable trimming of trailing whitespace when uncommenting
    let g:NERDTrimTrailingWhitespace = 1

    " Enable NERDCommenterToggle to check all selected lines is commented or not
    let g:NERDToggleCheckAllLines = 1
" }----------<NerdCommenter>

" ==================================   RainBow   ===================================
" <Rainbow>------{ // Copy from https://github.com/luochen1990/rainbow/blob/master/README_zh.md //------
" 本插件较为古老，不是通过VimPlug安装的。共有三个文件，直接删除掉就好。分别是：
" autoload/rainbow.vim & autoload/rainbow_main.vim & plugin/rainbow_main.vim
let g:rainbow_active = 1 "0 if you want to enable it later via :RainbowToggle
let g:rainbow_conf = {
\   'guifgs': ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick'],
\   'ctermfgs': ['lightblue', 'lightyellow', 'lightcyan', 'lightmagenta'],
\   'operators': '_,_',
\   'parentheses': ['start=/(/ end=/)/ fold', 'start=/\[/ end=/\]/ fold', 'start=/{/ end=/}/ fold'],
\   'separately': {
\       '*': {},
\       'tex': {
\           'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/'],
\       },
\       'lisp': {
\           'guifgs': ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick', 'darkorchid3'],
\       },
\       'vim': {
\           'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/', 'start=/{/ end=/}/ fold', 'start=/(/ end=/)/ containedin=vimFuncBody', 'start=/\[/ end=/\]/ containedin=vimFuncBody', 'start=/{/ end=/}/ fold containedin=vimFuncBody'],
\       },
\       'html': {
\           'parentheses': ['start=/\v\<((area|base|br|col|embed|hr|img|input|keygen|link|menuitem|meta|param|source|track|wbr)[ >])@!\z([-_:a-zA-Z0-9]+)(\s+[-_:a-zA-Z0-9]+(\=("[^"]*"|'."'".'[^'."'".']*'."'".'|[^ '."'".'"><=`]*))?)*\>/ end=#</\z1># fold'],
\       },
\       'css': 0,
\       'nerdtree': 0,
\   }
\}
" NERDTree与Rainbow会冲突，产生多余的括号，所以有 nerdtree:0一项
" }---------<Rainbow>

" ================================= Coc ================================================
" inoremap <silent> <expr> <CR> coc#pum#visible() ? coc#_select_confirm() : "\<CR>"
" inoremap <silent> <expr> <Tab> coc#pum#visible() ? coc#_select_confirm() : "\<CR>"
" inoremap <silent> <expr> <C-Space> coc#refresh()
" nnoremap <silent> <leader>f :CocCommand editor.action.formatDocument<CR>
" let g:coc_disable_startup_warning = 1
" let g:coc_user_config = {
" \ 'python.formatting.provider': 'autopep8',
" \}
" nnoremap <silent> <leader>r :call CocAction('rename')<CR>

" ===================================== LeaderF  ============================================
nnoremap <leader><leader>f :FloatermNew --title="FZF" --width=0.8 --autoclose=1 fzf<CR>
nnoremap <leader><leader>b :Buffers<CR>

" ================================= FloatTerm ================================================

" FloatTerm 配置
let g:floaterm_width = 0.6
let g:floaterm_height = 0.6
let g:floaterm_autoclose = 0
let g:floaterm_opener = 'edit'
let g:floaterm_wintype = 'float'
let g:floaterm_position = 'center'
let g:floaterm_title = 'floaterm: $1/$2'

let g:floaterm_keymap_new = '<Leader>t'
let g:floaterm_keymap_toggle = '<Leader>tt'
let g:floaterm_keymap_toggle = '<Leader><Leader>t'

nnoremap <silent> <leader>t :FloatermNew --autoclose=1 <CR>
nnoremap <silent> <leader>k :FloatermKill<CR>
tnoremap <silent> <leader>k <C-\><C-n>:FloatermKill<CR>
tnoremap <silent> <C-n> <C-\><C-n>:FloatermNext<CR>
tnoremap <silent> <F7> <C-\><C-n>:FloatermHide<CR>

" ToggleFT 函数
function! ToggleFT(name, cmd)
    if floaterm#terminal#get_bufnr(a:name) != -1
        exec "FloatermToggle " . a:name
    else
        exec "FloatermNew --name=" . a:name . " " . a:cmd
    endif
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 构建 & 运行 & 调试命令
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" 显示路径信息
function! ShowPath()
    let fullpath = expand("%:p")
    let folder = expand("%:p:h")
    let filename = expand("%:p:t")
    let fullbase = expand("%:p:r")
    let extension = expand("%:p:e")

    echo NormalizePath(filename)
    echo NormalizePath(folder)
    echo NormalizePath(fullpath)
endfunction

" 判断操作系统
function! GetOsType()
    if exists('$OS') && $OS =~? 'Windows_NT'
        if has('win32') || has('win64')
            return "OS_WINDOWS"
        else
            return "OS_GITBASH"
        endif
    endif
    return "OS_LINUX"
endfunction

" 包装命令以适应不同平台
function! WrapCommandForDiffOS(cmd)
    let tool_mapping = {
                \ 'gdb': { 'windows': 'gdb', 'gitbash': 'gdb', 'linux': 'cgdb' },
                \ 'pdb': { 'windows': 'pdb', 'gitbash': 'pdb', 'linux': 'pudb' }
                \ }
    let ostype = GetOsType()
    if ostype == "OS_WINDOWS"
        return has_key(tool_mapping, a:cmd) ? tool_mapping[a:cmd]['windows'] : a:cmd
    endif
    if ostype == "OS_GITBASH"
        return has_key(tool_mapping, a:cmd) ? tool_mapping[a:cmd]['gitbash'] : './' . a:cmd
    endif
    if ostype == "OS_LINUX"
        return has_key(tool_mapping, a:cmd) ? tool_mapping[a:cmd]['linux'] : './' . a:cmd
    endif
endfunction

" 规则化路径分隔符
function! NormalizePath(path)
    let sep = GetOsType() == "OS_WINDOWS" ? '\\' : '/'
    return substitute(a:path, '[/\\]', sep, 'g')
endfunction

" 命令行
function! RunCommand()
    let l:currdir = NormalizePath(expand("%:p:h"))
    let l:cmd = input("[" . currdir . "]$ ")
    exec "FloatermNew --autoclose=0 --title=COMMANDLINE --width=0.9 --height=0.85 " . l:cmd
endfunction

" 获取编译选项
function! GetCompileOptions(type)
    let defaultOptionsMap = {
                \ 'CPP': '-std=c++20 ',
                \ 'CPP_Debug': '-g -O0 -std=c++20 ',
                \ 'C': '',
                \ 'C_Debug': '-g '
                \ }
    return input("[" . a:type . "] Compile Options: ", get(defaultOptionsMap, a:type, ''))
endfunction

" 运行文件 (RunFile)
function! RunFile()
    write
    let ft = &filetype
    let run_cmd = {
                \ 'javascript': 'node',
                \ 'typescript': 'ts-node',
                \ 'python': 'python',
                \ 'go': 'go run',
                \ 'sh': 'bash',
                \ 'lua': 'lua'
                \ }

    if has_key(run_cmd, ft)
        call ToggleFT("RUN", run_cmd[ft] . " %")
    elseif ft ==# 'c'
        let cmd = printf(
                    \ 'bash -c "gcc %% -o %%< %s && %s && rm %%<"',
                    \ GetCompileOptions("C"),
                    \ WrapCommandForDiffOS("%<")
                    \ )
        call ToggleFT("RUN", cmd)
    elseif ft ==# 'cpp'
        let cmd = printf(
                    \ 'bash -c "g++ %% -o %%< %s && %s && rm %%<"',
                    \ GetCompileOptions("CPP"),
                    \ WrapCommandForDiffOS("%<")
                    \ )
        call ToggleFT("RUN", cmd)
    elseif ft ==# 'java'
        let cmd = 'bash -c "javac % && java %< && rm %<"'
        call ToggleFT("RUN", cmd)
    endif
endfunction

" 调试文件 (DebugFile)
function! DebugFile()
    write
    let ft = &filetype

    if ft ==# 'c'
        let cmd = printf(
                    \ 'bash -c "gcc %% -o %%< %s && %s -q %%< && rm %%<"',
                    \ GetCompileOptions("C_Debug"),
                    \ WrapCommandForDiffOS("gdb")
                    \ )
        exec "FloatermNew --autoclose=1 --title=DEBUG --width=0.9 --height=0.85 " . cmd
    elseif ft ==# 'cpp'
        let cmd = printf(
                    \ 'bash -c "g++ %% -o %%< %s && %s -q %%< && rm %%<"',
                    \ GetCompileOptions("CPP_Debug"),
                    \ WrapCommandForDiffOS("gdb")
                    \ )
        exec "FloatermNew --autoclose=1 --title=DEBUG --width=0.9 --height=0.85 " . cmd
    elseif ft ==# 'python'
        let cmd = printf(
                    \ 'bash -c "%s %% && read -n 1"',
                    \ WrapCommandForDiffOS("pdb")
                    \ )
        exec "FloatermNew --autoclose=1 --title=DEBUG --width=0.9 --height=0.85 " . cmd
    elseif ft ==# 'go'
        let title = "DEBUG"
        let dirname = expand("%:p:h")
        let fileBaseName = expand("%:t")
        let baseNameNoExt = expand("%:t:r")
        let flags = "-gcflags='-N -l' -o"
        let suffix = "&& cgdb -q " . baseNameNoExt . " && rm " . baseNameNoExt
        let command = printf(
                    \ 'bash -c "cd %s && go build %s %s %s %s"',
                    \ dirname, flags, baseNameNoExt, fileBaseName, suffix
                    \ )
        exec "FloatermNew --autoclose=1 --title=" . title . " --width=0.9 --height=0.85 " . command
    endif
endfunction

" 寻找根CMakeLists.txt路径
function! FindCMakeRoot()
    let l:path = expand("%:p:h")  " 获取当前文件所在目录
    let l:last_cmake_file = ''

    while 1
        " 检查CMakeLists.txt是否存在（注意//CMakeLists.txt 会被认为是当前目录，进而总是找到根目录）
        if l:path != '/' && filereadable(l:path . "/CMakeLists.txt")
            let l:last_cmake_file = l:path
        endif

        " 获取父目录
        let l:parent = fnamemodify(l:path, ":h")

        " 如果已经到达根目录则退出循环
        if l:parent ==# l:path
            break
        endif

        let l:path = l:parent
    endwhile

    return !empty(l:last_cmake_file) ? last_cmake_file : v:null
endfunction

" 获取 CMake 目标信息
function! GetCMakeTargetInfo()
    let cmakeRoot = FindCMakeRoot()
    let buildDir = NormalizePath(cmakeRoot . "/build")
    let defaultTargetName = expand("%:p:t:r")
    let userInput = input("Target('" . defaultTargetName . "'): ")
    let targetName = empty(userInput) ? defaultTargetName : userInput
    let binPath = NormalizePath(buildDir . "/bin")
    let targetPath = isdirectory(binPath) ? NormalizePath("bin/" . targetName) : NormalizePath(targetName)

    echo targetPath
    return [buildDir, targetName, targetPath]
endfunction

" 执行 CMake 命令
function! ExecuteCMakeCommand(cmakeBuildType, isRebuildNeeded, isDebugTargetNeeded, isUseNinja)
    " 获取 CMake 目标信息
    let [buildDir, targetName, targetPath] = GetCMakeTargetInfo()

    " 检查 buildDir 是否存在
    if !isdirectory(buildDir)
        echo "Error: Build directory does not exist: " . buildDir
        return
    endif

    " 并行构建的核心数
    let para_nums = 8

    " CMake 生成器（可选 Ninja）
    let cmakeGenerator = a:isUseNinja ? '-G"Ninja"' : ''

    " 构建命令
    let cmakeBuildTargetCmd = ''
    if a:isRebuildNeeded
        let cmakeBuildTargetCmd = printf(
                    \ '((rm -rf %s && mkdir %s) || (mkdir %s)) && cd %s && cmake .. %s -DCMAKE_BUILD_TYPE=%s && cmake --build . --target=%s -j%s',
                    \ buildDir, buildDir, buildDir, buildDir, cmakeGenerator, a:cmakeBuildType, targetName, para_nums
                    \ )
    else
        let cmakeBuildTargetCmd = printf(
                    \ 'cd %s && cmake --build . --target=%s -j%s',
                    \ buildDir, targetName, para_nums
                    \ )
    endif

    " 运行目标命令
    let runTargetCmd = a:isDebugTargetNeeded
                \ ? printf('clear && cd %s && %s %s', buildDir, WrapCommandForDiffOS("gdb"), targetPath)
                \ : printf('clear && cd %s && %s', buildDir, WrapCommandForDiffOS(targetPath))

    " 组合构建和运行命令
    let fullCommand = printf(
                \ 'bash -c "%s && %s"',
                \ cmakeBuildTargetCmd,
                \ runTargetCmd
                \ )

    " 设置 floatterm 参数
    let floatermTitle = a:isDebugTargetNeeded ? "CMakeDebugTarget" : "CMakeRunTarget"
    let floatermOptions = a:isDebugTargetNeeded ? '--autoclose=1 --width=0.9 --height=0.85' : '--autoclose=0'

    " 保存文件并执行命令
    write
    exec "FloatermNew --title=" . floatermTitle . ":" . targetName . " " . floatermOptions . " " . fullCommand
endfunction

" 定义快捷命令
command! CMakeRunTarget call ExecuteCMakeCommand("Release", v:true, v:false, v:true)
command! CMakeDebugTarget call ExecuteCMakeCommand("Debug", v:true, v:true, v:true)
command! CMakeRunTargetNonClean call ExecuteCMakeCommand("Release", v:false, v:false, v:true)
command! CMakeDebugTargetNonClean call ExecuteCMakeCommand("Debug", v:false, v:true, v:true)

nnoremap <leader><leader>r :call RunCommand()<CR>
nnoremap <F5> :call RunFile()<CR>
nnoremap <leader>r :call RunFile()<CR>
nnoremap <leader>d :call DebugFile()<CR>
nnoremap <leader>mcr :CMakeRunTarget<CR>
nnoremap <leader>mcd :CMakeDebugTarget<CR>
nnoremap <leader>mr :CMakeRunTargetNonClean<CR>
nnoremap <leader>md :CMakeDebugTargetNonClean<CR>
