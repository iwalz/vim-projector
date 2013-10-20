if !exists("g:projector_run_shortcut")
	let g:projector_run_shortcut = "<F5>"
endif

if !exists("g:projector_compile_shortcut")
	let g:projector_compile_shortcut = "<F6>"
endif

if !exists("g:projector_debug_shortcut")
	let g:projector_debug_shortcut = "<F8>"
endif

if !exists("g:projector_custom1_shortcut")
	let g:projector_custom1_shortcut = "<F9>"
endif

if !exists("g:projector_custom2_shortcut")
	let g:projector_custom2_shortcut = "<F10>"
endif

if !exists("g:projector_custom3_shortcut")
	let g:projector_custom3_shortcut = "<F11>"
endif

execute "nnoremap <silent>" . g:projector_run_shortcut . " :call projector#Run()<cr>"
execute "inoremap <silent>" . g:projector_run_shortcut . " <C-O>:call projector#Run()<cr>"
execute "nnoremap <silent>" . g:projector_compile_shortcut . " :call projector#Compile()<cr>"
execute "inoremap <silent>" . g:projector_compile_shortcut . " <C-O>:call projector#Compile()<cr>"
execute "nnoremap <silent>" . g:projector_debug_shortcut . " :call projector#Debug()<cr>"
execute "inoremap <silent>" . g:projector_debug_shortcut . " <C-O>:call projector#Debug()<cr>"
execute "nnoremap <silent>" . g:projector_custom1_shortcut . " :call projector#Custom1()<cr>"
execute "inoremap <silent>" . g:projector_custom1_shortcut . " <C-O>:call projector#Custom1()<cr>"
execute "nnoremap <silent>" . g:projector_custom2_shortcut . " :call projector#Custom2()<cr>"
execute "inoremap <silent>" . g:projector_custom2_shortcut . " <C-O>:call projector#Custom2()<cr>"
execute "nnoremap <silent>" . g:projector_custom3_shortcut . " :call projector#Custom3()<cr>"
execute "inoremap <silent>" . g:projector_custom3_shortcut . " <C-O>:call projector#Custom3()<cr>"

autocmd BufEnter,WinEnter,VimEnter,BufReadPre,BufNewFile * call projector#Init() 

command! -nargs=0 CreateProjector call projector#CreateProjector()
command! -nargs=0 CreateProjectorFile call projector#CreateProjectorFile()
command! -nargs=0 EditProjector call projector#EditProjector()
command! -nargs=0 ReloadProjector call projector#Reload()
command! -nargs=0 ListProjectorFiles call projector#ListProjectorFiles()
