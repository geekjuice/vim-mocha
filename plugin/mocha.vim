" Get file path
let s:plugin_path = expand("<sfile>:p:h:h")

" Set Javascript
function! s:SetJavascriptCommand()
  if !exists("g:mocha_js_command")
    let s:cmd = "mocha {spec}"
    call s:GUIRunning()
  else
    let g:spec_command = g:mocha_js_command
  endif
endfunction

" Set Coffeescript
function! s:SetCoffeescriptCommand()
  if !exists("g:mocha_coffee_command")
    let s:cmd = "mocha --compilers 'coffee:coffee-script/register' {spec}"
    call s:GUIRunning()
  else
    let g:spec_command = g:mocha_coffee_command
  endif
endfunction

" Run GUI version or Terminal version
function! s:GUIRunning()
  if has("gui_running") && has("gui_macvim")
    let g:spec_command = "silent !" . s:plugin_path . "/bin/run_in_os_x_terminal '" . s:cmd . "'"
  else
    let g:spec_command = "!echo " . s:cmd . " && " . s:cmd
  endif
endfunction

" Initial Spec Command
function! s:SetInitialSpecCommand()
  let l:spec = s:plugin_path . "/bin/major_filetype"
  let l:filetype = system(l:spec)
  if l:filetype =~ 'js'
    call s:SetJavascriptCommand()
  elseif l:filetype =~ 'coffee'
    call s:SetCoffeescriptCommand()
  else
    let g:spec_command = ""
  endif
endfunction

" Determine which command based on filetype
function! s:GetCorrectCommand()
  " Set default {mocha} command (javascript)
  if &filetype ==? 'javascript'
    call s:SetJavascriptCommand()
  " Set default {mocha} command (coffeescript)
  elseif &filetype ==? 'coffee'
    call s:SetCoffeescriptCommand()
  " Fallthrough default
  else
    call s:SetInitialSpecCommand()
  endif
endfunction

" Mocha Nearest Test
function! s:GetNearestTest()
  let callLine = line (".")           "cursor line
  let file = readfile(expand("%:p"))  "read current file
  let lineCount = 0                   "file line counter
  let lineDiff = 999                  "arbituary large number
  let descPattern = '\v<(it|describe|context)\s*\(?\s*[''"](.*)[''"]\s*,\s*(function|-\>)'
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

" All Specs
function! RunAllSpecs()
  if isdirectory('test')
    let l:spec = "test"
  elseif isdirectory('spec')
    let l:spec = "spec"
  else
    let l:spec = ""
  endif
  call SetLastSpecCommand(l:spec)
  call RunSpecs(l:spec)
endfunction

" Current File
function! RunCurrentSpecFile()
  if InSpecFile()
    let l:spec = @%
    call SetLastSpecCommand(l:spec)
    call RunSpecs(l:spec)
  else
    call RunLastSpec()
  endif
endfunction

" Nearest Spec
function! RunNearestSpec()
  if InSpecFile()
    call s:GetNearestTest()
    let l:spec = @% . " -g '" . s:nearestTest . "'"
    call SetLastSpecCommand(l:spec)
    call RunSpecs(l:spec)
  else
    call RunLastSpec()
  endif
endfunction

" Last Spec
function! RunLastSpec()
  if exists("s:last_spec_command")
    call RunSpecs(s:last_spec_command)
  endif
endfunction

" Current Spec File Name
function! InSpecFile()
  " Not a js or coffee file
  if match(expand('%'), '\v(.js|.coffee)$') == -1
    return 0
  endif

  " Check for describe block
  let l:contents = join(getline(1,'$'), "\n")
  let l:jsRegex = '\v<describe(.\w+)?\s{-}\(.{-}[''"].{-}[''"]\s{-}, {-}function\s{-}\(.{-}\)'
  let l:coffeeRegex = '\v<describe\s+[''"].{-}[''"]\s{-},\s+-\>'
  return match(l:contents, l:coffeeRegex) != -1 || match(l:contents, l:jsRegex) != -1
endfunction

" Cache Last Spec Command
function! SetLastSpecCommand(spec)
  let s:last_spec_command = a:spec
endfunction

" Spec Runner
function! RunSpecs(spec)
  call s:GetCorrectCommand()
  if g:spec_command ==? ""
    echom "No spec command specified."
  else
    execute substitute(g:spec_command, "{spec}", a:spec, "g")
  end
endfunction

