return {
  "nvim-lualine/lualine.nvim",
  opts = function(_, opts)
    table.remove(opts.sections.lualine_c)
    opts.options.theme = "catppuccin-mocha"
  end,
}
