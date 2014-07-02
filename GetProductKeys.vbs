' GetProductKeys.VBS v1.0 by Foolish IT

Const HKEY_LOCAL_MACHINE = &H80000002

WinKey = GetWinKey

OfficeKeys = GetOfficeKey("10.0") & GetOfficeKey("11.0") & GetOfficeKey("12.0") & GetOfficeKey("14.0") & GetOfficeKey("15.0")

If Msgbox(WinKey & vbnewline & vbnewline & OfficeKeys & vbnewline & "Save All Keys to ProductKeys.txt?", vbyesno, "GetProductKeys.VBS by Foolish IT") = vbyes then
    Set objFSO = CreateObject("Scripting.FileSystemObject")
    Set objTextFile = objFSO.CreateTextFile("ProductKeys.txt", True)
    objTextFile.Write WinKey & vbnewline & vbnewline & OfficeKeys
    objTextFile.Close
end if

Function GetOfficeKey(sVer)
    On Error Resume Next
    Dim arrSubKeys
    Set wshShell = WScript.CreateObject( "WScript.Shell" )
    sBit = wshShell.ExpandEnvironmentStrings("%ProgramFiles(x86)%")
    if sBit <> "%ProgramFiles(x86)%" then
   sBit = "Software\wow6432node"
    else
   sBit = "Software"
    end if
    Set objReg=GetObject("winmgmts:{impersonationLevel=impersonate}!\\.\root\default:StdRegProv")
    objReg.EnumKey HKEY_LOCAL_MACHINE, sBit & "\Microsoft\Office\" & sVer & "\Registration", arrSubKeys
    Set objReg = Nothing
    if IsNull(arrSubKeys) = False then
        For Each Subkey in arrSubKeys
       if lenb(other) < 1 then other = wshshell.RegRead("HKLM\" & sBit & "\Microsoft\Office\" & sVer & "\Registration\" & SubKey & "\ProductName")
       if ucase(right(SubKey, 7)) = "0FF1CE}" then
                Set wshshell = CreateObject("WScript.Shell")
           key = ConvertToKey(wshshell.RegRead("HKLM\" & sBit & "\Microsoft\Office\" & sVer & "\Registration\" & SubKey & "\DigitalProductID"))
      oem = ucase(mid(wshshell.RegRead("HKLM\" & sBit & "\Microsoft\Office\" & sVer & "\Registration\" & SubKey & "\ProductID"), 7, 3))
        edition = wshshell.RegRead("HKLM\" & sBit & "\Microsoft\Office\" & sVer & "\Registration\" & SubKey & "\ProductName")
      if err.number <> 0 then 
          edition = other
                   err.clear
      end if
           Set wshshell = Nothing
            if oem <> "OEM" then oem = "Retail"
           if lenb(final) > 1 then
          final = final & vbnewline & final
             else
               final = edition & " " & oem & ":  " & key 
                end if
       end if
        Next
   GetOfficeKey = final & vbnewline
    End If
End Function

Function GetWinKey()
    Set wshshell = CreateObject("WScript.Shell")
    edition = wshshell.RegRead("HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProductName")
    oem = ucase(mid(wshshell.RegRead("HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProductID"), 7, 3))
    key = GetKey("HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\DigitalProductId")
    set wshshell = Nothing
    if oem <> "OEM" then oem = "Retail"
    GetWinKey = edition & " " & oem & ":  " & key
End Function

Function GetKey(sReg)
    Set wshshell = CreateObject("WScript.Shell")
    GetKey = ConvertToKey(wshshell.RegRead(sReg))
    Set wshshell = Nothing
End Function

Function ConvertToKey(key)
    Const KeyOffset = 52
    i = 28
    Chars = "BCDFGHJKMPQRTVWXY2346789"
    Do
        Cur = 0
        x = 14
        Do
            Cur = Cur * 256
            Cur = key(x + KeyOffset) + Cur
            key(x + KeyOffset) = (Cur \ 24) And 255
            Cur = Cur Mod 24
            x = x - 1
        Loop While x >= 0
        i = i - 1
        KeyOutput = Mid(Chars, Cur + 1, 1) & KeyOutput
        If (((29 - i) Mod 6) = 0) And (i <> -1) Then
            i = i - 1
            KeyOutput = "-" & KeyOutput
        End If
    Loop While i >= 0
    ConvertToKey = KeyOutput
End Function
