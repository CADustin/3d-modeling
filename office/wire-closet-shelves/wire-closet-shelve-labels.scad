$labelWidth = 50; // [25:200]
$labelHeight = 20;
$labelThickness = 2;
$labelRadius = 2;

// Wire Shelf Parameters
$vertialWireThickness = 6;
$horizontalWireThickness = 2.32;
$distanceBetweenWires = 11.6;

$fn = 100;

module clip(horizontalWireThickness, distanceBetweenWires) {
    clipDiameter = horizontalWireThickness * 1.7;
    clipHeight = distanceBetweenWires * 0.80;

    difference() {
        cylinder(h = clipHeight, d = clipDiameter, center = true);

        // Cut the cylinder in half (we want a sem-cylinder)
        translate([0, clipDiameter / 4, 0])
        cube([clipDiameter, horizontalWireThickness, clipHeight * 1.1], center = true);

        // Now cut a void into the clip that will hold onto the wire part.
        translate([0, -horizontalWireThickness / 1.7, 0])
        cylinder(h = clipHeight * 1.1, d = horizontalWireThickness, center = true);
    }
}

$YOffsetForClips = $labelHeight/2-$horizontalWireThickness;
$ZOffsetForClips = .2;

// Clip #1
color("red")
translate([-($distanceBetweenWires * 0.80)/2-$horizontalWireThickness/2,$YOffsetForClips,$ZOffsetForClips])
rotate([90,0,90])
clip($horizontalWireThickness, $distanceBetweenWires);

// Clip #2
color("blue")
translate([($distanceBetweenWires * 0.80)/2+$horizontalWireThickness/2,$YOffsetForClips,$ZOffsetForClips])
rotate([90,0,90])
clip($horizontalWireThickness, $distanceBetweenWires);

// Label Body
linear_extrude(height=$labelThickness)
minkowski() {
    // minkowski() adds the circle to the outside.
    // Subtracting keeps the final size exactly WxH.
    square([$labelWidth - 2*$labelRadius, $labelHeight - 2*$labelRadius], center=true);
    circle(r=$labelRadius);
}
