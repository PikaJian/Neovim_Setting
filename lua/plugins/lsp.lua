local Util = require("utils")

return {
  -- lspconfig
  {
    "neovim/nvim-lspconfig",
    event = "LazyFile",
    dependencies = {
      "mason.nvim",
      { "mason-org/mason-lspconfig.nvim", config = function() end },
    },
    ---@class PluginLspOpts
    opts = function()
      util_diagnostics = require("utils.ui").icons.diagnostics
      local ret = {
        diagnostics = {
          underline = true,
          update_in_insert = false,
          virtual_text = {
            spacing = 4,
            source = "if_many",
            prefix = "●",
            -- this will set set the prefix to a function that returns the diagnostics icon based on the severity
            -- prefix = "icons",
          },
          severity_sort = true,
          signs = {
            text = {
              [vim.diagnostic.severity.ERROR] = util_diagnostics.Error,
              [vim.diagnostic.severity.WARN] = util_diagnostics.Warn,
              [vim.diagnostic.severity.HINT] = util_diagnostics.Hint,
              [vim.diagnostic.severity.INFO] = util_diagnostics.Info,
            },
          },
        },
        -- Enable this to enable the builtin LSP inlay hints on Neovim.
        -- Be aware that you also will need to properly configure your LSP server to
        -- provide the inlay hints.
        inlay_hints = {
          enabled = true,
          exclude = { "vue" }, -- filetypes for which you don't want to enable inlay hints
        },
        -- Enable this to enable the builtin LSP code lenses on Neovim.
        -- Be aware that you also will need to properly configure your LSP server to
        -- provide the code lenses.
        codelens = {
          enabled = false,
        },
        -- Enable this to enable the builtin LSP folding on Neovim.
        -- Be aware that you also will need to properly configure your LSP server to
        -- provide the folds.
        folds = {
          enabled = true,
        },
        -- add any global capabilities here
        capabilities = {
          workspace = {
            fileOperations = {
              didRename = true,
              willRename = true,
            },
          },
        },
        -- options for vim.lsp.buf.format
        -- `bufnr` and `filter` is handled by the LazyVim formatter,
        -- but can be also overridden when specified
        format = {
          formatting_options = nil,
          timeout_ms = nil,
        },
        -- LSP Server Settings
        ---@alias lazyvim.lsp.Config vim.lsp.Config|{mason?:boolean, enabled?:boolean}
        ---@type table<string, lazyvim.lsp.Config|boolean>
        servers = {
          stylua = { enabled = false },
          lua_ls = {
            -- mason = false, -- set to false if you don't want this server to be installed with mason
            -- Use this to add any additional keymaps
            -- for specific lsp servers
            -- ---@type LazyKeysSpec[]
            -- keys = {},
            settings = {
              Lua = {
                workspace = {
                  checkThirdParty = false,
                },
                codeLens = {
                  enable = true,
                },
                completion = {
                  callSnippet = "Replace",
                },
                doc = {
                  privateName = { "^_" },
                },
                hint = {
                  enable = true,
                  setType = false,
                  paramType = true,
                  paramName = "Disable",
                  semicolon = "Disable",
                  arrayIndex = "Disable",
                },
              },
            },
          },
        },
        -- you can do any additional lsp server setup here
        -- return true if you don't want this server to be setup with lspconfig
        ---@type table<string, fun(server:string, opts: vim.lsp.Config):boolean?>
        setup = {
          -- example to setup with typescript.nvim
          -- tsserver = function(_, opts)
          --   require("typescript").setup({ server = opts })
          --   return true
          -- end,
          -- Specify * to use this function as a fallback for any server
          -- ["*"] = function(server, opts) end,
        },
        servers = {
        -- Ensure mason installs the server
          clangd = {
            keys = {
              { "<leader>ch", "<cmd>LspClangdSwitchSourceHeader<cr>", desc = "Switch Source/Header (C/C++)" },
            },
            root_markers = {
              "compile_commands.json",
              "compile_flags.txt",
              "configure.ac", -- AutoTools
              "Makefile",
              "configure.ac",
              "configure.in",
              "config.h.in",
              "meson.build",
              "meson_options.txt",
              "build.ninja",
              ".git",
            },
            capabilities = {
              offsetEncoding = { "utf-16" },
            },
            cmd = {
              "clangd",
              "--background-index",
              "--clang-tidy",
              "--header-insertion=iwyu",
              "--completion-style=detailed",
              "--function-arg-placeholders",
              "--fallback-style=llvm",
            },
            init_options = {
              usePlaceholders = true,
              completeUnimported = true,
              clangdFileStatus = true,
            },
          },
        },
      }
    end,
    init = function()
        local lspconfig = vim.lsp
        local util = require("lspconfig.util")
        -- 若你有 cmp_nvim_lsp，可把 capabilities 傳給各 server
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        pcall(function()
          capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
        end)

        lspconfig.config("lua_ls", {
          settings = {
            Lua = {
              diagnostics = { globals = { "vim" } },
            },
          },
          capabilities = capabilities,
        })
    end,
    ---@param opts PluginLspOpts
    config = function(_, opts)
      vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float)
      vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist)
      ---vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, {silent = true, noremap = true})
      vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
      vim.keymap.set("n", "]d", vim.diagnostic.goto_next)

      -- setup autoformat
      Util.format.register(Util.lsp.formatter())

      vim.diagnostic.config({
        virtual_text = true, -- Enable/disable virtual text
        signs = true,        -- Enable/disable signs in the sign column
        update_in_insert = false, -- Update diagnostics in insert mode
        underline = true,    -- Underline problematic code
        severity_sort = true, -- Sort diagnostics by severity
        float = {            -- Configuration for floating windows (hover)
          border = "rounded",
          source = "always",
          header = "",
          prefix = "",
        },
      })


      -- Use LspAttach autocommand to only map the following keys
      -- after the language server attaches to the current buffer
      vim.api.nvim_create_autocmd("LspAttach", {
          group = vim.api.nvim_create_augroup("UserLspConfig", {}),
          callback = function(ev)
              -- Enable completion triggered by <c-x><c-o>
              vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

              -- FIXME: clangd semantic highlight is wrong.
              local client = vim.lsp.get_client_by_id(ev.data.client_id)
              if client.name == "clangd" then
                client.server_capabilities.semanticTokensProvider = nil
              end

              -- Buffer local mappings.
              -- See `:help vim.lsp.*` for documentation on any of the below functions
              local opts = { buffer = ev.buf }
              vim.keymap.set("n", "<leader>jD", vim.lsp.buf.declaration, opts)
              vim.keymap.set("n", "<leader>jd", vim.lsp.buf.definition, opts)
              vim.keymap.set("n", "<leader>jr", vim.lsp.buf.references, opts)
              vim.keymap.set("n", "<leader>K", vim.lsp.buf.hover, opts)
              vim.keymap.set("n", "<leader>ji", vim.lsp.buf.implementation, opts)
              vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

              vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)

              vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, opts)
              vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, opts)
              vim.keymap.set("n", "<space>wl", function()
                  print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
                  end, opts)
              -- use lspsaga instead
              -- vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, opts)
              -- vim.keymap.set({ "n", "v" }, "<space>ca", vim.lsp.buf.code_action, opts)
              vim.keymap.set("n", "<space>f", function()
                  vim.lsp.buf.format({ async = true })
                  end, opts)
          end,
      })

      vim.lsp.set_log_level("trace")
      require("mason-lspconfig").setup(
      {
        ensure_installed = {
          "lua_ls",
          "clangd",
        },
      })
    end,
  },
  -- cmdline tools and lsp servers
  {
    "mason-org/mason.nvim",
    cmd = "Mason",
    keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
    build = ":MasonUpdate",
    opts = {
      --[[ ensure_installed = {
		"lua_ls",
		"clangd",
        -- "flake8",
      }, ]]
    },
    ---@param opts MasonSettings | {ensure_installed: string[]}
    config = function(_, opts)
      require("mason").setup(opts)
    end,
  },
}

