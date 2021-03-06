'------------------------------------------------------------------------------
' InstallMSI.vbs
'------------------------------------------------------------------------------
' Script for downloading MSI Install and then silently installing with feedback
'------------------------------------------------------------------------------
'------------------------------------------------------------------------------
' Author: Paul Benn, Not Just Computers
'------------------------------------------------------------------------------



strSaveTo = "C:\NJCInst\Download"
strURL = "http://www.domain.com/downloads/File.msi"
strExecute = "customer.ScreenConnect.ClientSetup.msi"
strLocalFile = strSaveTo & "\" & strExecute


'------------------------------------------------------------------------------
' Setup any objects used
'------------------------------------------------------------------------------
Set FSO  = CreateObject("Scripting.FileSystemObject")
Set oCmd = CreateObject("Wscript.Shell")

'------------------------------------------------------------------------------
' Check if file exists and delete
'------------------------------------------------------------------------------
If objFSO.Fileexists(strLocalFile) Then
 WScript.Echo "Deleted file already downloaded: " & strLocalFile
 objFSO.DeleteFile strLocalFile
End If

'------------------------------------------------------------------------------
' Download File
'------------------------------------------------------------------------------
DownloadPath strSaveTo
WScript.Echo "Downloading to: " & strSaveTo
HTTPDownload strURL, strLocalFile


'------------------------------------------------------------------------------
' Execute command
'------------------------------------------------------------------------------
commandLine = "MSIexec /I "& strSaveTo & "\" & strExecute & " /quiet"
WScript.Echo "Installing: " & strExecute
x = oCmd.Run(commandLine, 0, True)
WScript.Echo "Exit Code: " & x

'------------------------------------------------------------------------------
' Release objects
'------------------------------------------------------------------------------
Set FSO  = Nothing
Set oCmd = Nothing


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
Else if x = 1604
WScript.Echo "Already installed : " & strExecute
WScript.quit(0)
Else
WScript.Echo " installation error : "
WScript.Echo "Installer Name : " & strExecute
WScript.quit(1001)
End if



'------------------------------------------------------------------------------
' subroutine check for download folder and create if required
'------------------------------------------------------------------------------

Sub DownloadPath(DirPath)
Dim aDirectories, sCreateDirectory, iDirectory


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
 
