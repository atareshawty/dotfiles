" Most of this is stolen from nvim/plugged/vim-test/autoload/test/javascript/jest.vim
if !exists('g:test#javascript#herbierunner#file_pattern')
  let g:test#javascript#herbierunner#file_pattern = '\v.*\.test\.(js|jsx|ts)'
endif

function! test#javascript#herbierunner#test_file(file) abort
  return a:file =~# g:test#javascript#herbierunner#file_pattern
endfunction

function! test#javascript#herbierunner#build_position(type, position) abort
  if a:type ==# 'nearest'
    let name = s:nearest_test(a:position)
    if !empty(name)
      let name = '-t '.shellescape(name, 1)
    endif
    return ['--no-coverage', name, '--', a:position['file']]
  elseif a:type ==# 'file'
    return ['--no-coverage', '--', a:position['file']]
  else
    return []
  endif
endfunction

function! test#javascript#herbierunner#build_args(args) abort
  return filter(a:args, 'v:val != "--"')
endfunction

function! test#javascript#herbierunner#executable() abort
  return "cd $HOME/src/drivecapital/herbie/web && yarn run jest"
endfunction

function! s:nearest_test(position) abort
  let name = test#base#nearest_test(a:position, g:test#javascript#patterns)
  return (len(name['namespace']) ? '^' : '') .
       \ test#base#escape_regex(join(name['namespace'] + name['test'])) .
       \ (len(name['test']) ? '$' : '')
endfunction
