# mvc.nvim
## A plugin for flying inside a .NET MVC project

# Features
- Switch between controller and views
- Determines the view name using *Tree-Sitter*
- Creates the controller dir and file if doesn't exists

# Installation:
Requires:
- Neovim 5+
- Tree-Sitter
- Plenary
# Using packer.nvim
```lua
use {
  'wexouv/mvc.nvim',
   requires = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter'
   }
}
```
# Usage:
Switch between Controllers and views ```require 'mvc'.Toggle()```

# TODO:
- Default keybinds
