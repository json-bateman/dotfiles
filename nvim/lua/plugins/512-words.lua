return {
	dir = "~/Coding/512-words",
	config = function()
		require("512-words").setup({
			storage_directory = "~",
			file_extension = ".txt",
		})
	end,
}
