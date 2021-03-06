if exists('g:current_compiler')
  finish
endif
let g:current_compiler = 'golint'
let s:save_cpo = &cpoptions
set cpoptions-=C

let &l:makeprg = 'golangci-lint run --out-format tab'
if len(get(g:, 'gopher_build_tags', [])) > 0
  let &l:makeprg .= printf(' --build-tags "%s"', join(g:gopher_build_tags, ' '))
endif

" benchmark_test.go:34:2   deadcode  `valFormT2` is unused
" formam.go:201:21         gosimple  S1002: should omit comparison to bool constant, can be simplified to `!inBracket`
let &l:errorformat = '%f:%l:%c %m'

let &cpoptions = s:save_cpo
unlet s:save_cpo
