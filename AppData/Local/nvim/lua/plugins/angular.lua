local fs, fn, uv = vim.fs, vim.fn, vim.uv

local function collect_node_modules(root_dir)
  local results = {}

  local project_node = fs.joinpath(root_dir, "node_modules")
  if uv.fs_stat(project_node) then
    table.insert(results, project_node)
  end

  local ngserver_exe = fn.exepath("ngserver")
  if ngserver_exe and #ngserver_exe > 0 then
    local realpath = uv.fs_realpath(ngserver_exe) or ngserver_exe
    local candidate = fs.normalize(fs.joinpath(fs.dirname(realpath), "../../node_modules"))
    if uv.fs_stat(candidate) then
      table.insert(results, candidate)
    end
  end

  local mason_node = LazyVim.get_pkg_path("angular-language-server", "/node_modules")
  local candidate = fs.normalize(mason_node)
  if uv.fs_stat(candidate) then
    table.insert(results, candidate)
  end

  return results
end

local function get_angular_core_version(root_dir)
  local package_json = fs.joinpath(root_dir, "package.json")
  if not uv.fs_stat(package_json) then return "" end

  local ok, f = pcall(io.open, package_json, "r")
  if not ok or not f then return "" end
  local json = vim.json.decode(f:read("*a")) or {}
  f:close()

  local version = (json.dependencies or {})["@angular/core"] or ""
  return version:match("%d+%.%d+%.%d+") or ""
end

return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      angularls = {
        cmd = function(dispatchers, config)
          local root_dir = config.root or fn.getcwd()
          local node_paths = collect_node_modules(root_dir)

          local ts_probe = table.concat(node_paths, ",")
          local ng_probe = table.concat(
            vim.iter(node_paths)
              :map(function(p) return fs.joinpath(p, "@angular/language-server/node_modules") end)
              :totable(),
            ","
          )
          local cmd = {
            "ngserver",
            "--stdio",
            "--tsProbeLocations", ts_probe,
            "--ngProbeLocations", ng_probe,
            "--angularCoreVersion", get_angular_core_version(root_dir),
          }
          return vim.lsp.rpc.start(cmd, dispatchers)
        end,
      },
    },
  },
}

