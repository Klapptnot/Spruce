-- && Spruce Nvim initialization

do -- Add config folder to package.path
  local nvcfg = vim.fn.stdpath("config")
  if string.find(package.path, nvcfg, 1, true) then return end
  local p = {
    s = package.config:sub(1, 1), -- Path separator
    d = package.config:sub(3, 3), -- package.path separator
    p = package.config:sub(5, 5), -- name placeholder
  }
  -- stylua: ignore
  package.path = package.path
    -- ";{}/?/init.lua"
    .. p.d .. nvcfg .. p.s .. p.p .. p.s .. "init.lua"
    -- ";{}/?.lua"
    .. p.d .. nvcfg .. p.s .. p.p .. ".lua"
end

-- Initialize things that needs to be downloaded, like lazy
require("src.bootstrap") -- This creates the `custom` folder and init.lua

local config = require("config")
---@type table<string, table<any, any>>
local custom = require("custom")

config.plugins():merge(custom.plugins):apply()

config.mapping():no_op_key("<C-z>") -- disable backgrounding when <C-z> is pressed
config.mapping():merge(custom.mapping):apply()
config.globals():merge(custom.globals):apply()
config.options():merge(custom.options):apply()

-- Load spruce files
require("src.spruce")

-- Run tweaks on nvim & lua behavior
require("src.spruce.tweaks").apply({ "lua_functions", "reset_cursor", "detect_indent" })
