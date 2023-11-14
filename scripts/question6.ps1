function Get-Folder {
    param([String]$relativePath = "")
    return (Join-Path -Path $PSScriptRoot -ChildPath $relativePath)
}

$folder = Get-Folder -relativePath "../files-to-sort"
$destination = Get-Folder -relativePath "../sorted-files"

$files = Get-ChildItem -Path $folder -File

foreach ($file in $files) {
    $fileExtension = $file.Extension
    if (-not (Test-Path -Path "$destination\$fileExtension")) {
        New-Item -Path "$destination\$fileExtension" -ItemType Directory
    }
    Copy-Item -Path $file.FullName -Destination "$destination\$fileExtension"
}

Write-Host "Copie terminee."
