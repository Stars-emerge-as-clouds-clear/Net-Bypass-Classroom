'===============================================
' �ű�����: Net Bypass Classroom.vbs
' ����: ��� Windows ���ƹ��ܲ���ָֹ�����̡�
' ����: ��ɢ���Ǻ�
' ��վ: ��ɢ���Ǻ�.cn
' �汾: 1.0
' ����: 2025-02-05
'===============================================
Dim WSH_SHELL
Set WSH_SHELL = WScript.CreateObject("WScript.Shell") ' ����һ���Ƕ�������ϵͳ������

' �˺���ͨ���޸�ע���������ض� Windows ���ܵ����ơ�
Function UnbanFeatures()
    Dim regPaths ' ���ڴ洢���޹��ܵ�ע���·�������顣
    regPaths = Array( _
        "Software\Microsoft\Windows\CurrentVersion\Policies\System\DisableTaskMgr", _
        "Software\Microsoft\Windows\CurrentVersion\Policies\System\DisableRegistryTools", _
        "Software\Microsoft\Windows\CurrentVersion\Policies\System\DisableCMD", _
        "Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\NoRun" _
    )
    
    Dim regPath, result ' ���ڴ洢ÿ��ע���·���Ͳ�������ı�����
    For Each regPath In regPaths ' ����ÿ��ע���·����
        result = WSH_SHELL.RegWrite("HKEY_CURRENT_USER\" & regPath, 0, "REG_DWORD") ' д��ֵΪ 0 �� DWORD �����ù��ܡ�
        If result Then ' �������Ƿ�ɹ���
            WScript.Echo  "�ɹ�������ƣ�" & Split(regPath, "\")(UBound(Split(regPath, "\"))) ' ֪ͨ�û��ɹ���
        Else
            WScript.Echo "�������ʧ�ܣ�" & Split(regPath, "\")(UBound(Split(regPath, "\"))) ' ֪ͨ�û�ʧ�ܡ�
        End If
    Next

    WSH_SHELL.Run "taskmgr.exe", 1, False ' �����������������֤���ġ�
End Function

' �˺�����ָֹ���Ľ��̡�
Function KillProcess(processName, outputErrors)
    Dim objWMIService ' ������ Windows ����淶 (WMI) �����Ķ���
    Dim colProcess ' ƥָ�����ƵĽ��̼��ϡ�
    Dim killCount ' ��¼��ֹ�Ľ��������ļ�������
    
    Set objWMIService = GetObject("winmgmts:\\.\root\cimv2") ' ���ӵ� WMI ����
    Set colProcess = objWMIService.ExecQuery("SELECT * FROM Win32_Process WHERE Name='" & processName & "'") ' ��ѯָ���Ľ��̡�
    
    killCount = 0
    If colProcess.Count > 0 Then ' ����Ƿ��ҵ��κν��̡�
        For Each objProcess In colProcess ' ����ÿ�����̡�
            objProcess.Terminate() ' ��ֹ���̡�
            killCount = killCount + 1 ' ������ֹ��������
        Next
    Else
        If Not outputErrors.Exists(processName) Then ' �������Ƿ��ѱ��档
            outputErrors.Add processName, "Failed to kill" ' �ڴ����ֵ��м�¼ʧ�ܡ�
        End If
    End If
End Function

' ���ӳ���Э������������ƺ���ֹ���̵Ĺ��̡�
Sub Main()
    Dim inputProcesses ' ���ڲ����û�����ı�����Ҫ��ֹ�Ľ��̣���
    Dim processesArray ' ���ڴ洢Ҫ��ֹ�Ľ����б�����顣
    Dim failProcesses ' ���ڸ����޷���ֹ�Ľ��̵��ֵ䡣
    Dim processName ' ���ڱ����������Ƶı�����
    
    WScript.Echo "���ڽ�����ƹ���..." ' ֪ͨ�û�������ƹ����ѿ�ʼ��
    UnbanFeatures ' ���ý���������Ƶĺ�����
    
    inputProcesses = InputBox("������Ҫ��ֹ�Ľ������ƣ��ÿո�ָ������磺notepad.exe calc.exe����", "��������") ' ��ʾ�û�����Ҫ��ֹ�Ľ��̡�
    
    If inputProcesses <> "" Then ' ȷ���û������˽������ơ�
        processesArray = Split(Trim(inputProcesses), " ") ' ��������Ϊ���顣
        
        Set failProcesses = CreateObject("Scripting.Dictionary") ' ��ʼ��һ���ֵ��Ը���ʧ�ܵĽ��̡�
        
        WScript.Echo "������ֹ����..." ' ֪ͨ�û���ֹ�����ѿ�ʼ��
        For Each processName In processesArray ' ����ÿ���������ơ�
            If processName <> "" Then ' ��������Ŀ��
                KillProcess processName, failProcesses ' ������ֹ���̡�
            End If
        Next
        
        If failProcesses.Count > 0 Then ' ����Ƿ���ʧ�ܵĽ��̡�
            MsgBox "���½�����ֹʧ�ܣ�" & vbCrLf & Join(failProcesses.Keys, vbCrLf), vbExclamation, "������ֹ����" ' ��ʾʧ�ܵĽ�����Ϣ��
        Else
            MsgBox "���н��̾��ѳɹ���ֹ��", vbInformation, "������ֹ�ɹ�" ' ȷ�ϳɹ���ֹ��
        End If
    Else
        MsgBox "δ����������ƣ��������˳���", vbInformation, "�����˳�" ' ֪ͨ�û�δ����������Ʋ��˳���
    End If
End Sub

Main ' ִ�����ӳ����������ű���