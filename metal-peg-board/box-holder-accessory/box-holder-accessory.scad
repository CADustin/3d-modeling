
use <../peg-base-plates/peg-base-plates.scad>

/* [Box/Slot Sizes] */
// The width of the slot (in mm).
$boxWidth = 13;

// The depth of the slot (in mm).
$boxDepth = 35;

// The spacing between rows of slots (in mm).
$boxRowSpacing = 8;

// The spacing between columns of slots (in mm).
$boxColumnSpacing = 8;

/* [Number of Boxes/Slots/Items to hold] */
// The number of slots wide.
$boxsWide = 4;

// The number of slots deep.
$boxsDeep = 1;

/* [General] */
// The total height (in mm).
$totalHeight = 50; 

// The outter wall thickness (in mm).
$wallThickness = 2; 

/* [Pegboard Settings] */
$pegPlateMode = "back"; // ["off", "side", "back"]

// The number of Pegs Wide (aka: The number of Columns of Pegs)
$pegPlateColumns = 4; // [0:12]

// The number of Pegs High (aka: The number of Rows of Pegs)
$pegPlateRows = 2; // [0:6]

{}

$slotPitchX = $boxWidth + $boxColumnSpacing;
$slotPitchY = $boxDepth + $boxRowSpacing;

$totalWidth = $wallThickness*2 + $boxWidth * $boxsWide + ($boxColumnSpacing * ($boxsWide - 1));

$totalDepth = $wallThickness*2 + $boxDepth * $boxsDeep + ($boxRowSpacing * ($boxsDeep - 1));

$slotStartX = -(($boxsWide - 1) * $slotPitchX) / 2;
$slotStartY = -(($boxsDeep - 1) * $slotPitchY) / 2;

module roundedCube(size, cornerRadius, center = true) {
	effectiveRadius = min(cornerRadius, min(size[0], min(size[1], size[2])) / 2 - 0.01);

	minkowski() {
		cube([size[0] - 2 * effectiveRadius, size[1] - 2 * effectiveRadius, size[2] - 2 * effectiveRadius], center = center);
		sphere(r = effectiveRadius, $fn = 32);
	}
}

difference() {
	roundedCube([$totalWidth,$totalDepth,$totalHeight], .5, center = true);

	for (row = [0 : $boxsDeep - 1]) {
		for (col = [0 : $boxsWide - 1]) {
			translate([
				$slotStartX + (col * $slotPitchX),
				$slotStartY + (row * $slotPitchY),
				$wallThickness
			])
				roundedCube([$boxWidth, $boxDepth, $totalHeight], 1, center = true);
		}
        
        translate([0,$slotStartY + (row * $slotPitchY),$wallThickness])
		#cube([($boxsWide - 1) * ($boxWidth + $boxRowSpacing), $boxDepth * .7, $totalHeight], center = true);
	}
}

if ($pegPlateMode == "side") {
	color("green")
	translate([$totalWidth / 2, 0, 0])
		rotate([0, 0, 90])
			pegBasePlate(
				columnCount = $pegPlateColumns,
				rowCount = $pegPlateRows,
				boardThickness = 0
			);
}

if ($pegPlateMode == "back") {
	color("red")
	translate([0, -$totalDepth / 2, 0])
		pegBasePlate(
			columnCount = $pegPlateColumns,
			rowCount = $pegPlateRows,
			boardThickness = 0
		);
}
