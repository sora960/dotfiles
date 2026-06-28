return {
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {}, 
    cmd = "Trouble",
    keys = {
      {
        "<leader>xx",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Open Error List (Trouble)",
      },
      {
        "<leader>xe",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "Current File Errors (Trouble)",
      },
    },
  }
}
