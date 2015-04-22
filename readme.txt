Get the top 10 of most CPU intensive running processes from a remote machine
---------------------------------------------------------------------------------------------------------------------------------------------------------------------
Directions:
The Batch file (GetCPUIntensivePs.bat) and the script file (GetCPUIntensivePs.ps1) should be placed in the same directory
---------------------------------------------------------------------------------------------------------------------------------------------------------------------
Prerequisites: Powershell 2.0 or later
---------------------------------------------------------------------------------------------------------------------------------------------------------------------
Configuration:
On both Computers perform the following actions:
1.	launch PowerShell as Administrator (Administrator account should have a password)
2.	Enable-PSRemoting –Force – This command enables PowerShell Remoting. Starts the WinRM service, sets it to start automatically with your system, and creates a 	firewall rule that allows incoming connections. The -Force part of the command tells PowerShell to perform these actions without prompting for each step.

If your computers aren’t on a domain 

3.	Set-Item wsman:\localhost\client\trustedhosts COMPUTERNAME – This configures the TrustedHosts setting so the computers will trust each other. 
4.	Restart-Service WinRM – This command restarts the WinRM service so the new settings will take effect
5.	Test-WsMan COMPUTER –Test the connection 
---------------------------------------------------------------------------------------------------------------------------------------------------------------------
Description:
The batch file is used to run the PowerShell script from. 
The script after getting hostname and credentials of the remote system, starts a session with the remote system through Enter-PSSession cmdlet  and runs commands on it through Invoke-Command cmdlet. The list of processes are selected, sent back and saved in a variable.
The script saves the result in three structured formats CSV, JSON, and XML in the path where the script is ran from.
The CPU consumption: The CPU property of the Get-Process cmdlet returns the number of seconds a particular process has used the CPU. However, a high number does not certainly indicate high CPU usage because CPU usage depends on how long a process has been running. The longer a process runs, the higher the CPU load is. To better estimate the CPU load, the average CPU load percentage is calculated that takes into account the total seconds a process is running together with the CPU load. More specifically, the percent value is calculated by dividing the total seconds a process is running by the accumulated CPU load and then multiplying by 100 to return the CPU load percentage per second.


