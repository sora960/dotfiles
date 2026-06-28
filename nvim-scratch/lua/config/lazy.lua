local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- If lazy isn't installed, clone it
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({ "git", "clone", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end

-- Add lazy to the runtime path
vim.opt.rtp:prepend(lazypath)

-- Setup lazy
require("lazy").setup({
  spec = { { import = "plugins" } },
  -- You can even remove the checker/install lines if you want it super clean
})
