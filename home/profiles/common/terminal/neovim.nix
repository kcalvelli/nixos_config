{ 
  config, 
  pkgs, 
  lib, 
  ... 
}:
{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    withNodeJs = true;
    withPython3 = true;
    withRuby = false;

    plugins = with pkgs.vimPlugins; [
      which-key-nvim
      nvim-web-devicons
      lualine-nvim
      gitsigns-nvim
      telescope-nvim
      telescope-fzf-native-nvim

      # Treesitter with Nix-bundled parsers to avoid runtime writes
      (pkgs.vimPlugins.nvim-treesitter.withPlugins (p: [
        p.lua p.vim p.vimdoc p.nix p.rust p.zig p.python
        p.javascript p.typescript p.tsx p.json p.yaml p.toml
        p.bash p.markdown
      ]))
      nvim-treesitter-textobjects

      nvim-lspconfig
      nvim-cmp
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      luasnip
      cmp_luasnip
      friendly-snippets
      conform-nvim

      # AI
      copilot-vim
      copilot-cmp
      codecompanion-nvim
      nui-nvim
      plenary-nvim
    ];

    extraLuaConfig = ''
        ------------------------------------------------------------
        -- Palette for #080C12 bg
        ------------------------------------------------------------
        local P = {
          bg      = "#080C12",
          base    = "#e0e4e9",
          dim     = "#9ca4ae",
          mute    = "#2a3a4e",
          dir     = "#b3d4ff",
          cyan    = "#86e8ef",
          green   = "#7fe0b4",
          yellow  = "#f5e38a",
          red     = "#ff9e9e",
          magenta = "#cba6f7",
        }
        vim.opt.termguicolors = true
        vim.cmd("highlight Normal guibg="..P.bg.." guifg="..P.base)
        vim.cmd("highlight Comment guifg="..P.mute)
        vim.cmd("highlight LineNr guifg="..P.mute)
        vim.cmd("highlight CursorLineNr guifg="..P.dir)
        vim.cmd("highlight Visual guibg="..P.mute)
        vim.cmd("highlight Search guifg="..P.bg.." guibg="..P.yellow.." gui=bold")
        vim.cmd("highlight IncSearch guifg="..P.bg.." guibg="..P.cyan.." gui=bold")
        vim.cmd("highlight VertSplit guifg="..P.mute.." guibg="..P.bg)
        vim.cmd("highlight StatusLine guifg="..P.bg.." guibg="..P.dir.." gui=bold")
        vim.cmd("highlight StatusLineNC guifg="..P.bg.." guibg="..P.mute)

        ------------------------------------------------------------
        -- Core UX
        ------------------------------------------------------------
        local o = vim.opt
        o.number = true
        o.relativenumber = true
        o.mouse = "a"
        o.clipboard = "unnamedplus"
        o.ignorecase = true
        o.smartcase = true
        o.hidden = true
        o.undofile = true
        o.updatetime = 300
        o.scrolloff = 3
        o.sidescrolloff = 5
        o.expandtab = true
        o.shiftwidth = 2
        o.tabstop = 2
        o.splitbelow = true
        o.splitright = true
        o.signcolumn = "yes"
        vim.g.mapleader = " "
        vim.g.maplocalleader = " "

        require("which-key").setup({})

        -- Lualine
        local lualine = require("lualine")
        local theme = {
          normal =   { a={fg=P.bg, bg=P.dir, gui="bold"}, b={fg=P.base, bg=P.mute}, c={fg=P.base, bg=P.bg} },
          insert =   { a={fg=P.bg, bg=P.green, gui="bold"}, b={fg=P.base, bg=P.mute}, c={fg=P.base, bg=P.bg} },
          visual =   { a={fg=P.bg, bg=P.cyan, gui="bold"},  b={fg=P.base, bg=P.mute}, c={fg=P.base, bg=P.bg} },
          replace =  { a={fg=P.bg, bg=P.red, gui="bold"},   b={fg=P.base, bg=P.mute}, c={fg=P.base, bg=P.bg} },
          command =  { a={fg=P.bg, bg=P.yellow, gui="bold"},b={fg=P.base, bg=P.mute}, c={fg=P.base, bg=P.bg} },
          inactive = { a={fg=P.dim, bg=P.mute},             b={fg=P.dim, bg=P.mute},  c={fg=P.dim, bg=P.bg} },
        }
        lualine.setup({
          options = { theme = theme, globalstatus = true, section_separators = "", component_separators = "" },
          sections = {
            lualine_a = { "mode" },
            lualine_b = { "branch", "diff", {"diagnostics", symbols={ error="✖ ", warn="▲ ", info="● ", hint=" "}} },
            lualine_c = { {"filename", path=1} },
            lualine_x = { "encoding", "filetype" },
            lualine_y = { "progress" },
            lualine_z = { "location" },
          },
        })

        -- Telescope
        require("telescope").setup({
          defaults = {
            prompt_prefix = "   ",
            selection_caret = "➤ ",
            layout_config = { horizontal = { preview_width = 0.6 } },
          },
          pickers = { buffers = { sort_lastused = true, theme = "dropdown" } },
          extensions = { fzf = { fuzzy = true, override_generic_sorter = true, override_file_sorter = true, case_mode = "smart_case" } },
        })
        pcall(require("telescope").load_extension, "fzf")

        -- Treesitter (Nix-bundled parsers; no runtime installs)
        require("nvim-treesitter.configs").setup({
          highlight = { enable = true },
          indent = { enable = true },
          incremental_selection = { enable = true },
          textobjects = { select = { enable = true } },

          auto_install = false,
          sync_install = false,
          ensure_installed = {},  -- parsers supplied by Nix
          -- If you ever want runtime installs:
          -- parser_install_dir = vim.fn.stdpath("data") .. "/parsers",
        })

        -- Completion
        local cmp = require("cmp")
        local luasnip = require("luasnip")
        require("luasnip.loaders.from_vscode").lazy_load()

        -- Copilot cmp source (comes from copilot-cmp)
        local ok_copilot, copilot_cmp = pcall(require, "copilot_cmp")
        if ok_copilot then copilot_cmp.setup() end

        cmp.setup({
          snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
          mapping = cmp.mapping.preset.insert({
            ["<C-n>"] = cmp.mapping.select_next_item(),
            ["<C-p>"] = cmp.mapping.select_prev_item(),
            ["<C-d>"] = cmp.mapping.scroll_docs(-4),
            ["<C-f>"] = cmp.mapping.scroll_docs(4),
            ["<C-Space>"] = cmp.mapping.complete(),
            ["<CR>"] = cmp.mapping.confirm({ select = true }),
            ["<Tab>"] = cmp.mapping(function(fallback)
              if cmp.visible() then cmp.select_next_item()
              elseif luasnip.expand_or_locally_jumpable() then luasnip.expand_or_jump()
              else fallback() end
            end, { "i", "s" }),
            ["<S-Tab>"] = cmp.mapping(function(fallback)
              if cmp.visible() then cmp.select_prev_item()
              elseif luasnip.locally_jumpable(-1) then luasnip.jump(-1)
              else fallback() end
            end, { "i", "s" }),
          }),
          sources = cmp.config.sources({
            { name = "copilot", group_index = 1, priority = 1000 },  -- Copilot first
            { name = "nvim_lsp" }, { name = "luasnip" },
          }, {
            { name = "path" }, { name = "buffer" },
          }),
          window = { documentation = cmp.config.window.bordered() },
        })

        -- LSP
        local lsp = require("lspconfig")
        local capabilities = require("cmp_nvim_lsp").default_capabilities()
        local function on_attach(_, bufnr)
          local map = function(mode, lhs, rhs, desc) vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc }) end
          map("n", "gd", vim.lsp.buf.definition,        "Goto Definition")
          map("n", "gr", vim.lsp.buf.references,        "References")
          map("n", "gi", vim.lsp.buf.implementation,    "Goto Implementation")
          map("n", "K",  vim.lsp.buf.hover,             "Hover")
          map("n", "<leader>rn", vim.lsp.buf.rename,    "Rename")
          map("n", "<leader>ca", vim.lsp.buf.code_action,"Code Action")
          map("n", "<leader>fd", function() vim.lsp.buf.format({ async = true }) end, "Format")
          map("n", "[d", vim.diagnostic.goto_prev,      "Prev Diagnostic")
          map("n", "]d", vim.diagnostic.goto_next,      "Next Diagnostic")
        end
        lsp.rust_analyzer.setup({ capabilities = capabilities, on_attach = on_attach })
        lsp.nixd.setup({ capabilities = capabilities, on_attach = on_attach })
        lsp.zls.setup({ capabilities = capabilities, on_attach = on_attach })
        lsp.pyright.setup({ capabilities = capabilities, on_attach = on_attach })
        -- tsserver deprecated -> ts_ls
        lsp.ts_ls.setup({ capabilities = capabilities, on_attach = on_attach })
        lsp.lua_ls.setup({
          capabilities = capabilities, on_attach = on_attach,
          settings = { Lua = { diagnostics = { globals = {"vim"} }, workspace = { checkThirdParty = false } } }
        })
        vim.diagnostic.config({ virtual_text = { prefix = "●" }, float = { border = "rounded" } })

        -- Gitsigns
        require("gitsigns").setup({
          signs = {
            add = { text = "▎" }, change = { text = "▎" }, delete = { text = "" },
            topdelete = { text = "" }, changedelete = { text = "▎" }
          },
        })

        -- Conform (formatters)
        require("conform").setup({
          notify_on_error = false,
          formatters_by_ft = {
            lua = { "stylua" },
            nix = { "nixfmt" },
            rust = { "rustfmt" },
            zig = { "zigfmt" },
            python = { "isort", "black" },
            javascript = { "prettier" },
            typescript = { "prettier" },
            json = { "prettier" },
            yaml = { "prettier" },
            markdown = { "prettier" },
            sh = { "shfmt" },
          },
          format_on_save = function(bufnr)
            local size = vim.api.nvim_buf_get_offset(bufnr, vim.api.nvim_buf_line_count(bufnr))
            if size > 256 * 1024 then return end
            return { timeout_ms = 1000, lsp_fallback = true }
          end,
        })

        ------------------------------------------------------------
        -- AI Integrations
        ------------------------------------------------------------
        -- GitHub Copilot (copilot.vim)
        -- Run :Copilot auth once to sign in.
        vim.g.copilot_no_tab_map = true  -- we use cmp for <Tab>
        vim.g.copilot_filetypes = {
          ["*"] = true, markdown = true, gitcommit = true,
          nix = true, rust = true, zig = true, python = true, javascript = true, typescript = true, lua = true,
        }

        -- Claude via CodeCompanion (new adapters.http API). Requires $ANTHROPIC_API_KEY.
        require("codecompanion").setup({
          adapters = {
            http = {
              anthropic = {
                opts = { api_key = os.getenv("ANTHROPIC_API_KEY") },
              },
            },
          },
          strategies = {
            chat   = { adapter = "anthropic", roles = { llm = "claude-3-5-sonnet" } },
            inline = { adapter = "anthropic", roles = { llm = "claude-3-5-sonnet" } },
          },
          display = { chat = { window = { border = "rounded" } } },
        })

        -- Handy keymaps (which-key will show them)
        local map = vim.keymap.set
        map("n", "<leader>cc", "<cmd>CodeCompanionChat<cr>", { desc="Claude Chat" })
        map({ "n", "v" }, "<leader>ca", "<cmd>CodeCompanionActions<cr>", { desc="Claude Actions" })
        map({ "n", "v" }, "<leader>ci", "<cmd>CodeCompanionInline<cr>", { desc="Claude Inline" })
    '';
  };
}
