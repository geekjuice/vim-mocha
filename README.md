# vim-mocha

This is a lightweight Mocha runner for Vim. Extracted from
[vim-spec](https://github.com/geekjuice/vim-spec)

Based off of [Attamusc/vim-mocha](https://github.com/Attamusc/vim-mocha) and
subsequently [thoughtbot/vim-rspec](https://github.com/thoughtbot/vim-rspec).


__Use both RSpec and Mocha? Take a look at [vim-spec](https://github.com/geekjuice/vim-spec)!__


## Installation

Using [vundle](https://github.com/gmarik/vundle):

```vim
Bundle 'geekjuice/vim-mocha'
```

If using zsh on OS X it may be necessary to run move `/etc/zshenv` to `/etc/zshrc`.


Using [pathogen](https://github.com/tpope/vim-pathogen)

```sh
cd ~/.vim/bundle
git clone git://github.com/geekjuice/vim-spec.git
```


## Example of key mappings

__NOTE__: The mappings have changed and use the same mappings as vim-rspec and
vim-spec. If this is a big issue for you, open an issue and I'll re-add/add the
namespace.

```vim
map <Leader>t :call RunCurrentSpecFile()<CR>
map <Leader>s :call RunNearestSpec()<CR>
map <Leader>l :call RunLastSpec()<CR>
map <Leader>a :call RunAllSpecs()<CR>
```

## Configuration

Like [thoughtbot/vim-rspec](https://github.com/thoughtbot/vim-rspec), the
following variables can be overwritten for custom spec commands:

* `g:mocha_js_command`
* `g:mocha_coffee_command`

Examples:

```vim
let g:mocha_js_command = "!mocha --recursive --no-colors {spec}"
let g:mocha_coffee_command = "!mocha -b --compilers coffee:coffee-script{spec}"

" Using test runners
let g:mocha_coffee_command = "!cortado {spec}"
```


Note: [cortado](bin/cortado) is a sugar wrapper for a more complex `mocha` call.


## Notes
* Allow configuration for `mocha` options i.e. `--recursive`, `--reporter dot`

* __BUG__: Assertions with no name i.e. no attribute for `it` in mocha will fail
  if trying to call nearest test `RunNearestSpec` as it depends on `it` having a
  value

* __BUG__: Last nearest test fails if below `it` call


## Credits

[thoughtbot/vim-rspec](https://github.com/thoughtbot/vim-rspec)

[Attamusc/vim-mocha](https://github.com/Attamusc/vim-mocha)

## License

mocha.vim is released under the [MIT License](LICENSE).
