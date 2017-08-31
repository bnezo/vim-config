set encoding=utf-8

if has("gui_running")
	set guioptions-=m " Remove menu bar
	set guioptions-=T " Remove toolbar
	set guioptions-=r " Remove right scroll bar
	set guioptions-=L " Remove left scroll bar
endif

" To disable a plugin, add it's bundle name to the following list
let g:pathogen_disabled = []
" e.g. like this:
" call add(g:pathogen_disabled, 'csscolor')
"call add(g:pathogen_disabled, 'gitignore')
"call add(g:pathogen_disabled, 'command-t')
call add(g:pathogen_disabled, 'ctrlp.vim')
call add(g:pathogen_disabled, 'omnisharp-vim')
execute pathogen#infect()
syntax on
filetype plugin indent on
call pathogen#helptags()

" Command-T
let g:CommandTTraverseSCM = 'pwd'
let g:CommandTWildIgnore=&wildignore . ",*.png,*.jpg,*.wav,*.jar,*.tga,*.md,*.mobileprovision,*.meta,*.replay,*.track,*.prefab"

" ctrlp
"let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files . -co --exclude-standard', 'find %s -type f']
"let g:ctrlp_working_path_mode = 'ra'

" OmniSharp
"let g:OmniSharp_selector_ui = 'ctrlp'  " Use ctrlp.vim


" Solarized
"syntax enable
"set background=dark
" Disable italic
"let g:solarized_italic=0
"colorscheme solarized

" gruvbox
let g:gruvbox_italic=0
let g:gruvbox_contrast_dark='soft'
colorscheme gruvbox

set list
set cursorline
" Line numbers
set number

" No error bell
set belloff=all

" Save window size and position
let g:screen_size_restore_pos = 1

if has("gui_running")
	function! ScreenFilename()
		if has('amiga')
			return "s:.vimsize"
		elseif has('win32')
			return $HOME.'\_vimsize'
		else
			return $HOME.'/.vimsize'
		endif
	endfunction

	function! ScreenRestore()
		" Restore window size (columns and lines) and position
		" from values stored in vimsize file.
		" Must set font first so columns and lines are based on font size.
		let f = ScreenFilename()
		if has("gui_running") && g:screen_size_restore_pos && filereadable(f)
			let vim_instance = (g:screen_size_by_vim_instance==1?(v:servername):'GVIM')
			for line in readfile(f)
				let sizepos = split(line)
				if len(sizepos) == 5 && sizepos[0] == vim_instance
					silent! execute "set columns=".sizepos[1]." lines=".sizepos[2]
					silent! execute "winpos ".sizepos[3]." ".sizepos[4]
					return
				endif
			endfor
		endif
	endfunction

	function! ScreenSave()
		" Save window size and position.
		if has("gui_running") && g:screen_size_restore_pos
			let vim_instance = (g:screen_size_by_vim_instance==1?(v:servername):'GVIM')
			let data = vim_instance . ' ' . &columns . ' ' . &lines . ' ' .
						\ (getwinposx()<0?0:getwinposx()) . ' ' .
						\ (getwinposy()<0?0:getwinposy())
			let f = ScreenFilename()
			if filereadable(f)
				let lines = readfile(f)
				call filter(lines, "v:val !~ '^" . vim_instance . "\\>'")
				call add(lines, data)
			else
				let lines = [data]
			endif
			call writefile(lines, f)
		endif
	endfunction

	if !exists('g:screen_size_restore_pos')
		let g:screen_size_restore_pos = 1
	endif
	if !exists('g:screen_size_by_vim_instance')
		let g:screen_size_by_vim_instance = 1
	endif
	autocmd VimEnter * if g:screen_size_restore_pos == 1 | call ScreenRestore() | endif
	autocmd VimLeavePre * if g:screen_size_restore_pos == 1 | call ScreenSave() | endif
endif

" Backspace like normal
set backspace=indent,eol,start

" Tabs are 4 characters wide
set tabstop=4
set shiftwidth=4

" Indent using tabs, align with spaces
set noet sts=0 sw=4 ts=4
set cindent
set cinoptions=(0,u0,U0,t0

" vvv For auto-indent on save
" Restore cursor position, window position, and last search after running a
" command.
function! Preserve(command)
	" Save the last search.
	let search = @/

	" Save the current cursor position.
	let cursor_position = getpos('.')

	" Save the current window position.
	normal! H
	let window_position = getpos('.')
	call setpos('.', cursor_position)

	" Execute the command.
	execute a:command

	" Restore the last search.
	let @/ = search

	" Restore the previous window position.
	call setpos('.', window_position)
	normal! zt

	" Restore the previous cursor position.
	call setpos('.', cursor_position)
endfunction

" Re-indent the whole buffer.
function! Indent()
	call Preserve('normal gg=G')
endfunction
nmap <F9> :call Indent()<CR>
"nmap <C-i> :RetabIndent!<CR>

" Build
set switchbuf=useopen,split
function! RunBuildBatchFile()
	set makeprg=build.bat
	silent make
	copen
	echo 'Build complete'
endfunction
nmap <F7> :w<CR><bar>:call RunBuildBatchFile()<CR>
"Go to next error
nnoremap <F6> :cn<CR><bar>zz
"Go to previous error
nnoremap <F5> :cp<CR><bar>zz

" Disable mouse
set mouse=c

" Always show status bar
set laststatus=2

" Use alt-movement to move lines
nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
inoremap <A-j> <Esc>:m .+1<CR>==gi
inoremap <A-k> <Esc>:m .-2<CR>==gi
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv

" Split on next comma
nnoremap K /,<CR>a<CR><Esc>

noremap <F4> :set hlsearch! hlsearch?<CR>

set ssop=buffers,curdir,resize,winpos,winsize

nnoremap <C-i> <C-i>zz
nnoremap <C-o> <C-o>zz

"function! Interleave(start, end, where)
"    if a:start < a:where
"        for i in range(0, a:end - a:start)
"            execute a:start . 'm' . (a:where + i)
"        endfor
"    else
"        for i in range(a:end - a:start, 0, -1)
"            execute a:end . 'm' . (a:where + i)
"        endfor
"    endif
"endfunction

command! -bar -nargs=* -range=% Interleave :<line1>,<line2>call Interleave(<f-args>)
fun! Interleave(...) range
  if a:0 == 0
    let x = 1
    let y = 1
  elseif a:0 == 1
    let x = a:1
    let y = a:1
  elseif a:0 == 2
    let x = a:1
    let y = a:2
  elseif a:0 > 2
    echohl WarningMsg
    echo "Argument Error: can have at most 2 arguments"
    echohl None
    return
  endif
  let i = a:firstline + x - 1
  let total = a:lastline - a:firstline + 1
  let j = total / (x + y) * x + a:firstline
  while j < a:lastline
    let range = y > 1 ? j . ',' . (j+y) : j
    silent exe range . 'move ' . i
    let i += y + x
    let j += y
  endwhile
endfun

" Persistent scratch window
let g:scratch_persistent_file='~\vimfiles\scratch'

" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" Auto-save session (vim-session)
let g:session_autosave='yes'

" Don't let cursorline highlight visible whitespace
call matchadd("NonText", '^\s\+')
call matchadd("NonText", '\s\+$')
