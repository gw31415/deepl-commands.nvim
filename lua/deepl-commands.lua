local targets = {
	{ 'BG', 'Bulgarian' },
	{ 'CS', 'Czech' },
	{ 'DA', 'Danish' },
	{ 'DE', 'German' },
	{ 'EL', 'Greek' },
	{ 'EN', 'English' },
	{ 'EN-GB', 'English (British)' },
	{ 'EN-US', 'English (American)' },
	{ 'ES', 'Spanish' },
	{ 'ET', 'Estonian' },
	{ 'FI', 'Finnish' },
	{ 'FR', 'French' },
	{ 'HU', 'Hungarian' },
	{ 'ID', 'Indonesian' },
	{ 'IT', 'Italian' },
	{ 'JA', 'Japanese' },
	{ 'LT', 'Lithuanian' },
	{ 'LV', 'Latvian' },
	{ 'NL', 'Dutch' },
	{ 'PL', 'Polish' },
	{ 'PT', 'Portuguese' },
	{ 'PT-BR', 'Portuguese (Brazilian)' },
	{ 'PT-PT', 'Portuguese (all Portuguese varieties excluding Brazilian Portuguese)' },
	{ 'RO', 'Romanian' },
	{ 'RU', 'Russian' },
	{ 'SK', 'Slovak' },
	{ 'SL', 'Slovenian' },
	{ 'SV', 'Swedish' },
	{ 'TR', 'Turkish' },
	{ 'UK', 'Ukrainian' },
	{ 'ZH', 'Chinese (simplified)' },
}

return {
	target_langs = targets,
	setup = function(opts)
		local args = {
			selector_func = opts.selector_func or vim.ui.select,
			default_target = opts.default_target or 'EN',
		}
		vim.api.nvim_set_var('deepl_target_lang', args.default_target)
		vim.api.nvim_create_user_command('DeepLTarget', function()
			local fzys_id = vim.api.nvim_create_autocmd('FileType', {
				pattern = 'fzyselect',
				once = true,
				callback = function()
					vim.fn.matchadd('Constant', [[\v^\zs.+\ze\|]])
					vim.fn.matchadd('NonText', [[\v^.+\zs\|\ze]])
				end
			})
			args.selector_func(targets, {
				format_item = function(key_value)
					return ('%5s | %s'):format(key_value[1], key_value[2])
				end,
				prompt = 'select DeepL target language'
			}, function(key_value)
				vim.api.nvim_del_autocmd(fzys_id)
				if key_value ~= nil then
					local target = key_value[1]
					vim.api.nvim_set_var('deepl_target_lang', target)
					vim.notify(
						('`g:deepl_target_lang` is now set to `%s`.'):format(target),
						vim.log.levels.INFO, { title = 'DeepL.vim' })
				end
			end)
		end, {})
		vim.api.nvim_create_user_command('DeepL', function(cx)
			local input = vim.fn.join(vim.fn.getline(cx.line1, cx.line2), "\n")
			local status, output = pcall(function()
				return vim.fn.split(vim.fn['deepl#translate'](input, vim.g.deepl_target_lang), "\n")
			end)
			if not status then
				vim.notify(output, vim.log.levels.ERROR, { title = 'DeepL.vim' })
			elseif cx.bang then
				vim.fn.setline(cx.line1, output)
			else
				vim.fn.append(cx.line2, output)
			end
		end, { bang = true, range = true })
	end,
}
