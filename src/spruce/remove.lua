-- && Spruce uninstall function
-- & It would be sad to run this :(

local function uninstall_spruce(all)
  local Result = require("src.warm.spruce").Result

  local folders = {
    vim.fn.stdpath("config"),
  }
  if all == true then
    table.insert(folders, vim.fn.stdpath("data"))
    table.insert(folders, vim.fn.stdpath("cache"))
  end

  for _, folder in ipairs(folders) do
    local remove = Result(vim.fn.delete, folder, "rf")
    if not remove() then
      print("Error removing folder:", folder)
      print("Error message:", remove.unwrap_err())
    end
  end
end

vim.api.nvim_create_user_command("SpruceRemove", function()
  vim.ui.select({ "Yes", "No" }, {
    prompt = "Are you sure you want to remove all configurations?",
  }, function(choice)
    if choice == "Yes" then
      vim.ui.select({ "Yes", "No" }, {
        prompt = "Do you want to remove all chached data?",
      }, function(choice)
        if choice == "Yes" then
          uninstall_spruce(true)
        else
          uninstall_spruce()
        end
      end)
    else
      vim.api.nvim_echo({ { "I was scared, puff!", "Bold" } }, false, {})
    end
  end)
end, {
  desc = "Remove Spruce instalation",
})
