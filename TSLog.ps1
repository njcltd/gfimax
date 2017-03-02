Get-EventLog -LogName Security | ?{(4624,4778) -contains $_.EventID} | %{
    (new-object -Type PSObject -Property @{
        TimeGenerated = $_.TimeGenerated
        ClientIP = $_.Message -replace '(?smi).*Source Network Address:\s+([^\s]+)\s+.*','$1'
        UserName = $_.Message -replace '(?smi).*Account Name:\s+([^\s]+)\s+.*','$1'
        UserDomain = $_.Message -replace '(?smi).*Account Domain:\s+([^\s]+)\s+.*','$1'
        LogonType = $_.Message -replace '(?smi).*Logon Type:\s+([^\s]+)\s+.*','$1'
    })
} | sort TimeGenerated -Descending | Select TimeGenerated, ClientIP `
, @{N='Username';E={'{0}\{1}' -f $_.UserDomain,$_.UserName}} `
, @{N='LogType';E={
    switch ($_.LogonType) {
        2   {'Interactive (logon at keyboard and screen of system)'}
        3   {'Network (i.e. connection to shared folder)'}
        4   {'Batch (i.e. scheduled task)'}
        5   {'Service (i.e. service start)'}
        7   {'Unlock (i.e. post screensaver)'}
        8   {'NetworkCleartext (i.e. IIS)'}
        9   {'NewCredentials (i.e. local impersonation process under existing connection)'}
        10  {'RemoteInteractive (i.e. RDP)'}
        11  {'CachedInteractive (i.e. interactive, but without network connection to validate against AD)'}   
        default {"LogType Not Recognised: $($_.LogonType)"}     
    }
}} 
