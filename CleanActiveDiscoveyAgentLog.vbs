'------------------------------------------------------------------------------
' Remove Rouge log files created by Active Discovery Agent
'------------------------------------------------------------------------------
' The Active Discovery Agent creates log files and does not clean itself up
' therefore it is necessary to clean these files manually
'------------------------------------------------------------------------------



Set oFileSys = WScript.CreateObject("Scripting.FileSystemObject")
sRoot = "C:\ProgramData\AdvancedMonitoringAgentNetworkManagement"
today = Date
nMaxFileAge = 3	 'Files older than this (in days) will be deleted

nCount = 0 'Count how many files were removed
nTotalSize = 0 'Keep track of total file size recovered

WScript.echo "Cleaning up Active Discovey log files over " & nMaxFileAge & " days old"

DeleteFiles(sRoot)

WScript.echo " "
WScript.echo "==== RESULTS ===="
WScript.echo " "
WScript.echo "Total Files Removed: " & nCount
WScript.echo "Total Space Recovered: " & ConvertSize(nTotalSize)


'------------------------------------------------------------------------------
' Delete files over the assigned age
'------------------------------------------------------------------------------
Function DeleteFiles(ByVal sFolder)

	Set oFolder = oFileSys.GetFolder(sFolder)
	Set aFiles = oFolder.Files

	For Each file in aFiles
		dFileCreated = FormatDateTime(file.DateLastModified, "2")
		If DateDiff("d", dFileCreated, today) > nMaxFileAge Then
		                nSize = ConvertSize( file.size)
                        WScript.echo "Deleted: "& file.Name & " : " & nSize
                        nTotalSize = nTotalSize + file.size
                        nCount = nCount +1
			file.Delete(True)
                        
		End If
	Next


End Function

'------------------------------------------------------------------------------
' Conver file size to KB/MB/GB/TB for readability
'------------------------------------------------------------------------------
Function ConvertSize(Size) 
Size = CSng(Replace(Size,",",""))

If Not VarType(Size) = vbSingle Then 
ConvertSize = "SIZE INPUT ERROR"
Exit Function
End If

Suffix = " Bytes" 
If Size >= 1024 Then suffix = " KB" 
If Size >= 1048576 Then suffix = " MB" 
If Size >= 1073741824 Then suffix = " GB" 
If Size >= 1099511627776 Then suffix = " TB" 

Select Case Suffix 
Case " KB" Size = Round(Size / 1024, 1) 
Case " MB" Size = Round(Size / 1048576, 1) 
Case " GB" Size = Round(Size / 1073741824, 1) 
Case " TB" Size = Round(Size / 1099511627776, 1) 
End Select

ConvertSize = Size & Suffix 
End Function
