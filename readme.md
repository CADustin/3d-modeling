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

## Future Automation Ideas

Here are some practical automation ideas to evolve this workflow over time.

### 1) OpenSCAD -> Color-Aware 3MF Post-Processor

Create a script that runs after OpenSCAD export and updates `.3mf` internals:

- Unzip `.3mf` package
- Read and update `3D/3dmodel.model`
- Add or normalize `basematerials` entries and `displaycolor` values
- Assign object-level or triangle-level material references (`pid` / `p1`)
- Repack to `.3mf`

This would allow repeatable color metadata injection directly from profile settings.

### 2) Profile-Driven Color Mapping in JSON

Extend existing profile JSON files with optional color mapping fields, for example:

- `bodyColor`
- `textColor`
- `partToColorMap`

Then have the build script pass those mappings into the post-processor so each profile can define its own color intent.

### 3) Multi-Part Label Export Convention

Adopt a naming convention where exported parts are intentionally split (for example `labelBody`, `labelText`) so automation can:

- Detect part roles automatically
- Assign consistent colors/extruders per role
- Reduce manual slicer setup for every new label set

### 4) Bambu Studio Metadata Template Reuse

For projects targeting Bambu printers, keep one known-good template `.3mf` and automate reuse of selected metadata:

- `Metadata/model_settings.config` for per-object extruder assignments
- `Metadata/project_settings.config` for printer/filament defaults

Automation can copy/merge safe fields while preserving geometry from fresh OpenSCAD exports.

### 5) Build Validation and Reporting

Add a validation step after each build that checks:

- Expected output files exist (`.3mf`, `.png`)
- Required color/material tags are present in `3D/3dmodel.model`
- Profile names are path-safe and valid

Emit a summary report (console table + optional CSV/Markdown log) for quick review.

### 6) Incremental and CI-Friendly Builds

Extend the script to support:

- File hash caching to skip unchanged profile outputs
- `-whatIf` / dry-run mode
- GitHub Actions validation mode for pull requests

This keeps local iteration fast and makes output quality checks reproducible.

### 7) Optional Thumbnail and Publish Pipeline

Add an optional publish step that can:

- Standardize preview image generation
- Bundle selected outputs for upload
- Create release-ready folders per model

This turns builds into a consistent artifact pipeline from source to shareable files.
