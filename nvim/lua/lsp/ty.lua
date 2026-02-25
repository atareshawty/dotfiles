local lspconfig = require("lspconfig")
local configs = require("lspconfig.configs")
local util = require("lspconfig.util")

-- Find the closest .venv directory above the given file path
local function find_closest_venv(file_path)
  local venv_names = { ".venv", "venv" }
  local current_dir = vim.fn.fnamemodify(file_path, ":p:h")

  -- Traverse up the directory tree
  while current_dir ~= "/" and current_dir ~= "" do
    for _, name in ipairs(venv_names) do
      local venv_path = util.path.join(current_dir, name)
      local bin_path = util.path.join(venv_path, "bin") -- Linux/macOS
      if vim.fn.isdirectory(bin_path) == 1 then
        return bin_path
      end
      -- Windows fallback
      local win_path = util.path.join(venv_path, "Scripts")
      if vim.fn.isdirectory(win_path) == 1 then
        return win_path
      end
    end
    -- Move up one directory
    current_dir = vim.fn.fnamemodify(current_dir, ":h")
  end
  return nil
end

configs.ty = {
  default_config = {
    cmd = { "ty", "server" },
    filetypes = { "python" },
    root_dir = util.root_pattern("pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", ".git"),
    on_new_config = function(new_config, new_root_dir)
      -- Get the current buffer's file path
      local bufname = vim.api.nvim_buf_get_name(0)
      if bufname == "" then
        -- Fallback to root_dir if no buffer name
        bufname = new_root_dir
      end

      local venv_bin = find_closest_venv(bufname)
      if venv_bin then
        local env_path = venv_bin .. ":" .. os.getenv("PATH")
        new_config.cmd_env = { PATH = env_path }
      else
        new_config.cmd_env = { PATH = os.getenv("PATH") }
      end
    end,
    settings = {},
  },
}

-- Setup 'ty'
lspconfig.ty.setup({
  settings = {
    ty = {
      diagnosticMode = "workspace",  -- or "openFilesOnly"
    },
  },
  on_attach = function(client, bufnr)
    -- Standard LSP keymaps
    local opts = { noremap=true, silent=true, buffer=bufnr }
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "gy", vim.lsp.buf.type_definition, opts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
  end,
})
