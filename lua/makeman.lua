-- make a function to list makefile targets
local function list_targets(directory)
	local targets = {}

	for line in io.lines(directory) do
		if string.find(line, "^[a-zA-Z0-9_]+:") then
			line = string.gsub(line, ":[^:]*", "")
			table.insert(targets, line)
		end
	end

	return targets
end

-- make a fucntion to search for a makefile in the current working directory
local function search_makefile()
	local cwd = vim.fn.getcwd()
	local makefile = cwd .. "/Makefile"

	if vim.fn.filereadable(makefile) == 1 then
		return makefile
	end

	makefile = cwd .. "/makefile"

	if vim.fn.filereadable(makefile) == 1 then
		return makefile
	end

	-- TODO: make a search on the lsp cwd
	return nil
end

-- make a function that run a makefile target in a separate tmux panel
local function execute_target(target, mode)
	vim.fn.jobstart({ "tmux", "new-window", "make " .. target .. " | less" })
end

-- our picker function: colors
local run = function()
	-- main module which is used to create a new picker.
	local pickers = require("telescope.pickers")
	-- provides interfaces to fill the picker with items.
	local finders = require("telescope.finders")
	-- table which holds telescope's configuration.
	local conf = require("telescope.config").values
	-- to control telescope actions when selecting
	local actions = require("telescope.actions")
	local action_state = require("telescope.actions.state")

	local file = search_makefile()

	if file == nil then
		print("No makefile found")
		return
	end

	local targets = list_targets(file)

	pickers
		.new({}, {
			prompt_title = "Makefile targets",
			-- fill with makefile targets
			finder = finders.new_table({ results = targets }),
			-- change default mappings
			attach_mappings = function(prompt_bufnr, _)
				actions.select_default:replace(function()
					actions.close(prompt_bufnr)
					local selection = action_state.get_selected_entry()[1]
					execute_target(selection)
				end)
				return true
			end,
			sorter = conf.generic_sorter({}),
		})
		:find()
end

return { run = run }
