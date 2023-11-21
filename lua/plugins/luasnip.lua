local ls = require("luasnip")
ls.setup()
require('luasnip.loaders.from_vscode').lazy_load()

vim.keymap.set({"i"}, "<TAB>",
    function()
        return ls.jumpable(1) and "<Plug>luasnip-jump-next" or "<tab>"
    end,
    {silent = true, expr = true}
)
vim.keymap.set({"s"}, "<TAB>", function() ls.jump(1) end, {silent = true})
vim.keymap.set({"i", "s"}, "<S-TAB>", function() ls.jump(-1) end, {silent = true})

