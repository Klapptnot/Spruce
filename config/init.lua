-- && Config loader for Spruce

local main = {
  globals = function() return require("config.globals"):new() end,
  mapping = function() return require("config.mapping"):new() end,
  options = function() return require("config.options"):new() end,
  plugins = function() return require("config.plugins"):new() end,
} -- Return all configs classes

return main
