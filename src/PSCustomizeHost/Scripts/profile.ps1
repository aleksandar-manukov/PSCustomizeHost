function Get-FileName ($Path)
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
};

$ProfileMetadata = New-Object -TypeName PSObject;

if ($PSScriptRoot -eq $null -or $PSScriptRoot -eq "")
{
    $ScriptPath = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath(".\");
}
else
{
    $ScriptPath = $PSScriptRoot;
}

$ScriptName = Get-FileName $MyInvocation.MyCommand.Name;

if (Test-Path -Path "$ScriptPath\$ScriptName.metadata.json")
{
    $ProfileMetadata = Get-Content -Path "$ScriptPath\$ScriptName.metadata.json" | ConvertFrom-Json;
}

$CurrentLocation = Get-Location

if ("DefaultLocation" -in $ProfileMetadata.PSObject.Properties.Name -and
    $ProfileMetadata.DefaultLocation -and
    $ProfileMetadata.DefaultLocation -ne "" -and
    $CurrentLocation.Path -eq $HOME)
{
    Set-Location $ProfileMetadata.DefaultLocation;
}

function Prompt {
    $Directory = Split-Path -Path (Get-Location) -Leaf;
    if ("GitMetadata" -in $ProfileMetadata.PSObject.Properties.Name -and 
        "ShowCurrentBranch" -in $ProfileMetadata.GitMetadata.PSObject.Properties.Name -and 
        $ProfileMetadata.GitMetadata.ShowCurrentBranch)
    {
        $BranchName = git rev-parse --abbrev-ref HEAD;

        if ($BranchName -ne '' -and $null -ne $BranchName)
        {
            Write-Host -NoNewline "(";

            if ("BranchColor" -in $ProfileMetadata.GitMetadata.PSObject.Properties.Name -and 
                $ProfileMetadata.GitMetadata.BranchColor)
            {
                Write-Host -NoNewline "$BranchName" -ForegroundColor $ProfileMetadata.GitMetadata.BranchColor;
            }
            else
            {
                Write-Host -NoNewline "$BranchName";
            }
        
            Write-Host -NoNewline ") ";
        }
    }
    
    Write-Host -NoNewline "$Directory >";

    return " ";
}

if ("HostColors" -in $ProfileMetadata.PSObject.Properties.Name -and
    $ProfileMetadata.HostColors)
{
    function Update-ConsoleColors {
        if ("ForegroundColor" -in $ProfileMetadata.HostColors.PSObject.Properties.Name -and
            $ProfileMetadata.HostColors.ForegroundColor)
        {
            $Host.UI.RawUI.ForegroundColor = $ProfileMetadata.HostColors.ForegroundColor;
        }

        if ("BackgroundColor" -in $ProfileMetadata.HostColors.PSObject.Properties.Name -and
            $ProfileMetadata.HostColors.BackgroundColor)
        {
            $Host.UI.RawUI.BackgroundColor = $ProfileMetadata.HostColors.BackgroundColor;
        }
        
        if ("ErrorForegroundColor" -in $ProfileMetadata.HostColors.PSObject.Properties.Name -and
            $ProfileMetadata.HostColors.ErrorForegroundColor)
        {
            $Host.PrivateData.ErrorForegroundColor = $ProfileMetadata.HostColors.ErrorForegroundColor;
        }
        
        if ("ErrorBackgroundColor" -in $ProfileMetadata.HostColors.PSObject.Properties.Name -and
            $ProfileMetadata.HostColors.ErrorBackgroundColor)
        {
            $Host.PrivateData.ErrorBackgroundColor = $ProfileMetadata.HostColors.ErrorBackgroundColor;
        }
        
        if ("WarningForegroundColor" -in $ProfileMetadata.HostColors.PSObject.Properties.Name -and
            $ProfileMetadata.HostColors.WarningForegroundColor)
        {
            $Host.PrivateData.WarningForegroundColor = $ProfileMetadata.HostColors.WarningForegroundColor;
        }
        
        if ("WarningBackgroundColor" -in $ProfileMetadata.HostColors.PSObject.Properties.Name -and
            $ProfileMetadata.HostColors.WarningBackgroundColor)
        {
            $Host.PrivateData.WarningBackgroundColor = $ProfileMetadata.HostColors.WarningBackgroundColor;
        }
        
        if ("DebugForegroundColor" -in $ProfileMetadata.HostColors.PSObject.Properties.Name -and
            $ProfileMetadata.HostColors.DebugForegroundColor)
        {
            $Host.PrivateData.DebugForegroundColor = $ProfileMetadata.HostColors.DebugForegroundColor;
        }
        
        if ("DebugBackgroundColor" -in $ProfileMetadata.HostColors.PSObject.Properties.Name -and
            $ProfileMetadata.HostColors.DebugBackgroundColor)
        {
            $Host.PrivateData.DebugBackgroundColor = $ProfileMetadata.HostColors.DebugBackgroundColor;
        }
        
        if ("VerboseForegroundColor" -in $ProfileMetadata.HostColors.PSObject.Properties.Name -and
            $ProfileMetadata.HostColors.VerboseForegroundColor)
        {
            $Host.PrivateData.VerboseForegroundColor = $ProfileMetadata.HostColors.VerboseForegroundColor;
        }
        
        if ("VerboseBackgroundColor" -in $ProfileMetadata.HostColors.PSObject.Properties.Name -and
            $ProfileMetadata.HostColors.VerboseBackgroundColor)
        {
            $Host.PrivateData.VerboseBackgroundColor = $ProfileMetadata.HostColors.VerboseBackgroundColor;
        }
        
        if ("ProgressForegroundColor" -in $ProfileMetadata.HostColors.PSObject.Properties.Name -and
            $ProfileMetadata.HostColors.ProgressForegroundColor)
        {
            $Host.PrivateData.ProgressForegroundColor = $ProfileMetadata.HostColors.ProgressForegroundColor;
        }
        
        if ("ProgressBackgroundColor" -in $ProfileMetadata.HostColors.PSObject.Properties.Name -and
            $ProfileMetadata.HostColors.ProgressBackgroundColor)
        {
            $Host.PrivateData.ProgressBackgroundColor = $ProfileMetadata.HostColors.ProgressBackgroundColor;
        }

        Clear-Host;
    };

    Update-ConsoleColors;
}
else
{
    [Console]::ResetColor();
}

# SIG # Begin signature block
# MIIFawYJKoZIhvcNAQcCoIIFXDCCBVgCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUdaHGW7ReQYSdTj1UNUF3FvUt
# Q1ugggMOMIIDCjCCAfKgAwIBAgIQSPkvzo6cXZ5LP6rP8LKNajANBgkqhkiG9w0B
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
# BAGCNwIBCzEOMAwGCisGAQQBgjcCARUwIwYJKoZIhvcNAQkEMRYEFIXdk9qC/JIK
# Bo6z2CgDdGDk1HbCMA0GCSqGSIb3DQEBAQUABIIBABrZVPrJkrWqh16NfDD53jXV
# AdRcmRQ7oDz8V+i3b/zgI5X51D4OWiKSK6uol4ksduV48GlQrDtXrpwkXgBxPHe8
# v0jdG/W4QQ2uCyKyYddis08tP+bqw7wUjHddCJke8nUPNxnhzJiphIhFnmpm9Rzp
# pIMnR3gQf6kwx5ze51MnZvt3PTxC3g3oxResPp8HRYiiMmKEwA+hexNusDF/pxrk
# aEyamnfWPtMupuDnvoPyG6QltqG+0sh8gWXN/92ts+HpSY8UDH76X9JUJnDtgDt+
# nqdG6gDAnCNgvzIIAo8m7zsLFu4FEJv4zTvT3hK7GFUyhw5AoyXpIW2lMk+vzpY=
# SIG # End signature block
