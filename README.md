# deepl-commands.nvim
Provides translation commands using [DeepL API](https://www.deepl.com/en/docs-api/).

https://user-images.githubusercontent.com/24710985/189486267-4e441aec-1fe3-4dfd-85a5-b42deb7470fd.mp4

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

## Commands

When connecting to the DeepL API using the following commands, you will be
asked for your Auth Key if `g:deepl_authkey` is not set. This value is stored
in the file `opts.deepl_keyfile` and will be loaded automatically the next time
it is started.

### `:DeepL`
translates the selected lines and adds the translation just below the
selection. If the command called with a exclamation mark ( `:{range}DeepL!` ),
the lines will be replaced with the translation.

### `:DeepLTarget`
Sets the language to which the `:DeepL` command will be translated.

## Related Projects
- [deepl.vim](https://github.com/gw31415/deepl.vim): Add Vim function to wrap the DeepL API.
- [fzyselect.vim](https://github.com/gw31415/fzyselect.vim): The fuzzy selector seen in the top video.
- [nvim-notify](https://github.com/rcarriga/nvim-notify): The `vim.notify` function seen in the top video. 
