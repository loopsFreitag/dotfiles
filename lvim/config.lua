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
  { "akinsho/bufferline.nvim" },
  { "leoluz/nvim-dap-go" },
  { "olexsmir/gopher.nvim" },
  { "yegappan/mru" },
  { "nvim-treesitter/nvim-treesitter" },
  { "nvim-java/lua-async-await" },
  { "nvim-java/nvim-java-refactor" },
  { "nvim-java/nvim-java-core" },
  { "nvim-java/nvim-java-test" },
  { "nvim-java/nvim-java-dap" },
  { "mfussenegger/nvim-dap" },
  { "neovim/nvim-lspconfig" },
  { "MunifTanjim/nui.nvim" },
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },
  { "nvim-java/nvim-java" },
  { "JavaHello/spring-boot.nvim" },
}

vim.opt.relativenumber = true

