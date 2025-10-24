-- Dan's nvim config file
-- Migrated from init.vim to init.lua for lazy.nvim package manager
-- Date: 2025-06-17

-- Python provider
vim.g.python3_host_prog = '/Users/dan/.pyenv/versions/nvim-312/bin/python'

-- Indentation
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

-- UI
vim.opt.number = true
vim.opt.wrap = true
vim.opt.textwidth = 79
vim.opt.formatoptions = 'qrn1'
vim.opt.colorcolumn = '85'
vim.opt.list = true
vim.opt.listchars = { tab = '▸ ', eol = '¬' }
vim.opt.visualbell = true
vim.opt.errorbells = false

-- Search
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true
vim.opt.showmatch = true
vim.opt.hlsearch = true

-- Keymaps
local keymap = vim.keymap.set
local opts = { silent = true }

-- Search with very magic
keymap({ 'n', 'v' }, '/', '/\\v')

-- Clear search highlight
keymap('n', '<leader><space>', ':noh<cr>', opts)

-- Tab for matching pairs
keymap({ 'n', 'v' }, '<tab>', '%')

-- Disable arrow keys
for _, mode in ipairs({ 'n', 'i' }) do
  for _, key in ipairs({ '<up>', '<down>', '<left>', '<right>' }) do
    keymap(mode, key, '<nop>')
  end
end

-- Better j/k movement
keymap('n', 'j', 'gj')
keymap('n', 'k', 'gk')

-- F1 to escape
keymap({ 'i', 'n', 'v' }, '<F1>', '<ESC>')

-- Semicolon to colon
keymap('n', ';', ':')

-- Buffer navigation
keymap('n', '<C-n>', ':bnext<CR>', opts)
keymap('n', '<C-p>', ':bprevious<CR>', opts)

-- IPython embed macro
keymap('n', 'emb', function()
  local line = "import IPython; IPython.embed(header=''); raise Exception('Debug end')"
  vim.fn.append(vim.fn.line('.'), line)
end, opts)

-- Commands
vim.api.nvim_create_user_command('W', 'write', {})
vim.api.nvim_create_user_command('Q', 'quit', {})

-- Autocommands
local augroup = vim.api.nvim_create_augroup('DanConfig', { clear = true })

-- Trim whitespace on save
vim.api.nvim_create_autocmd('BufWritePre', {
  group = augroup,
  pattern = { '*.md', '*.py', '*.c', '*.cpp', '*.java', '*.php', '*.html', '*.yaml', '*.yml', '*.sh', '*.tf', '*.txt' },
  command = [[%s/\s\+$//e]],
})

-- Jump to last position
vim.api.nvim_create_autocmd('BufReadPost', {
  group = augroup,
  callback = function()
    local line = vim.fn.line("'\"")
    if line > 1 and line <= vim.fn.line("$") then
      vim.cmd("normal! g'\"")
    end
  end,
})

-- Bootstrap lazy.nvim package manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Plugin setup
require("lazy").setup({
  -- Colorscheme
  {
    "nanotech/jellybeans.vim",
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("jellybeans")
    end,
  },
  
  -- Terraform support
  {
    "hashivim/vim-terraform",
    ft = { "terraform" },
  },
  
  -- Treesitter for syntax highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "lua", "vim", "python", "javascript", "typescript", "terraform" },
        auto_install = true,
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },
  
  -- GitHub Copilot
  {
    "github/copilot.vim",
    config = function()
      vim.g.copilot_filetypes = {
        zig = false
      }
    end,
  },
})
