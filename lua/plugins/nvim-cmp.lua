local lspkind = require("lspkind")
local cmp = require("cmp")

cmp.setup({
	-- 指定 snippet 引擎
	snippet = {
		expand = function(args)
			-- For `vsnip` users.
			-- vim.fn["vsnip#anonymous"](args.body)

			-- For `luasnip` users.
			-- require('luasnip').lsp_expand(args.body)

			-- For `ultisnips` users.
			-- vim.fn["UltiSnips#Anon"](args.body)

			-- For `snippy` users.
			-- require'snippy'.expand_snippet(args.body)
		end,
	},
	-- 来源
	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
		-- For vsnip users.
		-- { name = 'vsnip' },
		-- For luasnip users.
		-- { name = 'luasnip' },
		--For ultisnips users.
		-- { name = 'ultisnips' },
		-- -- For snippy users.
		-- { name = 'snippy' },
	}, { { name = "buffer" }, { name = "path" } }),

	-- 快捷键
	mapping = cmp.mapping.preset.insert({
		["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
		["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
		["<C-d>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert, count = 4}),
		["<C-u>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert, count = 4}),
		["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i' , 'c' }),
		["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-e>"] = cmp.mapping.abort(),
		["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
		["<S-CR>"] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Replace,
			select = true,
		}), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
		["<C-CR>"] = function(fallback)
			cmp.abort()
			fallback()
		end,
	}),
	-- 使用lspkind-nvim显示类型图标
	formatting = {
		format = lspkind.cmp_format({
			with_text = true, -- do not show text alongside icons
			maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
			before = function(entry, vim_item)
				-- Source 显示提示来源
				vim_item.menu = "[" .. string.upper(entry.source.name) .. "]"
				return vim_item
			end,
		}),
	},
})

-- Use buffer source for `/`.
cmp.setup.cmdline("/", {
	sources = {
		{ name = "buffer" },
	},
})

-- Use cmdline & path source for ':'.
cmp.setup.cmdline(":", {
	sources = cmp.config.sources(
		{
			{ name = "path" },
		} --[[,{
          { name = 'cmdline' }
        }]]
	),
})
