Set WshShell = CreateObject("WScript.Shell")
myKey = "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Gwx"
WshShell.RegWrite DisableGwx,1,"REG_DWORD"
Set WshShell = Nothing

