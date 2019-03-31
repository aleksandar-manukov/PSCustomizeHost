<#
.Synopsis
   Create customized profile for PowerShell Hosts.
.DESCRIPTION
   Using profile metadata you can create a customized profile for PowerShell Hosts. 
   
   By default only the current location will be customized to show only the last folder. For example 'PS C:\Users\{CurrentUser}\Documents > ' will be 'Documents > '. 
   You can customize also the default location, host colors and to show current git branch name.
.EXAMPLE
   Example of how to use this cmdlet
.EXAMPLE
   Another example of how to use this cmdlet
.INPUTS
   Inputs to this cmdlet (if any)
.OUTPUTS
   Output from this cmdlet (if any)
.NOTES
   General notes
.COMPONENT
   The component this cmdlet belongs to
.ROLE
   The role this cmdlet belongs to
.FUNCTIONALITY
   The functionality that best describes this cmdlet
#>
function New-PSCustomizedHostProfile
{
    [CmdletBinding()]
    [Alias()]
    [OutputType([void])]
    Param
    (
        # Customize Host for.
        [Parameter(Mandatory=$true, 
                   ValueFromPipeline=$false,
                   ValueFromPipelineByPropertyName=$false, 
                   ValueFromRemainingArguments=$false, 
                   Position=0,
                   ParameterSetName='Customize Host For')]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [ValidateCount(0, 6)]
        [ValidateSet("CurrentUserAllHosts", "CurrentUserISEHost", "CurrentUserConsoleHost", "AllUsersAllHosts", "AllUsersISEHost", "AllUsersConsoleHost")]
        [Alias("HostFor")] 
        [string[]]
        $CustomizedHostFor,

        # Show current git branch name
        [Parameter(Mandatory=$false, 
                   ValueFromPipeline=$false,
                   ValueFromPipelineByPropertyName=$false, 
                   ValueFromRemainingArguments=$false)]
        [Switch]
        $UseDefaultHostProfileMetadata,

        # Default location.
        [Parameter(Mandatory=$false, 
                   ValueFromPipeline=$false,
                   ValueFromPipelineByPropertyName=$false, 
                   ValueFromRemainingArguments=$false)]
        [string]
        $DefaultLocation,

        # Show current git branch name
        [Parameter(Mandatory=$false, 
                   ValueFromPipeline=$false,
                   ValueFromPipelineByPropertyName=$false, 
                   ValueFromRemainingArguments=$false)]
        [Switch]
        $ShowCurrentGitBranch,

        # Branch name color
        [Parameter(Mandatory=$false, 
                   ValueFromPipeline=$false,
                   ValueFromPipelineByPropertyName=$false, 
                   ValueFromRemainingArguments=$false)]
        [ConsoleColor]
        $GitBranchNameColor,

        # Host background color
        [Parameter(Mandatory=$false, 
                   ValueFromPipeline=$false,
                   ValueFromPipelineByPropertyName=$false, 
                   ValueFromRemainingArguments=$false)]
        [ConsoleColor]
        $HostBackgroundColor,

        # Host foreground color
        [Parameter(Mandatory=$false, 
                   ValueFromPipeline=$false,
                   ValueFromPipelineByPropertyName=$false, 
                   ValueFromRemainingArguments=$false)]
        [ConsoleColor]
        $HostForegroundColor,

        # Host error background color
        [Parameter(Mandatory=$false, 
                   ValueFromPipeline=$false,
                   ValueFromPipelineByPropertyName=$false, 
                   ValueFromRemainingArguments=$false)]
        [ConsoleColor]
        $HostErrorBackgroundColor,

        # Host error foreground color
        [Parameter(Mandatory=$false, 
                   ValueFromPipeline=$false,
                   ValueFromPipelineByPropertyName=$false, 
                   ValueFromRemainingArguments=$false)]
        [ConsoleColor]
        $HostErrorForegroundColor,

        # Host warning background color
        [Parameter(Mandatory=$false, 
                   ValueFromPipeline=$false,
                   ValueFromPipelineByPropertyName=$false, 
                   ValueFromRemainingArguments=$false)]
        [ConsoleColor]
        $HostWarningBackgroundColor,

        # Host warning foreground color
        [Parameter(Mandatory=$false, 
                   ValueFromPipeline=$false,
                   ValueFromPipelineByPropertyName=$false, 
                   ValueFromRemainingArguments=$false)]
        [ConsoleColor]
        $HostWarningForegroundColor,

        # Host debug background color
        [Parameter(Mandatory=$false, 
                   ValueFromPipeline=$false,
                   ValueFromPipelineByPropertyName=$false, 
                   ValueFromRemainingArguments=$false)]
        [ConsoleColor]
        $HostDebugBackgroundColor,

        # Host debug foreground color
        [Parameter(Mandatory=$false, 
                   ValueFromPipeline=$false,
                   ValueFromPipelineByPropertyName=$false, 
                   ValueFromRemainingArguments=$false)]
        [ConsoleColor]
        $HostDebugForegroundColor,

        # Host verbose background color
        [Parameter(Mandatory=$false, 
                   ValueFromPipeline=$false,
                   ValueFromPipelineByPropertyName=$false, 
                   ValueFromRemainingArguments=$false)]
        [ConsoleColor]
        $HostVerboseBackgroundColor,

        # Host verbose foreground color
        [Parameter(Mandatory=$false, 
                   ValueFromPipeline=$false,
                   ValueFromPipelineByPropertyName=$false, 
                   ValueFromRemainingArguments=$false)]
        [ConsoleColor]
        $HostVerboseForegroundColor,

        # Host progress background color
        [Parameter(Mandatory=$false, 
                   ValueFromPipeline=$false,
                   ValueFromPipelineByPropertyName=$false, 
                   ValueFromRemainingArguments=$false)]
        [ConsoleColor]
        $HostProgressBackgroundColor,

        # Host progress foreground color
        [Parameter(Mandatory=$false, 
                   ValueFromPipeline=$false,
                   ValueFromPipelineByPropertyName=$false, 
                   ValueFromRemainingArguments=$false)]
        [ConsoleColor]
        $HostProgressForegroundColor
    )

    Begin
    {
        Write-Verbose "Getting module path.";
        if ($PSScriptRoot -eq $null -or $PSScriptRoot -eq "")
        {
            $ModulePath = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath('.\');
        }
        else
        {
            $ModulePath = $PSScriptRoot;
        }
        
        Write-Verbose "Module path is $ModulePath.";

        $ScriptPath = "$ModulePath\Scripts\profile.ps1";
        
        Write-Verbose "Customized host script path is $ScriptPath.";

        $MetadataPath = "$ModulePath\Scripts\default.metadata.json";
        
        Write-Verbose "Customized host metadata path is $MetadataPath.";
        
        Write-Verbose "Testing whether customizing host script exists.";
        if (!(Test-Path -Path "$ScriptPath"))
        {
            throw [System.IO.FileNotFoundException]::new("Could not find path: $ScriptPath");
        }
    }
    Process
    {
        Write-Verbose "Generating profile metadata object";
        if ($UseDefaultHostProfileMetadata)
        {
            $ProfileMetadata = Get-Content -Path "$MetadataPath" | ConvertFrom-Json;
        }
        else
        {
            $ProfileMetadata = [PSCustomObject]@{
                DefaultLocation = $DefaultLocation
                GitMetadata = [PSCustomObject]@{
                    ShowCurrentBranch = $ShowCurrentGitBranch.IsPresent
                    BranchColor = if ($GitBranchNameColor) {$GitBranchNameColor.ToString()} else {$null}
                }
                HostColors = [PSCustomObject]@{
                    BackgroundColor = if ($HostBackgroundColor) {$HostBackgroundColor.ToString()} else {$null}
                    ForegroundColor = if ($HostForegroundColor) {$HostForegroundColor.ToString()} else {$null}
                    ErrorBackgroundColor = if ($HostErrorBackgroundColor) {$HostErrorBackgroundColor.ToString()} else {$null}
                    ErrorForegroundColor = if ($HostErrorForegroundColor) {$HostErrorForegroundColor.ToString()} else {$null}
                    WarningBackgroundColor = if ($HostWarningBackgroundColor) {$HostWarningBackgroundColor.ToString()} else {$null}
                    WarningForegroundColor = if ($HostWarningForegroundColor) {$HostWarningForegroundColor.ToString()} else {$null}
                    DebugBackgroundColor = if ($HostDebugBackgroundColor) {$HostDebugBackgroundColor.ToString()} else {$null}
                    DebugForegroundColor = if ($HostDebugForegroundColor) {$HostDebugForegroundColor.ToString()} else {$null}
                    VerboseBackgroundColor = if ($HostVerboseBackgroundColor) {$HostVerboseBackgroundColor.ToString()} else {$null}
                    VerboseForegroundColor = if ($HostVerboseForegroundColor) {$HostVerboseForegroundColor.ToString()} else {$null}
                    ProgressBackgroundColor = if ($HostProgressBackgroundColor) {$HostProgressBackgroundColor.ToString()} else {$null}
                    ProgressForegroundColor = if ($HostProgressForegroundColor) {$HostProgressForegroundColor.ToString()} else {$null}
                }
            };
        }
        
        Write-Verbose "Start generating customized scripts for each of provided host locations.";
        foreach ($CurrentCustomizedHostFor in $CustomizedHostFor)
        {
            Write-Verbose "Getting destination script for $CurrentCustomizedHostFor.";
            switch ($CurrentCustomizedHostFor)
            {
                "CurrentUserAllHosts" {
                    $DestinationScript = $profile.CurrentUserAllHosts;
                } 
                "CurrentUserISEHost" {
                    if ($host.Name.Contains("ISE"))
                    {
                        $DestinationScript = $profile.CurrentUserCurrentHost;
                    }
                    else
                    {
                        Write-Warning "Cannot get destination script for customizing the ISE host. Destination script for ISE can be retrieved only from the ISE host.";

                        Break;
                    }
                } 
                "CurrentUserConsoleHost" {
                    $ProcessInfo = New-Object System.Diagnostics.ProcessStartInfo 
                    $ProcessInfo.FileName = "powershell.exe" 
                    $ProcessInfo.RedirectStandardError = $true 
                    $ProcessInfo.RedirectStandardOutput = $true
                    $ProcessInfo.UseShellExecute = $false 
                    $ProcessInfo.CreateNoWindow = $true
                    $ProcessInfo.Arguments = 'write-output $profile.CurrentUserCurrentHost' 
                    $Process = New-Object System.Diagnostics.Process 
                    $Process.StartInfo = $ProcessInfo 
                    $Process.Start() | Out-Null 
                    $Process.WaitForExit() 
                    $DestinationScript = $Process.StandardOutput.ReadToEnd().Trim() 
                } 
                "AllUsersAllHosts" {
                    $DestinationScript = $profile.AllUsersAllHosts;
                } 
                "AllUsersISEHost" {
                    if ($host.Name.Contains("ISE"))
                    {
                        $DestinationScript = $profile.AllUsersCurrentHost;
                    }
                    else
                    {
                        Write-Warning "Cannot get destination script for customizing the ISE host. Destination script for ISE can be retrieved only from the ISE host.";

                        Break;
                    }
                } 
                "AllUsersConsoleHost" {
                    $ProcessInfo = New-Object System.Diagnostics.ProcessStartInfo 
                    $ProcessInfo.FileName = "powershell.exe" 
                    $ProcessInfo.RedirectStandardError = $true 
                    $ProcessInfo.RedirectStandardOutput = $true
                    $ProcessInfo.UseShellExecute = $false 
                    $ProcessInfo.CreateNoWindow = $true
                    $ProcessInfo.Arguments = 'write-output $profile.AllUsersCurrentHost' 
                    $Process = New-Object System.Diagnostics.Process 
                    $Process.StartInfo = $ProcessInfo 
                    $Process.Start() | Out-Null 
                    $Process.WaitForExit() 
                    $DestinationScript = $Process.StandardOutput.ReadToEnd().Trim() 
                }
                Default {
                    throw [System.ArgumentOutOfRangeException]::new("CustomizedHostFor", "$CurrentCustomizedHostFor", "Provided value $host for parameter CustomizedHostFor is not supported.");
                }
            }

            if ($DestinationScript -eq '' -or $null -eq $DestinationScript)
            {
                Break;
            }
            
            Write-Verbose "Destination script for $CurrentCustomizedHostFor is $DestinationScript.";
            
            $DestinationDirectory = Split-Path -Path ($DestinationScript) -Parent;

            Write-Verbose "Destination directory for $CurrentCustomizedHostFor is $DestinationDirectory.";

            Write-Verbose "Copying customized host script to $DestinationScript.";
                    
            Copy-Item -Path $ScriptPath -Destination $DestinationScript -Recurse -Force

            $DestinationScriptFileName = Get-FileName -Path $DestinationScript;

            Write-Verbose "Generating host metadata file '$DestinationScriptFileName.metadata.json' for $DestinationScript.";

            New-Item -ItemType File -Path "$DestinationDirectory\$DestinationScriptFileName.metadata.json" -Force | Out-Null
            
            Write-Verbose "Writing host metadata file content for $DestinationScript.";

            Set-Content -Path "$DestinationDirectory\$DestinationScriptFileName.metadata.json" -Value (ConvertTo-Json $ProfileMetadata);

            Write-Verbose "Customization for $CurrentCustomizedHostFor is completed.";
        }
    }
    End
    {
    }
}

<#
.Synopsis
   Remove customized profile for PowerShell Hosts.
#>
function Remove-PSCustomizedHostProfile
{
    [CmdletBinding()]
    [Alias()]
    [OutputType([void])]
    Param
    (
        # Customize Host for.
        [Parameter(Mandatory=$true, 
                   ValueFromPipeline=$false,
                   ValueFromPipelineByPropertyName=$false, 
                   ValueFromRemainingArguments=$false, 
                   Position=0,
                   ParameterSetName='Customized Host For')]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [ValidateCount(0, 6)]
        [ValidateSet("CurrentUserAllHosts", "CurrentUserISEHost", "CurrentUserConsoleHost", "AllUsersAllHosts", "AllUsersISEHost", "AllUsersConsoleHost")]
        [Alias("HostFor")] 
        [string[]]
        $CustomizedHostFor
    )

    Begin
    {
    }
    Process
    {        
        Write-Verbose "Start removing customized scripts for each of provided host locations.";
        foreach ($CurrentCustomizedHostFor in $CustomizedHostFor)
        {
            Write-Verbose "Getting destination script for $CurrentCustomizedHostFor.";
            switch ($CurrentCustomizedHostFor)
            {
                "CurrentUserAllHosts" {
                    $DestinationScript = $profile.CurrentUserAllHosts;
                } 
                "CurrentUserISEHost" {
                    if ($host.Name.Contains("ISE"))
                    {
                        $DestinationScript = $profile.CurrentUserCurrentHost;
                    }
                    else
                    {
                        Write-Warning "Cannot get destination script for customizing the ISE host. Destination script for ISE can be retrieved only from the ISE host.";

                        Break;
                    }
                } 
                "CurrentUserConsoleHost" {
                    $ProcessInfo = New-Object System.Diagnostics.ProcessStartInfo 
                    $ProcessInfo.FileName = "powershell.exe" 
                    $ProcessInfo.RedirectStandardError = $true 
                    $ProcessInfo.RedirectStandardOutput = $true
                    $ProcessInfo.UseShellExecute = $false 
                    $ProcessInfo.CreateNoWindow = $true
                    $ProcessInfo.Arguments = 'write-output $profile.CurrentUserCurrentHost' 
                    $Process = New-Object System.Diagnostics.Process 
                    $Process.StartInfo = $ProcessInfo 
                    $Process.Start() | Out-Null 
                    $Process.WaitForExit() 
                    $DestinationScript = $Process.StandardOutput.ReadToEnd().Trim() 
                } 
                "AllUsersAllHosts" {
                    $DestinationScript = $profile.AllUsersAllHosts;
                } 
                "AllUsersISEHost" {
                    if ($host.Name.Contains("ISE"))
                    {
                        $DestinationScript = $profile.AllUsersCurrentHost;
                    }
                    else
                    {
                        Write-Warning "Cannot get destination script for customizing the ISE host. Destination script for ISE can be retrieved only from the ISE host.";

                        Break;
                    }
                } 
                "AllUsersConsoleHost" {
                    $ProcessInfo = New-Object System.Diagnostics.ProcessStartInfo 
                    $ProcessInfo.FileName = "powershell.exe" 
                    $ProcessInfo.RedirectStandardError = $true 
                    $ProcessInfo.RedirectStandardOutput = $true
                    $ProcessInfo.UseShellExecute = $false 
                    $ProcessInfo.CreateNoWindow = $true
                    $ProcessInfo.Arguments = 'write-output $profile.AllUsersCurrentHost' 
                    $Process = New-Object System.Diagnostics.Process 
                    $Process.StartInfo = $ProcessInfo 
                    $Process.Start() | Out-Null 
                    $Process.WaitForExit() 
                    $DestinationScript = $Process.StandardOutput.ReadToEnd().Trim() 
                }
                Default {
                    throw [System.ArgumentOutOfRangeException]::new("CustomizedHostFor", "$CurrentCustomizedHostFor", "Provided value $host for parameter CustomizedHostFor is not supported.");
                }
            }
            
            Write-Verbose "Destination script for $CurrentCustomizedHostFor is $DestinationScript.";
        
            Write-Verbose "Testing whether destination script $DestinationScript for host $CurrentCustomizedHostFor exists.";
            if ((Test-Path -Path "$DestinationScript"))
            {
                Remove-Item -Path $DestinationScript -Force;
            
                $DestinationDirectory = Split-Path -Path ($DestinationScript) -Parent;

                Write-Verbose "Destination directory for $CurrentCustomizedHostFor is $DestinationDirectory.";

                $DestinationScriptFileName = Get-FileName -Path $DestinationScript;

                Write-Verbose "Host metadata file for $DestinationScript is '$DestinationScriptFileName.metadata.json'.";

                if ((Test-Path -Path "$DestinationDirectory\$DestinationScriptFileName.metadata.json"))
                {
                    Remove-Item -Path "$DestinationDirectory\$DestinationScriptFileName.metadata.json" -Force;
                }

                Write-Verbose "Customization for $CurrentCustomizedHostFor is completed.";
            }
        }
    }
    End
    {
    }
}

<#
.Synopsis
   Getting file name from file path.
#>
function Get-FileName
{
    [CmdletBinding()]
    [Alias()]
    [OutputType([string])]
    Param
    (
        # Param1 help description
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [string]
        $Path
    )

    Begin
    {
    }
    Process
    {
        $FileNameParts = (Split-Path -Path ($Path) -Leaf).Split(".");
        $FileName = "";
        for ($i = 0; $i -lt $FileNameParts.Count - 1; $i++)
        { 
            if ($i -eq 0)
            {
                $FileName = $FileNameParts[$i];
            }
            else
            {
                $FileName = "$FileName.$($FileNameParts[$i])";
            }
        }

        return $FileName;
    }
    End
    {
    }
}

Export-ModuleMember -Function New-PSCustomizedHostProfile;
Export-ModuleMember -Function Remove-PSCustomizedHostProfile;
# SIG # Begin signature block
# MIIFaQYJKoZIhvcNAQcCoIIFWjCCBVYCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUt7fZ4CuqKIrJtHRQXUHJCG3e
# +6egggMMMIIDCDCCAfCgAwIBAgIQWdT/1OINnrNDRG1QR8IoNzANBgkqhkiG9w0B
# AQsFADASMRAwDgYDVQQDDAdQQy1BTEVLMB4XDTE5MDExOTE3MTMxM1oXDTIwMDEx
# OTE3MzMxM1owEjEQMA4GA1UEAwwHUEMtQUxFSzCCASIwDQYJKoZIhvcNAQEBBQAD
# ggEPADCCAQoCggEBAMohVYQRaEn0aAZQTyJOiqrx9+1/fWeDQQm1v6sdxYNaAh+A
# JWA4fRgots+6w5h38BLUaWhr88PfPGMYa/Xse+OQNQYmGLMMk3duy0qAsH76RtGd
# xRcAa+Baw9CvTyIXWIwXvO7sFeYTQrf1nvod26T477wlqVmXbacXYv+dXiGGJm8X
# XNJ4D9jhdunLHYEDM0cUj2HJa1q5ZGWk74kjHVL71swdCTnX+bshRIFH+QoQT4UU
# u23gWbArs01iPxXgSy3vxYqV+d8Mksvbu+5dXIzAjAw1J8cqyVjDHiNfG/J2OV6I
# nQHwNxbe0YwbtL971vYzERw8BeHUK5gmHw5OO3ECAwEAAaNaMFgwDgYDVR0PAQH/
# BAQDAgeAMBMGA1UdJQQMMAoGCCsGAQUFBwMDMBIGA1UdEQQLMAmCB1BDLUFMRUsw
# HQYDVR0OBBYEFFqzRr4jnfCDLs3IYWizYpBOCiUZMA0GCSqGSIb3DQEBCwUAA4IB
# AQBBXiNtWO+FjGs1ehsk81sVjRp2TLELsEQJt3qheprhSvX8mo4Wa/Ga0IIdOrAb
# snKUC/dL+S6rBvQadaMFudTFfH0hIf/NOoMbxPucchJHjE9T3tCrFjvt8eTbqa2G
# 7ZBzcKK37a/rnLiIX9K3Kfj2v438sqkmgjVpWsWejAUjzydI+2U0uW2B201qE8Uz
# p0lnbGO60x9ZwMSrNAY2tu2QTLCbku+crmXTRnqLDIeOhL8hhS/Sju6p78PLbWq6
# uGLAdSqp6Qi/rt4AeUtvLPDBCe07k0Q2tcfv9NC4QWaEKsNkuFdkT4P+zzcPgSmj
# 5UUTda7xxRJ05Sjv0F6Er9ycMYIBxzCCAcMCAQEwJjASMRAwDgYDVQQDDAdQQy1B
# TEVLAhBZ1P/U4g2es0NEbVBHwig3MAkGBSsOAwIaBQCgeDAYBgorBgEEAYI3AgEM
# MQowCKACgAChAoAAMBkGCSqGSIb3DQEJAzEMBgorBgEEAYI3AgEEMBwGCisGAQQB
# gjcCAQsxDjAMBgorBgEEAYI3AgEVMCMGCSqGSIb3DQEJBDEWBBTuNYN8if+zOGsA
# mwZxvO3QzwyCbjANBgkqhkiG9w0BAQEFAASCAQAwUMJCFMYfZhnIt5Zbq50Mn/Kv
# qwAO7slcTLCoDHfPtm9MVkDD/ES2LrKJDq9hFNvWC0v+5kYd/TV/2/E9X+JEfChK
# 2vZqBSqUbEtZDRAz9HGB2gfLTscjzUzSobBIF+ai7ahW3srXyoWKzYt5vMc+CrnG
# MDf7gwPoHefICk3VjLRQcqBr0/wuk4davlLQh+aiLCm+Yw6MGpyjI4YfNmMAc4t+
# wwTmvZsp1AOHOqnXfoSoAz4AION+ck/9dKaAk99YDCZUP2nmG0Tk5xgNzbhG3MKP
# xmDcruVQD9bUoN8hKppYVTV3vuFTyBIOwa/6i09tPukhsZx/d22o1AdFWvWG
# SIG # End signature block
