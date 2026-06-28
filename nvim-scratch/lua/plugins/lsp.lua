return {
  "neovim/nvim-lspconfig",
  dependencies = { 
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
  },
  config = function()
    -- 1. The new Neovim 0.11+ way to start the server
	vim.lsp.enable("vtsls")

    -- 2. Your keymaps
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('UserLspConfig', {}),
      callback = function(ev)
        local opts = { buffer = ev.buf }
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
        vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts)

        -- 3. Format code automatically when you save
        vim.api.nvim_create_autocmd("BufWritePre", {
          buffer = ev.buf,
          callback = function()
            vim.lsp.buf.format({ async = false })
          end,
        })
      end,
    })
  end
}
