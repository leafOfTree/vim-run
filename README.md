# vim-run

<p align="center">
<img alt="screenshot" src="https://raw.githubusercontent.com/leafOfTree/leafOfTree.github.io/master/screenshot-run-c.png" width="200" />
<img alt="screenshot" src="https://raw.githubusercontent.com/leafOfTree/leafOfTree.github.io/master/screenshot-run-javascript.png" width="176" />
</p>

Run any file and show output inside vim.

## Usage

With config

```vim
let g:run_mapping = 'go' " default mapping

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

Open a `tmp.c` or `tmp.py` file and Press <kbd>g</kbd><kbd>o</kbd> in NORMAL mode. Vim will run the file and split a window to display the output.

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

#### `g:run_cmd`

- `{ key: <filetype>, value: <cmd> }`
- `{ key: <filetype>_plus, value: <cmd> }`

- description:

    Set `<cmd>` for `<filetype>`. The filename is appended to the `<cmd>`. 

    - If there are special chars in `<cmd>`, they will be replaced with a proper value. Meanwhile the filename won't be appended to the `<cmd>`.

      | Special chars | Value                       |
      |---------------|-----------------------------|
      | %             | Filename                    |
      | %:r           | Filename without extension  |
      | %t            | Temp filename given by vim  |

    - Optional: set `<cmd>` for `<filetype>_plus` which runs after the previous one. Useful when the previous only compiles the file.

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
          \'vim':           'source',  
          \}
    ```

Note: you need to use `'source'` for `vim` files.

#### `g:run_mapping`

- description: key mapping to run the current file.
- default: `'go'`
- example: 
    
    ```vim
    let g:run_mapping = '<F5>'
    ```

#### `g:run_output_focus`

Focus the output window. Default: `0`. (`0` or `1`).

#### `g:run_output_scroll_bottom`

Let the output window scroll to bottom. Default: `0`. (`0` or `1`).

#### `g:run_debug`

Show debug messages. Default: `0`. (`0` or `1`).

## Custom output syntax highlighting

You can add `syntax/run-<filetype>.vim` to custom `<filetype>` output's syntax highlighting. Examples are `syntax/run-go.vim`, `syntax/run-c.vim`, ...

[1]: https://github.com/VundleVim/Vundle.vim
[2]: https://github.com/tpope/vim-pathogen
[3]: https://github.com/junegunn/vim-plug
