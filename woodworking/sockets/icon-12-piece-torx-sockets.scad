// Torx Socket Storage Stand - 12 Piece Set
// Stores 7x 18mm sockets (T55, T50, T47, T45, T40, T30, T27)
// and 5x 12mm sockets (T25, T20, T15, T10, T8)

// Base dimensions
baseWidth = 65;
baseDepth = 95;
baseHeight = 20;
wallThickness = 3;

// 18mm socket holes (7 sockets)
largeDiameter = 18;
largeHoleRadius = largeDiameter / 2 + 0.5; // 0.5mm clearance
largeSocketCount = 7;

// 12mm socket holes (5 sockets)
smallDiameter = 12;
smallHoleRadius = smallDiameter / 2 + 0.5; // 0.5mm clearance
smallSocketCount = 5;

// Hole depth (cuts through top surface)
holeDepth = 16;

// Divider between sections
dividerThickness = wallThickness;

// Spacing between holes
holeSpacing = 13; // Vertical spacing

// Text label properties
labelHeight = 0.8;
labelSize = 5;

module baseBoard() {
    cube([baseWidth, baseDepth, baseHeight]);
}

module socketHole(radius) {
    cylinder(r = radius, h = holeDepth + 1, $fn = 32);
}

module largeSocketHolder() {
    // Column 1: 7 large 18mm sockets (T55, T50, T47, T45, T40, T30, T27)
    // Arranged vertically in a single column
    
    xPos = 15;
    startY = 9;
    zOffset = baseHeight - holeDepth;
    
    for (i = [0:6]) {
        yPos = startY + i * holeSpacing;
        translate([xPos, yPos, zOffset])
            socketHole(largeHoleRadius);
    }
}

module smallSocketHolder() {
    // Column 2: 5 small 12mm sockets (T25, T20, T15, T10, T8)
    // Arranged vertically in a single column
    
    xPos = 50;
    startY = 12;
    zOffset = baseHeight - holeDepth;
    
    for (i = [0:4]) {
        yPos = startY + i * holeSpacing;
        translate([xPos, yPos, zOffset])
            socketHole(smallHoleRadius);
    }
}

module torxSocketStand() {
    difference() {
        baseBoard();
        largeSocketHolder();
        smallSocketHolder();
    }
    
    // Add raised text labels on top surface
    translate([5, 1, baseHeight])
        linear_extrude(labelHeight)
            text("18mm", size = 4, valign = "top", halign = "left", font = "Liberation Sans");
    
    translate([40, 1, baseHeight])
        linear_extrude(labelHeight)
            text("12mm", size = 4, valign = "top", halign = "left", font = "Liberation Sans");
}

// Render the stand
torxSocketStand();

// Optional: Add edge guide walls (uncomment to include)
/*
module walls() {
    // Back wall
    translate([0, baseDepth - wallThickness, 0])
        cube([baseWidth, wallThickness, holeDepth / 2]);
    
    // Left wall
    cube([wallThickness, baseDepth, holeDepth / 2]);
    
    // Right wall
    translate([baseWidth - wallThickness, 0, 0])
        cube([wallThickness, baseDepth, holeDepth / 2]);
}

union() {
    torxSocketStand();
    walls();
}
*/
