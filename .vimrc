set 	number
set 	nohlsearch
syntax on
set nocompatible
filetype plugin on

nmap <silent> <c-k> <c-o> :Files<CR>
imap jj <ESC>
let mapleader = ";"

command! Md :m +1
command! Mu :m -2
command! C  :s/^./\=submatch(0)=="#"?"":"#".submatch(0)/
command! A  :s/^\([+-]\)\(.*[\r\n]\)/\=submatch(1)=="+"?"":" ".submatch(2)/

function! RebaseAction(a)
  if a:a == "p"
    let action = "pick"
  elseif a:a == "r"
    let action = "reword"
  elseif a:a == "e"
    let action = "edit"
  elseif a:a == "s"
    let action = "squash"
  elseif a:a == "f"
    let action = "fixup"
  elseif a:a == "x"
    let action = "execute"
  else
    echom "You must select one of the actions: p (pick), r (reword), e (edit), s (squash), f (fixup), x (execute)."
    return
  endif

  :s/^\([presfx]\|pick\|reword\|edit\|squash\|fixup\|execute\)\(\s.*\)/\=action . submatch(2)/
  return
   

  echom "Action: " . action
endfunction

command! -nargs=1 R call RebaseAction(<f-args>)

set ts=2 sts=2 sw=2 expandtab
set smartindent
let g:vim_json_syntax_conceal = 0

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
Plug 'junegunn/fzf.vim'
Plug 'mhinz/vim-signify'
Plug 'airblade/vim-gitgutter'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'tpope/vim-fugitive'
Plug 'junegunn/gv.vim'
Plug 'chrisbra/colorizer'
Plug 'yggdroot/indentline'
Plug 'vimwiki/vimwiki'
Plug 'easymotion/vim-easymotion'
Plug 'morhetz/gruvbox'
Plug 'psliwka/vim-smoothie'
Plug 'dense-analysis/ale'
Plug 'omnisharp/omnisharp-vim'
Plug 'nickspoons/vim-sharpenup'
Plug 'bkad/camelcasemotion'
Plug 'pedrohdz/vim-yaml-folds'
Plug 'elzr/vim-json'
call plug#end()

let g:airline_powerline_fonts = 1
let g:airline_theme='base16_gruvbox_dark_hard'

autocmd FileType git set foldlevel=1

let g:gruvbox_contrast_dark='hard'

" Fix vimdiff coloring, based on theme colors
highlight DiffAdd    cterm=bold ctermfg=10 ctermbg=17 gui=none guifg=bg guibg=Red
highlight DiffDelete cterm=bold ctermfg=10 ctermbg=17 gui=none guifg=bg guibg=Red
highlight DiffChange cterm=bold ctermfg=10 ctermbg=17 gui=none guifg=bg guibg=Red
highlight DiffText   cterm=bold ctermfg=10 ctermbg=88 gui=none guifg=bg guibg=Red

let g:vimwiki_list = [{'path': '~/vimwiki/', 'syntax': 'markdown', 'ext': '.md'}]

set ignorecase
set smartcase
set path+=**
set wildmenu
set number relativenumber
set number relativenumber

augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
augroup END

set foldlevelstart=100

let g:ale_completion_enabled = 1
let g:ale_linters = {
    \ 'sh': ['language_server'],
    \ }

set splitright
set splitbelow

