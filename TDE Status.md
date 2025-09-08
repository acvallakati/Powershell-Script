#Connect-AzAccount
    $comp = Import-CSV -Path "C:\Users\vallaak\Downloads\SQLDB.csv"
    ForEach ($id in $comp)
    {
      #$subscription = Import-CSV -Path "C:\Users\vallaak\Downloads\SQLDB.csv"
      select-AzSubscription -SubscriptionName $id.Subs
      $result = (Get-AzSqlDatabaseTransparentDataEncryption -ServerName $id.ServerName -ResourceGroupName $id.ResourceGroupName -DatabaseName $id.DatabaseName)
      $result | Export-Csv -Path C:\SQLDB\SQLDBTDE-$(Get-Date -UFormat "%Y-%m-%d_%H-%m").csv -NoTypeInformation -Append -Force
    }
    $emailFrom     = "akshaykumar.vallakati@linkgroup.com"

    $emailTo       = #"mohammedanwar.shaikh@linkgroup.com"
    
    $emailCc       = "akshaykumar.vallakati@linkgroup.com"
    
    $smtpServer    = "smtp.linkgroup.corp"
    
    $emailSubject  = ("SQL Database TDE Status - " + (Get-Date -format yyyy/mm/dd))
    
     
    
    $mailMessageParameters = @{
    
    From       = $emailFrom
    
    To         = $emailTo
    
    Cc         = $emailCc
    
    Subject    = $emailSubject
    
    SmtpServer = $smtpServer
    
    Body       = ("Hi, Please find the attached TDE status of SQL Database") | Out-String
    
    Attachment = "C:\SQLDB\SQLDBTDE-$(Get-Date -UFormat "%Y-%m-%d_%H-%m").csv"
    
    }
    
     
    
    Send-MailMessage @mailMessageParameters -BodyAsHtml