--[[ SETTINGS --]]

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

vim.g.mapleader = " "

--[[ AUTOCOMMANDS --]]
local autocmd = vim.api.nvim_create_autocmd

-- RESIZE BUFFERS IF WINDOW GOT RESIZED
vim.api.nvim_command('autocmd VimResized * wincmd =')

-- HIGHLIGHT ON Yank
autocmd("TextYankPost", {
  callback = function()
vim.highlight.on_yank()
  end,
  group = highlight_group,
pattern = "*",
})

-- LAST POSITION
autocmd("BufReadPost", {
    pattern = {"*"},
    callback = function()
        if vim.fn.line("'\"") > 1 and vim.fn.line("'\"") <= vim.fn.line("$") then
            vim.api.nvim_exec("normal! g'\"",false)
        end
    end
})

-- DONT SHOW NUMBER IN TERMINAL
autocmd("TermOpen", {
    command = [[setlocal nonumber norelativenumber]]
})

-- REMOVE WHITESPACE ON SAVE
autocmd("BufWritePre", {
    pattern = "",
    command = [[%s/\s\+$//e]]
})

-- DON'T AUTO COMMENTING NEW LINES
autocmd('BufEnter', {
  pattern = '',
  command = 'set fo-=c fo-=r fo-=o'
})

-- CURSOR ALWAYS CENTERED
autocmd({ "CursorMoved", "CursorMovedI", "BufEnter" }, {
    group = vim.api.nvim_create_augroup("ScrollOffEOF", {}),
    callback = function()
        local win_h = vim.api.nvim_win_get_height(0)
        local off = math.min(vim.o.scrolloff, math.floor(win_h / 2))
        local dist = vim.fn.line "$" - vim.fn.line "."
        local rem = vim.fn.line "w$" - vim.fn.line "w0" + 1
        if dist < off and win_h - rem + dist < off then
            local view = vim.fn.winsaveview()
            view.topline = view.topline + off - (win_h - rem + dist)
            vim.fn.winrestview(view)
        end
    end,
  })

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

 require("lazy").setup({
   spec = {

--[[ PLUGINS CONFIG --]]

     {
       "nvim-treesitter/nvim-treesitter",
       build = ":TSUpdate",
       config = function()
         require("nvim-treesitter.configs").setup({
           ensure_installed = {
             "vim", "vimdoc",  "lua", "luadoc",
           },
           auto_install = false,
           sync_install = false,
           highlight = { enable = true },
         })
       end
     },

     {
       "mbbill/undotree",
       config = function ()
         vim.keymap.set("n", "<F5>", vim.cmd.UndotreeToggle)
       end
     },

     {
       "nvim-telescope/telescope.nvim",
       tag = "0.1.8",
       dependencies = {
         "nvim-lua/plenary.nvim",
         { "nvim-telescope/telescope-fzf-native.nvim",
         build = make,
       },
       config = function()
         require("telescope").setup({
           pickers = {
             find_files = {
               hidden = true,
             },
           },
         })
         require("telescope").load_extension("fzf")
       end
     },
   },

   { "neovim/nvim-lspconfig",
   dependencies = {
     "williamboman/mason.nvim",
     "williamboman/mason-lspconfig.nvim",
     "j-hui/fidget.nvim",
     "hrsh7th/cmp-nvim-lsp",
     "hrsh7th/nvim-cmp",
     "hrsh7th/cmp-buffer",
     "hrsh7th/cmp-path",
     "hrsh7th/cmp-cmdline",
     {
       "L3MON4D3/LuaSnip", build = "make install_jsregexp",
     dependencies = {
       {"rafamadriz/friendly-snippets" ,
       config = function()
         require("luasnip.loaders.from_vscode").lazy_load()
       end,
     },
    },
 },
     "saadparwaiz1/cmp_luasnip",
   },
   config = function()
     local cmp = require("cmp")
     local cmp_lsp = require("cmp_nvim_lsp")
     local lsp_capabilities = require("cmp_nvim_lsp").default_capabilities()
     local luasnip = require("luasnip")
     require("fidget").setup({})
     require("mason").setup()
     require("mason-lspconfig").setup({
       ensure_installed = {
         "html",
         "ts_ls",
       },
       handlers = {
         function(server_name)
           require("lspconfig")[server_name].setup({
             capabilities = lsp_capabilities
           })
         end,
         require("lspconfig").phpactor.setup({
           capabilities = lsp_capabilities
         })
       },
     })

   cmp.setup({
     snippet = {
       expand = function(args)
         require("luasnip").lsp_expand(args.body)
       end,
     },
     sources = {
       {name = "nvim_lsp"},
       {name = "luasnip", keyword_length = 2},
       {name = "buffer", keyword_length = 3},
       {name = "path"},
     },
     window = {
       -- completion = cmp.config.window.bordered(),
       -- documentation = cmp.config.window.bordered(),
     },
     mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.confirm { select = true },
          ['<Tab>'] = cmp.mapping(function()
            if luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            end
          end, { 'i', 's' }),
          ['<S-Tab>'] = cmp.mapping(function()
            if luasnip.locally_jumpable(-1) then
             luasnip.jump(-1)
            end
          end, { 'i', 's' }),
     }),
        vim.diagnostic.config({
          virtual_text = false,
          float = {
            focusable = false,
            style = "minimal",
            source = "always",
            header = "",
            prefix = "",
          },
        }),
   })
   end
 },

-- [[ FAV THEMES ]] --

 { 'projekt0n/github-nvim-theme',
lazy = false,
priority = 1000,
config = function()
require('github-theme').setup({})
vim.cmd.colorscheme('github_light')
end,
 },


   },
   change_detection = {
     enabled = true,
     notify = true,
   },
   checker = {
     enabled = false,
     notify = true
   },
   performance = {
     rtp = {
       disabled_plugins = {
         "gzip",
         "matchit",
         "matchparen",
         "netrwPlugin",
         "tarPlugin",
         -- "tohtml",
         "tutor",
         "zipPlugin",
       },
     },
   },
 })

--[[ KEYMAPS --]]

vim.keymap.set("n", "<leader>q", "<cmd>q<cr>")
vim.keymap.set("n", "<leader><C-q>", "<cmd>q!<cr>")
vim.keymap.set("n", "<leader>w", "<cmd>w<cr>")
vim.keymap.set("n", "<leader>W", "<cmd>wq<cr>")
vim.keymap.set("n", "<leader>k", "ddkP")
vim.keymap.set("n", "<leader>j", "ddp")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "<leader>bb", "<cmd>bd<cr>")
vim.keymap.set("n", "<leader>rw", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gIc<Left><Left><Left><Left>]])
vim.keymap.set("n", "<C-Left>", [[<cmd>vertical resize +5<cr>]])
vim.keymap.set("n", "<C-Right>", [[<cmd>vertical resize -5<cr>]])
vim.keymap.set("n", "<C-Up>", [[<cmd>horizontal resize -2<cr>]])
vim.keymap.set("n", "<C-Down>", [[<cmd>horizontal resize +2<cr>]])

vim.keymap.set("v", "p", '"_dP')
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")
vim.keymap.set("v", "<leader>j", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "<leader>k", ":m '<-2<CR>gv=gv")

vim.keymap.set("t", "<ESC><ESC>", "<C-\\><C-n>")
vim.keymap.set("t", "<leader>q", "<C-\\><C-n>:q<cr>")

vim.keymap.set("x", "p", "\"_dP")

vim.keymap.set("i", "jk", "<Esc>")
-- vim.keymap.set("i", "<C-l>", "<ESC>%%a")

vim.keymap.set("n", "<leader>ff", vim.lsp.buf.format)
vim.keymap.set("n", "<leader>ds", vim.lsp.buf.document_symbol)
vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references)
vim.keymap.set("n", "<leader>gt", vim.diagnostic.setloclist)

vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers)
vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles)
vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files)
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').grep_string)
vim.keymap.set('n', '<leader>gs', require('telescope.builtin').live_grep)
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags)
vim.keymap.set('n', '<leader>/', function()
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end
)

local function toggle_autocomplete()
  local cmp = require("cmp")
  local current_setting = cmp.get_config().completion.autocomplete
  if current_setting and #current_setting > 0 then
    cmp.setup({ completion = { autocomplete = false } })
    print('Autocomplete disabled')
  else
    cmp.setup({ completion = { autocomplete = { cmp.TriggerEvent.TextChanged } } })
    print('Autocomplete enabled')
  end
end
vim.api.nvim_create_user_command('NvimCmpToggle', toggle_autocomplete, {})
vim.keymap.set("n", "<leader><F1>", ":NvimCmpToggle<CR>")

-- todo: add to 'fav themes'
-- require("gruber-darker").setup({
--          bold = false,
--          italic = {
--            strings = false,
--            comments = false,
--        },
--        config = function()
-- vim.cmd.colorscheme("gruber-darker")
-- end,
-- })

   --   { "ramojus/mellifluous.nvim",
   --   lazy = false,
   --   priority = 1000,
   --   opts = {
   --     color_set = "tender",
   --     styles = {
   --       comments = { italic = false },
   --       markup = {
   --         headings = { bold = true },
   --       },
   --     },
   --   }
   --   }
   --   vim.cmd.colorscheme("mellifluous")
   -- },

   -- {
   --   "slugbyte/lackluster.nvim",
   --   lazy = false,
   --   priority = 1000,
   --   opts = {},
   -- },
