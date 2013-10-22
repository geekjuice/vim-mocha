let s:plugin_path = expand("<sfile>:p:h:h")

if !exists("g:mocha_command")
  let s:cmd = "@NODE_ENV=test mocha -b --compilers coffee:coffee-script --reporter spec --recursive {spec}"

  if has("gui_running") && has("gui_macvim")
    let g:rspec_command = "silent !" . s:plugin_path . "/bin/run_in_os_x_terminal '" . s:cmd . "'"
  else
    let g:rspec_command = "!echo " . s:cmd . " && " . s:cmd
  endif
endif

function! mocha#RunAllSpecs()
  let l:spec = "test" "allow user to define
  call mocha#SetLastSpecCommand(l:spec)
  call mocha#RunSpecs(l:spec)
endfunction

function! mocha#RunCurrentSpecFile()
  if mocha#InSpecFile()
    let l:spec = @%
    call mocha#SetLastSpecCommand(l:spec)
    call mocha#RunSpecs(l:spec)
  else
    call mocha#RunLastSpec()
  endif
endfunction

" Need to use grep
function! mocha#RunNearestSpec()
  let callLine = line (".")
  let file = readfile(expand("%:p")) " read current file
  let descPattern='\v\_^\s*it\s*[(]*\s*[''"]{1}\zs[^''"]+\ze[''"]{1}'
  let nline=0
  let diff=999 "arbituary large number
  for line in file
    let nline=nline+1
    let match=match(line,descPattern)
    if(match != -1)
      let currentDiff=abs(callLine - nline)
      if(currentDiff <= diff)
        let diff=currentDiff
        let nearestTest = matchstr(line,descPattern)
      endif
    endif
  endfor
  if mocha#InSpecFile()
    let l:spec = @% . " -g '" . nearestTest . "'"
    echo l:spec
    call mocha#SetLastSpecCommand(l:spec)
    call mocha#RunSpecs(l:spec)
  else
    call mocha#RunLastSpec()
  endif
endfunction

function! mocha#RunLastSpec()
  if exists("s:last_spec_command")
    call mocha#RunSpecs(s:last_spec_command)
  endif
endfunction

function! mocha#InSpecFile()
  return match(expand("%"), "^test/") != -1 || match(expand("%"), "^spec/") != -1
endfunction

function! mocha#SetLastSpecCommand(spec)
  let s:last_spec_command = a:spec
endfunction

function! mocha#RunSpecs(spec)
  execute substitute(g:mocha_command, "{spec}", a:spec, "g")
endfunction
