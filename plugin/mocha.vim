let s:plugin_path = expand("<sfile>:p:h:h")

if !exists("g:mocha_command")
  let s:cmd = "mocha {spec}"

  if has("gui_running") && has("gui_macvim")
    let g:mocha_command = "silent !" . s:plugin_path . "/bin/run_in_os_x_terminal '" . s:cmd . "'"
  else
    let g:mocha_command = "!echo " . s:cmd . " && " . s:cmd
  endif
endif

function! mocha#RunAllSpecs()
  if isdirectory('spec')
    let l:spec = "spec"
  else
    let l:spec = "test"
  endif

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

function! mocha#RunNearestSpec()
  if mocha#InSpecFile()
    call mocha#GetNearestTest()
    let l:spec = @% . " -g '" . s:nearestTest . "'"
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
  return match(expand("%"),'\v.(js|coffee)$') != -1
endfunction

function! mocha#SetLastSpecCommand(spec)
  let s:last_spec_command = a:spec
endfunction

function! mocha#GetNearestTest()
  let callLine = line (".")           "cursor line
  let file = readfile(expand("%:p"))  "read current file
  let lineCount = 0                   "file line counter
  let lineDiff = 999                  "arbituary large number
  let descPattern='\v\s*it\s*[(]?\s*([''"]{1})(.+)\1{1}'
  for line in file
    let lineCount += 1
    let match = match(line,descPattern)
    if(match != -1)
      let currentDiff = callLine - lineCount
      " break if closest test is the next test
      if(currentDiff < 0 && lineDiff != 999)
        break
      endif
      " if closer test is found, cache new nearest test
      if(currentDiff <= lineDiff)
        let lineDiff = currentDiff
        let s:nearestTest = substitute(matchlist(line,descPattern)[2],'\v([''"()])','(.{1})','g')
      endif
    endif
  endfor
endfunction

function! mocha#RunSpecs(spec)
  execute substitute(g:mocha_command, "{spec}", a:spec, "g")
endfunction
