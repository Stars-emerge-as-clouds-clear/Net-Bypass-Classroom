Dim WSH_SHELL
Set WSH_SHELL = WScript.CreateObject("WScript.Shell")

Function UnbanFeatures()
    Dim regPaths
    regPaths = Array( _
        "Software\Microsoft\Windows\CurrentVersion\Policies\System\DisableTaskMgr", _
        "Software\Microsoft\Windows\CurrentVersion\Policies\System\DisableRegistryTools", _
        "Software\Microsoft\Windows\CurrentVersion\Policies\System\DisableCMD", _
        "Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\NoRun" _
    )
    
    Dim regPath, result
    For Each regPath In regPaths
        result = WSH_SHELL.RegWrite("HKEY_CURRENT_USER\" & regPath, 0, "REG_DWORD")
        If result Then
            WScript.Echo "Unbanned " & Split(regPath, "\")(UBound(Split(regPath, "\"))) & " successfully"
        Else
            WScript.Echo "Failed to unban " & Split(regPath, "\")(UBound(Split(regPath, "\"))) & ""
        End If
    Next

    WSH_SHELL.Run "taskmgr.exe", 1, False
End Function

Function KillProcess(processName, outputErrors)
    Dim objWMIService, colProcess, killCount
    Set objWMIService = GetObject("winmgmts:\\.\root\cimv2")
    Set colProcess = objWMIService.ExecQuery("SELECT * FROM Win32_Process WHERE Name='" & processName & "'")
    
    killCount = 0
    If colProcess.Count > 0 Then
        For Each objProcess In colProcess
            objProcess.Terminate()
            killCount = killCount + 1
        Next
    Else
        If Not outputErrors.Exists(processName) Then
            outputErrors.Add processName, "Failed to kill"
        End If
    End If
End Function

Sub Main
    Dim inputProcesses, processesArray
    Dim failProcesses, processName
    
    WScript.Echo "Starting to unban restricted features..."
    UnbanFeatures
    
    inputProcesses = InputBox("Enter process names to kill (separated by spaces, e.g., notepad.exe calc.exe):", "Process Names")
    
    If inputProcesses <> "" Then
        processesArray = Split(Trim(inputProcesses), " ")
        
        Set failProcesses = CreateObject("Scripting.Dictionary")
        
        WScript.Echo "Starting to terminate processes..."
        For Each processName In processesArray
            If processName <> "" Then
                KillProcess processName, failProcesses
            End If
        Next
        
        If failProcesses.Count > 0 Then
            MsgBox "Failed to kill the following processes:" & vbCrLf & Join(failProcesses.Keys, vbCrLf), vbExclamation, "Process Kill Errors"
        Else
            MsgBox "All processes were terminated successfully.", vbInformation, "Process Termination Successful"
        End If
    Else
        MsgBox "No process names entered. The program has exited.", vbInformation, "Program Exit"
    End If
End Sub

' Execute the main subroutine
Main