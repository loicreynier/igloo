local sinfo = require("user.system").info

---@type vim.lsp.Config
return {
  cmd = {
    "fortls",
    "--notify_init",
    "--hover_signature",
    "--hover_language=fortran",
    "--use_signature_help",
    "--disable_autoupdate",
  },
  filetypes = { "fortran" },
  root_markers = { ".fortls", ".fortls.rc", ".fortls.json", ".git" },
}
