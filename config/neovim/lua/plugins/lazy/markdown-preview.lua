return {
  "iamcco/markdown-preview.nvim",
  cmd = { "MarkdownPreview", "MarkdownPreviewToggle", "MarkdownPreviewStop" },
  ft = { "markdown" },
  enabled = not require("system").is_ssh,
  build = function()
    if require("system").has_self_install then
      vim.fn["mkdp#util#install"]()
    else
      vim.notify(
        "Cannot build binary, please install manually in `<plugin_dir>/app/bin`",
        ---@diagnostic disable-next-line: param-type-mismatch
        "warn",
        { title = "Markdown Preview" }
      )
    end
  end,
  init = function()
    vim.g.mkdp_filetypes = { "markdown" }
    vim.g.mkdp_auto_start = 0
    vim.g.mkdp_auto_close = 1
  end,
}
