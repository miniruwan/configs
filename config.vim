" unfold everything when opening a file
"set foldlevelstart=20

set nu

" copying to clipboard
vmap <C-x> :!pbcopy<CR>  
vmap <C-c> "+y

" Setting the correct path for grep
set grepprg=/usr/bin/grep

" change cursor shape between insert and command modes
let &t_SI = "\<Esc>]50;CursorShape=1\x7"
let &t_SR = "\<Esc>]50;CursorShape=2\x7"
let &t_EI = "\<Esc>]50;CursorShape=0\x7"

" do an upward search from the directory containing tags up to the stop directory (~)
set tags+=tags;~

colorscheme zenburn

" Mouse scroll
set mouse=a
map <ScrollWheelUp> <C-Y>
map <ScrollWheelDown> <C-E>

" configure tabwidth and insert spaces instead of tabs
set tabstop=4        " tab width is 4 spaces
set shiftwidth=4     " indent also with 4 spaces
set expandtab        " expand tabs to spaces

" Search web selected text
:vmap ?? y:!
 \ /usr/bin/open -a "/Applications/Google Chrome.app" "http://www.google.com/search?q=
 \<C-R>0
 \"
 \<CR><CR>

" ================== Start of Plugin Configs ==========================
" YouCompleteMe
let g:ycm_global_ycm_extra_conf = '~/.vim_runtime/sources_non_forked/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py'

" Smooth scroll
noremap <silent> <c-u> :call smooth_scroll#up(&scroll, 20, 2)<CR>
noremap <silent> <c-d> :call smooth_scroll#down(&scroll, 20, 2)<CR>
 " ================== End of Plugin Configs ==========================
