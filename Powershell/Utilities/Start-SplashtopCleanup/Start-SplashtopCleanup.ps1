cd "$env:windir\Temp"
Uninstall-Package -Name 'Splashtop Streamer' -Force
MsiExec.exe /qn /X{B7C5EA94-B96A-41F5-BE95-25D78B486678}
rm -r -force 'C:\Program Files (x86)\Splash*'
rm -r -force C:\ProgramData\splash*
pause
Write-Output "Splashtop Streamer has been uninstalled."