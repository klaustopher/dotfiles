local function apply_theme()
  local scheme = vim.o.background == "dark" and "nightfox" or "dayfox"
  if vim.g.colors_name ~= scheme then
    vim.cmd.colorscheme(scheme)
  end
end

vim.api.nvim_create_autocmd("OptionSet", { pattern = "background", nested = true, callback = apply_theme })
vim.api.nvim_create_autocmd("VimEnter", { nested = true, callback = apply_theme })

return {
  { "EdenEast/nightfox.nvim" },
  { "LazyVim/LazyVim", opts = { colorscheme = apply_theme } },
}
