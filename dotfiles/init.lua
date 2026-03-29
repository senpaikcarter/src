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
    ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline" },
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

if vim.fn.executable("terraform-ls") == 1 then
  vim.lsp.config('terraformls', {})
  vim.lsp.enable('terraformls')
end

if vim.fn.executable("tflint") == 1 then
  vim.lsp.config('tflint', {})
  vim.lsp.enable('tflint')
end

vim.cmd([[silent! autocmd! filetypedetect BufRead,BufNewFile *.tf]])
vim.cmd([[autocmd BufRead,BufNewFile *.hcl set filetype=hcl]])
vim.cmd([[autocmd BufRead,BufNewFile .terraformrc,terraform.rc set filetype=hcl]])
vim.cmd([[autocmd BufRead,BufNewFile *.tf,*.tfvars set filetype=terraform]])
vim.cmd([[autocmd BufRead,BufNewFile *.tfstate,*.tfstate.backup set filetype=json]])

vim.cmd([[let g:terraform_fmt_on_save=1]])
vim.cmd([[let g:terraform_align=1]])

vim.keymap.set("n", "<leader>ti", ":!terraform init<CR>", opts)
vim.keymap.set("n", "<leader>tv", ":!terraform validate<CR>", opts)
vim.keymap.set("n", "<leader>tp", ":!terraform plan<CR>", opts)
vim.keymap.set("n", "<leader>taa", ":!terraform apply -auto-approve<CR>", opts)
