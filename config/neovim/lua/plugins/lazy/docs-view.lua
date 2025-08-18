---@type LazySpec
return {
  "amrbashir/nvim-docs-view",
  enabled = false, -- TODO: fix auto update?
  cmd = "DocsViewToggle",
  opts = {
    update_mode = "auto",
    position = "bottom",
    height = 10,
  },
}
