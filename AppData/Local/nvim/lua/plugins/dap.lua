return {
  "mfussenegger/nvim-dap",
  optional = true,
  opts = function()
    local dap = require("dap")

    dap.defaults.fallback.resolve_path = function(path)
      if path:match("^%a:") then
        return (path:gsub("^%a", string.upper))
      end
      if vim.loop.os_uname().version:match("Windows") then
        path = path:gsub("/", "\\")
      end
      return path
    end

    if not dap.adapters["pwa-chrome"] then
      dap.adapters["pwa-chrome"] = {
        type = "server",
        host = "localhost",
        port = "${port}",
        executable = {
          command = "node",
          args = {
            require("mason-registry").get_package("js-debug-adapter"):get_install_path()
              .. "/js-debug/src/dapDebugServer.js",
            "${port}",
          },
        },
      }
    end

    for _, lang in ipairs({ "typescript", "javascript" }) do
      dap.configurations[lang] = dap.configurations[lang] or {}
      table.insert(dap.configurations[lang], {
        type = "pwa-chrome",
        request = "launch",
        name = "Launch Chrome",
        url = "http://localhost:4200/ep-atos-prep-web",
        webRoot = "${workspaceFolder}/frontend",
        sourceMaps = true,
      })
    end

    dap.configurations["java"] = dap.configurations["java"] or {}
    table.insert(dap.configurations["java"], {
      type = "java",
      name = "Debug (Attach)",
      request = "attach",
      hostName = "localhost",
      port = 50555,
    })
  end,
}
