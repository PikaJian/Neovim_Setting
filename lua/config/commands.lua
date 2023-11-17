--  lsp
vim.api.nvim_create_user_command("SwitchHeader", function()
	local switch_header = require("plugins.lsp_setting").switch_source_header()
	if switch_header ~= nil then
		switch_header()
	end
end, {})
