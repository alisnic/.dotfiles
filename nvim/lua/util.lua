local M = {}
local charset = {}

-- qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM1234567890
for i = 48,  57 do table.insert(charset, string.char(i)) end
for i = 65,  90 do table.insert(charset, string.char(i)) end
for i = 97, 122 do table.insert(charset, string.char(i)) end

function M.randomString(length)
  math.randomseed(os.time())

  if length > 0 then
    return M.randomString(length - 1) .. charset[math.random(1, #charset)]
  else
    return ""
  end
end

M.map_handlers = {}

function M.nmap(key, cmd)
  vim.api.nvim_set_keymap('n', key, cmd, { noremap = true, silent = true })
end

function M.nmap_func(key, func)
  local func_name = M.randomString(16)
  M.map_handlers[func_name] = func

  local cmd = ":lua require('util').map_handlers['" .. func_name .. "']()<CR>"
  vim.api.nvim_set_keymap('n', key, cmd, { noremap = true, silent = true })
end

function M.vmap(key, cmd)
  vim.api.nvim_set_keymap('v', key, cmd, { noremap = true, silent = true  })
end

return M
