local map = vim.keymap.set

-- Space toggles fold
function _G.OnSpace()
  if vim.fn.foldlevel('.') > 0 then
    if vim.fn.foldclosed('.') ~= -1 then
      return "zO"
    else
      return "za"
    end
  end
  return " "
end

map("n", "<Space>", "v:lua.OnSpace()", { silent = true, expr = true })
