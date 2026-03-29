vim.g.mapleader = " "
vim.g.maplocalleader = "//"

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2

vim.api.nvim_create_autocmd("InsertEnter", {
  callback = function() vim.opt.relativenumber = false end,
})
vim.api.nvim_create_autocmd("InsertLeave", {
  callback = function() vim.opt.relativenumber = true end,
})

local opts = { noremap = true, silent = true }

require("config.lazy")

local nvim_tree_ok, nvim_tree = pcall(require, "nvim-tree")
if nvim_tree_ok then
  nvim_tree.setup()
  vim.keymap.set('n', '<leader>tr', ':NvimTreeToggle<CR>', opts)
end

local treesitter_ok, treesitter = pcall(require, "nvim-treesitter.configs")
if treesitter_ok then
  treesitter.setup {
    ensure_installed = {
      "bash",
      "c",
      "dockerfile",
      "go",
      "hcl",
      "lua",
      "python",
      "query",
      "terraform",
      "vim",
      "vimdoc",
      "markdown",
      "markdown_inline",
    },
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
    },
  }
end

vim.cmd.colorscheme("oxocarbon")

local telescope_ok, builtin = pcall(require, 'telescope.builtin')
if telescope_ok then
  vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
  vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
  vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
  vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
end

local lint_ok, lint = pcall(require, "lint")
if lint_ok then
  lint.linters_by_ft = {
    dockerfile = { "hadolint" },
    go = { "golangcilint" },
    python = { "ruff" },
  }

  vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
    callback = function()
      pcall(lint.try_lint)
    end,
  })
end

local function enable_lsp_if_available(server, config)
  if vim.fn.executable(config.cmd[1]) == 1 then
    vim.lsp.config(server, config)
    vim.lsp.enable(server)
  end
end

enable_lsp_if_available("terraformls", {
  cmd = { "terraform-ls", "serve" },
  filetypes = { "terraform", "terraform-vars" },
  root_markers = { ".terraform", ".git" },
})

enable_lsp_if_available("tflint", {
  cmd = { "tflint", "--langserver" },
  filetypes = { "terraform" },
  root_markers = { ".terraform", ".git", ".tflint.hcl" },
})

enable_lsp_if_available("gopls", {
  cmd = { "gopls" },
  filetypes = { "go", "gomod", "gowork", "gotmpl" },
  root_markers = { "go.work", "go.mod", ".git" },
})

enable_lsp_if_available("pyright", {
  cmd = { "pyright-langserver", "--stdio" },
  filetypes = { "python" },
  root_markers = {
    "pyproject.toml",
    "setup.py",
    "setup.cfg",
    "requirements.txt",
    ".git",
  },
})

enable_lsp_if_available("dockerls", {
  cmd = { "docker-langserver", "--stdio" },
  filetypes = { "dockerfile" },
  root_markers = { "Dockerfile", ".git" },
})

enable_lsp_if_available("docker_compose_language_service", {
  cmd = { "docker-compose-langserver", "--stdio" },
  filetypes = { "yaml.docker-compose" },
  root_markers = {
    "compose.yaml",
    "compose.yml",
    "docker-compose.yaml",
    "docker-compose.yml",
    ".git",
  },
})

enable_lsp_if_available("bashls", {
  cmd = { "bash-language-server", "start" },
  filetypes = { "bash", "sh", "zsh" },
  root_markers = { ".git" },
})

vim.cmd([[silent! autocmd! filetypedetect BufRead,BufNewFile *.tf]])
vim.cmd([[autocmd BufRead,BufNewFile *.hcl set filetype=hcl]])
vim.cmd([[autocmd BufRead,BufNewFile .terraformrc,terraform.rc set filetype=hcl]])
vim.cmd([[autocmd BufRead,BufNewFile *.tf,*.tfvars set filetype=terraform]])
vim.cmd([[autocmd BufRead,BufNewFile *.tfvars.json set filetype=terraform-vars]])
vim.cmd([[autocmd BufRead,BufNewFile *.tfstate,*.tfstate.backup set filetype=json]])

vim.cmd([[let g:terraform_fmt_on_save=1]])
vim.cmd([[let g:terraform_align=1]])

vim.keymap.set("n", "<leader>ti", ":!terraform init<CR>", opts)
vim.keymap.set("n", "<leader>tv", ":!terraform validate<CR>", opts)
vim.keymap.set("n", "<leader>tp", ":!terraform plan<CR>", opts)
vim.keymap.set("n", "<leader>taa", ":!terraform apply -auto-approve<CR>", opts)
