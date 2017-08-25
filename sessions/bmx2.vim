let SessionLoad = 1
if &cp | set nocp | endif
let s:so_save = &so | let s:siso_save = &siso | set so=0 siso=0
let v:this_session=expand("<sfile>:p")
silent only
cd w:\unity\bmx2
if expand('%') == '' && !&modified && line('$') <= 1 && getline(1) == ''
  let s:wipebuf = bufnr('%')
endif
set shortmess=aoO
badd +0 Assets\Menus\MenuScripts\Achievements\AchievementsMenu.cs
badd +19 ~\.vimrc
badd +1 ~\.gvimrc
argglobal
silent! argdel *
set lines=86 columns=320
winpos -2568 -25
edit ~\.vimrc
set splitbelow splitright
wincmd _ | wincmd |
vsplit
1wincmd h
wincmd w
set nosplitbelow
set nosplitright
wincmd t
set winminheight=1 winheight=1 winminwidth=1 winwidth=1
exe 'vert 1resize ' . ((&columns * 160 + 160) / 320)
exe 'vert 2resize ' . ((&columns * 159 + 160) / 320)
argglobal
let s:l = 2 - ((1 * winheight(0) + 42) / 84)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
2
normal! 020|
wincmd w
argglobal
edit Assets\Menus\MenuScripts\Achievements\AchievementsMenu.cs
let s:l = 38 - ((37 * winheight(0) + 42) / 84)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
38
normal! 0
wincmd w
2wincmd w
exe 'vert 1resize ' . ((&columns * 160 + 160) / 320)
exe 'vert 2resize ' . ((&columns * 159 + 160) / 320)
if exists('s:wipebuf')
  silent exe 'bwipe ' . s:wipebuf
endif
unlet! s:wipebuf
set winheight=1 winwidth=20 shortmess=filnxtToO
set winminheight=1 winminwidth=1
let s:sx = expand("<sfile>:p:r")."x.vim"
if file_readable(s:sx)
  exe "source " . fnameescape(s:sx)
endif
let &so = s:so_save | let &siso = s:siso_save
doautoall SessionLoadPost
unlet SessionLoad
" vim: set ft=vim :
