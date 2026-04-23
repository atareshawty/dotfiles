local lspconfig = require("lspconfig")
local util = require("lspconfig.util")

lspconfig.clangd.setup({
  cmd = {
    "/usr/bin/clangd-18",
    "--background-index",
    "--header-insertion=iwyu",
    "--completion-style=detailed",
    "--pch-storage=memory",
    "--clang-tidy",
    "-j=4",
    "--log=error",
  },
  filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
  root_dir = util.root_pattern(
    "compile_commands.json",
    ".clangd",
    ".clang-format",
    "compile_flags.txt",
    ".git"
  ),
  capabilities = {
    offsetEncoding = { "utf-16" },
  },
  on_attach = function(client, bufnr)
    local opts = { noremap = true, silent = true, buffer = bufnr }
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "gy", vim.lsp.buf.type_definition, opts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "<LocalLeader>s", "<cmd>ClangdSwitchSourceHeader<CR>", opts)
  end,
})
