" This file is automatically generated by test-syntax from testing.vim

fun! Test_cgo() abort
    call TestSyntax(g:test_packdir . '/syntax/testdata/cgo.go',
        \ [
        \ [['goPackage', 1, 8]],
        \ [],
        \ [['goComment', 1, 2]],
        \ [['goCgo', 1, 18]],
        \ [['goCgo', 1, 14]],
        \ [['goCgo', 1, 26]],
        \ [['goCgo', 1, 31]],
        \ [['goCgo', 1, 16]],
        \ [['goCgo', 1, 35]],
        \ [['goComment', 1, 7]],
        \ [],
        \ [['goComment', 1, 13]],
        \ [],
        \ [['goCgoError', 1, 35]],
        \ [['goCgoError', 1, 27]],
        \ [['goCgoError', 1, 17]],
        \ [['goComment', 1, 7]],
        \ [],
        \ [['goCgo', 1, 22]],
        \ [['goCgo', 1, 28]],
        \ [['goCgo', 1, 5]],
        \ [['goCgo', 1, 20]],
        \ [['goCgo', 1, 6]],
        \ [['goComment', 1, 2]],
        \ [],
        \ [['goComment', 1, 11]],
        \ [['goCgo', 1, 21]],
        \ [['goCgo', 1, 17]],
        \ [['goCgo', 1, 29]],
        \ [['goCgo', 1, 34]],
        \ [['goCgo', 1, 19]],
        \ [['goCgo', 1, 29]],
        \ [['goCgo', 1, 38]],
        \ [['goComment', 1, 11]],
        \ [],
        \ [['goCgoError', 1, 38]],
        \ [['goCgoError', 1, 30]],
        \ [['goCgoError', 1, 20]],
        \ [['goComment', 1, 2]],
        \ [['goCgo', 1, 25]],
        \ [['goCgo', 1, 33]],
        \ [['goCgo', 1, 8]],
        \ [['goCgo', 1, 25]],
        \ [['goCgo', 1, 9]],
        \ [['goCgo', 1, 65]],
        \ [['goCgo', 1, 36]],
        \ [['goCgo', 1, 65]],
        \ [['goImport', 1, 7], ['goString', 8, 10]],
        \ [],
        \ [['goCgo', 1, 10]],
        \ [['goDeclaration', 1, 5]],
        \ [],
        \ [['goComment', 1, 29]],
    \ ])
endfun
