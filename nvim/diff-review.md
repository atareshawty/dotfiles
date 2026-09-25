# diff-review cheatsheet

`\dd` reviews the current stack branch against the one below it, `\c` comments in the diff pane, `\ds` archives the review to `~/reviews/`.

Leader is `\`. Config lives in `nvim/lua/diff_review_config.lua`.

## Opening and closing

| Keys | Command | Does |
|---|---|---|
| `\dd` | | Review this branch against the branch below it in the `gh` stack, or against the trunk fork point when there is no stack |
| | `:DiffReview pr:645` | Review a PR (GitHub scopes a stacked PR to its own base) |
| | `:DiffReview main..my-branch` | Review an explicit range |
| | `:DiffReview` | Prompt for review type |
| `\dr` | `:DiffReviewToggle` | Close the panel, or reopen the last review where you left off |
| `q` | | Close the panel |

Pass the same argument string to resume a review; the comment store is keyed off it.

## In the panel

| Keys | Does |
|---|---|
| `j` / `k` / `<CR>` | Move through files, open the diff |
| `<Tab>` / `\t` | Fold a directory, toggle tree and flat view |
| `\c` | Comment on the cursor line, or on a visual range |
| `\dc` | Comment pre-filled with a ` ```suggestion ` block for the visual selection |
| `\e` / `\d` | Edit or delete the comment under the cursor |
| `\l` / `\v` | List this file's comments, send all comments to the quickfix list |
| `gf` | Open the real file at that line (closes the panel, `\dr` brings it back) |

`\c`, `\e`, `\d`, `\l`, and `\v` only bind inside the diff pane, not the file tree.

## Comment popup

| Keys | Does |
|---|---|
| `ZZ`, `<C-s>`, `:w` | Save |
| `q`, `<Esc>`, `ZQ` | Discard |
| `<C-w>p` | Return to the popup after moving away (text is preserved) |

## Getting comments out

| Keys | Command | Does |
|---|---|---|
| `\ds` | `:DiffReviewSave [comments\|full\|diff]` | Write markdown to `~/reviews/<date>-<repo>-<id>.md` |
| `\dy` | `:DiffReviewCopy [comments\|full\|diff]` | Copy to clipboard |
| | `:DiffReview submit` | Post the comments to the PR |

Comments auto-save to `<git-dir>/diff-review/<review-id>.json` as you write them. That path is inside `.git/worktrees/<name>/` for a `review-pr` worktree, which `review-pr-clean` deletes, so `\ds` before tearing one down.

## Notes

Note mode (`\dn`, `\dN`) annotates files outside any diff. It rebinds `\c`, `\e`, `\d`, `\l`, and `\v` on every buffer it enters, including the diff pane, where it fails with `Not in a valid file buffer`. Do not run it during a review. Auto-restore is off, so a restart clears it.

`:DiffReviewList` (`\dR`) needs snacks.nvim or telescope.nvim, neither of which is installed.

<details>
<summary>Local fixes in <code>diff_review_config.lua</code></summary>

- `layout.restore` is overridden. Upstream calls `reviews.start_ref_review()` and friends, which do not exist, so every reopen and toggle throws.
- `\dd` resolves the down-stack branch from `gh stack view --json`, by branch order rather than the `base` field, which holds a commit sha that is not the tip below you. It emits `<below>..<current>` so each pair keeps its own comment store; a bare ref is always keyed `ref-HEAD` and would share comments across every review in the repo.
- Off a stack, `\dd` fetches the branch `origin/HEAD` points at, then reviews `<merge-base>..<current>`. Two dots from the fork point is the three-dot diff a pull request shows, and the fork point does not move when the fetch advances the trunk, so the comment store survives. A failed fetch warns and falls back to the local copy.
- `file_list_width` is recomputed per open as a quarter of the window, capped at 45 columns. It is an absolute column count upstream, so a fixed 45 is a quarter of a full terminal but half of a tmux quadrant.
- `notes.auto_restore` is off.

</details>
