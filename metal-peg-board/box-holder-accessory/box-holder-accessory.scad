
$boxWidth = 13;
$boxDepth = 35;
$boxRowSpacing = 8;
$boxColumnSpacing = 8;

$boxsWide = 4;
$boxsDeep = 2;

$wallThickness = 2;

$totalHeight = 50;

$slotPitchX = $boxWidth + $boxColumnSpacing;
$slotPitchY = $boxDepth + $boxRowSpacing;

$totalWidth = $wallThickness*2 + $boxWidth * $boxsWide + ($boxColumnSpacing * ($boxsWide - 1));

$totalDepth = $wallThickness*2 + $boxDepth * $boxsDeep + ($boxRowSpacing * ($boxsDeep - 1));

$slotStartX = -(($boxsWide - 1) * $slotPitchX) / 2;
$slotStartY = -(($boxsDeep - 1) * $slotPitchY) / 2;

difference() {
	cube([$totalWidth,$totalDepth,$totalHeight], center = true);

	for (row = [0 : $boxsDeep - 1]) {
		for (col = [0 : $boxsWide - 1]) {
			translate([
				$slotStartX + (col * $slotPitchX),
				$slotStartY + (row * $slotPitchY),
				$wallThickness
			])
				cube([$boxWidth, $boxDepth, $totalHeight], center = true);
		}
        
        translate([0,$slotStartY + (row * $slotPitchY),$wallThickness])
        cube([$boxsWide * $boxWidth, $boxDepth*.7, $totalHeight], center = true);
	}
}
