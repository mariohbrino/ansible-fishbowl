# Show hidden files in File Explorer
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v Hidden /t REG_DWORD /d 1 /f

# Show file extensions in File Explorer
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v HideFileExt /t REG_DWORD /d 0 /f

# Disable File Checkbox in File Explorer
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v AutoCheckSelect /t REG_DWORD /d 0 /f

# Expand Ribbon in File Explorer
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Ribbon" /v MinimizedStateTabletModeOff /t REG_DWORD /d 0 /f
