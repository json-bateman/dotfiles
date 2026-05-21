-- -- Making a language server
-- vim.lsp.set_log_level("debug")
-- local client = vim.lsp.start_client {
--   cmd = { "/Users/jack/Coding/customlsp/customlsp" }
-- }
--
-- if not client then
--   vim.notify "hey you didn't do the client thing good"
--   return
-- end
--
-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = "markdown",
--   callback = function()
--     vim.lsp.buf_attach_client(0, client)
--   end,
-- })

-- Wrapper to look at tables (objects) with vim.inspect
function P(table)
	print(vim.inspect(table))
	return table
end

-- Move through the quickfix list
vim.api.nvim_create_autocmd("FileType", {
	pattern = "qf",
	callback = function(event)
		local opts = { buffer = event.buf, silent = true }
		vim.keymap.set("n", "<C-n>", "<cmd>cn<CR>zz<cmd>wincmd p<CR>", opts)
		vim.keymap.set("n", "<C-p>", "<cmd>cN<CR>zz<cmd>wincmd p<CR>", opts)
	end,
})

-- Don't automatically make more comments lines on enter
vim.api.nvim_create_autocmd("BufEnter", {
	callback = function()
		vim.opt.formatoptions = vim.opt.formatoptions - { "c", "r", "o" }
	end,
})

-- -- Write file when moving between splits
-- vim.api.nvim_create_autocmd("BufLeave",
--   {
--     command = 'wall'
--   }
-- )

-- Highlights yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank({ higroup = "Question", timeout = 300 })
	end,
})

-- Write and quit typos
local typos = { "W", "Wq", "WQ", "Wqa", "WQa", "WQA", "WqA", "Q", "Qa", "QA" }
for _, cmd in ipairs(typos) do
	vim.api.nvim_create_user_command(cmd, function(opts)
		vim.api.nvim_cmd({
			cmd = cmd:lower(),
			bang = opts.bang,
			mods = { noautocmd = true },
		}, {})
	end, { bang = true })
end

-- Matching function to jump from beginning tag to end like html (i.e. <div></div>)
-- .html has a builtin plugin for this in vim, so this is just for .templ files
local function jumpTagStartTagEnd()
	local node = vim.treesitter.get_node()
	if not node then
		vim.cmd("normal! %")
		return
	end

	-- Walk up to find tag_start or tag_end
	local tag_node = node
	while tag_node do
		local type = tag_node:type()
		if type == "tag_start" or type == "tag_end" then
			break
		end
		tag_node = tag_node:parent()
	end

	-- No tag found, fall back to default %
	if not tag_node then
		vim.cmd("normal! %")
		return
	end

	local parent = tag_node:parent()
	if not parent or parent:type() ~= "element" then
		vim.cmd("normal! %")
		return
	end

	local target
	if tag_node:type() == "tag_start" then
		for child in parent:iter_children() do
			if child:type() == "tag_end" then
				target = child
			end
		end
	else
		for child in parent:iter_children() do
			if child:type() == "tag_start" then
				target = child
				break
			end
		end
	end

	if target then
		local row, col = target:start()
		vim.api.nvim_win_set_cursor(0, { row + 1, col })
	else
		vim.cmd("normal! %")
	end
end

vim.api.nvim_create_autocmd("FileType", {
	pattern = "templ",
	callback = function()
		vim.keymap.set("n", "%", jumpTagStartTagEnd, { buffer = true })
	end,
})
