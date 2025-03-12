cd "$env:windir\Temp"
Uninstall-Package -Name 'Splashtop Streamer' -Force
MsiExec.exe /qn /X{B7C5EA94-B96A-41F5-BE95-25D78B486678}
Remove-Item -Recurse -Force 'C:\Program Files (x86)\Splash*' -ErrorAction SilentlyContinue
Remove-Item -Recurse -Force 'C:\ProgramData\splash*' -ErrorAction SilentlyContinue
pause
Write-Output "Splashtop Streamer has been uninstalled."