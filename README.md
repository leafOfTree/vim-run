# vim-run

<p align="center">
<img alt="screenshot" src="https://raw.githubusercontent.com/leafOfTree/leafOfTree.github.io/master/screenshot-run-c.png" height="300" />
<img alt="screenshot" src="https://raw.githubusercontent.com/leafOfTree/leafOfTree.github.io/master/screenshot-run-javascript.png" height="300" />
</p>

Run any file and show output inside vim.

## Usage

With setting

```vim
let g:run_cmd_c = 'clang'
let g:run_output_cmd_c = './a.out'
```

Open a `tmp.c` file and Press <kbd>go</kbd> in NORMAL mode. Vim will run the file and split a window that displays output.

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

#### `g:run_cmd_<filetype>`

- description: cmd to run file and generate output. File name will be appended to it.
- default: `''`
- example: 

    ```vim
    let g:run_cmd_javascript = 'node'
    ```

#### `g:run_output_cmd_<filetype>`

- description: cmd to generate output. It's optional. It's useful if previous cmd only compiles file, for example.
- default: `''`
- example: 

    ```vim
    let g:run_cmd_c = 'clang'
    let g:run_output_cmd_c = './a.out'
    ```

#### `g:run_mapping`

- description: custom run file mapping.
- default: `'go'`
- example: 
    
    ```vim
    let g:run_mapping = '<F5>'
    ```

[1]: https://github.com/VundleVim/Vundle.vim
[2]: https://github.com/tpope/vim-pathogen
[3]: https://github.com/junegunn/vim-plug
