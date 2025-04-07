return {
  -- snippets
  {
    "L3MON4D3/LuaSnip",
    build = (not jit.os:find("Windows"))
        and "echo 'NOTE: jsregexp is optional, so not a big deal if it fails to build'; make install_jsregexp"
      or nil,
    dependencies = {
      "rafamadriz/friendly-snippets",
      config = function()
        require("luasnip.loaders.from_vscode").lazy_load()
      end,
    },
    config = function()
      local luasnip = require("luasnip")
      local config_dir = vim.fn.stdpath("config") .. "/lua/LuaSnip"
      -- print(config_dir)
      require("luasnip.loaders.from_lua").load({paths = config_dir})
      luasnip.filetype_set("cpp", { "c" })
    end,
    opts = {
      history = true,
      delete_check_events = "TextChanged",
    },
    -- stylua: ignore
    keys = {
      {
        "<Tab>",
        function()
          local luasnip = require("luasnip")
          if luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          else
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, false, true), "n", false)
          end
        end,
        mode = {"i"},
        silent = true,
        expr = true
      },
      { "<Tab>", function() require("luasnip").jump(1) end, mode = "s" },
      { "<s-tab>", function() require("luasnip").jump(-1) end, mode = { "i", "s" } },
    },
  },
  -- auto completion
  {
    "hrsh7th/nvim-cmp",
    version = false, -- last release is way too old
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "saadparwaiz1/cmp_luasnip",
      {
        "zbirenbaum/copilot-cmp",
        dependencies = "zbirenbaum/copilot.lua",
        opts = {},
        config = function(_, opts)
          local copilot_cmp = require("copilot_cmp")
          copilot_cmp.setup(opts)
          require("copilot_cmp").setup(opts)
          -- attach cmp source whenever copilot attaches
          -- fixes lazy-loading issues with the copilot cmp source
          require("utils").lsp.on_attach(function(client)
            if client.name == "copilot" then
              copilot_cmp._on_insert_enter({})
            end
          end)
        end,
      }
    },
    opts = function()
      vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
      local cmp = require("cmp")
      local defaults = require("cmp.config.default")()
      return {
        completion = {
          completeopt = "menu,menuone,noinsert",
        },
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<C-d>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert, count = 4}),
          ["<C-u>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert, count = 4}),
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<M-Space>"] = cmp.mapping.complete(),
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
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "path" },
          { name = "copilot", priority = 100 }
        }, {
          { name = "buffer", group_index = 2 },
        }),
        formatting = {
          format = function(_, item)
            local icons = require("utils.ui").icons.kinds
            if icons[item.kind] then
              item.kind = icons[item.kind] .. item.kind
            end
            return item
          end,
        },
        experimental = {
          ghost_text = {
            hl_group = "CmpGhostText",
          },
        },
        sorting = defaults.sorting,
      }
    end,
    ---@param opts cmp.ConfigSchema
    config = function(_, opts)
      for _, source in ipairs(opts.sources) do
        source.group_index = source.group_index or 1
      end
      require("cmp").setup(opts)
    end,
  }, 

  -- comments
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    lazy = true,
    opts = {
      enable_autocmd = false,
    },
    config = function (_, opts)
      require('ts_context_commentstring').setup(opts)
    end
  },
  {
    "numToStr/Comment.nvim",
    event = "VeryLazy",
    opts = {
      -- space between comment and code
      padding = true,
    },
    config = function (_, opts)
      opts.pre_hook = function()
        require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook()
      end
      require('Comment').setup(opts)
    end
  },
  {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    config = true,
    opts = {

    }
    -- use opts = {} for passing setup options
    -- this is equalent to setup({}) function
  }
}
