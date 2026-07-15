return {
  'saghen/blink.cmp',
  version = '*', -- Download the latest stable release
  opts = {
    -- 'default' keymaps: 
    -- <Up>/<Down> to select
    -- <Enter> to accept
    -- <Ctrl-n>/<Ctrl-p> to move
    keymap = { preset = 'default' },

    appearance = {
      use_nvim_cmp_as_default = true,
      nerd_font_variant = 'mono'
    },

    -- This connects your LSP (the brains) to the Menu (the UI)
    sources = {
      default = { 'lsp', 'path', 'snippets', 'buffer' },
    },
  },
}
