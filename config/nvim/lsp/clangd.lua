---@class ClangdInitializeResult: lsp.InitializeResult
---@field offsetEncoding? string

---@type vim.lsp.Config
return {
  cmd = { "clangd" },
  filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
  root_markers = {
    ".clangd",
    ".clang-tidy",
    ".clang-format",
    "compile_commands.json",
    "compile_flags.txt",
    "configure.ac", -- AutoTools
    ".git",
  },
  get_language_id = function(_, ftype)
    local t = { objc = "objective-c", objcpp = "objective-cpp", cuda = "cuda-cpp" }
    return t[ftype] or ftype
  end,
  capabilities = {
    textDocument = {
      completion = {
        editsNearCursor = true,
      },
    },
    offsetEncoding = { "utf-8", "utf-16" },
  },
  ---@param init_result ClangdInitializeResult
  on_init = function(client, init_result)
    if init_result.offsetEncoding then client.offset_encoding = init_result.offsetEncoding end
  end,
}
