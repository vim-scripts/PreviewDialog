" Vim plugin to show dialogs with colors definitions and image files
" Author: Taylon Silmer <taylonsilva@gmail.com>
" Version: 0.1
" License: This program is free software; you can redistribute it and/or modify
"          it under the terms of the GNU General Public License as published by
"          the Free Software Foundation; either version 2 of the License, or
"          (at your option) any later version.
"
"          This program is distributed in the hope that it will be useful,
"          but WITHOUT ANY WARRANTY; without even the implied warranty of
"          MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU 
"          General Public License for more details.
"
"          You should have received a copy of the GNU General Public License
"          along with this program; if not, write to the Free Software
"          Foundation, Inc., 59 Temple Place - Suite 330, Boston, 
"          MA 02111-1307, USA.
"
" Options:
" 
"   g:PreviewDialogKey:
"     Change shotcurt (Default is 'F8')
"    
"   g:PreviewDialogEnable:
"     Enable PreviewDialog (Default is '1')
"    
"   g:PreviewDialogAuto:
"     Shows the dialog automatically when hold cursor over a word (Default is '1')
"
"   g:PathPyFile:
"     Set the path of .py file (Default is '~/.vim/')
"    
"   g:WindowPosition:
"     Set default window position. Can you use 'center', 'right_top' or 'right_bottom' (Default is 'right_bottom')
"
" ChangeLog:
"   0.1:
"     - First release.
"

" Set default options
if !exists('g:PreviewDialogKey')
    let g:PreviewDialogKey = '<F8>'
endif
if !exists('g:PathPyFile')
    let g:PathPyFile = '~/.vim/'
endif
if !exists('g:DialogPosition')
    let g:DialogPosition = 'right_bottom'
endif
if !exists('g:DialogTitle')
    let g:DialogTitle = 'VIM - PreviewDialog'
endif
if !exists('g:PreviewDialogAuto')
    let g:PreviewDialogAuto = 1
endif

" Remember the last image/color displayed
let s:LastWord = ''

function! Show(hold)
    if (strpart(getline('.'), col('.') - 1, 1) =~ '\S')
        let s:word = expand('<cfile>')

        " If have a '#' probably is a color
        if s:word =~ '#'
            let s:word = expand('<cword>')
        endif

        " Check the LastWord just in CursorHold event
        if a:hold
            if s:LastWord != s:word
                call system('python '.g:PathPyFile.'preview_dialog.py -s '.s:word.' -t'.fnameescape(g:DialogTitle).' -p'.g:DialogPosition.' &')
                let s:LastWord = s:word
            endif
        else
            call system('python '.g:PathPyFile.'preview_dialog.py -s '.s:word.' -t'.g:DialogTitle.' -p'.g:DialogPosition.' &')
        endif
    endif
endfunction

function! ShowI(hold)
    call Show(a:hold)

    if col('.') == len(getline('.'))
        " Insert if the cursor is in the end of line
        startinsert!
    else
        " <ESC> move the cursor to the left, then move it for right
        let s:pos = getpos('.')
        let s:pos[2] += 1
        call setpos('.', s:pos)
        startinsert
    endif
endfunction

if exists('g:PreviewDialogEnable') && g:PreviewDialogEnable
    exec 'nmap '.g:PreviewDialogKey.' :call Show(0)<CR>'
    exec 'imap '.g:PreviewDialogKey.' <ESC>:call ShowI(0)<CR>'
    if exists('g:PreviewDialogAuto') && g:PreviewDialogAuto
        au! CursorHold  * nested call Show(1)
    endif
endif
