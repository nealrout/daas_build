# God awful script to not copy the contents in excludedDirs
param (
    [string]$SourceDir,
    [string]$DestDir
)

$excludeDirs = @("__pycache__", ".git", "build", "dist")

function Copy-Directory {
    param (
        [string]$Source,
        [string]$Destination
    )

    if (-not (Test-Path $Destination)) {
        New-Item -ItemType Directory -Path $Destination
    }

    Get-ChildItem -Path $Source -Recurse | ForEach-Object {
        $relativePath = (Resolve-PathRelative -Base $Source -Path $_.FullName)
        $exclude = $false

        foreach ($excludeDir in $excludeDirs) {
            if ($relativePath -like "*$excludeDir*") {
                $exclude = $true
                break
            }
        }

        if (-not $exclude) {
            $destPath = Join-Path $Destination -ChildPath $relativePath
            if ($_.PSIsContainer) {
                Copy-Directory -Source $_.FullName -Destination $destPath
            } else {
                Copy-Item -Path $_.FullName -Destination $destPath
            }
        }
    }
}

function Resolve-PathRelative {
    param (
        [string]$Base,
        [string]$Path
    )

    $baseUri = [System.Uri]("$Base/")
    $pathUri = [System.Uri]($Path)
    return $baseUri.MakeRelativeUri($pathUri).ToString()
}

Copy-Directory -Source $SourceDir -Destination $DestDir
