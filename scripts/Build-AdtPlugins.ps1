<#
.SYNOPSIS
    Runs MVN INSTALL on paths contained in a text file
#>
param(
    # Path to JSON file with names to git repositories
    [Parameter(Mandatory = $true)]
    [string]$RepoListPath,
    # Base path to repositories
    [Parameter(Mandatory = $true)]
    [string]$ReposBasePath,
    # Flag to indicate only sequential execution of maven
    [Parameter()]
    [switch]$DisableParallel
)

# F U N C T I O N S
# ===============================================================
Function mvnInstall([string]$RepoPath) {
    if (!(Test-Path $RepoPath)) {
        Write-Error "Path $RepoPath is not valid"
        return
    }

    Set-Location $RepoPath

    Write-Host "Running 'mvn install' for Repository $(Split-Path -Leaf $RepoPath)"
    mvn clean install -q
    Write-Host -ForegroundColor Green "Finished 'mvn install' for Repository $(Split-Path -Leaf $RepoPath)"
}

Function runSerialRepos() {
     ($reposDetails | % {
        if (!$_.parallel -or $DisableParallel) {
            ($_.repos | % {
                mvnInstall -RepoPath "$ReposBasePath\$_"
            })
        }
    })
}

Function runParallelRepos() {
    $JobBlock = {
        param($RepoPath)
        if (!(Test-Path $RepoPath)) {
            Write-Error "Path $RepoPath is not valid"
            return
        }

        Set-Location $RepoPath

        Write-Host "Running 'mvn install' for Repository $(Split-Path -Leaf $RepoPath)"
        mvn clean install -q
        Write-Host -ForegroundColor Green "Finished 'mvn install' for Repository $(Split-Path -Leaf $RepoPath)"
    }
    $jobs = @()
    ($reposDetails | % {
        if ($_.parallel) {
            ($_.repos | % {
                $jobName = "mvn_install_$($_)"
                Start-Job -ScriptBlock $JobBlock -ArgumentList "$ReposBasePath\$_" -Name $jobName
                $jobs += $jobName
            })
        }
    })

    Receive-Job -Name $jobs -Wait -AutoRemoveJob
}
# ==============================================================

# Script Start
if (!(Test-Path $RepoListPath)) {
    Write-Error "RepoListPath does not point to a valid text file"
    return
}

if (!(Test-Path $ReposBasePath)) {
    Write-Error "ReposBasePath is not a valid path"
}

$ReposBasePath = (Resolve-Path $ReposBasePath)
$startDir = Get-Location
$reposDetails = (Get-Content $RepoListPath | ConvertFrom-Json)

Write-Host "1) Install repos without dependencies"
runSerialRepos
if (!$DisableParallel) {
    Write-Host "2) Install repos with dependencies"
    runParallelRepos
}

Set-Location $startDir




