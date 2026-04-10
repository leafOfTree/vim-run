" Hex: 0xFF
syntax match Number /\<0[xX][0-9a-fA-F]\+\>/

" Octal: 0o77
syntax match Number /\<0[oO][0-7]\+\>/

" Binary: 0b1010
syntax match Number /\<0[bB][01]\+\>/

" Decimal: 123, 123.1, 123-1233
syntax match Number /\<\d\+\%(\.\d\+\)\?\%(-\d\+\)\?\>/

syntax match Constant /\[[^]]*\]/
syntax match Error /\c\w*exception\?/
syntax match Error /\c\w*errors\?/
syntax match Warning /\c\warnings\?/
syntax match Note /\cnotes\?/
syntax match Help /\chelps\?/
syntax keyword Constant true false
syntax match Normal /n't /
syntax region String start=+"+ end=+"+ end=+$+ 
syntax region String start=+'+ end=+'+ end=+$+
syntax region String start=+`+ end=+`+ end=+$+

highlight default link Warning Type
highlight default link Note Statement
highlight default link RunError Error
highlight default link Help Statement
