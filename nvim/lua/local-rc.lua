local ffi = require "ffi"

ffi.cdef [[
 int getuid(void);
]]

local loaded_dirs = {}

local function file_owned_by_me(file)
  return ffi.C.getuid() == vim.loop.fs_stat(file).uid
end

local function load()
  local local_rc_name = ".nvimrc.lua"
  if vim.loop.fs_stat(local_rc_name) then
    if file_owned_by_me(local_rc_name) then
      dofile(local_rc_name)
    else
      print(
        local_rc_name
          .. " exists but is not loaded. Security reason: a diffent owner."
      )
    end
  end
end

local function on_dir_change()
  local cwd = vim.fn.getcwd()

  if not loaded_dirs[cwd] then
    load()
  end

  loaded_dirs[cwd] = true
end

return {
  load = load,
  on_dir_change = on_dir_change,
}
