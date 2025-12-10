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

# Loop through each *.scad file and process its corresponding *.json file
$scadFiles | ForEach-Object {
    $scadFile = $_.FullName
    $jsonFile = Join-Path -Path $_.Directory.FullName -ChildPath "$($_.BaseName).json"

    # Read the JSON file
    $jsonContent = Get-Content -Path $jsonFile -Raw | ConvertFrom-Json
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

        $3mfArgumentsList = @(
            ($openSCADPath -replace ' ', '` '),
            "-o", ($3mfFilePath -replace ' ', '` ' -replace '&', '-' -replace '%', '-' -replace ',', ''),
			
            "-p", ($jsonFile -replace ' ', '` '),
            "-P", ($presetName -replace ' ', '` '),
            $scadFile
        )
        Start-Process -FilePath powershell.exe -ArgumentList $3mfArgumentsList -NoNewWindow -Wait

        Write-Host "3MF file generated: $3mfFileName"
		
		# Call OpenSCAD to generate the PNG file
		Write-Host "Generating PNG for preset '$presetName'..."
		$pngFileName = "$($_.BaseName)_${presetName}.png"
        $pngFilePath = Join-Path -Path $outputFolder -ChildPath $pngFileName
		
        $pngArgumentsList = @(
            ($openSCADPath -replace ' ', '` '),
            "-o", ($pngFilePath -replace ' ', '` ' -replace '&', '-' -replace '%', '-' -replace ',', ''),
            "-p", ($jsonFile -replace ' ', '` '),
            "-P", ($presetName -replace ' ', '` '),
            $scadFile
        )
        Start-Process -FilePath powershell.exe -ArgumentList $pngArgumentsList -NoNewWindow -Wait

        Write-Host "PNG file generated: $pngFileName"
        Write-Host ""
    }
}