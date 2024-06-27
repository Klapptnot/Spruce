local __plugins__ = {
  --#region Dependencies of a lot of plugins
  ["nvim-tree/nvim-web-devicons"] = {},
  ["nvim-lua/plenary.nvim"] = {},
  --#endregion

  -- stylua: ignore start
  ["stevearc/dressing.nvim"]            = {},
  ["folke/trouble.nvim"]                = {},
  ["RRethy/vim-illuminate"]             = {},
  ["nvim-telescope/telescope.nvim"]     = { tag = "0.1.5" },
  ---@diagnostic disable-next-line: different-requires
  ["hrsh7th/nvim-cmp"]                  = require("config.data.for.cmp"),
  ["windwp/nvim-autopairs"]             = require("config.data.for.autopairs"),
  ["williamboman/mason.nvim"]           = require("config.data.for.mason"),
  ["nanozuki/tabby.nvim"]               = require("config.data.for.tabby"),
  ["lewis6991/gitsigns.nvim"]           = require("config.data.for.gitsigns"),
  ["williamboman/mason-lspconfig.nvim"] = require("config.data.for.masonlsp"),
  ["neovim/nvim-lspconfig"]             = require("config.data.for.lspconfig"),
  ["nvimtools/none-ls.nvim"]            = require("config.data.for.null_ls"),
  ["simrat39/symbols-outline.nvim"]     = require("config.data.for.symbols_outline"),
  ["nvim-neo-tree/neo-tree.nvim"]       = require("config.data.for.neo_tree"),
  ["nvim-treesitter/nvim-treesitter"]   = require("config.data.for.treesitter"),
  ["shellRaining/hlchunk.nvim"]         = require("config.data.for.hlchunk"),
  ["Cassin01/wf.nvim"]                  = require("config.data.for.wf"),
  -- ["folke/which-key.nvim"]           = { event = "VeryLazy", },
  -- stylua: ignore end

  ["utilyre/barbecue.nvim"] = {
    name = "barbecue",
    version = "*",
    dependencies = {
      "SmiteshP/nvim-navic",
    },
  },

  ["numToStr/Comment.nvim"] = {
    opts = {},
    lazy = false,
  },

  ["rcarriga/nvim-notify"] = {
    name = "notify",
    init = function()
      require("notify").setup({
        background_colour = "#000000", -- Just to ignore notification
      })
      vim.notify = require("notify")
    end,
  },

  ["catppuccin/nvim"] = {
    name = "catppuccin",
    priority = 1000,
    -- config = function()
    --   require("catppuccin").setup()
    --   vim.cmd.colorscheme("catppuccin")
    -- end,
  },

  ["EdenEast/nightfox.nvim"] = {
    lazy = false,
    priority = 1000,
    config = function()
      require("nightfox").setup({
        options = {
          terminal_colors = true,
          transparent = true,
        },
      })
      vim.cmd.colorscheme("duskfox")
    end,
  },

  ["LhKipp/nvim-nu"] = {
    lazy = true,
    init = function()
      require("nu").setup({
        use_lsp_features = true,
        all_cmd_names = [[help commands | get name | str join "\n"]],
      })
    end,
  },
}

return __plugins__
