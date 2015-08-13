' Add run to Start Menu Windows XP/7
' Version 1.0
' By Paul Benn - Not Just Computers Limited
 
Dim objShell, RegLocate, RegLocate1
Set objShell = WScript.CreateObject("WScript.Shell")
On Error Resume Next
RegLocate = "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced "
objShell.RegWrite RegLocate,"1","REG_DWORD"
 
 
WScript.Quit ' Tells the script to stop and exit.
