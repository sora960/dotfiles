return {
	-- Auto-close brackets, quotes, parentheticals
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = function()
			require("nvim-autopairs").setup({
				check_ts = true, -- Enable Treesitter integration
			})
		end,
	},

	-- Manipulate surroundings: cs"' changes "text" to 'text', ysaw) wraps word in ()
	{
		"kylechui/nvim-surround",
		version = "*",
		event = "VeryLazy",
		opts = {},
	},

	-- Comment lines quickly with gcc or visual gc
	{
		"numToStr/Comment.nvim",
		event = { "BufReadPre", "BufNewFile" },
		opts = {},
	},
}
