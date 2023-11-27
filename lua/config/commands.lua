--  lsp
vim.api.nvim_create_user_command("SwitchHeader", function()
	local switch_header = require("plugins.lsp_setting").switch_source_header()
	if switch_header ~= nil then
		switch_header()
	end
end, {})

vim.api.nvim_create_user_command("SpellOn", function()
    require("utils").misc.spell_on()
  end, {})

vim.api.nvim_create_user_command("SeeTab", function()
  if not vim.g.SeeTabEnabled then
    vim.g.SeeTabEnabled = 1
    vim.g.SeeTab_list = vim.o.list
    vim.g.SeeTab_listchars = vim.o.listchars
    local regA = vim.fn.getreg('a', 1)
    vim.fn.execute('hi SpecialKey')
    vim.fn.setreg('a', regA, 1)
    vim.cmd('silent! hi SpecialKey guifg=black guibg=magenta ctermfg=black ctermbg=magenta')
    vim.o.list = true
    vim.opt.listchars = { tab = '|\\' }
  else
    vim.o.list = vim.g.SeeTab_list
    vim.o.listchars = vim.g.SeeTab_listchars
    vim.cmd('silent! exe "hi " . substitute(g:SeeTabSpecialKey, "xxx", "", "e")')
    vim.g.SeeTabEnabled = nil
    vim.g.SeeTab_list = nil
    vim.g.SeeTab_listchars = nil
  end
end, { nargs = 0 })

vim.api.nvim_create_user_command("DiffRev", function(opts)
  local git_status_dictionary = {
    ["A"] = "Added",
    ["B"] = "Broken",
    ["C"] = "Copied",
    ["D"] = "Deleted",
    ["M"] = "Modified",
    ["R"] = "Renamed",
    ["T"] = "Changed",
    ["U"] = "Unmerged",
    ["X"] = "Unknown"
  }

  local rev = opts.fargs[1]
  print(rev)
  local output = vim.fn.systemlist('git diff --name-status ' .. rev)
  local list = {}
  for _, val in ipairs(output) do
    local filename = val:match("%S+$")
    local status = val:match("^%w")
    local text = git_status_dictionary[status] or "Unknown"
    table.insert(list, { filename = filename, text = text })
  end
  vim.fn.setqflist(list)
  vim.cmd('copen')
end, { nargs = 1, complete = 'file' })

