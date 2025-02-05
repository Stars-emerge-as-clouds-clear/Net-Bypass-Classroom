'===============================================
' 脚本名称: Net Bypass Classroom.vbs
' 描述: 解除 Windows 限制功能并终止指定进程。
' 作者: 云散皆星河
' 网站: 云散皆星河.cn
' 版本: 1.0
' 日期: 2025-02-05
'===============================================
Dim WSH_SHELL
Set WSH_SHELL = WScript.CreateObject("WScript.Shell") ' 创建一个壳对象以与系统交互。

' 此函数通过修改注册表来解除特定 Windows 功能的限制。
Function UnbanFeatures()
    Dim regPaths ' 用于存储受限功能的注册表路径的数组。
    regPaths = Array( _
        "Software\Microsoft\Windows\CurrentVersion\Policies\System\DisableTaskMgr", _
        "Software\Microsoft\Windows\CurrentVersion\Policies\System\DisableRegistryTools", _
        "Software\Microsoft\Windows\CurrentVersion\Policies\System\DisableCMD", _
        "Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\NoRun" _
    )
    
    Dim regPath, result ' 用于存储每个注册表路径和操作结果的变量。
    For Each regPath In regPaths ' 遍历每个注册表路径。
        result = WSH_SHELL.RegWrite("HKEY_CURRENT_USER\" & regPath, 0, "REG_DWORD") ' 写入值为 0 的 DWORD 以启用功能。
        If result Then ' 检查操作是否成功。
            WScript.Echo  "成功解除限制：" & Split(regPath, "\")(UBound(Split(regPath, "\"))) ' 通知用户成功。
        Else
            WScript.Echo "解除限制失败：" & Split(regPath, "\")(UBound(Split(regPath, "\"))) ' 通知用户失败。
        End If
    Next

    WSH_SHELL.Run "taskmgr.exe", 1, False ' 启动任务管理器以验证更改。
End Function

' 此函数终止指定的进程。
Function KillProcess(processName, outputErrors)
    Dim objWMIService ' 用于与 Windows 管理规范 (WMI) 交互的对象。
    Dim colProcess ' 匹指定名称的进程集合。
    Dim killCount ' 记录终止的进程数量的计数器。
    
    Set objWMIService = GetObject("winmgmts:\\.\root\cimv2") ' 连接到 WMI 服务。
    Set colProcess = objWMIService.ExecQuery("SELECT * FROM Win32_Process WHERE Name='" & processName & "'") ' 查询指定的进程。
    
    killCount = 0
    If colProcess.Count > 0 Then ' 检查是否找到任何进程。
        For Each objProcess In colProcess ' 遍历每个进程。
            objProcess.Terminate() ' 终止进程。
            killCount = killCount + 1 ' 增加终止计数器。
        Next
    Else
        If Not outputErrors.Exists(processName) Then ' 检查错误是否已报告。
            outputErrors.Add processName, "Failed to kill" ' 在错误字典中记录失败。
        End If
    End If
End Function

' 此子程序协调解除功能限制和终止进程的过程。
Sub Main()
    Dim inputProcesses ' 用于捕获用户输入的变量（要终止的进程）。
    Dim processesArray ' 用于存储要终止的进程列表的数组。
    Dim failProcesses ' 用于跟踪无法终止的进程的字典。
    Dim processName ' 用于遍历进程名称的变量。
    
    WScript.Echo "正在解除限制功能..." ' 通知用户解除限制过程已开始。
    UnbanFeatures ' 调用解除功能限制的函数。
    
    inputProcesses = InputBox("请输入要终止的进程名称（用空格分隔，例如：notepad.exe calc.exe）：", "进程名称") ' 提示用户输入要终止的进程。
    
    If inputProcesses <> "" Then ' 确保用户输入了进程名称。
        processesArray = Split(Trim(inputProcesses), " ") ' 将输入拆分为数组。
        
        Set failProcesses = CreateObject("Scripting.Dictionary") ' 初始化一个字典以跟踪失败的进程。
        
        WScript.Echo "正在终止进程..." ' 通知用户终止过程已开始。
        For Each processName In processesArray ' 遍历每个进程名称。
            If processName <> "" Then ' 跳过空条目。
                KillProcess processName, failProcesses ' 尝试终止进程。
            End If
        Next
        
        If failProcesses.Count > 0 Then ' 检查是否有失败的进程。
            MsgBox "以下进程终止失败：" & vbCrLf & Join(failProcesses.Keys, vbCrLf), vbExclamation, "进程终止错误" ' 显示失败的进程消息框。
        Else
            MsgBox "所有进程均已成功终止。", vbInformation, "进程终止成功" ' 确认成功终止。
        End If
    Else
        MsgBox "未输入进程名称，程序已退出。", vbInformation, "程序退出" ' 通知用户未输入进程名称并退出。
    End If
End Sub

Main ' 执行主子程序以启动脚本。