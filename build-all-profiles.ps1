# Define the folder containing the OpenSCAD files (current directory)
$folderPath = Split-Path -Path $PSCommandPath

# Get the current date
$currentDate = Get-Date -Format "yyyyMMdd"

# Find the path to openscad.exe
$openSCADPath = Get-ChildItem -Path "C:\Program Files\OpenSCAD" -Recurse -Filter "openscad.exe" -ErrorAction SilentlyContinue -Force | Select-Object -First 1 -ExpandProperty FullName

if (-not $openSCADPath) {
    Write-Host "openscad.exe not found. Please ensure OpenSCAD is installed and the path is correct."
    exit
}
else {
    Write-Host "Found OpenSCAD at: $openSCADPath"
}

# Loop through each OpenSCAD file in the folder
Get-ChildItem -Path $folderPath -Filter "*.scad" -Recurse | ForEach-Object {
    $openSCADFile = $_.FullName
    Write-Host "Processing: $openSCADFile"

    $fileNameWithoutExtension = [System.IO.Path]::GetFileNameWithoutExtension($_.FullName)

    # Look for the corresponding JSON file for presets
    $jsonFilePath = Join-Path -Path $_.Directory.FullName -ChildPath "$fileNameWithoutExtension.json"
    if (-not (Test-Path $jsonFilePath)) {
        Write-Host "No preset JSON file found for $openSCADFile. Skipping..."
        return
    }

    # Parse the JSON file to get the parameter sets
    $jsonContent = Get-Content -Path $jsonFilePath -Raw | ConvertFrom-Json
    $parameterSets = $jsonContent.parameterSets

    if (-not $parameterSets) {
        Write-Host "No parameter sets found in $jsonFilePath. Skipping..."
        return
    }

    # Loop through each parameter set and generate the STL file
    foreach ($presetName in $parameterSets.PSObject.Properties.Name) {
        $presetValues = $parameterSets.$presetName

        # Construct the -D arguments for all variables in the preset
        $dynamicArguments = ($presetValues.PSObject.Properties | ForEach-Object {
            "-D $($_.Name)=$($presetValues.$($_.Name))"
        }) -join " "

        Write-Host "Dynamic Arguments: $dynamicArguments"

        $stlFileName = "${currentDate}_${fileNameWithoutExtension}_${presetName}.stl"
        $stlFilePath = Join-Path -Path $folderPath -ChildPath $stlFileName

        # Generate the STL file using OpenSCAD
        Write-Host "Exporting preset '$presetName' to $stlFilePath"
        $scadArgs = @('-o', $stlFilePath) + $dynamicArguments.Split(' ') + $openSCADFile
        & $openSCADPath @scadArgs
    }
}