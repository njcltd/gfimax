Const HKLM = &H80000002

wscript.echo "View Product Keys | Microsoft Products" & vbCrLf

'Install Date 
Computer = "."
Set objWMIService = GetObject("winmgmts:\\" & Computer & "\root\cimv2")
Set Obj = objWMIService.ExecQuery ("Select * from Win32_OperatingSystem")

dim InsDate

For Each item in Obj
  InsDate = item.InstallDate
  ' Gather Operating System Information
  Caption = Item.Caption
  OSArchitecture = Item.OSArchitecture
  CSDVersion = Item.CSDVersion
  Version = Item.Version
  Next

dim NewDate

NewDate = mid(InsDate,9,2) & ":" & mid(InsDate,11,2) & ":" & mid(InsDate,13,2)
NewDate = NewDate & " " & mid(InsDate,7,2) & "/" & mid(InsDate,5,2) & "/" & mid(InsDate,1,4)

QueryWindowsProductKeys() 

wscript.echo 'vbCrLf & "Office Keys" & vbCrLf

QueryOfficeProductKeys()

Function DecodeProductKey(arrKey, intKeyOffset)
  If Not IsArray(arrKey) Then Exit Function
    intIsWin8 = BitShiftRight(arrKey(intKeyOffset + 14),3) And 1    
    arrKey(intKeyOffset + 14) = arrKey(intKeyOffset + 14) And 247 Or BitShiftLeft(intIsWin8 And 2,2)
    i = 24
    strChars = "BCDFGHJKMPQRTVWXY2346789"
    strKeyOutput = ""
    While i > -1
        intCur = 0
        intX = 14
        While intX > -1
            intCur = BitShiftLeft(intCur,8)
            intCur = arrKey(intX + intKeyOffset) + intCur
            arrKey(intX + intKeyOffset) = Int(intCur / 24) 
            intCur = intCur Mod 24
            intX = intX - 1
        Wend
        i = i - 1
        strKeyOutput = Mid(strChars,intCur + 1,1) & strKeyOutput
        intLast = intCur
    Wend
    If intIsWin8 = 1 Then
        strKeyOutput = Mid(strKeyOutput,2,intLast) & "N" & Right(strKeyOutput,Len(strKeyOutput) - (intLast + 1))    
    End If
    strKeyGUIDOutput = Mid(strKeyOutput,1,5) & "-" & Mid(strKeyOutput,6,5) & "-" & Mid(strKeyOutput,11,5) & "-" & Mid(strKeyOutput,16,5) & "-" & Mid(strKeyOutput,21,5)
    DecodeProductKey = strKeyGUIDOutput
End Function

Function RegReadBinary(strRegPath,strRegValue)
    Set objReg = GetObject("winmgmts:{impersonationLevel=impersonate}!\\.\root\default:StdRegProv")
    objReg.GetBinaryValue HKLM,strRegPath,strRegValue,arrRegBinaryData
    RegReadBinary = arrRegBinaryData
    Set objReg = Nothing
End Function

Function BitShiftLeft(intValue,intShift)
    BitShiftLeft = intValue * 2 ^ intShift
End Function

Function BitShiftRight(intValue,intShift)
    BitShiftRight = Int(intValue / (2 ^ intShift))
End Function

Function QueryOfficeProductKeys()

        strBaseKey = "SOFTWARE\"

        strOfficeKey = strBaseKey & "Microsoft\Office"
        Set objReg = GetObject("winmgmts:{impersonationLevel=impersonate}!\\.\root\default:StdRegProv")
        objReg.EnumKey HKLM, strOfficeKey, arrOfficeVersionSubKeys
        intProductCount = 1
        If IsArray(arrOfficeVersionSubKeys) Then

            For Each strOfficeVersionKey In arrOfficeVersionSubKeys

                Select Case strOfficeVersionKey
                    Case "11.0"
                        CheckOfficeKey strOfficeKey & "\11.0\Registration",52,intProductCount
                    Case "12.0"
                        CheckOfficeKey strOfficeKey & "\12.0\Registration",52,intProductCount
                    Case "14.0"
                        CheckOfficeKey strOfficeKey & "\14.0\Registration",808,intProductCount
                    Case "15.0"
                        CheckOfficeKey strOfficeKey & "\15.0\Registration",808,intProductCount
                End Select
            Next
        End If

        strBaseKey = "SOFTWARE\Wow6432Node\"

        strOfficeKey = strBaseKey & "Microsoft\Office"
        Set objReg = GetObject("winmgmts:{impersonationLevel=impersonate}!\\.\root\default:StdRegProv")
        objReg.EnumKey HKLM, strOfficeKey, arrOfficeVersionSubKeys
        intProductCount = 1

        If IsArray(arrOfficeVersionSubKeys) Then

            For Each strOfficeVersionKey In arrOfficeVersionSubKeys

                Select Case strOfficeVersionKey
                    Case "11.0"
                        CheckOfficeKey strOfficeKey & "\11.0\Registration",52,intProductCount
                    Case "12.0"
                        CheckOfficeKey strOfficeKey & "\12.0\Registration",52,intProductCount
                    Case "14.0"
                        CheckOfficeKey strOfficeKey & "\14.0\Registration",808,intProductCount
                    Case "15.0"
                        CheckOfficeKey strOfficeKey & "\15.0\Registration",808,intProductCount
                End Select
            Next
        End If
End Function

'Office Product Key
Sub CheckOfficeKey(strRegPath,intKeyOffset,intProductCount)

    Set objReg = GetObject("winmgmts:{impersonationLevel=impersonate}!\\.\root\default:StdRegProv")
    objReg.EnumKey HKLM, strRegPath, arrOfficeRegistrations
    If IsArray(arrOfficeRegistrations) Then
        For Each strOfficeRegistration In arrOfficeRegistrations

            objReg.GetStringValue HKLM,strRegPath & "\" & strOfficeRegistration,"ConvertToEdition",strOfficeEdition
            objReg.GetBinaryValue HKLM,strRegPath & "\" & strOfficeRegistration,"DigitalProductID",arrProductID
            If strOfficeEdition <> "" And IsArray(arrProductID) Then
                WriteData "Product", strOfficeEdition
                WriteData "Key", DecodeProductKey(arrProductID,intKeyOffset) & vbCrLf
                intProductCount = intProductCount + 1
            End If
        Next
    End If
End Sub


'Windows Product Key
Sub QueryWindowsProductKeys()
    strWinKey = CheckWindowsKey("SOFTWARE\Microsoft\Windows NT\CurrentVersion","DigitalProductId",52)
    If strWinKey <> "" Then
        wscript.echo "Product: " & Caption & Version & " (" & OSArchitecture & ")"
        wscript.echo "Installation Date: " & NewDate 
        WriteData "Key", strWinKey
        Exit Sub
    End If
    strWinKey = CheckWindowsKey("SOFTWARE\Microsoft\Windows NT\CurrentVersion","DigitalProductId4",808)
    If strWinKey <> "" Then
        wscript.echo "Product: " & Caption & Version & " (" & OSArchitecture & ")"
        wscript.echo "Installation Date: " & NewDate
        WriteData "Key", strWinKey
        Exit Sub
    End If
    strWinKey = CheckWindowsKey("SOFTWARE\Microsoft\Windows NT\CurrentVersion\DefaultProductKey","DigitalProductId",52)
    If strWinKey <> "" Then
        wscript.echo "Product: " & Caption & Version & " (" & OSArchitecture & ")"
        wscript.echo "Installation Date: " & NewDate
        WriteData "Key", strWinKey
        Exit Sub
    End If
    strWinKey = CheckWindowsKey("SOFTWARE\Microsoft\Windows NT\CurrentVersion\DefaultProductKey","DigitalProductId4",808)
    If strWinKey <> "" Then
        wscript.echo "Product: " & Caption & Version & " (" & OSArchitecture & ")"
        wscript.echo "Installation Date: " & NewDate
        WriteData "Key", strWinKey
        Exit Sub
    End If
End Sub

Function CheckWindowsKey(strRegPath,strRegValue,intKeyOffset)
    strWinKey = DecodeProductKey(RegReadBinary(strRegPath,strRegValue),intKeyOffset)
    If strWinKey <> "BBBBB-BBBBB-BBBBB-BBBBB-BBBBB" And strWinKey <> "" Then
        CheckWindowsKey = strWinKey
    Else
        CheckWindowsKey = ""
    End If
End Function

Function RegReadBinary(strRegPath,strRegValue)
    Set objReg = GetObject("winmgmts:{impersonationLevel=impersonate}!\\.\root\default:StdRegProv")
    objReg.GetBinaryValue HKLM,strRegPath,strRegValue,arrRegBinaryData
    RegReadBinary = arrRegBinaryData
    Set objReg = Nothing
End Function

Function OsArch()
    Set objShell = WScript.CreateObject("WScript.Shell")
    If objShell.ExpandEnvironmentStrings("%ProgramFiles(x86)%") = "%ProgramFiles(x86)%" Then
        OsArch = "x86" 
    Else
        OsArch = "x64"
    End If
    Set objShell = Nothing
End Function

Sub WriteData(strProperty,strValue)

    WScript.Echo strProperty & ": " & Trim(strValue)

    'Set objShell = CreateObject("WScript.Shell")
    'strKey = "HKLM\SOFTWARE\CentraStage\Custom\" & strProperty
    'objShell.RegWrite strKey,Trim(strValue),"REG_SZ"
    'Set objShell = Nothing

End Sub
