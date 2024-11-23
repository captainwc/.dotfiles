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
Plug 'vim-scripts/taglist.vim'

" coc
" [Usages] CocInstall coc-cland等安装对不同语言的支持，CocCommand补全来查看各种命令
Plug 'neoclide/coc.nvim', {'branch': 'release'}

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
set clipboard^=unnamedplus " 设置vim剪贴板（”寄存器）和系统剪切板（+寄存器）同步
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
\	'guifgs': ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick'],
\	'ctermfgs': ['lightblue', 'lightyellow', 'lightcyan', 'lightmagenta'],
\	'operators': '_,_',
\	'parentheses': ['start=/(/ end=/)/ fold', 'start=/\[/ end=/\]/ fold', 'start=/{/ end=/}/ fold'],
\	'separately': {
\		'*': {},
\		'tex': {
\			'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/'],
\		},
\		'lisp': {
\			'guifgs': ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick', 'darkorchid3'],
\		},
\		'vim': {
\			'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/', 'start=/{/ end=/}/ fold', 'start=/(/ end=/)/ containedin=vimFuncBody', 'start=/\[/ end=/\]/ containedin=vimFuncBody', 'start=/{/ end=/}/ fold containedin=vimFuncBody'],
\		},
\		'html': {
\			'parentheses': ['start=/\v\<((area|base|br|col|embed|hr|img|input|keygen|link|menuitem|meta|param|source|track|wbr)[ >])@!\z([-_:a-zA-Z0-9]+)(\s+[-_:a-zA-Z0-9]+(\=("[^"]*"|'."'".'[^'."'".']*'."'".'|[^ '."'".'"><=`]*))?)*\>/ end=#</\z1># fold'],
\		},
\		'css': 0,
\		'nerdtree': 0,
\	}
\}
" NERDTree与Rainbow会冲突，产生多余的括号，所以有 nerdtree:0一项
" }---------<Rainbow>

" ================================= Coc ================================================
" inoremap <silent> <expr> <CR> coc#pum#visible() ? coc#_select_confirm() : "\<CR>"
inoremap <silent> <expr> <Tab> coc#pum#visible() ? coc#_select_confirm() : "\<CR>"
inoremap <silent> <expr> <C-Space> coc#refresh()
nnoremap <silent> <leader>f :CocCommand editor.action.formatDocument<CR>
let g:coc_disable_startup_warning = 1
let g:coc_user_config = {
\ 'python.formatting.provider': 'autopep8',
\}
" nnoremap <silent> <leader>r :call CocAction('rename')<CR>

" ================================= FloatTerm  ================================================
"
" Function to toggle or create a new Floaterm window with a specific name
" This func cannot handle '&&' correctly, the only found is use bash -c 
" function! ToggleFT(name, cmd)
"   if floaterm#terminal#get_bufnr(a:name) != -1
"     exec "FloatermToggle " . a:name
"   else
"     exec "FloatermNew --name=" . a:name . " " . a:cmd
"   endif
" endfunction

" Function to run the current file based on its filetype
function! RunFile()
  write
  let ft = &filetype
  if ft ==# 'python'
	FloatermNew --autoclose=1 bash -c "python -u % && read -n 1"
  elseif ft ==# 'javascript'
	FloatermNew --autoclose=1 bash -c "node % && read -n 1"
  elseif ft ==# 'go'
	FloatermNew --autoclose=1 bash -c "go run % && read -n 1"
  elseif ft ==# 'lua'
	FloatermNew --autoclose=1 bash -c "lua % && read -n 1"
  elseif ft ==# 'sh'
	FloatermNew --autoclose=1 bash -c "bash % && read -n 1"
  elseif ft ==# 'c'
    FloatermNew --autoclose=1 bash -c "gcc % -o %< && ./%< && rm %< && read -n 1"
  elseif ft ==# 'cpp'
    FloatermNew --autoclose=1 bash -c "g++ % -o %< -std=c++20 && ./%< && rm %< && read -n 1"
  elseif ft ==# 'rust'
	FloatermNew --autoclose=1 bash -c "rustc % -o %< && ./%< && rm %< && read -n 1"
  endif
endfunction

" Function to debug the current file based on its filetype
function! DebugFile()
  write
  let ft = &filetype
  if ft ==# 'c'
    FloatermNew --width=0.9 --height=0.85 --autoclose=1 --title="DEBUG" bash -c "gcc % -o %< -g && ./%< && cgdb -q %< && rm %<"
  elseif ft ==# 'cpp'
    FloatermNew --width=0.9 --height=0.85 --autoclose=1 --title="DEBUG" bash -c "g++ % -o %< -std=c++20 -g && cgdb -q %< && rm %<"
  elseif ft ==# 'python'
	  FloatermNew --width=0.9 --height=0.85 --autoclose=1 --title="DEBUG" bash -c "pudb %"
  elseif ft ==# 'go'
    FloatermNew --width=0.9 --height=0.85 --autoclose=1 --title="DEBUG" bash -c "cd %:p:h && go build -gcflags='-N -l' -o %:t:r %:t && cgdb -q %:t:r && rm %:t:r"
  elseif ft ==# 'rust'
    FloatermNew --width=0.9 --height=0.85 --autoclose=1 --title="DEBUG" bash -c "rustc -g % -o %< && gdb -q %< && rm %<"
  endif
endfunction

" Configuration for floaterm
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
nnoremap <F5> :call RunFile()<CR>
nnoremap <leader>r :call RunFile()<CR>
nnoremap <leader>d :call DebugFile()<CR>

" ===================================== LeaderF  ============================================
nnoremap <leader><leader>f :FloatermNew --title="FZF" --width=0.8 --autoclose=1 fzf<CR>
