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
# MIIFawYJKoZIhvcNAQcCoIIFXDCCBVgCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUt7fZ4CuqKIrJtHRQXUHJCG3e
# +6egggMOMIIDCjCCAfKgAwIBAgIQSPkvzo6cXZ5LP6rP8LKNajANBgkqhkiG9w0B
# AQsFADASMRAwDgYDVQQDDAdQQy1BTEVLMCAXDTIwMDIwODE1NTQyOFoYDzIxMjAw
# MjA4MTYwNDI4WjASMRAwDgYDVQQDDAdQQy1BTEVLMIIBIjANBgkqhkiG9w0BAQEF
# AAOCAQ8AMIIBCgKCAQEA3lm+L8sf4y7cmYaY3qfPnucv1TtAn4sz5DZAFZw9j2l1
# +i7Qh3Zc6bRQI6hy7LNblwp7dM1FEq7ZXnRLgsIBEVyqguUY/eiL2n+8mb23gxr3
# +g4VbaZImol+6N0ahnBFFVdqIM+5TCLN0xQo6JW03ECt9qDcbI+uBIe6rY6EX/HI
# BDAMjKbQiWxf7wHugPpxrsPYIsAeK7BjSoOLfHCfU6+iUDj2N9MEtW+j+0jL0nKJ
# vcHBmSTkG5GOj6tGSqjGidde12cWYcHRiarfhqLos+EpjPBJ5lPD6ZGx8NVIauAO
# p+jfQxPPqZrYG82OR1LfFoIDXpOTLqbjOdXaus7PDQIDAQABo1owWDAOBgNVHQ8B
# Af8EBAMCB4AwEwYDVR0lBAwwCgYIKwYBBQUHAwMwEgYDVR0RBAswCYIHUEMtQUxF
# SzAdBgNVHQ4EFgQUCCu1qzlHweiw0U0e/MdxsXbPo70wDQYJKoZIhvcNAQELBQAD
# ggEBAIe5cRpif3tpaCC2AJ7SmyoAdEy4o5yuEgz9qhnZ/W5IxyksYeY9MaCjVr2G
# KGuWhClZ4iECGGp2HPpmVfRGiHI8cmZOmlHd8hN1rduUjJ5XkZBL4CMN7mn5k/0U
# S1Nx1h3W5Nh9twedbjj/nBKvhbDng8k2BDkhWSA47vVCzPxMd/jy5STcKhCt5krF
# cXHKEOoZ2tXYnX4T+XQCsvhSYUXQUHAKIUU9p7jKYMhsDBHuqiOy6NLvmGeMNazR
# eD9RVfZYkfQvCjHayHm0ecWRUsWaKyhQH8vRG61AeZ+4r+er7q+L3tfTpC2sKxai
# o7Jyu488vBVtATUZ9TneSaYcAloxggHHMIIBwwIBATAmMBIxEDAOBgNVBAMMB1BD
# LUFMRUsCEEj5L86OnF2eSz+qz/CyjWowCQYFKw4DAhoFAKB4MBgGCisGAQQBgjcC
# AQwxCjAIoAKAAKECgAAwGQYJKoZIhvcNAQkDMQwGCisGAQQBgjcCAQQwHAYKKwYB
# BAGCNwIBCzEOMAwGCisGAQQBgjcCARUwIwYJKoZIhvcNAQkEMRYEFO41g3yJ/7M4
# awCbBnG87dDPDIJuMA0GCSqGSIb3DQEBAQUABIIBAHlE5QWTmXwfOvZN2iBBoaC1
# MQT4lm/85kpXWMhbxbSU+S9SJpHoAhKYRzcA1GqgL9C8ptQvUtk5gjh679siCUU3
# PKhf0p925QZFpcqa/ZDxt4jc5jOvBT8U5o4vDqJcpuBkPJ9Dk53XdVHjeScl4Vjz
# 3tVJXgDcO2qp6b289qXFfGQ2TEQlNIaw5qvPtEWT+s5y2LY2OFssVaX5KCMXIbu4
# 9cgYSF1VA/rrBSV5x6ttjWO1FH+dqhq9n58IelyDFSyoYKQmh5ZeGGDvHHji+y8d
# Igk9XoHa1xgJasffYKNUS71JMJ33XTrjEQsNG9socnaVs/f1ew2o0S9Y9d6cSLc=
# SIG # End signature block
