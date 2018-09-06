" Commandline completion: original, unexported camelCase, and exported
" CamelCase.
function! gopher#rename#complete(lead, cmdline, cursor) abort
  let l:word = expand('<cword>')
  return filter(
        \ uniq(sort([l:word, s:unexport(l:word), s:export(l:word)])),
        \ { i, v -> strpart(l:v, 0, len(a:lead)) is# a:lead })
endfun

fun! gopher#rename#do(bang, ...) abort
  " No argument; try to make a sane decision:
  " - ALLCAPS -> Allcaps
  " - snake_case -> snakeCase     (Convert snake_case while keeping export status)
  " - Snake_case -> SnakeCase
  " - Otherwise toggle export status.
  if a:0 is 0
    let l:to = gopher#rename#_auto_to(expand('<cword>'))
  else
    let l:to = a:1
  endif

  call gopher#internal#write_all()
  cexpr []

  " Make sure the buffer can't be modified since gorename will write stuff to
  " disk, and overwrite the user's changes.
  " Set this for *all* buffers since gorename can modify multiple files.
  call gopher#internal#bufdo('set nomodifiable')
  let l:autoread = &autoread
  set autoread

  try
    call gopher#system#tool_job(function('s:done'), [
          \ 'gorename',
          \ '-to',     l:to,
          \ '-tags',   get(g:, 'gopher_build_tags', ''),
          \ '-offset', gopher#internal#cursor_offset(1)
          \ ] + get(g:, 'gopher_gorename_flags', []))
  catch
    " Just so we don't leave the buffer in nomod state on errors, and it doesn't
    " hurt to do twice.
    call gopher#internal#bufdo('set modifiable')
    let &autoread = l:autoread
  endtry
endfun

fun! s:done(exit, out) abort
  call gopher#internal#bufdo('set modifiable')

  if a:exit > 0
    return s:errors(a:out, '')
  endif

  call gopher#internal#info(a:out)
endfun

fun! s:errors(out, bang) abort
  if a:out =~# '": no identifier at this position'
    call gopher#internal#error('gorename: no identifier at this position')
    return
  endif

  if a:out =~# ': renaming this.*conflicts with'
    let l:out = map(split(a:out, "\n"), { i, v -> split(l:v, ':')})

    call gopher#internal#error(
          \ gopher#internal#trim(join(l:out[0][3:]))
          \ . ' ' .
          \ gopher#internal#trim(join(l:out[1][3:])))
    return
  endif

  " TODO: allow configuring of loclist/qflist, auto/open close .. maybe re-use
  " ALE vars?
  " TODO: QuickFixCmdPre and QuickFixCmdPost autocmds?
  for l:err in split(a:out, "\n")
    " Not a very useful line to add.
    if l:err =~# "^gorename: couldn't load packages due to errors:"
      continue
    endif

    let l:err = substitute(l:err, '\v^gorename: (-offset ".{-}:#\d{-}": cannot parse file: )?', '', '')
    let l:err = split(l:err, ':')
    if len(l:err) < 3
      continue
    endif

    call setqflist(winnr(), [{
          \ 'type':     'E',
          \ 'filename': l:err[0],
          \ 'lnum':     l:err[1],
          \ 'col':      l:err[2],
          \ 'text':     join(l:err[3:], ':'),
          \ }], 'a')
  endfor

  if len(getqflist(winnr())) is 0
    call gopher#internal#error(a:out)
    return
  endif

  exe 'copen ' . len(getqflist(winnr()))
  if !a:bang
    cc 1
  endif
endfun

" Exported just for testing.
" TODO: See if we can test this without exposing it.
fun! gopher#rename#_auto_to(w) abort
  if a:w =~# '^\u\+$'
    return a:w[0] . tolower(a:w[1:])
  elseif a:w =~# '_'
    return a:w =~# '^\u' ? s:export(a:w) : s:unexport(a:w)
  else
    return a:w =~# '^\u' ? s:unexport(a:w) : s:export(a:w)
  endif
endfun

" Copied from tpope/vim-abolish.
fun! s:unexport(word) abort
  "let v:errors = add(v:errors, 'unexp ' . a:word)

  let l:word = substitute(a:word, '-', '_', 'g')
  if l:word !~# '_' && l:word =~# '\l'
    return substitute(l:word, '^.', '\l&', '')
  else
    return substitute(l:word, '\C\(_\)\=\(.\)', '\=submatch(1)==""?tolower(submatch(2)) : toupper(submatch(2))','g')
  endif
endfun

fun! s:export(word) abort
  "let v:errors = add(v:errors, 'exp ' . a:word)

  let l:word = s:unexport(a:word)
  return toupper(l:word[0]) . l:word[1:]
endfun