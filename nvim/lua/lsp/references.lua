local M = {}

-- A path is a test when it sits in a test directory or its basename is named for
-- one. Package names like forge_testing are left alone, since their src/ holds
-- production code.
local test_patterns = {
  "/tests?/",
  "/test_[^/]*$",
  "[^/]*_test%.[^/]+$",
  "[^/]*_tests%.[^/]+$",
}

--- True when the path looks like a test file.
---@param filename string
---@return boolean
function M.is_test(filename)
  for _, pattern in ipairs(test_patterns) do
    if filename:match(pattern) then
      return true
    end
  end
  return false
end

--- Sends LSP references to the quickfix list with test files dropped.
function M.without_tests()
  vim.lsp.buf.references(nil, {
    on_list = function(result)
      local items = vim.tbl_filter(function(item)
        return not M.is_test(item.filename)
      end, result.items)

      local dropped = #result.items - #items
      if #items == 0 then
        vim.notify(('No references outside tests (%d dropped)'):format(dropped), vim.log.levels.INFO)
        return
      end

      vim.fn.setqflist({}, ' ', { title = result.title, items = items })
      vim.cmd('botright copen')
      if dropped > 0 then
        vim.notify(('%d test reference(s) hidden, gR shows all'):format(dropped), vim.log.levels.INFO)
      end
    end,
  })
end

return M
