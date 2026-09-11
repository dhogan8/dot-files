 if vim.fn.has 'nvim-0.9.0' == 1 then
  vim.loader.enable()
 end

-- nvim-treesitter (main-branch rewrite: highlighting is provided by Neovim core)
local ts_ok, ts = pcall(require, 'nvim-treesitter')
if ts_ok then
    local ensure = {
        'bash', 'dockerfile', 'go', 'html', 'javascript', 'lua', 'markdown',
        'markdown_inline', 'python', 'regex', 'ruby', 'rust', 'sql',
        'typescript', 'vim', 'yaml',
    }
    local installed = {}
    for _, lang in ipairs(ts.get_installed()) do
        installed[lang] = true
    end
    local missing = vim.tbl_filter(function(lang) return not installed[lang] end, ensure)
    if #missing > 0 then
        ts.install(missing)
    end

    -- Enable treesitter highlighting per buffer for any installed parser.
    vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('treesitter_highlight', {}),
        callback = function(ev)
            local lang = vim.treesitter.language.get_lang(ev.match) or ev.match
            local ok, added = pcall(vim.treesitter.language.add, lang)
            if ok and added then
                vim.treesitter.start(ev.buf, lang)
            end
        end,
    })
else
    vim.notify('nvim-treesitter not found. Run :PlugInstall to install plugins.', vim.log.levels.WARN)
end

vim.opt.termguicolors = true
vim.opt.mouse = "v"

require('bufferline').setup {
    options = {
        diagnostics = 'nvim_lsp',
        numbers = 'ordinal',
    }
}

-- require('virt-column').setup()

local cmp = require 'cmp'

---@diagnostic disable-next-line:redundant-parameter
cmp.setup({
    experimental = {
        ghost_text = true,
    },
    formatting = {
        format = function(entry, vim_item)
            vim_item = require('lspkind').cmp_format()(entry, vim_item)
            local alias = {
                buffer = 'buffer',
                path = 'path',
                calc = 'calc',
                emoji = 'emoji',
                nvim_lsp = 'LSP',
                luasnip = 'luasnip',
                vsnip = 'vsnip',
                nvim_lua = 'lua',
                nvim_lsp_signature_help = 'LSP Signature',
            }

            if entry.source.name == 'nvim_lsp' then
                vim_item.menu = entry.source.source.client.name
            else
                vim_item.menu = alias[entry.source.name] or entry.source.name
            end
            return vim_item
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
                -- elseif luasnip.expand_or_jumpable() then
                -- luasnip.expand_or_jump()
            else
                fallback()
            end
        end, { "i", "s" }),
    }),
    preselect = cmp.PreselectMode.None,
    view = {
        -- entries = 'native',
    },
    snippet = {
        -- REQUIRED - you must specify a snippet engine
        expand = function(args)
            -- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
            require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
            -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
            -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
        end,
    },
    sources = cmp.config.sources({
        { name = 'buffer',   priority = 7, keyword_length = 4 },
        { name = 'emoji',    priority = 3 },
        { name = 'path',     priority = 5 },
        { name = 'calc',     priority = 4 },
        { name = 'nvim_lua', priority = 9 },
        { name = 'nvim_lsp', priority = 9 },
        { name = 'luasnip',  priority = 8 },
        { name = 'lazydev',  group_index = 0 }, -- skip LuaLS completions in favor of lazydev
    }),
    window = {
        -- completion = cmp.config.window.bordered(),
        -- documentation = cmp.config.window.bordered(),
    },
})

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
        { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
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
    sources = cmp.config.sources {
        { name = 'cmdline', keyword_length = 2 },
        { name = 'nvim_lua' },
        { name = 'path' },
    },
})

-- Set up lspconfig.
-- Mappings.
vim.api.nvim_create_augroup("LspAttach_inlayhints", {})
vim.api.nvim_create_autocmd("LspAttach", {
    group = "LspAttach_inlayhints",
    callback = function(args)
        if not (args.data and args.data.client_id) then
            return
        end

        local bufnr = args.buf
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        require("lsp-inlayhints").on_attach(client, bufnr)
    end,
})

-- copied from https://github.com/neovim/nvim-lspconfig
-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
        -- Enable completion triggered by <c-x><c-o>
        vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

        -- Buffer local mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local opts = { buffer = ev.buf }
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
        vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
        vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
        vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
        vim.keymap.set('n', '<space>wl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, opts)
        vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
        vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
        vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
        vim.keymap.set('n', '<space>f', function()
            vim.lsp.buf.format { async = true }
        end, opts)
    end,
})
-- end copied from https://github.com/neovim/nvim-lspconfig


local capabilities = require('cmp_nvim_lsp').default_capabilities()

require("mason").setup()
require("mason-lspconfig").setup {
    -- v2 auto-enables every installed mason package via vim.lsp.enable(), which
    -- double-attaches servers we also configure below and resurrects removed ones.
    -- Disable it; servers are activated by the explicit lspconfig.*.setup{} calls.
    automatic_enable = false,
    ensure_installed = {
        "bashls",
        "lua_ls",
        "ts_ls",
        "yamlls",
    }
}

require("lsp-format").setup {}

local lspconfig = require('lspconfig')
lspconfig.bashls.setup {}
--lspconfig.docker_compose_language_service.setup {}
lspconfig.yamlls.setup {}

local navbuddy = require("nvim-navbuddy")
navbuddy.setup {
    lsp = {
        auto_attach = true,
        preference = nil,
    },
}

lspconfig.ts_ls.setup({})

-- lazydev loads the Neovim runtime + plugin type info into lua_ls on demand (when a
-- module is require'd), so lua_ls starts instantly instead of preloading the whole
-- runtimepath as a workspace library.
require('lazydev').setup()

lspconfig.lua_ls.setup {
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
        path = runtime_path,
      },
      diagnostics = {
        globals = { 'vim' },
      },
      workspace = {
        checkThirdParty = false,
      },
      telemetry = {
        enable = false,
      },
    },
  },
}

wildchar = "<tab>"

require("noice").setup({
    lsp = {
        -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
        override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true,
        },
        progress = {
            enabled = true,
            format = 'lsp_progress',
            format_done = 'lsp_progress_done',
            view = 'mini',
        },
    },
    messages = {
      enabled = false,
    },
    -- you can enable a preset for easier configuration
    presets = {
        bottom_search = false,    -- use a classic bottom cmdline for search
        command_palette = true,   -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = false,       -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = false,   -- add a border to hover docs and signature help
    },
})

vim.notify = require("notify")
require("notify").setup({ top_down = false });

local null_ls = require("null-ls")

null_ls.setup({
    sources = {
        null_ls.builtins.formatting.shfmt,
    },
})

require('glow').setup()

require('trouble').setup()

-- folding
-- zR - open all folds
-- zM - close all folds
-- zc - close current fold
-- zo - open current fold

vim.o.foldcolumn = '0' -- hide column by default
vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true

-- Using ufo provider need remap `zR` and `zM`. If Neovim is 0.6.1, remap yourself
vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)

require('ufo').setup({
    provider_selector = function(bufnr, filetype, buftype)
        return { 'treesitter', 'indent' }
    end
})

local wk = require("which-key")
wk.add({
    { "<leader>fc", desc = "close all folds" },
    { "<leader>ff", "<cmd>Files<cr>", desc = "open FZF file finder" },
    { "<leader>fo", desc = "open all folds" },
    { "<leader>gd", desc = "debug stuff" },
    { "<leader>gj", desc = "join the object under cursor" },
    { "<leader>gs", desc = "split the object under cursor" },
    { "<leader>gt", desc = "toggle gutter" },
    { "<leader>lh", "<cmd>DisableHL<cr>", desc = "Disable HL" },
    { "<leader>td", desc = "Trouble document diagnostics" },
    { "<leader>tw", desc = "Trouble workspace diagnostics" },
  })
wk.setup {}

-- fzf-lua
local fzf_lua = require('fzf-lua')
fzf_lua.setup({ "fzf-vim" })

-- Claude Code integration
local claude_ok, claude_code = pcall(require, 'claude-code')
if claude_ok then
  claude_code.setup()
end

fzf_lua.git_domo = function()
  fzf_lua.files({
    prompt = 'GitDomo>',
    cmd = 'git domo',
    previewer = 'bat',
  })
end

vim.cmd([[
  command! -bang GDomo lua require('fzf-lua').git_domo()
]])

-- end
