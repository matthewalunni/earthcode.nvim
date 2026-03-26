-- Adds the plugin root to runtimepath so require("earthcode.*") works
vim.opt.runtimepath:prepend(vim.fn.getcwd())
