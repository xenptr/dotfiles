return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
	},
	{
		"LazyVim/LazyVim",
		opts = {
			colorscheme = "catppuccin-mocha",
		},
	},
}

-- return {
-- 	{
-- 		"navarasu/onedark.nvim",
-- 		priority = 1000,
-- 		config = function()
-- 			require("onedark").setup({
-- 				style = "darker", -- options: dark, darker, cool, deep, warm, warmer
-- 			})
-- 			require("onedark").load()
-- 		end,
-- 	},
-- 	{
-- 		"LazyVim/LazyVim",
-- 		opts = {
-- 			colorscheme = "onedark",
-- 		},
-- 	},
-- }

-- return {
--   {
--     "catppuccin/nvim",
--     lazy = false,
--     name = "catppuccin",
--     priority = 1000,

--     config = function()
--       require("catppuccin").setup({
--         transparent_background = true,
--       })
--       vim.cmd.colorscheme "catppuccin-mocha"
--     end
--   }
-- }
