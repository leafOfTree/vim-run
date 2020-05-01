# vim-run

<p align="center">
<img alt="screenshot" src="https://raw.githubusercontent.com/leafOfTree/leafOfTree.github.io/master/screenshot-run-c.png" width="200" />
<img alt="screenshot" src="https://raw.githubusercontent.com/leafOfTree/leafOfTree.github.io/master/screenshot-run-javascript.png" width="176" />
</p>

Run any file and show output inside vim.

## Usage

With config

```vim

let g:run_cmd = {
      \'c':           'gcc -Wall -Wextra -std=c99 -pedantic',
      \'c_plus':      './a.out',
      \'python':      'python',
      \'javascript':  'node',
      \'tsx':         'tsc --outFile %t %',
      \'tsx_plus':    'node %t',
      \'vim':         'source',  
      \}
```

Open a `tmp.c` or `tmp.py` file and Press <kbd>go</kbd> in NORMAL mode. Vim will run the file and split a window that displays the output.

## Installation

<details>
<summary><a>How to install</a></summary>

- [VundleVim][1]

        Plugin 'leafOfTree/vim-run'

- [vim-pathogen][2]

        cd ~/.vim/bundle && \
        git clone https://github.com/leafOfTree/vim-run --depth 1

- [vim-plug][3]

        Plug 'leafOfTree/vim-run'
        :PlugInstall

- Or manually, clone this plugin to `path/to/this_plugin`, and add it to `rtp` in vimrc

        set rtp+=path/to/this_plugin

<br />
</details>

Please stay up to date. Feel free to open an issue or a pull request.

## Configuration

#### `g:run_cmd`: `{ key: <filetype[_plus]>, value: <cmd> }`

- description:

    Specifies `<cmd>` to run for `<filetype>`. Filename will be appended to the `<cmd>`. 

    | Special chars | Replacement                 |
    |---------------|-----------------------------|
    | %             | Filename                    |
    | %:r           | Filename without extennsion |
    | %t            | Temp filename               |

    If there are special chars in `<cmd>`, they are replaced. Meanwhile filename won't be appended to the `<cmd>`.

    Optional: specifies `<cmd>` to run for `<filetype_plus>` after the previous one. Useful if the previous `<cmd>` only compiles file, for example.

- type: `Dictionary`
- default: `Undefined`
- example: 

    ```vim
    let markdown_to_html = 'pandoc 
          \ --metadata title="%" 
          \ -c http://cdn.bootcss.com/bootstrap/3.3.5/css/bootstrap.min.css 
          \ -s % -o %:r.html'

    let g:run_cmd = {
          \'c':             'gcc -Wall -Wextra -std=c99 -pedantic',
          \'c_plus':        './a.out',
          \'cpp':           'g++ -Wall -Wextra -pedantic',
          \'javascript':    'node',
          \'python':        'python',
          \'markdown':      markdown_to_html,
          \'markdown_plus': 'open %:r.html',
          \}
    ```

#### `g:run_mapping`

- description: key mapping to run the current file.
- default: `'go'`
- example: 
    
    ```vim
    let g:run_mapping = '<F5>'
    ```

#### `g:run_output_focus`

- description: focus the output window. 
- default: `0`. It can be `0` or `1`.

#### `g:run_output_scroll_bottom`

- description: let the output window scroll to bottom.
- default: `0`. It can be `0` or `1`.

#### `g:run_debug = 0`

- description: show the debug messages.
- default: `0`. It can be `0` or `1`.

## Custom output syntax highlighting

You can add `syntax/run-<filetype>.vim` to custom `<filetype>` output's syntax highlighting. Examples are `syntax/run-go.vim`, `syntax/run-c.vim`, ...

[1]: https://github.com/VundleVim/Vundle.vim
[2]: https://github.com/tpope/vim-pathogen
[3]: https://github.com/junegunn/vim-plug
