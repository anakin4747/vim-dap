
" Describe the debugging experience you want.
"
" - provide 2 ways of debugging, one with the dap repl and the other with gdb
"   repl for languages that support gdb
" - a way to jump back to current line being debugged
" - application either open up to the right or in a new tab with <esc><esc>
"   disabled
" - support for external terminal for launching process
" - at the bottom the gdb prompt is open with preset settings at a set height
" - a temporary buffer which contains the backtrace indented so that folds can
"   work for you
" - a temporary buffer which contains variables that can be treated like folds
"   - the scope of the variables can be chosen explicitly to be local, global,
"     or both
" - treesitter highlighting in the gdb terminal
" - a way to show variables in the specific scope and be able to
"   increase/decrease the depth of the scope
" - launch commands for debugger can be configured
" - launch commands for debuggee can be configured
" - save launch commands for specific repos
" - setup defaults for your most common languages
" - a way to highlight a section of code and debug that section
" - maybe have a way to read .vscode/launch.json files
" - cool to tell you if the application you are trying to debug does not have
"   debug symbols
" - external terminal support
"
" dap.vim - A Debug Adapter Protocol client the Vim way
" Maintainer:   Anakin Childerhose
" Version:      0.1


" COMMANDS TO ADD
"
" DbgStart
" - No arguments tries its best to run last debug session in that repo
" - Ask for application to debug if none yet provided
" - Restarts your debugging session if there is one
" - The repo specific config needs to be merged with the debugger configs so
"   that the repo specific configs can override the global config
" DbgStart <program>
" - Starts debugging that program but first saves the config for running in
"   that directory so that you don't need to respecify the program
" DbgStart <program> <core>
" - Starts debugging that program with that core dump, updates the application
"   to debug for that repo but not necessarily the core dump
" - Maybe store reference to coredump to be able to reuse most recent core
"   dump(s) (maybe a history of coredumps used for that repo)
"   (maybe a history of debuggees used for that repo)
" DbgStart <pid>
" - Attach to pid to debug
" - Will have a history of all last calls of DbgStart so that it uses the
"   settings of your most recent invocation of any way of calling DbgStart
"   overlaid with the rest of the config that was stored for that repo
" - Check if the arg is an int and that int is a process
" DbgStart <ip> <port>
" - Soft check that ip matches close enough to an ip address and the port is an
"   int in the port ranges
" - Attach to ip address and port
" - Let gdb do most of the talking you know, like if gdb cant find the ip
"   address just let that be sent to the gdb window so that I know why it
"   failed to connect. Saves you from having to implement it yourself
" - Possibly support telnet connections
"
" _DbgSaveConfig_ (Maybe not, it should just build up automatically)
" - Saves a config for that repo
" - Hash on the remote and figure out how git hashes are stored so that you can
"   keep track of every config for every remote
" - On updates to the config, commit each internally to have a history for all
"   changes, that way you can have a repo of all your configs as it grows
" - Maybe track repo configurations by their remote so you check the remote to
"   know which configuration to use
"
" DbgEditRepoConfig
" - Edits the config for that repo
"
" DbgEditConfig
" - Edits the config for the debuggers
"
" DbgJump2CurrentLine
" - Jump to the current line being debugged


"if exists('g:loaded_dap')
"    finish
"endif
"let g:loaded_dap = 1


" repo local configs need to be stored in a file somewhere
"
" like have one file that stores the repos root dir in the first column and the
" second column is just the config vimscript dict

" TODO
" Given the current file, I want to be able to get the configuration stored in
" the internal storage for
function! GetConfig(cfg_dir, file)
    " Have the repo configs just be a list of all the previous settings
    "
    " They do not grow upon each other, they are independent
    "
    " Anytime it is started with new different args to the current repo config
    " then a new one is added to the beginning of the config
endf

" Given the current file, get the remote of that repo
function! GetRemote(file)
    let dirname = fnamemodify(a:file, ":p:h")
    try
        return $"git -C {dirname} remote -v"->system()->split()[1]
    catch
        return ""
    endtry
endf

runtime actions.vim

" TODO: smarter tab completion
command! -nargs=* -complete=file DbgStart call s:DbgStart("<args>")

function! s:DbgStart(args = "")

    let remote = GetRemote(expand("%"))

    let action = GetAction({}, a:args)

    if empty(action)
        echohl WarningMsg
        echo $"No program setup to debug for remote: {remote}"
        echohl Title
        echo 'Try one of:'
        echo ' :DbgStart /path/to/program'
        echo ' :DbgStart <pid>'
        echo ' :DbgStart <name of process>'
        echo ' :DbgStart <ip> <port>'
        echo 'Then:'
        echo ' :DbgStart'
        echohl None
        return
    endif

    echo action
endf

