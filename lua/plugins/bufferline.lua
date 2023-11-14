local icons = {
	misc = {
		dots = "󰇘",
	},
	dap = {
		Stopped = { "󰁕 ", "DiagnosticWarn", "DapStoppedLine" },
		Breakpoint = " ",
		BreakpointCondition = " ",
		BreakpointRejected = { " ", "DiagnosticError" },
		LogPoint = ".>",
	},
	diagnostics = {
		Error = " ",
		Warn = " ",
		Hint = " ",
		Info = " ",
	},
	git = {
		added = " ",
		modified = " ",
		removed = " ",
	},
	kinds = {
		Array = " ",
		Boolean = "󰨙 ",
		Class = " ",
		Codeium = "󰘦 ",
		Color = " ",
		Control = " ",
		Collapsed = " ",
		Constant = "󰏿 ",
		Constructor = " ",
		Copilot = " ",
		Enum = " ",
		EnumMember = " ",
		Event = " ",
		Field = " ",
		File = " ",
		Folder = " ",
		Function = "󰊕 ",
		Interface = " ",
		Key = " ",
		Keyword = " ",
		Method = "󰊕 ",
		Module = " ",
		Namespace = "󰦮 ",
		Null = " ",
		Number = "󰎠 ",
		Object = " ",
		Operator = " ",
		Package = " ",
		Property = " ",
		Reference = " ",
		Snippet = " ",
		String = " ",
		Struct = "󰆼 ",
		TabNine = "󰏚 ",
		Text = " ",
		TypeParameter = " ",
		Unit = " ",
		Value = " ",
		Variable = "󰀫 ",
	},
}

require("bufferline").setup({
	options = {
		separator_style = "thin",
		diagnostics = "nvim_lsp",
		diagnostics_indicator = function(_, _, diag)
			local ret = (diag.error and icons.diagnostics.Error .. diag.error .. " " or "")
				.. (diag.warning and icons.diagnostics.Warn .. diag.warning or "")
			return vim.trim(ret)
		end,
		--[[diagnostics_indicator = function(count, level, diagnostics_dict, context)
             local icon = level:match("error") and " " or " "
             return " " .. icon .. count
         end,]]
	},
})

vim.api.nvim_create_autocmd("BufAdd", {
	callback = function()
		vim.schedule(function()
			pcall(nvim_bufferline)
		end)
	end,
})

vim.keymap.set("n", "]b", ":BufferLineCycleNext<CR>", { silent = true, noremap = true })
vim.keymap.set("n", "[b", ":BufferLineCyclePrev<CR>", { silent = true, noremap = true })
