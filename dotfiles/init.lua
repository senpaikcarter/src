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

local lualine_ok, lualine = pcall(require, "lualine")
if lualine_ok then
  lualine.setup({ options = { theme = "auto" } })
end

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

local lsp_capabilities = vim.lsp.protocol.make_client_capabilities()
local cmp_lsp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if cmp_lsp_ok then
  lsp_capabilities = cmp_nvim_lsp.default_capabilities()
end

-- LSP keymaps attached whenever any language server connects
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(event)
    local map = function(keys, func, desc)
      vim.keymap.set("n", keys, func, { buffer = event.buf, desc = desc })
    end
    local tb_ok, tb = pcall(require, "telescope.builtin")
    map("gd",         tb_ok and tb.lsp_definitions     or vim.lsp.buf.definition,     "Go to definition")
    map("gr",         tb_ok and tb.lsp_references       or vim.lsp.buf.references,     "Find references")
    map("gi",         tb_ok and tb.lsp_implementations  or vim.lsp.buf.implementation, "Go to implementation")
    map("K",          vim.lsp.buf.hover,                                               "Hover docs")
    map("<C-k>",      vim.lsp.buf.signature_help,                                      "Signature help")
    map("<leader>rn", vim.lsp.buf.rename,                                              "Rename symbol")
    map("<leader>ca", vim.lsp.buf.code_action,                                         "Code action")
    map("<leader>ld", vim.diagnostic.open_float,                                       "Line diagnostics")
    map("]d",         vim.diagnostic.goto_next,                                        "Next diagnostic")
    map("[d",         vim.diagnostic.goto_prev,                                        "Prev diagnostic")
  end,
})

local function enable_lsp_if_available(server, config)
  if vim.fn.executable(config.cmd[1]) == 1 then
    config.capabilities = lsp_capabilities
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

local toggleterm_ok, toggleterm = pcall(require, "toggleterm")
if toggleterm_ok then
  toggleterm.setup({
    shell = "zsh",
    direction = "float",
    float_opts = {
      border = "curved",
      width = math.floor(vim.o.columns * 0.85),
      height = math.floor(vim.o.lines * 0.80),
    },
    -- Return to normal mode with <Esc> while in the terminal
    on_open = function(term)
      vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { buffer = term.bufnr, noremap = true })
    end,
  })

  vim.keymap.set({ "n", "t" }, "<leader>tt", "<cmd>ToggleTerm<CR>", { desc = "Toggle floating terminal" })
end

local copilot_ok, copilot = pcall(require, "copilot")
if copilot_ok then
  copilot.setup({
    -- disable ghost text — suggestions come through cmp instead
    suggestion = { enabled = false },
    panel     = { enabled = false },
  })
end

local copilot_cmp_ok, copilot_cmp = pcall(require, "copilot_cmp")
if copilot_cmp_ok then
  copilot_cmp.setup()
end

local cmp_ok, cmp = pcall(require, "cmp")
if cmp_ok then
  cmp.setup({
    mapping = cmp.mapping.preset.insert({
      ["<C-Space>"] = cmp.mapping.complete(),
      ["<C-e>"]     = cmp.mapping.abort(),
      ["<CR>"]      = cmp.mapping.confirm({ select = false }),
      ["<Tab>"]     = cmp.mapping.select_next_item(),
      ["<S-Tab>"]   = cmp.mapping.select_prev_item(),
    }),
    sources = cmp.config.sources({
      { name = "copilot" },
      { name = "nvim_lsp" },
    }, {
      { name = "buffer" },
      { name = "path" },
    }),
  })
end

local gitsigns_ok, gitsigns = pcall(require, "gitsigns")
if gitsigns_ok then
  gitsigns.setup()
  vim.keymap.set("n", "]h", "<cmd>Gitsigns next_hunk<CR>", { desc = "Next git hunk" })
  vim.keymap.set("n", "[h", "<cmd>Gitsigns prev_hunk<CR>", { desc = "Prev git hunk" })
  vim.keymap.set("n", "<leader>hp", "<cmd>Gitsigns preview_hunk<CR>", { desc = "Preview hunk" })
end

local trouble_ok, trouble = pcall(require, "trouble")
if trouble_ok then
  trouble.setup()
  vim.keymap.set("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>",  { desc = "Toggle diagnostics panel" })
  vim.keymap.set("n", "<leader>xd", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", { desc = "Buffer diagnostics" })
end

local autopairs_ok, autopairs = pcall(require, "nvim-autopairs")
if autopairs_ok then
  autopairs.setup({ check_ts = true })
  -- Hook into cmp so confirming a completion also closes any open pair
  if cmp_ok then
    local cmp_autopairs = require("nvim-autopairs.completion.cmp")
    cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
  end
end

local conform_ok, conform = pcall(require, "conform")
if conform_ok then
  conform.setup({
    formatters_by_ft = {
      go         = { "gofmt" },
      python     = { "ruff_format" },
      sh         = { "shfmt" },
      bash       = { "shfmt" },
      zsh        = { "shfmt" },
      lua        = { "stylua" },
    },
    format_on_save = { timeout_ms = 500, lsp_format = "fallback" },
  })
end

local whichkey_ok, whichkey = pcall(require, "which-key")
if whichkey_ok then
  whichkey.setup()
  -- Register leader key group labels for the menu
  whichkey.add({
    { "<leader>f", group = "find (telescope)" },
    { "<leader>h", group = "harpoon / git hunk" },
    { "<leader>t", group = "tree / terminal / terraform" },
    { "<leader>x", group = "diagnostics (trouble)" },
    { "<leader>r", group = "rename" },
    { "<leader>c", group = "code action" },
    { "<leader>l", group = "lsp" },
  })
end

local comment_ok, comment = pcall(require, "Comment")
if comment_ok then
  comment.setup()
end

local harpoon_ok, harpoon = pcall(require, "harpoon")
if harpoon_ok then
  harpoon:setup()
  vim.keymap.set("n", "<leader>ha", function() harpoon:list():add() end,                            { desc = "Harpoon: add file" })
  vim.keymap.set("n", "<leader>hh", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end,    { desc = "Harpoon: menu" })
  vim.keymap.set("n", "<leader>1",  function() harpoon:list():select(1) end,                        { desc = "Harpoon: file 1" })
  vim.keymap.set("n", "<leader>2",  function() harpoon:list():select(2) end,                        { desc = "Harpoon: file 2" })
  vim.keymap.set("n", "<leader>3",  function() harpoon:list():select(3) end,                        { desc = "Harpoon: file 3" })
  vim.keymap.set("n", "<leader>4",  function() harpoon:list():select(4) end,                        { desc = "Harpoon: file 4" })
end
