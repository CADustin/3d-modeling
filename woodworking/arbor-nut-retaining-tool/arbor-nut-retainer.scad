$shaftSize = 13.5;
$shaftLength = 20;

$retainerSize = 20;
$retainerLength = 5;

$magnetDiameter = 12;
$magnetThickness = 6;
$magnetPressoutHoleSize = 4;
$magnetDistanceFromEnd = -0.1;

{}

rotate([180, 0, 0])
difference(){
    // The main shaft and the retaining cap
    group(){
        // Main shaft
        color("red")
        cylinder(h = $shaftLength, r = $shaftSize / 2, center = true, $fn = 100);

        // Retainer
        $offsetFromCenterToEnd = $shaftLength / 2 + $retainerLength / 2;
        color("green")
        translate([0, 0, $offsetFromCenterToEnd])
        cylinder(h = $retainerLength, r = $retainerSize / 2, center = true, $fn = 100);
    }

    // This hole is intended to be used to press out the magnet if the 
    // tool needs to be replaced ... I came across a design for dust 
    // collector fittings where the designer did this, and I like it 
    // more than glue.
    $magnetPressoutHole = ($shaftLength + $retainerLength) * 2;
    cylinder(h = $magnetPressoutHole, r = $magnetPressoutHoleSize / 2, center = true, $fn = 100);

    // Magnet Cutout
    $offsetFromCenterToMagnetPlacement = -$shaftLength / 2 + $magnetThickness / 2 + $magnetDistanceFromEnd;
    translate([0, 0, $offsetFromCenterToMagnetPlacement])
    cylinder(h = $magnetThickness, r = $magnetDiameter / 2, center = true, $fn = 100);
}