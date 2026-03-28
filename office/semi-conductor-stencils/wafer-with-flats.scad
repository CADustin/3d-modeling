// Semiconductor Wafer Stencil with Major and Minor Flats
// Reference: https://www.topline.tv/drawings/pdf/wafers/wafer_flats_thickness.pdf

// Inner Diameter of the resulting template
templateDiameter = 76.2; // [50:460]

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

// 3" (76.2mm) wafer is the base reference
baseDiameter = 76.2;  // Reference wafer size all proportions are relative to (in mm)
scale = templateDiameter / baseDiameter;

// Scaled parameters (base values are for a 3" wafer)
majorFlatLength = 25 * scale; // Length of major flat (in mm)
minorFlatLength = 12 * scale; // Length of minor flat (in mm)
minorFlatAngle = 90; // Angular position of minor flat (in degrees, not scaled)

// Guard: stencilThickness must be at least magnetDepth + 1mm so there
// is always at least 1mm of material above each magnet pocket.
assert(
    stencilThickness >= magnetDepth + 1,
    "stencilThickness must be at least magnetDepth + 1mm"
);

// Guard: outlineThickness must be at least 1.5x magnetDiameter so the
// magnet pocket fits within the ring wall with material on both sides.
assert(
    outlineThickness >= 2 * magnetDiameter,
    "outlineThickness must be at least 1.5x magnetDiameter"
);

$fn = 360;

module waferStencil() {
    innerR         = templateDiameter / 2;
    outerR         = innerR + outlineThickness;
    magnetR        = magnetDiameter / 2;
    magnetCenterR  = innerR + outlineThickness / 2;  // mid-wall radius

    difference() {
        linear_extrude(height = stencilThickness) {
            difference() {
                // Outer boundary
                circle(r = outerR);

                // Inner wafer opening: circle clipped by flat half-planes
                // Each flat is a chord; intersection keeps the side toward center
                majorFlatDist = sqrt(innerR * innerR - majorFlatLength * majorFlatLength / 4);
                minorFlatDist = sqrt(innerR * innerR - minorFlatLength * minorFlatLength / 4);

                intersection() {
                    circle(r = innerR);

                    // Major flat at bottom: keep everything above y = -majorFlatDist
                    translate([-(innerR + 1), -majorFlatDist])
                        square([2 * (innerR + 1), majorFlatDist + innerR + 1]);

                    // Minor flat: rotated minorFlatAngle clockwise from major
                    rotate([0, 0, -minorFlatAngle])
                        translate([-(innerR + 1), -minorFlatDist])
                            square([2 * (innerR + 1), minorFlatDist + innerR + 1]);
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
