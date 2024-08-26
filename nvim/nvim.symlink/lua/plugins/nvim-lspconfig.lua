return {
    "neovim/nvim-lspconfig",
    opts = {
        servers = {
            ruby_lsp = {
                mason = false,
                cmd = { vim.fn.expand("~/.rbenv/shims/ruby-lsp") },
            },
            rubocop = {
                mason = false,
                cmd = { vim.fn.expand("~/.rbenv/shims/rubocop"), "--lsp" },
            }
        },
    },
}
