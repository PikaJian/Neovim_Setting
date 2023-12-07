local M = {}

function M.dump_table(o)
  if type(o) == 'table' then
    local s = '{ '
    for k, v in pairs(o) do
      if type(k) ~= 'number' then k = '"' .. k .. '"' end
      s = s .. '[' .. k .. '] = ' .. M.dump_table(v) .. ','
    end
    return s .. '} '
  else
    return tostring(o)
  end
end

function M.twiddle_case(str)
  if str == string.upper(str) then
    return string.lower(str)
  elseif str == string.lower(str) then
    return string.gsub(str, "(%<%w+%>)", string.upper)
  else
    return string.upper(str)
  end
end

function M.ViewUTF8()
  vim.o.encoding = "utf-8"
  vim.o.termencoding = "big5"
end

function M.UTF8()
  vim.o.encoding = "utf-8"
  vim.o.termencoding = "big5"
  vim.o.fileencoding = "utf-8"
  vim.o.fileencodings = "ucs-bom,big5,utf-8,latin1"
end

function M.Big5()
  vim.o.encoding = "utf-8"
  vim.o.termencoding = "big5"
end

function M.GitVersion(...)
  local git_version_output = vim.fn.system('git --version')
  local s_git_versions = string.match(git_version_output, '%d[^%s]+')
  local components = vim.split(s_git_versions, '%D+')
  if next(components) == nil then
    return -1
  end
  for i = 1, #arg do
    if tonumber(arg[i]) > tonumber(components[i]) then
      return 0
    elseif tonumber(arg[i]) < tonumber(components[i]) then
      return 1
    end
  end
  return tonumber(arg[#arg]) == tonumber(components[#components])
end

function M.spell_on()
  vim.opt.spell = true
  vim.opt.spelllang = "en_us"
end

function M.format_code(style)
  local firstline = vim.fn.line('.')
  local lastline = vim.fn.line('.')
  -- Visual mode
  if vim.api.nvim_buf_get_mark(0, '<') then
    firstline = unpack(vim.api.nvim_buf_get_mark(0, '<'))
    lastline = unpack(vim.api.nvim_buf_get_mark(0, '>'))
  end
  local formatdef_clangformat = "'clang-format-3.8" ..
      " --lines='" .. firstline .. ":" .. lastline .. "'" ..
      " --assume-filename=" .. vim.fn.bufname('%') ..
      " -style=" .. style .. "'"
  local formatcommand = ":" .. firstline .. "," .. lastline .. "Autoformat"
  -- vim.api.nvim_exec(formatcommand, false)
end

-- insert ; after )
function M.insert_semi_colon()
    local line = vim.fn.line('.')
    local content = vim.fn.getline('.')
    local eol = ';'

    -- 如果行末有分号，则在光标后面插入分号
    if content:sub(-2, -2) == ';' then
        vim.cmd('normal! a;')
        vim.cmd('normal! l')
        vim.cmd('startinsert')
    else
        -- 如果当前行有括号，则判断是插入分号还是');'
        if vim.fn.search('(', 'bcn', line) > 0 then
            local found_close = vim.fn.search(')', 'cn', line)
            eol = found_close > 0 and ';' or ');'
        end
        -- 在当前行末插入分号或');'
        vim.fn.setline(line, content .. eol)
        vim.cmd('startinsert!')
    end
end

function M.test()
  print("fuck")
end

function M.CurDir()
  local curdir = vim.fn.substitute(vim.fn.getcwd(), vim.env.HOME, "~", "")
  return curdir
end

function M.HasPaste()
  if vim.o.paste == true then
    return "[PASTE]"
  else
    return ""
  end
end

-- Lua 脚本示例：创建浮动窗口以获取用户输入并保存到字符串变量
function M.ReplSelect()
    -- 创建新缓冲区
    local bufnr = vim.api.nvim_create_buf(false, true)

    -- 设置浮动窗口的选项
    local opts = {
        relative = 'cursor',
        width = 80,
        height = 1,
        row = 5,
        col = 5,
        border = 'single',
        style = 'minimal',
        title = "Register to paste over selection? (<cr> => default register: \")"
    }

    -- 打开浮动窗口
    local winid = vim.api.nvim_open_win(bufnr, true, opts)

    -- 将浮动窗口设置为可输入
    vim.api.nvim_buf_set_option(bufnr, 'buftype', 'prompt')

    -- 聚焦在浮动窗口上，等待用户输入
    vim.cmd('startinsert')

    -- 读取用户输入并存储到变量中
    local input = nil
    vim.fn.prompt_setcallback(bufnr, function(text)
        input = text
        vim.api.nvim_buf_delete(bufnr, {force = true})
    end)

    -- 返回获取到的用户输入（这里返回的是函数指针，可以在 Lua 中使用）
    -- return input
end


function M.change_fold()
  if vim.o.foldmethod == 'syntax' then
    vim.o.foldmethod = 'indent'
  else
    vim.o.foldmethod = 'syntax'
  end
  vim.cmd [[set foldmethod?]]
end


return M
