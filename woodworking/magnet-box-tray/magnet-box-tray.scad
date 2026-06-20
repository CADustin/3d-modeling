// Tray Parameters
$slots = 6;
$trayWalls = 2; // [2:0.5:8]
$trayHeightPct = 60; // [20:5:80]

// Magnet Box Size
$boxWidth = 72;
$boxLength = 72;
$boxHeight = 18;

{}

// Overall Width
$oaw = $boxWidth + $trayWalls * 2;

// Overall Height
$oah = $boxHeight * $slots + $trayWalls * ($slots - 1) + $trayWalls * 2;

// Overall Depth
$oad = $boxLength * $trayHeightPct/100 + $trayWalls;

difference() {
    // Main Tray Body
    cube([$oaw,$oad,$oah], center = true);
    
    // Box Cutouts
    $cutoutDepth = $boxLength * $trayHeightPct/100;
    $cutoutY = $oad / 2 - $trayWalls - $cutoutDepth / 2;
    $cutoutStackHeight = $slots * $boxHeight + ($slots - 1) * $trayWalls;

    for (i = [0:$slots - 1]) {
        $cutoutZ = -$cutoutStackHeight / 2 + $boxHeight / 2 + i * ($boxHeight + $trayWalls);
        translate([0, $cutoutY, $cutoutZ])
        cube([$boxWidth, $cutoutDepth, $boxHeight], center = true);
    }
    
    translate([0,-$oad/2,0])
    cylinder(h = $oah, d = $oad/1.5, center = true);
}


