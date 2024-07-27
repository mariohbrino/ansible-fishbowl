Set-ExecutionPolicy Unrestricted -Scope LocalMachine -Force -ErrorAction Ignore

# OpenSSH Setup
Add-WindowsCapability -Online -Name 'OpenSSH.Server~~~~0.0.1.0'
Set-Service -Name sshd -StartupType 'Automatic'
Set-Service -Name ssh-agent -StartupType 'Automatic'
Start-Service -Name sshd
Start-Service -Name ssh-agent

# Install Chocolatey
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# Fix OpenSSH to not be strict
$ssh_config_path = 'AuthorizedKeysFile __PROGRAMDATA__/ssh/administrators_authorized_keys'
$ssh_config_path_replace = '#AuthorizedKeysFile __PROGRAMDATA__/ssh/administrators_authorized_keys'

$sshd_config = Get-Content "C:\ProgramData\ssh\sshd_config"
$sshd_config = $sshd_config -replace '#PubkeyAuthentication yes', 'PubkeyAuthentication yes'
$sshd_config = $sshd_config -replace '#PasswordAuthentication yes', 'PasswordAuthentication no'
$sshd_config = $sshd_config -replace 'Match Group administrators', '#Match Group administrators'
$sshd_config = $sshd_config -replace $ssh_config_path, $ssh_config_path_replace
Set-Content "C:\ProgramData\ssh\sshd_config" $sshd_config

mkdir "c:\Users\administrator\.ssh"
type "a:\fishbowl.pub" | Out-File -Encoding UTF8 "c:\Users\administrator\.ssh\authorized_keys"

# Restart service
Restart-Service -Name sshd
Restart-Service -Name ssh-agent

# Make sure appropriate firewall port openings exist
$firewallExists = Get-NetFirewallPortFilter | Where-Object { $_.LocalPort -eq '22' }

if (-not $firewallExists) {
  New-NetFirewallRule -Name 'OpenSSH-Server-In-TCP' -DisplayName 'OpenSSH Server (TCP-In)' \ 
    -Enabled True -Direction Inbound -LocalPort 22 -Protocol TCP -Action Allow
}

# Enable Ping
Enable-NetFirewallRule -DisplayName "File and Printer Sharing (Echo Request - ICMPv4-In)"

# Configure RDS
Enable-NetFirewallRule -DisplayName "Remote Desktop - User Mode (TCP-In)"
Enable-NetFirewallRule -DisplayName "Remote Desktop - User Mode (UDP-In)"
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections /t REG_DWORD /d 0 /f
