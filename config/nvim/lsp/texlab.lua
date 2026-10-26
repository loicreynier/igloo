---@brief
---
--- https://github.com/latex-lsp/texlab - Completion engine built for (La)TeX
---
--- See https://github.com/latex-lsp/texlab/wiki/Configuration for configuration options.
---
--- Texlab extends the LSP with custom messages, namely:
--- - `textDocument/build`
--- - `textDocument/forwardSearch` : sent from the client to the server when the user requests a
---                                  a forwarch search via SyncTeX.
--- See: https://github.com/latex-lsp/texlab/wiki/LSP-internals
---

local function buf_build(client, bufnr)
  local win = vim.api.nvim_get_current_win()
  local params = vim.lsp.util.make_position_params(win, client.offset_encoding)
  client:request("textDocument/build", params, function(err, result)
    if err then error(tostring(err)) end
    local texlab_build_status = {
      [0] = "Success",
      [1] = "Error",
      [2] = "Failure",
      [3] = "Cancelled",
    }
    vim.notify("Build " .. texlab_build_status[result.status], vim.log.levels.INFO)
  end, bufnr)
end

local function buf_cancel_build(client, bufnr)
  return client:exec_cmd({
    title = "cancel",
    command = "texlab.cancelBuild",
  }, { bufnr = bufnr })
end

local function buf_search(client, bufnr)
  local win = vim.api.nvim_get_current_win()
  local params = vim.lsp.util.make_position_params(win, client.offset_encoding)
  client:request("textDocument/forwardSearch", params, function(err, result)
    if err then error(tostring(err)) end
    local texlab_forward_status = {
      [0] = "Success",
      [1] = "Error",
      [2] = "Failure",
      [3] = "Unconfigured",
    }
    vim.notify("Search " .. texlab_forward_status[result.status], vim.log.levels.INFO)
  end, bufnr)
end

local function dependency_graph(client)
  client:exec_cmd({ command = "texlab.showDependencyGraph" }, { bufnr = 0 }, function(err, result)
    if err then return vim.notify(err.code .. ": " .. err.message, vim.log.levels.ERROR) end
    vim.notify("The dependency graph has been generated:\n" .. result, vim.log.levels.INFO)
  end)
end

---@type vim.lsp.Config
return {
  cmd = { "texlab" },
  filetypes = { "tex" },
  root_markers = {
    ".latexmkrc",
    "latexmkrc",
    "Tectonic.toml",
    ".git",
  },
  settings = {
    texlab = {
      build = {
        executable = "latexmk",
        args = { "-pdf", "-interaction=nonstopmode", "-synctex=1", "%f" },
        onSave = false,
        forwardSearchAfter = false,
      },
      latexFormatter = "tex-fmt",
      bibtexFormatter = "tex-fmt",
      chktex = {
        onOpenAndSave = false,
        onEdit = false,
      },
      diagnosticDelay = 300,
    },
  },
  on_attach = function(client, bufnr)
    for _, cmd in ipairs({
      { name = "LspTexlabBuild", fn = buf_build, desc = "Build the current buffer" },
      { name = "LspTexlabCancelBuild", fn = buf_cancel_build, desc = "Cancel the current build" },
      { name = "LspTexlabForward", fn = buf_search, desc = "Forward search from current position" },
      { name = "LspTexlabDependencyGraph", fn = dependency_graph, desc = "Show the dependency graph" },
    }) do
      vim.api.nvim_buf_create_user_command(
        bufnr,
        "Lsp" .. cmd.name,
        function() cmd.fn(client, bufnr) end,
        { desc = cmd.desc }
      )
    end
  end,
}
