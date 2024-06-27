---@diagnostic disable: deprecated

local main = {}

---Apply tweaks to the runtime environment and functionality
---@param nvim boolean
---@param lua boolean
---@return integer number of nvim tweaks
---@return integer number of lua tweaks
function main.apply(nvim, lua)
  if nvim == nil then nvim = false end
  assert(type(nvim), "argument #1 must be boolean")
  if lua == nil then lua = false end
  assert(type(lua), "argument #2 must be boolean")

  local nvmt, luat = 0, 0

  NVIM_TWEAKED_SP = false
  if nvim then
    -- Reset cursor style on exit
    vim.api.nvim_create_autocmd({ "VimLeave" }, {
      pattern = { "*" },
      command = 'set guicursor= | call chansend(v:stderr, "\\x1b[ q")',
    })

    NVIM_TWEAKED_SP = true
    nvmt = 1
  end

  NVIM_LUA_TWEAKED_SP = false
  if lua then
    -- !! Neovim has Lua 5.1, so make it appear Lua 5.4
    -- !! moving unpack to table.unpack
    -- !! making forward compatibility easy (When available, remove this)
    table.unpack = unpack

    ---Simple check if string contains other string inside
    --
    ---Patterns are escaped and matched as single string
    -- ```lua
    -- local valid_types = "string,number"
    -- assert(valid_types:has(type(v)), 'argument #1 must be either string or number')
    -- ```
    ---@param s string
    ---@param str string
    ---@return boolean
    string.has = function(s, str)
      return s:find(str:gsub("[%^%$%(%)%%%.%[%]%*%+%-%?]", "%%%1")) ~= nil
    end

    ---Print string to `stdout`.
    ---Same as print(string), but avoiding weird editing
    -- ```lua
    -- local fmt = '%d.%d.%d'
    -- fmt:format(major, minor, patch):print()
    -- ```
    ---@param s string
    string.print = function(s) print(s) end

    ---Write string to default output file (mainly `stdout`).
    ---Used to `print()` without trailing `\n`
    -- ```lua
    -- local fmt = '%d.%d.%d'
    -- fmt:format(major, minor, patch):put()
    -- ```
    ---@param s string
    string.put = function(s) io.write(s) end

    NVIM_LUA_TWEAKED_SP = true
    luat = 3
  end

  return nvmt, luat
end

return main
