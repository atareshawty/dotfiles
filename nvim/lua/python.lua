local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local py_group = augroup("python", { clear = true })

-- Manually autoformat on save for pyton files
autocmd("BufWrite", {
  group = py_group,
  pattern = "*.py",
  command = "call CocAction('format')",
})

autocmd("BufWritePre", {
  group = py_group,
  pattern = "*.py",
  command = "silent! call CocAction('runCommand', 'python.sortImports')",
})
