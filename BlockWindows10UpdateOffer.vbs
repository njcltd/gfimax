
Dim WshShell
Set WshShell = CreateObject("WScript.Shell")

myKey = "HKLM\SOFTWARE\Policies\Microsoft\Windows\Gwx\DisableGwx"

WshShell.RegWrite myKey,1,"REG_DWORD"

Set WshShell = Nothing

