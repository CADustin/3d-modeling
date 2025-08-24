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

# Loop through each OpenSCAD file in the folder
Get-ChildItem -Path $folderPath -Filter "*.scad" | ForEach-Object {
    $openSCADFile = $_.FullName

    $fileNameWithoutExtension = [System.IO.Path]::GetFileNameWithoutExtension($_.Name)

    # Get the list of presets
    $presets = & $openSCADPath -o null -D 'echo(allPresets());' $openSCADFile

    # Loop through each preset and generate the STL file
    $presets -split ',' | ForEach-Object {
        $preset = $_.Trim()
        $stlFileName = "$currentDate`_$fileNameWithoutExtension`_$preset.stl"
        $stlFilePath = Join-Path -Path $folderPath -ChildPath $stlFileName

        # Generate the STL file using OpenSCAD
        & $openSCADPath -o $stlFilePath -D "preset=$preset" $openSCADFile
    }
}