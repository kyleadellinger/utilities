#
# more or less copied from microsoft docs
# and without any type of proper error checking or input validation or really any validation whatsoever.

Install-WindowsFeature -name AD-Domain-Services -IncludeManagementTools
# no reboot is required quote

# get available cmdlets in the module:
# Get-Command -Module ADDSDeployment

# note to self:
# manually prompt for a password:
# -SafeModeAdministratorPassword (Read-Host -Prompt "DSRM Password:" -AsSecureString)

# Test Cmdlets of note
# Test-ADDSForestInstallation                      # runs prereqs for installing new AD Forest
# Test-ADDSDomainInstallation                      # runs prereqs for installing new domain in AD
# Test-ADDSDomainControllerInstallation            # runs prereqs for installing Domain Controller in AD
# Test-ADDSReadOnlyDomainControllerAccountCreation # runs prereqs for adding a Read-Only Domain Controller (RODC) account

# Install new forest root domain
# Install-ADDSForest -DomainName "corp.contoso.com"
# Install-ADDSForest -DomainName corp.contoso.com -CreateDNSDelegation -DomainMode Win2008 -ForestMode Win2025 -DatabasePath "d:\NTDS" -SYSVOLPath "d:\SYSVOL" -Log "e:\Logs"

# Install a new child or tree domain
# Install-ADDSDomain -SafeModeAdministratorPassword -Credential (Get-Credential corp\EnterpriseAdmin1) -NewDomainName child -ParentDomainName corp.contoso.com -InstallDNS -CreateDNSDelegation -DomainMode Win2025 -ReplicationSourceDC DC1.corp.contoso.com -SiteName Houston -DatabasePath "d:\NTDS" -SYSVOLPath "d:\SYSVOL" -LogPath "e:\Logs" -Confirm:$false

# Install additional (replica) domain controller
# Install-ADDSDomainController -Credential (Get-Credential CORP\Administrator) -DomainName "corp.contoso.com"
# if computer is already domain-joined and you're a member of domain admins:
# Install-ADDSDomainController -DomainName "corp.contoso.com"
# to be prompted for domain name:
# Install-ADDSDomainController -Credential (Get-Credential) -DomainName (Read-Host "Domain to promote into:")

# Staged RODC installation
# Add-ADDSReadOnlyDomainControllerAccount -DomainControllerAccountName RODC1 -DomainName corp.contoso.com -SiteName Boston -DelegatedAdministratorAccountName AdminUser
# Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools
# Install-ADDSDomainController -DomainName corp.contoso.com -SafeModeAdministratorPassword (Read-Host -Prompt "DSRM Password:" -AsSecureString) -Credential (Get-Credential Corp\AdminUser) -UseExistingAccount
