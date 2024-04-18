@echo off & cls
setLocal EnableExtensions EnableDelayedExpansion
set bat_name=M-M-C's quick-n-dirty In-Place-Upgrade-Helper for Win10/11
set bat_ver=0.92 (optimized)
set ccols=125
set clines=45
rem mode con: cols=!ccols! lines=!clines!

set VBS_UAC=%temp%\getadmin.vbs
>nul 2>&1 fsutil dirty query %systemdrive% && (goto gotAdmin)

:UACPrompt
if exist "%SYSTEMROOT%\System32\Cscript.exe" (
    echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "%~s0", "", "", "runas", 1 >"!VBS_UAC!" 
    Cscript.exe //nologo "!VBS_UAC!"
	del /f /q "!VBS_UAC!"
    exit
) else (
	powershell -v >nul 2>nul
	if "!errorlevel!"=="9009" echo Csript.exe and Powershell not found. Exit. & pause & goto endofbatch
    powershell -c "Start-Process -Verb RunAs -FilePath '%~0'"
    exit
)

:gotAdmin
pushd "%CD%" && CD /D "%~dp0"
if not defined iammaximized (
    set iammaximized=1
	start /max "" "%0" "%*"
    exit
)

call :translateENG
for %%a in (%~dp0\*.hprlng) do set current_lang=%%a
if not "!current_lang!"=="" call :load_translate

echo !hint_maximized_window_text!
echo !hint_maximized_window_terminalbug_text!
call :pause
REM Automatic loading of system variables
for /f "tokens=1,2*" %%a in ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion"') do (
	if "%%a"=="ProductName" set current_productname=%%c
	if "%%a"=="EditionID" set current_editionid=%%c
	if "%%a"=="CompositionEditionID" set current_compositioneditionid=%%c
)
REM Check if the variables are set and use default values if not
if "%current_productname%"=="" set current_productname=!not_available!
if "%current_editionid%"=="" set current_editionid=!not_available!
if "%current_compositioneditionid%"=="" set current_compositioneditionid=!not_available!

set sourcespath=.

:premainmenu
if not exist "%sourcespath%\setup.exe" call :search_storages "\setup.exe" "\sources\" & goto premainmenu

Title !bat_name! Ver:!bat_ver!
call :AllWindowsVersions
call :setvar "!not_available!" "!not_available!" "!not_available!" "!not_available!"
set tlines=
for /L %%a in (2,1,!ccols!) do set tlines=-!tlines!

cls
echo !files_found_text!
echo.
echo !hint_not_available_text!
echo !upgrade_chart_text!:
echo.
echo !table_available_required_text!
echo.
echo Windows Pro                                   Windows Pro
echo Windows Pro for Workstations                  Windows Pro
echo Windows Education                             Windows Pro
echo Windows Pro Education                         Windows Pro
echo Windows Enterprise                            Windows Pro
echo Windows Enterprise multi-session              Windows Pro
echo Windows IoT Enterprise                        Windows Pro
echo Windows SE [Cloud] (Win11 only)               Windows Pro
echo Windows Home                                  Windows Home
echo Windows Home Single Language                  Windows Home
echo Windows Pro N                                 Windows Pro N
echo Windows Pro N for Workstations                Windows Pro N
echo Windows Education N                           Windows Pro N
echo Windows Pro Education N                       Windows Pro N
echo Windows Enterprise N                          Windows Pro N
echo Windows SE [Cloud] N (Win11 only)             Windows Pro N
echo Windows 10 Enterprise LTSC 2021               Windows 10 Enterprise LTSC 2021
echo Windows 10 Enterprise N LTSC 2021             Windows 10 Enterprise LTSC N 2021
echo Windows 10 IoT Enterprise LTSC 2021           Windows 10 Enterprise LTSC 2021
echo Windows 11 Enterprise LTSC 2024               Windows 11 Enterprise LTSC 2024
echo Windows 11 Enterprise N LTSC 2024             Windows 11 Enterprise N LTSC 2024
echo Windows 11 IoT Enterprise LTSC 2024           Windows 11 Enterprise LTSC 2024
echo Windows 11 IoT Enterprise LTSC Subscr. 2024   Windows 11 Enterprise LTSC 2024
echo Windows Server 2022 Standard                  Windows Server 2022 Standard
echo Windows Server 2022 Datacenter                Windows Server 2022 Datacenter
echo Windows Server 2025 Standard                  Windows Server 2025 Standard
echo Windows Server 2025 Datacenter                Windows Server 2025 Datacenter
echo.
call :pause "!press_any_key_to_list_text!"
echo !reading_installation_text!
if exist "%sourcespath%\sources\install.wim" powershell -ExecutionPolicy Bypass -Command "Get-WindowsImage -ImagePath '%sourcespath%\sources\install.wim' | Select-Object -Property ImageName, ImageDescription, ImageIndex"
if exist "%sourcespath%\sources\install.esd" powershell -ExecutionPolicy Bypass -Command "Get-WindowsImage -ImagePath '%sourcespath%\sources\install.esd' | Select-Object -Property ImageName, ImageDescription, ImageIndex"
if exist "%sourcespath%\sources\install.swm" powershell -ExecutionPolicy Bypass -Command "Get-WindowsImage -ImagePath '%sourcespath%\sources\install.swm' | Select-Object -Property ImageName, ImageDescription, ImageIndex"
call :pause "!press_any_key_to_start_text!"

:mainmenu
cls
REM echo.
REM echo [95m!bat_name! Ver:!bat_ver![0m
REM echo.
rem echo [96m!current_system_text!:[0m 
echo [96mProductName:[0m "%current_productname%" ^| [96mEditionID:[0m "%current_editionid%" ^| [96mCompositionEditionID:[0m "%current_compositioneditionid%"
echo ([93m!hint_win11_text![0m)
echo.
echo [92m!selected_system_text!:[0m
echo --- [92mProductName:[0m %productname%
echo --- [92mEditionID:[0m %editionid%
echo --- [92mCompositionEditionID:[0m %compositioneditionid% ([93m!hint_composition_text![0m)
echo --- [92mOEM ProductKey:[0m %productkey% ([93m!hint_productkey_text![0m)
echo !tlines!
echo         [93mStandart Version                            N/IoT/SE-version[0m
echo !tlines!
echo !x_1! 1) Windows Home[0m                          !x_9! 9) Windows Home N[0m
echo !x_2! 2) Windows Pro[0m                           !x_10! 10) Windows Pro N[0m
echo !x_3! 3) Windows Pro for Workstations[0m          !x_11! 11) Windows Pro N for Workstations[0m
echo !x_4! 4) Windows Enterprise[0m                    !x_12! 12) Windows Enterprise N[0m
echo                                              !x_13! 13) Windows IoT Enterprise[0m
echo                                              !x_14! 14) Windows Enterprise multi-session[0m
echo !x_5! 5) Windows Education[0m                     !x_15! 15) Windows Education N[0m
echo !x_6! 6) Windows Pro Education[0m                 !x_16! 16) Windows Pro Education N[0m
echo !x_7! 7) Windows Home Single Language[0m
echo !x_8! 8) Windows 11 SE CloudEdition[0m            !x_17! 17) Windows 11 SE CloudEdition N[0m
echo !tlines!
echo         [93m!special_edition_text!:[0m
echo !tlines!
echo [93mWindows 10 LTSC:[0m
echo !x_18! 18) Windows 10 Enterprise LTSC 2021[0m      !x_19! 19) Windows 10 Enterprise N LTSC 2021[0m
echo                                              !x_20! 20) Windows 10 IoT Enterprise LTSC 2021[0m
echo [93mWindows 11 LTSC:[0m
echo !x_21! 21) Windows 11 Enterprise LTSC 2024[0m      !x_22! 22) Windows 11 Enterprise N LTSC 2024[0m
echo                                              !x_23! 23) Windows 11 IoT Enterprise LTSC 2024[0m
echo                                              !x_24! 24) Windows 11 IoT Enterprise LTSC Subscription 2024[0m
echo [93mServers:[0m
echo !x_25! 25) Windows Server 2022 Standard[0m         !x_27! 27) Windows Server 2025 Standard[0m
echo !x_26! 26) Windows Server 2022 Datacenter[0m       !x_28! 28) Windows Server 2025 Datacenter[0m
if not "%productkey%"=="!not_available!" (
	echo.
	echo !readyto_text!:
	echo  K^) !slmgr_method_upgrade_text!
	echo  S^) !without_selecting_upgrade_text!
	echo  U^) !upgrade_text!
	echo  F^) !forced_upgrade_text!
	echo  R^) !reset_choice_text!
)
echo.
echo 0) !exit_text!
echo.
set choiced=
set /p input_menu=!toinput_text!: || set input_menu=
if not defined input_menu goto mainmenu

if not "!productname[%input_menu%]!"=="" (
	call :setvar "!productname[%input_menu%]!" "!editionid[%input_menu%]!" "!compositioneditionid[%input_menu%]!" "!productkey[%input_menu%]!"
)

if not "%productkey%"=="!not_available!" (
	if /I "%input_menu%"=="k" goto keychange
	if /I "%input_menu%"=="s" goto runboringupgrade
	if /I "%input_menu%"=="u" goto runupgrade
	if /I "%input_menu%"=="f" goto runforcedupgrade
	if /I "%input_menu%"=="r" call :setvar "!not_available!" "!not_available!" "!not_available!" "!not_available!"
)
if "%input_menu%"=="0" goto endofbatch
if "!choiced!"=="1" goto mainmenu

echo.
echo "%input_menu%" !not_found_item!
echo.
call :pause
goto mainmenu

:keychange
echo !keychange_text!
slmgr /ipk %productkey%
goto mainmenu

:runboringupgrade
echo.
echo !running_text!
%sourcespath%\setup.exe /eula accept /telemetry disable /priority normal /resizerecoverypartition enable
goto completebatch

:runupgrade
echo.
echo !running_text!
%sourcespath%\setup.exe /eula accept /telemetry disable /priority normal /resizerecoverypartition enable /pkey %productkey%
goto completebatch

:runforcedupgrade
echo.
echo !forced_1_text!
echo !forced_2_text!
echo !forced_3_text!
echo !forced_4_text!
echo !forced_5_text!
echo !forced_6_text!
echo.
echo !forced_7_text!
echo !forced_8_text!
echo !forced_9_text!
echo.
echo !forced_10_text!
echo.
call :pause
echo.
echo !reg_entries_text!
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v "EditionID" /t REG_SZ /d "%editionid%" /f
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v "ProductName" /t REG_SZ /d "%productname%" /f
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v "CompositionEditionID" /t REG_SZ /d "%compositioneditionid%" /f
reg add "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows NT\CurrentVersion" /v "EditionID" /t REG_SZ /d "%editionid%" /f /reg:32
reg add "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows NT\CurrentVersion" /v "ProductName" /t REG_SZ /d "%productname%" /f /reg:32
reg add "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows NT\CurrentVersion" /v "CompositionEditionID" /t REG_SZ /d "%compositioneditionid%" /f /reg:32
echo.
echo !running_text!
%sourcespath%\setup.exe /eula accept /telemetry disable /priority normal /resizerecoverypartition enable /pkey %productkey%
goto completebatch

:pause
if not "%~1"=="" (
	pause>nul|set/p=%~1&echo.
) else (
	pause>nul|set/p=!press_any_key_text!&echo.
)
exit/b

:nosetupfound
echo %~1 !not_found_setup_1_text!
echo !not_found_setup_2_text!
set /p sourcespath=!enter_sourcepath_text!: 
goto premainmenu

:setvar
rem %1 - ProductName, %2 - EditionID, %3 - CompositionEditionID, %4 - ProductKey
set productname=%~1
set editionid=%~2
set compositioneditionid=%~3
set productkey=%~4

for /L %%a in (1,1,!AllWindowsVersions_count!) do set x_%%a=[90m[ ]
if defined input_menu if /I not "!input_menu!"=="r" set x_!input_menu!=[92m[X]
set choiced=1
exit /b

:search_storages
echo.
Title !autosearch_instpath_text!
set alph_disc=ABCDEFGHIJKLMNOPQRSTUVWXYZ
set count=0
set count_storages=0
:search_storages_loop
set current_letter=!alph_disc:~%count%,1!
if exist "!current_letter!:%~1" if exist "!current_letter!:%~2" (
	set /a count_storages=!count_storages!+1
	set storage_!count_storages!=!current_letter!:
)
set /a count=!count!+1
if not "!alph_disc:~%count%,1!"=="" goto search_storages_loop
if "!count_storages!"=="0" goto nosetupfound
:search_storages_choose_loop
cls
echo.
echo !storages_found_text!
echo.
for /l %%a in (1,1,!count_storages!) do echo  %%a^) !storage_text! !storage_%%a!%~1
echo.
set /p storage_input=!choose_storage_text!: || set storage_input=
if not defined storage_input goto search_storages_choose_loop
if /I "!storage_input!"=="m" goto nosetupfound
if not exist "!storage_%storage_input%!" (
	echo !choose_from_list_text!
	echo.
	call :pause
	goto search_storages_choose_loop
)
set sourcespath=!storage_%storage_input%!
set alph_disc=
set count=
set current_letter=
exit /b

:completebatch
echo !complete_text!
timeout /t 3 /nobreak >nul
goto endofbatch

:endofbatch
endLocal
exit

REM =================== Windows Version Massive
:AllWindowsVersions
REM Windows Home
set productname[1]=Windows 10 Home
set editionid[1]=Core
set compositioneditionid[1]=Core
set productkey[1]=YTMG3-N6DKC-DKB77-7M9GH-8HVX7

REM Windows Pro
set productname[2]=Windows 10 Pro
set editionid[2]=Professional
set compositioneditionid[2]=Enterprise
set productkey[2]=VK7JG-NPHTM-C97JM-9MPGT-3V66T

REM Windows Pro for Workstations
set productname[3]=Windows 10 Pro for Workstations
set editionid[3]=ProfessionalWorkstation
set compositioneditionid[3]=Enterprise
set productkey[3]=DXG7C-N36C4-C4HTG-X4T3X-2YV77

REM Windows Enterprise
set productname[4]=Windows 10 Enterprise
set editionid[4]=Enterprise
set compositioneditionid[4]=Enterprise
set productkey[4]=XGVPP-NMH47-7TTHJ-W3FW7-8HV2C

REM Windows Education
set productname[5]=Windows 10 Education
set editionid[5]=Education
set compositioneditionid[5]=Enterprise
set productkey[5]=YNMGQ-8RYV3-4PGQ3-C8XTP-7CFBY

REM Windows Pro Education
set productname[6]=Windows 10 Pro Education
set editionid[6]=ProfessionalEducation
set compositioneditionid[6]=Enterprise
set productkey[6]=8PTT6-RNW4C-6V7J2-C2D3X-MHBPB

REM Windows Home Single Language
set productname[7]=Windows 10 Home Single Language
set editionid[7]=CoreSingleLanguage
set compositioneditionid[7]=Core
set productkey[7]=BT79Q-G7N6G-PGBYW-4YWX6-6F4BT

REM Windows SE CloudEdition
set productname[8]=Windows 10 SE
set editionid[8]=CloudEdition
set compositioneditionid[8]=Enterprise
set productkey[8]=KY7PN-VR6RX-83W6Y-6DDYQ-T6R4W

REM Windows Home N
set productname[9]=Windows 10 Home N
set editionid[9]=CoreN
set compositioneditionid[9]=CoreN
set productkey[9]=4CPRK-NM3K3-X6XXQ-RXX86-WXCHW

REM Windows Pro N
set productname[10]=Windows 10 Pro N
set editionid[10]=ProfessionalN
set compositioneditionid[10]=EnterpriseN
set productkey[10]=2B87N-8KFHP-DKV6R-Y2C8J-PKCKT

REM Windows Pro N for Workstations
set productname[11]=Windows 10 Pro N for Workstations
set editionid[11]=ProfessionalWorkstationN
set compositioneditionid[11]=EnterpriseN
set productkey[11]=WYPNQ-8C467-V2W6J-TX4WX-WT2RQ

REM Windows Enterprise N
set productname[12]=Windows 10 Enterprise N
set editionid[12]=EnterpriseN
set compositioneditionid[12]=EnterpriseN
set productkey[12]=3V6Q6-NQXCX-V8YXR-9QCYV-QPFCT

REM Windows IoT Enterprise
set productname[13]=Windows 10 IoT Enterprise
set editionid[13]=IoTEnterprise
set compositioneditionid[13]=Enterprise
set productkey[13]=XQQYW-NFFMW-XJPBH-K8732-CKFFD

REM Windows Enterprise multi-session / Virtual Desktops
set productname[14]=Windows 10 Enterprise multi-session
set editionid[14]=ServerRdsh
set compositioneditionid[14]=Enterprise
set productkey[14]=CPWHC-NT2C7-VYW78-DHDB2-PG3GK

REM Windows Education N
set productname[15]=Windows 10 Education N
set editionid[15]=EducationN
set compositioneditionid[15]=EnterpriseN
set productkey[15]=84NGF-MHBT6-FXBX8-QWJK7-DRR8H

REM Windows Pro Education N
set productname[16]=Windows 10 Pro Education N
set editionid[16]=ProfessionalEducationN
set compositioneditionid[16]=EnterpriseN
set productkey[16]=GJTYN-HDMQY-FRR76-HVGC7-QPF8P

REM Windows SE CloudEdition N
set productname[17]=Windows 10 SE N
set editionid[17]=CloudEditionN
set compositioneditionid[17]=EnterpriseN
set productkey[17]=K9VKN-3BGWV-Y624W-MCRMQ-BHDCD

REM Windows 10 Enterprise LTSC 2021
set productname[18]=Windows 10 Enterprise LTSC 2021
set editionid[18]=EnterpriseS
set compositioneditionid[18]=EnterpriseS
set productkey[18]=M7XTQ-FN8P6-TTKYV-9D4CC-J462D

REM Windows 10 Enterprise N LTSC 2021
set productname[19]=Windows 10 Enterprise N LTSC 2021
set editionid[19]=EnterpriseSN
set compositioneditionid[19]=EnterpriseSN
set productkey[19]=2D7NQ-3MDXF-9WTDT-X9CCP-CKD8V

REM Windows 10 IoT Enterprise LTSC 2021
set productname[20]=Windows 10 IoT Enterprise LTSC 2021
set editionid[20]=IoTEnterpriseS
set compositioneditionid[20]=EnterpriseS
set productkey[20]=QPM6N-7J2WJ-P88HH-P3YRH-YY74H

REM Windows 11 Enterprise LTSC 2024
set productname[21]=Windows 10 Enterprise LTSC 2024
set editionid[21]=EnterpriseS
set compositioneditionid[21]=EnterpriseS
set productkey[21]=M7XTQ-FN8P6-TTKYV-9D4CC-J462D

REM Windows 11 Enterprise N LTSC 2024
set productname[22]=Windows 10 Enterprise N LTSC 2024
set editionid[22]=EnterpriseSN
set compositioneditionid[22]=EnterpriseSN
set productkey[22]=92NFX-8DJQP-P6BBQ-THF9C-7CG2H

REM Windows 11 IoT Enterprise LTSC 2024
set productname[23]=Windows 10 IoT Enterprise LTSC 2024
set editionid[23]=IoTEnterpriseS
set compositioneditionid[23]=EnterpriseS
set productkey[23]=KBN8V-HFGQ4-MGXVD-347P6-PDQGT

REM Windows 11 IoT Enterprise LTSC Subscription 2024
set productname[24]=Windows 10 IoT Enterprise Subscription LTSC 2024
set editionid[24]=IoTEnterpriseSK
set compositioneditionid[24]=EnterpriseS
set productkey[24]=N979K-XWD77-YW3GB-HBGH6-D32MH

REM Windows Server 2022 Standard / Standard with desktop experience
set productname[25]=Windows Server 2022 Standard
set editionid[25]=ServerStandard
set compositioneditionid[25]=ServerStandard
set productkey[25]=VDYBN-27WPP-V4HQT-9VMD4-VMK7H

REM Windows Server 2022 Datacenter / Datacenter with desktop experience
set productname[26]=Windows Server 2022 Datacenter
set editionid[26]=ServerDatacenter
set compositioneditionid[26]=ServerDatacenter
set productkey[26]=WX4NM-KYWYW-QJJR4-XV3QB-6VM33

REM Windows Server 2025 Standard / Standard with desktop experience
set productname[27]=Windows Server 2025 Standard
set editionid[27]=ServerStandard
set compositioneditionid[27]=ServerStandard
set productkey[27]=DPNXD-67YY9-WWFJJ-RYH99-RM832

REM Windows Server 2025 Datacenter / Datacenter with desktop experience
set productname[28]=Windows Server 2025 Datacenter
set editionid[28]=ServerDatacenter
set compositioneditionid[28]=ServerDatacenter
set productkey[28]=CNFDQ-2BW8H-9V4WM-TKCPD-MD2QF

rem Add Here
REM set productname[next_num]=
REM set editionid[next_num]=
REM set compositioneditionid[next_num]=
REM set productkey[next_num]=

set AllWindowsVersions_count=0
:AllWindowsVersions_loopcount
set /a AllWindowsVersions_count+=1
if not "!productkey[%AllWindowsVersions_count%]!"=="" (goto AllWindowsVersions_loopcount) else set /a AllWindowsVersions_count-=1
exit /b

REM =================== ENGLISH TRANSLATE
:translateENG
set chcp_current=1251
chcp 1251 >nul

set hint_maximized_window_text=If this windows is not maximized please change the size manually.
set hint_maximized_window_terminalbug_text=This is a know bug in Windows Terminal.
set not_available=N/A
set files_found_text=Installation files found
set hint_not_available_text=If the chosen edition is not available on the installation medium, Windows setup can generate certain editions by itself.
set upgrade_chart_text=Upgrade chart
set table_available_required_text=Available edition for installation            required edition on installation medium
set press_any_key_to_list_text=Press any key to list available editions on the installation medium.
set reading_installation_text=Reading installation medium, please wait...
set press_any_key_to_start_text=Press any key to start the In-Place-Upgrade-Helper.
set press_any_key_text=Press any key to continue...

set current_system_text=Current system
set hint_win11_text=Microsoft uses "Windows 10" for this registry key even if Windows 11 is installed
set selected_system_text=Selected system
set hint_composition_text=Base edition, on which the actual edition is technically derived from
set hint_productkey_text=Official key from Microsoft for pre-installation, not for activation
set special_edition_text=Special editions, only available on separate installation media
set readyto_text=Ready to
set slmgr_method_upgrade_text=Try to install the selected key with SLMGR (simple edition change without in-place upgrade)
set without_selecting_upgrade_text=Upgrade without selecting an edition, setup decides alone (equivalent to a normal in-place upgrade)
set upgrade_text=Upgrade to the selected edition (the appropriate pre-installation key is used for the setup)
set forced_upgrade_text=FORCED upgrade to the selected edition (the appropriate pre-installation key is used for the setup)
set reset_choice_text=Reset choice
set exit_text=Exit
set toinput_text=Please make a selection
set not_found_item=was not found, please try again

set keychange_text=An attempt is made to "change" the edition by simply changing the key...
set running_text=Setup and background processes are running, please wait. This window then closes automatically.
set complete_text=Complete

set forced_1_text=Forces an in-place upgrade (apps and settings are retained) to the selected version by "faking" a different version in the registry.
set forced_2_text=For example, if Pro is to be installed, then "ProductName" and "EditionID" in the registry will be overwritten with the values of the Pro edition.
set forced_3_text=Setup then thinks the Pro is already installed and continues with the in-place upgrade.
set forced_4_text=This means you can do an in-place upgrade that is not in the official upgrade path, e.g. downgrades from Pro to Home.
set forced_5_text=But upgrade paths that are blocked for licensing reasons, such as Home directly to Enterprise, can also be unlocked with this.
set forced_6_text=Or even very creative things like Win10 Edu work on Win10 IoT Enterprise LTSC.
set forced_7_text=This is of course completely unsupported by Microsoft, use at your own risk.
set forced_8_text=However, no problems have arisen so far, everything behaves like a normal in-place upgrade.
set forced_9_text=Are you sure you want to continue? Otherwise, cancel with CTRL+C or simply close the window.
set forced_10_text=If you accidentally wrote the wrong edition into the registry, simply restart the forced in-place upgrade with the correct edition.
set reg_entries_text=Set registry entries...

set autosearch_instpath_text=Trying to search for installation storage automatically
set storages_found_text=The tool is not located in the installation folder. Storages with installation files found. 
set choose_storage_text=Choose a storage (M - Enter manually)
set choose_from_list_text=Choose from current list
set storage_text=Storage

set not_found_setup_1_text=not found. Tool not copied to the installation files?
set not_found_setup_2_text=Try using an external installation storage...
set enter_sourcepath_text=Please enter path to the installation storage (e.g. "F:\" or "D:\unpackedISO\")
exit /b

:load_translate
for /f "tokens=1* delims==" %%a in ('type "!current_lang!"') do if "%%a"=="chcp_current" set %%a=%%b
chcp !chcp_current! >nul
for /f "tokens=1* delims==" %%a in ('type "!current_lang!"') do set %%a=%%b
exit /b