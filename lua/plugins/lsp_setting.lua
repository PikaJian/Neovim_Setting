local M = {}

function M.switch_source_header()
	local bufnr = 0
	local params = { uri = vim.uri_from_bufnr(bufnr) }

	for _, client in ipairs(vim.lsp.get_active_clients({ bufnr = bufnr })) do
		if client.name == "clangd" then
			client.request("textDocument/switchSourceHeader", params, function(err, result)
				if err then
					error(tostring(err))
				end
				if not result then
					print("Corresponding file cannot be determined")
					return
				end
				-- vim.api.nvim_command("Tabdrop " .. vim.uri_to_fname(result))
				vim.api.nvim_command('edit ' .. vim.uri_to_fname(result))
			end)
			return
		end
	end
	local file = vim.fn.expand("%:p:t")
	if vim.endswith(file, ".h") then
		file = vim.fn.expand("%:p:t:r") .. ".c"
	else
		file = vim.fn.expand("%:p:t:r") .. ".h"
	end
	vim.api.nvim_command('edit ' .. vim.uri_to_fname(file))
	-- require("fuzzy_menu").oldfiles({ default_text = file })
end

return M
