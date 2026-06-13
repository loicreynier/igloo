local g = vim.g

g.mapleader = " "
g.maplocalleader = " "
g.cmp_engine = vim.env.NVIM_CMP_ENGINE or "nvim"
g.tex_flavor = "latex"
g.sqlite_clib_path = g.sinfo.is_nix and os.getenv("NVIM_NIX_SQLITE_PATH")
g.plugins_extra = false
