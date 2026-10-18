// Metal peg board long pole holder.
//
// Procedural reconstruction that does not depend on external mesh imports.

use <../peg-base-plates/peg-base-plates.scad>

/* [Holder] */

// Barrel diameter profile in millimeters.
barrelDiameterMm = 20; // [20:5:30]

// Holder spacing in millimeters.
spacingMm = 20; // [10:1:95]

// Enable magnetic holder variant where available.
useMagneticHolder = false;

// Only used for the 20mm, 10mm-spacing holder variant.
useShortHolder = false;

/* [Hidden] */

holderHeightDefault = 46;
holderHeightMagnetic = 40;
holderFn = 72;

magnetDiameter = 12;
magnetDepth = 3;
magnetPushoutDiameter = 3;

function holderWidth(diameter) = diameter * 1.25;
function holderDepth(diameter, spacing) = diameter + spacing;
function pegColumnCount(diameter) = diameter >= 30 ? 2 : 1;
function pegCenterX(columnIndex, diameter) = pegColumnCount(diameter) == 1 ? 0 : (columnIndex == 0 ? -11 : 11);
function pegCenterZ(rowIndex) = rowIndex == 0 ? -17 : 17;

module cradleCut(diameter, depth, height) {
    translate([0, depth / 2 - diameter / 2 + 0.01, 0]) {
        cylinder(h = height + 0.2, d = diameter, center = true, $fn = holderFn);

        // Open the lower half of the circular cut to create the front cradle mouth.
        translate([0, diameter / 4, 0])
            cube([diameter, diameter / 2, height + 0.2], center = true);
    }
}

module magneticHoles(depth, height) {
    magRadius = magnetDiameter / 2;
    stepSize = magRadius + 1;

    for (i = [0 : stepSize : height - magRadius * 3]) {
        offsetDirection = floor(i / stepSize) % 2 == 1 ? -1 : 1;

        translate([
            offsetDirection * magRadius,
            -(depth / 2 - magnetDepth / 2),
            i - (height / 2 - stepSize)
        ])
            rotate([90, 0, 0]) {
                cylinder(h = magnetDepth, r = magRadius, center = true, $fn = holderFn);

                // Push-through hole to recover press-fit magnets.
                translate([0, 0, -depth / 2])
                    cylinder(h = depth, d = magnetPushoutDiameter, center = true, $fn = holderFn / 2);
            }
    }
}

module backPegs(depth, diameter) {
    for (rowIndex = [0 : 1]) {
        for (columnIndex = [0 : pegColumnCount(diameter) - 1]) {
            translate([
                pegCenterX(columnIndex, diameter),
                -depth / 2,
                pegCenterZ(rowIndex)
            ])
                peg();
        }
    }
}

module longPoleHolder(diameter = barrelDiameterMm, spacing = spacingMm, magnetic = useMagneticHolder, shortHolder = useShortHolder) {
    if (!(diameter == 20 || diameter == 25 || diameter == 30)) {
        echo("Unsupported holder diameter", diameter);
    } else if (magnetic && !(diameter == 20 && spacing == 20)) {
        echo("Unsupported magnetic holder combination", diameter, spacing);
    } else if (!magnetic && diameter != 20 && spacing == 10) {
        echo("Unsupported non-magnetic holder combination", diameter, spacing);
    } else {
        width = holderWidth(diameter);
        depth = holderDepth(diameter, spacing);
        height = magnetic ? holderHeightMagnetic : holderHeightDefault;

        // Keep the short variant selectable for compatibility with existing presets.
        shortOffset = shortHolder ? 0 : 0;

        union() {
            difference() {
                translate([0, shortOffset, 0])
                    cube([width, depth, height], center = true);

                translate([0, shortOffset, 0])
                    cradleCut(diameter, depth, height);

                if (magnetic)
                    translate([0, shortOffset, 0])
                        magneticHoles(depth, height);
            }

            if (!magnetic)
                translate([0, shortOffset, 0])
                    backPegs(depth, diameter);
        }
    }
}

longPoleHolder();
