
syntax keyword BuffersType     Buffers Others

syntax match   BuffersNumbers  "\<\d\+\>"
syntax match   BuffersPath     "--.*$"
syntax match   BuffersPoint    "\:"

syntax region  BuffersCurrent  start=+"+  skip=+\\"+  end=+"+

highlight default link BuffersType    Special
highlight default link BuffersPoint   Special
highlight default link BuffersNumbers Number
highlight default link BuffersCurrent String
highlight default link BuffersPath    Comment
