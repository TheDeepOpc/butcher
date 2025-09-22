' Morpheus: Use with proper authorization only

Option Explicit

Dim fso, shell, userProfile, scriptPath, datasFolder
Dim foldersToSearch, totalFiles, allTargetFiles, foundCount
Dim ie, i, percent, logLines(4), logIndex, updateCounter
Dim j, k, logMsg

Set fso = CreateObject("Scripting.FileSystemObject")
Set shell = CreateObject("WScript.Shell")

userProfile = shell.ExpandEnvironmentStrings("%USERPROFILE%")
scriptPath = fso.GetParentFolderName(WScript.ScriptFullName)
datasFolder = scriptPath & "\Datas"

If Not fso.FolderExists(datasFolder) Then fso.CreateFolder(datasFolder)

foldersToSearch = Array(userProfile & "\Desktop", userProfile & "\Documents", userProfile & "\Pictures", userProfile & "\Downloads", "D:\")

Set allTargetFiles = CreateObject("Scripting.Dictionary")
foundCount = 0
logIndex = 0

' Find all target files and get their total count
For i = 0 To UBound(foldersToSearch)
    CountTargetFiles foldersToSearch(i)
Next

If allTargetFiles.Count = 0 Then
    MsgBox "PNG, PDF, RTF yoki MD topilmadi!", 64, "Morpheus"
    WScript.Quit
End If

totalFiles = allTargetFiles.Count

' Open IE window and set design
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

updateCounter = 0

For Each k In allTargetFiles.Keys
    On Error Resume Next
    fso.CopyFile k, datasFolder & "\" & fso.GetFileName(k), True
    foundCount = foundCount + 1
    updateCounter = updateCounter + 1

    ' Log lines
    If logIndex < 4 Then
        logLines(logIndex) = "Copied: " & fso.GetFileName(k)
        logIndex = logIndex + 1
    Else
        For j = 1 To 4
            logLines(j-1) = logLines(j)
        Next
        logLines(4) = "Copied: " & fso.GetFileName(k)
    End If

    ' Update progress after every 20 files or at the last file
    If (updateCounter Mod 20 = 0) Or (foundCount = totalFiles) Then
        percent = Int((foundCount / totalFiles) * 100)
        logMsg = ""
        For j = 0 To 4
            If logLines(j) <> "" Then
                logMsg = logMsg & logLines(j) & "<br>"
            End If
        Next

        With ie.Document
            .GetElementById("bar").Style.Width = percent & "%"
            .GetElementById("percent").innerText = percent & "%"
            .GetElementById("log").innerHTML = logMsg
        End With
    End If
Next

' On completion, update and close the window
Do While ie.Busy Or ie.ReadyState <> 4
    WScript.Sleep 100
Loop
ie.Document.Body.InnerHTML = "<h2 style='color:#00FF00;'>COMPLETED! Copied: " & foundCount & " files (PNG, PDF, RTF, MD)</h2>"
WScript.Sleep 700

On Error Resume Next
If Not ie Is Nothing Then
    ie.Quit
    Set ie = Nothing
End If
On Error GoTo 0

MsgBox "Bajarildi! Topilgan va ko‘chirilgan fayllar (PNG, PDF, RTF, MD): " & foundCount, 64, "Morpheus"

' --- Functions ---
Sub CountTargetFiles(folderPath)
    On Error Resume Next
    Dim folder, file, subfolder, ext
    If fso.FolderExists(folderPath) Then
        Set folder = fso.GetFolder(folderPath)
        For Each file In folder.Files
            ext = LCase(fso.GetExtensionName(file.Name))
            If ext = "png" Or ext = "pdf" Or ext = "rtf" Or ext = "md" Then
                If Left(file.Name, 1) <> "$" Then
                    If Not allTargetFiles.Exists(file.Path) Then
                        allTargetFiles.Add file.Path, ""
                    End If
                End If
            End If
        Next
        For Each subfolder In folder.SubFolders
            CountTargetFiles subfolder.Path
        Next
    End If
End Sub