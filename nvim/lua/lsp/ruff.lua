local lspconfig = require("lspconfig")

lspconfig.ruff.setup({
  cmd = { "ruff", "server" },
  filetypes = { "python" },
  init_options = {
    settings = {
      args = {}, -- pass ruff CLI args here if you want
    },
  },
  on_attach = function(client, bufnr)
    -- Ruff should only do linting & fixes
    client.server_capabilities.hoverProvider = false
  end,
})
