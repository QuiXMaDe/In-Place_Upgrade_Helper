# In-Place_Upgrade_Helper
Helper tool for Windows 10/11 in-place upgrades and edition changes

Does it bother you when the Windows setup itself decides what it should do?
You want to install Pro, but the setup automatically jumps to Home because the key is stored in the firmware?
You wanted to upgrade from Pro to Pro for Workstations but don't have a GLVK key to hand?
Have you installed Pro but only realize afterwards that you only have a license for Home but are too lazy to do a clean install?
You want to upgrade Home directly to Enterprise because it's technically no different than an upgrade to Pro, but the setup doesn't allow it purely for licensing reasons?
Do you notice that the Enterprise Edition isn't actually on your consumer ISO / on your MediaCreationTool USB stick?
You want to go back to Pro from Pro Education, but there is no upgrade or downgrade path? https://learn.microsoft.com/en-us/windows/deployment/upgrade/windows-edition-upgrades
You have new installations under control with customized EI.cfg but (in-place) upgrades don't give you an edition selection?
You wanted to build an (almost) all-in-one installation medium without any tinkering or modifications to the WIM?

This tool helps.
To find out exactly how it works, just take a look at the batch. This is not an activation tool, only official pre-installation keys are used.
Simply copy this batch to the setup.exe in the installation medium. Or start it by itself and enter the path of your installation files.

If the appropriate version is not available on the installation medium, the setup is able to generate the appropriate image on the fly.
Most likely this is the same function that DISM /Get-TargetEditions and DISM /Set-Edition use (https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/change-the-windows-image -to-a-higher-edition-using-dism?view=windows-11).
This is the method with which, for example, https://uupdump.net/ can generate all other editions from the two Home and Pro editions (create_virtual_editions.cmd, https://github.com/abbodi1406/BatUtil/tree/master/uup -converter-wimlib)
This was tested with a WIM where only Home was available but setup was started with Pro-Key. As expected, the home setup still started here.
Then the Pro was added to the WIM, but nothing more. Setup was then started again with the Pro key and the correct Pro setup now appears.
The setup was aborted and now started with a Pro for Workstations key. The setup now automatically generated Pro for Workstations from the Pro.
The next test was to install Enterprise with a consumer ISO (de-de_windows_11_consumer_editions...iso), which actually doesn't have Enterprise at all. The setup also generated these from the Pro if you take the appropriate key as a parameter.
All tests were carried out online.

This results in the following upgrade chart:

Available edition for installation            required edition on installation medium

Windows Pro                                   Windows Pro
Windows Pro for Workstations                  Windows Pro
Windows Education                             Windows Pro
Windows Pro Education                         Windows Pro
Windows Enterprise                            Windows Pro
Windows Enterprise multi-session              Windows Pro
Windows IoT Enterprise                        Windows Pro
Windows SE [Cloud] (Win11 only)               Windows Pro
Windows Home                                  Windows Home
Windows Home Single Language                  Windows Home
Windows Pro N                                 Windows Pro N
Windows Pro N for Workstations                Windows Pro N
Windows Education N                           Windows Pro N
Windows Pro Education N                       Windows Pro N
Windows Enterprise N                          Windows Pro N
Windows SE [Cloud] N (Win11 only)             Windows Pro N
Windows 10 Enterprise LTSC 2021               Windows 10 Enterprise LTSC 2021
Windows 10 Enterprise N LTSC 2021             Windows 10 Enterprise LTSC N 2021
Windows 10 IoT Enterprise LTSC 2021           Windows 10 Enterprise LTSC 2021
Windows 11 Enterprise LTSC 2024               Windows 11 Enterprise LTSC 2024
Windows 11 Enterprise N LTSC 2024             Windows 11 Enterprise N LTSC 2024
Windows 11 IoT Enterprise LTSC 2024           Windows 11 Enterprise LTSC 2024
Windows 11 IoT Enterprise LTSC Subscr. 2024   Windows 11 Enterprise LTSC 2024
Windows Server 2022 Standard                  Windows Server 2022 Standard
Windows Server 2022 Datacenter                Windows Server 2022 Datacenter
Windows Server 2025 Standard                  Windows Server 2025 Standard
Windows Server 2025 Datacenter                Windows Server 2025 Datacenter


This also means that your ISO only needs to contain Home, Home N, Pro and Pro N in order to be able to install all available editions (without LTSC).
A completely normal consumer installation medium already meets these requirements.
In other words: A standard ISO or a standard USB stick (https://www.microsoft.com/de-de/software-download/windows11) becomes an all-in-one installer with this batch.
At the moment the tool does not support the Home China edition.
All installation tests were done with de-de_windows_11_consumer_editions_version_23h2_updated_feb_2024_x64_dvd_9665512b.iso and an USB Stick created with MediaCreationTool Win11_23H2 as a base.

DANGER:
LTSC editions are NOT included in the normal installation media. To use this editions you have to get the appropriate ISO yourself.
The same of course also applies to Server 2022/2025.
Windows 10 Enterprise LTSC 2021 (and IoT/N) were tested with de-de_windows_10_enterprise_ltsc_2021_x64_dvd_71796d33.iso.

BONUS:
The folder "[optional_install_media_mods]" contains a script to deactivate any installation requirements like TPM or secure boot.
Additional info for EI.CFG: While doing a clean install only the actually existing editions on the installation medium are shown, not the edition that can be generated. Generating addition edtions is only possible with an in-place-upgrade.

ONLY sources\$OEM$\$$\Panther\unattend.xml IS SUPPORTED!
autounattend.xml in root folder or similar breaks In-Place_Upgrade_Helper.bat!


Changelog:
v0.92
Did some tests with unattend.xml and autounattend.xml. Anything besides sources\$OEM$\$$\Panther\ breaks this tool, and that gave me some problems with some TPM-requirement workarounds...
So I wrote a small extra script to modify the Windows installation files. Obviously this only works with extracted ISOs and USB-sticks, not mounted ISOs.

Added from me:
Autosearch storages with installation files
Support "multi"-languages (read "_readme.txt" in "_languages" folder)
Re-structured and recolored menu