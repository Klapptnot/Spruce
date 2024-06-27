-- && Default Spruce Nvim highlightings "Cupcake"

local main = {}

-- main.foreground_color = "#e5dbff" -- "#fcfcff"
-- main.background_color = "#1b162e"
main.palette16 = {
  ["01"] = "#434c5e",
  ["02"] = "#fa5aa4",
  ["03"] = "#2be491",
  ["04"] = "#fa946e",
  ["05"] = "#63c5ea",
  ["06"] = "#cf8ef4",
  ["07"] = "#25f0ff",
  ["08"] = "#f7f7f7",
  ["09"] = "#4c566a",
  ["10"] = "#fa74b2",
  ["11"] = "#44eb9f",
  ["12"] = "#e8eb64",
  ["13"] = "#7acbea",
  ["14"] = "#d8a6f4",
  ["15"] = "#6bf5ff",
  ["16"] = "#f4f4f4",
}

main.palette = {}
function main:apply()
  --& "Cupcake" colorscheme highlightings
  for k, v in pairs(self.palette16) do
    local name = string.format("Cupcake%02d", k)
    vim.api.nvim_set_hl(0, "B" .. name .. "Def", { bg = v })
    vim.api.nvim_set_hl(0, "F" .. name .. "Def", { fg = v })
    vim.api.nvim_set_hl(0, "F" .. name .. "Bol", { fg = v, bold = true })
    vim.api.nvim_set_hl(0, "F" .. name .. "Ita", { fg = v, italic = true })
    vim.api.nvim_set_hl(0, "F" .. name .. "Und", { fg = v, underline = true })
    vim.api.nvim_set_hl(0, "S" .. name .. "Mod", { bg = v, fg = "#151515" })
  end
  --& Spruce main color
  local spruce_color = "#8C65C5"
  vim.api.nvim_set_hl(0, "BSpruceDef", { bg = spruce_color })
  vim.api.nvim_set_hl(0, "FSpruceDef", { fg = spruce_color })
  vim.api.nvim_set_hl(0, "FSpruceBol", { fg = spruce_color, bold = true })
  vim.api.nvim_set_hl(0, "FSpruceIta", { fg = spruce_color, italic = true })
  vim.api.nvim_set_hl(0, "FSpruceUnd", { fg = spruce_color, underline = true })
  vim.api.nvim_set_hl(0, "SSpruceMod", { bg = spruce_color, fg = "#151515" })
  --& Global UnsetAllFlags, '\x1b[0m'
  vim.api.nvim_set_hl(0, "UnsetAllFlags", {})
  --& Default foreground
  vim.api.nvim_set_hl(0, "CupcakeDark", { bg = "#151515", fg = "#fcfcff" })
  vim.api.nvim_set_hl(0, "CupcakeLight", { bg = "#fcfcff", fg = "#151515" })
end

return main
