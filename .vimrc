set 	number
set 	nohlsearch
syntax on
set nocompatible
filetype plugin on

nmap <silent> <c-k> <c-o> :Files<CR>
imap jk <ESC>
noremap <SPACE> <Nop>
let mapleader = "\<Space>"

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
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'machakann/vim-swap'
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

augroup omnisharp_commands
  autocmd!

  " Show type information automatically when the cursor stops moving.
  " Note that the type is echoed to the Vim command line, and will overwrite
  " any other messages in this space including e.g. ALE linting messages.
  autocmd CursorHold *.cs OmniSharpTypeLookup

  " The following commands are contextual, based on the cursor position.
  autocmd FileType cs nmap <silent> <buffer> gd <Plug>(omnisharp_go_to_definition)
  autocmd FileType cs nmap <silent> <buffer> <Leader>osfu <Plug>(omnisharp_find_usages)
  autocmd FileType cs nmap <silent> <buffer> <Leader>osfi <Plug>(omnisharp_find_implementations)
  autocmd FileType cs nmap <silent> <buffer> <Leader>ospd <Plug>(omnisharp_preview_definition)
  autocmd FileType cs nmap <silent> <buffer> <Leader>ospi <Plug>(omnisharp_preview_implementations)
  autocmd FileType cs nmap <silent> <buffer> <Leader>ost <Plug>(omnisharp_type_lookup)
  autocmd FileType cs nmap <silent> <buffer> <Leader>osd <Plug>(omnisharp_documentation)
  autocmd FileType cs nmap <silent> <buffer> <Leader>osfs <Plug>(omnisharp_find_symbol)
  autocmd FileType cs nmap <silent> <buffer> <Leader>osfx <Plug>(omnisharp_fix_usings)
  autocmd FileType cs nmap <silent> <buffer> <C-\> <Plug>(omnisharp_signature_help)
  autocmd FileType cs imap <silent> <buffer> <C-\> <Plug>(omnisharp_signature_help)

  " Navigate up and down by method/property/field
  autocmd FileType cs nmap <silent> <buffer> [[ <Plug>(omnisharp_navigate_up)
  autocmd FileType cs nmap <silent> <buffer> ]] <Plug>(omnisharp_navigate_down)
  " Find all code errors/warnings for the current solution and populate the quickfix window
  autocmd FileType cs nmap <silent> <buffer> <Leader>osgcc <Plug>(omnisharp_global_code_check)
  " Contextual code actions (uses fzf, vim-clap, CtrlP or unite.vim selector when available)
  autocmd FileType cs nmap <silent> <buffer> <Leader>osca <Plug>(omnisharp_code_actions)
  autocmd FileType cs xmap <silent> <buffer> <Leader>osca <Plug>(omnisharp_code_actions)
  " Repeat the last code action performed (does not use a selector)
  autocmd FileType cs nmap <silent> <buffer> <Leader>os. <Plug>(omnisharp_code_action_repeat)
  autocmd FileType cs xmap <silent> <buffer> <Leader>os. <Plug>(omnisharp_code_action_repeat)

  autocmd FileType cs nmap <silent> <buffer> <Leader>os= <Plug>(omnisharp_code_format)

  autocmd FileType cs nmap <silent> <buffer> <Leader>osnm <Plug>(omnisharp_rename)

  autocmd FileType cs nmap <silent> <buffer> <Leader>osre <Plug>(omnisharp_restart_server)
  autocmd FileType cs nmap <silent> <buffer> <Leader>osst <Plug>(omnisharp_start_server)
  autocmd FileType cs nmap <silent> <buffer> <Leader>ossp <Plug>(omnisharp_stop_server)
augroup END

inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr>    pumvisible() ? asyncomplete#close_popup() : "\<cr>"
imap <c-space> <Plug>(asyncomplete_force_refresh)
