param(
    [switch]$changedLast24Hours
)

$logPath = Join-Path -Path $PSScriptRoot -ChildPath "build-all-profiles.log"
Start-Transcript -Path $logPath -Force

try {
    # Find the path to openscad.exe
    $openSCADPath = Get-ChildItem -Path "C:\Program Files\" -Recurse -Filter "openscad.com" -ErrorAction SilentlyContinue -Force | Sort-Object LastWriteTime -Descending | Select-Object -First 1 -ExpandProperty FullName

    if (-not $openSCADPath) {
        Write-Host "openscad.exe not found. Please ensure OpenSCAD is installed and the path is correct."
        return
    }
    else {
        Write-Host "Found OpenSCAD at: $openSCADPath"
    }

    # Find all *.scad files in the current directory that also have a corresponding *.json file
    $cutoffTime = (Get-Date).AddHours(-24)

    if ($changedLast24Hours) {
        Write-Host "Filtering to SCAD/JSON pairs changed since: $cutoffTime"
    }

    $scadFiles = Get-ChildItem -Path (Get-Location) -Filter "*.scad" -Recurse | Where-Object {
        $jsonFile = Join-Path -Path $_.Directory.FullName -ChildPath "$($_.BaseName).json"

        if (-not (Test-Path $jsonFile)) {
            return $false
        }

        if (-not $changedLast24Hours) {
            return $true
        }

        ($_.LastWriteTime -ge $cutoffTime) -or ((Get-Item -Path $jsonFile).LastWriteTime -ge $cutoffTime)
    }

    if (-not $scadFiles) {
        Write-Host "No matching *.scad files with corresponding *.json files found."
        return
    }
    else {
        Write-Host "Found matching *.scad files:"
        $scadFiles | ForEach-Object { Write-Host $_.FullName }
    }

    # Loop through each *.scad file and process its corresponding *.json file
    $scadFiles | ForEach-Object {
        $scadFile = $_.FullName
        $jsonFile = Join-Path -Path $_.Directory.FullName -ChildPath "$($_.BaseName).json"

        # Read the JSON file
        try {
            $jsonContent = Get-Content -LiteralPath $jsonFile -Raw | ConvertFrom-Json -ErrorAction Stop
        }
        catch {
            Write-Host "ERROR: Failed to parse $jsonFile - $($_.Exception.Message). Skipping..."
            return
        }
        $parameterSets = $jsonContent.parameterSets

        if (-not $parameterSets) {
            Write-Host "No parameter sets found in $jsonFile. Skipping..."
            return
        }

        # Loop through each parameter set
        foreach ($presetName in $parameterSets.PSObject.Properties.Name) {
            # Skip parameter sets containing "design default values"
            if ($presetName -like "*design default values*") {
                Write-Host "Skipping preset '$presetName' (contains design default values)."
                continue
            }

            # Construct the output STL file name
            ##$currentDate = Get-Date -Format "yyyyMMdd"
            ##$stlFileName = "${currentDate}_$($_.BaseName)_${presetName}.stl"
            # # $stlFileName = "$($_.BaseName)_${presetName}.stl"
            # # $stlFilePath = Join-Path -Path $_.Directory.FullName -ChildPath $stlFileName

            # # # Call OpenSCAD to generate the STL file
            # # Write-Host "Generating STL for preset '$presetName'..."

            # # $stlArgumentsList = @(
            # #     ($openSCADPath -replace ' ', '` '),
            # #     "-o", ($stlFilePath -replace ' ', '` ' -replace '&', '-' -replace '%', '-' -replace ',', ''),
            # #     "-p", ($jsonFile -replace ' ', '` '),
            # #     "-P", ($presetName -replace ' ', '` '),
            # #     $scadFile
            # # )
            # # Start-Process -FilePath powershell.exe -ArgumentList $stlArgumentsList -NoNewWindow -Wait

            # # Write-Host "STL file generated: $stlFileName"

            $outputFolder = Join-Path -Path $_.Directory.FullName -ChildPath "output"
            New-Item -Path $outputFolder -ItemType Directory -Force | Out-Null

            # Call OpenSCAD to generate the 3MF file
            Write-Host "Generating 3MF for preset '$presetName'..."
            $3mfFileName = "$($_.BaseName)_${presetName}.3mf"
            $3mfFilePath = Join-Path -Path $outputFolder -ChildPath $3mfFileName

            $openSCADArguments = @(
                "-o", $3mfFilePath,
                "-p", $jsonFile,
                "-P", $presetName,
                "--enable", "textmetrics",
                $scadFile
            )
            & $openSCADPath @openSCADArguments 2>&1 | ForEach-Object { Write-Host $_ }

            Write-Host "3MF file generated: $3mfFileName"

            # Call OpenSCAD to generate the PNG file
            Write-Host "Generating PNG for preset '$presetName'..."
            $pngFileName = "$($_.BaseName)_${presetName}.png"
            $pngFilePath = Join-Path -Path $outputFolder -ChildPath $pngFileName

            $openSCADArguments = @(
                "-o", $pngFilePath,
                "-p", $jsonFile,
                "-P", $presetName,
                "--enable", "textmetrics",
                $scadFile
            )
            & $openSCADPath @openSCADArguments 2>&1 | ForEach-Object { Write-Host $_ }

            Write-Host "PNG file generated: $pngFileName"
            Write-Host ""
        }
    }
}
finally {
    Stop-Transcript
}