-- & Default Spruce Nvim mappings
-- & add your own custom mappings in
-- & ~/.config/nvim/overrides/mapping/init.lua

local __map__ = require("config.data.mapping")

---@class NvimMappingConfig
local main = {}

---Return a new instance of mapping table
---@param tbl? SpruceKeyMapp[]
---@return NvimMappingConfig
function main:new(tbl)
  ---@type SpruceKeyMapp[]
  self = tbl or __map__
  setmetatable(self, { __index = main })
  return self
end

---Merge mappings table into self
---@param tbl table
---@return NvimMappingConfig
function main:merge(tbl) return self:new(vim.tbl_deep_extend("force", self, tbl)) end

---Make `mapp` a non-op in the most common modes
---@param mapp string
---@return NvimMappingConfig
function main:no_op_key(mapp)
  if mapp == nil then return self end
  local modes = { "n", "v", "i", "t", "x", "s", "o", "c", "!", "l" }
  local opts = { noremap = false, silent = true }
  for _, mode in ipairs(modes) do
    vim.keymap.set(mode, mapp, "<NOP>", opts)
  end
  return self
end

---Disable the mouse mappings
---@return NvimMappingConfig
function main:disable_mouse()
  local mouse_events = {
    "<LeftMouse>",
    "<LeftDrag>",
    "<LeftRelease>",
    "<RightMouse>",
    "<RightDrag>",
    "<RightRelease>",
    "<MiddleMouse>",
    "<MiddleDrag>",
    "<MiddleRelease>",
    "<ScrollWheelUp>",
    "<ScrollWheelDown>",
    "<ScrollWheelLeft>",
    "<ScrollWheelRight>",
  }
  for _, v in ipairs(mouse_events) do
    self:no_op_key(v)
  end
  return self
end

---Add one keybinding to the table
---@param id string
---@param props table
---@return NvimMappingConfig
function main:add(id, props)
  if self[id] == nil then self[id] = props end
  return self
end

---Apply all mappings to nvim
function main:apply()
  local rcall = require("warm.spr").rcall
  local fmt = require("warm.str").format

  for _, props in pairs(self) do
    ---@cast props SpruceKeyMapp
    if type(props.exec) == "function" then
      props.opts.callback = props.exec
      props.exec = ""
    end
    props.opts.desc = props.desc -- Just to not nest items
    for _, mode in ipairs(props.mode) do
      local remove = rcall(vim.api.nvim_set_keymap, mode, props.mapp, props.exec, props.opts)
      if not remove() then
        fmt("Mapping error for '{}': {}", tostring(props.desc), remove.unwrap(true)):print()
      end
    end
  end
  return self
end

return main
