--[[
 ________
| |____| |
| keymap |
|  (__)  |
|________|

]]

--[[
  Modes:
    Normal       = "n"
    Insert       = "i"
    Visual       = "v"
    Visual_Block = "x"
    Terminal     = "t"
    Command      = "c"
]]

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

keymap("n", "<leader>E", "<CMD>edit $MYVIMRC<CR>", opts)
keymap("n", "<leader>W", "<CMD>w<CR><CMD>so%<CR>", opts)

keymap("n", "s", "<c-w>", opts)
keymap("n", "<leader>cc", "<CMD>cclose<CR>", opts)
keymap("n", "<leader>co", "<CMD>copen<CR>", opts)
keymap("n", "<C-d>", "<C-d>zz", opts)
keymap("n", "<C-u>", "<C-u>zz", opts)
keymap("n", "<leader>cj", "<CMD>clearjumps<CR>", opts)
keymap("n", "<leader>q", "<CMD>:bd<CR>", opts)

keymap("c", "%%", "<C-R>=expand('%:h')<CR>", opts)

-- Terminal Stuff
keymap("n", "term", "<CMD>:terminal<CR>a", opts)
keymap("t", "qq", "<C-\\><C-N>:q!<CR>", opts)
keymap("t", "<Esc>", "<C-\\><C-N>", opts)

-- Tab Stuff
keymap("n", "<leader>tt", "<CMD>tabnew<CR>", opts)
keymap("n", "<leader>tc", "<CMD>tabclose<CR>", opts)
keymap("n", "<leader>to", "<CMD>tabonly<CR>", opts)

-- Copy / Paste outside nvim
keymap("v", "<leader>y", '"+y', opts)
keymap("n", "<leader>p", '"+p', opts)
keymap("v", "<leader>p", '"+p', opts)

keymap("n", "gs", ":%s~~", opts)
keymap("v", "gs", ":s~~", opts)

-- Custom Functions
keymap("n", "<leader>yo", function()
	vim.ui.input({ prompt = "Command to yank output: " }, function(cmd)
		if cmd and #cmd > 0 then
			vim.cmd("redir @+")
			vim.cmd("silent " .. cmd)
			vim.cmd("redir END")
			vim.notify("Output of :" .. cmd .. " copied to clipboard!", vim.log.levels.INFO)
		else
			vim.notify("No command entered.", vim.log.levels.WARN)
		end
	end)
end, { desc = "Yank output of any Ex command to clipboard" })

keymap("n", "<leader>x", "<Esc>:bprevious<bar>bdelete #<CR>", opts)
keymap("n", "<leader>X", function()
	local current_buf = vim.api.nvim_get_current_buf()
	local last = vim.fn.bufnr("$")
	local delete_count = 0

	-- Delete every buffer but the current one
	for n = 1, last do
		if n ~= current_buf and vim.fn.buflisted(n) == 1 then
			local ok = pcall(vim.api.nvim_buf_delete, n, { force = true })
			if ok and vim.fn.buflisted(n) == 0 then
				delete_count = delete_count + 1
			end
		end
	end

	if delete_count == 1 then
		vim.notify("1 buffer deleted")
	elseif delete_count > 1 then
		vim.notify(delete_count .. " buffers deleted")
	end
end, { desc = "Buffer: Keep current buffer only." })
