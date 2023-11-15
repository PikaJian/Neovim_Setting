local opts = {
	theme = "doom",
	hide = {
		-- this is taken care of by lualine
		-- enabling this messes up the actual laststatus setting after loading a file
		statusline = false,
	},
}

require("dashboard").setup({
    opts
	-- config
})
