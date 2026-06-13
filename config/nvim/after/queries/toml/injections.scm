; extends

; Source: https://mise.jdx.dev/mise-cookbook/neovim.html

;; Requires adding the `is-mise` predicate:
;;
;; vim.treesitter.query.add_predicate("is-mise?", function(_, _, bufnr, _)
;;   local filepath = vim.api.nvim_buf_get_name(tonumber(bufnr) or 0)
;;   local filename = vim.fn.fnamemodify(filepath, ":t")
;;   return string.match(filename, ".*mise.*%.toml$") ~= nil
;; end, { force = true, all = false })
;;

; Multiline + `env` shebang
(pair
  (bare_key) @key (#eq? @key "run")
  (string) @injection.content @injection.language

  (#is-mise?)
  (#match? @injection.language "^['\"]{3}\n*#!(/\\w+)+/env\\s+\\w+") ; Shebang
  (#gsub! @injection.language "^.*#!/.*/env%s+([^%s]+).*" "%1") ; Extract lang
  (#offset! @injection.content 0 3 0 -3) ; Srtips quotes from highlighting range
)

; Multiline + direct shebang
(pair
  (bare_key) @key (#eq? @key "run")
  (string) @injection.content @injection.language

  (#is-mise?)
  (#match? @injection.language "^['\"]{3}\n*#!(/\\w+)+\s*\n")
  (#gsub! @injection.language "^.*#!/.*/([^/%s]+).*" "%1")
  (#offset! @injection.content 0 3 0 -3)
)

; Multiline without shebang -> defaults to Bash
(pair
  (bare_key) @key (#eq? @key "run")
  (string) @injection.content

  (#is-mise?)
  (#match? @injection.content "^['\"]{3}\n*.*")
  (#not-match? @injection.content "^['\"]{3}\n*#!")
  (#offset! @injection.content 0 3 0 -3)
  (#set! injection.language "bash")
)

; Single-line -> defaults to Bash
(pair
  (bare_key) @key (#eq? @key "run")
  (string) @injection.content

  (#is-mise?)
  (#not-match? @injection.content "^['\"]{3}")
  (#offset! @injection.content 0 1 0 -1)
  (#set! injection.language "bash")
)
