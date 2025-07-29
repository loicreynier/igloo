local M = {}

M.icons = {
  prompt = {
    prefix = " ",
    selection = " ",
  },
  actions = {
    new_file = " ",
    find_files = " ",
    find_text = " ",
    recent_files = " ",
    config_files = " ",
    restore_session = " ",
    quit = " ",
    keymaps = " ",
    projects = " ",
  },
  diagnostics = {
    Error = " ",
    Warn = " ",
    Hint = " ",
    Info = " ",
  },
  git = {
    logo = " ",
    added = " ",
    modified = " ",
    removed = " ",
  },
  kinds = {
    Array = " ",
    Boolean = "󰨙 ",
    Class = " ",
    Codeium = "󰘦 ",
    Color = " ",
    Control = " ",
    Collapsed = " ",
    Constant = "󰏿 ",
    Constructor = " ",
    Copilot = " ",
    Enum = " ",
    EnumMember = " ",
    Event = " ",
    Field = " ",
    File = " ",
    Folder = " ",
    Function = "󰊕 ",
    Interface = " ",
    Key = " ",
    Keyword = " ",
    Method = "󰊕 ",
    Module = " ",
    Namespace = "󰦮 ",
    Null = " ",
    Number = "󰎠 ",
    Object = " ",
    Operator = " ",
    Package = " ",
    Property = " ",
    Reference = " ",
    Snippet = " ",
    String = " ",
    Struct = "󰆼 ",
    TabNine = "󰏚 ",
    Text = " ",
    TypeParameter = " ",
    Unit = " ",
    Value = " ",
    Variable = "󰀫 ",
  },
  plugins = {
    Lazy = "󰒲 ",
    Mason = "󱌣 ",
  },
}

M.header = {
  -- Source: https://github.com/PraveenGongada/dotfiles
  width = 70,
  string = "                                                                     \n"
    .. "       ████ ██████           █████      ██                     \n"
    .. "      ███████████             █████                             \n"
    .. "      █████████ ███████████████████ ███   ███████████   \n"
    .. "     █████████  ███    █████████████ █████ ██████████████   \n"
    .. "    █████████ ██████████ █████████ █████ █████ ████ █████   \n"
    .. "  ███████████ ███    ███ █████████ █████ █████ ████ █████  \n"
    .. " ██████  █████████████████████ ████ █████ █████ ████ ██████ \n",
}

return M
