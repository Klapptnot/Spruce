-- && Load spruce components

-- Add help files
vim.cmd("silent! helptags " .. vim.fn.stdpath("config") .. "/doc")

-- stylua: ignore start
require("src.spruce.highlight").load()  -- Enable custom token highlighting
require("src.spruce.term").setup({})    -- Enable terminal plugin

require("src.spruce.remove")                   -- Add the uninstaller command (Sadge)
require("src.spruce.configure")                -- Add the configure command
require("src.spruce.themes.accents").hg_load() -- Add spruce themes command
require("src.spruce.themes").load()            -- Add spruce themes command
-- stylua: ignore end

require("src.spruce.vibib").setup().load(true) -- Enable statusline plugin

local tbmerge = require("warm.table").merge

-- I was about to use this, but was easy to use my own (is not what I wanted)
-- https://gist.github.com/kawarimidoll/302b03fc6e9300786f54cfafb9150fe3
function MergeHighlight(new, ...)
  -- Check for minimum arguments
  local args = { ... }
  if #args < 2 then
    vim.err("[MergeHighlight] At least 2 arguments are required.")
    vim.err("  * New highlight name")
    vim.err("  * Source highlight names (one or more)")
    return
  end

  local res = {}
  for _, v in ipairs(args) do
    res = tbmerge(res, vim.api.nvim_get_hl(0, { name = v }))
  end

  -- Create the new highlight with merged definitions
  if #res > 0 then vim.api.nvim_set_hl(0, new, res) end
  return res
end
