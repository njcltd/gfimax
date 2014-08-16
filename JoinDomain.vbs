On Error Resume Next
' This script joins the current computer to a domain, using specified user and placing it in specified OU
' Created by Sole Viktor - sole@sole.dk

' Set theese variables
strDomain = "mydomain.local" ' Domain to logon
strPassword = "MyPassword" ' Service account logon password
strUser = "MyUserAccount" ' Service account
strOU = "OU=LetsPlaceItHere,OU=MySecondOU,OU=MyFirstOU,DC=mydomain,DC=local" ' OU to place computer in

' Constants to choose from when joining
Const JOIN_DOMAIN = 1
Const ACCT_CREATE = 2
Const ACCT_DELETE = 4
Const WIN9X_UPGRADE = 16
Const DOMAIN_JOIN_IF_JOINED = 32
Const JOIN_UNSECURE = 64
Const MACHINE_PASSWORD_PASSED = 128
Const DEFERRED_SPN_SET = 256
Const INSTALL_INVOCATION = 262144

Set objNetwork = CreateObject("WScript.Network")
strComputer = objNetwork.ComputerName

' Join Domain
Set objComputer = GetObject("winmgmts:{impersonationLevel=Impersonate}!\\" & _
strComputer & "\root\cimv2:Win32_ComputerSystem.Name='" & _
strComputer & "'")
ReturnValue = objComputer.JoinDomainOrWorkGroup(strDomain, _
strPassword, strDomain & "\" & strUser, strOU, _
JOIN_DOMAIN + ACCT_CREATE + DOMAIN_JOIN_IF_JOINED)

Select Case ReturnValue

Case 0 Status = "Success"

Case 2 Status = "Missing OU"

Case 5 Status = "Access denied"

Case 53 Status = "Network path not found"

Case 87 Status = "Parameter incorrect"

Case 1326 Status = "Logon failure, user or pass"

Case 1355 Status = "Domain can not be contacted"

Case 1909 Status = "User account locked out"

Case 2224 Status = "Computer Account allready exists"

Case 2691 Status = "Allready joined"

Case Else Status = "UNKNOWN ERROR " & ReturnValue

' Show Status
WScript.Echo "Join domain status: " & Status

End Select
