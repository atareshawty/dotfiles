local autocmd = vim.api.nvim_create_autocmd

-- Exit Nvim if NERDTree is the only window remaining
autocmd("BufEnter", {
  pattern = "*",
  callback = function()
    if vim.fn.winnr("$") == 1
      and vim.b.NERDTreeType == "primary" then
      vim.cmd("q")
    end
  end,
})
