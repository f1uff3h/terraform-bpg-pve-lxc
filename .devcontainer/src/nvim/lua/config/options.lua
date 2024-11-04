LazyVim.terminal.setup("nu")

local opt = vim.opt

opt.spell = true
opt.spelllang = "en_us"
opt.wrap = true

vim.filetype.add({
	pattern = {
		[".*[C|c]ontainerfile.*"] = "dockerfile",
	},
})
