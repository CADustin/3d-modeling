// Shelf Width (in mm)
$shelfWidth = 400;

// Shelf Width (in mm)
$shelfDepth = 200;

// Shelf Thickness (in mm)
$thickness = 3;

// Cublical Wall Thickness (in Inches)
$cubicalWallSize = 3.75; // [2,2.25,2.5,2.75,3,3.25,3.5,3.75]

{}
$cubicalWallSizeInMM = $cubicalWallSize*25.4;

include <BOSL2/std.scad>

cuboid([$shelfWidth,$shelfDepth,$thickness], rounding=$thickness, edges="Z");

$shelfSupportLength = $cubicalWallSizeInMM/2;

color("green")
translate([0,$cubicalWallSizeInMM/2,$shelfSupportLength/2-$thickness*.5])
rotate([90,0,0])
cuboid([$shelfWidth*0.80,$shelfSupportLength,$thickness], rounding=$thickness, edges="Z");

color("red")
translate([0,-$cubicalWallSizeInMM/2,$shelfSupportLength/2-$thickness*.5])
rotate([90,0,0])
cuboid([$shelfWidth*0.80,$shelfSupportLength,$thickness], rounding=$thickness, edges="Z");