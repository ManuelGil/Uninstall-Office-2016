:: ==================================================================================
:: NAME     : Uninstall Office 2016.
:: AUTHOR     : Manuel Gil.
:: VERSION     : 2.2.
:: ==================================================================================


:: Screen settings.
:: void mode();
:: /************************************************************************************/
:mode
	echo off
	title Uninstall Office 2016.
	color 47

	goto permission
goto :eof
:: /************************************************************************************/


:: Print Top Text.
::		@param - text = the text to print (%*).
:: void print(string text);
:: /*************************************************************************************/
:print
	cls
	echo.
	echo.Uninstall Office 2016 Tool.
	echo.
	echo.%*
	echo.
goto :eof
:: /************************************************************************************/


:: Checking for Administrator elevation.
:: void permission();
:: /************************************************************************************/
:permission
	openfiles>nul 2>&1

	if %errorlevel% EQU 0 goto terms

	call :print Checking for Administrator elevation.

	echo.    You are not running as Administrator.
	echo.    This tool cannot do it's job without elevation.
	echo.
	echo.    You need run this tool as Administrator.
	echo.

	echo.Press any key to continue . . .
	pause>nul
goto :eof
:: /************************************************************************************/


:: Terms.
:: void terms();
:: /*************************************************************************************/
:terms
	call :print Terms and Conditions.

	echo.    The methods inside this batch modify files and registry settings.
	echo.    While they are tested and tend to work, I take no responsibility for
	echo.    the use of this file.
	echo.    This batch is provided without warranty. Any damage caused is your
	echo.    own responsibility.
	echo.
	echo.    As well, batch files are almost always flagged by anti-virus, feel free
	echo.    to review the code if you're unsure.
	echo.

	choice /c YN /n /m "Do you want to continue with this process? (Yes/No) "
	if %errorlevel% EQU 1 goto Menu
	if %errorlevel% EQU 2 goto Close

	echo.
	echo.An unexpected error has occurred.
	echo.
	echo.Press any key to continue . . .
	pause>nul
goto :eof
:: /*************************************************************************************/


:: Menu of tool.
:: void menu();
:: /*************************************************************************************/
:Menu
	call :print Main menu.

	echo.     1. Make backup of Registry.
	echo.     2. Uninstall Office 2016.
	echo.     3. Delete waste of Office.
	echo.     4. Close.
	echo.

	set /p option=Select option: 

	if %option% EQU 1 (
		call :Registry
	) else if %option% EQU 2 (
		call :Office16
	) else if %option% EQU 3 (
		call :All
	) else if %option% EQU 4 (
		goto Close
	) else (
		echo.
		echo.Invalid option.
		echo.
		echo.Press any key to continue . . .
		pause>nul
	)

	goto Menu
goto :eof
:: /*************************************************************************************/


:: Making backup of Registry.
:: void registry()
:: /*************************************************************************************/
:Registry
	for /f "tokens=1-5 delims=/., " %%a in ("%date%") do (
		set now=%%a%%b%%c%%d%time:~0,2%%time:~3,2%
	)

	if not exist "%USERPROFILE%\Desktop\Backup\Regedit\%now%\" (
		mkdir "%USERPROFILE%\Desktop\Backup\Regedit\%now%\"
	)

	:: Create a backup of the Registry.
	:: ------------------------------------------------------------------------
	call :print Making a backup of the Registry in: %USERPROFILE%\Desktop\Backup\Regedit\%now%\

	if exist "%USERPROFILE%\Desktop\Backup\Regedit\%now%\HKLM.reg" (
		echo.An unexpected error has occurred.
		echo.
		echo.    Changes were not carried out in the registry.
		echo.    Will try it later.
		echo.
		echo.Press any key to continue . . .
		pause>nul
		goto :eof
	) else (
		reg Export HKCR "%USERPROFILE%\Desktop\Backup\Regedit\%now%\HKCR.reg"
		reg Export HKCU "%USERPROFILE%\Desktop\Backup\Regedit\%now%\HKCU.reg"
		reg Export HKLM "%USERPROFILE%\Desktop\Backup\Regedit\%now%\HKLM.reg"
		reg Export HKU "%USERPROFILE%\Desktop\Backup\Regedit\%now%\HKU.reg"
		reg Export HKCC "%USERPROFILE%\Desktop\Backup\Regedit\%now%\HKCC.reg"
	)

	:: Checking backup.
	:: ------------------------------------------------------------------------
	call :print Checking the backup.

	if not exist "%USERPROFILE%\Desktop\Backup\Regedit\%now%\HKLM.reg" (
		echo.An unexpected error has occurred.
		echo.
		echo.    Something went wrong.
		echo.    You manually create a backup of the registry before continuing.
		echo.
		echo.Press any key to continue . . .
		pause>nul
		goto :eof
	) else (
		echo.The operation completed successfully.
		echo.
		echo.Press any key to continue . . .
		pause>nul
		goto :eof
	)
goto :eof
:: /*************************************************************************************/


:: Uninstall Office 2016.
:: void Office16()
:: /*************************************************************************************/
:Office16
	:: Closing apps.
	:: --------------------------------------------------
	call :print Microsoft Office, Internet Explorer y Windows Explorer go to close.

	echo.    Please, save changes to all open Word documents before continue.
	echo.
	echo.Press any key to continue . . .
	pause>nul

	:: Closing Office apps.
	:: --------------------------------------------------
	call :print Closing the Office apps . . .

	taskkill /f /im winword.exe /t
	taskkill /f /im excel.exe /t
	taskkill /f /im powerpnt.exe /t
	taskkill /f /im onenote.exe /t
	taskkill /f /im outlook.exe /t
	taskkill /f /im mspub.exe /t
	taskkill /f /im msaccess.exe /t
	taskkill /f /im infopath.exe /t
	taskkill /f /im groove.exe /t
	taskkill /f /im lync.exe /t

	:: Closing Click-to-Run task.
	:: --------------------------------------------------
	call :print Closing the Office apps . . .

	taskkill /f /im officeclicktorun.exe /t
	taskkill /f /im officeondemand.exe /t
	taskkill /f /im officec2rclient.exe /t
	taskkill /f /im appvshnotify.exe /t
	taskkill /f /im firstrun.exe /t
	taskkill /f /im setup.exe /t

	:: Closing others apps.
	:: --------------------------------------------------
	call :print Closing the Office apps . . .

	taskkill /f /im integratedoffice.exe /t
	taskkill /f /im integrator.exe /t
	taskkill /f /im communicator.exe /t
	taskkill /f /im msosync.exe /t
	taskkill /f /im onenotem.exe /t
	taskkill /f /im iexplore.exe /t
	taskkill /f /im mavinject32.exe /t
	taskkill /f /im werfault.exe /t
	taskkill /f /im perfboost.exe /t
	taskkill /f /im roamingoffice.exe /t
	taskkill /f /im msiexec.exe /t
	taskkill /f /im ose.exe /t

	:: Stopping Office Source Engine.
	:: --------------------------------------------------
	call :print Stopping Office Source Engine service . . .

	net stop ose
	 
	call :print Stopping Office Source Engine service . . .

	sc query ose | findstr /I /C:"STOPPED"
	If %errorlevel% EQU 0 (
		sc config ose start= disabled obj= LocalSystem
	)

	:: Removing Office files.
	:: --------------------------------------------------
	call :print Removing Office files . . .
	 
	if exist "%PROGRAMFILES%\Microsoft Office 15" (
		takeown /f "%PROGRAMFILES%\Microsoft Office 15"
		attrib -r -s -h /s /d "%PROGRAMFILES%\Microsoft Office 15"
		rmdir /s /q "%PROGRAMFILES%\Microsoft Office 15"
	) else if exist "%PROGRAMFILES(x86)%\Microsoft Office 15" (
		takeown /f "%PROGRAMFILES(x86)%\Microsoft Office 15"
		attrib -r -s -h /s /d "%PROGRAMFILES(x86)%\Microsoft Office 15"
		rmdir /s /q "%PROGRAMFILES(x86)%\Microsoft Office 15"
	)

	if exist "%PROGRAMFILES%\Microsoft Office\root\Integration" (
		cd /d "%PROGRAMFILES%\Microsoft Office\root\Integration"
		takeown /f C2RManifest*.xml
		attrib -r -s -h /s /d C2RManifest*.xml
		del /s /q /f C2RManifest*.xml
	) else if exist "%PROGRAMFILES(x86)%\Microsoft Office\root\Integration" (
		cd /d "%PROGRAMFILES(x86)%\Microsoft Office\root\Integration"
		takeown /f C2RManifest*.xml
		attrib -r -s -h /s /d C2RManifest*.xml
		del /s /q /f C2RManifest*.xml
	)
	 
	if exist "%PROGRAMFILES%\Microsoft Office\PackageManifest" (
		takeown /f "%PROGRAMFILES%\Microsoft Office\PackageManifest"
		attrib -r -s -h /s /d "%PROGRAMFILES%\Microsoft Office\PackageManifest"
		rmdir /s /q "%PROGRAMFILES%\Microsoft Office\PackageManifest"
	) else if exist "%PROGRAMFILES(x86)%\Microsoft Office\PackageManifest" (
		takeown /f "%PROGRAMFILES(x86)%\Microsoft Office\PackageManifest"
		attrib -r -s -h /s /d "%PROGRAMFILES(x86)%\Microsoft Office\PackageManifest"
		rmdir /s /q "%PROGRAMFILES(x86)%\Microsoft Office\PackageManifest"
	)

	if exist "%PROGRAMFILES%\Microsoft Office\PackageSunrisePolicies" (
		takeown /f "%PROGRAMFILES%\Microsoft Office\PackageSunrisePolicies"
		attrib -r -s -h /s /d "%PROGRAMFILES%\Microsoft Office\PackageSunrisePolicies"
		rmdir /s /q "%PROGRAMFILES%\Microsoft Office\PackageSunrisePolicies"
	) else if exist "%PROGRAMFILES(x86)%\Microsoft Office\PackageSunrisePolicies" (
		takeown /f "%PROGRAMFILES(x86)%\Microsoft Office\PackageSunrisePolicies"
		attrib -r -s -h /s /d "%PROGRAMFILES(x86)%\Microsoft Office\PackageSunrisePolicies"
		rmdir /s /q "%PROGRAMFILES(x86)%\Microsoft Office\PackageSunrisePolicies"
	)

	if exist "%PROGRAMFILES%\Microsoft Office\root" (
		takeown /f "%PROGRAMFILES%\Microsoft Office\root"
		attrib -r -s -h /s /d "%PROGRAMFILES%\Microsoft Office\root"
		rmdir /s /q "%PROGRAMFILES%\Microsoft Office\root"
	) else if exist "%PROGRAMFILES(x86)%\Microsoft Office\root" (
		takeown /f "%PROGRAMFILES(x86)%\Microsoft Office\root"
		attrib -r -s -h /s /d "%PROGRAMFILES(x86)%\Microsoft Office\root"
		rmdir /s /q "%PROGRAMFILES(x86)%\Microsoft Office\root"
	)

	if exist "%PROGRAMFILES%\Microsoft Office\AppXManifest.xml" (
		takeown /f "%PROGRAMFILES%\Microsoft Office\AppXManifest.xml"
		attrib -r -s -h /s /d "%PROGRAMFILES%\Microsoft Office\AppXManifest.xml"
		del /s /q /f "%PROGRAMFILES%\Microsoft Office\AppXManifest.xml"
	) else if exist "%PROGRAMFILES(x86)%\Microsoft Office\AppXManifest.xml" (
		takeown /f "%PROGRAMFILES(x86)%\Microsoft Office\AppXManifest.xml"
		attrib -r -s -h /s /d "%PROGRAMFILES(x86)%\Microsoft Office\AppXManifest.xml"
		del /s /q /f "%PROGRAMFILES(x86)%\Microsoft Office\AppXManifest.xml"
	)

	if exist "%PROGRAMFILES%\Microsoft Office\FileSystemMetadata.xml" (
		takeown /f "%PROGRAMFILES%\Microsoft Office\FileSystemMetadata.xml"
		attrib -r -s -h /s /d "%PROGRAMFILES%\Microsoft Office\FileSystemMetadata.xml"
		del /s /q /f "%PROGRAMFILES%\Microsoft Office\FileSystemMetadata.xml"
	) else if exist "%PROGRAMFILES(x86)%\Microsoft Office\FileSystemMetadata.xml" (
		takeown /f "%PROGRAMFILES(x86)%\Microsoft Office\FileSystemMetadata.xml"
		attrib -r -s -h /s /d "%PROGRAMFILES(x86)%\Microsoft Office\FileSystemMetadata.xml"
		del /s /q /f "%PROGRAMFILES(x86)%\Microsoft Office\FileSystemMetadata.xml"
	)

	if exist "%PROGRAMDATA%\Microsoft\ClicToRun" (
		takeown /f "%PROGRAMDATA%\Microsoft\ClicToRun"
		attrib -r -s -h /s /d "%PROGRAMDATA%\Microsoft\ClicToRun"
		rmdir /s /q "%PROGRAMDATA%\Microsoft\ClicToRun"
	)

	if exist "%COMMONPROGRAMFILES%\Microsoft Shared\ClickToRun" (
		takeown /f "%COMMONPROGRAMFILES%\Microsoft Shared\ClickToRun"
		attrib -r -s -h /s /d "%COMMONPROGRAMFILES%\Microsoft Shared\ClickToRun"
		rmdir /s /q "%COMMONPROGRAMFILES%\Microsoft Shared\ClickToRun"
	) else if exist "%COMMONPROGRAMFILES(x86)%\Microsoft Shared\ClickToRun" (
		takeown /f "%COMMONPROGRAMFILES(x86)%\Microsoft Shared\ClickToRun"
		attrib -r -s -h /s /d "%COMMONPROGRAMFILES(x86)%\Microsoft Shared\ClickToRun"
		rmdir /s /q "%COMMONPROGRAMFILES(x86)%\Microsoft Shared\ClickToRun"
	)

	if exist "%PROGRAMDATA%\Microsoft\office\FFPackageLocker" (
		takeown /f "%PROGRAMDATA%\Microsoft\office\FFPackageLocker"
		attrib -r -s -h /s /d "%PROGRAMDATA%\Microsoft\office\FFPackageLocker"
		rmdir /s /q "%PROGRAMDATA%\Microsoft\office\FFPackageLocker"
	)

	if exist "%PROGRAMDATA%\Microsoft\office\ClickToRunPackageLocker" (
		takeown /f "%PROGRAMDATA%\Microsoft\office\ClickToRunPackageLocker"
		attrib -r -s -h /s /d "%PROGRAMDATA%\Microsoft\office\ClickToRunPackageLocker"
		rmdir /s /q "%PROGRAMDATA%\Microsoft\office\ClickToRunPackageLocker"
	)

	if exist "%PROGRAMDATA%\Microsoft\office\FFStatePBLocker" (
		takeown /f "%PROGRAMDATA%\Microsoft\office\FFStatePBLocker"
		attrib -r -s -h /s /d "%PROGRAMDATA%\Microsoft\office\FFStatePBLocker"
		rmdir /s /q "%PROGRAMDATA%\Microsoft\office\FFStatePBLocker"
	)

	if exist "%PROGRAMDATA%\Microsoft\office\Heartbeat" (
		takeown /f "%PROGRAMDATA%\Microsoft\office\Heartbeat"
		attrib -r -s -h /s /d "%PROGRAMDATA%\Microsoft\office\Heartbeat"
		rmdir /s /q "%PROGRAMDATA%\Microsoft\office\Heartbeat"
	)

	if exist "%USERPROFILE%\Microsoft Office" (
		takeown /f "%USERPROFILE%\Microsoft Office"
		attrib -r -s -h /s /d "%USERPROFILE%\Microsoft Office"
		rmdir /s /q "%USERPROFILE%\Microsoft Office"
	)

	if exist "%USERPROFILE%\Microsoft Office 15" (
		takeown /f "%USERPROFILE%\Microsoft Office 15"
		attrib -r -s -h /s /d "%USERPROFILE%\Microsoft Office 15"
		rmdir /s /q "%USERPROFILE%\Microsoft Office 15"
	)

	if exist "%USERPROFILE%\Microsoft Office 16" (
		takeown /f "%USERPROFILE%\Microsoft Office 16"
		attrib -r -s -h /s /d "%USERPROFILE%\Microsoft Office 16"
		rmdir /s /q "%USERPROFILE%\Microsoft Office 16"
	)

	:: Removing scheduled tasks.
	:: --------------------------------------------------
	call :print Removing tasks . . .

	schtasks.exe /delete /tn "FF_INTEGRATEDstreamSchedule" /f
	schtasks.exe /delete /tn "FF_INTEGRATEDUPDATEDETECTION" /f
	schtasks.exe /delete /tn "C2RAppVLoggingStart" /f
	schtasks.exe /delete /tn "Office 15 Subscription Heartbeat" /f
	schtasks.exe /delete /tn "\Microsoft\Office\Office 15 Subscription Heartbeat" /f
	schtasks.exe /delete /tn "Microsoft Office 15 Sync Maintenance for {d068b555-9700-40b8-992c-f866287b06c1}" /f
	schtasks.exe /delete /tn "\Microsoft\Office\OfficeInventoryAgentFallBack" /f
	schtasks.exe /delete /tn "\Microsoft\Office\OfficeTelemetryAgentFallBack" /f
	schtasks.exe /delete /tn "\Microsoft\Office\OfficeInventoryAgentLogOn" /f
	schtasks.exe /delete /tn "\Microsoft\Office\OfficeTelemetryAgentLogOn" /f
	schtasks.exe /delete /tn "Office Background Streaming" /f
	schtasks.exe /delete /tn "\Microsoft\Office\Office Automatic Updates" /f
	schtasks.exe /delete /tn "\Microsoft\Office\Office ClickToRun Service Monitor" /f
	schtasks.exe /delete /tn "Office Subscription Maintenance" /f
	schtasks.exe /delete /tn "\Microsoft\Office\Office Subscription Maintenance" /f

	:: Removing Click-to-Run service.
	:: --------------------------------------------------
	call :print Removing Click-to-Run service . . .

	sc delete Clicktorunsvc

	:: Removing keys in the Registry.
	:: --------------------------------------------------
	call :print Removing keys in the Registry . . .

	reg delete "HKCU\Software\Microsoft\Office\15.0\Registration" /f
	reg delete "HKCU\Software\Microsoft\Office\16.0\Registration" /f
	reg delete "HKCU\Software\Microsoft\Office\Registration" /f

	reg delete "HKLM\SOFTWARE\Microsoft\AppVISV" /f

	reg delete "HKLM\SOFTWARE\Microsoft\Office\15.0\Common\InstallRoot\Virtual" /f
	reg delete "HKLM\SOFTWARE\Microsoft\Office\16.0\Common\InstallRoot\Virtual" /f
	reg delete "HKLM\SOFTWARE\Microsoft\Office\Common\InstallRoot\Virtual" /f

	reg delete "HKLM\SOFTWARE\Classes\CLSID\{2027FC3B-CF9D-4ec7-A823-38BA308625CC}" /f
	reg delete "HKLM\SOFTWARE\Classes\Wow6432Node\CLSID\{A0D4CD32-5D5D-4f72-BAAA-767A7AD6BAC5}" /f
	reg delete "HKCR\Wow6432Node\CLSID\{A0D4CD32-5D5D-4f72-BAAA-767A7AD6BAC5}" /f

	reg delete "HKCU\SOFTWARE\Microsoft\Office\15.0\ClickToRun" /f
	reg delete "HKLM\SOFTWARE\Microsoft\Office\15.0\ClickToRun" /f
	reg delete "HKLM\SOFTWARE\Microsoft\Office\15.0\ClickToRunStore" /f
	reg delete "HKLM\SOFTWARE\Microsoft\Office\16.0\ClickToRun" /f
	reg delete "HKLM\SOFTWARE\Microsoft\Office\16.0\ClickToRun" /f
	reg delete "HKLM\SOFTWARE\Microsoft\Office\16.0\ClickToRunStore" /f
	reg delete "HKCU\SOFTWARE\Microsoft\Office\ClickToRun" /f
	reg delete "HKLM\SOFTWARE\Microsoft\Office\ClickToRun" /f
	reg delete "HKLM\SOFTWARE\Microsoft\Office\ClickToRunStore" /f

	reg delete "HKLM\Software\Microsoft\Office\15.0" /f
	reg delete "HKLM\Software\Microsoft\Office\15.0" /f
	reg delete "HKLM\Software\Microsoft\Office\16.0" /f
	reg delete "HKLM\Software\Microsoft\Office\16.0" /f
	reg delete "HKLM\SOFTWARE\Microsoft\Office" /f

	reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run\Lync15" /f
	reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run\Lync16" /f

	reg delete "HKLM\SOFTWARE\Classes\Protocols\Handler\osf" /f

	reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\ShellIconOverlayIdentifiers\Microsoft SPFS Icon Overlay 1 (ErrorConflict)" /f
	reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\ShellIconOverlayIdentifiers\Microsoft SPFS Icon Overlay 2 (SyncInProgress)" /f
	reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\ShellIconOverlayIdentifiers\Microsoft SPFS Icon Overlay 3 (InSync)" /f
	reg delete "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\ShellIconOverlayIdentifiers\Microsoft SPFS Icon Overlay 1 (ErrorConflict)" /f
	reg delete "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\ShellIconOverlayIdentifiers\Microsoft SPFS Icon Overlay 2 (SyncInProgress)" /f
	reg delete "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\ShellIconOverlayIdentifiers\Microsoft SPFS Icon Overlay 3 (InSync)" /f

	reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Approved\{B28AA736-876B-46DA-B3A8-84C5E30BA492}" /f
	reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Approved\{8B02D659-EBBB-43D7-9BBA-52CF22C5B025}" /f
	reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Approved\{0875DCB6-C686-4243-9432-ADCCF0B9F2D7}" /f
	reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Approved\{42042206-2D85-11D3-8CFF-005004838597}" /f
	reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Approved\{993BE281-6695-4BA5-8A2A-7AACBFAAB69E}" /f
	reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Approved\{C41662BB-1FA0-4CE0-8DC5-9B7F8279FF97}" /f
	reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Approved\{506F4668-F13E-4AA1-BB04-B43203AB3CC0}" /f
	reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Approved\{D66DC78C-4F61-447F-942B-3FB6980118CF}" /f
	reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Approved\{46137B78-0EC3-426D-8B89-FF7C3A458B5E}" /f

	reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objects\{31D09BA0-12F5-4CCE-BE8A-2923E76605DA}" /f
	reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objects\{B4F3A835-0E21-4959-BA22-42B3008E02FF}" /f
	reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objects\{D0498E0A-45B7-42AE-A9AA-ABA463DBD3BF}" /f
	reg delete "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objects\{31D09BA0-12F5-4CCE-BE8A-2923E76605DA}" /f
	reg delete "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objects\{B4F3A835-0E21-4959-BA22-42B3008E02FF}" /f
	reg delete "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objects\{D0498E0A-45B7-42AE-A9AA-ABA463DBD3BF}" /f

	reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace\{0875DCB6-C686-4243-9432-ADCCF0B9F2D7}" /f

	reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Desktop\Namespace\{B28AA736-876B-46DA-B3A8-84C5E30BA492}" /f
	reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\NetworkNeighborhood\Namespace\{46137B78-0EC3-426D-8B89-FF7C3A458B5E}" /f

	reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Microsoft Office Temp Files" /f

	set key=HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall
	set value=0FF1CE

	for /f %%a in ('"reg query "%key%" | find "%value%""') do (
		reg delete "%%a" /f
	)

	set key=HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall
	set value=O365

	for /f %%a in ('"reg query "%key%" | find "%value%""') do (
		reg delete "%%a - ar-sa" /f
		reg delete "%%a - bg-bg" /f
		reg delete "%%a - ca-es" /f
		reg delete "%%a - cs-cz" /f
		reg delete "%%a - da-dk" /f
		reg delete "%%a - de-de" /f
		reg delete "%%a - el-gr" /f
		reg delete "%%a - en-us" /f
		reg delete "%%a - es-es" /f
		reg delete "%%a - et-ee" /f
		reg delete "%%a - eu-es" /f
		reg delete "%%a - fi-fi" /f
		reg delete "%%a - fr-fr" /f
		reg delete "%%a - gl-es" /f
		reg delete "%%a - he-il" /f
		reg delete "%%a - hi-in" /f
		reg delete "%%a - hr-hr" /f
		reg delete "%%a - hu-hu" /f
		reg delete "%%a - id-id" /f
		reg delete "%%a - it-it" /f
		reg delete "%%a - ja-jp" /f
		reg delete "%%a - kk-kz" /f
		reg delete "%%a - ko-kr" /f
		reg delete "%%a - lt-lt" /f
		reg delete "%%a - lv-lv" /f
		reg delete "%%a - ms-my" /f
		reg delete "%%a - nb-no" /f
		reg delete "%%a - nl-nl" /f
		reg delete "%%a - pl-pl" /f
		reg delete "%%a - pt-br" /f
		reg delete "%%a - pt-pt" /f
		reg delete "%%a - ro-ro" /f
		reg delete "%%a - ru-ru" /f
		reg delete "%%a - sk-sk" /f
		reg delete "%%a - sl-si" /f
		reg delete "%%a - sr-cyrl-cs" /f
		reg delete "%%a - sr-cyrl-rs" /f
		reg delete "%%a - sr-latn-cs" /f
		reg delete "%%a - sr-latn-rs" /f
		reg delete "%%a - sv-se" /f
		reg delete "%%a - th-th" /f
		reg delete "%%a - tr-tr" /f
		reg delete "%%a - uk-ua" /f
		reg delete "%%a - vi-vn" /f
		reg delete "%%a - zh-cn" /f
		reg delete "%%a - zh-tw" /f
	)

	set key=HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall
	set value=ProfessionaRetail

	for /f %%a in ('"reg query "%key%" | find "%value%""') do (
		reg delete "%%a - ar-sa" /f
		reg delete "%%a - bg-bg" /f
		reg delete "%%a - ca-es" /f
		reg delete "%%a - cs-cz" /f
		reg delete "%%a - da-dk" /f
		reg delete "%%a - de-de" /f
		reg delete "%%a - el-gr" /f
		reg delete "%%a - en-us" /f
		reg delete "%%a - es-es" /f
		reg delete "%%a - et-ee" /f
		reg delete "%%a - eu-es" /f
		reg delete "%%a - fi-fi" /f
		reg delete "%%a - fr-fr" /f
		reg delete "%%a - gl-es" /f
		reg delete "%%a - he-il" /f
		reg delete "%%a - hi-in" /f
		reg delete "%%a - hr-hr" /f
		reg delete "%%a - hu-hu" /f
		reg delete "%%a - id-id" /f
		reg delete "%%a - it-it" /f
		reg delete "%%a - ja-jp" /f
		reg delete "%%a - kk-kz" /f
		reg delete "%%a - ko-kr" /f
		reg delete "%%a - lt-lt" /f
		reg delete "%%a - lv-lv" /f
		reg delete "%%a - ms-my" /f
		reg delete "%%a - nb-no" /f
		reg delete "%%a - nl-nl" /f
		reg delete "%%a - pl-pl" /f
		reg delete "%%a - pt-br" /f
		reg delete "%%a - pt-pt" /f
		reg delete "%%a - ro-ro" /f
		reg delete "%%a - ru-ru" /f
		reg delete "%%a - sk-sk" /f
		reg delete "%%a - sl-si" /f
		reg delete "%%a - sr-cyrl-cs" /f
		reg delete "%%a - sr-cyrl-rs" /f
		reg delete "%%a - sr-latn-cs" /f
		reg delete "%%a - sr-latn-rs" /f
		reg delete "%%a - sv-se" /f
		reg delete "%%a - th-th" /f
		reg delete "%%a - tr-tr" /f
		reg delete "%%a - uk-ua" /f
		reg delete "%%a - vi-vn" /f
		reg delete "%%a - zh-cn" /f
		reg delete "%%a - zh-tw" /f
	)

	set key=HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall
	set value=0FF1CE

	for /f %%a in ('"reg query "%key%" | find "%value%""') do (
		reg delete "%%a" /f
	)

	set key=HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall
	set value=O365

	for /f %%a in ('"reg query "%key%" | find "%value%""') do (
		reg delete "%%a - ar-sa" /f
		reg delete "%%a - bg-bg" /f
		reg delete "%%a - ca-es" /f
		reg delete "%%a - cs-cz" /f
		reg delete "%%a - da-dk" /f
		reg delete "%%a - de-de" /f
		reg delete "%%a - el-gr" /f
		reg delete "%%a - en-us" /f
		reg delete "%%a - es-es" /f
		reg delete "%%a - et-ee" /f
		reg delete "%%a - eu-es" /f
		reg delete "%%a - fi-fi" /f
		reg delete "%%a - fr-fr" /f
		reg delete "%%a - gl-es" /f
		reg delete "%%a - he-il" /f
		reg delete "%%a - hi-in" /f
		reg delete "%%a - hr-hr" /f
		reg delete "%%a - hu-hu" /f
		reg delete "%%a - id-id" /f
		reg delete "%%a - it-it" /f
		reg delete "%%a - ja-jp" /f
		reg delete "%%a - kk-kz" /f
		reg delete "%%a - ko-kr" /f
		reg delete "%%a - lt-lt" /f
		reg delete "%%a - lv-lv" /f
		reg delete "%%a - ms-my" /f
		reg delete "%%a - nb-no" /f
		reg delete "%%a - nl-nl" /f
		reg delete "%%a - pl-pl" /f
		reg delete "%%a - pt-br" /f
		reg delete "%%a - pt-pt" /f
		reg delete "%%a - ro-ro" /f
		reg delete "%%a - ru-ru" /f
		reg delete "%%a - sk-sk" /f
		reg delete "%%a - sl-si" /f
		reg delete "%%a - sr-cyrl-cs" /f
		reg delete "%%a - sr-cyrl-rs" /f
		reg delete "%%a - sr-latn-cs" /f
		reg delete "%%a - sr-latn-rs" /f
		reg delete "%%a - sv-se" /f
		reg delete "%%a - th-th" /f
		reg delete "%%a - tr-tr" /f
		reg delete "%%a - uk-ua" /f
		reg delete "%%a - vi-vn" /f
		reg delete "%%a - zh-cn" /f
		reg delete "%%a - zh-tw" /f
	)

	set key=HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall
	set value=ProfessionalRetail

	for /f %%a in ('"reg query "%key%" | find "%value%""') do (
		reg delete "%%a - ar-sa" /f
		reg delete "%%a - bg-bg" /f
		reg delete "%%a - ca-es" /f
		reg delete "%%a - cs-cz" /f
		reg delete "%%a - da-dk" /f
		reg delete "%%a - de-de" /f
		reg delete "%%a - el-gr" /f
		reg delete "%%a - en-us" /f
		reg delete "%%a - es-es" /f
		reg delete "%%a - et-ee" /f
		reg delete "%%a - eu-es" /f
		reg delete "%%a - fi-fi" /f
		reg delete "%%a - fr-fr" /f
		reg delete "%%a - gl-es" /f
		reg delete "%%a - he-il" /f
		reg delete "%%a - hi-in" /f
		reg delete "%%a - hr-hr" /f
		reg delete "%%a - hu-hu" /f
		reg delete "%%a - id-id" /f
		reg delete "%%a - it-it" /f
		reg delete "%%a - ja-jp" /f
		reg delete "%%a - kk-kz" /f
		reg delete "%%a - ko-kr" /f
		reg delete "%%a - lt-lt" /f
		reg delete "%%a - lv-lv" /f
		reg delete "%%a - ms-my" /f
		reg delete "%%a - nb-no" /f
		reg delete "%%a - nl-nl" /f
		reg delete "%%a - pl-pl" /f
		reg delete "%%a - pt-br" /f
		reg delete "%%a - pt-pt" /f
		reg delete "%%a - ro-ro" /f
		reg delete "%%a - ru-ru" /f
		reg delete "%%a - sk-sk" /f
		reg delete "%%a - sl-si" /f
		reg delete "%%a - sr-cyrl-cs" /f
		reg delete "%%a - sr-cyrl-rs" /f
		reg delete "%%a - sr-latn-cs" /f
		reg delete "%%a - sr-latn-rs" /f
		reg delete "%%a - sv-se" /f
		reg delete "%%a - th-th" /f
		reg delete "%%a - tr-tr" /f
		reg delete "%%a - uk-ua" /f
		reg delete "%%a - vi-vn" /f
		reg delete "%%a - zh-cn" /f
		reg delete "%%a - zh-tw" /f
	)

	:: Removing shortcuts.
	:: --------------------------------------------------
	call :print Removing shortcuts . . .
	 
	if exist "%PROGRAMFILES%\Microsoft\Windows\Start Menu\Programs\Microsoft Office 2016" (
		takeown /f "%PROGRAMFILES%\Microsoft\Windows\Start Menu\Programs\Microsoft Office 2016"
		attrib -r -s -h /s /d "%PROGRAMFILES%\Microsoft\Windows\Start Menu\Programs\Microsoft Office 2016"
		rmdir /s /q "%PROGRAMFILES%\Microsoft\Windows\Start Menu\Programs\Microsoft Office 2016"
	)

	if exist "%PROGRAMFILES%\Microsoft\Windows\Start Menu\Programs\Herramientas de Microsoft Office 2016" (
		takeown /f "%PROGRAMFILES%\Microsoft\Windows\Start Menu\Programs\Herramientas de Microsoft Office 2016"
		attrib -r -s -h /s /d "%PROGRAMFILES%\Microsoft\Windows\Start Menu\Programs\Herramientas de Microsoft Office 2016"
		rmdir /s /q "%PROGRAMFILES%\Microsoft\Windows\Start Menu\Programs\Herramientas de Microsoft Office 2016"
	)

	if exist "%PROGRAMFILES%\Microsoft\Windows\Start Menu\Programs\Microsoft Office 2016 Tools" (
		takeown /f "%PROGRAMFILES%\Microsoft\Windows\Start Menu\Programs\Microsoft Office 2016 Tools"
		attrib -r -s -h /s /d "%PROGRAMFILES%\Microsoft\Windows\Start Menu\Programs\Microsoft Office 2016 Tools"
		rmdir /s /q "%PROGRAMFILES%\Microsoft\Windows\Start Menu\Programs\Microsoft Office 2016 Tools"
	)

	cd /d "%PROGRAMFILES%\Microsoft\Windows\Start Menu\Programs"
	takeown /f *2016.lnk
	attrib -r -s -h /s /d *2016.lnk
	del /s /f /q *2016.lnk
	 
	if exist "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Microsoft Office 2016" (
		takeown /f "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Microsoft Office 2016"
		attrib -r -s -h /s /d "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Microsoft Office 2016"
		rmdir /s /q "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Microsoft Office 2016"
	)

	if exist "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Herramientas de Microsoft Office 2016" (
		takeown /f "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Herramientas de Microsoft Office 2016"
		attrib -r -s -h /s /d "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Herramientas de Microsoft Office 2016"
		rmdir /s /q "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Herramientas de Microsoft Office 2016"
	)

	if exist "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Microsoft Office 2016 Tools" (
		takeown /f "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Microsoft Office 2016 Tools"
		attrib -r -s -h /s /d "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Microsoft Office 2016 Tools"
		rmdir /s /q "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Microsoft Office 2016 Tools"
	)

	cd /d "%APPDATA%\Microsoft\Windows\Start Menu\Programs"
	takeown /f *2016.lnk
	attrib -r -s -h /s /d *2016.lnk
	del /s /f /q *2016.lnk
	 
	if exist "%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\Microsoft Office 2016" (
		takeown /f "%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\Microsoft Office 2016"
		attrib -r -s -h /s /d "%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\Microsoft Office 2016"
		rmdir /s /q "%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\Microsoft Office 2016"
	)

	if exist "%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\Herramientas de Microsoft Office 2016" (
		takeown /f "%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\Herramientas de Microsoft Office 2016"
		attrib -r -s -h /s /d "%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\Herramientas de Microsoft Office 2016"
		rmdir /s /q "%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\Herramientas de Microsoft Office 2016"
	)

	if exist "%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\Microsoft Office 2016 Tools" (
		takeown /f "%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\Microsoft Office 2016 Tools"
		attrib -r -s -h /s /d "%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\Microsoft Office 2016 Tools"
		rmdir /s /q "%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\Microsoft Office 2016 Tools"
	)

	cd /d "%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs"
	takeown /f *2016.lnk
	attrib -r -s -h /s /d *2016.lnk
	del /s /f /q *2016.lnk
	 
	if exist "%USERPROFILE%\Microsoft\Windows\Start Menu\Programs\Microsoft Office 2016" (
		takeown /f "%USERPROFILE%\Microsoft\Windows\Start Menu\Programs\Microsoft Office 2016"
		attrib -r -s -h /s /d "%USERPROFILE%\Microsoft\Windows\Start Menu\Programs\Microsoft Office 2016"
		rmdir /s /q "%USERPROFILE%\Microsoft\Windows\Start Menu\Programs\Microsoft Office 2016"
	)

	if exist "%USERPROFILE%\Microsoft\Windows\Start Menu\Programs\Herramientas de Microsoft Office 2016" (
		takeown /f "%USERPROFILE%\Microsoft\Windows\Start Menu\Programs\Herramientas de Microsoft Office 2016"
		attrib -r -s -h /s /d "%USERPROFILE%\Microsoft\Windows\Start Menu\Programs\Herramientas de Microsoft Office 2016"
		rmdir /s /q "%USERPROFILE%\Microsoft\Windows\Start Menu\Programs\Herramientas de Microsoft Office 2016"
	)

	if exist "%USERPROFILE%\Microsoft\Windows\Start Menu\Programs\Microsoft Office 2016 Tools" (
		takeown /f "%USERPROFILE%\Microsoft\Windows\Start Menu\Programs\Microsoft Office 2016 Tools"
		attrib -r -s -h /s /d "%USERPROFILE%\Microsoft\Windows\Start Menu\Programs\Microsoft Office 2016 Tools"
		rmdir /s /q "%USERPROFILE%\Microsoft\Windows\Start Menu\Programs\Microsoft Office 2016 Tools"
	)

	cd /d "%USERPROFILE%\Microsoft\Windows\Start Menu\Programs"
	takeown /f *2016.lnk
	attrib -r -s -h /s /d *2016.lnk
	del /s /f /q *2016.lnk

	:: End process.
	:: --------------------------------------------------
	call :print The operation completed successfully.

	echo.Press any key to continue . . .
	pause>nul
goto :eof
:: /*************************************************************************************/


:: Delete waste of Office.
:: void All()
:: /*************************************************************************************/
:All
	:: Closing apps.
	:: --------------------------------------------------
	call :print Microsoft Office, Internet Explorer y Windows Explorer go to close.

	echo.    Please, save changes to all open Word documents before continue.
	echo.
	echo.Press any key to continue . . .
	pause>nul

	:: Closing Office apps.
	:: --------------------------------------------------
	call :print Closing the Office apps . . .

	taskkill /f /im winword.exe /t
	taskkill /f /im excel.exe /t
	taskkill /f /im powerpnt.exe /t
	taskkill /f /im onenote.exe /t
	taskkill /f /im outlook.exe /t
	taskkill /f /im mspub.exe /t
	taskkill /f /im msaccess.exe /t
	taskkill /f /im infopath.exe /t
	taskkill /f /im groove.exe /t
	taskkill /f /im lync.exe /t

	:: Closing Click-to-Run task.
	:: --------------------------------------------------
	call :print Closing the Office apps . . .

	taskkill /f /im officeclicktorun.exe /t
	taskkill /f /im officeondemand.exe /t
	taskkill /f /im officec2rclient.exe /t
	taskkill /f /im appvshnotify.exe /t
	taskkill /f /im firstrun.exe /t
	taskkill /f /im setup.exe /t

	:: Closing others apps.
	:: --------------------------------------------------
	call :print Closing the Office apps . . .

	taskkill /f /im integratedoffice.exe /t
	taskkill /f /im integrator.exe /t
	taskkill /f /im communicator.exe /t
	taskkill /f /im msosync.exe /t
	taskkill /f /im onenotem.exe /t
	taskkill /f /im iexplore.exe /t
	taskkill /f /im mavinject32.exe /t
	taskkill /f /im werfault.exe /t
	taskkill /f /im perfboost.exe /t
	taskkill /f /im roamingoffice.exe /t
	taskkill /f /im msiexec.exe /t
	taskkill /f /im ose.exe /t

	:: Stopping Office Source Engine.
	:: --------------------------------------------------
	call :print Stopping Office Source Engine service . . .

	net stop ose

	call :print Stopping Office Source Engine service . . .

	sc query ose | findstr /I /C:"STOPPED"
	If %errorlevel% EQU 0 (
		sc config ose start= disabled obj= LocalSystem
	)

	:: Removing Office files.
	:: --------------------------------------------------
	call :print Removing Office files . . .
	 
	if exist "%PROGRAMFILES%\Microsoft Office 15" (
		rmdir /s /q "%PROGRAMFILES%\Microsoft Office 15"
	) else if exist "%PROGRAMFILES(x86)%\Microsoft Office 15" (
		rmdir /s /q "%PROGRAMFILES(x86)%\Microsoft Office 15"
	)

	if exist "%PROGRAMFILES%\Microsoft Office\root\Integration" (
		cd /d "%PROGRAMFILES%\Microsoft Office\root\Integration"
		del /s /q /f C2RManifest*.xml
	) else if exist "%PROGRAMFILES(x86)%\Microsoft Office\root\Integration" (
		cd /d "%PROGRAMFILES(x86)%\Microsoft Office\root\Integration"
		del /s /q /f C2RManifest*.xml
	)
	 
	if exist "%PROGRAMFILES%\Microsoft Office\PackageManifest" (
		rmdir /s /q "%PROGRAMFILES%\Microsoft Office\PackageManifest"
	) else if exist "%PROGRAMFILES(x86)%\Microsoft Office\PackageManifest" (
		rmdir /s /q "%PROGRAMFILES(x86)%\Microsoft Office\PackageManifest"
	)

	if exist "%PROGRAMFILES%\Microsoft Office\PackageSunrisePolicies" (
		rmdir /s /q "%PROGRAMFILES%\Microsoft Office\PackageSunrisePolicies"
	) else if exist "%PROGRAMFILES(x86)%\Microsoft Office\PackageSunrisePolicies" (
		rmdir /s /q "%PROGRAMFILES(x86)%\Microsoft Office\PackageSunrisePolicies"
	)

	if exist "%PROGRAMFILES%\Microsoft Office\root" (
		rmdir /s /q "%PROGRAMFILES%\Microsoft Office\root"
	) else if exist "%PROGRAMFILES(x86)%\Microsoft Office\root" (
		rmdir /s /q "%PROGRAMFILES(x86)%\Microsoft Office\root"
	)

	if exist "%PROGRAMFILES%\Microsoft Office\AppXManifest.xml" (
		del /s /q /f "%PROGRAMFILES%\Microsoft Office\AppXManifest.xml"
	) else if exist "%PROGRAMFILES(x86)%\Microsoft Office\AppXManifest.xml" (
		del /s /q /f "%PROGRAMFILES(x86)%\Microsoft Office\AppXManifest.xml"
	)

	if exist "%PROGRAMFILES%\Microsoft Office\FileSystemMetadata.xml" (
		del /s /q /f "%PROGRAMFILES%\Microsoft Office\FileSystemMetadata.xml"
	) else if exist "%PROGRAMFILES(x86)%\Microsoft Office\FileSystemMetadata.xml" (
	   del /s /q /f "%PROGRAMFILES(x86)%\Microsoft Office\FileSystemMetadata.xml"
	)

	if exist "%PROGRAMDATA%\Microsoft\ClicToRun" (
		rmdir /s /q "%PROGRAMDATA%\Microsoft\ClicToRun"
	)

	if exist "%COMMONPROGRAMFILES%\Microsoft Shared\ClickToRun" (
		rmdir /s /q "%COMMONPROGRAMFILES%\Microsoft Shared\ClickToRun"
	) else if exist "%COMMONPROGRAMFILES(x86)%\Microsoft Shared\ClickToRun" (
		rmdir /s /q "%COMMONPROGRAMFILES(x86)%\Microsoft Shared\ClickToRun"
	)

	if exist "%PROGRAMDATA%\Microsoft\office\FFPackageLocker" (
		rmdir /s /q "%PROGRAMDATA%\Microsoft\office\FFPackageLocker"
	)

	if exist "%PROGRAMDATA%\Microsoft\office\ClickToRunPackageLocker" (
		rmdir /s /q "%PROGRAMDATA%\Microsoft\office\ClickToRunPackageLocker"
	)

	if exist "%PROGRAMDATA%\Microsoft\office\FFStatePBLocker" (
		rmdir /s /q "%PROGRAMDATA%\Microsoft\office\FFStatePBLocker"
	)

	if exist "%PROGRAMDATA%\Microsoft\office\Heartbeat" (
		rmdir /s /q "%PROGRAMDATA%\Microsoft\office\Heartbeat"
	)

	if exist "%USERPROFILE%\Microsoft Office" (
		rmdir /s /q "%USERPROFILE%\Microsoft Office"
	)

	if exist "%USERPROFILE%\Microsoft Office 15" (
		rmdir /s /q "%USERPROFILE%\Microsoft Office 15"
	)

	if exist "%USERPROFILE%\Microsoft Office 16" (
		rmdir /s /q "%USERPROFILE%\Microsoft Office 16"
	)

	if exist "%PROGRAMFILES%\Microsoft Office" (
		rmdir /s /q "%PROGRAMFILES%\Microsoft Office"
	) else if exist "%PROGRAMFILES(x86)%\Microsoft Office" (
		rmdir /s /q "%PROGRAMFILES(x86)%\Microsoft Office"
	)

	if exist "%COMMONPROGRAMFILES%\Microsoft Shared\Office11" (
		rmdir /s /q "%COMMONPROGRAMFILES%\Microsoft Shared\Office11"
	) else if exist "%COMMONPROGRAMFILES(x86)%\Microsoft Shared\Office11" (
		rmdir /s /q "%COMMONPROGRAMFILES(x86)%\Microsoft Shared\Office11"
	)

	if exist "%COMMONPROGRAMFILES%\Microsoft Shared\Office12" (
		rmdir /s /q "%COMMONPROGRAMFILES%\Microsoft Shared\Office12"
	) else if exist "%COMMONPROGRAMFILES(x86)%\Microsoft Shared\Office12" (
		rmdir /s /q "%COMMONPROGRAMFILES(x86)%\Microsoft Shared\Office12"
	)

	if exist "%COMMONPROGRAMFILES%\Microsoft Shared\Office14" (
		rmdir /s /q "%COMMONPROGRAMFILES%\Microsoft Shared\Office14"
	) else if exist "%COMMONPROGRAMFILES(x86)%\Microsoft Shared\Office14" (
		rmdir /s /q "%COMMONPROGRAMFILES(x86)%\Microsoft Shared\Office14"
	)

	if exist "%COMMONPROGRAMFILES%\Microsoft Shared\Office15" (
		rmdir /s /q "%COMMONPROGRAMFILES%\Microsoft Shared\Office15"
	) else if exist "%COMMONPROGRAMFILES(x86)%\Microsoft Shared\Office15" (
		rmdir /s /q "%COMMONPROGRAMFILES(x86)%\Microsoft Shared\Office15"
	)

	if exist "%COMMONPROGRAMFILES%\Microsoft Shared\Source Engine" (
		rmdir /s /q "%COMMONPROGRAMFILES%\Microsoft Shared\Source Engine"
	) else if exist "%COMMONPROGRAMFILES(x86)%\Microsoft Shared\Source Engine" (
		rmdir /s /q "%COMMONPROGRAMFILES(x86)%\Microsoft Shared\Source Engine"
	)

	if exist "%APPDATA%\microsoft\templates\Normal.dotm" (
		del /s /q /f "%APPDATA%\microsoft\templates\Normal.dotm"
	)

	if exist "%APPDATA%\microsoft\templates\Word.dotx" (
		del /s /q /f "%APPDATA%\microsoft\templates\Word.dotx"
	)

	if exist "%APPDATA%\microsoft\document building blocks\3082\15\Building Blocks.dotx" (
		del /s /q /f "%APPDATA%\microsoft\document building blocks\3082\15\Building Blocks.dotx"
	)

	if exist "%ALLUSERSPROFILE%\Microsoft\Office" (
		rmdir /s /q "%ALLUSERSPROFILE%\Microsoft\Office"
	)

	if exist "%USERPROFILE%\Microsoft\Office" (
		rmdir /s /q "%USERPROFILE%\Microsoft\Office"
	)

	:: Removing temporary files in Windows.
	:: --------------------------------------------------
	call :print Removing temporary files in Windows . . .

	cd /d %TEMP%
	del /s /f /q *.*

	:: Removing keys in the Registry.
	:: --------------------------------------------------
	call :print Removing keys in the Registry . . .

	reg delete "HKCU\Software\Microsoft\Office\15.0\Registration" /f
	reg delete "HKCU\Software\Microsoft\Office\16.0\Registration" /f
	reg delete "HKCU\Software\Microsoft\Office\Registration" /f

	reg delete "HKLM\SOFTWARE\Microsoft\AppVISV" /f

	reg delete "HKLM\SOFTWARE\Microsoft\Office\15.0\Common\InstallRoot\Virtual" /f
	reg delete "HKLM\SOFTWARE\Microsoft\Office\16.0\Common\InstallRoot\Virtual" /f
	reg delete "HKLM\SOFTWARE\Microsoft\Office\Common\InstallRoot\Virtual" /f

	reg delete "HKLM\SOFTWARE\Classes\CLSID\{2027FC3B-CF9D-4ec7-A823-38BA308625CC}" /f
	reg delete "HKLM\SOFTWARE\Classes\Wow6432Node\CLSID\{A0D4CD32-5D5D-4f72-BAAA-767A7AD6BAC5}" /f
	reg delete "HKCR\Wow6432Node\CLSID\{A0D4CD32-5D5D-4f72-BAAA-767A7AD6BAC5}" /f

	reg delete "HKCU\SOFTWARE\Microsoft\Office\15.0\ClickToRun" /f
	reg delete "HKLM\SOFTWARE\Microsoft\Office\15.0\ClickToRun" /f
	reg delete "HKLM\SOFTWARE\Microsoft\Office\15.0\ClickToRunStore" /f
	reg delete "HKLM\SOFTWARE\Microsoft\Office\16.0\ClickToRun" /f
	reg delete "HKLM\SOFTWARE\Microsoft\Office\16.0\ClickToRun" /f
	reg delete "HKLM\SOFTWARE\Microsoft\Office\16.0\ClickToRunStore" /f
	reg delete "HKCU\SOFTWARE\Microsoft\Office\ClickToRun" /f
	reg delete "HKLM\SOFTWARE\Microsoft\Office\ClickToRun" /f
	reg delete "HKLM\SOFTWARE\Microsoft\Office\ClickToRunStore" /f

	reg delete "HKLM\Software\Microsoft\Office\15.0" /f
	reg delete "HKLM\Software\Microsoft\Office\15.0" /f
	reg delete "HKLM\Software\Microsoft\Office\16.0" /f
	reg delete "HKLM\Software\Microsoft\Office\16.0" /f
	reg delete "HKLM\SOFTWARE\Microsoft\Office" /f

	reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run\Lync15" /f
	reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run\Lync16" /f

	reg delete "HKLM\SOFTWARE\Classes\Protocols\Handler\osf" /f

	reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\ShellIconOverlayIdentifiers\Microsoft SPFS Icon Overlay 1 (ErrorConflict)" /f
	reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\ShellIconOverlayIdentifiers\Microsoft SPFS Icon Overlay 2 (SyncInProgress)" /f
	reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\ShellIconOverlayIdentifiers\Microsoft SPFS Icon Overlay 3 (InSync)" /f
	reg delete "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\ShellIconOverlayIdentifiers\Microsoft SPFS Icon Overlay 1 (ErrorConflict)" /f
	reg delete "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\ShellIconOverlayIdentifiers\Microsoft SPFS Icon Overlay 2 (SyncInProgress)" /f
	reg delete "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\ShellIconOverlayIdentifiers\Microsoft SPFS Icon Overlay 3 (InSync)" /f

	reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Approved\{B28AA736-876B-46DA-B3A8-84C5E30BA492}" /f
	reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Approved\{8B02D659-EBBB-43D7-9BBA-52CF22C5B025}" /f
	reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Approved\{0875DCB6-C686-4243-9432-ADCCF0B9F2D7}" /f
	reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Approved\{42042206-2D85-11D3-8CFF-005004838597}" /f
	reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Approved\{993BE281-6695-4BA5-8A2A-7AACBFAAB69E}" /f
	reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Approved\{C41662BB-1FA0-4CE0-8DC5-9B7F8279FF97}" /f
	reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Approved\{506F4668-F13E-4AA1-BB04-B43203AB3CC0}" /f
	reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Approved\{D66DC78C-4F61-447F-942B-3FB6980118CF}" /f
	reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Approved\{46137B78-0EC3-426D-8B89-FF7C3A458B5E}" /f

	reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objects\{31D09BA0-12F5-4CCE-BE8A-2923E76605DA}" /f
	reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objects\{B4F3A835-0E21-4959-BA22-42B3008E02FF}" /f
	reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objects\{D0498E0A-45B7-42AE-A9AA-ABA463DBD3BF}" /f
	reg delete "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objects\{31D09BA0-12F5-4CCE-BE8A-2923E76605DA}" /f
	reg delete "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objects\{B4F3A835-0E21-4959-BA22-42B3008E02FF}" /f
	reg delete "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objects\{D0498E0A-45B7-42AE-A9AA-ABA463DBD3BF}" /f

	reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace\{0875DCB6-C686-4243-9432-ADCCF0B9F2D7}" /f

	reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Desktop\Namespace\{B28AA736-876B-46DA-B3A8-84C5E30BA492}" /f
	reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\NetworkNeighborhood\Namespace\{46137B78-0EC3-426D-8B89-FF7C3A458B5E}" /f

	reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Microsoft Office Temp Files" /f

	reg delete "HKCU\Software\Microsoft\Office" /f
	reg delete "HKLM\SOFTWARE\Microsoft\Office" /f
	reg delete "HKLM\SYSTEM\CurrentControlSet\Services\ose" /f

	reg delete "HKLM\SOFTWARE\Microsoft\AppVISV" /f

	reg delete "HKLM\SOFTWARE\Wow6432Node\Microsoft\Office" /f

	set key=HKLM\SOFTWARE\Microsoft\Office\Delivery\SourceEngine\Downloads
	set value=0FF1CE}

	for /f %%a in ('"reg query "%key%" | find "%value%""') do (
		reg delete "%%a" /f
	)

	set key=HKLM\SOFTWARE\Wow6432Node\Microsoft\Office\Delivery\SourceEngine\Downloads
	set value=0FF1CE}

	for /f %%a in ('"reg query "%key%" | find "%value%""') do (
		reg delete "%%a" /f
	)

	set key=HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall
	set value=0FF1CE

	for /f %%a in ('"reg query "%key%" | find "%value%""') do (
		reg delete "%%a" /f
	)

	set key=HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall
	set value=O365

	for /f %%a in ('"reg query "%key%" | find "%value%""') do (
		reg delete "%%a - ar-sa" /f
		reg delete "%%a - bg-bg" /f
		reg delete "%%a - ca-es" /f
		reg delete "%%a - cs-cz" /f
		reg delete "%%a - da-dk" /f
		reg delete "%%a - de-de" /f
		reg delete "%%a - el-gr" /f
		reg delete "%%a - en-us" /f
		reg delete "%%a - es-es" /f
		reg delete "%%a - et-ee" /f
		reg delete "%%a - eu-es" /f
		reg delete "%%a - fi-fi" /f
		reg delete "%%a - fr-fr" /f
		reg delete "%%a - gl-es" /f
		reg delete "%%a - he-il" /f
		reg delete "%%a - hi-in" /f
		reg delete "%%a - hr-hr" /f
		reg delete "%%a - hu-hu" /f
		reg delete "%%a - id-id" /f
		reg delete "%%a - it-it" /f
		reg delete "%%a - ja-jp" /f
		reg delete "%%a - kk-kz" /f
		reg delete "%%a - ko-kr" /f
		reg delete "%%a - lt-lt" /f
		reg delete "%%a - lv-lv" /f
		reg delete "%%a - ms-my" /f
		reg delete "%%a - nb-no" /f
		reg delete "%%a - nl-nl" /f
		reg delete "%%a - pl-pl" /f
		reg delete "%%a - pt-br" /f
		reg delete "%%a - pt-pt" /f
		reg delete "%%a - ro-ro" /f
		reg delete "%%a - ru-ru" /f
		reg delete "%%a - sk-sk" /f
		reg delete "%%a - sl-si" /f
		reg delete "%%a - sr-cyrl-cs" /f
		reg delete "%%a - sr-cyrl-rs" /f
		reg delete "%%a - sr-latn-cs" /f
		reg delete "%%a - sr-latn-rs" /f
		reg delete "%%a - sv-se" /f
		reg delete "%%a - th-th" /f
		reg delete "%%a - tr-tr" /f
		reg delete "%%a - uk-ua" /f
		reg delete "%%a - vi-vn" /f
		reg delete "%%a - zh-cn" /f
		reg delete "%%a - zh-tw" /f
	)

	set key=HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall
	set value=ProfessionaRetail

	for /f %%a in ('"reg query "%key%" | find "%value%""') do (
		reg delete "%%a - ar-sa" /f
		reg delete "%%a - bg-bg" /f
		reg delete "%%a - ca-es" /f
		reg delete "%%a - cs-cz" /f
		reg delete "%%a - da-dk" /f
		reg delete "%%a - de-de" /f
		reg delete "%%a - el-gr" /f
		reg delete "%%a - en-us" /f
		reg delete "%%a - es-es" /f
		reg delete "%%a - et-ee" /f
		reg delete "%%a - eu-es" /f
		reg delete "%%a - fi-fi" /f
		reg delete "%%a - fr-fr" /f
		reg delete "%%a - gl-es" /f
		reg delete "%%a - he-il" /f
		reg delete "%%a - hi-in" /f
		reg delete "%%a - hr-hr" /f
		reg delete "%%a - hu-hu" /f
		reg delete "%%a - id-id" /f
		reg delete "%%a - it-it" /f
		reg delete "%%a - ja-jp" /f
		reg delete "%%a - kk-kz" /f
		reg delete "%%a - ko-kr" /f
		reg delete "%%a - lt-lt" /f
		reg delete "%%a - lv-lv" /f
		reg delete "%%a - ms-my" /f
		reg delete "%%a - nb-no" /f
		reg delete "%%a - nl-nl" /f
		reg delete "%%a - pl-pl" /f
		reg delete "%%a - pt-br" /f
		reg delete "%%a - pt-pt" /f
		reg delete "%%a - ro-ro" /f
		reg delete "%%a - ru-ru" /f
		reg delete "%%a - sk-sk" /f
		reg delete "%%a - sl-si" /f
		reg delete "%%a - sr-cyrl-cs" /f
		reg delete "%%a - sr-cyrl-rs" /f
		reg delete "%%a - sr-latn-cs" /f
		reg delete "%%a - sr-latn-rs" /f
		reg delete "%%a - sv-se" /f
		reg delete "%%a - th-th" /f
		reg delete "%%a - tr-tr" /f
		reg delete "%%a - uk-ua" /f
		reg delete "%%a - vi-vn" /f
		reg delete "%%a - zh-cn" /f
		reg delete "%%a - zh-tw" /f
	)

	set key=HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall
	set value=0FF1CE

	for /f %%a in ('"reg query "%key%" | find "%value%""') do (
		reg delete "%%a" /f
	)

	set key=HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall
	set value=O365

	for /f %%a in ('"reg query "%key%" | find "%value%""') do (
		reg delete "%%a - ar-sa" /f
		reg delete "%%a - bg-bg" /f
		reg delete "%%a - ca-es" /f
		reg delete "%%a - cs-cz" /f
		reg delete "%%a - da-dk" /f
		reg delete "%%a - de-de" /f
		reg delete "%%a - el-gr" /f
		reg delete "%%a - en-us" /f
		reg delete "%%a - es-es" /f
		reg delete "%%a - et-ee" /f
		reg delete "%%a - eu-es" /f
		reg delete "%%a - fi-fi" /f
		reg delete "%%a - fr-fr" /f
		reg delete "%%a - gl-es" /f
		reg delete "%%a - he-il" /f
		reg delete "%%a - hi-in" /f
		reg delete "%%a - hr-hr" /f
		reg delete "%%a - hu-hu" /f
		reg delete "%%a - id-id" /f
		reg delete "%%a - it-it" /f
		reg delete "%%a - ja-jp" /f
		reg delete "%%a - kk-kz" /f
		reg delete "%%a - ko-kr" /f
		reg delete "%%a - lt-lt" /f
		reg delete "%%a - lv-lv" /f
		reg delete "%%a - ms-my" /f
		reg delete "%%a - nb-no" /f
		reg delete "%%a - nl-nl" /f
		reg delete "%%a - pl-pl" /f
		reg delete "%%a - pt-br" /f
		reg delete "%%a - pt-pt" /f
		reg delete "%%a - ro-ro" /f
		reg delete "%%a - ru-ru" /f
		reg delete "%%a - sk-sk" /f
		reg delete "%%a - sl-si" /f
		reg delete "%%a - sr-cyrl-cs" /f
		reg delete "%%a - sr-cyrl-rs" /f
		reg delete "%%a - sr-latn-cs" /f
		reg delete "%%a - sr-latn-rs" /f
		reg delete "%%a - sv-se" /f
		reg delete "%%a - th-th" /f
		reg delete "%%a - tr-tr" /f
		reg delete "%%a - uk-ua" /f
		reg delete "%%a - vi-vn" /f
		reg delete "%%a - zh-cn" /f
		reg delete "%%a - zh-tw" /f
	)

	set key=HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall
	set value=ProfessionalRetail

	for /f %%a in ('"reg query "%key%" | find "%value%""') do (
		reg delete "%%a - ar-sa" /f
		reg delete "%%a - bg-bg" /f
		reg delete "%%a - ca-es" /f
		reg delete "%%a - cs-cz" /f
		reg delete "%%a - da-dk" /f
		reg delete "%%a - de-de" /f
		reg delete "%%a - el-gr" /f
		reg delete "%%a - en-us" /f
		reg delete "%%a - es-es" /f
		reg delete "%%a - et-ee" /f
		reg delete "%%a - eu-es" /f
		reg delete "%%a - fi-fi" /f
		reg delete "%%a - fr-fr" /f
		reg delete "%%a - gl-es" /f
		reg delete "%%a - he-il" /f
		reg delete "%%a - hi-in" /f
		reg delete "%%a - hr-hr" /f
		reg delete "%%a - hu-hu" /f
		reg delete "%%a - id-id" /f
		reg delete "%%a - it-it" /f
		reg delete "%%a - ja-jp" /f
		reg delete "%%a - kk-kz" /f
		reg delete "%%a - ko-kr" /f
		reg delete "%%a - lt-lt" /f
		reg delete "%%a - lv-lv" /f
		reg delete "%%a - ms-my" /f
		reg delete "%%a - nb-no" /f
		reg delete "%%a - nl-nl" /f
		reg delete "%%a - pl-pl" /f
		reg delete "%%a - pt-br" /f
		reg delete "%%a - pt-pt" /f
		reg delete "%%a - ro-ro" /f
		reg delete "%%a - ru-ru" /f
		reg delete "%%a - sk-sk" /f
		reg delete "%%a - sl-si" /f
		reg delete "%%a - sr-cyrl-cs" /f
		reg delete "%%a - sr-cyrl-rs" /f
		reg delete "%%a - sr-latn-cs" /f
		reg delete "%%a - sr-latn-rs" /f
		reg delete "%%a - sv-se" /f
		reg delete "%%a - th-th" /f
		reg delete "%%a - tr-tr" /f
		reg delete "%%a - uk-ua" /f
		reg delete "%%a - vi-vn" /f
		reg delete "%%a - zh-cn" /f
		reg delete "%%a - zh-tw" /f
	)

	reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Office14.ENTERPRISE" /f
	reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Office14.ULTIMATE" /f
	reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Office14.PRO" /f
	reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Office14.PROPLUS" /f

	reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Office14.ENTERPRISER" /f
	reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Office14.ULTIMATER" /f
	reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Office14.PROR" /f
	reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Office14.HOMESTUDENTR" /f
	reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Office14.STANDARDR" /f
	reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Office14.SMALLBUSINESSR" /f

	reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\ENTERPRISE" /f
	reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\ULTIMATE" /f
	reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\PRO" /f
	reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\PROPLUS" /f

	reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\ENTERPRISER" /f
	reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\ULTIMATER" /f
	reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\PROR" /f
	reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\HOMESTUDENTR" /f
	reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\STANDARDR" /f
	reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\SMALLBUSINESSR" /f

	reg delete "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Office14.ENTERPRISE" /f
	reg delete "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Office14.ULTIMATE" /f
	reg delete "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Office14.PRO" /f
	reg delete "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Office14.PROPLUS" /f

	reg delete "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Office14.ENTERPRISER" /f
	reg delete "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Office14.ULTIMATER" /f
	reg delete "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Office14.PROR" /f
	reg delete "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Office14.HOMESTUDENTR" /f
	reg delete "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Office14.STANDARDR" /f
	reg delete "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Office14.SMALLBUSINESSR" /f

	reg delete "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\ENTERPRISE" /f
	reg delete "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\ULTIMATE" /f
	reg delete "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\PRO" /f
	reg delete "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\PROPLUS" /f

	reg delete "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\ENTERPRISER" /f
	reg delete "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\ULTIMATER" /f
	reg delete "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\PROR" /f
	reg delete "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\HOMESTUDENTR" /f
	reg delete "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\STANDARDR" /f
	reg delete "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\SMALLBUSINESSR" /f

	set key=HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Installer\UserData\S-1-5-18\Products
	set value=F01FEC

	for /f %%a in ('"reg query "%key%" | find "%value%""') do (
		reg delete "%%a" /f
	)

	set key=HKCR\Installer\Features
	set value=F01FEC

	for /f %%a in ('"reg query "%key%" | find "%value%""') do (
		reg delete "%%a" /f
	)

	set key=HKCR\Installer\Products
	set value=F01FEC

	for /f %%a in ('"reg query "%key%" | find "%value%""') do (
		reg delete "%%a" /f
	)

	set key=HKCR\Installer\UpgradeCodes
	set value=F01FEC

	for /f %%a in ('"reg query "%key%" | find "%value%""') do (
		reg delete "%%a" /f
	)

	set key=HKCR\Installer\Win32Assemblies
	set value=Office16

	for /f %%a in ('"reg query "%key%" | find "%value%""') do (
		reg delete "%%a" /f
	)

	set key=HKCR\Installer\Win32Assemblies
	set value=Office15

	for /f %%a in ('"reg query "%key%" | find "%value%""') do (
		reg delete "%%a" /f
	)

	set key=HKCR\Installer\Win32Assemblies
	set value=Office14

	for /f %%a in ('"reg query "%key%" | find "%value%""') do (
		reg delete "%%a" /f
	)

	set key=HKCR\Installer\Win32Assemblies
	set value=Office12

	for /f %%a in ('"reg query "%key%" | find "%value%""') do (
		reg delete "%%a" /f
	)

	set key=HKCR\Installer\Win32Assemblies
	set value=Office11

	for /f %%a in ('"reg query "%key%" | find "%value%""') do (
		reg delete "%%a" /f
	)

	reg delete "HKU\.DEFAULT\Software\Microsoft\Office" /f

	reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\winword.exe" /f
	reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\excel.exe" /f
	reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\powerpnt.exe" /f
	reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\onenote.exe" /f
	reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\outlook.exe" /f
	reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\mspub.exe" /f
	reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\msaccess.exe" /f
	reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\infopath.exe" /f
	reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\groove.exe" /f
	reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\lync.exe" /f

	reg delete "HKLM\SOFTWARE\Microsoft\AppModel" /f

	:: End process.
	:: --------------------------------------------------
	call :print The operation completed successfully.

	echo.Press any key to continue . . .
	pause>nul
goto :eof
:: /*************************************************************************************/


:: End tool.
:: void close();
:: /*************************************************************************************/
:close
	exit
goto :eof
:: /*************************************************************************************/

