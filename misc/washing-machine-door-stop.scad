/* [Main Dimensions] */
baseDiameter = 40; // [10:0.1:60]
topDiameter = 40; // [10:0.1:40]

/* [Magnet Dimensions] */
magnetDiameter = 12.1; // [5:0.1:20]
magnetDepth = 3; // [1:0.1:5]

{} // Above this is intended to be user customizable; below are the model and variables not indended to be customized.

$fn=128;

difference() {
	cylinder(d1 = baseDiameter, d2 = topDiameter, h = 60);

	// Through-hole, extended slightly past both ends for a clean cut.
	translate([0, 0, -0.1])
		cylinder(d = 5, h = 60.2);

	// Magnet pocket on the bottom face.
	cylinder(d = magnetDiameter, h = magnetDepth);
}
