syntax match Number /\<-\?[[:digit:]]\?\>/
syntax match Number /\<-\?[[:digit:].Ee-]\{2,}\>/
syntax match Error /\cerrors\?/
syntax match Error /\cshell error/
syntax match Error /\c\w*errors\?/
syntax match Warning /\c\warnings\?/
syntax match Note /\cnotes\?/
syntax keyword Constant true false
highlight default link Warning Type
highlight default link Note Statement
highlight default link RunError Error
