return {
  {
    'akinsho/toggleterm.nvim',
    version = "*",
    config = function()
      require("toggleterm").setup({
        open_mapping = [[<c-`>]], 
        direction = 'horizontal', -- Puts it at the bottom
        size = 15,                -- Sets a fixed height so it doesn't take half the screen
        shade_terminals = true,    -- Makes the terminal background slightly darker than your code
      })
    end
  }
}
