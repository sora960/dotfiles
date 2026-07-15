return {
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    opts = {
      -- This is the "Automatic" part you'll love
      ensure_installed = { "vtsls" },
    },
  },
}
