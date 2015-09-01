'------------------------------------------------------------------------------
' Script for downloading and silently installing MSI
'------------------------------------------------------------------------------

strSaveTo = "C:\NJCInst\Download"
strURL = "http://www.domain.com/downloads/File.msi"
strExecute = "customer.ScreenConnect.ClientSetup.msi"


'------------------------------------------------------------------------------
' Download File
'------------------------------------------------------------------------------
WScript.Echo "Downloading to: " & strSaveTo
HTTPDownload strURL, strFile
Set oCmd = CreateObject("Wscript.Shell")


'------------------------------------------------------------------------------
' Execute command
'------------------------------------------------------------------------------
commandLine = "MSIexec /I "& strSaveTo & "\" & strExecute & " /quiet"
WScript.Echo "Installing: " & strExecute
oCmd.Run commandLine, 0, True


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
 
