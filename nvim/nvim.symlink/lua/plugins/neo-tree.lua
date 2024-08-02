-- source: https://github.com/nvim-neo-tree/neo-tree.nvim/discussions/353#discussioncomment-9630157

return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "main",
  dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
      -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
  },
  config = function()
      require("neo-tree").setup({
          filesystem = {
              filtered_items = {
                  visible = true,
                  show_hidden_count = false,
                  hide_dotfiles = false,
                  hide_gitignored = true,
                  hide_by_name = {
                      '.git',
                      '.DS_Store',
                      'thumbs.db',
                      'package-lock.json',
                      'yarn.lock',
                      'Gemfile.lock'
                  },
                  never_show = { '.git' },
              },
          },
      })
      vim.keymap.set("n", "<C-n>", ":Neotree filesystem toggle left<CR>", {})
  end,
}
