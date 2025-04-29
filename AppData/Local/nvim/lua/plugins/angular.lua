local path = require("mason-core.path")

local mason_path = path.package_prefix("angular-language-server")
local mason_config = require("mason-lspconfig.server_configurations.angularls")(mason_path)

return {
  "neovim/nvim-lspconfig",
  opts = {
    setup = {
      angularls = function(_, opts)
        opts.on_new_config = function(new_config, new_path)
          local angularVersion = new_config.cmd[8] -- stores current project version
          mason_config.on_new_config(new_config, new_path)
          vim.list_extend(new_config.cmd, { "--angularCoreVersion", angularVersion })
        end
        require("lspconfig").angularls.setup(opts)
      end,
    },
  },
}
