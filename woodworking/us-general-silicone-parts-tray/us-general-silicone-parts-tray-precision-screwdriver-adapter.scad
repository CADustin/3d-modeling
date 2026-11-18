// Number of hexagons in the row.
hexagonCount = 10;

// Hexagon diameter across opposite corners, in millimeters.
hexagonAcrossCorners = 7.1;

// Height of each hexagon, excluding the top plate, in millimeters.
hexagonHeight = 15;

// Gap between the facing flat edges of adjacent hexagons, in millimeters.
hexagonGap = 3.1;

// Through-bore diameter in millimeters; must be positive and at least 1 mm less than the hexagon diameter.
boreDiameter = 3.5;

// Add a plate across the tops of the hexagons.
includeTopPlate = true;

// Thickness of the top plate in millimeters; also controls its size and overhang.
topPlateThickness = 2;

// Plate edge radius in millimeters; use 0 for square edges. Must be less than half the smallest plate dimension.
topPlateEdgeRadius = 0.25;

{}

hexagonXWidth = hexagonAcrossCorners * cos(30);
hexagonSpacing = hexagonXWidth + hexagonGap;
maxBoreDiameter = hexagonAcrossCorners - 2;
topPlateLength = (hexagonCount - 1) * hexagonSpacing + hexagonXWidth + 2 * topPlateThickness;
topPlateWidth = hexagonAcrossCorners + 2 * topPlateThickness / 2;

$fn=30;

assert(boreDiameter > 0, "boreDiameter must be greater than zero");
assert(boreDiameter <= maxBoreDiameter, "boreDiameter must be at least 1 mm smaller than hexagonAcrossCorners");
assert(!includeTopPlate || topPlateThickness > 0, "topPlateThickness must be greater than zero when the top plate is enabled");
assert(!includeTopPlate || (topPlateEdgeRadius >= 0 && topPlateEdgeRadius < min(topPlateThickness, topPlateLength, topPlateWidth) / 2),
    "topPlateEdgeRadius must be nonnegative and less than half the smallest top plate dimension");

translate([0, 0, hexagonHeight + (includeTopPlate ? topPlateThickness : 0)]) rotate([180, 0, 0]) difference() {
    union() {
        for (index = [0 : hexagonCount - 1]) {
            translate([(index - (hexagonCount - 1) / 2) * hexagonSpacing, 0, 0])
                rotate([0, 0, 90])
                    cylinder(d = hexagonAcrossCorners, h = hexagonHeight, $fn = 6);
        }

        if (includeTopPlate) {
            if (topPlateEdgeRadius == 0) {
                translate([-topPlateLength / 2, -topPlateWidth / 2, hexagonHeight])
                    cube([topPlateLength, topPlateWidth, topPlateThickness]);
            } else {
                translate([-topPlateLength / 2 + topPlateEdgeRadius,
                           -topPlateWidth / 2 + topPlateEdgeRadius,
                           hexagonHeight + topPlateEdgeRadius])
                    minkowski() {
                        cube([topPlateLength - 2 * topPlateEdgeRadius,
                              topPlateWidth - 2 * topPlateEdgeRadius,
                              topPlateThickness - 2 * topPlateEdgeRadius]);
                        sphere(r = topPlateEdgeRadius);
                    }
            }
        }
    }

    for (index = [0 : hexagonCount - 1]) {
        translate([(index - (hexagonCount - 1) / 2) * hexagonSpacing, 0, -1])
            cylinder(d = boreDiameter, h = hexagonHeight + (includeTopPlate ? topPlateThickness : 0) + 2);
    }
}