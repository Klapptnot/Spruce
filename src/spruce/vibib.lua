-- && Spruce Nvim statusline 'vibib'

local main = {}

local path = require("src.warm.path")
local str = require("src.warm.str")
local uts = require("src.warm.uts")

SPRUCE = {
  vibib = {
    funcs = {},
  },
}

-- Function to generate a random string
local function random_string(length)
  -- if not length or length <= 0 then length = 16 end
  local charset = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ" --"0123456789"
  math.randomseed(os.time())

  local result = ""
  for _ = 1, length do
    local random_index = math.random(#charset)
    local character = string.sub(charset, random_index, random_index)
    result = result .. character
  end

  return result
end

-- local unicode_icons = {
--   [1] = "▬", -- Horizontal bar
--   [2] = "●", -- Filled circle
--   [3] = "▲", -- Triangle
--   [4] = "◆", -- Diamond
--   [5] = "◐", -- Circle with a dot in the center
--   [6] = "◓", -- Circle with a small circle inside
--   [7] = "◌", -- Empty circle
--   [8] = "□", -- Square
--   [9] = "◠", -- Semicircle (upper)
--   [10] = "◡", -- Semicircle (lower)
--   [11] = "⌒", -- Wide tilde
--   [12] = "≈", -- Approximately equal to
--   [13] = "∆", -- Delta symbol
--   [14] = "◇", -- Diamond shape
--   [15] = "█", -- Full block
--   [16] = "▌", -- Left half block
--   [17] = "▐", -- Right half block
--   [18] = "▉", -- Upper one-eighth block
--   [19] = "▊", -- Lower one-eighth block
--   [20] = "◤", -- Upper left corner block
--   [21] = "◥", -- Upper right corner block
--   [22] = "◣", -- Lower right corner block
--   [23] = "◢", -- Lower left corner block
--   [24] = "▭", -- Rectangle with horizontal line in the middle
--   [25] = "", -- Left half rhombus
--   [26] = "", -- Right half rhombus
--   [27] = "", -- Left-down diagonal half block
--   [28] = "", -- Right-up diagonal half block
--   [29] = "", -- Left-up diagonal half block
--   [30] = "", -- Right-down diagonal half block
--   [31] = "", -- Left half circle
--   [32] = "", -- Right half circle
-- }

local HEADER = [[
local path = require("src.warm.path")
local str = require("src.warm.str")

return function ()
  local modi = str.fallback(vim.api.nvim_get_mode().mode, "sp")
  local sbuf = vim.api.nvim_win_get_buf(vim.g.statusline_winid or 1000)
  local igit = vim.b[sbuf].gitsigns_head or vim.b[sbuf].gitsigns_git_status
  local name = vim.api.nvim_buf_get_name(sbuf)
  local skip = vim.api.nvim_get_current_win() ~= vim.g.statusline_winid

  if skip then
    return str.format(
      "  INACTIVE> {}%={}",
      (str.boolean(name) and path.basename(name)) or "Empty",
      str.fallback(vim.bo[sbuf].filetype, "unknown")
    )
  end

  local bar = {}
]]
local FOOTER = [[
  return table.concat(bar, " ")
end
]]

---@enum
-- stylua: ignore
main.blocks = {
  MODE             = "MODE",
  FILE             = "FILE",
  FILE_TYPE        = "FILE_TYPE",
  FILE_EOL         = "FILE_EOL",
  FILE_ENCODING    = "FILE_ENCODING",
  LSP_INFO         = "LSP_INFO",
  GIT_INFO         = "GIT_INFO",
  CURSOR_POS       = "CURSOR_POS",
  CWD              = "CWD",
}

local blocks = {
  MODE = [[
  do
    -- This table was initialy copied from
    -- nvchad statusline
    -- to get the posible modes
    local vim_modes = {
      ["n"]        = { "NORMAL",       "{<normal>}" },
      ["no"]       = { "NORMAL (no)",  "{<normal>}" },
      ["nov"]      = { "NORMAL (nov)", "{<normal>}" },
      ["noV"]      = { "NORMAL (noV)", "{<normal>}" },
      ["noCTRL-V"] = { "NORMAL",       "{<normal>}" },
      ["niI"]   = { "NORMAL i",        "{<normal>}" },
      ["niR"]   = { "NORMAL r",        "{<normal>}" },
      ["niV"]   = { "NORMAL v",        "{<normal>}" },

      ["nt"]    = { "NTERMINAL",       "{<normal>}" },
      ["ntT"]   = { "NTERMINAL (ntT)", "{<normal>}" },

      ["v"]   = { "VISUAL",          "{<visual>}" },
      ["vs"]  = { "V-CHAR (Ctrl O)", "{<visual>}" },
      ["V"]   = { "V-LINE",          "{<visual>}" },
      ["Vs"]  = { "V-LINE",          "{<visual>}" },
      [""]   = { "V-BLOCK",         "{<visual>}" },

      ["i"]   = { "INSERT",              "{<insert>}" },
      ["ic"]  = { "INSERT (completion)", "{<insert>}" },
      ["ix"]  = { "INSERT completion",   "{<insert>}" },

      ["t"]   = { "TERMINAL", "{<prompt>}" },

      ["R"]   = { "REPLACE",           "{<replace>}" },
      ["Rc"]  = { "REPLACE (Rc)",      "{<replace>}" },
      ["Rx"]  = { "REPLACEa (Rx)",     "{<replace>}" },
      ["Rv"]  = { "V-REPLACE",         "{<replace>}" },
      ["Rvc"] = { "V-REPLACE (Rvc)",   "{<replace>}" },
      ["Rvx"] = { "V-REPLACE (Rvx)",   "{<replace>}" },

      ["s"]   = { "SELECT",     "{<visual>}" },
      ["S"]   = { "S-LINE",     "{<visual>}" },
      [""]   = { "S-BLOCK",    "{<visual>}" },

      ["c"]   = { "COMMAND",    "{<prompt>}" },
      ["cv"]  = { "COMMAND",    "{<prompt>}" },
      ["ce"]  = { "COMMAND",    "{<prompt>}" },
      ["r"]   = { "PROMPT",     "{<prompt>}" },
      ["rm"]  = { "MORE",       "{<prompt>}" },
      ["r?"]  = { "CONFIRM",    "{<prompt>}" },
      ["x"]   = { "CONFIRM",    "{<prompt>}" },
      ["!"]   = { "SHELL",      "{<prompt>}" },

      ["sp"]  = { "SPRUCE",     "{<other>}" },
    }

    if str.has("neo-tree,Outline", str.fallback(vim.bo[sbuf].filetype, "unknown")) then
      return vim_modes[modi][1] .. " in "
      .. str.fallback(vim.bo[sbuf].filetype, "unknown")
    end

    local mode, color = table.unpack(vim_modes[modi])
    bar[#bar + 1] = str.format("%#{{1}}Bs#  {{2}} %#{{1}}F#", color, mode)
  end
]],
  FILE = [[
  do
    local icon = "󰈚 " -- Default icon
    local file = (str.boolean(name) and path.basename(name)) or "Empty"

    -- Get the right icon for the file
    if file ~= "Empty" then
      -- Safe load, require exits if SOMEONE removed dependencies
      local loaded, devicons = pcall(require, "nvim-web-devicons")
      if loaded then icon = devicons.get_icon(file) or icon end
    end

    bar[#bar + 1] =
      string.format("%%#{1}Bs# %s %s %%#StatusLine#", icon, file)
  end
]],
  FILE_TYPE = [[
  do
    local type = str.fallback(vim.bo[sbuf].filetype, "unknown")
    bar[#bar + 1] = "%#{1}Fs# " .. type .. " %#StatusLine#"
  end
]],
  FILE_EOL = [[
  bar[#bar + 1] = "%#{1}# <> %#StatusLine#"
]],
  FILE_ENCODING = [[
  do
    local enc = str.fallback(vim.bo[sbuf].fileencoding, "")
    bar[#bar + 1] = "%#{1}# " .. enc .. " %#StatusLine#"
  end
]],
  CURSOR_POS = [[
  bar[#bar + 1] = "%#{1}# Ln %l, Col %c %#StatusLine#"
]],
  GIT_INFO = [[
  do
    if igit then
      local gst = vim.b[sbuf].gitsigns_status_dict
      bar[#bar + 1] = string.format(
        "%%#{<branch>}Bs# %s %%#StatusLine#",
        vim.b[sbuf].gitsigns_status_dict.head
      )
      gst = {
        gst.added,
        gst.changed,
        gst.removed,
      }
      local mod = { "", "", "" }
      if gst[1] and gst[1] > 0 then mod[1] = "%#{<added>}Fs#  " .. gst[1] end
      if gst[2] and gst[2] > 0 then mod[2] = "%#{<changed>}Fs#  " .. gst[2] end
      if gst[3] and gst[3] > 0 then mod[3] = "%#{<removed>}Fs#  " .. gst[3] end
      bar[#bar + 1] = table.concat(mod, "") .. "%#StatusLine#"
    end
  end
]],
  LSP_INFO = [[
  do
    if rawget(vim, "lsp") ~= nil then
      for _, lsp in ipairs(vim.lsp.get_active_clients()) do
        if lsp.name ~= "null-ls" and lsp.attached_buffers[sbuf] ~= nil then
          bar[#bar + 1] = "%#{<name>}Bs#   " .. lsp.name .. " %#StatusLine#"
          break
        end
      end
      local stat = {
        #vim.diagnostic.get(sbuf, { severity = vim.diagnostic.severity.INFO }),
        #vim.diagnostic.get(sbuf, { severity = vim.diagnostic.severity.HINT }),
        #vim.diagnostic.get(sbuf, { severity = vim.diagnostic.severity.WARN }),
        #vim.diagnostic.get(sbuf, { severity = vim.diagnostic.severity.ERROR }),
      }
      local stats = { "", "", "", "" } --        
      if stat[1] and stat[1] > 0 then stats[1] = "%{<info>}Fs#  " .. stat[1] end
      if stat[2] and stat[2] > 0 then stats[2] = "%#{<hint>}Fs#  " .. stat[2] end
      if stat[3] and stat[3] > 0 then stats[3] = "%#{<warn>}Fs#  " .. stat[3] end
      if stat[4] and stat[4] > 0 then stats[4] = "%#{<error>}Fs#  " .. stat[4] end
      bar[#bar + 1] = table.concat(stats, "") .. " %#StatusLine#"
    end
  end
]],
  CWD = [[
  bar[#bar + 1] = "%#{1}Bs# 󰉖 "
    .. str.fallback(path.basename(vim.fn.getcwd()), "")
    .. " %T%#StatusLine#"
]],
}

function main.add_vim_expr(expr)
  local form = [[
  bar[#bar + 1] = "{}"
]]
  return str.format(form, expr)
end

-- Embed lua functions in statusline via vim functions
function main.add_lua_fn(fn)
  local rndm = random_string(16)
  SPRUCE.vibib.funcs[rndm] = fn
  local cmd = [[
  function! __VIBIB_LUAFN_WRAPPER_{1}(...)
    lua SPRUCE.vibib.funcs.{1}()
  endfunction
  ]]
  vim.api.nvim_command(str.format(cmd, rndm))
  local form = [[
  bar[#bar] = "%@__VIBIB_LUAFN_WRAPPER_{}@" .. bar[#bar]
]]
  return str.format(form, rndm)
end

function main.load(enable)
  main.__enabled = false
  if enable == true then
    vim.opt.statusline = "%!v:lua.require('src.spruce.vibib_filled')()"
    main.__enabled = true
  end
  vim.api.nvim_create_user_command("VibibToggle", function()
    if main.__enabled then
      vim.opt.statusline = ""
      main.__enabled = false
    else
      vim.opt.statusline = "%!v:lua.require('src.spruce.vibib_filled')()"
      main.__enabled = true
    end
  end, {})
end

local default = {
  items = {
    main.blocks.MODE,
    main.blocks.FILE,
    main.blocks.LSP_INFO,
    main.add_vim_expr("%="),
    main.blocks.GIT_INFO,
    main.blocks.CURSOR_POS,
    main.blocks.FILE_TYPE,
    main.blocks.FILE_ENCODING,
    main.blocks.CWD,
    main.add_lua_fn(function(_)
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
  },
  colors = {
    blocks = {
      mode = {
        normal = "Yogurt",
        insert = "MintGreen",
        visual = "Cyan",
        prompt = "Purple",
        replace = "Pink",
        other = "Ocre",
      },
      cwd = "Mauve",
      file = "DustyRose",
      file_type = "Beige",
      lsp_info = {
        name = "Skin",
        error = "Red",
        hint = "Blue",
        warn = "Orange",
        info = "CandyPurple",
      },
      git_info = {
        branch = "DarkBrown",
        changed = "Indigo",
        added = "Green",
        removed = "Red",
      },
      cursor_pos = "SolarWhite",
      file_eol = "White",
      file_encoding = "Peach",
    },
    bg = "#0101010",
  },
}

function main.setup(opts)
  opts = vim.tbl_deep_extend("force", opts, default)
  vim.api.nvim_command("hi StatusLine guibg=" .. opts.colors.bg)

  for i, v in ipairs(opts.items) do
    local color = opts.colors.blocks[string.lower(v)]
    if color ~= nil then opts.items[i] = str.format(blocks[v], color) end
  end

  local fcont = HEADER .. table.concat(opts.items, "") .. FOOTER
  uts.str_to_file(fcont, path.join(uts.fwd(false), "vibib_filled.lua"))
  return main
end

return main
