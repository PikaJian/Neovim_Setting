local M = {}

function M.dump_table(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. M.dump_table(v) .. ','
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


return M
