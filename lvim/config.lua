lvim.keys.normal_mode["<S-f>"] = ":Telescope live_grep<CR>"
lvim.keys.normal_mode["<S-l>"] = ":BufferLineCycleNext<CR>"
lvim.keys.normal_mode["<S-h>"] = ":BufferLineCyclePrev<CR>"
lvim.keys.normal_mode["<C-a>"] = "ggVG"
lvim.colorscheme = "delek"
lvim.keys.normal_mode["<S-CR>"] = 'o<ESC>'

lvim.plugins = {
  {
    "shortcuts/no-neck-pain.nvim",
    config = function ()
      require("no-neck-pain").setup({
        autocmds = {
          enableOnVimEnter = true,
          enableOnTabEnter = true,
        },
        buffers = {
          right = {
            enabled = false,
          }
        },
      })
    end,
  },
  { "VidocqH/lsp-lens.nvim" },
  { "leoluz/nvim-dap-go" },
  { "olexsmir/gopher.nvim" },
  { "yegappan/mru" },
  { "nvim-treesitter/nvim-treesitter" }
}

vim.opt.relativenumber = true
