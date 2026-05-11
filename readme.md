# Rebuilding OpenSCAD Files

This repository includes a simplified build script that finds all `.scad` files with matching `.json` files and builds each profile.

## Script

- `build-all-profiles-simplified.ps1`

## What It Builds

For each matching SCAD/JSON pair, the script:

- Reads `parameterSets` from the JSON file
- Skips presets containing `design default values`
- Generates a `.3mf` file in an `output` folder next to the source file
- Generates a `.png` preview in that same `output` folder

## Prerequisites

- Windows PowerShell
- OpenSCAD installed (the script auto-detects `openscad.com` under `C:\Program Files`)

## Run From Repo Root

Open PowerShell in the repository root and run:

```powershell
.\build-all-profiles-simplified.ps1
```

## Optional: Build Only Recently Changed Files

To only build SCAD/JSON pairs changed in the last 24 hours:

```powershell
.\build-all-profiles-simplified.ps1 -changedLast24Hours
```

The 24-hour filter checks both the `.scad` file and its matching `.json` file.
