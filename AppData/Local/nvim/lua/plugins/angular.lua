local uv, fs, fn = vim.uv, vim.fs, vim.fn

-- Detect project root
local function get_project_root()
  local node_modules = fs.find("node_modules", { path = fn.getcwd() })[1]
  return node_modules and fs.dirname(node_modules) or nil
end

-- Resolve Angular core version from package.json
local function get_angular_core_version(project_root)
  if not project_root then
    return ""
  end

  local package_json = fs.joinpath(project_root, "package.json")
  if not uv.fs_stat(package_json) then
    return ""
  end

  local ok, file = pcall(io.open, package_json, "r")
  if not ok or not file then
    return ""
  end

  local contents = file:read("*a")
  file:close()

  local json = vim.json.decode(contents) or {}
  local version = json.dependencies and json.dependencies["@angular/core"] or ""
  return version:match("%d+%.%d+%.%d+") or ""
end

-- Resolve probe directories for TypeScript and Angular
local function get_probe_dirs(project_root)
  local extension_path =
    fs.normalize(fs.joinpath(fn.stdpath("data"), "mason/packages/angular-language-server/node_modules"))

  local default_probe = project_root and fs.joinpath(project_root, "node_modules") or ""

  local ts_probe_dirs = table.concat({ extension_path, default_probe }, ",")
  local ng_probe_dirs = table.concat({
    fs.joinpath(extension_path, "@angular/language-server/node_modules"),
    fs.joinpath(default_probe, "@angular/language-server/node_modules"),
  }, ",")

  return ts_probe_dirs, ng_probe_dirs
end

-- Init
local project_root = get_project_root()
local angular_core_version = get_angular_core_version(project_root)
local ts_probe_dirs, ng_probe_dirs = get_probe_dirs(project_root)

---@type vim.lsp.Config
return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      angularls = {
        cmd = {
          "ngserver",
          "--stdio",
          "--tsProbeLocations",
          ts_probe_dirs,
          "--ngProbeLocations",
          ng_probe_dirs,
          "--angularCoreVersion",
          angular_core_version,
        },
        filetypes = {
          "typescript",
          "html",
          "typescriptreact",
          "typescript.tsx",
          "htmlangular",
        },
        root_markers = { "angular.json", "nx.json" },
      },
    },
  },
}
