'===============================================
' Script Name: Net Bypass Classroom.vbs
' Description: Unbans restricted Windows features and terminates specified processes.
' Author: 云散皆星河
' Web: 云散皆星河.cn
' Version: 1.0
' Date: 2025-02-05
'===============================================
Dim WSH_SHELL
Set WSH_SHELL = WScript.CreateObject("WScript.Shell") ' Create a shell object to interact with the system.

' This function unrestricts specific Windows features by modifying the registry.
Function UnbanFeatures()
    Dim regPaths ' Array to hold the registry paths of restricted features.
    regPaths = Array( _
        "Software\Microsoft\Windows\CurrentVersion\Policies\System\DisableTaskMgr", _
        "Software\Microsoft\Windows\CurrentVersion\Policies\System\DisableRegistryTools", _
        "Software\Microsoft\Windows\CurrentVersion\Policies\System\DisableCMD", _
        "Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\NoRun" _
    )
    
    Dim regPath, result ' Variables to hold each registry path and the result of the operation.
    For Each regPath In regPaths ' Loop through each registry path.
        result = WSH_SHELL.RegWrite("HKEY_CURRENT_USER\" & regPath, 0, "REG_DWORD") ' Write a DWORD value of 0 to enable the feature.
        If result Then ' Check if the operation was successful.
            WScript.Echo "Successfully unblocked: " & Split(regPath, "\")(UBound(Split(regPath, "\"))) ' Notify the user of success.
        Else
            WScript.Echo "Failed to unblock: " & Split(regPath, "\")(UBound(Split(regPath, "\"))) ' Notify the user of failure.
        End If
    Next

    WSH_SHELL.Run "taskmgr.exe", 1, False ' Launch Task Manager to verify the changes.
End Function

' This function terminates a specified process.
Function KillProcess(processName, outputErrors)
    Dim objWMIService ' Object to interact with Windows Management Instrumentation (WMI).
    Dim colProcess ' Collection of processes matching the specified name.
    Dim killCount ' Counter for the number of processes terminated.
    
    Set objWMIService = GetObject("winmgmts:\\.\root\cimv2") ' Connect to the WMI service.
    Set colProcess = objWMIService.ExecQuery("SELECT * FROM Win32_Process WHERE Name='" & processName & "'") ' Query for the specified process.
    
    killCount = 0
    If colProcess.Count > 0 Then ' Check if any processes were found.
        For Each objProcess In colProcess ' Loop through each process.
            objProcess.Terminate() ' Terminate the process.
            killCount = killCount + 1 ' Increment the termination counter.
        Next
    Else
        If Not outputErrors.Exists(processName) Then ' Check if the error hasn't been reported before.
            outputErrors.Add processName, "Failed to kill" ' Record the failure in the error dictionary.
        End If
    End If
End Function

' This subroutine orchestrates the process of unblocking features and terminating processes.
Sub Main()
    Dim inputProcesses ' Variable to capture user input for processes to terminate.
    Dim processesArray ' Array to hold the list of processes to terminate.
    Dim failProcesses ' Dictionary to track processes that couldn't be terminated.
    Dim processName ' Variable to iterate through process names.
    
    WScript.Echo "Initializing feature unblocking..." ' Inform the user about the start of the unblocking process.
    UnbanFeatures ' Call the function to unblock features.
    
    inputProcesses = InputBox("Enter process names to terminate (separate with spaces, e.g., notepad.exe calc.exe):", "Process Names") ' Prompt the user for processes to terminate.
    
    If inputProcesses <> "" Then ' Ensure the user entered process names.
        processesArray = Split(Trim(inputProcesses), " ") ' Split the input into an array.
        
        Set failProcesses = CreateObject("Scripting.Dictionary") ' Initialize a dictionary to track failures.
        
        WScript.Echo "Starting process termination..." ' Inform the user about the start of termination.
        For Each processName In processesArray ' Loop through each process name.
            If processName <> "" Then ' Skip empty entries.
                KillProcess processName, failProcesses ' Attempt to terminate the process.
            End If
        Next
        
        If failProcesses.Count > 0 Then ' Check if there were any failures.
            MsgBox "Failed to terminate the following processes:" & vbCrLf & Join(failProcesses.Keys, vbCrLf), vbExclamation, "Termination Errors" ' Display a message box with failed processes.
        Else
            MsgBox "All processes were terminated successfully.", vbInformation, "Termination Successful" ' Confirm successful termination.
        End If
    Else
        MsgBox "No processes entered. Exiting the program.", vbInformation, "Program Exit" ' Inform the user if no processes were entered.
    End If
End Sub

Main ' Execute the main subroutine to start the script.