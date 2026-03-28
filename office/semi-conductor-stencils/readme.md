# Semiconductor Wafer Whiteboard Stencils

3D-printable magnetic stencils for tracing semiconductor wafer outlines on whiteboards. While a rough circle usually gets the job done, these stencils produce accurate wafer shapes — complete with the correct flats or notch — that elevate your whiteboard diagrams.

Each stencil is a ring that matches the wafer outline. Pockets on the underside hold small magnets so the stencil stays put on a magnetic whiteboard while you trace.

## Stencil Types

### Wafer with Flats

Represents older-style wafers (≤150 mm) that use a major and minor flat for orientation and doping identification. The base reference is a 3-inch (76.2 mm) wafer; flat lengths scale proportionally when the template diameter is changed.

### Wafer with Notch

Represents modern wafers (200 mm+) that use a small notch for orientation. The base reference is a 200 mm wafer; the notch depth scales proportionally with template diameter.

## Pre-built Models

Ready-to-print 3MF files are in the `output/` folder:

| File | Type | Template Diameter |
|------|------|-------------------|
| `wafer-with-flats_3in-Wafer-1x-Scale.3mf` | Flats | 76.2 mm (1:1) |
| `wafer-with-flats_3in-Wafer-Scaled-to-200mm.3mf` | Flats | 200 mm |
| `wafer-with-flats_3in-Wafer-Scaled-to-300mm.3mf` | Flats | 300 mm |
| `wafer-with-notch_200mm-Wafer-1x-Scale.3mf` | Notch | 200 mm (1:1) |
| `wafer-with-notch_200mm-Wafer-1.5x-Scale.3mf` | Notch | 300 mm |
| `wafer-with-notch_200mm-Wafer-0.39x-Scale.3mf` | Notch | 78 mm |

## Customization

The models are parametric [OpenSCAD](https://openscad.org/) files. Open the `.scad` file in OpenSCAD and adjust the parameters in the Customizer panel, or edit the `.json` files to define your own parameter sets.

| Parameter | Default | Description |
|-----------|---------|-------------|
| `templateDiameter` | varies | Inner diameter of the stencil opening (mm) |
| `outlineThickness` | 10 | Wall thickness of the stencil ring (mm) |
| `stencilThickness` | 4 | Height / depth of the stencil (mm) |
| `magnetDiameter` | 5 | Diameter of each magnet pocket (mm) |
| `magnetDepth` | 2 | Depth of each magnet pocket (mm) |
| `magnetCount` | 6 | Number of magnets evenly spaced around the ring |

## Magnets

The default pockets are sized for **5 mm x 2 mm disc magnets**, which are widely available and inexpensive. The pockets are blind holes on the bottom of the stencil — press-fit or glue the magnets in place after printing.

## Printing Tips

- No supports needed — the magnet pockets print as shallow blind holes from the bottom.
- PLA or PETG both work well.
- A layer height of 0.2 mm is fine for all variants.
- The 300 mm template diameter variants are large; verify they fit your print bed.