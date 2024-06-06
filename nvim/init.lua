--SETTINGS

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.laststatus = 3
vim.opt.pumheight = 10
vim.opt.pumblend = 10
vim.opt.termguicolors = true
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.softtabstop = 2
vim.opt.showmatch = true
vim.opt.ignorecase = true
vim.opt.signcolumn = "yes:1"
vim.opt.completeopt = "menu,menuone,noselect"
vim.opt.updatetime = 1000
vim.opt.undofile = true
vim.opt.showmode = true
vim.opt.wildmode = "longest:full,full"
vim.opt.formatoptions = "jcroqlnt"
vim.opt.clipboard = "unnamedplus"
vim.opt.cursorline = true
vim.opt.scrolloff = 10
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.hidden = true
vim.opt.fillchars = "eob: "
vim.opt.list = true
vim.opt.wrap = false
-- vim.opt.kp = ":help"

vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3
vim.g.netrw_browse_split = 4
vim.g.netrw_altv = 1
vim.g.netrw_winsize = 40

--KEYMAPS
vim.g.mapleader = " "

vim.keymap.set("n", "<leader>q", "<cmd>q<cr>")
-- vim.keymap.set("n", "<ESC>", ":nohlsearch<Bar>:echo<CR>")
vim.keymap.set("i", "jk", "<Esc>")
vim.keymap.set("i", "jj", "<Esc>")
vim.keymap.set("n", "<leader><C-s>", "<cmd>w<cr>")
vim.keymap.set("v", "p", '"_dP')
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")
vim.keymap.set("n", "<leader>k", "ddkP")
vim.keymap.set("n", "<leader>j", "ddp")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set("v", "<leader>j", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "<leader>k", ":m '<-2<CR>gv=gv")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "<leader>bb", "<cmd>bd<cr>")
vim.keymap.set("t", "<ESC><ESC>", "<C-\\><C-n>")
vim.keymap.set("t", "<leader>q", "<C-\\><C-n>:q<cr>")
vim.keymap.set("n", "<leader>rw", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set("x", "p", "\"_dP")
vim.keymap.set("n", "<C-Left>", [[<cmd>vertical resize +5<cr>]])
vim.keymap.set("n", "<C-Right>", [[<cmd>vertical resize -5<cr>]])
vim.keymap.set("n", "<C-Up>", [[<cmd>horizontal resize -2<cr>]])
vim.keymap.set("n", "<C-Down>", [[<cmd>horizontal resize +2<cr>]])
vim.keymap.set("i", "<C-l>", "<ESC>%%a")
-- vim.keymap.set("n", "<leader>ts","<cmd>split term://bash<CR>")


--HIGHLIGHT ON Yank

vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})


--LAST POSITION

vim.api.nvim_create_autocmd("BufReadPost", {
    pattern = {"*"},
    callback = function()
        if vim.fn.line("'\"") > 1 and vim.fn.line("'\"") <= vim.fn.line("$") then
            vim.api.nvim_exec("normal! g'\"",false)
        end
    end
})

-- DONT SHOW NUMBER IN TERMINAL
vim.api.nvim_create_autocmd("TermOpen", {
    command = [[setlocal nonumber norelativenumber]]
})

local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'

if not vim.loop.fs_stat(lazypath) then
  print('Installing lazy.nvim....')
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable',
    lazypath,
  })
  print('Done.')
end

vim.opt.rtp:prepend(lazypath)

local colors = {
  -- fg = "#E4E4E4",
  -- bg = "#181818",
}

require('lazy').setup({
--  { 'ramojus/mellifluous.nvim',
--  opts = {
--  color_set = 'tender',
--  transparent_background = {
--    enabled = true,
--  },
--   },
-- },
 --  { 'nyoom-engineering/oxocarbon.nvim'
 -- },
--   { 'sainnhe/gruvbox-material' },
  { 'blazkowolf/gruber-darker.nvim',
  opts = {
    bold = true,
    italic = {
      strings = false,
    },
  },
},
  {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v2.x',
    dependencies = {
      {'neovim/nvim-lspconfig'},
      {
        'williamboman/mason.nvim',
        build = function()
          pcall(vim.cmd, 'MasonUpdate')
        end,
      },
      {'williamboman/mason-lspconfig.nvim'},

      {'hrsh7th/nvim-cmp'},
      {'hrsh7th/cmp-nvim-lsp'},
      {'hrsh7th/cmp-buffer'},
      {'hrsh7th/cmp-path'},
      {'saadparwaiz1/cmp_luasnip'},
      {'hrsh7th/cmp-nvim-lua'},
      {'L3MON4D3/LuaSnip'},
      {'rafamadriz/friendly-snippets'},
    }
  },
  { 'nvim-treesitter/nvim-treesitter',
  build = ":TSUpdate",
  config = function()
    require('nvim-treesitter.configs').setup({
      ensure_installed = { 'lua', 'javascript', 'vimdoc' },
      sync_install = false,
      auto_install = false,
      highlight = { enable = true },
    })
  end
},
  { 'nvim-telescope/telescope.nvim', tag = '0.1.2',
    dependencies = { 
    'nvim-lua/plenary.nvim',
   { 'nvim-telescope/telescope-fzf-native.nvim',
   build = 'make',
   config = function()
     require('telescope').load_extension('fzf')
   end,
 },
},
},
  { 'numToStr/Comment.nvim', opts = {} },
  { 'mbbill/undotree' },
  { 'nvim-lualine/lualine.nvim',
  opts = {
    options = {
    icons_enabled = true,
    colored = false,
    -- always_visible = true,
    section_separators = { left = '', right = ''},
    component_separators = { left = '' , right = '' },
        theme = {
           normal = {
             a = { fg = colors.fg, bg = colors.bg },
             b = { fg = colors.fg, bg = colors.bg },
             c = { fg = colors.fg, bg = colors.bg },
            },
            insert = { a = { fg = colors.fg, bg = colors.bg }, b = { fg = colors.fg, bg = colors.bg } },
            visual = { a = { fg = colors.fg, bg = colors.bg }, b = { fg = colors.fg, bg = colors.bg } },
            command = { a = { fg = colors.fg, bg = colors.bg }, b = { fg = colors.fg, bg = colors.bg } },
            replace = { a = { fg = colors.fg, bg = colors.bg }, b = { fg = colors.fg, bg = colors.bg } },
            inactive = {
              a = { bg = colors.fg, fg = colors.bg },
              b = { bg = colors.fg, fg = colors.bg },
              c = { bg = colors.fg, fg = colors.bg },
            },
          },
        },
        sections = {
          lualine_a = {' '},
          lualine_b = {'branch', {'filename', path = 0 }},
          lualine_c = {'diff'},
          lualine_x = {'diagnostics'},
          lualine_y = {},
          lualine_z = {'location' },
        },
  },
},

})

local lsp = require('lsp-zero').preset({
name = 'minimal',
})

lsp.on_attach(function(client, bufnr)


vim.keymap.set('n', '<leader>rn',vim.lsp.buf.rename, {buffer = true})
vim.keymap.set('n', 'K', vim.lsp.buf.hover, {buffer = true})
vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, {buffer = true})
vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, {buffer = true})
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {buffer = true})
vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, {buffer = true})
vim.keymap.set('n', '<leader>vd', vim.diagnostic.open_float, {buffer = true})
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, {buffer = true})
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, {buffer = true})
vim.keymap.set('n', 'gI', vim.lsp.buf.implementation, {buffer = true})

end)


lsp.setup()


local cmp = require('cmp')
local cmp_action = require('lsp-zero').cmp_action()

require('luasnip.loaders.from_vscode').lazy_load()

cmp.setup({
  sources = {
    {name = 'nvim_lsp'},
    {name = 'luasnip', keyword_length = 2},
    {name = 'path'},
    {name = 'buffer', keyword_length = 3},
  },
  mapping = {
     ['<CR>'] = cmp.mapping.confirm({select = false}),
     ['<C-Space>'] = cmp.mapping.confirm({behavior = cmp.ConfirmBehavior.Replace, select = true}),
     ['<Tab>'] = cmp_action.luasnip_supertab(),
     ['<S-Tab>'] = cmp_action.luasnip_shift_supertab(),
     ['<C-/>'] = cmp.mapping.complete(),
   },
})

local builtin = require('telescope.builtin')

vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles)
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers)
vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files)
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string)
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep)
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics)
vim.keymap.set('n', '<leader>ds', require('telescope.builtin').lsp_document_symbols)
vim.keymap.set('n', 'gr', require('telescope.builtin').lsp_references)
vim.keymap.set('n', '<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols)
vim.keymap.set('n', '<leader>/', function()
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer]' })
vim.keymap.set("n", "<F5>", vim.cmd.UndotreeToggle)


vim.cmd.colorscheme('gruber-darker')
