local Util = require("utils")

return {
  -- lspconfig
  {
    "neovim/nvim-lspconfig",
    event = "LazyFile",
    dependencies = {
      "mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    ---@class PluginLspOpts
    opts = {
    },
    init = function()
        for name, icon in pairs(require("utils.ui").icons.diagnostics) do
            name = "DiagnosticSign" .. name
            vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
        end
        local lspconfig = require("lspconfig")
        -- diagnostics
        require("mason-lspconfig").setup_handlers({
            function(server_name)
                require("lspconfig")[server_name].setup({})
            end,
            -- Next, you can provide targeted overrides for specific servers.
            ["lua_ls"] = function()
                lspconfig.lua_ls.setup({
                    settings = {
                        Lua = {
                            diagnostics = {
                                globals = { "vim" },
                            },
                        },
                    },
                })
            end,
            ["clangd"] = function()
                lspconfig.clangd.setup({
                    cmd = {
                        "clangd",
                        "--header-insertion=never",
                        "--query-driver=/opt/homebrew/opt/llvm/bin/clang",
                        "--all-scopes-completion",
                        "--completion-style=detailed",
                        -- '--log=verbose'
                    },
                })
            end,
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


            -- Use LspAttach autocommand to only map the following keys
            -- after the language server attaches to the current buffer
            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("UserLspConfig", {}),
                callback = function(ev)
                    -- Enable completion triggered by <c-x><c-o>
                    vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

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

                    vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, opts)
                    vim.keymap.set({ "n", "v" }, "<space>ca", vim.lsp.buf.code_action, opts)
                    vim.keymap.set("n", "<space>f", function()
                        vim.lsp.buf.format({ async = true })
                        end, opts)
                end,
            })

            vim.lsp.set_log_level("trace")
        end,
  },

  -- cmdline tools and lsp servers
  {

    "williamboman/mason.nvim",
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
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "mason.nvim",
    },
    opts = {
      ensure_installed = {
		"lua_ls",
		"clangd",
      },
    },
    ---@param opts MasonSettings | {ensure_installed: string[]}
    config = function(_, opts)
      require("mason-lspconfig").setup(opts)
    end,
  },

}

