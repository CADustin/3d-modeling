// The length of the individual bin/tray.
$length = 86;

// The depth (width really) of the bin/tray.
$depth = 86;

// The height as a percentage of the total available depth of the bin it will be inserted into.
$heightPct = 50; // [20:100]

// The thickness of the outter walls.
$wallThickness = 2; // [2:10]

// The thickness of the bottom.
$bottomThickness = 2; // [2:10]

// The chamfer size on the left side of the box.
$leftChamfer = 12; // [0:14]

// The chamfer size on the right side of the box.
$rightChamfer = 12; // [0:14]

{} // Below this are not customizable parameters

generateTrayPct($length, $depth, $heightPct, $wallThickness, $bottomThickness, $leftChamfer, $rightChamfer);

module generateTrayPct(length, depth, heightPct, wallThickness, bottomThickness, leftChamfer, rightChamfer) {
    $height = 82 * heightPct * 0.01;
    generateTray(length, depth, $height, wallThickness, bottomThickness, leftChamfer, rightChamfer);
}

module generateTray(length, depth, height, wallThickness, bottomThickness, leftChamfer, rightChamfer) {
    $leftChamferTriangleSide = sqrt(pow(leftChamfer,2)/2);
    $rightChamferTriangleSide = sqrt(pow(rightChamfer,2)/2);

    // Outer polygon
    outer_points = [
        [$leftChamferTriangleSide,0], 
        [length-$rightChamferTriangleSide,0], 
        [length, $rightChamferTriangleSide],
        [length, depth-$rightChamferTriangleSide],
        [length - $rightChamferTriangleSide, depth],
        [$leftChamferTriangleSide,depth],
        [0,depth-$leftChamferTriangleSide],
        [0, $leftChamferTriangleSide]
    ];

    // Inner polygon
    inner_points = [
        [$leftChamferTriangleSide + wallThickness, wallThickness], 
        [length - $rightChamferTriangleSide - wallThickness, wallThickness], 
        [length - wallThickness, $rightChamferTriangleSide + wallThickness],
        [length - wallThickness, depth - $rightChamferTriangleSide - wallThickness],
        [length - $rightChamferTriangleSide - wallThickness, depth - wallThickness],
        [$leftChamferTriangleSide + wallThickness, depth - wallThickness],
        [wallThickness, depth - $leftChamferTriangleSide - wallThickness],
        [wallThickness, $leftChamferTriangleSide + wallThickness]
    ];

    // Create the hollow shape and extrude it
    color("green")
    linear_extrude(height = height)
    difference() {
            polygon(points = outer_points);
            polygon(points = inner_points);
    }

    // Add a solid base
    color("red")
    linear_extrude(height = bottomThickness)
    polygon(points = outer_points);
}