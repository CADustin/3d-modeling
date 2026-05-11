# US General Series 2 Label Slips

This folder contains an OpenSCAD customizer for generating printable drawer labels sized for the US General Series 2 toolbox.

## Files

- `us-general-series2-label-slips.scad` - Main OpenSCAD source for the label customizer
- `us-general-series2-label-slips.json` - Customizer preset data

## Using the Customizer

1. Open `us-general-series2-label-slips.scad` in OpenSCAD.
2. Open the Customizer panel.
3. Adjust the available settings such as:
   - font
   - text size
   - text height
   - alignment
   - corner rounding
   - bevel size
   - colors
   - bed layout spacing
4. Render the model.
5. Export the result for your slicer.

## Editing Label Names

OpenSCAD's Customizer does not expose string arrays in the UI, so `userLabelTexts` must be edited directly in the `.scad` file.

The file currently includes a woodworking list as the active set and a mechanic list as a commented alternate.

## Bambu Studio Notes

After importing the model into Bambu Studio:

1. Bambu Studio may ignore the preview colors defined in OpenSCAD. If this happens, use the color tool to assign the second color by height so the raised text prints in a different color. I normally use the "Place input box of bottom near mouse" and enter `2.05` for 2mm thick labels.

2. **Optional:** Split the imported model so that the labels can be reorganized on the build plate.

## Notes

- The label body is fixed at 17 mm tall and 2 mm thick.
- Raised text height is adjustable in the customizer.
- Separate parts are intended to help multicolor workflows, but slicer setup is still required.
