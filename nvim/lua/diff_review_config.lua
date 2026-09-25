require('diff-review').setup({
  diff = {
    -- Treesitter highlighting; +/- render as line backgrounds instead of prefixes
    syntax_highlighting = true,
  },
  notes = {
    -- Note mode rebinds <leader>c on every buffer it enters, including the review's
    -- diff pane, so a forgotten \dn would silently break commenting in later sessions.
    auto_restore = false,
  },
})

-- Upstream v0.5.1 layout.restore() dispatches to reviews.start_ref_review() and
-- friends, which do not exist, so every reopen throws. Reopen through
-- layout.open(), the same entry point the :DiffReview command uses.
local layout = require('diff-review.layout')
function layout.restore()
  local state = layout.last_review_state or require('diff-review.persistence').load_global_session()
  local ctx = state and state.review_context
  if not ctx then
    vim.notify('No previous review session to restore', vim.log.levels.INFO)
    return false
  end

  layout.open(ctx.type, ctx.base, ctx.head, ctx.pr_number)

  local file_list = require('diff-review.file_list')
  if state.view_mode and state.view_mode ~= file_list.state.view_mode then
    file_list.toggle_view_mode()
  end
  if state.file_index and state.file_index > 0 then
    file_list.state.current_index = state.file_index
    file_list.render()
    file_list.update_diff()
  end
  if state.cursor_pos and layout.state.diff_win and vim.api.nvim_win_is_valid(layout.state.diff_win) then
    pcall(function()
      vim.api.nvim_win_set_cursor(layout.state.diff_win, state.cursor_pos)
      if state.scroll_pos then
        vim.fn.winrestview({ topline = state.scroll_pos })
      end
    end)
  end
  return true
end

-- file_list_width is a fixed column count, so 45 is a quarter of a full terminal
-- but half of a tmux quadrant. Scale it to the window, never above the default.
local layout_open = layout.open
layout.open = function(...)
  require('diff-review.config').get().layout.file_list_width =
    math.max(20, math.min(45, math.floor(vim.o.columns * 0.25)))
  return layout_open(...)
end

vim.keymap.set('n', '<leader>dr', '<cmd>DiffReviewToggle<CR>', { desc = 'Toggle diff review' })
vim.keymap.set('n', '<leader>dR', '<cmd>DiffReviewList<CR>', { desc = 'List/switch reviews' })
vim.keymap.set('n', '<leader>dy', '<cmd>DiffReviewCopy<CR>', { desc = 'Copy review comments' })
vim.keymap.set('n', '<leader>dn', '<cmd>DiffNoteToggle<CR>', { desc = 'Toggle note mode' })
vim.keymap.set('n', '<leader>dN', '<cmd>DiffNoteCopy<CR>', { desc = 'Copy notes' })

-- Comments live in <git-dir>/diff-review/, which for a review-pr worktree is
-- .git/worktrees/<name>/ and dies with `review-pr-clean`. Archive each review
-- outside the repo so the corpus survives cleanup.
local review_archive = vim.fn.expand('~/reviews')

vim.api.nvim_create_user_command('DiffReviewSave', function(cmd)
  local content, err = require('diff-review.export').export(cmd.args ~= '' and cmd.args or 'full')
  if not content then
    vim.notify('DiffReviewSave: ' .. (err or 'export failed'), vim.log.levels.ERROR)
    return
  end

  local review = require('diff-review.reviews').get_current()
  local root = vim.fn.systemlist('git rev-parse --show-toplevel')[1] or vim.fn.getcwd()
  local path = ('%s/%s-%s-%s.md'):format(
    review_archive, os.date('%Y-%m-%d'), vim.fn.fnamemodify(root, ':t'), review.id
  )

  vim.fn.mkdir(review_archive, 'p')
  vim.fn.writefile(vim.split(content, '\n'), path)
  vim.fn.setreg('+', path)
  vim.notify('Saved review to ' .. path)
end, {
  nargs = '?',
  complete = function() return { 'comments', 'full', 'diff' } end,
  desc = 'Archive the current review as markdown outside the repo',
})

vim.keymap.set('n', '<leader>ds', '<cmd>DiffReviewSave<CR>', { desc = 'Save review to archive' })

--- Open a comment on lines [line1, line2] of the diff pane, pre-filled with a
--- GitHub suggestion block holding those lines.
local function suggest(line1, line2)
  local layout = require('diff-review.layout')
  if not layout.state.is_open or vim.api.nvim_get_current_buf() ~= layout.state.diff_buf then
    vim.notify('Suggestions only work in the diff pane', vim.log.levels.WARN)
    return
  end

  local file_list = require('diff-review.file_list')
  local file = file_list.state.files[file_list.state.current_index]
  if not file then
    vim.notify('No file selected', vim.log.levels.WARN)
    return
  end

  local lines = vim.api.nvim_buf_get_lines(layout.state.diff_buf, line1 - 1, line2, false)
  -- The diff pane strips +/- into line highlights; without that they are real text.
  if not require('diff-review.config').get().diff.syntax_highlighting then
    for i, l in ipairs(lines) do
      lines[i] = l:gsub('^[+%- ]', '')
    end
  end

  local seed = table.concat({ '```suggestion', table.concat(lines, '\n'), '```' }, '\n')
  require('diff-review.popup').open(seed, function(text)
    local range = line2 > line1 and { start = line1, ['end'] = line2 } or nil
    require('diff-review.comments').add(file.path, line1, text, range)
    require('diff-review.actions').refresh_comments()
  end)
end

vim.api.nvim_create_user_command('DiffReviewSuggest', function(cmd)
  suggest(cmd.line1, cmd.line2)
end, { range = true, desc = 'Comment with a suggestion block for the selected lines' })

vim.keymap.set('v', '<leader>dc', ':DiffReviewSuggest<CR>', { silent = true, desc = 'Suggest a change for the selection' })

--- Remote default branch, e.g. `origin/develop`, or nil when none resolves.
---@return string|nil
local function default_base()
  local ref = vim.trim(vim.fn.system({ 'git', 'symbolic-ref', '--short', 'refs/remotes/origin/HEAD' }))
  if vim.v.shell_error == 0 and ref ~= '' then
    return ref
  end
  for _, candidate in ipairs({ 'origin/develop', 'origin/main', 'origin/master' }) do
    vim.fn.system({ 'git', 'rev-parse', '--verify', '--quiet', candidate })
    if vim.v.shell_error == 0 then
      return candidate
    end
  end
  return nil
end

--- Checked-out branch name, or 'HEAD' when detached.
---@return string
local function current_branch()
  local name = vim.trim(vim.fn.system({ 'git', 'branch', '--show-current' }))
  return name ~= '' and name or 'HEAD'
end

--- Name of the branch one position below the current branch in the gh stack.
--- Returns nil plus a message when the current branch is not in a stack.
---@return string|nil, string|nil, boolean|nil
local function down_stack_branch()
  if vim.fn.executable('gh') == 0 then
    return nil, 'gh is not on PATH'
  end
  local out = vim.fn.system({ 'gh', 'stack', 'view', '--json' })
  local ok, stack = pcall(vim.json.decode, out)
  if not ok or type(stack) ~= 'table' or type(stack.branches) ~= 'table' then
    return nil, vim.trim(out)
  end

  local function name_of(b)
    return type(b) == 'table' and (b.name or b.branch or b.headRefName or b.head) or b
  end

  -- Branch entries run bottom of stack first. Which one is current is reported
  -- inconsistently, so accept any of the three signals.
  local head = current_branch()
  local idx
  for i, b in ipairs(stack.branches) do
    if (type(b) == 'table' and b.isCurrent) or name_of(b) == head then
      idx = i
      break
    end
  end
  if not idx and type(stack.currentBranchIndex) == 'number' then
    idx = stack.currentBranchIndex + 1 -- zero-based in the JSON
  end
  if not idx then
    return nil, ('current branch %q not found in stack: %s'):format(head, vim.trim(out))
  end

  local entry = stack.branches[idx]
  -- Down-stack branch is the previous entry: `base` is a commit sha, and not
  -- necessarily the tip of the branch below, so it is only a last resort for
  -- the bottom branch (where it points at the fork point from the trunk).
  local below = (idx > 1 and name_of(stack.branches[idx - 1]))
    or stack.trunk
    or (type(entry) == 'table' and entry.base)
  if not below then
    return nil, 'no branch below current'
  end
  return below, nil, type(entry) == 'table' and entry.needsRebase or nil
end

vim.keymap.set('n', '<leader>dd', function()
  local branch, err, needs_rebase = down_stack_branch()

  -- Range form naming both endpoints, so each pair gets its own comment store:
  -- a bare ref is always keyed `ref-HEAD`, and `..HEAD` would collide across two
  -- branches stacked on the same parent.
  if branch then
    if needs_rebase then
      vim.notify(branch .. ' is not an ancestor of HEAD; diff includes its changes too', vim.log.levels.WARN)
    end
    vim.cmd(('DiffReview %s..%s'):format(branch, current_branch()))
    return
  end

  -- Off a stack, review against the fork point from the remote default branch.
  -- Two dots from the fork point is the three-dot diff a pull request shows, and
  -- the fork point survives the fetch, so the comment store stays put.
  local base = default_base()
  if not base then
    vim.notify('gh stack: ' .. (err or 'not in a stack') .. ', and no origin default branch', vim.log.levels.ERROR)
    return
  end

  vim.fn.system({ 'git', 'fetch', 'origin', (base:gsub('^origin/', '')) })
  if vim.v.shell_error ~= 0 then
    vim.notify('could not fetch ' .. base .. ', using the local copy', vim.log.levels.WARN)
  end

  local fork = vim.trim(vim.fn.system({ 'git', 'merge-base', base, 'HEAD' }))
  if vim.v.shell_error ~= 0 or fork == '' then
    vim.notify('no merge base with ' .. base, vim.log.levels.ERROR)
    return
  end

  local short = vim.trim(vim.fn.system({ 'git', 'rev-parse', '--short', fork }))
  vim.notify('not in a stack, comparing against ' .. base, vim.log.levels.INFO)
  vim.cmd(('DiffReview %s..%s'):format(short, current_branch()))
end, { desc = 'Diff review against the branch below in the stack, or the trunk fork point' })

return { down_stack_branch = down_stack_branch }
