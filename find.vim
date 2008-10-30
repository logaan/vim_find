" from http://www.vim.org/tips/tip.php?tip_id=1432
" originally written by Samuel Hughes
function! Find(command, name)
  let l:_name = substitute(a:name, "\\s", "\.*", "g")
  let l:list=system("find . -regex '.*".l:_name.".*' -not -name \"*.pyc\" -and -not -name \"*.swp\" -not -regex '.*vendor.*' -and -not -regex '.*tmp.*' -and -not -regex '.*\.svn.*' -and -not -regex '^\./doc.*' | perl -ne 'print \"$.\\t$_\"'")
  let l:num=strlen(substitute(l:list, "[^\n]", "", "g"))
  if l:num < 1
    echo "'".a:name."' not found"
    return
  endif

  if l:num != 1
    echo l:list
    let l:input=input("Which ? (<enter>=nothing)\n")

    if strlen(l:input)==0
      return
    endif

    if strlen(substitute(l:input, "[0-9]", "", "g"))>0
      echo "Not a number"
      return
    endif

    if l:input<1 || l:input>l:num
      echo "Out of range"
      return
    endif

    let l:line=matchstr("\n".l:list, "\n".l:input."\t[^\n]*")
  else
    let l:line=l:list
  endif

  let l:line=substitute(l:line, "^[^\t]*\t./", "", "")
  execute ":".a:command." ".l:line
endfunction

command! -nargs=1 Find :call Find("edit", "<args>")
command! -nargs=1 TFind :call Find("tabedit", "<args>")

