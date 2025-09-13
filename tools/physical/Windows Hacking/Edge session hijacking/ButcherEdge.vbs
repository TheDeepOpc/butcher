Option Explicit

Dim fso, shell, userProfile, scriptPath, backupFolder, sourceFolder
Dim totalSize, copiedSize, ie

Set fso = CreateObject("Scripting.FileSystemObject")
Set shell = CreateObject("WScript.Shell")

On Error Resume Next
shell.Run "taskkill /IM msedge.exe /F", 0, True
On Error GoTo 0

userProfile = shell.ExpandEnvironmentStrings("%USERPROFILE%")
scriptPath = fso.GetParentFolderName(WScript.ScriptFullName)
backupFolder = scriptPath & "\Backup_Edge"
If Not fso.FolderExists(backupFolder) Then fso.CreateFolder(backupFolder)
sourceFolder = userProfile & "\AppData\Local\Microsoft\Edge\User Data\Default"

If fso.FolderExists(sourceFolder) Then
    totalSize = GetFolderSize(sourceFolder)
    copiedSize = 0

    Set ie = CreateObject("InternetExplorer.Application")
    ie.Visible = True
    ie.Toolbar = False
    ie.StatusBar = False
    ie.Width = 1000
    ie.Height = 350
    ie.Left = 500
    ie.Top = 200
    ie.Navigate("about:blank")
    Do While ie.Busy Or ie.ReadyState <> 4
        WScript.Sleep 100
    Loop

    ie.Document.Write "<html><head><title>Butcher</title></head>" & _
        "<body style='font-family:Courier New; background:black; color:#00FF00; text-align:center; overflow:hidden;'>" & _
        "<h2>Butcher started</h2>" & _
        "<div style='width:90%;height:30px;border:1px solid #00FF00;margin:auto;'>" & _
        "<div id='bar' style='width:0%;height:100%;background:#00FF00;'></div></div> <br/>" & _
        "<pre id='log' style='text-align:left; width:90%; margin:auto; height:80px; overflow:hidden;'></pre>" & _
        "<p id='percent'>0%</p>" & _
        "</body></html>"
    ie.Document.Close

    CopyFolderWithLiveProgress sourceFolder, backupFolder & "\Default"

    Do While ie.Busy Or ie.ReadyState <> 4
        WScript.Sleep 100
    Loop
    ie.Document.Body.InnerHTML = "<h2 style='color:#00FF00;'>COMPLETED!</h2>"
    WScript.Sleep 500

    On Error Resume Next
    If Not ie Is Nothing Then
        ie.Quit
        Set ie = Nothing
    End If
    On Error GoTo 0
End If

fso.GetFolder(backupFolder).Attributes = 2 + 4

Function GetFolderSize(folderPath)
    Dim folder, file, subSize
    subSize = 0
    For Each file In fso.GetFolder(folderPath).Files
        subSize = subSize + file.Size
    Next
    For Each folder In fso.GetFolder(folderPath).SubFolders
        subSize = subSize + GetFolderSize(folder.Path)
    Next
    GetFolderSize = subSize
End Function

Sub CopyFolderWithLiveProgress(src, dst)
    Dim folder, file, percent, updateCounter
    If Not fso.FolderExists(dst) Then fso.CreateFolder(dst)
    updateCounter = 0

    For Each file In fso.GetFolder(src).Files
        fso.CopyFile file.Path, dst & "\", True
        copiedSize = copiedSize + file.Size
        updateCounter = updateCounter + 1
        If updateCounter >= 5 Then
            percent = Int((copiedSize / totalSize) * 100)
            UpdateProgress percent, file.Name
            updateCounter = 0
        End If
    Next

    For Each folder In fso.GetFolder(src).SubFolders
        CopyFolderWithLiveProgress folder.Path, dst & "\" & folder.Name
    Next

    If updateCounter > 0 Then
        percent = Int((copiedSize / totalSize) * 100)
        UpdateProgress percent, "Finalizing..."
    End If
End Sub

Sub UpdateProgress(p, fname)
    On Error Resume Next
    ie.Document.GetElementById("bar").Style.Width = p & "%"
    ie.Document.GetElementById("percent").innerText = p & "%"
    ie.Document.GetElementById("log").innerHTML = "Copying: " & fname & vbCrLf & ie.Document.GetElementById("log").innerHTML
End Sub
