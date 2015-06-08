'------------------------------------------------------------------------------
' Remove Windows 10 Upgrade Offer Icon
'------------------------------------------------------------------------------
' Script stop the Windows 10 upgrade offer icon from appearing
'------------------------------------------------------------------------------
 
 Dim WshShell
Set WshShell = CreateObject("WScript.Shell")

myKey = "HKLM\SOFTWARE\Policies\Microsoft\Windows\Gwx\DisableGwx"


If NOT RegistryValueExists( myKey ) Then
		WScript.Echo "Applying Block Upgrade Offer Settings"
		WshShell.RegWrite myKey,1,"REG_DWORD"
ElseIf  wshShell.RegRead( myKey ) < 1 Then
		WScript.Echo "Reapplying Blocking Offer"
		WshShell.RegWrite myKey,1,"REG_DWORD"
Else
 WScript.Echo "Already Blocked!! - Good Work"
 End If

If wshShell.RegRead( myKey ) Then
WScript.Echo "Windows 10 Upgrade offer Blocked by Registry Key"
WScript.Echo "Key: HKLM\SOFTWARE\Policies\Microsoft\Windows\Gwx"
WScript.Echo "DisableGwx is set to 1 - Delete DisableGwx to show Offer Again!"
End If

Set WshShell = Nothing


Function RegistryValueExists (fncStrRegistryValue)
  'Ensure the last character is NOT a backslash (\) - if it is, we aren't looking for a value
  If (Right(fncStrRegistryValue, 1) = "\") Then
    'It's not a registry value we are looking for
    RegistryValueExists = false
  Else
    'If there isnt the value when we read it, it will return an error, so we need to resume
    On Error Resume Next

    'Try reading the value
    WshShell.RegRead fncStrRegistryValue

    'Catch the error
    Select Case Err
      Case 0:
        'Error Code 0 = 'success'
        RegistryValueExists = true
      Case Else
        'Any other error code is a failure code
        RegistryValueExists = false
    End Select

    'Turn error reporting back on
    On Error Goto 0
  End If
End Function 

 
