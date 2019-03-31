﻿function Get-FileName ($Path)
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

if ("DefaultLocation" -in $ProfileMetadata.PSObject.Properties.Name -and
    $ProfileMetadata.DefaultLocation -and
    $ProfileMetadata.DefaultLocation -ne "")
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
# MIIFaQYJKoZIhvcNAQcCoIIFWjCCBVYCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUpE04DkgopPoXHRzkHuxR0scf
# dzKgggMMMIIDCDCCAfCgAwIBAgIQWdT/1OINnrNDRG1QR8IoNzANBgkqhkiG9w0B
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
# gjcCAQsxDjAMBgorBgEEAYI3AgEVMCMGCSqGSIb3DQEJBDEWBBR4nQoDiwxWlAdY
# ropjKRNZ2nyy9TANBgkqhkiG9w0BAQEFAASCAQA5Rekhl5q7MYSOK9g6Z41u2nyd
# YsifJ/MfT1Wj3I0ZBAPkLOiLkLLfg6BMN0M5CKi++xtPATsTrmr7M/HxzdpMNGv9
# 763NyCSAVEDPTA3QTfsrjZaPSX6nSZSjaeLITsY205ALPn6sJjyAsTwzqnrN3ikF
# oHdXqIRaoqJZeRlfmUwcRro+7FodmuZ4Wo4Cfn19oUStKDcKbzF1d97+PDGnT0V7
# 7djjK8gyhvCpEDr8cY9N0f/xy5pAjDBtCCpT02CmoKD0n5BK2OyDPkrJPmUzDYnd
# KrPELXyn2T1sc4VwjsEk0M9cy8grvELA8bRUBs8TvsOrzGL7a7wcV48VtZNH
# SIG # End signature block
