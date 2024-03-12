
A simple plugin for listing and running makefile targets. It searches for a 
makefile inside your current working directory and displays them using 
[telescope.nvim](https://github.com/nvim-telescope/telescope.nvim).

## Installation

With Lazy:

```lua
{
    "elias-gill/makeman",
    dependencies = { "nvim-telescope/telescope.nvim" }
}
```

## Usage

Just run:

```lua 
require("makeman").run()
```

## TODO

- Search inside the LSP cwd if a Makefile cannot be found inside Neovim's cwd.


`Note`: This plugin is intended for personal use, but feel free to send suggestions or PRs.
