-- Lazy.nvim
local lazy_path = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazy_path) then
  vim.fn.system({'git', 'clone', '--filter=blob:none', 'https://github.com/folke/lazy.nvim.git', '--branch=stable', lazy_path})
end
vim.opt.rtp:prepend(lazy_path)

-- Vim options
vim.g.mapleader      = ' '
vim.g.maplocalleader = ' '

vim.o.tabstop        = 4
vim.o.softtabstop    = 4
vim.o.shiftwidth     = 4
vim.o.expandtab      = true

vim.o.autoindent     = true
vim.o.copyindent     = true

vim.o.cmdheight      = 0
vim.o.showmode       = false
vim.o.signcolumn     = 'yes'

vim.o.number         = true
vim.o.showcmd        = true
vim.o.wildmenu       = true
vim.o.showmatch      = true
vim.o.scrolloff      = 10
--vim.o.colorcolumn    = '100'

vim.o.termguicolors  = true
vim.o.linebreak      = true
vim.o.pumheight      = 10
vim.o.relativenumber = true
vim.o.clipboard      = 'unnamedplus'

--vim.o.hlsearch      = false
vim.o.ignorecase     = true
vim.o.smartcase      = true
vim.o.undofile       = true
vim.o.list           = true
vim.o.updatetime     = 250

vim.o.wrap           = true
vim.o.linebreak      = true
vim.o.showbreak      = '+++'

vim.opt.listchars:append 'space:⋅'
vim.opt.listchars:append 'eol:↴'

vim.cmd [[highlight LineNr guifg=#fff]]

-- Normal & insert mode numbers
vim.api.nvim_create_autocmd('InsertEnter', { callback = function() vim.wo.relativenumber = false end })
vim.api.nvim_create_autocmd('InsertLeave', { callback = function() vim.wo.relativenumber = true end })

-- Reset cmdheight when macro recording
vim.api.nvim_create_autocmd('RecordingEnter', { callback = function() vim.o.cmdheight = 1 end })
vim.api.nvim_create_autocmd('RecordingLeave', { callback = function() vim.o.cmdheight = 0 end })

-- Keymaps
vim.keymap.set({ 'n', 'v' }, '<space>', '<nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', 'v:count == 0 ? "gk" : "k"', { expr = true, silent = true })
vim.keymap.set('n', 'j', 'v:count == 0 ? "gj" : "j"', { expr = true, silent = true })

-- Window navigation
vim.keymap.set('n', '<a-h>', '<cmd>wincmd h<cr>', { silent = true })
vim.keymap.set('n', '<a-j>', '<cmd>wincmd j<cr>', { silent = true })
vim.keymap.set('n', '<a-k>', '<cmd>wincmd k<cr>', { silent = true })
vim.keymap.set('n', '<a-l>', '<cmd>wincmd l<cr>', { silent = true })

-- Save buffers
vim.keymap.set('n', '<c-s>', '<cmd>w<cr>')
vim.keymap.set('n', '<a-s>', '<cmd>wa<cr>')

-- Enter to insert newline
vim.keymap.set('n', '<cr>', 'o<esc>', { silent = true })

-- Bind redo Kate style
vim.keymap.set('n', '<s-u>', '<c-r>', { silent = true })

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev,         { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next,         { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>f', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- Lazy setup
require('lazy').setup({
  -- [[ Look & feel ]]
  -- Themes
  { 'catppuccin/nvim',
    name = 'catppuccin',
    lazy = false,
    priority = 1000,
    opts = {},
    config = function()
      require('catppuccin').setup({
        --transparent_background = true,
        flavour = 'mocha',
        styles = {
          --comments = {},
        },
      })
      vim.cmd.colorscheme 'catppuccin'
    end,
  },

  -- Library
  'nvim-lua/plenary.nvim',
  'MunifTanjim/nui.nvim',

  -- Icons
  'nvim-tree/nvim-web-devicons',

  -- Tabs
  {
    'romgrk/barbar.nvim',
    config = function()
      vim.keymap.set('n', '<a-z>',   '<cmd>BufferPrevious<cr>',     { silent = true })
      vim.keymap.set('n', '<a-x>',   '<cmd>BufferNext<cr>',         { silent = true })
      vim.keymap.set('n', '<a-s-z>', '<cmd>BufferMovePrevious<cr>', { silent = true })
      vim.keymap.set('n', '<a-s-x>', '<cmd>BufferMoveNext<cr>',     { silent = true })
      vim.keymap.set('n', '<a-c>',   '<cmd>BufferClose<cr>',        { silent = true })
      vim.keymap.set('n', '<a-s-c>', '<cmd>BufferRestore<cr>',      { silent = true })
      vim.keymap.set('n', '<a-t>',   '<cmd>BufferPick<cr>',         { silent = true })
    end
  },

  -- File explorer
  {
    'nvim-tree/nvim-tree.lua',
    opts = {
      renderer = {
        group_empty = true,
        indent_width = 2,
        indent_markers = {
          enable = true,
          inline_arrows = false,
        },
      },
      git = {
        ignore = false,
      },
      view = {
        number = true,
        float = {
          enable = true,
          open_win_config = {
            width = 80,
            height = 100
          },
        },
      },
      filters = {
        dotfiles = false
      },
    },
    config = function()
      vim.g.loaded_netrw       = 1
      vim.g.loaded_netrwPlugin = 1

      require('nvim-tree').setup({
          renderer = { group_empty = true, indent_width = 2, indent_markers = { enable = true, inline_arrows = false } },
          git = { ignore = false },
          view = { number = true, float = { enable = true, open_win_config = { width = 80, height = 100 } } },
          filters = { dotfiles = false },
      })

      vim.keymap.set('n', '<leader>e', '<cmd>NvimTreeOpen<cr>', { desc = 'Open File [E]xplorer' })
    end
  },

  -- Status line
  {
    'nvim-lualine/lualine.nvim',
    opts = {
      options = {
        component_separators = '|',
        section_separators = '',
      },
      sections = {
        lualine_a = {'mode'},
        lualine_b = {'branch', 'diff', 'diagnostics'},
        lualine_c = {{
          'filename',
          path = 3,
        }},
        lualine_x = {'encoding', 'fileformat', 'filetype'},
        lualine_y = {'progress'},
        lualine_z = {'location'}
      },
      inactive_sections = {
        lualine_c = {'filename'},
        lualine_x = {'location'},
      },
    },
  },

  -- [[ IDE plugins ]]
  -- Treesitter
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter.configs').setup({
        ensure_installed = { 'c', 'cpp', 'go', 'lua', 'python', 'rust', 'tsx', 'javascript', 'typescript', 'vimdoc', 'vim' },
        auto_install = true,

        highlight = { enable = true },
        indent = { enable = true },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = '<c-space>',
            node_incremental = '<c-space>',
            scope_incremental = '<c-s>',
            node_decremental = '<M-space>',
          },
        },
        textobjects = {
          select = {
            enable = true,
            lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
            keymaps = {
              -- You can use the capture groups defined in textobjects.scm
              ['aa'] = '@parameter.outer',
              ['ia'] = '@parameter.inner',
              ['af'] = '@function.outer',
              ['if'] = '@function.inner',
              ['ac'] = '@class.outer',
              ['ic'] = '@class.inner',
            },
          },
          move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
              [']m'] = '@function.outer',
              [']]'] = '@class.outer',
            },
            goto_next_end = {
              [']M'] = '@function.outer',
              [']['] = '@class.outer',
            },
            goto_previous_start = {
              ['[m'] = '@function.outer',
              ['[['] = '@class.outer',
            },
            goto_previous_end = {
              ['[M'] = '@function.outer',
              ['[]'] = '@class.outer',
            },
          },
          swap = {
            enable = true,
            swap_next = {
              ['<leader>a'] = '@parameter.inner',
            },
            swap_previous = {
              ['<leader>A'] = '@parameter.inner',
            },
          },
        },
      })
    end
  },

  { 'nvim-treesitter/nvim-treesitter-context', opts = {} },
  'nvim-treesitter/nvim-treesitter-textobjects',

  -- LSP
  {
    'neovim/nvim-lspconfig',
    config = function()
      local nvim_cmp_lsp = require('cmp_nvim_lsp')
      local capabilities = nvim_cmp_lsp.default_capabilities()
      local lc = require('lspconfig')

      --lc['clangd'].setup {
      --  capabilities = capabilities,
      --  settings = {
      --    clangd = {
      --      semanticHighlighting = true,
      --    },
      --  },
      --  on_attach = function(c)
      --    --ceih = require("clangd_extensions.inlay_hints")
      --    --ceih.setup_autocmd()
      --    --ceih.set_inlay_hints()
      --  end,
      --}

      --lc['zls'].setup {
      --  capabilities = capabilities,
      --  settings = {
      --  },
      --  on_attach = function(c)
      --  end,
      --}

      ---- require('clangd_extensions').prepare({
      ---- })

      --lc['svelte'].setup {
      --  capabilities = capabilities,
      --  settings = {
      --    svelte = {
      --      plugin = {
      --        html = {
      --          completions = { enable = true }
      --        },
      --      },
      --      ['enable-ts-plugin'] = true,
      --    },
      --  },
      --  on_attach = function(client)
      --    vim.api.nvim_create_autocmd('BufWritePost', {
      --      pattern = { '*.js', '*.ts' },
      --      callback = function(ctx)
      --        client.notify('$/onDidChangeTsOrJsFile', { uri = ctx.file })
      --      end,
      --    })
      --  end,
      --}

      --lc['ts_ls'].setup {
      --  capabilities = capabilities
      --}

      --lc['emmet_language_server'].setup {
      --  capabilities = capabilities,
      --  filetypes = { 'css', 'eruby', 'html', 'javascript', 'javascriptreact', 'less', 'sass', 'scss', 'pug', 'typescriptreact', 'vue' }, -- removed svelte since svelte has its own
      --}

      -- More lspconfig setup

      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspConfig', {}),
        callback = function(ev)
          -- Enable completion triggered by <c-x><c-o>
          vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

          -- Buffer local mappings.
          -- See `:help vim.lsp.*` for documentation on any of the below functions
          local opts = { buffer = ev.buf }
          
          vim.keymap.set('n', '<F2>', vim.lsp.buf.rename, opts)
          vim.keymap.set('n', '<leader>]', vim.diagnostic.goto_next)
          vim.keymap.set('n', '<leader>[', vim.diagnostic.goto_prev)
          vim.keymap.set('n', '<leader>\\', function () vim.diagnostic.open_float(nil, {focus=false}) end)
          vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
          vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
          vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
          vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
          vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
          vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
          vim.keymap.set('n', '<space>wl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          end, opts)
          vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
        end,
      })

      -- local updated_capabilities = vim.lsp.protocol.make_client_capabilities()
      -- updated_capabilities.workspace.didChangeWatchedFiles = {
      --   dynamicRegistration = true,
      --   relativePatternSupport = true,
      -- }
    end
  },

  {
    'williamboman/mason.nvim',
    config = function()
      require('mason').setup() 
    end
  },

  {
    'williamboman/mason-lspconfig.nvim',
    config = function()
      require('mason-lspconfig').setup()
    end
  },

  { 'j-hui/fidget.nvim', tag = 'legacy', opts = {} },
  { 'folke/neodev.nvim', opts = {} },

  -- Completion
  {
    'hrsh7th/nvim-cmp',
    config = function()
      local cmp = require('cmp')

      cmp.setup({
        enabled = function()
          -- disable completion in comments
          local context = require 'cmp.config.context'
          -- keep command mode completion enabled when cursor is in a comment
          if vim.api.nvim_get_mode().mode == 'c' then
            return true
          else
            return not context.in_treesitter_capture('comment') 
              and not context.in_syntax_group('Comment')
          end
        end,
        snippet = {
          expand = function(args)
            require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-k>'] = cmp.mapping.select_prev_item(),
          ['<C-j>'] = cmp.mapping.select_next_item(),
          ['<C-Space>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
        },
        {
          { name = 'buffer' },
        }),
        performance = {
          debounce = 250,
          -- max_view_entries = 10,
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        }
      })

      -- Set configuration for specific filetype.
      cmp.setup.filetype('gitcommit', {
        sources = cmp.config.sources({
          { name = 'git' }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
        }, {
          { name = 'buffer' },
        })
      })

      -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline({ '/', '?' }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = 'buffer' }
        }
      })

      -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = 'path' }
        }, {
          { name = 'cmdline' }
        })
      })
    end
  },

  'hrsh7th/cmp-nvim-lsp',
  'hrsh7th/cmp-buffer',
  'hrsh7th/cmp-path',
  'hrsh7th/cmp-cmdline',
  'L3MON4D3/LuaSnip',
  'saadparwaiz1/cmp_luasnip',

  -- { 'rafamadriz/friendly-snippets' },
  {
    'p00f/clangd_extensions.nvim',
    config = function()
      require("clangd_extensions").setup({
        --[[
        inlay_hints = {
          inline = vim.fn.has("nvim-0.10") == 1,
          only_current_line = false,
          only_current_line_autocmd = { "CursorHold" },
          show_parameter_hints = true,
          parameter_hints_prefix = "<- ",
          other_hints_prefix = "=> ",
          max_len_align = false,
          max_len_align_padding = 1,
          right_align = true,
          right_align_padding = 7,
          highlight = "Comment",
          priority = 100,
        },
        ]]--
        ast = {
          role_icons = {
            type = "🄣",
            declaration = "🄓",
            expression = "🄔",
            statement = ";",
            specifier = "🄢",
            ["template argument"] = "🆃",
          },
          kind_icons = {
            Compound = "🄲",
            Recovery = "🅁",
            TranslationUnit = "🅄",
            PackExpansion = "🄿",
            TemplateTypeParm = "🅃",
            TemplateTemplateParm = "🅃",
            TemplateParamObject = "🅃",
          },
          highlights = {
            detail = "Comment",
          },
        },
        memory_usage = {
          border = "none",
        },
        symbol_info = {
          border = "none",
        },
      })
    end
  },

  -- Integration Development
  'skywind3000/asyncrun.vim',

  -- Debugging
  {
    'mfussenegger/nvim-dap',
    config = function()
      local dap      = require('dap')
      local dapui    = require('dapui')
      local dapvtext = require('nvim-dap-virtual-text')

      dapui.setup()
      dapvtext.setup()

      local dconf = {
        {
          name = 'Launch file',
          type = 'codelldb',
          request = 'launch',
          program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
          end,
          cwd = '${workspaceFolder}',
          stopOnEntry = false,
        },
      }
      dap.adapters.codelldb = {
        type = 'server',
        host = '127.0.0.1',
        port = '13000',
        executable = {
          -- USE MASON
          command = vim.fn.stdpath('data') .. '/mason/bin/codelldb',
          args = {'--port', '13000'},
          -- On windows you may have to uncomment this:
          -- detached = false,
        }
      }
      dap.configurations.cpp = {
        {
          name = 'Launch file',
          type = 'codelldb',
          request = 'launch',
          program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
          end,
          arg = function()
            return vim.fn.input('Arguments:')
          end,
          cwd = '${workspaceFolder}',
          stopOnEntry = false,
        },
      }
      dap.configurations.c = dap.configurations.cpp

      vim.keymap.set('n', '<leader><F2>',  function() dap.toggle_breakpoint() end)
      vim.keymap.set('n', '<leader><F6>',  function() dap.step_into() end)
      vim.keymap.set('n', '<leader><F7>',  function() dap.step_over() end)
      vim.keymap.set('n', '<leader><F8>',  function() dap.continue() end)
      vim.keymap.set('n', '<leader><F9>', function() dap.repl.open() end)
      vim.keymap.set('n', '<leader><F10>', function() dapui.toggle() end)

      dap.listeners.after.event_initialized['dapui_config'] = function() dapui.open() end
      dap.listeners.before.event_terminated['dapui_config'] = function() dapui.close() end
      dap.listeners.before.event_exited['dapui_config']     = function() dapui.close() end
    end
  },

  'nvim-neotest/nvim-nio',
  { "rcarriga/nvim-dap-ui", dependencies = {"mfussenegger/nvim-dap", "nvim-neotest/nvim-nio"} },
  'theHamsta/nvim-dap-virtual-text',

  -- Indent detection
  'tpope/vim-sleuth',

  -- Indentation lines
  {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    config = function()
      -- Config Indent highlight
      local highlight = {
          'RainbowRed',
          'RainbowYellow',
          'RainbowBlue',
          'RainbowOrange',
          'RainbowGreen',
          'RainbowViolet',
          'RainbowCyan',
      }

      local hooks = require 'ibl.hooks'
      -- create the highlight groups in the highlight setup hook, so they are reset
      -- every time the colorscheme changes
      hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
          vim.api.nvim_set_hl(0, 'RainbowRed',    { fg = '#E06C75' })
          vim.api.nvim_set_hl(0, 'RainbowYellow', { fg = '#E5C07B' })
          vim.api.nvim_set_hl(0, 'RainbowBlue',   { fg = '#61AFEF' })
          vim.api.nvim_set_hl(0, 'RainbowOrange', { fg = '#D19A66' })
          vim.api.nvim_set_hl(0, 'RainbowGreen',  { fg = '#98C379' })
          vim.api.nvim_set_hl(0, 'RainbowViolet', { fg = '#C678DD' })
          vim.api.nvim_set_hl(0, 'RainbowCyan',   { fg = '#56B6C2' })
      end)

      require('ibl').setup {
        indent = {
          char = '┋', --'│',
          highlight = highlight
        },
        scope = {
          -- This is the horizontal bar
          enabled = false,
          show_start = false,
          show_end = false,
        },
      }
    end
  },

  -- 'tpope/vim-fugitive',
  -- 'tpope/vim-rhubarb',
  'tpope/vim-ragtag',

  -- Git
  {
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add          = { text = '+' },
        change       = { text = '~' },
        delete       = { text = '_' },
        topdelete    = { text = '‾' },
        changedelete = { text = '~' },
        -- untracked    = { text = '┆' },
      },
      on_attach = function(bufnr)
        local gs = require('gitsigns')
        keymap {
          -- Actions
          {'n', '<leader>hp', gs.preview_hunk, { buffer = bufnr, desc = 'Preview git hunk' }},

          -- Navigation
          {{'n', 'v'}, ']c', function()
            if vim.wo.diff then return ']c' end
            vim.schedule(function() gs.next_hunk() end)
            return '<Ignore>'
          end, { expr = true, buffer = bufnr, desc = 'Jump to next hunk' }},

          {{'n', 'v'}, '[c', function()
            if vim.wo.diff then return '[c' end
            vim.schedule(function() gs.prev_hunk() end)
            return '<Ignore>'
          end, { expr = true, buffer = bufnr, desc = 'Jump to previous hunk' }}
        }
      end,
    },
  },

  -- Telescope
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    opts = {
      defaults = {
        mappings = {
          i = {
            ['<C-u>'] = false,
            ['<C-d>'] = false,
          },
        },
      },
    },
    config = function()
      vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles,      { desc = '[?] Find recently opened files' })
      vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
      vim.keymap.set('n', '<leader>/', function()
          -- You can pass additional configuration to telescope to change theme, layout, etc.
          require('telescope.builtin').current_buffer_fuzzy_find(
            require('telescope.themes').get_dropdown {
              winblend = 10,
              previewer = false,
          })
        end, { desc = '[/] Fuzzily search in current buffer' })

      vim.keymap.set('n', '<leader>gf', require('telescope.builtin').git_files,   { desc = 'Search [G]it [F]iles' })
      vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files,  { desc = '[S]earch [F]iles' })
      vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags,   { desc = '[S]earch [H]elp' })
      vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
      vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep,   { desc = '[S]earch by [G]rep' })
      vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
      vim.keymap.set('n', '<leader>sr', require('telescope.builtin').resume,      { desc = '[S]earch [R]resume' })

      pcall(require('telescope').load_extension, 'fzf')
    end
  },

  {
    'nvim-telescope/telescope-fzf-native.nvim',
    build = 'make',
    cond = function()
      return vim.fn.executable('make') == 1
    end,
  },

  -- Smooth scroll
  'psliwka/vim-smoothie',

  -- Keymap preview
  { 'folke/which-key.nvim', opts = {} },

  -- Scope Highlighter
  {
    'HiPhish/rainbow-delimiters.nvim',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
    },
  },

  -- [[ Code editing ]]
  -- Language
  {
    'leafOfTree/vim-svelte-plugin',
    config = function()
      vim.g.vim_svelte_plugin_use_typescript = 1
      vim.g.vim_svelte_plugin_open_devdocs = 0
    end
  },

  {
    'ziglang/zig.vim',
    config = function()
      vim.g.zig_fmt_autosave = 0
    end
  },

  {
    'bfrg/vim-cpp-modern',
    config = function()
      vim.g.cpp_function_highlight   = 1
      vim.g.cpp_attributes_highlight = 1
      vim.g.cpp_member_highlight     = 1
      vim.g.cpp_simple_highlight     = 1
    end
  },

  -- Auto pair parentheses
  { 'windwp/nvim-autopairs', opts = {} }, -- requires nvim-cmp

  -- Comment plugin
  { 'numToStr/Comment.nvim', opts = {} },

  -- Multi-case, regex replace
  'tpope/vim-abolish',

  -- -- "." repeating
  -- { 'tpope/vim-repeat' },

  -- Align plugin
  {
    'junegunn/vim-easy-align',
    config = function()
      vim.keymap.set('x', 'ga', '<plug>(EasyAlign)', { silent = true })
      vim.keymap.set('n', 'ga', '<plug>(EasyAlign)', { silent = true })
    end
  },

  -- Scope splitter / joiner
  {
    'Wansmer/treesj',
    keys = { '<space>m', '<space>j', '<space>s' },
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
      require('treesj').setup({--[[ your config ]]})
    end,
  },
})
