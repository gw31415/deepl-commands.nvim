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

local function setup_authkey(path)
	---@diagnostic disable: param-type-mismatch
	path = vim.fn.expand(path, nil, nil)
	local key
	if vim.fn.filereadable(path) == 1 then
		key = vim.fn.trim(vim.fn.readfile(path, nil, 1)[1])
	else
		key = vim.fn.input('`g:deepl_authkey`: ')
		if key == '' then
			return false
		end
		vim.fn.writefile({ key }, path)
		vim.fn.system({ 'chmod', '600', path })
		vim.notify(vim.fn.printf(
			'Successfully saved g:deepl_authkey at `%s`.', path),
			vim.log.levels.INFO, {
			title = 'DeepL.vim'
		})
	end
	vim.api.nvim_set_var('deepl_authkey', key)
	return true
end

return {
	target_langs = targets,
	setup = function(opts)
		local selector_func = opts.selector_func or vim.ui.select
		local default_target = opts.default_target or 'EN'
		local deepl_keyfile = opts.deepl_keyfile or '~/.ssh/deepl_authkey.txt'
		vim.api.nvim_set_var('deepl_target_lang', default_target)
		vim.api.nvim_create_user_command('DeepLTarget', function()
			local fzys_id = vim.api.nvim_create_autocmd('FileType', {
				pattern = 'fzyselect',
				callback = function()
					vim.fn.matchadd('Constant', [[\v^\zs.+\ze\|]])
					vim.fn.matchadd('NonText', [[\v^.+\zs\|\ze]])
				end
			})
			selector_func(targets, {
				format_item = function(key_value)
					return ('%5s | %s'):format(key_value[1], key_value[2])
				end,
				prompt = 'select DeepL target language'
			}, function(key_value)
				if key_value ~= nil then
					local target = key_value[1]
					vim.api.nvim_set_var('deepl_target_lang', target)
					vim.notify(
						('`g:deepl_target_lang` is now set to "%s".'):format(target),
						vim.log.levels.INFO, { title = 'DeepL.vim' })
				end
			end)
			vim.api.nvim_del_autocmd(fzys_id)
		end, {})
		vim.api.nvim_create_user_command('DeepL', function(cx)
			if (vim.g.deepl_authkey or '') == ''
				and not setup_authkey(deepl_keyfile) then
				return
			end
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
	end
}
