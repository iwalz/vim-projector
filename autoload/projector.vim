if exists("g:projector_loaded")
	finish
endif

let g:projector_loaded = 1
let s:projector_filename = ".projector"
let t:projector_configfiles = []
let t:commands = { }

" Initialize projector, check files starting from 
" the directory of the current file and up
" {{{
function! projector#Init()
	if !exists("t:commands")
		let t:commands = { }
	endif

	if !exists("t:projector_configfiles") 
		let t:projector_configfiles = [ ]
	endif
	if !has_key(t:commands, expand("%:p")) && expand("%:p") != ""
		let t:commands[expand("%:p")] = { 
					\'compile': { 'cmd': '', 'path': '', 'config': '' }, 
					\'debug': { 'cmd': '', 'path': '', 'config': '' }, 
					\'run': { 'cmd': '', 'path': '', 'config': '' }, 
					\'custom1': { 'cmd': '', 'path': '', 'config': '' }, 
					\'custom2': { 'cmd': '', 'path': '', 'config': '' }, 
					\'custom3': { 'cmd': '', 'path': '', 'config': '' } 
					\}
		let path = expand('%:p:h')
		let filename = path.'/'.s:projector_filename
		let parentdirs = split(path, "/")
		let index = 0
	
		while index <= len(parentdirs)
			let dir = ""
			let index += 1
			for keys in range(0, len(parentdirs)-index) 
				let dir = dir . "/" . parentdirs[keys]
			endfor
			call projector#AddConfigFile(dir . "/" . s:projector_filename)
			if dir == expand("%:p:h")
				call projector#AddConfigFile(dir . "/" . s:projector_filename . "_" . expand("%:t"))
			endif
		endwhile

		call projector#LoadConfig()
	endif
endfunction
" }}}

" Reloads the current config
" {{{
function! projector#Reload()
	unlet t:commands
	let t:commands = { }
	call projector#Init()
endfunction
" }}}

" Add a config file if exists
" {{{
function! projector#AddConfigFile(filename)
	if filereadable(a:filename)
		if index(t:projector_configfiles, a:filename) == -1
			call add(t:projector_configfiles, a:filename)
		endif
	endif
endfunction
" }}}

" Loads the configs into memory
" {{{
function! projector#LoadConfig()
	" Go through all files
	for file in t:projector_configfiles
		for line in readfile(file, '', 10)
			" Assign if path is longer and key matches
			if line =~ 'COMPILE=' && ( 
						\strlen(t:commands[expand("%:p")].compile.path) < strlen(fnamemodify(file, ":p:h")) || 
						\strlen(t:commands[expand("%:p")].compile.config) < strlen(fnamemodify(file, ":t")) )
				let t:commands[expand("%:p")].compile.cmd = substitute(line, "COMPILE=", "", "")
				let t:commands[expand("%:p")].compile.path = fnamemodify(file, ":p:h")
				let t:commands[expand("%:p")].compile.config = fnamemodify(file, ":t")
			elseif line =~ 'DEBUG=' && (
						\strlen(t:commands[expand("%:p")].debug.path) < strlen(fnamemodify(file, ":p:h")) || 
						\strlen(t:commands[expand("%:p")].debug.config) < strlen(fnamemodify(file, ":t")) )
				let t:commands[expand("%:p")].debug.cmd = substitute(line, "DEBUG=", "", "")
				let t:commands[expand("%:p")].debug.path = fnamemodify(file, ":p:h")
				let t:commands[expand("%:p")].debug.config = fnamemodify(file, ":t")
			elseif line =~ 'RUN=' && (
						\strlen(t:commands[expand("%:p")].run.path) < strlen(fnamemodify(file, ":p:h")) || 
						\strlen(t:commands[expand("%:p")].run.config) < strlen(fnamemodify(file, ":t")) )
				let t:commands[expand("%:p")].run.cmd = substitute(line, "RUN=", "", "")
				let t:commands[expand("%:p")].run.path = fnamemodify(file, ":p:h")
				let t:commands[expand("%:p")].run.config = fnamemodify(file, ":t")
			elseif line =~ 'CUSTOM1=' && (
						\strlen(t:commands[expand("%:p")].custom1.path) < strlen(fnamemodify(file, ":p:h")) || 
						\strlen(t:commands[expand("%:p")].custom1.config) < strlen(fnamemodify(file, ":t")) )
				let t:commands[expand("%:p")].custom1.cmd = substitute(line, "CUSTOM1=", "", "")
				let t:commands[expand("%:p")].custom1.path = fnamemodify(file, ":p:h")
				let t:commands[expand("%:p")].custom1.config = fnamemodify(file, ":t")
			elseif line =~ 'CUSTOM2=' && (
						\strlen(t:commands[expand("%:p")].custom2.path) < strlen(fnamemodify(file, ":p:h")) || 
						\strlen(t:commands[expand("%:p")].custom2.config) < strlen(fnamemodify(file, ":t")) )
				let t:commands[expand("%:p")].custom2.cmd = substitute(line, "CUSTOM2=", "", "")
				let t:commands[expand("%:p")].custom2.path = fnamemodify(file, ":p:h")
				let t:commands[expand("%:p")].custom2.config = fnamemodify(file, ":t")
			elseif line =~ 'CUSTOM3=' && (
						\strlen(t:commands[expand("%:p")].custom3.path) < strlen(fnamemodify(file, ":p:h")) || 
						\strlen(t:commands[expand("%:p")].custom3.config) < strlen(fnamemodify(file, ":t")) )
				let t:commands[expand("%:p")].custom3.cmd = substitute(line, "CUSTOM3=", "", "")
				let t:commands[expand("%:p")].custom3.path = fnamemodify(file, ":p:h")
				let t:commands[expand("%:p")].custom3.config = fnamemodify(file, ":t")
			endif
		endfor
	endfor
endfunction
" }}}

" Create projector file in current directory
" {{{
function! projector#CreateProjector()
	let file = expand("%:p:h") . "/" . s:projector_filename
	silent! execute "tabnew " . file
	silent! execute "normal! iCOMPILE=\<CR>"
	silent! execute "normal! iRUN=\<CR>"
	silent! execute "normal! iDEBUG=\<CR>"
	silent! execute "normal! iCUSTOM1=\<CR>"
	silent! execute "normal! iCUSTOM2=\<CR>"
	silent! execute "normal! iCUSTOM3="
endfunction
" }}}

" Create projector file for the current file
" {{{
function! projector#CreateProjectorFile()
	let file = expand("%:p:h") . "/" . s:projector_filename . "_" . expand("%:t")
	silent! execute "tabnew " . file
	silent! execute "normal! iCOMPILE=\<CR>"
	silent! execute "normal! iRUN=\<CR>"
	silent! execute "normal! iDEBUG=\<CR>"
	silent! execute "normal! iCUSTOM1=\<CR>"
	silent! execute "normal! iCUSTOM2=\<CR>"
	silent! execute "normal! iCUSTOM3="
endfunction
" }}}

" List projector config files
" {{{
function! projector#ListProjectorFiles()
	for file in t:projector_configfiles
		echom file
	endfor
endfunction
" }}}

" Edit the projector file
" {{{
function! projector#EditProjector()
	let priofile = ""
	let length = -1
	for file in t:projector_configfiles
		if strlen(file) > length
			let priofile = file
			let length = strlen(file)
		endif
	endfor
	if priofile != ""
		silent! execute "tabnew " . priofile
	endif
endfunction
" }}}

" Execute the debug section
" {{{
function! projector#Debug()
	if !has_key(t:commands, expand("%:p"))
		call projector#Init()
	endif
	if has_key(t:commands, expand("%:p"))
		let prevdir = getcwd()
		silent! cd t:commands[expand("%:p")].debug.path
		silent !clear
		execute "!" . t:commands[expand("%:p")].debug.cmd
		silent! cd prevdir
	endif
endfunction
" }}}

" Execute the run section
" {{{
function! projector#Run()
	if !has_key(t:commands, expand("%:p"))
		call projector#Init()
	endif
	if has_key(t:commands, expand("%:p"))
		let prevdir = getcwd()
		silent! cd t:commands[expand("%:p")].run.path
		silent !clear
		execute "!" . t:commands[expand("%:p")].run.cmd
		silent! cd prevdir
	endif
endfunction
" }}}

" Execute the compile section
" {{{
function! projector#Compile()
	if !has_key(t:commands, expand("%:p"))
		call projector#Init()
	endif
	if has_key(t:commands, expand("%:p"))
		let prevdir = getcwd()
		silent! cd t:commands[expand("%:p")].compile.path
		silent !clear
		execute "!" . t:commands[expand("%:p")].compile.cmd
		silent! cd prevdir
	endif
endfunction
" }}}

" Execute the custom1 section
" {{{
function! projector#Custom1()
	if !has_key(t:commands, expand("%:p"))
		call projector#Init()
	endif
	if has_key(t:commands, expand("%:p"))
		let prevdir = getcwd()
		silent! cd t:commands[expand("%:p")].custom1.path
		silent !clear
		execute "!" . t:commands[expand("%:p")].custom1.cmd
		silent! cd prevdir
	endif
endfunction
" }}}

" Execute the custom2 section
" {{{
function! projector#Custom2()
	if !has_key(t:commands, expand("%:p"))
		call projector#Init()
	endif
	if has_key(t:commands, expand("%:p"))
		let prevdir = getcwd()
		silent! cd t:commands[expand("%:p")].custom2.path
		silent !clear
		execute "!" . t:commands[expand("%:p")].custom2.cmd
		silent! cd prevdir
	endif
endfunction
" }}}

" Execute the custom3 section
" {{{
function! projector#Custom3()
	if !has_key(t:commands, expand("%:p"))
		call projector#Init()
	endif
	if has_key(t:commands, expand("%:p"))
		let prevdir = getcwd()
		silent! cd t:commands[expand("%:p")].custom3.path
		silent !clear
		execute "!" . t:commands[expand("%:p")].custom3.cmd
		silent! cd prevdir
	endif
endfunction
" }}}
