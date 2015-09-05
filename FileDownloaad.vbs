'------------------------------------------------------------------------------
' Script for downloading and running the downloaded file
'------------------------------------------------------------------------------

strSaveTo = "C:\NJCInst\Download"
strURL = "http://www.domain.com/downloads/File.exe"
strExecute = "File.exe"


'------------------------------------------------------------------------------
' Setup variables used in script
'------------------------------------------------------------------------------
strFile = strSaveTo & "\" & strExecute


'------------------------------------------------------------------------------
' Download File
'------------------------------------------------------------------------------
DownloadPath strSaveTo
WScript.Echo "Downloading: " & strExecute & " to: " & strSaveTo
HTTPDownload strURL, strFile
Set oCmd = CreateObject("Wscript.Shell")


'------------------------------------------------------------------------------
' Execute command
'------------------------------------------------------------------------------
commandLine = strFile
WScript.Echo "Executing: " & strExecute
oCmd.Run commandLine, 0, True


'------------------------------------------------------------------------------
' subroutine check for download folder and create if required
'------------------------------------------------------------------------------
 
Sub DownloadPath(DirPath)
Dim aDirectories, sCreateDirectory, iDirectory
Set FSO  = CreateObject("Scripting.FileSystemObject")
 
If FSO.FolderExists(DirPath) Then
WScript.Echo "Download folder exists"
Else

aDirectories = Split(DirPath, "\")
sCreateDirectory = aDirectories(0)
For iDirectory = 1 To UBound(aDirectories)
sCreateDirectory = sCreateDirectory & "\" & aDirectories(iDirectory)
If Not FSO.FolderExists(sCreateDirectory) Then
FSO.CreateFolder(sCreateDirectory)
End If
Next
WScript.Echo "Download folder created"
End If

Set FSO = Nothing
End Sub


'------------------------------------------------------------------------------
' subroutine to call for downloading file
'------------------------------------------------------------------------------
Sub HTTPDownload(myURL, strFile)
 
 Set objXMLHTTP = CreateObject("MSXML2.XMLHTTP")
 
 objXMLHTTP.open "GET", myURL, false
 objXMLHTTP.send()
 
 If objXMLHTTP.Status = 200 Then
  Set objADOStream = CreateObject("ADODB.Stream")
  objADOStream.Open
  objADOStream.Type = 1 'adTypeBinary
 
  objADOStream.Write objXMLHTTP.ResponseBody
  objADOStream.Position = 0 'Set the stream position to the start
 
  objADOStream.SaveToFile strFile
  objADOStream.Close
  Set objADOStream = Nothing
 End if
 
 Set objXMLHTTP = Nothing
End Sub
 
