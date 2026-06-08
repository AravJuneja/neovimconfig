-- bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- options
vim.g.mapleader = " "
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 50

-- transparent background to match terminal
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = function()
    vim.api.nvim_set_hl(0, "Normal",     { bg = "NONE", ctermbg = "NONE" })
    vim.api.nvim_set_hl(0, "NormalNC",   { bg = "NONE", ctermbg = "NONE" })
    vim.api.nvim_set_hl(0, "SignColumn", { bg = "NONE", ctermbg = "NONE" })
  end,
})
vim.api.nvim_set_hl(0, "Normal",     { bg = "NONE", ctermbg = "NONE" })
vim.api.nvim_set_hl(0, "NormalNC",   { bg = "NONE", ctermbg = "NONE" })
vim.api.nvim_set_hl(0, "SignColumn", { bg = "NONE", ctermbg = "NONE" })

-- keymaps
vim.keymap.set("n", "<leader>w", ":w<CR>")
vim.keymap.set("n", "<leader>q", ":q<CR>")

require("lazy").setup({

  -- syntax highlighting (new API for nvim 0.12+)
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").install({
        "c", "cpp", "python", "lua", "vim", "vimdoc", "verilog",
      })
    end,
  },

  -- installs language servers: run :MasonInstall pyright clangd
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },

  -- completion engine
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      cmp.setup({
        snippet = {
          expand = function(args) luasnip.lsp_expand(args.body) end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"]      = cmp.mapping.confirm({ select = true }),
          ["<Tab>"]     = cmp.mapping(function(fallback)
            if cmp.visible() then cmp.select_next_item() else fallback() end
          end, { "i", "s" }),
          ["<S-Tab>"]   = cmp.mapping(function(fallback)
            if cmp.visible() then cmp.select_prev_item() else fallback() end
          end, { "i", "s" }),
        }),
        sources = {
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        },
      })
    end,
  },

  -- fuzzy finder: <leader>ff=files, <leader>fg=grep, <leader>fb=buffers
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("telescope").setup()
      local b = require("telescope.builtin")
      vim.keymap.set("n", "<leader>ff", b.find_files)
      vim.keymap.set("n", "<leader>fg", b.live_grep)
      vim.keymap.set("n", "<leader>fb", b.buffers)
    end,
  },

  -- file tree
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup()
      vim.keymap.set("n", "<leader>t", ":NvimTreeToggle<CR>", { silent = true })
    end,
  },

  -- auto-close brackets and quotes
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup()
    end,
  },

  -- statusline
  {
    "nvim-lualine/lualine.nvim",
    config = function()
      require("lualine").setup()
    end,
  },

})

-- startup screen
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    if vim.fn.argc() > 0 then return end

    local art = {
      [[            .$                                  $.]],
      [[          /:;                                  :;\]],
      [[         : $                                    $ ;]],
      [[         ;:$                                    $;:]],
      [[        : $:              ________              ;$ ;]],
      [[        ; $;;     _..gg$$SSP^^^^T$S$$pp.._     ::$ :]],
      [[       : :$;|  .g$$$$$$SSP"      "TS$$$$$$$p.  |:$; ;]],
      [[       ; :$;:.d$$$$$$$SSS          SS$$$$$$$$b.;:$; :]],
      [[      :  :$$$$$$$$$$$$SSS          SS$$$$$$$$$$$$$;  ;]],
      [[      ;  $$$$$$$$$$$$$$SSb.      .dS$$$$$$$$$$$$$$;  :]],
      [[     :  :S$$$$$$$$$$$$$$SSSSppggSSS$$$$$$$$$$$$$$$;   ;]],
      [[     |  :SS$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$;   :]],
      [[     |  :SS$$$$$$$$$$$$$$$$$^^^^^^^^^$$$$$$$$$$$$$$   :]],
      [[     ;   SS$$$$$$$$$$P^"                 "^T$$$$$$$   :]],
      [[    :    :SS$$$$$$$$$                       T$$$$$;   :]],
      [[    |     SSS$$$$$$$;                        T$$$$    :]],
      [[    |     :SSS$$$$$$;                        :$$$;    :]],
      [[    ;      SSS$$$$$$;                        :S$$;    :]],
      [[    ;      :SS$$P"^P                          S$$;    :]],
      [[    ;    ..d$$$P    `                         S$$$    :]],
      [[    ;     T$$$P                          dS   T$$$b.  :]],
      [[    ;    :$$$$.     .                   dSS;   $$$$$b.:]],
      [[    ;    :$$$$$b     Tb.   .          .dSS$$b.d$$$$$$$:]],
      [[    :    $$$$$$$b     TSb   Tb..g._, :$$SS$$$$$$SSS$$$:]],
      [[    :   :$$$$$$$$b     SSb   T$SS$P   "^TS$$$$$$P"TS$$:]],
      [[    :   $$$$$$$$$$b._.dS$$b _ T$$P _     TSS$SSP  :SS$:]],
      [[    :  :$$$$SSS$$$$$$$$$P" d$b. _.d$P     TSSP"    SS$:]],
      [[    :  :P"TSSP"^T$$$$$$P  :$$$$$$$$P d$$b          $S$;]],
      [[    :  :b.dS^^-.  ""^^"    $b T d$$$s$$$$b __..--""$ $;]],
      [[    :  :$$$S    ""^^..ggSS$$$$$$$$$$$$$$P^^""     .$ $;]],
      [[    :   $$$$$pp..__   `j$$$$$$^$$$$$b. d....ggppTSSS$$;]],
      [[    :   $$$$SP     """t  :$$$$ $$$$$$$b.  d$b    `TSS$;]],
      [[    :  \:$$SP   _.gd$$P_d$$$$$ $$$$$$$$$bd$P'    .dSPd;]],
      [[    :   \"^S     "^T$$$$$$$$$$ $$$$$SS$$$$b.    dSS'd$;]],
      [[    $    $. "-.__.gd$$$$$$$SP:S$$P  TSS$$$$$bssS^".d$$:]],
      [[   :$    $$b.   ""^^T$$$$SP' :S$P    TSSSP^^""  .d$$$$:]],
      [[   :$   :$$$P        "^SP'   :S;     .^"`.     $$$$$$$:]],
      [[   $;   :$$$            "-.  :S;  .-"     \    :$$$$$$:]],
      [[  .$ :  $$$;   :           `.:S;.'         ;    $$$$$$:;]],
      [[ .P :S  $$$    ;             `^'                :$$$$$:;]],
      [[.P  S;.d$$;   :               -'                 $$$$$:;]],
      [[$  :SS$$$$    ;     __....----  --...____        :$$$ :S]],
      [[$  $SSS$$;    :  ; d$$$$$$$pppqqqq$$$$$$L;       :$$$ SS]],
      [[: :SSSSS$$     ; : \ "^T$$$$$$$$$$$$$P' .':      $PT$ SS;]],
      [[ $SP^"^TSP\    :  \ "-.  """"""""""" .-"  ;     /   $ SSSb.]],
      [[ :S     S  \           "--...___..--"    /  :  /    :gSSSSSb.]],
      [[  T bug T   \       `.      _____       /   ; /]],
      [[   `         \ :      "==="""""""""===""   : /]],
      [[              `:                           ;']],
      [[                "-.                     .-"]],
      [[                   ""--..         ..--""]],
    }

    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_set_current_buf(buf)
    vim.bo[buf].buftype   = "nofile"
    vim.bo[buf].bufhidden = "wipe"
    vim.bo[buf].swapfile  = false

    vim.api.nvim_buf_set_lines(buf, 0, -1, false, art)
    vim.bo[buf].modifiable = false

    vim.keymap.set("n", "q", ":q<CR>",    { buffer = buf, silent = true })
    vim.keymap.set("n", "e", ":enew<CR>", { buffer = buf, silent = true })
  end,
})

-- LSP (native nvim 0.11+ API — no lspconfig needed)
-- install servers with: :MasonInstall pyright clangd
vim.lsp.config('*', {
  capabilities = require("cmp_nvim_lsp").default_capabilities(),
})

vim.lsp.config('pyright', {
  cmd = { 'pyright-langserver', '--stdio' },
  filetypes = { 'python' },
  root_markers = { 'pyproject.toml', 'setup.py', 'setup.cfg', 'requirements.txt', '.git' },
})
vim.lsp.enable('pyright')

vim.lsp.config('clangd', {
  cmd = { 'clangd' },
  filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda' },
  root_markers = { '.clangd', 'compile_commands.json', 'CMakeLists.txt', '.git' },
})
vim.lsp.enable('clangd')

-- enable treesitter highlighting per filetype
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "c", "cpp", "cuda", "python", "lua", "vim", "verilog" },
  callback = function() vim.treesitter.start() end,
})

-- LSP keymaps (active only when a server attaches)
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local opts = { buffer = args.buf }
    vim.keymap.set("n", "gd",          vim.lsp.buf.definition,    opts)
    vim.keymap.set("n", "K",           vim.lsp.buf.hover,         opts)
    vim.keymap.set("n", "gr",          vim.lsp.buf.references,    opts)
    vim.keymap.set("n", "<leader>rn",  vim.lsp.buf.rename,        opts)
    vim.keymap.set("n", "<leader>ca",  vim.lsp.buf.code_action,   opts)
    vim.keymap.set("n", "<leader>d",   vim.diagnostic.open_float, opts)
  end,
})
