// Semiconductor Wafer Stencil with Notch
// Reference: https://www.topline.tv/drawings/pdf/wafers/wafer_flats_thickness.pdf

// Inner Diameter of the resulting template (in mm)
templateDiameter = 200; // [50:460]

// Wall thickness of the stencil ring (in mm)
outlineThickness = 10; // [5:20]

// Z height / depth of the stencil (in mm)
stencilThickness = 4; // [3:12]

// Diameter of each magnet (in mm)
magnetDiameter = 5; // [3:12]

// Depth of each magnet pocket, blind hole from bottom (in mm)
magnetDepth = 2; // [0:5]

// Number of magnets evenly spaced around the ring
magnetCount = 6; // [0:12]

{}

// 200mm wafer is used as a reference
baseDiameter = 200; // Reference wafer size all proportions are relative to (in mm)
scale = templateDiameter / baseDiameter;

// Scaled parameters (base values are for a 200mm wafer)
notchDepth = 3  * scale; // Depth of notch measured inward from inner edge (in mm)

// Guard: stencilThickness must be at least magnetDepth + 1mm so there
// is always at least 1mm of material above each magnet pocket.
assert(
    stencilThickness >= magnetDepth + 1,
    "stencilThickness must be at least magnetDepth + 1mm"
);

// Guard: outlineThickness must be at least 2x magnetDiameter so the
// magnet pocket fits within the ring wall with material on both sides.
assert(
    outlineThickness >= 2 * magnetDiameter,
    "outlineThickness must be at least 2x magnetDiameter"
);

$fn = 360;

module waferStencil() {
    innerR         = templateDiameter / 2;
    outerR         = innerR + outlineThickness;
    magnetR        = magnetDiameter / 2;
    magnetCenterR  = innerR + outlineThickness / 2;  // mid-wall radius

    difference() {
        // Stencil ring body
        linear_extrude(height = stencilThickness) {
            difference() {
                // Outer boundary of the stencil ring
                circle(r = outerR);

                // Inner cutout — the wafer shape with notch
                difference() {
                    circle(r = innerR);

                    // Notch: circular cutter centered on the inner edge.
                    // Cutter radius = notchDepth so the deepest point is
                    // exactly notchDepth mm inside the inner opening.
                    translate([0, -innerR])
                        circle(r = notchDepth);
                }
            }
        }

        // Magnet holes
        for (i = [0 : magnetCount - 1]) {
            rotate([0, 0, i * 360 / magnetCount])
                translate([magnetCenterR, 0, 0])
                    cylinder(r = magnetR, h = magnetDepth);
        }
    }
}

waferStencil();
