let s:termbufm_window = -1
let s:termbufm_buffer = -1
let s:termbufm_job_id = -1

function! TermBufMDirection()
    if !exists('g:termbufm_direction_cmd')
        return 'vnew'
    else
        return g:termbufm_direction_cmd
    endif
endfunction

function! TermBufMOpen(...)

    let direction = 'new'
    if len(a:000) == 1
        let direction = a:0
    else
        let direction = TermBufMDirection()
    endif

    " if not exist
    if !bufexists(s:termbufm_buffer)
        " create the termbufm buffer

        exec direction

        " set the job id
        let s:termbufm_job_id = termopen($SHELL)

        " change name of buffer
        silent file termbufm_b

        " set window and buffer ids
        let s:termbufm_window = win_getid()
        let s:termbufm_buffer = bufnr('%')

        " don't show in buffer list
        set nobuflisted

    " don't show line numbers
    set nonumber norelativenumber

    " if not currently shown
    elseif !win_gotoid(s:termbufm_window)

        " open the buffer in a split window
        exec direction
        buffer termbufm_b

        " set window id
        let s:termbufm_window = win_getid()
    endif
endfunction

function! TermBufMToggle()
    if win_gotoid(s:termbufm_window)
        call TermBufMClose()
    else
        call TermBufMOpen()
    endif
endfunction

function! TermBufMClose()
    if win_gotoid(s:termbufm_window)
      hide
    endif
endfunction

function! TermBufMExec(cmd)

    " open if needed
    if !win_gotoid(s:termbufm_window)
        call TermBufMOpen()
    endif

    " send command
    call chansend(s:termbufm_job_id, a:cmd . "\n")

    " go to bottom
    normal! G

    " go to previous window where you came from
    wincmd p
endfunction

if !exists('g:termbufm_code_scripts')
  let g:termbufm_code_scripts = {
        \ 'python': { 'build': [''],                       'run': ['cat input | python %s', '%'] },
        \ 'cpp':    { 'build': ['g++ -std=c++11 %s', '%'], 'run': ['cat input | ./a.out'] },
        \ 'java':   { 'build': ['javac %s', '%'],          'run': ['cat input | java %s', '%:r'] },
        \ 'c':      { 'build': ['gcc %s', '%'],            'run': ['cat input | ./a.out'] },
        \ }
endif



function! TermBufMExecCodeScript(ft, type) abort
    if !has_key(g:termbufm_code_scripts, a:ft)
        throw printf('filetype not found: %s', a:ft)
        return
    endif

    let ft_dict = get(g:termbufm_code_scripts, a:ft)

    if !has_key(ft_dict, a:type)
        throw printf('command type not found: %s', a:type)
        return
    endif

    " if have not generated cmd yet, create new dict
    if !exists('b:termbufm_cached_cmd')
      let b:termbufm_cached_cmd = {}
    endif

    " if have not cached the cmd type yet, generate it from global dictionary
    if !has_key(b:termbufm_cached_cmd, a:type)
      let entry = get(ft_dict, a:type)
      if len(entry) == 0
        return
      endif

      let [fmtstr; fargs] = entry

      let argstr = ''
      let begin = 1
      for arg in fargs
        let argstr .= '"' . expand(arg) . '"' . (begin ? '' : ', ')
      endfor

      " simulate argument unpacking using loop over List and execute()
      let cmd = trim(execute('echo printf(''' . fmtstr . ''', ' . argstr .')'))
      let b:termbufm_cached_cmd[a:type] = cmd
    endif

    call TermBufMExec(b:termbufm_cached_cmd[a:type])

endfunction
