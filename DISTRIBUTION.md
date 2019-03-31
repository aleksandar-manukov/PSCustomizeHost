# This file describes how to customize your PowerShell Host.
There are two ways to customize your host. You can use PSCustomizeHost module to generate and remove host customization scripts or manually to add host customization script.

In the **dist** folder you will find one zip file for PSCustomizeHost module and one zip file containing host customization script file and metadata file for the script.

### Customize your PowerShell Host using PSCustomizeHost module.
Follow the following steps.

1. [Download](https://github.com/aleksandar-manukov/PSCustomizeHost/raw/master/dist/Module/PSCustomizeHost.zip) the zip file containing PSCustomizeHost module.
2. Unzip the file. *Preferred directory for unzipping is the default directory for your PowerShell modules. Normally the default PowerShell modules directory is in 'C:\Users\\{current user}\Documents\WindowsPowerShell\Modules'. You can check it by executing `$env:PSModulePath` the first item is the default directory for your modules. If the directory doesn't exist you should create it first.*
3. Open PowerShell and import the PSCustomizeHost module. *You can import it by executing the following command `Import-Module PSCustomizeHost` if you unzip the file into the default directory for your PowerShell modules. Otherwise you should execute `Import-Module {path to folder containing unzipped files}\PSCustomizeModule`.*
4. Now we can use the following cmdlets `New-PSCustomizedHostProfile` and `Remove-PSCustomizedHostProfile` to generate and remove customized host scripts. *You can check PSCustomizeHost module examples for more information.*
5. After creating customized host script you need to restart the host in order the customization to be implemented.

### PSCustomizeHost module examples
Here are only few simple examples for creating and removing customized host script. For more information use `Get-Help` for one of the cmdlets.

1. Creating customized host script.
```
New-PSCustomizedHostProfile CurrentUserAllHosts -UseDefaultHostProfileMetadata
```
```
New-PSCustomizedHostProfile -CustomizedHostFor CurrentUserAllHosts, CurrentUserConsoleHost -DefaultLocation 'C:\' -ShowCurrentGitBranch -GitBranchNameColor Yellow
```

> **Important notes!**
> * You cannot use **AllUsersISEHost** and **CurrentUserISEHost** when you are running the script in PowerShell Console.
> * When using **UseDefaultHostProfileMetadata** the default location is 'C:\Workspaces'.
> * When customizing colors for PowerShell Console you should manually update the background and foreground colors 'Properties > Colors'. This is a bug of PowerShell console.

2. Removing customized host script.
```
Remove-PSCustomizedHostProfile -CustomizedHostFor CurrentUserAllHosts, CurrentUserConsoleHost
```

### Customize your PowerShell Host manually creating customized host script.
Follow the following steps.

1. [Download](https://github.com/aleksandar-manukov/PSCustomizeHost/raw/master/dist/Script/profile.zip) the zip file containing script for host customization and metadata file.
2. Unzip the file.
3. Manually update the metadata file by your preferences.
4. Copy the script to one of the customized host script paths. *You can check them by executing one of the following commands: `$profile.AllUsersAllHosts`, `$profile.AllUsersCurrentHost`, `$profile.CurrentUserAllHosts` or `$profile.CurrentUserCurrentHost`.*
5. Copy metadata file to the customized host script directory.
6. Rename the metadata file to `{script file name}.metadata.json`.
7. Restart the host in order the customization to be implemented.


> **Important notes!**
> * When customizing colors for PowerShell Console you should manually update the background and foreground colors 'Properties > Colors'. This is a bug of PowerShell console.
