'------------------------------------------------------------------------------
' niniteupdate.vbs
'------------------------------------------------------------------------------
' Script that will download and run ninite pro to update your software.
'------------------------------------------------------------------------------
'------------------------------------------------------------------------------
' Author: Mike Wilson with some of the code copied from Jake Paternoster
' updates and amendments by Paul Benn
'------------------------------------------------------------------------------
'Usage: ninite_update.vbs /Cachepath:"\\<server>\<share>"
' 
'  (Optional) Cachepath: Ninite Pro automatically saves and reuses downloads in
'                        a NiniteDownloads folder it creates in the same 
'                        directory as the Ninite .exe. Ninite Pro still checks 
'                         for new versions of applications and downloads them if
'                         they are not already in the cache.
'                        To specify a different cache location, like a network
'                         share, use the /cachepath switch:
' 
' ex: ninite_update.vbs /Cachepath:"\\server1\sharedfolder"
'------------------------------------------------------------------------------
' ***WARNING*** Run this script at your own risk. I am not responsible for any  
' ***WARNING*** damage it may cause!
'------------------------------------------------------------------------------
'------------------------------------------------------------------------------
' ***WARNING*** If you use dropbox - anyone that sees your url has access to 
' ***WARNING*** update any computers they want to on your dime. Also, this 
' ***WARNING*** script does a secure erase of the ninite exe file from system.
'------------------------------------------------------------------------------
'------------------------------------------------------------------------------
' ***WARNING*** Keep in mind that this script will leave your Ninite executable 
' ***WARNING*** in the downloaded location on the PC. Anyone, including your  
' ***WARNING*** competition could steal it and update systems on your dime!
'------------------------------------------------------------------------------
strNJC_Inst = "C:\NJCInst"
strSaveTo = "C:\NJCInst\NiniteOne"                            '<=== working directory to save files to. must be only 1 level deep or pre-created
'strSaveTo = ""                                                '<=== uncomment if you want to use windows temp directory
strAuditrpt = "Auditrpt.txt"                                   '<=== change to file name for audit report output
strUpdterpt = "Updaterpt.txt"                                  '<=== change to file name for update report output
strURL = "http://domain.com/downloads/NiniteOne.exe" '<=== URL to download your ninite pro executable from ***dropbox https not working***
strExecute = "NiniteOne.exe"                                   '<=== name of your ninite pro executable (normally niniteone.exe)
strAudparm = "/audit /silent "                                 '<=== audit switches
strSDparm = "/p 3 /q "
If strSaveTo <> "" Then
 strAuditrpt = strSaveTo & "\" & strAuditrpt
 strUpdterpt = strSaveTo & "\" & strUpdterpt 
End if
strCache = "" 
strUpdparm = "/updateonly /disableautoupdate /disableshortcuts /allusers /exclude teamviewer /silent " & strUpdterpt  '<== update switches
strFile = strURL
 
'------------------------------------------------------------------------------
' Add /Cachepath parm to command line if one was specified on commandline
'------------------------------------------------------------------------------ 
If WScript.Arguments.Named("cachepath") <> "" Then 
 strCache = "/cachepath " & WScript.Arguments.Named("cachepath")
 strUpdparm = strUpdparm & " " & strCache
End If 
'------------------------------------------------------------------------------
' Use Windows temp directory if strSaveTo not specified
'------------------------------------------------------------------------------ 
If strSaveTo = "" Then
 strSaveTo = WScript.CreateObject("Scripting.FileSystemObject").GetSpecialFolder(2)
End If
 
' Create a File System Object
Set objFSO = CreateObject( "Scripting.FileSystemObject" )
 
'------------------------------------------------------------------------------ 
' Check if the specified target file or folder exists,
' and build the fully qualified path of the target file
'------------------------------------------------------------------------------ 
If NOT objFSO.FolderExists(strNJC_Inst) Then
WScript.Echo "Creating Folder: " & strNJC_Inst
  objFSO.CreateFolder strNJC_Inst
 End If 
 
If objFSO.FolderExists(strSaveTo) Then
 strFile = objFSO.BuildPath(strSaveTo, Mid(strURL, InstrRev(strURL, "/" ) + 1 ) )
 ElseIf objFSO.FolderExists(Left(strSaveTo, InStrRev(strSaveTo, "\" ) - 1 ) ) Then
  WScript.Echo "Creating Folder: " & strSaveTo
  objFSO.CreateFolder strSaveTo
  strFile = objFSO.BuildPath(strSaveTo, Mid(strURL, InstrRev(strURL, "/" ) + 1 ) ) 
 
Else
 WScript.Echo "ERROR: Target folder not found."
 WScript.Quit(2)
End If
 
If objFSO.Fileexists(strFile) Then
 WScript.Echo strFile & " Already Exists!, overwriting..."
 objFSO.DeleteFile strFile                                      '<=== delete pre-existing file
End If
 
'------------------------------------------------------------------------------
' Download niniteone
'------------------------------------------------------------------------------
WScript.Echo "Downloading to: " & strSaveTo
HTTPDownload strURL, strFile
Set oCmd = CreateObject("Wscript.Shell")
 
'------------------------------------------------------------------------------
' Execute ninite update command
'------------------------------------------------------------------------------
commandLine = strSaveTo & "\" & strExecute & " " & strUpdparm 
WScript.Echo "Running Update: " & strExecute & " " & strUpdparm 
oCmd.Run commandLine, 0, True
 
'------------------------------------------------------------------------------
' Execute ninite audit command
'------------------------------------------------------------------------------
commandLine = strSaveTo & "\" & strExecute & " " & strAudparm & " " & strAuditrpt
WScript.Echo "Running Audit: " & strExecute & " " & strAudparm & " " & strAuditrpt
oCmd.Run commandLine, 0, True
 
'------------------------------------------------------------------------------
' open Update Report echo back what was updated
'------------------------------------------------------------------------------
Set objFZ = objFSO.GetFile(strUpdterpt)
Set objFile = objFSO.OpenTextFile(strUpdterpt, 1)
If objFZ.Size > 0 Then
 Wscript.Echo "***Products Updated:***"
 Do Until objFile.AtEndOfStream
  strLine = objFile.ReadLine
  If InStr(strLine, ": OK") > 0 Then 
    Wscript.Echo strLine
  End if
 Loop
objFile.Close
Else
 Wscript.Echo "No Applications were Updated."
End If
 
'------------------------------------------------------------------------------
' open audit report and echo back what was updated
'------------------------------------------------------------------------------
Set objFZ = objFSO.GetFile(strAuditrpt)
Set objFile = objFSO.OpenTextFile(strAuditrpt, 1)
If objFZ.Size > 0 Then
 Wscript.Echo "***Products Require Updating:***"
 Do Until objFile.AtEndOfStream
  strLine = objFile.ReadLine
  If InStr(strLine, "Update -") > 0 Then 
   Wscript.Echo strLine
  End if
 Loop
objFile.Close
Else
 Wscript.Echo "The file is empty."
End If
 
'------------------------------------------------------------------------------
' open audit report and echo back what was NOT updated
'------------------------------------------------------------------------------
Set objFZ = objFSO.GetFile(strAuditrpt)
Set objFile = objFSO.OpenTextFile(strAuditrpt, 1)
If objFZ.Size > 0 Then
 Wscript.Echo "***Products Skipped listed below:***"
 Do Until objFile.AtEndOfStream
  strLine = objFile.ReadLine
  If InStr(strLine, "Skipped -") > 0 Then 
   Wscript.Echo strLine
  End if
 Loop
objFile.Close
Else
 Wscript.Echo "The file is empty."
End If
 
'------------------------------------------------------------------------------
' open audit report for 2nd time and echo back what was updated
'------------------------------------------------------------------------------
Set objFile = objFSO.OpenTextFile(strAuditrpt, 1)
If objFZ.Size > 0 Then
 Wscript.Echo "***Products installed and up to date below:***"
 Do Until objFile.AtEndOfStream
  strLine = objFile.ReadLine
  If InStr(strLine, "OK -") > 0 Then 
    Wscript.Echo strLine
  End if
 Loop
objFile.Close
Else
 Wscript.Echo "The file is empty."
End If
 
 
'--------------------------------------------------------------------------------
' Remove NiniteOne as we dont want this laying around as it costs money!!
'--------------------------------------------------------------------------------
If objFSO.Fileexists(strFile) Then
 WScript.Echo " Removing NiniteOne File! ..." & strFile
 objFSO.DeleteFile strFile                                      '<=== delete pre-existing file
End If
 
WScript.Quit(0)                                                '<=== End script 
 
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
 
