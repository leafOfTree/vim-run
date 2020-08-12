syntax match Number /\d/
syntax match Error /\v\cerrors?/
syntax match Error /\v\cshell error/
syntax match Error /\v\c\w*errors?/
syntax match Warning /\v\c\warnings?/
syntax match Note /\v\cnotes?/
highlight default link Warning Type
highlight default link Note Statement
highlight default link RunError Error
