# define name of installer
OutFile "installer.exe"
 
# define installation directory
InstallDir "C:\Program Files\RGSA\Scans"

RequestExecutionLevel admin ;Require admin rights on NT6+ (When UAC is turned on)

!include LogicLib.nsh

Function .onInit
UserInfo::GetAccountType
pop $0
${If} $0 != "admin" ;Require admin rights on NT4+
    MessageBox mb_iconstop "Administrator rights required!"
    SetErrorLevel 740 ;ERROR_ELEVATION_REQUIRED
    Quit
${EndIf}
FunctionEnd

# start default section
Section
    SetOutPath $INSTDIR
    File "rgsascans.exe"
    File "desktop_window_plugin.dll"
    File "flutter_windows.dll"

    SetOutPath "$INSTDIR\data"
    File "data\*"

    SetOutPath "$INSTDIR\data\flutter_assets"
    File "data\flutter_assets\*"
    
    SetOutPath "$INSTDIR\data\flutter_assets\assets\img"
    file "data\flutter_assets\assets\img\*"

    SetOutPath "$INSTDIR\data\flutter_assets\fonts"
    file "data\flutter_assets\fonts\*"

    SetOutPath "$INSTDIR\data\flutter_assets\packages\cupertino_icons\assets"
    file "data\flutter_assets\packages\cupertino_icons\assets\*"

    # create the uninstaller
    WriteUninstaller "$INSTDIR\uninstall.exe"
 
    # create a shortcut named "new shortcut" in the start menu programs directory
    # point the new shortcut at the program uninstaller
    CreateDirectory "$SMPROGRAMS\RGSA"
    CreateShortcut "$SMPROGRAMS\RGSA\RGSA Scans.lnk" "$INSTDIR\rgsascans.exe"
    CreateShortcut "$SMPROGRAMS\RGSA\uninstall_scans.lnk" "$INSTDIR\uninstall.exe"
SectionEnd
 
# uninstaller section start
Section "uninstall"
 
    # first, delete the uninstaller
    Delete "$INSTDIR\uninstall.exe"
 
    # second, remove the link from the start menu
    Delete "$SMPROGRAMS\uninstall_scans.lnk"
 
    RMDir /r $INSTDIR
# uninstaller section end
SectionEnd