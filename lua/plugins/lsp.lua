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
          pyright = {
            -- 如果你用的是 LazyVim + mason，通常不用寫 mason=true，預設會幫你裝
            settings = {
              python = {
                analysis = {
                  typeCheckingMode = "basic", -- 可改 "off" / "strict"
                  autoSearchPaths = true,
                  useLibraryCodeForTypes = true,
                  diagnosticMode = "workspace",
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
          end,
      })

      vim.lsp.set_log_level("error")
      require("mason-lspconfig").setup(
      {
        ensure_installed = {
          "lua_ls",
          "clangd",
          "pyright"
        },
      })
    end,
    keys = {
      -- LSP 基本跳轉 / 查詢
      { "<leader>jD", function() vim.lsp.buf.declaration() end,      desc = "LSP: Go to Declaration",   mode = "n" },
      { "<leader>jd", function() vim.lsp.buf.definition() end,       desc = "LSP: Go to Definition",    mode = "n" },
      { "<leader>jr",
        function()
          vim.lsp.buf.references()
        end,
        desc = "LSP references (quickfix + bqf)"
      },
      { "<leader>K",  function() vim.lsp.buf.hover() end,            desc = "LSP: Hover",               mode = "n" },
      { "<leader>ji", function() vim.lsp.buf.implementation() end,   desc = "LSP: Go to Implementation",mode = "n" },

      -- 其他 LSP 動作
      { "<leader>rn", function() vim.lsp.buf.rename() end,           desc = "LSP: Rename Symbol",       mode = "n" },
      { "<C-k>",      function() vim.lsp.buf.signature_help() end,   desc = "LSP: Signature Help",      mode = "n" },

      -- 診斷
      { "<leader>d",  function() vim.diagnostic.open_float(nil, { focus = false }) end,
        desc = "Diagnostics: Show Float", mode = "n" },

      -- Workspace
      { "<leader>wa", function() vim.lsp.buf.add_workspace_folder() end,    desc = "Workspace: Add Folder",    mode = "n" },
      { "<leader>wr", function() vim.lsp.buf.remove_workspace_folder() end, desc = "Workspace: Remove Folder", mode = "n" },
      { "<leader>wl", function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end,
        desc = "Workspace: List Folders", mode = "n" },

      -- Format
      { "<leader>jf",  function() vim.lsp.buf.format({ async = true }) end, desc = "LSP: Format", mode = "n" },
    },
  },
  -- cmdline tools and lsp servers
  {
    "mason-org/mason.nvim",
    cmd = "Mason",
    keys = { { "<leader>cm", "<cmd>mason<cr>", desc = "mason" } },
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

