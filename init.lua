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

-- Run tweaks on nvim & lua behavior
require("src.spruce.tweaks").apply(true, true)

-- Initialize things that needs to be downloaded, like lazy
require("src.bootstrap") -- This creates the `custom` folder and init.lua

local config = require("config")
---@type table<string, table<any, any>>
local custom = require("custom")

config.mapping:no_op_key("<C-z>") -- disable backgrounding when <C-z> is pressed

config.globals:merge(custom.globals):apply()
config.mapping:merge(custom.mapping):apply()
config.options:merge(custom.options):apply()
config.plugins:merge(custom.plugins):apply()

-- Load spruce files
require("src.spruce")

-- Set indentation based on guesses, works better btw
vim.api.nvim_create_augroup("SetIndentation", { clear = true })
vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
  group = "SetIndentation",
  callback = function()
    local indent = require("src.furnace.gindent")
    local width = indent.guess()
    if width == nil then return end
    vim.bo.shiftwidth = width
    vim.bo.tabstop = width
    vim.bo.softtabstop = width
  end,
})
