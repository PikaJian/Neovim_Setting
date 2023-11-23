require("bufferline").setup({
	options = {
		separator_style = "thin",
        diagnostics = "nvim_lsp",
        diagnostics_indicator = function(_, _, diag)
            local diagnostics = require("utils.ui").icons.diagnostics
            local ret = (diag.error and diagnostics.Error .. diag.error .. " " or "")
                .. (diag.warning and diagnostics.Warn .. diag.warning or "")
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
