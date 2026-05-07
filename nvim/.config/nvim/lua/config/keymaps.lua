-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local utils = require("utils")

local function map(mode, lhs, rhs, opts)
  local keys = require("lazy.core.handler").handlers.keys
  ---@cast keys LazyKeysHandler
  -- do not create the keymap if a lazy keys handler exists
  if not keys.active[keys.parse({ lhs, mode = mode }).id] then
    opts = opts or {}
    opts.silent = opts.silent ~= false
    vim.keymap.set(mode, lhs, rhs, opts)
  end
end

-- better up/down
map({ "n", "x" }, "<c-k>", "v:count == 0 ? '10gk' : '10k'", { expr = true, silent = true })
map({ "n", "x" }, "<c-j>", "v:count == 0 ? '10gj' : '10j'", { expr = true, silent = true })

map("n", "<leader>\\", "<C-W>v", { desc = "Split window right" })
map("n", "<leader>-", "<C-W>s", { desc = "Split window below" })

map("n", "<leader>rw", "ea<c-w><c-r>+<esc>", { noremap = true, silent = true })
map("n", "<leader>r`", '"8di`P', { noremap = true, silent = true })
map("n", "<leader>r'", "\"8di'P", { noremap = true, silent = true })
map("n", '<leader>r"', '"8di"P', { noremap = true, silent = true })
map("n", "<leader>r)", '"8di)P', { noremap = true, silent = true })
map("n", "<leader>r]", '"8di]P', { noremap = true, silent = true })
map("n", "<leader>r}", '"8di}P', { noremap = true, silent = true })
map("n", "<leader>rt", '"8ditP', { noremap = true, silent = true })
map("n", "<", "<<", { noremap = true, silent = true, nowait = true })
map("n", ">", ">>", { noremap = true, silent = true, nowait = true })
-- map("x", "<", "<gv", { noremap = true, silent = true, nowait = true })
-- map("x", ">", ">gv", { noremap = true, silent = true, nowait = true })
-- map({ "n", "x" }, "H", "g^", { noremap = true, silent = true })
-- map({ "n", "x" }, "L", "g_", { noremap = true, silent = true })
map({ "x" }, "H", "g^", { noremap = true, silent = true })
map({ "x" }, "L", "g_", { noremap = true, silent = true })
map("x", "p", "P", { noremap = true, silent = true })
-- quit
map({ "n", "x" }, "<c-q>", "<cmd>q<cr>", { desc = "Quit All" })
map({ "n", "x" }, "Q", "<cmd>qa<cr>", { desc = "Quit All" })

-- unite
map("n", "<leader>fx", ":silent !chmod +x %<cr>", { noremap = true, silent = true })
map("n", "<leader>fX", ":silent !chmod -R a-x %<cr>", { noremap = true, silent = true })
-- map("n", "<leader>ft", [[:silent !tmux-popup<cr>]], { desc = "tmux popup" })

map(
  "n",
  "<c-f>",
  ":silent !tmux neww tmux-sessionizer<cr>",
  { noremap = true, silent = true, desc = "Projects (tmux)" }
)
map("n", "<c-g>", [[:silent !tmux neww lazygit<cr>]], { noremap = true, silent = true, desc = "Lazygit (tmux)" })

map("n", "<leader>og", [[:silent !goGitHome<cr>]], { noremap = true, silent = true, desc = "goGitHome (browser)" })

map("n", "<leader>op", function()
  utils.open_nvim_plugin_git_repo()
end, { noremap = true, silent = true, desc = "open_nvim_plugin_git_repo" })

map("n", "<leader>ob", function()
  utils.match_line_url(function(url)
    utils.open_browser(url)
  end)
end, { noremap = true, silent = true, desc = "open_url_with_browser" })

map("n", "<leader>oi", function()
  utils.match_line_url(function(url)
    local escaped_url = url:gsub("'", "'\\''")
    local cmd = string.format("!tmux new-window 'imgview \"%s\"; echo Press Enter to close...; read'", escaped_url)
    vim.cmd(cmd)
  end)
end, { noremap = true, silent = true, desc = "open image with imgview in tmux new window" })

map("n", "<leader>ol", function()
  utils.print_current_var("cword")
end, { noremap = true, silent = true, desc = "print_current_var" })

-- translator-tui: yank selection then translate
vim.keymap.set(
  "v",
  "t",
  '"ty:lua vim.fn.jobstart(string.format("tmux display-popup -E -w 75%% -h 60%% ~/.local/bin/translator-tui %s", vim.fn.shellescape(vim.fn.getreg("t"))), { detach = true })<CR>',
  { silent = true, desc = "Translate Selected" }
)
