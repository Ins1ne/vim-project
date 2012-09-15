"=============================================================================
" Description: Local project plugin
"              Go to last file(s) if invoked without arguments, restore previous state
"              Based on:
"                  - http://vimcastsim.wikia.com/wiki/Open_the_last_edited_file
"                  - http://vim.wikia.com/wiki/Restore_state_of_edited_files_when_reopened
" Author:      Aider Ibragimov <aider.ibragimov@gmail.com>
" URL:         https://github.com/Ins1ne/vim-project.git
" Version:     0.0.1
"=============================================================================

" Create folder .vim in current working directory
function! CreateVimProjectFolder()
    if (!isdirectory(".vim"))
        call mkdir(".vim")

        " create directory for undofiles
        call mkdir(".vim/undodir")
    endif
endfunction

" Save session without options
function! SaveProject()
    if (filewritable(".vim"))
        " do not save options
        set sessionoptions-=options

        " save session
        execute "mksession! .vim/session.vim"
        execute "wviminfo! .vim/viminfo.vim"
    endif
endfunction

" Restore session if exist
function! RestoreProject()
    if argc() == 0 && filereadable(".vim/session.vim")
        execute "source .vim/session.vim"
    endif

    if argc() == 0 && filereadable(".vim/viminfo.vim")
        execute "rviminfo .vim/viminfo.vim"
    endif

    execute "set undodir=.vim/undodir"
endfunction

" Allow to map another key
if !exists('g:vim_project_create_map')
    let g:vim_project_create_map = '<F6>'
endif

execute "nnoremap" g:vim_project_create_map ":call CreateVimProjectFolder()<CR>"

autocmd VimLeave * nested :call SaveProject()
autocmd VimEnter * nested :call RestoreProject()

command! CreateVimProjectFolder :call CreateVimProjectFolder()
