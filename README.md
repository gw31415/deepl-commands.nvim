# deepl-commands.nvim
Related commands for [gw31415/deepl.vim](https://github.com/gw31415/deepl.vim).

## Installation and setup
This plugin requires [gw31415/deepl.vim](https://github.com/gw31415/deepl.vim).

[packer.nvim](wbthomason/packer.nvim)
```lua
use {
	'gw31415/deepl-commands.nvim',
	requires = {
		'gw31415/deepl.vim',
		'gw31415/fzyselect.vim', -- Optional
	},
	config = function()
		require 'deepl-commmands'.setup {
			selector_func = require 'fzyselect'.start, -- Default value is `vim.ui.select`
			default_target = 'JA', -- Default value is 'EN'
		}
	end
}
```

### Commands

### `:DeepL`
translates the selected lines and adds the translation just below the
selection. If the command called with a exclamation mark ( `:{range}DeepL!` ),
the lines will be replaced with the translation.

### `:DeepLTarget`
Sets the language to which the `:DeepL` command will be translated.
