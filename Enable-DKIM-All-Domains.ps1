#Revision: 0.1

Write-Host "Getting list of all custom domains" -ForegroundColor Yellow
$EXOdomains = (Get-AcceptedDomain | ? { $_.name -NotLike '*.onmicrosoft.com'}).name 
    
$EXOdomains | foreach {

$dkimconfig = Get-DkimSigningConfig -Identity $_ -ErrorAction SilentlyContinue

if (!($dkimconfig)) {
  Write-Host "Adding domain: $_ to DKIM Signing Configuration..." : $_ -ForegroundColor Yellow
    New-DkimSigningConfig -DomainName $_ -Enabled $false
    }          
}

#Get DKIM info from the teant
Write-Host "Collecting Selector1 and Selector2 CNAME records from all domains" -ForegroundColor Yellow
Get-DkimSigningConfig | select domain, Selector1CNAME, Selector2CNAME | fl | Out-File .\O365-DKIM-SigningKeys.txt

#Open the log in Notepad, after running the tasks
notepad .\O365-DKIM-SigningKeys.txt

