-- && Config loader for Spruce

---@alias SpruceConfig {globals:fun():NvimGlobalsConfig; mapping:fun():NvimMappingConfig; options:fun():NvimOptionsConfig; plugins:fun():NvimPluginsConfig}

---@type SpruceConfig
local main = {
  ---@return NvimGlobalsConfig
  globals = function() return require("config.globals"):new() end,
  ---@return NvimMappingConfig
  mapping = function() return require("config.mapping"):new() end,
  ---@return NvimOptionsConfig
  options = function() return require("config.options"):new() end,
  ---@return NvimPluginsConfig
  plugins = function() return require("config.plugins"):new() end,
} -- Return all configs classes

return main
