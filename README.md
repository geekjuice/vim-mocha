# mocha.vim

This is a lightweight Mocha runner for Vim.

Based off of [Attamusc/vim-mocha](https://github.com/Attamusc/vim-mocha) and
subsequently [thoughtbot/vim-rspec](https://github.com/thoughtbot/vim-rspec).

## Installation

Recommended installation with [vundle](https://github.com/gmarik/vundle):

```vim
Bundle 'geekjuice/vim-mocha'
```

If using zsh on OS X it may be necessary to run move `/etc/zshenv` to `/etc/zshrc`.

## Example of key mappings

```vim
" Mocha.vim mappings
map <Leader>t :call mocha#RunCurrentSpecFile()<CR>
map <Leader>s :call mocha#RunNearestSpec()<CR>
map <Leader>l :call mocha#RunLastSpec()<CR>
map <Leader>a :call mocha#RunAllSpecs()<CR>
```

## Configuration

Overwrite `g:mocha_command` variable to execute a custom command.

Example:

```vim
let g:mocha_command = "!mocha -b --compilers coffee:coffee-script{spec}"
```

This `g:mocha_command` variable can be used with your own custom calls. For
example, using the [cortado](bin/cortado) function provided in [bin](bin)

```vim
let g:mocha_command = "!cortado {spec}"
```

Note: [cortado](bin/cortado) is a sugar wrapper for a more complex `mocha` call.

## Work-in-Progress
- Refactor `RunNearestSpec`
- Allow configuration for `mocha` options i.e. `--recursive`, `--reporter dot`
- Add exceptino for inside describe of another test (RunNearestSpec)

Credits
-------

[thoughtbot/vim-rspec](https://github.com/thoughtbot/vim-rspec)

[Attamusc/vim-mocha](https://github.com/Attamusc/vim-mocha)

## License

mocha.vim is released under the [MIT License](LICENSE).
