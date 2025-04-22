return {
	"Blovio/512-words",
	config = function()
		require("512-words").setup({
			storage_directory = "~",
		})
	end,
}
