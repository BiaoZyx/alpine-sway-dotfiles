" ============================================================
" Vimore
" 作者: BiaoZyx
" 邮箱: BiaoZyx@outlook.com
" 版本: 3.14
" ============================================================
"  _   ___
" | | / (_)_ _  ___  _______
" | |/ / /  ' \/ _ \/ __/ -_)
" |___/_/_/_/_/\___/_/  \__/
"                   Less is more.
" ============================================================
" 备注: 普通vim可能剪切板支持不好，建议安装gvim以使用vim
" ============================================================


" ============================================================
" 1. 基础设置
" ============================================================
set nocompatible              " 不使用 vi 兼容模式
syntax on
syntax enable
set background=dark

let mapleader = " "           " Leader 键设为空格
set clipboard=                " 不自动同步系统剪切板，用 Ctrl+C/V 手动控制

" 颜色主题
try
    colorscheme slate
catch
    colorscheme default
endtry

" 启动信息精简：a=缩写, o=覆盖写入, O=覆盖读取, t=启动提示, T=标签页信息
set shortmess=aoOtT

filetype on
filetype indent on
filetype plugin on

" ============================================================
" 2. 界面显示
" ============================================================
set number                    " 显示行号
set relativenumber            " 显示相对行号
set cursorline                " 高亮当前行
set cursorcolumn              " 高亮当前列
"set noshowcmd                 " 不显示命令（减少回显）
set noshowmode                " 不显示 --INSERT-- 等（状态栏已显示）
set laststatus=2              " 始终显示状态栏
set ruler                     " 显示光标位置
set title                     " 设置终端标题
set ttyfast                   " 快速终端连接
set lazyredraw                " 延迟屏幕更新（提高性能）

" ============================================================
" 3. 状态栏
" ============================================================
" ---------- 高亮颜色定义（终端 + GUI 统一设置） ----------
if has('gui_running')
    " ---- GUI 颜色 ----
    highlight StatusLine   guifg=#ffffff guibg=#585858 gui=bold
    highlight StatusLineNC guifg=#aaaaaa guibg=#303030
    highlight StatusLineTerm guifg=#ffffff guibg=#303030 gui=bold
    highlight User1        guifg=#ffd700 guibg=#585858 gui=bold
    highlight User2        guifg=#87d787 guibg=#585858 gui=bold
    highlight User3        guifg=#5fd7ff guibg=#585858 gui=bold
    highlight User4        guifg=#d7afff guibg=#585858 gui=bold
    highlight User5        guifg=#ffaf5f guibg=#585858 gui=bold
    " 模式指示器颜色（GUI 版）
    highlight ModeNormal   guifg=#ffffff guibg=#585858 gui=bold
    highlight ModeInsert   guifg=#5fafff guibg=#585858 gui=bold
    highlight ModeVisual   guifg=#87d787 guibg=#585858 gui=bold
    highlight ModeVLine    guifg=#5faf5f guibg=#585858 gui=bold
    highlight ModeVBlock   guifg=#5fd7ff guibg=#585858 gui=bold
    highlight ModeReplace  guifg=#d787ff guibg=#585858 gui=bold
    highlight ModeCmdline  guifg=#ff5f5f guibg=#585858 gui=bold
    highlight ModeTerminal guifg=#ffd700 guibg=#585858 gui=bold
else
    " ---- 终端颜色（256 色优先） ----
    if &t_Co >= 256
        highlight StatusLine   ctermfg=white ctermbg=238 cterm=bold
        highlight StatusLineNC ctermfg=gray  ctermbg=236
        highlight StatusLineTerm ctermfg=white ctermbg=236 cterm=bold
        highlight User1        ctermfg=220   ctermbg=238 cterm=bold
        highlight User2        ctermfg=114   ctermbg=238 cterm=bold
        highlight User3        ctermfg=81    ctermbg=238 cterm=bold
        highlight User4        ctermfg=176   ctermbg=238 cterm=bold
        highlight User5        ctermfg=215   ctermbg=238 cterm=bold
        " 模式指示器颜色（256 色终端）
        highlight ModeNormal   ctermfg=white ctermbg=238 cterm=bold
        highlight ModeInsert   ctermfg=blue  ctermbg=238 cterm=bold
        highlight ModeVisual   ctermfg=green ctermbg=238 cterm=bold
        highlight ModeVLine    ctermfg=darkgreen ctermbg=238 cterm=bold
        highlight ModeVBlock   ctermfg=cyan  ctermbg=238 cterm=bold
        highlight ModeReplace  ctermfg=magenta ctermbg=238 cterm=bold
        highlight ModeCmdline  ctermfg=red   ctermbg=238 cterm=bold
        highlight ModeTerminal ctermfg=yellow ctermbg=238 cterm=bold
    else
        " ---- 低色彩终端（8/16 色） ----
        highlight StatusLine   ctermfg=white ctermbg=darkblue cterm=bold
        highlight StatusLineNC ctermfg=gray  ctermbg=darkgray
        highlight User1        ctermfg=yellow ctermbg=darkblue cterm=bold
        highlight User2        ctermfg=green  ctermbg=darkblue cterm=bold
        highlight User3        ctermfg=cyan   ctermbg=darkblue cterm=bold
        highlight User4        ctermfg=magenta ctermbg=darkblue cterm=bold
        highlight User5        ctermfg=lightred ctermbg=darkblue cterm=bold
        " 模式指示器颜色（低色彩终端）
        highlight ModeNormal   ctermfg=white  ctermbg=darkblue cterm=bold
        highlight ModeInsert   ctermfg=blue   ctermbg=darkblue cterm=bold
        highlight ModeVisual   ctermfg=green  ctermbg=darkblue cterm=bold
        highlight ModeVLine    ctermfg=darkgreen ctermbg=darkblue cterm=bold
        highlight ModeVBlock   ctermfg=cyan   ctermbg=darkblue cterm=bold
        highlight ModeReplace  ctermfg=magenta ctermbg=darkblue cterm=bold
        highlight ModeCmdline  ctermfg=red    ctermbg=darkblue cterm=bold
        highlight ModeTerminal ctermfg=yellow ctermbg=darkblue cterm=bold
    endif
endif

" ---------- 模式指示器函数（根据 mode() 返回文字） ----------
function! StatuslineMode()
    let m = mode()
    if m == 'n'
        return '%#ModeNormal# [-]%*'
    elseif m == 'i'
        return '%#ModeInsert# [I]%*'
    elseif m == 'v'
        return '%#ModeVisual# [v]%*'
    elseif m == 'V'
        return '%#ModeVLine# [V]%*'
    elseif m == "\<C-v>"
        return '%#ModeVBlock# [B]%*'
    elseif m == 'R'
        return '%#ModeReplace# [R]%*'
    elseif m == 'c'
        return '%#ModeCmdline# [C]%*'
    elseif m == 't'
        return '%#ModeTerminal# [T]%*'
    else
        return ''
    endif
endfunction

" ---------- 状态栏内容 ----------
let &statusline = ''
let &statusline .= '%{%StatuslineMode()%} '   " 模式指示器
let &statusline .= '%f%m%r%h%w%*'             " 文件名、修改标志、只读等
let &statusline .= '%='                       " 右对齐
let &statusline .= '%2* [%Y]%*'               " 文件类型
let &statusline .= '%3* [%{&ff}] [%{&fenc!=''''?&fenc:&enc}]%*'  " 格式 & 编码
let &statusline .= '%4* [%l,%v] [%p%%]%*'    " 行、列、百分比
let &statusline .= '%5* %{strftime(''%H:%M'')}%*'  " 当前时间

" ============================================================
" 4. 编码与文件
" ============================================================
set encoding=utf-8
set fileencoding=utf-8
set termencoding=utf-8
set fileencodings=utf-8,gbk,cp936,gb2312,gb18030,ucs-bom
set fileformats=unix,dos,mac

" 备份和交换文件
set backup
set swapfile
set writebackup
set autoread
set confirm
set hidden
set history=2000
set undolevels=1000
set undofile
set undodir=~/.vim/undodir
set backupdir=~/.vim/backupdir
set directory=~/.vim/swapdir

" ============================================================
" 5. 缩进与格式
" ============================================================
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set smarttab
set autoindent
set cindent
set shiftround
set infercase
set formatoptions+=mB
set lbr
set textwidth=0                " 禁止自动换行
set nowrap
set nolinebreak
set showbreak=↪

" 各文件类型自定义缩进
autocmd FileType python,sh setlocal tabstop=4 shiftwidth=4 softtabstop=4 expandtab
autocmd FileType go setlocal tabstop=4 shiftwidth=4 softtabstop=4 noexpandtab
autocmd FileType javascript,typescript,html,css,json,yaml,markdown setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab
autocmd FileType c,cpp,java,rust setlocal tabstop=4 shiftwidth=4 softtabstop=4 expandtab

" ============================================================
" 6. 搜索与替换
" ============================================================
set hlsearch                  " 高亮搜索结果
set incsearch                 " 增量搜索
set ignorecase                " 忽略大小写
set smartcase                 " 智能大小写（有大写则区分）
set magic                     " 使用正则表达式
set wrapscan                  " 搜索到文件尾后从开头继续
set gdefault                  " 默认全局替换

" ============================================================
" 7. 编辑行为
" ============================================================
set backspace=indent,eol,start
set whichwrap+=<,>,h,l,b,s
set scrolloff=5
set sidescrolloff=5
set sidescroll=1
set virtualedit=block
set selection=exclusive
set selectmode=mouse,key
set mouse=a
set mousemodel=popup
set ttymouse=sgr
set keymodel=startsel,stopsel
" 插入模式下设置为闪烁竖线 (solid vertical bar)
let &t_SI = "\<Esc>[5 q"
" 正常模式下设置为闪烁方块 (solid block)
let &t_EI = "\<Esc>[1 q"
set timeoutlen=300   " 缩短普通映射超时（单位毫秒）
set ttimeoutlen=50   " 缩短按键码（如功能键、方向键）超时

" 黑洞寄存器命令 :D 删除不进任何寄存器
command! -range -bar D <line1>,<line2>delete _
cabbrev d <c-r>=(getcmdpos()==1 && getcmdtype()==':' ? 'D' : 'd')<CR>

" ============================================================
" 8. 括号/引号智能补全
" ============================================================
" 补全左括号光标后无字符或紧挨右括号时智能处理）
inoremap <silent> ( <C-r>=SmartPair('(', ')')<CR>
inoremap <silent> [ <C-r>=SmartPair('[', ']')<CR>

" 特殊映射
function! SmartCondition(char)
    if a:char == '{'
        " 花括号：C/C++/CSS 中不补全
        if &filetype =~? 'c\|cpp\|css'
            return '{'
        else
            return SmartPair('{', '}')
        endif
    elseif a:char == '<'
        " 小于号：仅在 HTML/XML 中补全
        if &filetype =~? 'xml\|html\|xhtml'
            return SmartPair('<', '>')
        else
            return '<'
        endif
    elseif a:char == '"'
        " 双引号：在 vimrc 中不补全
        if &filetype == 'vim'
            return '"'
        else
            return SmartQuote('"')
        endif
    " 可继续添加其他字符规则（如 '[' 等）
    else
        return a:char
    endif
endfunction
" 应用特殊映射
inoremap <silent> { <C-r>=SmartCondition('{')<CR>
inoremap <silent> < <C-r>=SmartCondition('<')<CR>
inoremap <silent> " <C-r>=SmartCondition('"')<CR>

inoremap <silent> ' <C-r>=SmartQuote("'")<CR>

function! SmartPair(left, right)
    let line = getline('.')
    let col = col('.') - 1

    " 如果光标前是反斜杠，直接插入左括号，不补全
    if col > 0 && line[col-1] == '\'
        return a:left
    endif

    " 原有逻辑（保持不变）
    if col >= len(line) || line[col] =~ '\s'
        return a:left . a:right . "\<Left>"
    endif
    let next = line[col]
    if next =~ '[])}>"]' || next == "'"
        return a:left . a:right . "\<Left>"
    endif
    return a:left
endfunction

" 引号补全（支持字符串内智能关闭）
function! SmartQuote(quote)
    let line = getline('.')
    let col = col('.') - 1

    " 1. 如果光标前是反斜杠，直接插入，不补全（转义场景）
    if col > 0 && line[col-1] == '\'
        return a:quote
    endif

    " 2. 如果光标后已有同款引号，跳过（充当右引号）
    if col < len(line) && line[col] == a:quote
        return "\<Right>"
    endif

    " 3. 如果光标后是异类引号或右括号，补全一对（嵌套）
    if col < len(line) && (line[col] =~ '[])}>"]' || line[col] == "'")
        return a:quote . a:quote . "\<Left>"
    endif

    " 4. 如果光标后是非空白字符，只插入左引号（续写）
    if col < len(line) && line[col] !~ '\s'
        return a:quote
    endif

    " 5. 行尾或空白：统计未被转义的该引号个数
    let before = line[:col-1]
    let quote_count = 0
    let i = 0
    while i < len(before)
        if before[i] == a:quote
            " 如果前一个字符不是反斜杠，则计数（忽略转义）
            if i == 0 || before[i-1] != '\'
                let quote_count += 1
            endif
        endif
        let i += 1
    endwhile

    " 奇数 → 补全右引号（关闭），偶数 → 补全一对
    if quote_count % 2 == 1
        return a:quote
    else
        return a:quote . a:quote . "\<Left>"
    endif
endfunction

" 右括号智能跳出
inoremap <silent> ) <C-r>=SmartClose(')')<CR>
inoremap <silent> ] <C-r>=SmartClose(']')<CR>
inoremap <silent> } <C-r>=SmartClose('}')<CR>
inoremap <silent> > <C-r>=SmartClose('>')<CR>
"inoremap <silent> " <C-r>=SmartCloseQuote('"')<CR>
"inoremap <silent> ' <C-r>=SmartCloseQuote("'")<CR>

function! SmartClose(char)
    let line = getline('.')
    let col = col('.') - 1
    if col < len(line) && line[col] == a:char
        return "\<Right>"
    endif
    return a:char
endfunction

function! SmartCloseQuote(quote)
    silent!
    let line = getline('.')
    let col = col('.') - 1

    if col < len(line) && line[col] == a:quote
        return "\<Right>"
    endif

    return a:quote
endfunction

" 智能退格：成对删除括号/引号
inoremap <silent> <BS> <C-r>=SmartBackspace()<CR>

function! SmartBackspace()
    silent!
    let line = getline('.')
    let col = col('.') - 1

    if col <= 0
        return "\<BS>"
    endif

    let char_before = line[col - 1]
    let char_after = col < len(line) ? line[col] : ''

    " 删除成对引号 "" 或 ''
    if (char_before == '"' && char_after == '"') ||
       \ (char_before == "'" && char_after == "'")
        let before_prev = col > 1 ? line[col - 2] : ''
        let after_next = col + 1 < len(line) ? line[col + 1] : ''
        if before_prev != char_before && after_next != char_after
            return "\<BS>\<Del>"
        endif
    endif

    " 删除成对括号 () [] {}
    let pairs = {'(' : ')', '[' : ']', '{' : '}', '<' : '>'}
    if has_key(pairs, char_before) && char_after == pairs[char_before]
        let before_prev = col > 1 ? line[col - 2] : ''
        let after_next = col + 1 < len(line) ? line[col + 1] : ''
        if before_prev != char_before || after_next != char_after
            return "\<BS>\<Del>"
        endif
    endif

    " 嵌套括号 ((|)) → 删除内层一对
    if col >= 2 && col + 2 <= len(line)
        let before2 = line[col - 2]
        let after2 = line[col + 1]
        if before2 == '(' && after2 == ')' &&
           \ char_before == '(' && char_after == ')'
            return "\<BS>\<Del>"
        endif
    endif

    return "\<BS>"
endfunction

" 手动成对删除（快捷键：空格+d）
nnoremap <silent> <leader>d :call DeletePair()<CR>

function! DeletePair()
    silent!
    let line = getline('.')
    let col = col('.') - 1
    let pairs = {'(' : ')', '[' : ']', '{' : '}', '"' : '"', "'" : "'"}

    if col > 0
        let char_before = line[col - 1]
        if has_key(pairs, char_before)
            let char_after = col < len(line) ? line[col] : ''
            if char_after == pairs[char_before]
                call setline('.', line[:col-2] . line[col+1:])
                call cursor('.', col)
                return
            endif
        endif
    endif

    if col < len(line)
        let char_after = line[col]
        for [left, right] in items(pairs)
            if char_after == left
                let end_pos = s:find_matching_right(col, left, right)
                if end_pos != -1
                    call setline('.', line[:col-1] . line[col+1:end_pos-1] . line[end_pos+1:])
                    call cursor('.', col + 1)
                    return
                endif
            endif
        endfor
    endif

    echo "没有找到要成对删除的括号/引号"
endfunction

function! s:find_matching_right(start, left, right)
    silent!
    let line = getline('.')
    let pos = a:start + 1
    let count = 1
    while pos < len(line)
        if line[pos] == a:left
            let count += 1
        elseif line[pos] == a:right
            let count -= 1
            if count == 0
                return pos
            endif
        endif
        let pos += 1
    endwhile
    return -1
endfunction

" ============================================================
" 9. 复制粘贴（系统剪切板）
" ============================================================
" 复制 (<C-S-c>在有的终端有问题，留<C-c>备用)
vnoremap <C-S-c> "+y
nnoremap <C-S-c> "+y
vnoremap <C-c> "+y
nnoremap <C-c> "+y

" 粘贴：仅 Ctrl+Shift+V
nnoremap <C-S-v> "+p
vnoremap <C-S-v> "+p

set pastetoggle=<F11>

" ============================================================
" 10. 快速注释
" ============================================================
let g:comment_map = {
    \ 'python': '# ', 'sh': '# ', 'bash': '# ', 'zsh': '# ',
    \ 'lua': '-- ', 'sql': '-- ',
    \ 'c': '// ', 'cpp': '// ', 'java': '// ', 'javascript': '// ',
    \ 'typescript': '// ', 'go': '// ', 'rust': '// ', 'csharp': '// ',
    \ 'php': '// ', 'json': '// ', 'scss': '// ',
    \ 'vim': '" ', 'vimrc': '" ',
    \ 'html': '<!-- ', 'markdown': '<!-- ',
    \ 'css': '/* ',
    \ 'yaml': '# ', 'yml': '# ', 'ruby': '# ', 'perl': '# ',
    \ 'tex': '% ',
\ }

function! GetCommentStr()
    return get(g:comment_map, &filetype, '# ')
endfunction

function! GetCommentEndStr()
    let ft = &filetype
    if ft == 'html' || ft == 'markdown'
        return ' -->'
    elseif ft == 'css'
        return ' */'
    endif
    return ''
endfunction

" 空格+/ 注释/取消注释
nnoremap <silent> <leader>/ :call ToggleComment()<CR>
vnoremap <silent> <leader>/ :call ToggleCommentVisual()<CR>

function! ToggleComment()
    let line = getline('.')
    let comment = GetCommentStr()
    let comment_end = GetCommentEndStr()
    let trimmed = substitute(line, '^\s*', '', '')

    if trimmed =~ '^' . escape(comment, '.*^$[]')
        " 取消注释
        if comment_end != ''
            let line = substitute(line, '\(\s*\)' . escape(comment, '.*^$[]') . '\(.*\)' . escape(comment_end, '.*^$[]'), '\1\2', '')
        else
            let line = substitute(line, '\(\s*\)' . escape(comment, '.*^$[]'), '\1', '')
        endif
        call setline('.', line)
    else
        " 添加注释
        if comment_end != ''
            let line = substitute(line, '^\(\s*\)\(.*\)$', '\1' . comment . '\2' . comment_end, '')
        else
            let line = substitute(line, '^\(\s*\)\(.*\)$', '\1' . comment . '\2', '')
        endif
        call setline('.', line)
    endif
endfunction

function! ToggleCommentVisual()
    let comment = GetCommentStr()
    let comment_end = GetCommentEndStr()
    let first_line = getline("'<")
    let trimmed = substitute(first_line, '^\s*', '', '')
    let is_commented = trimmed =~ '^' . escape(comment, '.*^$[]')

    if is_commented
        if comment_end != ''
            execute "'<,'>s/\\(\\s*\\)" . escape(comment, '.*^$[]') . "\\(.*\\)" . escape(comment_end, '.*^$[]') . "/\\1\\2/"
        else
            execute "'<,'>s/\\(\\s*\\)" . escape(comment, '.*^$[]') . "/\\1/"
        endif
    else
        if comment_end != ''
            execute "'<,'>s/^\\(\\s*\\)/\\1" . comment . "/"
            execute "'<,'>s/$/" . comment_end . "/"
        else
            execute "'<,'>s/^\\(\\s*\\)/\\1" . comment . "/"
        endif
    endif
endfunction

" ============================================================
" 11. 终端集成
" ============================================================
nnoremap <silent> <leader>tt :call OpenTerminal('horizontal')<CR>
nnoremap <silent> <leader>tv :call OpenTerminal('vertical')<CR>
nnoremap <silent> <leader>tr :call RunInTerminal()<CR>
nnoremap <silent> <leader>tk :call ToggleTerminal()<CR>

" 终端退出
tnoremap <Esc> <C-\><C-n>
tnoremap <C-c> <C-\><C-n>

" 终端复制（退出终端模式后复制到系统剪切板）
tnoremap <C-S-c> <C-\><C-n>"+yi
tnoremap <C-S-v> <C-\><C-n>"+pi

function! OpenTerminal(direction)
    if a:direction == 'horizontal'
        botright terminal
        execute "resize " . (&lines / 3)
    else
        vertical botright terminal
        execute "vertical resize " . (&columns / 3)
    endif
    startinsert
endfunction

function! GetRunCommand()
    let ft = &filetype
    if ft == 'python'
        return 'python3 ' . expand('%')
    elseif ft == 'go'
        return 'go run ' . expand('%')
    elseif ft == 'c'
        return 'gcc ' . expand('%') . ' -o ' . expand('%:r') . ' && ./' . expand('%:r')
    elseif ft == 'cpp'
        return 'g++ ' . expand('%') . ' -o ' . expand('%:r') . ' && ./' . expand('%:r')
    elseif ft == 'javascript'
        return 'node ' . expand('%')
    elseif ft == 'sh' || ft == 'bash'
        return 'bash ' . expand('%')
    elseif ft == 'lua'
        return 'lua ' . expand('%')
    elseif ft == 'rust'
        return 'cargo run'
    else
        return ''
    endif
endfunction

function! RunInTerminal()
    let cmd = GetRunCommand()
    if cmd == ''
        echo "不支持的文件类型: " . &filetype
        return
    endif
    silent! write
    botright terminal
    execute "resize " . (&lines / 3)
    call feedkeys(cmd . "\<CR>")
    startinsert
endfunction

function! ToggleTerminal()
    let term_buf = -1
    for buf in range(1, bufnr('$'))
        if getbufvar(buf, '&buftype') == 'terminal'
            let term_buf = buf
            break
        endif
    endfor

    if term_buf == -1
        botright terminal
        execute "resize " . (&lines / 3)
        startinsert
    else
        if bufwinnr(term_buf) == -1
            execute "botright split | buffer " . term_buf
            execute "resize " . (&lines / 3)
            startinsert
        else
            execute bufwinnr(term_buf) . "wincmd c"
        endif
    endif
endfunction

" ============================================================
" 12. 补全
" ============================================================
set completeopt=menuone,noinsert,noselect,preview
set complete=.,w,b,u,t,i,k
set wildmenu
set wildmode=full
set wildignorecase
set wildignore+=*.pyc,*.pyo,*.swp,*.swo,*.so,*.dll,*.exe
set wildignore+=*.jpg,*.png,*.gif,*.bmp,*.ico
set wildignore+=*.zip,*.tar,*.gz,*.bz2
set wildignore+=node_modules,__pycache__,*.git,*.svn
set wildignore+=*.o,*.a,*.obj,*.class

inoremap <silent><expr> <TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <silent><expr> <S-TAB> pumvisible() ? "\<C-p>" : "\<S-TAB>"
inoremap <silent><expr> <CR> pumvisible() ? "\<C-y>" : "\<CR>"
"inoremap <silent><expr> <CR> pumvisible() ? "\<C-y>" : (SmartEnterCondition() ? "\<C-o>:call SmartEnter()\<CR>" : "\<CR>")

filetype plugin on

" 各语言补全函数
let g:omni_func_map = {
    \ 'python': 'python3complete#Complete',
    \ 'javascript': 'javascriptcomplete#CompleteJS',
    \ 'html': 'htmlcomplete#CompleteTags',
    \ 'css': 'csscomplete#CompleteCSS',
    \ 'c': 'ccomplete#Complete',
    \ 'cpp': 'cppcomplete#Complete',
    \ 'go': 'go#complete#Complete',
    \ 'ruby': 'rubycomplete#Complete',
    \ 'perl': 'perlcomplete#Complete',
    \ 'php': 'phpcomplete#Complete',
    \ 'xml': 'xmlcomplete#CompleteTags'
\ }

function! SetOmniFunc()
    let ft = &filetype
    if has_key(g:omni_func_map, ft)
        execute 'set omnifunc=' . g:omni_func_map[ft]
    else
        set omnifunc=syntaxcomplete#Complete
    endif
endfunction
autocmd FileType * call SetOmniFunc()

" ============================================================
" 13. 代码折叠
" ============================================================
set foldmethod=indent
set foldlevel=99
set foldenable
set foldnestmax=5
set foldminlines=2
set foldtext=MyFoldText()

function! MyFoldText()
    let line = getline(v:foldstart)
    let n = v:foldend - v:foldstart + 1
    return "+ " . line . " ... " . n . " lines"
endfunction

" ============================================================
" 14. Leader 快捷键（空格前缀）
" ============================================================
" 辅助函数：保存并 2 秒后清空消息
function! SaveAndClear()
    write
    call timer_start(2000, {-> execute('echo ""', '')})
endfunction


" 搜索
nnoremap <silent> <leader>h :nohlsearch<CR>

" 文件操作
nnoremap <leader>w :call SaveAndClear()<CR>
nnoremap <silent> <leader>q :silent! quit<CR>
nnoremap <leader>x :call SaveAndClear()<CR>:silent! quit<CR>
nnoremap <silent> <leader>W :silent! wall<CR>
nnoremap <silent> <leader>Q :silent! qall<CR>

" 代码功能
nnoremap <silent> <leader>f :call FormatCode()<CR>
nnoremap <silent> <leader>c :call CheckCode()<CR>

" 折叠
nnoremap <silent> <leader><leader> :silent! za<CR>   " 空格+空格 切换折叠
nnoremap <silent> <leader>z zM                       " 全部折叠
nnoremap <silent> <leader>Z zR                       " 全部展开

" 配置管理
nnoremap <silent> <leader>sv :source $MYVIMRC<CR>
nnoremap <silent> <leader>ev :e $MYVIMRC<CR>
nnoremap <silent> <leader>dd :g/^\s*$/d<CR>

" Git
nnoremap <silent> <leader>gs :!git status<CR>
nnoremap <silent> <leader>gd :!git diff<CR>
nnoremap <silent> <leader>gl :!git log --oneline --graph<CR>
nnoremap <silent> <leader>ga :!git add %<CR>
nnoremap <silent> <leader>gc :!git commit -m "<C-r>=input('Commit: ')<CR>"<CR>
nnoremap <silent> <leader>gp :!git push<CR>
nnoremap <silent> <leader>gP :!git pull<CR>

" 十六进制
nnoremap <silent> <leader>hx :%!xxd<CR>
nnoremap <silent> <leader>hX :%!xxd -r<CR>

" 排序
vnoremap <silent> <leader>s :sort<CR>
vnoremap <silent> <leader>su :sort u<CR>
vnoremap <silent> <leader>sn :sort n<CR>

" 统计
nnoremap <silent> <leader>wc g<C-g>

" 寄存器
nnoremap <silent> <leader>r :reg<CR>

" 行尾空格清理
nnoremap <silent> <leader>ws :call StripTrailingWhitespaceManual()<CR>

" ============================================================
" 15. 行尾空格显示与清理
" ============================================================
highlight ExtraWhitespace ctermfg=240 guifg=#666666 ctermbg=NONE guibg=NONE
match ExtraWhitespace /\s\+$/

" 保存时自动清理行尾空格（Markdown 除外）
autocmd BufWritePre * call StripTrailingWhitespace()

function! StripTrailingWhitespace()
    if &filetype == 'markdown'
        return
    endif
    let pos = getpos('.')
    silent! execute '%s/\s\+$//e'
    call setpos('.', pos)
endfunction

function! StripTrailingWhitespaceManual()
    let pos = getpos('.')
    silent! execute '%s/\s\+$//e'
    call setpos('.', pos)
    echo "已清理行尾空格"
endfunction

" ============================================================
" 16. 边界线
" ============================================================
if exists('+colorcolumn')
    set colorcolumn=120
    highlight! ColorColumn ctermbg=234 guibg=#3a3a3a cterm=NONE gui=NONE
endif

" ============================================================
" 17. 普通快捷键（无 leader）
" ============================================================
" 保存
nnoremap <C-s> :call SaveAndClear()<CR>
inoremap <C-s> <Esc>:call SaveAndClear()<CR>

" 窗口切换
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" 标签页切换
nnoremap <silent> <S-Left> :tabp<CR>
nnoremap <silent> <S-Right> :tabn<CR>
nnoremap <silent> <C-t> :tabnew<CR>
nnoremap <silent> <C-w> :tabclose<CR>

" 全选复制
map <C-a> ggVG$"+y
vnoremap <C-x> "+x

" ============================================================
" 18. F 键快捷键
" ============================================================
nnoremap <silent> <F3> :Explore<CR>          " 文件浏览器
nnoremap <silent> <F4> :Vexplore<CR>         " 垂直浏览器
nnoremap <silent> <F5> :call RunCode()<CR>   " 运行代码
nnoremap <silent> <F6> :call DebugCode()<CR> " 调试代码
nnoremap <silent> <F8> :call CheckCode()<CR> " 代码检查
nnoremap <silent> <F9> gg=G                  " 基础格式化
nnoremap <silent> <F10> :call FormatCode()<CR> " 自动格式化
nnoremap <silent> <F7> :set wrap!<CR>:echo "wrap = " . &wrap<CR>  " 切换自动换行

" ============================================================
" 19. 运行、调试、格式化、检查函数
" ============================================================
func! RunCode()
    silent! write
    let ft = &filetype
    if ft == 'python'
        exec "!python3 %"
    elseif ft == 'go'
        exec "!go run %"
    elseif ft == 'c'
        exec "!gcc % -o %< -Wall -Wextra -O2 && ./%<"
    elseif ft == 'cpp'
        exec "!g++ % -o %< -std=c++17 -Wall -Wextra -O2 && ./%<"
    elseif ft == 'javascript'
        exec "!node %"
    elseif ft == 'sh'
        exec "!bash %"
    elseif ft == 'lua'
        exec "!lua %"
    elseif ft == 'java'
        exec "!javac % && java %<"
    elseif ft == 'html'
        exec "!firefox % &"
    else
        echo "vimore: 不支持的文件类型: " . ft
    endif
    redraw!
endfunc

func! DebugCode()
    silent! write
    let ft = &filetype
    if ft == 'python'
        exec "!python3 -m pdb %"
    elseif ft == 'c' || ft == 'cpp'
        exec "!g++ % -g -o %< && gdb ./%<"
    elseif ft == 'go'
        exec "!dlv debug %"
    else
        echo "vimore: 调试不支持的文件类型: " . ft
    endif
    redraw!
endfunc

func! FormatCode()
    silent! write
    let pos = getpos('.')
    let formatted = 0

    if &filetype == 'python'
        if executable('black')
            silent! execute "!black --skip-string-normalization %"
            let formatted = 1
        elseif executable('autopep8')
            silent! execute "!autopep8 -i --aggressive --max-line-length=120 %"
            let formatted = 1
        endif
        if formatted && executable('isort')
            silent! execute "!isort %"
        endif
        if !formatted
            execute "normal gg=G"
        endif
    elseif &filetype == 'go'
        if executable('gofmt')
            silent! execute "!gofmt -w %"
            let formatted = 1
        endif
        if formatted && executable('goimports')
            silent! execute "!goimports -w %"
        endif
        if !formatted
            execute "normal gg=G"
        endif
    elseif &filetype == 'javascript' || &filetype == 'typescript'
        if executable('prettier')
            silent! execute "!prettier --write %"
            let formatted = 1
        elseif executable('eslint')
            silent! execute "!eslint --fix %"
            let formatted = 1
        endif
        if !formatted
            execute "normal gg=G"
        endif
    elseif &filetype == 'c' || &filetype == 'cpp'
        if executable('clang-format')
            silent! execute "!clang-format -i %"
            let formatted = 1
        endif
        if !formatted
            execute "normal gg=G"
        endif
    elseif &filetype == 'java'
        if executable('astyle')
            silent! execute "!astyle --style=java --suffix=none %"
            let formatted = 1
        endif
        if !formatted
            execute "normal gg=G"
        endif
    elseif &filetype == 'json'
        if executable('prettier')
            silent! execute "!prettier --write %"
            let formatted = 1
        elseif executable('python3')
            silent! execute "!python3 -m json.tool % > %:r.tmp && mv %:r.tmp %"
            let formatted = 1
        endif
        if !formatted
            execute "normal gg=G"
        endif
    else
        execute "normal gg=G"
    endif

    silent! execute "e!"
    call setpos('.', pos)
    redraw!
endfunc

func! CheckCode()
    silent! write
    if &filetype == 'python'
        if executable('pylint')
            exec "!pylint %"
        elseif executable('flake8')
            exec "!flake8 %"
        else
            echo "vimore: 未找到 Python 代码检查工具"
        endif
    elseif &filetype == 'javascript'
        if executable('eslint')
            exec "!eslint %"
        else
            echo "vimore: 未找到 JavaScript 代码检查工具"
        endif
    else
        echo "vimore: 代码检查不支持的文件类型: " . &filetype
    endif
    redraw!
endfunc

" ============================================================
" 20. 文件浏览器配置
" ============================================================
let g:netrw_banner=0
let g:netrw_liststyle=3
let g:netrw_winsize=25
let g:netrw_altv=1
let g:netrw_alto=1
let g:netrw_browse_split=0
let g:netrw_preview=1
let g:netrw_sort_sequence='[\/]$,*'

" ============================================================
" 21. 文件头自动生成
" ============================================================
autocmd BufNewFile *.py,*.go,*.sh,*.c,*.cpp,*.java,*.js,*.ts,*.rs,*.lua call s:SetTitle()

function! s:SetTitle()
    if line('$') > 1 && getline(1) != ''
        return
    endif

    let author = "BiaoZyx"
    let email = "BiaoZyx@outlook.com"
    let date = strftime("%Y-%m-%d %H:%M:%S")

    if &filetype == 'python'
        call setline(1, "#!/usr/bin/env python3")
        call append(1, "# -*- coding: utf-8 -*-")
        call append(2, "\"\"\"")
        call append(3, "@Author: " . author)
        call append(4, "@Email: " . email)
        call append(5, "@Date: " . date)
        call append(6, "@Description: ")
        call append(7, "\"\"\"")
        call append(8, "")
    elseif &filetype == 'go'
        call setline(1, "package main")
        call append(1, "")
        call append(2, "func main() {")
        call append(3, "}")
        call append(4, "")
    elseif &filetype == 'sh'
        call setline(1, "#!/bin/bash")
        call append(1, "# Author: " . author)
        call append(2, "# Email: " . email)
        call append(3, "# Date: " . date)
        call append(4, "")
    elseif &filetype == 'c'
        call setline(1, "/*************************************************************************")
        call append(1, " * @file: ".expand("%"))
        call append(2, " * @author: " . author)
        call append(3, " * @email: " . email)
        call append(4, " * @date: " . date)
        call append(5, " * @description: ")
        call append(6, " ************************************************************************/")
        call append(7, "")
        call append(8, "#include <stdio.h>")
        call append(9, "#include <stdlib.h>")
        call append(10, "")
        call append(11, "int main(int argc, char *argv[]) {")
        call append(12, "    return 0;")
        call append(13, "}")
        call append(14, "")
    elseif &filetype == 'cpp'
        call setline(1, "/*************************************************************************")
        call append(1, " * @file: ".expand("%"))
        call append(2, " * @author: " . author)
        call append(3, " * @email: " . email)
        call append(4, " * @date: " . date)
        call append(5, " * @description: ")
        call append(6, " ************************************************************************/")
        call append(7, "")
        call append(8, "#include <iostream>")
        call append(9, "#include <vector>")
        call append(10, "#include <string>")
        call append(11, "#include <algorithm>")
        call append(12, "")
        call append(13, "using namespace std;")
        call append(14, "")
        call append(15, "int main(int argc, char *argv[]) {")
        call append(16, "    return 0;")
        call append(17, "}")
        call append(18, "")
    elseif &filetype == 'java'
        call setline(1, "/*")
        call append(1, " * @file: ".expand("%"))
        call append(2, " * @author: " . author)
        call append(3, " * @email: " . email)
        call append(4, " * @date: " . date)
        call append(5, " */")
        call append(6, "")
        call append(7, "public class ".expand("%:r"))
        call append(8, "{")
        call append(9, "    public static void main(String[] args) {")
        call append(10, "        System.out.println(\"Hello, World!\");")
        call append(11, "    }")
        call append(12, "}")
        call append(13, "")
    elseif &filetype == 'javascript'
        call setline(1, "/**")
        call append(1, " * @file: ".expand("%"))
        call append(2, " * @author: " . author)
        call append(3, " * @email: " . email)
        call append(4, " * @date: " . date)
        call append(5, " */")
        call append(6, "")
    endif
    normal G
endfunction

" ============================================================
" 22. 自动命令
" ============================================================
autocmd FocusGained,BufEnter * :silent! checktime
autocmd BufEnter * :silent! lcd %:p:h
autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g'\"" | endif

" ============================================================
" 23. 帮助
" ============================================================
function! VimMoreHelp()
    echo ""
    echo "    ╔══════════════════════════════════════════════════════════════════╗"
    echo "    ║                         vimore 帮助                              ║"
    echo "    ╠══════════════════════════════════════════════════════════════════╣"
    echo "    ║  基础操作:                                                       ║"
    echo "    ║    SPC-w   保存                 SPC-q  退出                      ║"
    echo "    ║    SPC-x   保存并退出           SPC-h  取消搜索高亮              ║"
    echo "    ║    SPC-W   全部保存             SPC-Q  全部退出                  ║"
    echo "    ║                                                                  ║"
    echo "    ║  编程功能:                                                       ║"
    echo "    ║    SPC-/   快速注释             SPC-c  代码检查                  ║"
    echo "    ║    SPC-f   格式化代码           <F3>   文件浏览器                ║"
    echo "    ║    <F4>    垂直浏览器           <F5>   运行代码                  ║"
    echo "    ║    <F6>    调试代码             <F8>   代码检查                  ║"
    echo "    ║    <F9>    基础格式化           <F10>  自动格式化                ║"
    echo "    ║    <F11>   粘贴模式切换                                          ║"
    echo "    ║                                                                  ║"
    echo "    ║  折叠:                                                           ║"
    echo "    ║    SPC-SPC 切换折叠             SPC-z  全部折叠                  ║"
    echo "    ║    SPC-Z   全部展开                                              ║"
    echo "    ║                                                                  ║"
    echo "    ║  终端:                                                           ║"
    echo "    ║    SPC-tt  底部终端             SPC-tv  右侧终端                 ║"
    echo "    ║    SPC-tr  运行当前文件         SPC-tk  切换/关闭终端            ║"
    echo "    ║    Esc     终端回到普通模式                                      ║"
    echo "    ║                                                                  ║"
    echo "    ║  标签页:                                                         ║"
    echo "    ║    SPC-tn  新建标签             SPC-tc  关闭标签                 ║"
    echo "    ║    SPC-to  保留当前标签         SPC-tl  列出标签                 ║"
    echo "    ║    SPC-1~9 跳转标签             SPC-0   跳转第10个               ║"
    echo "    ║    SPC-tu  恢复关闭标签         SPC-td  新标签打开目录           ║"
    echo "    ║    SPC-te  新标签编辑当前       SPC-tm  移动标签                 ║"
    echo "    ║    SPC-tM  左移标签             SPC-tN  右移标签                 ║"
    echo "    ║    SPC-tr  重命名标签           SPC-ft  新标签查找文件           ║"
    echo "    ║    S-Left/Right  标签页切换     C-t  新建   C-w  关闭            ║"
    echo "    ║                                                                  ║"
    echo "    ║  导航:                                                           ║"
    echo "    ║    C-h/j/k/l  窗口切换                                           ║"
    echo "    ║                                                                  ║"
    echo "    ║  Git:                                                            ║"
    echo "    ║    SPC-gs 状态   SPC-gd 差异   SPC-gl 日志   SPC-ga 添加         ║"
    echo "    ║    SPC-gc 提交   SPC-gp 推送   SPC-gP 拉取                       ║"
    echo "    ║                                                                  ║"
    echo "    ║  配置:                                                           ║"
    echo "    ║    SPC-sv  重新加载配置         SPC-ev  编辑配置                 ║"
    echo "    ║    SPC-ws  删除行尾空格         SPC-dd  删除空行                 ║"
    echo "    ║                                                                  ║"
    echo "    ║  其他:                                                           ║"
    echo "    ║    SPC-d   成对删除括号/引号    SPC-r   查看寄存器               ║"
    echo "    ║    SPC-wc  统计字数             SPC-hx  十六进制模式             ║"
    echo "    ║    SPC-hX  退出十六进制         SPC-s   排序选中行               ║"
    echo "    ║    SPC-su  去重排序             SPC-sn  数字排序                 ║"
    echo "    ║    C-c     复制到系统剪切板     C-v     从系统剪切板粘贴         ║"
    echo "    ║    C-s     保存（含插入模式）   C-a     全选复制                 ║"
    echo "    ║                                                                  ║"
    echo "    ║  命令:  :D  黑洞删除            :HelpVimore  帮助                ║"
    echo "    ║                                                                  ║"
    echo "    ║  *SPC = 空格键                                                   ║"
    echo "    ╚══════════════════════════════════════════════════════════════════╝"
    echo ""
endfunction

command! HelpVimore call VimMoreHelp()

" ============================================================
" 24. 标签栏
" ============================================================
set showtabline=1

highlight clear TabLine
highlight clear TabLineSel
highlight clear TabLineFill

highlight TabLine       ctermfg=245 ctermbg=237 cterm=NONE
highlight TabLineSel    ctermfg=220 ctermbg=235 cterm=bold
highlight TabLineFill   ctermbg=237 cterm=NONE

function! MyTabLine()
    let s = ''
    let t = tabpagenr()
    let n = tabpagenr('$')

    let width = (&columns - 2) / n
    if width < 8 | let width = 8 | endif
    let padding = 2

    for i in range(1, n)
        let buflist = tabpagebuflist(i)
        let winnr = tabpagewinnr(i)
        let bufname = fnamemodify(bufname(buflist[winnr - 1]), ':t')
        if bufname == '' | let bufname = '[No Name]' | endif

        let name_len = width - len(i . ':') - 2 - padding
        if len(bufname) > name_len
            let bufname = bufname[:name_len-2] . '…'
        endif

        let modified = getbufvar(buflist[winnr - 1], '&modified') ? '+' : ''
        let label = ' ' . i . ':' . bufname . modified
        let label = label . repeat(' ', width - len(label))

        if i == t
            let s .= '%#TabLineSel#' . label
        else
            let s .= '%#TabLine#' . label
        endif
    endfor

    let s .= '%#TabLineFill#%T'
    return s
endfunction

set tabline=%!MyTabLine()

" ============================================================
" 25. 标签页快捷键
" ============================================================
nnoremap <silent> <leader>tn :tabnew<CR>
nnoremap <leader>te :tabedit %<CR>
nnoremap <silent> <leader>tc :tabclose<CR>
nnoremap <silent> <leader>to :tabonly<CR>

nnoremap <leader>1 1gt
nnoremap <leader>2 2gt
nnoremap <leader>3 3gt
nnoremap <leader>4 4gt
nnoremap <leader>5 5gt
nnoremap <leader>6 6gt
nnoremap <leader>7 7gt
nnoremap <leader>8 8gt
nnoremap <leader>9 9gt
nnoremap <leader>0 10gt

nnoremap <leader>tm :tabmove<CR>
nnoremap <silent> <leader>tM :tabmove -1<CR>
nnoremap <silent> <leader>tN :tabmove +1<CR>
nnoremap <leader>tl :tabs<CR>
nnoremap <leader>tu :tabnew #<CR>
nnoremap <leader>td :tabnew .<CR>
" nnoremap <leader>tr :tabrename<CR>   " 重命名标签（需要插件）
nnoremap <leader>ft :tabfind *<CR>
