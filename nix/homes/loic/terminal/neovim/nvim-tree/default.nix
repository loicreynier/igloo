{lib, ...}: {
  programs.nixvim = {
    # -- Custom on attach function
    # Must be set in `extraConfigLuaPre` so that is defined
    # before loading `nvim-tree` setup
    extraConfigLuaPre = ''
      -- {{{ `nvim-tree`  additional config

      ${lib.strings.fileContents ./hjkl-nav.lua}
      ${lib.strings.fileContents ./git-stage.lua}

      local function _nvim_tree_on_attach(bufnr)
          local api = require("nvim-tree.api")

          local function opts(desc)
              return {
                  desc = "nvim-tree: " .. desc,
                  buffer = bufnr,
                  noremap = true,
                  silent = true,
                  nowait = true,
              }
          end

          -- Default mappings
          api.config.mappings.default_on_attach(bufnr)

          -- Custom mappings
          ${lib.strings.fileContents ./hjkl-nav-onattach.lua}
          ${lib.strings.fileContents ./git-stage-onattach.lua}
          -- }}}
      end
    '';
    plugins.nvim-tree.onAttach.__raw = "_nvim_tree_on_attach";
  };
}
# vim: nofen

