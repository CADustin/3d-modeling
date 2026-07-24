// Metal peg board key holder reconstructed from exported meshes.
//
// This file reuses the peg geometry from peg-base-plates.scad.
// It can be rendered standalone and reused from other SCAD files.

use <../peg-base-plates/peg-base-plates.scad>

/* [Layout] */

// Number of pegs on the back side.
pegCount = 5; // [1:1:9]

// Number of front hooks.
hookCount = 6; // [1:1:12]

// Thickness of the rectangular back plate.
plateThickness = 2; // [1:0.1:5]

/* [Hidden] */

plateWidth = 22;
plateEdgeInset = 17;
hookWidth = 5;
hookBodyMinY = -15.24863;
hookBodyMidY = -9.75137;
hookBodyMaxY = -1;
hookLocalMinZ = -4.526131;
hookLocalMaxZ = 5.526131;
hookTopNotchStartZ = 0.75;

function plateHalfHeight(pegTotal) = pegTotal * plateEdgeInset;

function spreadCenter(index, count, minValue, maxValue) =
    count <= 1 ? 0 : minValue + (maxValue - minValue) * index / (count - 1);

function pegCenterZ(index, pegTotal, halfHeight) =
    spreadCenter(index, pegTotal, -halfHeight + plateEdgeInset, halfHeight - plateEdgeInset);

function hookCenterZ(index, hookTotal, halfHeight) =
    hookTotal <= 1
        ? 0
    : spreadCenter(index, hookTotal, -halfHeight - hookLocalMinZ, halfHeight - hookLocalMaxZ);

// Front hook body measured from exported geometry.
// The side profile below is taken from the 1hook-1peg mesh slice at x=2.5.
function hookProfilePoints() = [
    [hookBodyMaxY, -4.75],
    [hookBodyMaxY, hookTopNotchStartZ],
    [hookBodyMidY, hookTopNotchStartZ],
    [hookBodyMidY, hookLocalMaxZ],
    [-9.762237, 5.577253],
    [-9.783494, 5.625000],
    [-9.814215, 5.667282],
    [-9.853054, 5.702253],
    [-9.898316, 5.728386],
    [-9.948023, 5.744536],
    [-10.000000, 5.750000],
    [-15.000000, 5.750000],
    [-15.051977, 5.744536],
    [-15.101684, 5.728386],
    [-15.146946, 5.702253],
    [-15.185785, 5.667282],
    [-15.216506, 5.625000],
    [-15.237763, 5.577253],
    [hookBodyMinY, hookLocalMaxZ],
    [hookBodyMinY, hookLocalMinZ],
    [-15.237763, -4.577253],
    [-15.216506, -4.625000],
    [-15.185785, -4.667282],
    [-15.146946, -4.702253],
    [-15.101684, -4.728386],
    [-15.051977, -4.744536],
    [-15.000000, -4.750000],
    [hookBodyMaxY, -4.750000]
];

module keyHook() {
    rotate([90, 0, 90])
        linear_extrude(height = hookWidth, center = true)
            polygon(points = hookProfilePoints());
}

// Reusable key holder assembly.
// pegTotal: number of back pegs.
// hookTotal: number of front hooks.
// boardThickness: thickness of the plate.
module keyHolder(pegTotal = pegCount, hookTotal = hookCount, boardThickness = plateThickness) {
    halfHeight = plateHalfHeight(pegTotal);

    union() {
        cube([plateWidth, boardThickness, halfHeight * 2], center = true);

        // Back pegs (reuse geometry from peg-base-plates.scad).
        for (index = [0 : pegTotal - 1]) {
            translate([0, boardThickness / 2, pegCenterZ(index, pegTotal, halfHeight)])
                mirror([0, 1, 0])
                    peg();
        }

        // Front hooks.
        for (index = [0 : hookTotal - 1]) {
            translate([0, 0, hookCenterZ(index, hookTotal, halfHeight)])
                keyHook();
        }
    }
}

// Standalone render using customizer values.
keyHolder();
