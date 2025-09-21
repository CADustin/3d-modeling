# Find the path to openscad.exe
$openSCADPath = Get-ChildItem -Path "C:\Program Files\" -Recurse -Filter "openscad.com" -ErrorAction SilentlyContinue -Force | Select-Object -First 1 -ExpandProperty FullName

if (-not $openSCADPath) {
    Write-Host "openscad.exe not found. Please ensure OpenSCAD is installed and the path is correct."
    exit
}
else {
    Write-Host "Found OpenSCAD at: $openSCADPath"
}

# Find all *.scad files in the current directory that also have a corresponding *.json file
$scadFiles = Get-ChildItem -Path (Get-Location) -Filter "*.scad" -Recurse | Where-Object {
    $jsonFile = Join-Path -Path $_.Directory.FullName -ChildPath "$($_.BaseName).json"
    Test-Path $jsonFile
}

if (-not $scadFiles) {
    Write-Host "No matching *.scad files with corresponding *.json files found."
    exit
}
else {
    Write-Host "Found matching *.scad files:"
    $scadFiles | ForEach-Object { Write-Host $_.FullName }
}

# Record the start time of the entire script
$scriptStartTime = Get-Date

# Initialize a list to store summary information
$summary = @()

# Loop through each *.scad file and process its corresponding *.json file
$scadFiles | ForEach-Object {
    $scadFile = $_.FullName
    $jsonFile = Join-Path -Path $_.Directory.FullName -ChildPath "$($_.BaseName).json"

    # Output the name of the *.scad file being processed
    Write-Host "Processing SCAD file: $scadFile"

    # Read the JSON file
    $jsonContent = Get-Content -Path $jsonFile -Raw | ConvertFrom-Json
    $parameterSets = $jsonContent.parameterSets

    if (-not $parameterSets) {
        Write-Host "No parameter sets found in $jsonFile. Skipping..."
        return
    }

    # Loop through each parameter set
    foreach ($presetName in $parameterSets.PSObject.Properties.Name) {
        $presetValues = $parameterSets.$presetName

        # Skip parameter sets containing "design default values"
        if ($presetName -like "*design default values*") {
            Write-Host "Skipping preset '$presetName' (contains design default values)."
            continue
        }

        # Construct the -D arguments for all variables in the preset
        $dynamicArguments = ($presetValues.PSObject.Properties | ForEach-Object {
            if ($_.Value -ne "") {
                "-D '$($_.Name)=`"$($presetValues.$($_.Name))`"'"
            }
        }) -join " "

        # Construct the output STL file name
        $currentDate = Get-Date -Format "yyyyMMdd"
        $stlFileName = "${currentDate}_$($_.BaseName)_${presetName}.stl"
        $stlFilePath = Join-Path -Path $_.Directory.FullName -ChildPath $stlFileName

        # Measure the time taken to generate the STL file
        $startTime = Get-Date

        # Call OpenSCAD to generate the STL file
        Write-Host "Generating STL for preset '$presetName'..."

        # Debugging output
        Write-Host "Dynamic Arguments: $dynamicArguments"

        $openSCADPathClean = $openSCADPath -replace ' ', '` '
        $argList = @(
            ("&`"$openSCADPathClean`""), 
            "-o $stlFilePath",
             $dynamicArguments,
             $scadFile);
        Start-Process  -FilePath powershell.exe -ArgumentList $argList -NoNewWindow -Wait

        $endTime = Get-Date
        $duration = ($endTime - $startTime).TotalSeconds

        Write-Host "STL file generated: $stlFilePath in $duration seconds"
        Write-Host ""

        # Add to summary
        $summary += [PSCustomObject]@{
            PresetName = $presetName
            FilePath = $stlFilePath
            DurationSeconds = [math]::Round($duration, 2)
        }
    }
}

# Record the end time of the entire script
$scriptEndTime = Get-Date
$totalExecutionTime = ($scriptEndTime - $scriptStartTime).TotalSeconds

# Output the summary
Write-Host "Summary of Generated Files:"
$summary | ForEach-Object {
    Write-Host "Preset: $($_.PresetName), File: $($_.FilePath), Time: $($_.DurationSeconds) seconds"
}

# Output the total execution time in minutes
$totalExecutionTimeMinutes = ($totalExecutionTime / 60)
Write-Host "Total Execution Time: $([math]::Round($totalExecutionTimeMinutes, 2)) minutes"

