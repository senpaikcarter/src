return {
  -- Lazy.nvim manages itself
  { "folke/lazy.nvim" },

  -- Telescope fuzzy finder
  { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },

  -- Treesitter for better syntax highlighting
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate", lazy = false },

  -- Lualine statusline
  { "nvim-lualine/lualine.nvim" },

  -- Gruvbox colorscheme
  { "ellisonleao/gruvbox.nvim" },

  -- Git integration
  { "tpope/vim-fugitive" },

  -- Dracula Colorscheme
  --{ "Mofiqul/dracula.nvim" }, 

  -- Nyoom Colorscheme
  {  "nyoom-engineering/oxocarbon.nvim" },

  -- neovim/nvim-lspconfig
  { "neovim/nvim-lspconfig" },

  -- copilot
  { "github/copilot.vim" },

  -- Nvim-Tree for file explorer
  { "nvim-tree/nvim-tree.lua", dependencies = { "nvim-tree/nvim-web-devicons" } },

  -- indentLine for better indentation visualization
{
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    ---@module "ibl"
    ---@type ibl.config
    opts = {},
}
}
