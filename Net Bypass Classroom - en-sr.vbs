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

Sub Main
    WScript.Echo "Starting to unban restricted features..."
    UnbanFeatures
    MsgBox "All features have been unbanned successfully.", vbInformation, "Unban Successful"
End Sub

Main