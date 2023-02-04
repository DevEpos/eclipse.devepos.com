<#
.SYNOPSIS
    Clears m2 artifacts for Namespace com.devepos
#>

$m2DeveposFolder = "~/.m2/repository/com/devepos"
if (!(Test-Path $m2DeveposFolder)) {
    Write-Host -ForegroundColor Yellow "Directory $m2DeveposFolder" does not exist
    return
}

Write-Host "Deleting Directory $m2DeveposFolder"

rm -Force -Recurse -Path $m2DeveposFolder

if (!(Test-Path $m2DeveposFolder)) {
    Write-Host -ForegroundColor Green "Directory $m2DeveposFolder deleted"
}
