-- All available language servers can be found here:
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
-- NOTE: You need to have the language server installed on your system for it to work.
local map = vim.keymap.set

-- Python
vim.lsp.enable('ruff')
vim.lsp.enable('ty')

-- Terraform (Hashicorp Official LS, not the community one)
vim.lsp.enable('terraformls')

-- Show diagnostics in a floating window on cursor hold
vim.api.nvim_create_augroup("lsp_diagnostics_auto", { clear = true })
vim.api.nvim_create_autocmd({ "CursorHold" }, {
  group = "lsp_diagnostics_auto",
  callback = function()
    vim.diagnostic.open_float(nil, { scope = "cursor" })
  end,
})

-- Adjust the 'updatetime' for responsiveness
-- Default is 4000ms (4 seconds)
vim.opt.updatetime = 300

---------------------
-- GENERAL KEYMAPS --
---------------------
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    local opts = { buffer = ev.buf, silent = true }

    map("n", "K", function()
      if vim.tbl_contains({ "vim", "help" }, vim.bo.filetype) then
        vim.cmd("h " .. vim.fn.expand("<cword>"))
      else
        vim.lsp.buf.hover()
      end
    end, opts)

    map("n", "gd", vim.lsp.buf.definition, opts)
    map("n", "gy", vim.lsp.buf.type_definition, opts)
    map("n", "gi", vim.lsp.buf.implementation, opts)
    map("n", "gr", vim.lsp.buf.references, opts)
  end,
})

--------------------------
-- LSP specific configs --
--------------------------
-- Autoformat Python files on save using Ruff LSP
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*.py",
    callback = function()
        -- Apply all auto-fixable diagnostics
        vim.lsp.buf.code_action({
            context = {
                only = { "source.fixAll.ruff" },
            },
            apply = true,
        })
        -- Run the standard LSP formatting request (Ruff LSP provides this capability)
        vim.lsp.buf.format({ async = false })
    end,
})

-- Autoformat Terraform files on save using Terraform LSP
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*.tf",
    callback = function()
        -- Apply all auto-fixable diagnostics
        vim.lsp.buf.code_action({
            context = {
                only = { "source.fixAll.terraformls" },
            },
            apply = true,
        })
        -- Run the standard LSP formatting request (Ruff LSP provides this capability)
        vim.lsp.buf.format({ async = false })
    end,
})

vim.lsp.config('ty', {
  settings = {
    ty = {
      diagnosticMode = "workspace",

      -- turn off inlay hints similar to your Pyright settings
      inlayHints = {
        variableTypes = "off",
        functionReturnTypes = "off",
        parameterTypes = "off",
      },
    },
  },
})
