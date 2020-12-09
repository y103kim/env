" Specify a directory for plugins
" - For Neovim: stdpath('data') . '/plugged'
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.local/nvim/plugged')
Plug 'scrooloose/nerdtree'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'terryma/vim-expand-region'
Plug 'tomasiser/vim-code-dark'
Plug 'fatih/vim-go'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'mg979/vim-visual-multi'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
call plug#end()

"" default setting
syntax on
set ai
set ci
set si
set relativenumber
set nu
set imi=1
set hidden
let mapleader=","
set mouse=a
set backspace=2
set updatetime=200
set colorcolumn=100
set belloff=all
set clipboard=

"" tab settings
set ts=2
set sw=2
set sts=2
set expandtab

" Gnu style indent settings
function! GnuIndent()
  set cinoptions=>4,n-2,{2,^-2,:2,=2,g0,h2,p5,t0,+2,(0,u0,w1,m1
  set shiftwidth=2
  set tabstop=8
endfunction

" Set tabstop, softtabstop and shiftwidth to the same value
command! -nargs=* ET call ET()
function! ET()
  let l:tabstop = 1 * input('set tabstop = softtabstop = shiftwidth = ')
  if l:tabstop > 0
    let &l:sts = l:tabstop
    let &l:ts = l:tabstop
    let &l:sw = l:tabstop
    set expandtab
  endif
  call SummarizeTabs()
endfunction

command! -nargs=* NT call NT()
function! NT()
  let l:tabstop = 1 * input('set tabstop = softtabstop = shiftwidth = ')
  if l:tabstop > 0
    let &l:sts = l:tabstop
    let &l:ts = l:tabstop
    let &l:sw = l:tabstop
    set noexpandtab
  endif
  call SummarizeTabs()
endfunction

function! SummarizeTabs()
  try
    echohl ModeMsg
    echon 'tabstop='.&l:ts
    echon ' shiftwidth='.&l:sw
    echon ' softtabstop='.&l:sts
    if &l:et
      echon ' expandtab'
    else
      echon ' noexpandtab'
    endif
  finally
    echohl None
  endtry
endfunction

"" Trailing whitespace
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
map <leader>dw :%s/\s\+$//<cr>

"" set function keys
set nopaste
set pastetoggle=<F4>
map <F9> @q
map <F8> <esc><<esc><esc><esc>:w<cr>:make<cr><cr><cr><cr>
map ,bu <esc><esc>:w<cr>:make<cr><cr><cr><cr>
autocmd QuickFixCmdPost [^l]* nested cwindow
autocmd QuickFixCmdPost    l* nested lwindow

"" function key toggle
set mouse=a
function! ShowMouseMode()
  if (&mouse == 'a')
    echo "mouse-vim"
  else
    echo "mouse-xterm"
  endif
endfunction
map <silent><F5> :let &mouse=(&mouse == "a"?"":"a")<CR>:call ShowMouseMode()<CR>
imap <silent><F5> :let &mouse=(&mouse == "a"?"":"a")<CR>:call ShowMouseMode()<CR>

let g:nu_state = 1
function! NumberToggle()
  if(g:nu_state == 0)
    set number
    set relativenumber
    let g:nu_state = 1
    execute "GitGutterEnable"
  elseif(g:nu_state == 1)
    set number
    set norelativenumber
    let g:nu_state = 2
    execute "GitGutterEnable"
  elseif(g:nu_state == 2)
    set nonu
    set norelativenumber
    let g:nu_state = 0
    execute "GitGutterDisable"
  endif
endfunc
noremap <F3> :call NumberToggle()<CR>

"" buffer setting
map <C-L> :bnext<cr>
map <C-h> :bNext<cr>
map <leader>q :bp <BAR> bd #<CR>

"" config
map <leader>cv :e ~/.vimrc<cr>
map <leader>cs :e ~/.screenrc<cr>
map <leader>cb :e ~/.bashrc<cr>
map <leader>cz :e ~/.zpreztorc<cr>
map <leader>cr :source ~/.vimrc<cr>

"" NerdTree setup
map <leader>ef :NERDTreeToggle<CR>

" <leader>f setup
" FIXME: map formatting function according to file format
map <leader>fo :w<cr>:!yapf -i --style='{based_on_style:google,column_limit:100}' %<CR>:e!<CR>:redraw!<CR>

" Fzf
map <leader>fr :Rg <C-R>=expand("<cword>")<CR><CR>
silent! !git rev-parse --is-inside-work-tree 1>/dev/null 2>&1
if v:shell_error == 0
  map <leader>ff :GFiles <CR>
  map <leader>fs :GFiles! <CR>
else
  map <leader>ff :Files <CR>
  map <leader>fs :Files <CR>
endif
map <leader>fb :Buffers <CR>
map <leader>fb :Buffers <CR>
map <leader>ft :Tags <C-R>=expand("<cword>")<CR><CR>
cnoreabbrev rg Rg

"" Airline setup
" set laststatus=2
" set term=xterm-256color
let g:airline#extensions#tabline#enabled = 1
let g:airline_theme='codedark'
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#fnamemod = ':t'

"" xclip
vmap <C-c> y:call system("xclip -i -selection clipboard", getreg("\""))<CR>
map <leader>ya :call system("xclip -i -selection clipboard", getreg("%"))<CR>
map <leader>yf :call system("xclip -i -selection clipboard", expand("%:t"))<CR>

"" Vim expand region setting
map L <Plug>(expand_region_expand)
map H <Plug>(expand_region_shrink)

"" GitGutter
set updatetime=100
autocmd BufWritePost * GitGutter

"" color scheme
" colorscheme wombat256dave
colorscheme codedark

"" vim-indent-guide
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_auto_colors = 0
hi IndentGuidesOdd  ctermbg=235
hi IndentGuidesEven ctermbg=236

"" hls color
set hls
hi Search cterm=NONE ctermfg=black ctermbg=yellow
map <leader>/ :let @/ = ""<cr>
