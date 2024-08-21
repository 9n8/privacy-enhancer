@echo off
echo ======================================================
echo Reverting to Normal PC Functionality
echo ======================================================
echo.

REM --- Re-enable Windows Telemetry and Tracking (Optional) ---
echo Re-enabling telemetry and tracking services...
sc config DiagTrack start=auto
sc config dmwappushservice start=auto
sc start DiagTrack
sc start dmwappushservice

REM --- Re-enable Remote Assistance ---
echo Re-enabling Remote Assistance...
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Remote Assistance" /v fAllowToGetHelp /t REG_DWORD /d 1 /f

REM --- Re-enable Error Reporting ---
echo Re-enabling error reporting...
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\Windows Error Reporting" /v Disabled /t REG_DWORD /d 0 /f

REM --- Re-enable Cortana ---
echo Re-enabling Cortana...
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v AllowCortana /f

REM --- Remove VPN Connection ---
echo Disconnecting from VPN...
REM Replace 'MyVPN' with your VPN connection name
rasdial "MyVPN" /disconnect

REM --- Reset DNS to Default ---
echo Resetting DNS to default settings...
netsh interface ip set dns name="Ethernet" source=dhcp
netsh interface ip set dns name="Wi-Fi" source=dhcp

REM --- Disable DNS over HTTPS ---
echo Disabling DNS over HTTPS...
reg delete "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v EnableAutoDoh /f

REM --- Ask to Reboot ---
echo.
set /p RESTART="Would you like to restart now? (Y/N): "
if /I "%RESTART%"=="Y" (
    echo Rebooting system...
    shutdown /r /t 5
) else (
    echo Please remember to restart your system later to apply the changes.
)
