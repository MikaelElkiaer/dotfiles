set 	number
set 	nohlsearch
syntax on
set nocompatible
filetype plugin on

nmap <silent> <c-k> <c-o> :Files<CR>

command	Md 	:m +1
command Mu 	:m -2
command C 	:s/^./\=submatch(0)=="#"?"":"#".submatch(0)/
command A 	:s/^\([+-]\)\(.*[\r\n]\)/\=submatch(1)=="+"?"":" ".submatch(2)/

function RebaseAction(a)
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

command -nargs=1 R call RebaseAction(<f-args>)

autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

if &diff
colorscheme elflord
endif

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
Plug 'morhetz/gruvbox'
Plug 'vimwiki/vimwiki'
call plug#end()

let g:airline_powerline_fonts = 1
let g:airline_theme='base16_gruvbox_dark_hard'
let g:gruvbox_termcolors=16
let g:gruvbox_contrast_dark='hard'

autocmd FileType git set foldlevel=1
let g:indentLine_char = '┆'

colorscheme gruvbox

let g:vimwiki_list = [{'path': '~/vimwiki/', 'syntax': 'markdown', 'ext': '.md'}]

