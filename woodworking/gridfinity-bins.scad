// Gridfinity bin generator (standard 42 mm pitch, 7 mm height units)

/* [Bin Size] */
// Grid units wide (X)
gridX = 2; // [1:1:10]
// Grid units deep (Y)
gridY = 2; // [1:1:10]
// Height in 7 mm units (includes the base, excludes the stacking lip)
heightUnits = 3; // [1:1:20]

/* [Features] */
stackingLip = true;
// Number of compartments along X
compartmentsX = 1; // [1:1:10]
// Number of compartments along Y
compartmentsY = 1; // [1:1:10]
// Scoop radius at the front of each compartment (0 = none)
scoopRadius = 0; // [0:1:20]
// Magnet holes in the base
magnetHoles = false;
magnetDiameter = 6.5;
magnetDepth = 2.4;
wallThickness = 1.2;
// Floor thickness above the base profile
floorThickness = 0.8;
dividerThickness = 1.2;

/* [Gridfinity Standard] */
gridPitch = 42;
heightUnit = 7;
binClearance = 0.5;
outerRadius = 3.75;
baseHeight = 4.75;
lipHeight = 4.4;

/* [Hidden] */
$fn = 48;
eps = 0.01;

binWidth = gridX * gridPitch - binClearance;
binDepth = gridY * gridPitch - binClearance;
bodyHeight = heightUnits * heightUnit;
topHeight = bodyHeight + (stackingLip ? lipHeight : 0);

module roundedSlab(w, d, r, z, h = eps) {
    cornerRadius = max(r, 0.01);
    translate([0, 0, z])
        linear_extrude(h)
            offset(r = cornerRadius)
                translate([cornerRadius, cornerRadius])
                    square([max(w - 2 * cornerRadius, 0.01), max(d - 2 * cornerRadius, 0.01)]);
}

module insetSlab(w, d, r, z, inset) {
    translate([inset, inset, 0])
        roundedSlab(w - 2 * inset, d - 2 * inset, max(r - inset, 0.8), z);
}

// Hulls consecutive [z, inset] profile points into a solid
module profileSolid(w, d, r, points) {
    for (i = [0:len(points) - 2])
        hull() {
            insetSlab(w, d, r, points[i][0], points[i][1]);
            insetSlab(w, d, r, points[i + 1][0], points[i + 1][1]);
        }
}

// Gridfinity foot: 0.8 chamfer, 1.8 vertical, 2.15 chamfer
module baseFoot() {
    cellSize = gridPitch - binClearance;
    profileSolid(cellSize, cellSize, outerRadius, [
        [0, 2.95],
        [0.8, 2.15],
        [2.6, 2.15],
        [baseHeight, 0]
    ]);
}

module baseFeet() {
    for (x = [0:gridX - 1], y = [0:gridY - 1])
        translate([x * gridPitch, y * gridPitch, 0])
            baseFoot();
}

module magnetCutouts() {
    magnetOffset = 13;
    cellSize = gridPitch - binClearance;
    for (x = [0:gridX - 1], y = [0:gridY - 1], mx = [-1, 1], my = [-1, 1])
        translate([
            x * gridPitch + cellSize / 2 + mx * magnetOffset,
            y * gridPitch + cellSize / 2 + my * magnetOffset,
            -eps])
            cylinder(d = magnetDiameter, h = magnetDepth + eps);
}

// Interior cavity, including the stacking lip profile (inset from the outer wall)
module cavity() {
    floorZ = baseHeight + floorThickness;
    if (stackingLip) {
        lipBottom = topHeight - lipHeight - 2.1;
        profileSolid(binWidth, binDepth, outerRadius, [
            [floorZ, wallThickness],
            [lipBottom, wallThickness],
            [topHeight - lipHeight, 3.3],
            [topHeight - 2.5, 1.4],
            [topHeight - 1.8, 1.4],
            [topHeight - 0.7, 0.7],
            [topHeight + eps, 0.7]
        ]);
    } else {
        profileSolid(binWidth, binDepth, outerRadius, [
            [floorZ, wallThickness],
            [topHeight + eps, wallThickness]
        ]);
    }
}

module outerShell() {
    translate([0, 0, baseHeight - eps])
        linear_extrude(topHeight - baseHeight + eps)
            offset(r = outerRadius)
                translate([outerRadius, outerRadius])
                    square([binWidth - 2 * outerRadius, binDepth - 2 * outerRadius]);
}

module dividers() {
    innerW = binWidth - 2 * wallThickness;
    innerD = binDepth - 2 * wallThickness;
    for (i = [1:compartmentsX - 1])
        translate([wallThickness + i * innerW / compartmentsX - dividerThickness / 2, wallThickness, baseHeight])
            cube([dividerThickness, innerD, bodyHeight - baseHeight]);
    for (j = [1:compartmentsY - 1])
        translate([wallThickness, wallThickness + j * innerD / compartmentsY - dividerThickness / 2, baseHeight])
            cube([innerW, dividerThickness, bodyHeight - baseHeight]);
}

// Quarter-round scoop against the front wall of each compartment column
module scoops() {
    if (scoopRadius > 0) {
        innerW = binWidth - 2 * wallThickness;
        columnW = innerW / compartmentsX;
        for (i = [0:compartmentsX - 1])
            translate([wallThickness + i * columnW, wallThickness, baseHeight + floorThickness])
                difference() {
                    cube([columnW, scoopRadius, scoopRadius]);
                    translate([-eps, scoopRadius, scoopRadius])
                        rotate([0, 90, 0])
                            cylinder(r = scoopRadius, h = columnW + 2 * eps);
                }
    }
}

module gridfinityBin() {
    difference() {
        union() {
            baseFeet();
            outerShell();
        }
        cavity();
        if (magnetHoles) magnetCutouts();
    }
    intersection() {
        union() {
            dividers();
            scoops();
        }
        outerShell();
    }
}

gridfinityBin();
