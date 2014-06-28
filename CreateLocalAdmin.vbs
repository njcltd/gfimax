Set objShell = CreateObject ("WScript.Shell")  
Set Shell = Nothing 
on error resume Next
 
 
Set NamedArgs = Wscript.Arguments.Named 
strPassword = NamedArgs("newpass")
 
Set oWshNet = CreateObject("WScript.Network")
strComputer = oWshNet.ComputerName
 
strLocalUserName = "LocalAdmin"
strLocalUserFullName = "Local Administrator"
strGroupname = "Administrators"
 
If strPassword = "" Then 
strPassword = "Change_To_your_Password"
End if
 
WScript.Sleep(900)
 
On Error Resume Next
 
Set objUser = GetObject("WinNT://" & strComputer & "/" & strLocalUserName & ",user")
 
If Err.Number <> 0 Then 
objShell.Run "NET USER "&strLocalUserName&" "&strPassword&" /ADD " _
& "/ACTIVE:YES /COMMENT:""Local IT Support Account"" /FULLNAME:""" _
& strLocalUserFullName &""" /expires:never", 0, True
End If
 
On Error Resume Next ' Try again 
Set objUser = GetObject("WinNT://" & strComputer & "/" & strLocalUserName & ",user")
If Err.Number = 0 Then
Set objGroup = GetObject("WinNT://" & strComputer & "/" & strGroupname)
On Error Resume Next
 
objGroup.Add(objUser.ADsPath)

WScript.sleep 600
 
objGroup.Add(objUser.ADsPath)
 
' Error -2147023518 is "The specified account name is already
' a member of the local group."
 
 
End If
 
 
'return state 
If Err.Number <> -2147023518 Then
WScript.Echo("Error Creating User LocalAdmin : " &Err.Number)
WScript.Quit(1001)
Else
WScript.Echo("User LocalAdmin Created Sucessfully : "&strPassword)
WScript.Quit(0)
End if 
 
 
Const ufDONT_EXPIRE_PASSWD = &H10000
objUserFlags = objUser.Get("UserFlags")
if (objUserFlags And ufDONT_EXPIRE_PASSWD) = 0 then
 objUserFlags = objUserFlags Or ufDONT_EXPIRE_PASSWD
 objUser.Put "UserFlags", objUserFlags
 objUser.SetInfo 
end if
 
