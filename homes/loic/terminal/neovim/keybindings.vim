" Make <C-n>/<C-p> act as <Up>/<Down> when completing command
" TODO: implement using Nixivm
" NOTE: doesn't work using the following NixNeovim implementation
"
"   programs.nixneovim.mapping.command."<c-n>" = {
"    action = "'wildmenumode() ? \"<c-n>\" : \"<down>\"'";
"    expr = true;
"   };
"
cnoremap <expr> <c-p> wildmenumode() ? "<c-p>" : "<up>"
cnoremap <expr> <c-n> wildmenumode() ? "<c-n>" : "<down>"
