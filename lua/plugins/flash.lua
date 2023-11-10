--[[
opts = {
	keys = {
		{
			"s",
			mode = { "n", "x", "o" },
			function()
				require("flash").jump()
			end,
			desc = "Flash",
		},
		{
			"S",
			mode = { "n", "x", "o" },
			function()
				require("flash").treesitter()
			end,
			desc = "Flash Treesitter",
		},
		{
			"r",
			mode = "o",
			function()
				require("flash").remote()
			end,
			desc = "Remote Flash",
		},
		{
			"R",
			mode = { "o", "x" },
			function()
				require("flash").treesitter_search()
			end,
			desc = "Treesitter Search",
		},
		{
			"<c-s>",
			mode = { "c" },
			function()
				require("flash").toggle()
			end,
			desc = "Toggle Flash Search",
		},
	},
}
--]]

vim.keymap.set({'n', 'x', 'o'}, 's',
			function()
				require("flash").jump()
			end
)

vim.keymap.set({'n', 'x', 'o'}, 'S',
			function()
				require("flash").treesitter()
			end
)

vim.keymap.set({'o'}, 'r',
			function()
				require("flash").remote()
			end
)

vim.keymap.set({'c', 'x'}, 'R',
			function()
				require("flash").treesitter_search()
			end
)

vim.keymap.set('c', '<c-s>',
			function()
				require("flash").toggle()
			end
)

require("flash").setup()
