// Shelf Width (in mm)
shelfWidth = 200;

// Shelf Depth (in mm)
shelfDepth = 120;

// Shelf Thickness (in mm)
thickness = 3;

// Cublical Wall Thickness (in Inches)
cubicalWallSize = 3; // [2,2.25,2.5,2.75,3,3.25,3.5,3.75]

{}

include <BOSL2/std.scad>

cubicalWallSizeInMM = cubicalWallSize*25.4;

$requiredShelfDepth = cubicalWallSizeInMM + thickness;
$validWidth = shelfDepth > $requiredShelfDepth;
$validWidthMessage = str("The shelf must be deeper than ", $requiredShelfDepth, "mm");
assert($validWidth, $validWidthMessage);

cuboid([shelfWidth,shelfDepth,thickness], rounding=thickness*2, edges="Z");

$shelfSupportLength = cubicalWallSizeInMM/2;

$fn=30;

translate([0,cubicalWallSizeInMM/2,$shelfSupportLength/2+thickness])
rotate([90,0,0])
cuboid([shelfWidth*0.80,$shelfSupportLength+thickness,thickness], rounding=thickness, edges = "Z", except = FWD+RIGHT+LEFT);

translate([0,-cubicalWallSizeInMM/2,$shelfSupportLength/2+thickness])
rotate([90,0,0])
cuboid([shelfWidth*0.80,$shelfSupportLength+thickness,thickness], rounding=thickness, edges="Z", except = FWD+RIGHT+LEFT);