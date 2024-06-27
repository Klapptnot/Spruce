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

local vibib = require("src.spruce.vibib") -- Enable statusline plugin

vibib.setup({
  vibib.blocks.MODE,
  vibib.blocks.FILE,
  vibib.blocks.LSP_INFO,
  vibib.add_vim_expr("%="),
  vibib.blocks.GIT_INFO,
  vibib.blocks.CURSOR_POS,
  vibib.blocks.FILE_TYPE,
  vibib.blocks.FILE_ENCODING,
  vibib.blocks.CWD,
  vibib.add_lua_fn(function(_)
    local win = require("plenary.popup").create("", {
      title = "New CWD",
      style = "minimal",
      borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
      borderhighlight = "pathBr",
      titlehighlight = "pathToGo",
      focusable = true,
      width = 50,
      height = 1,
    })

    vim.cmd("normal A")
    vim.cmd("startinsert")

    vim.keymap.set({ "i", "n" }, "<Esc>", "<cmd>q<CR>", { buffer = 0 })

    vim.keymap.set({ "i", "n" }, "<CR>", function()
      local new = vim.trim(vim.fn.getline("."))
      vim.api.nvim_win_close(win, true)
      vim.cmd.stopinsert()
      vim.fn.chdir(new)
    end, { buffer = 0 })
  end),
}, {})

vibib.load(true)

local tbmerge = require("src.warm.table").merge

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
