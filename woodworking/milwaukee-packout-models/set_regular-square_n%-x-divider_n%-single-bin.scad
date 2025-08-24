use <regular-square-divider.scad>
use <regular-square-bin.scad>

// The length of the individual bin/tray.
$binLength = 86;

// The depth (width really) of the bin/tray.
$binDepth = 86;

// The height as a percentage of the total available depth of the bin it will be inserted into.
$binHeightPct = 50; // [20:100]

// The thickness of the outter walls.
$binWallThickness = 2; // [2:10]

// The thickness of the bottom.
$binBottomThickness = 2; // [2:10]

// The chamfer size on the left side of the box.
$binLeftChamfer = 12; // [0:14]

// The chamfer size on the right side of the box.
$binRightChamfer = 12; // [0:14]

// Length of the Divider ... Regular 4" Square, X-Style: 113mm was a tad loose, 114mm was too tight, 113.5 fits but is a tad tight.
$dividerLengthAtTop = 113.1;

// Thickness of the Divider
$dividerThickness = 2; // [2:10]

// The proportion of the total height to use for scaling.
$dividerHeightPercentage = 50; // [10:100]

// Width of the Divider Edge
$dividerWidthOfDividerEdge = 6; // [6:10]

// The Length of the Chamfer
$chamferLength = 10; // [6:14]

{} // Below this are not customizable parameters

// Divider 1
translate([0, $binLength/2 + $dividerWidthOfDividerEdge * 2, 0])
GenerateDivider($dividerLengthAtTop, $dividerThickness, $dividerHeightPercentage, $dividerWidthOfDividerEdge, $chamferLength, 1, 40);

// Divider 2
translate([0, $binLength/2 + $dividerWidthOfDividerEdge * 2 + 10, 0])
GenerateDivider($dividerLengthAtTop, $dividerThickness, $dividerHeightPercentage, $dividerWidthOfDividerEdge, $chamferLength, -1, 40);



translate([-$binLength/2,-$binDepth/2,0])
generateTrayPct($binLength, $binDepth, $binHeightPct, $binWallThickness, $binBottomThickness, $binLeftChamfer, $binRightChamfer);