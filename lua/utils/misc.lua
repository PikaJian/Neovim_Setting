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

return M
