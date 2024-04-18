This is an upgrade helper tool for Windows 10/11 and Windows Server.

This tool can upgrade Windows via four different methods:

- Changing the product key via `slmgr`. This method only supports [the official upgrade paths][1].

- Starting `Setup.exe` and letting it choose the edition by itself. This is an ordinary in-place upgrade.

- Starting an in-place upgrade of a Windows edition of your choice. This method stops Windows Setup from using any firmware-embedded keys or your current edition. This is done by using an OEM GLVK key as a setup parameter. This method only supports [the official upgrade paths][1].

- Starting a forced in-place upgrade to keep all apps and settings. This method modifies the Windows Registry before using OEM GLVK keys, enabling an edition change outside the supported upgrade path, e.g., "Pro" to "Home," "Education Pro" or "Enterprise," or "Education" to "IoT Enterprise LTSC". Microsoft does not endorse this method. Use this method at your own risk. Please back up your system in advance.

Additional information, including a chart showing all supported editions, can be found in `In-Place_Upgrade_Helper_readme.txt`

Copy this tool to your installation media alongside `setup.exe` and run it. Or start it by itself and enter the path of your installation files.
External installation files, like a mounted or extracted ISO, are supported.

![IUH3](https://github.com/TheMMC/In-Place_Upgrade_Helper/assets/87301831/d12cf777-2699-4faa-8552-65e818078dd2)
![IUH4](https://github.com/TheMMC/In-Place_Upgrade_Helper/assets/87301831/da2961c9-e1f2-43b1-8141-df625449ff9d)
![IUH1](https://github.com/TheMMC/In-Place_Upgrade_Helper/assets/87301831/65a2bdbb-b052-4941-9ea3-db043227fc2b)
![cmd_UqN0tOTj2y](https://github.com/QuiXMaDe/In-Place_Upgrade_Helper/assets/112066385/fe984690-33a2-4fdb-b624-7ebfb60ba4e8)


Please note:

- This tool is a work in progress.
- This tool **DOES NOT** activate Windows. Any product keys it uses are placeholder OEM GVLK keys.
- Tool reworked with support any languages. Read the "_languages\_readme.txt" file.

[1]: https://learn.microsoft.com/en-us/windows/deployment/upgrade/windows-edition-upgrades
