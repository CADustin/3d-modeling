
$swatchWidth = 12;
$swatchHeight = 2;
$swatchSpacing = 10;

$width = 150;
$depth = 50;
$height = 6;
$slotCount = floor($width / ($swatchSpacing + $swatchWidth));
$edgeRadius = .25; // [0:0.1:2]
$magnetDiameter = 5.2;
$magnetDepth = 10.1;
$magnetMargin = 3;

module roundedCube(width, depth, height, radius) {
    minkowski() {
        cube([
            width - 2 * radius,
            depth - 2 * radius,
            height - 2 * radius
        ], center = true);
        sphere(r = radius);
    }
}


$fn = 50;


module holderBody() {
    difference(){
        roundedCube($width, $depth, $height, $edgeRadius);

    translate([0,0,$depth/2])
    rotate([0,90,0])
    cylinder(h = $width, d = $depth, center = true);
    
    cube([$width-10,$depth-20,$height*1.1], center = true);

        // Add separate swatch slots with centers spaced by the swatch width and spacing.
        for (xPosition = [-($slotCount - 1) * ($swatchSpacing + $swatchWidth) / 2 : $swatchSpacing + $swatchWidth : ($slotCount - 1) * ($swatchSpacing + $swatchWidth) / 2]) {
            translate([xPosition, 0, $height / 2 - $swatchHeight / 2])
                cube([$swatchWidth, $depth, $swatchHeight], center = true);
        }
    }
}

difference() {
    minkowski() {
        holderBody();
        sphere(r = $edgeRadius);
    }

    for (xPosition = [-$width / 2 - $edgeRadius + $magnetMargin + $magnetDiameter / 2, $width / 2 + $edgeRadius - $magnetMargin - $magnetDiameter / 2]) {
        for (yPosition = [-$depth / 2 - $edgeRadius + $magnetMargin + $magnetDiameter / 2, $depth / 2 + $edgeRadius - $magnetMargin - $magnetDiameter / 2]) {
            for (zPosition = [-$height / 2 - $edgeRadius + $magnetDepth / 2, $height / 2 + $edgeRadius - $magnetDepth / 2]) {
                translate([xPosition, yPosition, zPosition])
                    cylinder(d = $magnetDiameter, h = $magnetDepth, center = true);
            }
        }
    }
}