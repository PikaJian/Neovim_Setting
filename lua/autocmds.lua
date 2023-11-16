-- callback return true to remove autocmd
-- auto reload vimrc when editing it
--

vim.api.nvim_create_autocmd('bufwritepost', {
    pattern = { '.vimrc' },
    callback = function()
        vim.api.nvim_command("source ~/.vimrc")
        return true
    end
    }
)

vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'vim' },
    callback = function()
        vim.opt_local.ts = 2
        vim.opt_local.sw = 2
        vim.opt_local.sts= 0
        vim.opt_local.expandtab = true
    end,
})
