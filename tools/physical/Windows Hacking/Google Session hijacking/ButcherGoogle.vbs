' Morpheus: Use with proper authorization only

Option Explicit

Dim fso, shell, userProfile, scriptPath, datasFolder
Dim foldersToSearch, totalFiles, copiedSize, allJPGs, foundCount
Dim ie, i, percent, logLines(4), logIndex

Set fso = CreateObject("Scripting.FileSystemObject")
Set shell = CreateObject("WScript.Shell")

userProfile = shell.ExpandEnvironmentStrings("%USERPROFILE%")
scriptPath = fso.GetParentFolderName(WScript.ScriptFullName)
datasFolder = scriptPath & "\Datas"

If Not fso.FolderExists(datasFolder) Then fso.CreateFolder(datasFolder)

foldersToSearch = Array(userProfile & "\Desktop", userProfile & "\Documents", userProfile & "\Pictures", userProfile & "\Downloads", "D:\")

Set allJPGs = CreateObject("Scripting.Dictionary")
foundCount = 0
logIndex = 0
copiedSize = 0

' --- 1. Barcha JPG fayllarni topib, umumiy sonini olish ---
For i = 0 To UBound(foldersToSearch)
    CountJPGs foldersToSearch(i)
Next

If allJPGs.Count = 0 Then
    MsgBox "JPG topilmadi!", 64, "Morpheus"
    WScript.Quit
End If

totalFiles = allJPGs.Count

' --- 2. IE oynasini ochish va “hacker style” progress oynasi yasash ---
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

' --- 3. JPG fayllarni ko‘chirish va progressni IE oynasida ko‘rsatish ---
Dim k, logMsg
For Each k In allJPGs.Keys
    On Error Resume Next
    fso.CopyFile k, datasFolder & "\" & fso.GetFileName(k), True
    foundCount = foundCount + 1
    percent = Int((foundCount / totalFiles) * 100)
    
    ' Log lines
    If logIndex < 4 Then
        logLines(logIndex) = "Copied: " & fso.GetFileName(k)
        logIndex = logIndex + 1
    Else
        Dim j
        For j = 1 To 3
            logLines(j-1) = logLines(j)
        Next
        logLines(3) = "Copied: " & fso.GetFileName(k)
    End If

    ' Loglarni html formatda tayyorlash
    logMsg = ""
    For j = 0 To 3
        If logLines(j) <> "" Then
            logMsg = logMsg & logLines(j) & "<br>"
        End If
    Next

    ' --- IE oynasini yangilash ---
    With ie.Document
        .GetElementById("bar").Style.Width = percent & "%"
        .GetElementById("percent").innerText = percent & "%"
        .GetElementById("log").innerHTML = logMsg
    End With

    WScript.Sleep 30
Next

' --- 4. Tamom bo‘lganda ochiq oynani yangilash va yopish ---
Do While ie.Busy Or ie.ReadyState <> 4
    WScript.Sleep 100
Loop
ie.Document.Body.InnerHTML = "<h2 style='color:#00FF00;'>COMPLETED! Copied: " & foundCount & " JPG</h2>"
WScript.Sleep 700

On Error Resume Next
If Not ie Is Nothing Then
    ie.Quit
    Set ie = Nothing
End If
On Error GoTo 0

MsgBox "Bajarildi! Topilgan va ko‘chirilgan JPG fayllar: " & foundCount, 64, "Morpheus"

' --- Functions ---
Sub CountJPGs(folderPath)
    On Error Resume Next
    Dim folder, file, subfolder
    If fso.FolderExists(folderPath) Then
        Set folder = fso.GetFolder(folderPath)
        For Each file In folder.Files
            If LCase(fso.GetExtensionName(file.Name)) = "jpg" Then
                If Left(file.Name, 1) <> "$" Then
                    If Not allJPGs.Exists(file.Path) Then
                        allJPGs.Add file.Path, ""
                    End If
                End If
            End If
        Next
        For Each subfolder In folder.SubFolders
            CountJPGs subfolder.Path
        Next
    End If
End Sub