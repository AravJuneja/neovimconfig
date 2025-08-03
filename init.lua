-- init.lua

-- 1) Bootstrap packer.nvim if not installed
local fn = vim.fn
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  fn.system({
    'git', 'clone', '--depth', '1',
    'https://github.com/wbthomason/packer.nvim',
    install_path,
  })
  vim.cmd('packadd packer.nvim')
end

-- 2) Plugins
require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'  -- Packer manages itself

  -- File browser
  use {
    'kyazdani42/nvim-tree.lua',
    requires = 'kyazdani42/nvim-web-devicons',
  }

  -- Utility library
  use 'nvim-lua/plenary.nvim'

  -- Fuzzy finder
  use {
    'nvim-telescope/telescope.nvim',
    requires = 'nvim-lua/plenary.nvim',
  }

  -- Treesitter for better syntax highlighting & indenting
  use {
    'nvim-treesitter/nvim-treesitter',
    run = function()
      require('nvim-treesitter.install').update({ with_sync = true })
    end,
  }

  -- Statusline
  use 'nvim-lualine/lualine.nvim'

  -- LSP configurations
  use 'neovim/nvim-lspconfig'
  use 'williamboman/mason.nvim'
  use 'williamboman/mason-lspconfig.nvim'

  -- Autocompletion
  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-nvim-lsp'

  -- Snippets
  use 'L3MON4D3/LuaSnip'

  -- Git signs
  use 'lewis6991/gitsigns.nvim'

  -- Debugging
  use 'mfussenegger/nvim-dap'
  use {
    'rcarriga/nvim-dap-ui',
    requires = 'nvim-neotest/nvim-nio',  -- required by dap-ui
  }

  -- nvim-nio (dependency for nvim-dap-ui)
  use 'nvim-neotest/nvim-nio'
end)

-- 3) Core Settings
vim.g.mapleader = ' '
local opt = vim.opt
opt.number         = true
opt.relativenumber = true
opt.expandtab      = true
opt.shiftwidth     = 2
opt.tabstop        = 2
opt.smartindent    = true
opt.wrap           = false
opt.termguicolors  = true
vim.cmd('colorscheme ivory')

-- 4) nvim-tree Configuration
require('nvim-tree').setup({
  view = { width = 30, side = 'left' },
  hijack_netrw         = true,
  update_focused_file  = { enable = true },
  renderer             = { indent_markers = { enable = true } },
})
vim.api.nvim_set_keymap('n', '<leader>e', ':NvimTreeToggle<CR>', { noremap = true, silent = true })

-- 5) Treesitter Configuration
require('nvim-treesitter.configs').setup({
  ensure_installed = { 'lua', 'python', 'javascript' },
  highlight        = { enable = true },
  indent           = { enable = true },
})

-- 6) Telescope Configuration
require('telescope').setup({
  defaults = { file_ignore_patterns = { 'node_modules' } },
})
local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }
map('n', '<leader>ff', ':Telescope find_files<CR>', opts)
map('n', '<leader>fg', ':Telescope live_grep<CR>', opts)
map('n', '<leader>fb', ':Telescope buffers<CR>', opts)
map('n', '<leader>fh', ':Telescope help_tags<CR>', opts)

-- 7) Lualine Configuration
require('lualine').setup()

-- 8) Gitsigns Configuration
require('gitsigns').setup()

-- 9) Mason & LSPconfig Setup
require('mason').setup()
require('mason-lspconfig').setup({ ensure_installed = { 'pyright', 'ts_ls' } })
local capabilities = require('cmp_nvim_lsp').default_capabilities()
local lspconfig = require('lspconfig')
for _, server in ipairs({ 'pyright', 'ts_ls' }) do
  lspconfig[server].setup({ capabilities = capabilities })
end

-- 10) nvim-cmp Setup
local cmp = require('cmp')
cmp.setup({
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>']      = cmp.mapping.confirm({ select = true }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  }, {
    { name = 'buffer' },
  }),
})

-- 11) DAP & DAP-UI Configuration
local dap   = require('dap')
local dapui = require('dapui')
dapui.setup()
-- Automatically open/close DAP UI
dap.listeners.after.event_initialized['dapui_config'] = function()
  dapui.open()
end
dap.listeners.before.event_terminated['dapui_config'] = function()
  dapui.close()
end

-- 12) Undo/Redo Mappings
vim.api.nvim_set_keymap('n', '<C-z>', 'u', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<C-z>', '<Esc>ui', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-S-z>', '<C-r>', { noremap = true, silent = true })

-- 13) Select All Mapping
vim.api.nvim_set_keymap('n', '<C-a>', 'ggVG', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<C-a>', '<Esc>ggVG', { noremap = true, silent = true })

