
function TestNoArgsNoConfig()
    let expected = ""
    let actual = dbg#action#next({}, "")
    call assert_equal(expected, actual)
endfunction

function TestNoArgsWithProg()
    let expected = #{action: "launch", program_path: "/bin/bash"}
    let actual = dbg#action#next(#{program_path: "/bin/bash"}, "")
    call assert_equal(expected, actual)
endfunction

function TestNoArgsWithProgArgs()
    let expected = #{
        \ action: "launch",
        \ program_path: "/bin/bash",
        \ program_args: ["-c", "ls"]
        \}
    let actual = dbg#action#next(#{
        \ program_path: "/bin/bash",
        \ program_args: ["-c", "ls"]
        \}, "")
    call assert_equal(expected, actual)
endfunction

function TestNoArgsWithProgCore()
    let expected = #{
        \ action: "launch",
        \ program_path: "/bin/bash",
        \ coredump_path: "/etc/group",
        \}
    let actual = dbg#action#next(#{
        \ program_path: "/bin/bash",
        \ coredump_path: "/etc/group",
        \}, "")
    call assert_equal(expected, actual)
endfunction

function TestNoArgsWithPid()
    let expected = #{action: "attach-pid", pid: 31892}
    let actual = dbg#action#next(#{pid: 31892}, "")
    call assert_equal(expected, actual)
endfunction

function TestNoArgsWithProc()
    let expected = #{action: "attach-pid", pid: 1, proc: "systemd"}
    let actual = dbg#action#next(#{proc: "systemd"}, "")
    call assert_equal(expected, actual)
endfunction

function TestNoArgsWithProcExec()
    let expected = #{action: "attach-pid", proc: "awesome"}
    let actual = dbg#action#next(#{proc: "awesome"}, "")
    call assert_equal(get(expected, 'action'), get(actual, 'action'))
    call assert_equal(get(expected, 'proc'), get(actual, 'proc'))
    call assert_equal(v:t_number, type(get(actual, 'pid', "")))
endfunction

function TestNoArgsWithIp()
    let expected = #{action: "attach-ip", ip: "192.168.20.34"}
    let actual = dbg#action#next(#{ip: "192.168.20.34"}, "")
    call assert_equal(expected, actual)
endfunction

function TestNoArgsWithIpPort()
    let expected = #{action: "attach-ip", ip: "192.168.20.34", port: 44009}
    let actual = dbg#action#next(#{ip: "192.168.20.34", port: 44009}, "")
    call assert_equal(expected, actual)
endfunction

function TestNoArgsWithIpBadPort()
    let expected = #{action: "attach-ip", ip: "192.168.20.34"}
    let actual = dbg#action#next(#{ip: "192.168.20.34", port: -1}, "")
    call assert_equal(expected, actual)
endfunction

function TestProgArgNoConfig()
    let expected = #{action: "launch", program_path: "/bin/bash"}
    let actual = dbg#action#next({}, "/bin/bash")
    call assert_equal(expected, actual)
endfunction

function TestProgArgsNoConfig()
    let expected = #{
        \ action: "launch",
        \ program_path: "/bin/bash",
        \ program_args: ["-c", "ls"]
        \}
    let actual = dbg#action#next({}, "/bin/bash -c ls")
    call assert_equal(expected, actual)
endfunction

function TestProgArgWithSpaceNoConfig()
    let expected = #{action: "launch", program_path: "/bin/bash"}
    let actual = dbg#action#next({}, " /bin/bash ")
    call assert_equal(expected, actual)
endfunction

function TestProgCoreArgNoConfig()
    let expected = #{
        \ action: "launch",
        \ program_path: "/bin/bash",
        \ coredump_path: "/etc/group"
        \}
    let actual = dbg#action#next({}, "/bin/bash /etc/group")
    call assert_equal(expected, actual)
endfunction

function TestPidArgNoConfig()
    let expected = #{action: "attach-pid", pid: 31892}
    let actual = dbg#action#next({}, "31892")
    call assert_equal(expected, actual)
endfunction

function TestProcArgNoConfig()
    let expected = #{action: "attach-pid", pid: 1, proc: "systemd"}
    let actual = dbg#action#next({}, "systemd")
    call assert_equal(expected, actual)
endfunction

function TestProcExecArgNoConfig()
    let expected = #{action: "attach-pid", proc: "awesome"}
    let actual = dbg#action#next({}, "awesome")

    call assert_equal(get(expected, 'action'), get(actual, 'action'))
    call assert_equal(get(expected, 'proc'), get(actual, 'proc'))
    call assert_equal(v:t_number, type(get(actual, 'pid', "")))
endfunction

function TestIpArgNoConfig()
    let expected = #{action: "attach-ip", ip: "192.168.30.23"}
    let actual = dbg#action#next({}, "192.168.30.23")
    call assert_equal(expected, actual)
endfunction

function TestIpPortArgNoConfig()
    let expected = #{
        \ action: "attach-ip",
        \ ip: "192.168.30.23",
        \ port: 31892,
        \}
    let actual = dbg#action#next({}, "192.168.30.23 31892")
    call assert_equal(expected, actual)
endfunction

" TODO: Repeat this test for the other situation
function TestProgArgBeatsConfig()
    let expected = #{action: "launch", program_path: "/bin/bash"}
    let actual = dbg#action#next(#{program_path: "/usr/bin/zsh"}, "/bin/bash")
    call assert_equal(expected, actual)
endfunction

function TestInsertNewAction()
    let expected = [#{action: "launch", program_path: "/bin/bash"}]
    let actual = dbg#action#insert([], #{action: "launch", program_path: "/bin/bash"})
    call assert_equal(expected, actual)
endf

function TestMoveDuplicateActionToFront()
    let action_hist = [
        \ #{action: "launch", program_path: "/bin/bash"},
        \ #{action: "launch", program_path: "/bin/bash", program_args: ["-c", "ls"]},
        \ #{action: "attach-pid", pid: 31892},
        \]
    let new_action = #{action: "attach-pid", pid: 31892}
    let expected = [
        \ #{action: "attach-pid", pid: 31892},
        \ #{action: "launch", program_path: "/bin/bash"},
        \ #{action: "launch", program_path: "/bin/bash", program_args: ["-c", "ls"]},
        \]

    let actual = dbg#action#insert(action_hist, new_action)
    call assert_equal(expected, actual)
endf

