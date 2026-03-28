// 3" Semiconductor Wafer Stencil with Major and Minor Flats
// Reference: https://www.topline.tv/drawings/pdf/wafers/wafer_flats_thickness.pdf

waferDiameter    = 76.2;  // mm — 3" inner opening diameter
majorFlatLength  = 25;    // mm — length of major flat
minorFlatLength  = 12;    // mm — length of minor flat
minorFlatAngle   = 90;    // degrees — angular position of minor flat relative to major flat

outlineThickness = 10;    // mm — wall thickness of the stencil ring
stencilThickness = 4;     // mm — Z height (depth) of the stencil

magnetDiameter   = 5;     // mm — diameter of each magnet
magnetDepth      = 3;     // mm — depth of each magnet pocket (blind hole from bottom)
magnetCount      = 6;     // number of magnets evenly spaced around the ring

// Guard: stencilThickness must be at least magnetDepth + 1mm so there
// is always at least 1mm of material above each magnet pocket.
assert(
    stencilThickness >= magnetDepth + 1,
    "stencilThickness must be at least magnetDepth + 1mm"
);

// Guard: outlineThickness must be at least 2× magnetDiameter so the
// magnet pocket fits within the ring wall with material on both sides.
assert(
    outlineThickness >= 2 * magnetDiameter,
    "outlineThickness must be at least 2× magnetDiameter"
);

$fn = 360;

module waferStencil() {
    innerR         = waferDiameter / 2;
    outerR         = innerR + outlineThickness;
    magnetR        = magnetDiameter / 2;
    magnetCenterR  = innerR + outlineThickness / 2;  // mid-wall radius

    difference() {
        // ── Stencil ring body ──────────────────────────────────────────
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

        // ── Magnet pockets (blind holes opening from the bottom face) ──
        for (i = [0 : magnetCount - 1]) {
            rotate([0, 0, i * 360 / magnetCount])
                translate([magnetCenterR, 0, 0])
                    cylinder(r = magnetR, h = magnetDepth);
        }
    }
}

waferStencil();
