<h1 align="center">📋 termbufm</h1>
<p align="center">A lightweight terminal buffer manager for Neovim.</p>

A wrapper around the Neovim terminal window, with functionality for toggling and auto-compiling and running code.

A simple install using a plugin manager, in this case [vim-plug](https://github.com/junegunn/vim-plug):

```vim
Plug 'mizlan/termbufm'
```

## Follow these steps to configure:

### Set preferred direction:

```vim
" if you prefer it opening in a left-right split:
let g:termbufm_direction_cmd = 'vnew'

" if you prefer it opening in a top-down split:
let g:termbufm_direction_cmd = 'new'
```

### Load default keymaps:

```vim
" init.vim

" DEFAULTS:
" <leader>tb to build
" <leader>tr to run
" <leader>t<space> to toggle window
call termbufm#load_keymaps()
```

### Define Vim commands for terminal commands:

```vim
command! TBuild call TermBufMExecCodeScript(&filetype, 'build')
command! TRun call TermBufMExecCodeScript(&filetype, 'run')
```

### Create keybinds:
```vim
nnoremap <silent> <leader>b :TBuild<CR>
nnoremap <silent> <leader>r :TRun<CR>

" toggle the window (show/hide)
nnoremap <silent> <leader><space> :call TermBufMToggle()<CR>
```

### Load auxiliary keymap:

```vim
" will enable using <Esc> in terminal
call termbufm#load_terminal_keymaps()
```

### Edit language configurations:

Add languages to the dictionary, determined by `filetype` and provide a `build`
and `run` command. The first element of the list (if any) is a `printf` style
string. Read `:h printf()` for information on how to format this.  Any other
elements will be expanded through `expand()` (read `:h expand()`) and passed in
as arguments, along with the format string, to `printf()`.

For your convenience, some common options for the `expand()` command are here:
| Type | Value |
| :--- | :--- |
| filename | `test.cpp` |
| `%` | `test.cpp` |
| `%:r` | `test` |
| `%:e` | `cpp` |
| `%:p` | `/home/ml/code/test.cpp` |

For example, for `cpp` filetypes, `'g++ -std=c++11 %s'` is the format string, and `'%'` means the filename.

```vim
" the default configuration
let g:termbufm_code_scripts = {
      \ 'python': { 'build': [''],                       'run': ['cat input | python %s', '%'] },
      \ 'cpp':    { 'build': ['g++ -std=c++11 %s', '%'], 'run': ['cat input | ./a.out'] },
      \ 'java':   { 'build': ['javac %s', '%'],          'run': ['cat input | java %s', '%:r'] },
      \ 'c':      { 'build': ['gcc %s', '%'],            'run': ['cat input | ./a.out'] },
      \ }
```

#### Note for Windows users:

Set the shell to PowerShell in windows along with some additional necessary options:

```vim
" inside init.vim

set shell=powershell
set shellcmdflag=-c
set shellquote=\"
set shellxquote=
```
