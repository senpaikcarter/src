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
  { "nyoom-engineering/oxocarbon.nvim" },

  -- neovim/nvim-lspconfig
  { "neovim/nvim-lspconfig" },

  -- Async linting
  { "mfussenegger/nvim-lint" },

  -- copilot (Lua version integrates with cmp)
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
  },
  { "zbirenbaum/copilot-cmp" },

  -- Nvim-Tree for file explorer
  { "nvim-tree/nvim-tree.lua", dependencies = { "nvim-tree/nvim-web-devicons" } },

  -- indentLine for better indentation visualization
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    ---@module "ibl"
    ---@type ibl.config
    opts = {},
  },

  -- Toggleable floating terminal
  {
    "akinsho/toggleterm.nvim",
    version = "*",
  },

  -- Autocompletion
  { "hrsh7th/nvim-cmp" },
  { "hrsh7th/cmp-nvim-lsp" },
  { "hrsh7th/cmp-buffer" },
  { "hrsh7th/cmp-path" },

  -- Git gutter signs
  { "lewis6991/gitsigns.nvim" },

  -- Diagnostics panel
  { "folke/trouble.nvim", dependencies = { "nvim-tree/nvim-web-devicons" } },

  -- Auto-pairs
  { "windwp/nvim-autopairs" },

  -- Formatter
  { "stevearc/conform.nvim" },

  -- Keymap hint popup
  { "folke/which-key.nvim" },

  -- Comment toggling
  { "numToStr/Comment.nvim" },

  -- Fast file pinning and switching
  { "ThePrimeagen/harpoon", branch = "harpoon2", dependencies = { "nvim-lua/plenary.nvim" } },
}
