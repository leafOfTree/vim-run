syntax match Number /\(#\)\@<!\<-\?[[:digit:]]\?\>/
syntax match Number /\(#\)\@<!\<-\?[[:digit:].Ee-]\{2,}\>/
syntax match Error /\c\w*exception\?/
syntax match Error /\c\w*errors\?/
syntax match Warning /\c\warnings\?/
syntax match Error /\cshell error/
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
