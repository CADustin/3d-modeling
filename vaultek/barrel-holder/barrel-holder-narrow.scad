include <BOSL2/std.scad>
include <../common/functions.scad>

// THe total height of the barrel holder (in mm).
$holderHeight = 46; // [20:100]

// The spacing from the back of the safe to the beginning of where the barrel will rest (in mm) **Note:** The typical Vaultek spacers are ~38mm.
$spacingToBarrel = 76; // [10:150]

// The barrel diameter (in mm).
$barrelDiameter = 25.4; // [10:50]

{}

$totalWidth = $barrelDiameter*1.25;

$depth = $spacingToBarrel + $barrelDiameter;

color("blue")
translate([0,-$depth/2,0])
accessoryBaseWithPins($totalWidth,$holderHeight,0);

difference(){
cube([$totalWidth,$depth,$holderHeight], center = true);

color("red")
translate([0,$depth/2-$barrelDiameter/2+0.01,0])
group(){
    cylinder(h = $holderHeight+0.1, d = $barrelDiameter, center = true, $fn = 50);

    translate([0,$barrelDiameter/4,0])
    cube([$barrelDiameter, $barrelDiameter/2, $holderHeight+0.1], center = true);
}
}