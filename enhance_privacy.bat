@echo off
echo ======================================================
echo Enhancing Privacy and Security on Your PC
echo ======================================================
echo.

REM --- Disable Windows Telemetry and Tracking ---
echo Disabling telemetry and tracking services...
sc stop DiagTrack
sc delete DiagTrack
sc stop dmwappushservice
sc delete dmwappushservice

REM --- Disable Remote Assistance ---
echo Disabling Remote Assistance...
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Remote Assistance" /v fAllowToGetHelp /t REG_DWORD /d 0 /f

REM --- Disable Error Reporting ---
echo Disabling error reporting...
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\Windows Error Reporting" /v Disabled /t REG_DWORD /d 1 /f

REM --- Disable Cortana ---
echo Disabling Cortana...
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v AllowCortana /t REG_DWORD /d 0 /f

REM --- Block Microsoft Tracking Domains ---
echo Blocking tracking domains in the hosts file...
echo 0.0.0.0 vortex.data.microsoft.com >> %windir%\System32\drivers\etc\hosts
echo 0.0.0.0 settings-win.data.microsoft.com >> %windir%\System32\drivers\etc\hosts
echo 0.0.0.0 watson.telemetry.microsoft.com >> %windir%\System32\drivers\etc\hosts
echo 0.0.0.0 fe3.delivery.mp.microsoft.com >> %windir%\System32\drivers\etc\hosts

REM --- Clear Logs and Temporary Files ---
echo Clearing logs, metadata, and temporary files...
del /s /f /q %SystemRoot%\Temp\*.*
del /s /f /q %SystemRoot%\Prefetch\*.*
del /s /f /q %SystemRoot%\SoftwareDistribution\Download\*.*
del /s /f /q %USERPROFILE%\AppData\Local\Temp\*.*
del /s /f /q %USERPROFILE%\AppData\Roaming\Microsoft\Windows\Recent\*.*
del /s /f /q %USERPROFILE%\AppData\Roaming\Microsoft\Windows\Recent\AutomaticDestinations\*.*
del /s /f /q %USERPROFILE%\AppData\Roaming\Microsoft\Windows\Recent\CustomDestinations\*.*
cleanmgr /sagerun:1

REM --- Enable VPN to Hide Your IP Address ---
echo Connecting to VPN to hide your IP address...
REM Replace 'MyVPN' with your VPN connection name
rasdial "MyVPN"

REM --- Set Google DNS ---
echo Setting Google DNS for secure browsing...
netsh interface ip set dns name="Ethernet" source=static addr=8.8.8.8 register=primary
netsh interface ip add dns name="Ethernet" addr=8.8.4.4 index=2
netsh interface ip set dns name="Wi-Fi" source=static addr=8.8.8.8 register=primary
netsh interface ip add dns name="Wi-Fi" addr=8.8.4.4 index=2

REM --- Enable DNS over HTTPS ---
echo Enabling DNS over HTTPS for encrypted DNS requests...
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v EnableAutoDoh /t REG_DWORD /d 2 /f

REM --- Ask to Reboot ---
echo.
set /p RESTART="Would you like to restart now? (Y/N): "
if /I "%RESTART%"=="Y" (
    echo Rebooting system...
    shutdown /r /t 5
) else (
    echo Please remember to restart your system later to apply the changes.
)
