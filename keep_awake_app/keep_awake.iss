[Setup]
AppName=KeepAwake
AppVersion=1.0
DefaultDirName={autopf}\KeepAwake
DefaultGroupName=KeepAwake
OutputBaseFilename=KeepAwakeInstaller
Compression=lzma
SolidCompression=yes

[Files]
Source: "dist\keep_awake_tray.exe"; DestDir: "{app}"; Flags: ignoreversion

[Icons]
Name: "{group}\KeepAwake"; Filename: "{app}\keep_awake_tray.exe"
Name: "{group}\Uninstall KeepAwake"; Filename: "{uninstallexe}"

[Run]
Filename: "{app}\keep_awake_tray.exe"; Description: "Launch KeepAwake"; Flags: nowait postinstall skipifsilent
