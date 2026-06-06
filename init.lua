-- Minimalist built-in Neovim configuration with habamax
vim.o.termguicolors = true
vim.cmd.colorscheme("habamax")
vim.g.mapleader = " "
vim.o.number = true
vim.o.cursorline = true
vim.o.expandtab = true
vim.o.shiftwidth, vim.o.tabstop, vim.o.softtabstop = 2, 2, 2
vim.o.ignorecase, vim.o.smartcase = true, true
vim.o.clipboard = "unnamedplus"
vim.g.netrw_liststyle = 3
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25
vim.g.netrw_browse_split = 4   -- open files in previous window
vim.g.netrw_altv = 1           -- vertical split goes right
vim.keymap.set("n", "<leader>e", "<cmd>Lex<CR>")  -- toggle sidebar

-- vim.o.termguicolors = true
-- vim.o.expandtab = true
-- vim.o.tabstop = 2
-- vim.o.shiftwidth = 2
-- vim.o.softtabstop = 2
-- vim.o.ignorecase = true
-- vim.o.smartcase = true
--
-- vim.g.maplocalleader = "\\"
--
-- vim.o.relativenumber = true
-- vim.o.cursorline = true
-- vim.o.mouse = "a"
-- vim.o.termguicolors = true
-- vim.o.expandtab = true
-- vim.o.tabstop = 2
-- vim.o.shiftwidth = 2
-- vim.o.softtabstop = 2
-- vim.o.ignorecase = true
-- vim.o.smartcase = true
-- vim.o.scrolloff = 8
-- vim.o.signcolumn = "yes"
-- vim.o.splitbelow = true
-- vim.o.splitright = true
-- vim.o.wrap = true
-- vim.o.linebreak = true
-- vim.o.fillchars = "vert:│,eob:·"
-- vim.o.winborder = "rounded"
-- vim.o.splitkeep = "screen"
-- vim.o.smoothscroll = true
-- vim.o.undofile = true
-- vim.o.timeout = false
-- vim.o.sidescrolloff = 7
-- vim.o.sidescroll = 1
-- vim.o.autoindent = true
-- vim.opt.wildignore:append({
--   "*/node_modules/*","*/tmp/*","*/target/*","*/build/*",
-- })
--
-- local map = vim.keymap.set
-- map("n", "x", '"_x')              -- x/X to black hole
-- map("n", "X", '"_X')
-- map("n", "<c-j>", ":m .+1<CR>==") -- move line down
-- map("n", "<c-k>", ":m .-2<CR>==") -- move line up
-- map("t", "<Esc>", [[<C-\><C-n>]]) -- escape terminal
-- map("n", "<leader><tab>", "<c-^>")
-- map("n", "<leader>w", "<c-w>")
--
-- vim.filetype.add({ extension = { mal = "lisp" } })
--
-- vim.api.nvim_create_autocmd("BufReadPost", {  -- restore cursor pos
--   callback = function()
--     local m = vim.api.nvim_buf_get_mark(0, '"')
--     if m[1] > 1 and m[1] <= vim.api.nvim_buf_line_count(0) then
--       vim.api.nvim_win_set_cursor(0, m)
--     end
--   end,
-- })
--
-- vim.opt.packpath:prepend(vim.fn.stdpath("data") .. "/site")
-- vim.pack.add({
--   "https://github.com/catppuccin/nvim",
--   "https://github.com/nvim-lualine/lualine.nvim",
--   "https://github.com/zaldih/themery.nvim",
--   "https://github.com/folke/tokyonight.nvim",
--   "https://github.com/rebelot/kanagawa.nvim",
--   "https://github.com/rose-pine/neovim",
--   "https://github.com/EdenEast/nightfox.nvim",
-- })
-- vim.cmd.colorscheme("catppuccin-mocha")
-- vim.cmd("hi! WinSeparator guifg=#7aa2f7 guibg=NONE")
-- vim.cmd("hi! VertSplit    guifg=#7aa2f7 guibg=NONE")
-- require("lualine").setup({ options = { theme = "auto" } })
-- require("themery").setup({
--   themes = {
--     "catppuccin-mocha","catppuccin-latte",
--     "tokyonight-storm","tokyonight-day",
--     "kanagawa-wave","kanagawa-dragon",
--     "rose-pine","rose-pine-dawn",
--     "nightfox","duskfox","carbonfox",
--   },
--   livePreview = true,
-- })
--
-- vim.api.nvim_create_autocmd("TextYankPost", {
--   callback = function() vim.hl.on_yank() end,
-- })
--
-- vim.diagnostic.config({
--   virtual_text     = false,
--   signs            = true,
--   underline        = true,
--   update_in_insert = false,
--   severity_sort    = true,
--   float            = { border = "rounded" },
-- })
--
-- if vim.fn.executable("pyright-langserver") == 1 then
--   vim.lsp.config("pyright", {
--     cmd          = {"pyright-langserver", "--stdio"},
--     filetypes    = {"python"},
--     root_markers = {"pyproject.toml", ".git"},
--   })
--   vim.lsp.enable("pyright")
--   vim.api.nvim_create_autocmd("LspAttach", {
--     callback = function(a)
--       local b = { buffer = a.buf, silent = true }
--       vim.keymap.set("n", "K",         vim.lsp.buf.hover,         b)
--       vim.keymap.set("n", "gd",        vim.lsp.buf.definition,    b)
--       vim.keymap.set("n", "gr",        vim.lsp.buf.references,    b)
--       vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, b)
--     end,
--   })
-- end
