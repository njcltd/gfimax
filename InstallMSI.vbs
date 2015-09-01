'------------------------------------------------------------------------------
' Script for downloading and silently installing MSI
'------------------------------------------------------------------------------

strSaveTo = "C:\NJCInst\Download"
strURL = "http://www.domain.com/downloads/File.msi"
strExecute = "customer.ScreenConnect.ClientSetup.msi"


'------------------------------------------------------------------------------
' Download File
'------------------------------------------------------------------------------
DownloadPath strSaveTo
WScript.Echo "Downloading to: " & strSaveTo
HTTPDownload strURL, strFile
Set oCmd = CreateObject("Wscript.Shell")


'------------------------------------------------------------------------------
' Execute command
'------------------------------------------------------------------------------
commandLine = "MSIexec /I "& strSaveTo & "\" & strExecute & " /quiet"
WScript.Echo "Installing: " & strExecute
 = oCmd.Run commandLine, 0, True

'------------------------------------------------------------------------------
' Return install status
'------------------------------------------------------------------------------
If x = 0 OR Then
WScript.Echo "Sucessfully Installed : " & strExecute
WScript.quit(0)
Else if x = 3010 then
WScript.Echo "Sucessfully Installed : " & strExecute
WScript.Echo "Reboot Required to complete the install"
WScript.quit(0)
Else
WScript.Echo " installation error : " & x & " - Installing: " & strExecute
WScript.quit(1001)
End if



'------------------------------------------------------------------------------
' subroutine check for download folder and create if required
'------------------------------------------------------------------------------

Sub DownloadPath(DirPath)
Dim FSO, aDirectories, sCreateDirectory, iDirectory

Set FSO = CreateObject("Scripting.FileSystemObject")
If FSO.FolderExists(DirPath) Then
WScript.Echo "Download folder exists"
Exit Function
End If

aDirectories = Split(DirPath, "\")
sCreateDirectory = aDirectories(0)
For iDirectory = 1 To UBound(aDirectories)
sCreateDirectory = sCreateDirectory & "\" & aDirectories(iDirectory)
If Not FSO.FolderExists(sCreateDirectory) Then
FSO.CreateFolder(sCreateDirectory)
End If
Next
WScript.Echo "Download folder created"
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
 
