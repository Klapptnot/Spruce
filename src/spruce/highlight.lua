-- && Spruce comment highlights

local main = {}

function main.load()
  vim.api.nvim_create_autocmd({ "BufRead" }, {
    pattern = "*.lua",
    callback = function()
      -- Clear existing matches of highlighting
      vim.fn.clearmatches()
      vim.fn.matchadd("DescriptionOfKey", [[\v\s*--\s*!!.*$]])
      vim.cmd("hi DescriptionOfKey guifg=#C25CF7 gui=italic")
      vim.fn.matchadd("PossibleValues", [[\v\s*--\s*!\?.*$]])
      vim.cmd("hi PossibleValues guifg=#FD2AF8 gui=italic")
      vim.fn.matchadd("DefaultNvimValue", [[\v\s*--\~.*$]])
      vim.cmd("hi DefaultNvimValue guifg=#65FD82 gui=italic")
      vim.fn.matchadd("SpruceCommentTitleBold", [[^\v\s*--\s*\&\&.*$]])
      vim.cmd("hi SpruceCommentTitleBold guifg=#cf8ef4 gui=bold")
      vim.fn.matchadd("SpruceCommentTitle", [[^\v\s*--\s*\&.*$]])
      vim.cmd("hi SpruceCommentTitle guifg=#cf8ef4")
    end,
  })
end

return main
