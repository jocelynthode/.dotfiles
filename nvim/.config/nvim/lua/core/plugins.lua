local fn = vim.fn
local utils = require("core.utils")

-- Automatically install packer
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system({
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  })
  print("Installing packer close and reopen Neovim...")
  vim.cmd([[packadd packer.nvim]])
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
local packer_user_config = vim.api.nvim_create_augroup("packer_user_config", { clear = true })

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  pattern = { "plugins.lua" },
  command = "source <afile> | PackerSync",
  group = packer_user_config,
})

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return
end

-- Have packer use a popup window
packer.init({
  display = {
    open_fn = function()
      return require("packer.util").float({ border = "rounded" })
    end,
  },
})

return packer.startup(function(use)
  use("wbthomason/packer.nvim") -- Have packer manage itself
  use("nvim-lua/popup.nvim")
  use("nvim-lua/plenary.nvim")
  use("kyazdani42/nvim-web-devicons")
  use("lewis6991/impatient.nvim")
  use("moll/vim-bbye")
  use("arkav/lualine-lsp-progress")
  use("antoinemadec/FixCursorHold.nvim") -- This is needed to fix lsp doc highlight
  use({ "schtibe/taxi.vim", ft = "taxi" })
  use({
    "max397574/better-escape.nvim",
    event = "InsertCharPre",
  })
  use("ellisonleao/gruvbox.nvim")
  use("RRethy/nvim-base16")
  -- snippets
  use({
    "L3MON4D3/LuaSnip",
    event = "InsertCharPre",
  })
  use({
    "rafamadriz/friendly-snippets",
    event = "InsertCharPre",
  })
  use({
    "norcalli/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup()
    end
  })
  use({
    "ethanholz/nvim-lastplace",
    config = function() require('nvim-lastplace').setup() end
  })
  use({
    "windwp/nvim-autopairs",
    config = utils.require_plugin("autopairs")
  })
  use({
    "numToStr/Comment.nvim",
    config = utils.require_plugin("comment")
  })
  use({
    "lukas-reineke/indent-blankline.nvim",
    config = utils.require_plugin("indentline")
  })
  use({
    "ur4ltz/surround.nvim",
    config = utils.require_plugin("surround")
  })
  use({
    "kyazdani42/nvim-tree.lua",
    config = utils.require_plugin("nvimtree")
  })
  use({
    "akinsho/bufferline.nvim",
    branch = "main",
    config = utils.require_plugin("bufferline")
  })
  use({
    "nvim-lualine/lualine.nvim",
    config = utils.require_plugin("lualine")
  })
  use({
    "akinsho/toggleterm.nvim",
    branch = "main",
    config = utils.require_plugin("toggleterm")
  })
  use({
    "goolord/alpha-nvim",
    config = utils.require_plugin("alpha")
  })
  use({
    "folke/which-key.nvim",
    config = utils.require_plugin("whichkey")
  })

  -- cmp plugins
  use({
    "hrsh7th/nvim-cmp",
    requires = {
      { "hrsh7th/cmp-nvim-lsp" },
      { "hrsh7th/cmp-nvim-lua" },
      { "hrsh7th/cmp-buffer" },
      { "hrsh7th/cmp-path" },
      { "hrsh7th/cmp-cmdline" },
    },
    config = utils.require_plugin("cmp"),
  })


  -- LSP
  use({
    "neovim/nvim-lspconfig",
    config = utils.require_plugin("lsp")
  }) -- enable LSP
  use("williamboman/nvim-lsp-installer") -- simple to use language server installer
  use("tamago324/nlsp-settings.nvim") -- language server settings defined in json for
  use({
    "jose-elias-alvarez/null-ls.nvim",
  }) -- for formatters and linters

  -- Telescope
  use({
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    config = utils.require_plugin("telescope")
  })
  use("nvim-telescope/telescope-media-files.nvim")
  use("nvim-telescope/telescope-ui-select.nvim")
  use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" })
  use({
    "stevearc/dressing.nvim",
    config = utils.require_plugin("dressing")
  })
  -- Treesitter
  use({
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
    config = utils.require_plugin("treesitter")
  })
  use("JoosepAlviste/nvim-ts-context-commentstring")

  -- Git
  use({
    "lewis6991/gitsigns.nvim",
    config = utils.require_plugin("gitsigns")
  })
  use({
    "tpope/vim-fugitive",
    cmd = {
      "Git",
      "Gdiff",
      "Gdiffsplit",
      "Gvdiffsplit",
      "Gwrite",
      "Gw",
      "GBrowse",
    },
  })

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end
end)
