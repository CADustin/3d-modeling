/* [Cleaner] */
// Outer diameter of the Cleaner body, in millimeters.
$diameter = 20; // [10:1:40]
// Overall height of the Cleaner body, in millimeters.
$height = 60; // [20:1:100]
// Diameter of the axial opening at the bottom of the Cleaner, in millimeters.
$bottomHoleDiameter = 14; // [4:1:18]
// Depth of the Cleaner’s bottom opening; also limits the Base’s top cylinder height.
$bottomHoleDepth = 25; // [5:1:50]
// Height of each cross-shaped slot cut into the Cleaner’s bottom, in millimeters.
$bottomSlotHeight = 10; // [2:1:20]
// Width of each cross-shaped slot cut into the Cleaner’s bottom, in millimeters.
$bottomSlotWidth = 5; // [2:0.5:10]

/* [Base] */
// Outer diameter of the Base's lower textured cylinder, in millimeters.
$baseDiameter = 40; // [10:1:80]
// Height of the Base’s centered top cylinder; automatically capped at Bottom Hole Depth.
$topCylinderHeight = 8; // [1:1:50]

/* [Texture] */
// Surface treatment used on the Cleaner and the cylindrical body of the Base.
$texture = "Smooth"; // [Smooth, Tapered, Scales, Honeycomb, Wave ribs, Dimples]
// Vertical distance between dimple rows, in millimeters (Dimples texture only).
$dimpleSpacing = 5; // [3:1:10]
// Number of dimples around the Cleaner; adjusted proportionally for the wider Base (Dimples only).
$dimpleCount = 16; // [8:2:32]
// Diameter of each dimple, in millimeters (Dimples texture only).
$dimpleDiameter = 1.6; // [0.8:0.2:3]
// Number of spiral ribs around the Cleaner; adjusted proportionally for the wider Base (Wave ribs only).
$waveRibCount = 8; // [4:1:16]
// Side-to-side angular sweep of each rib, in degrees (Wave ribs texture only).
$waveAmplitude = 14; // [0:2:30]
// Vertical repeat length of the rib wave, in millimeters (Wave ribs texture only).
$wavePeriod = 18; // [8:2:40]
// Thickness of each raised rib, in millimeters (Wave ribs texture only).
$waveWidth = 1.8; // [0.8:0.2:3]
// Vertical distance between honeycomb rows, in millimeters (Honeycomb texture only).
$honeycombSpacing = 5; // [3:1:10]
// Number of cells around the Cleaner; adjusted proportionally for the wider Base (Honeycomb only).
$honeycombCount = 16; // [8:2:32]
// Width of each hexagonal cell, in millimeters (Honeycomb texture only).
$honeycombSize = 2.6; // [1.5:0.5:4]
// Radial depth of the honeycomb surface cut, in millimeters (Honeycomb texture only).
$honeycombDepth = 2.5; // [1:0.5:5]
// Vertical distance between scale rows, in millimeters (Scales texture only).
$scaleSpacing = 3; // [2:0.5:8]
// Number of scales around the Cleaner; adjusted proportionally for the wider Base (Scales only).
$scaleCount = 16; // [8:2:32]
// Diameter of each scale impression, in millimeters (Scales texture only).
$scaleDiameter = 3.5; // [2:0.5:6]
// Top diameter of the tapered body, in millimeters (Tapered texture only).
$taperTopDiameter = 16; // [8:1:32]

/* [Quality] */
// Facet count used to render circular surfaces; higher values look smoother but render more slowly.
$fn = 100;
// Radius used to soften the outside top and bottom edges of straight-sided cylinders; set to 0 for sharp edges.
$edgeRadius = 1; // [0:0.1:2]

// Internal reference used to preserve circumferential texture spacing between the differently sized models.
textureReferenceDiameter = $diameter;

module roundedCylinder(d, h, r = $edgeRadius, sides = $fn) {
	filletRadius = min(max(r, 0), min(d / 2, h / 2));
	arcSteps = max(4, ceil(sides / 4));
	if (filletRadius == 0) {
		cylinder(d = d, h = h, $fn = sides);
	} else {
		rotate_extrude($fn = sides)
			polygon(points = concat(
				[[0, 0], [d / 2 - filletRadius, 0]],
				[for (step = [0:arcSteps]) [
					d / 2 - filletRadius + filletRadius * cos(-90 + 90 * step / arcSteps),
					filletRadius + filletRadius * sin(-90 + 90 * step / arcSteps)
				]],
				[for (step = [0:arcSteps]) [
					d / 2 - filletRadius + filletRadius * cos(90 * step / arcSteps),
					h - filletRadius + filletRadius * sin(90 * step / arcSteps)
				]],
				[[0, h]]
			));
	}
}

module plainCylinder(sides = $fn) {
	roundedCylinder(d = $diameter, h = $height, sides = sides);
}

module dimpleTexture() {
	dimpleCount = ceil($dimpleCount * $diameter / textureReferenceDiameter);
	difference() {
		plainCylinder();
		for (row = [0:floor($height / $dimpleSpacing) - 1]) {
			z = 3 + row * $dimpleSpacing;
			for (column = [0:dimpleCount - 1]) {
				stagger = (row % 2) * 180 / dimpleCount;
				rotate([0, 0, column * 360 / dimpleCount + stagger])
					translate([$diameter / 2 - 0.2, 0, z])
						sphere(d = $dimpleDiameter, $fn = 16);
			}
		}
	}
}

module waveRibTexture() {
	waveRibCount = ceil($waveRibCount * $diameter / textureReferenceDiameter);
	difference() {
		plainCylinder();
		for (rib = [0:waveRibCount - 1]) {
			for (segment = [0:ceil($height / 2) - 1]) {
				z1 = segment * 2;
				z2 = min(z1 + 2, $height);
				angle1 = rib * 360 / waveRibCount + $waveAmplitude * sin(z1 * 360 / $wavePeriod);
				angle2 = rib * 360 / waveRibCount + $waveAmplitude * sin(z2 * 360 / $wavePeriod);
				point1 = [($diameter / 2 - 0.25) * cos(angle1), ($diameter / 2 - 0.25) * sin(angle1), z1];
				point2 = [($diameter / 2 - 0.25) * cos(angle2), ($diameter / 2 - 0.25) * sin(angle2), z2];
				hull() {
					translate(point1) sphere(d = $waveWidth, $fn = 12);
					translate(point2) sphere(d = $waveWidth, $fn = 12);
				}
			}
		}
	}
}

module honeycombTexture() {
	honeycombCount = ceil($honeycombCount * $diameter / textureReferenceDiameter);
	difference() {
		plainCylinder();
		for (row = [0:ceil($height / $honeycombSpacing) - 1]) {
			z = 3 + row * $honeycombSpacing;
			stagger = (row % 2) * 180 / honeycombCount;
			for (column = [0:honeycombCount - 1]) {
				rotate([0, 0, column * 360 / honeycombCount + stagger])
					translate([$diameter / 2 - $honeycombDepth / 2 + 0.1, 0, z])
						rotate([0, 90, 0])
							cylinder(d = $honeycombSize, h = $honeycombDepth + 0.2, center = true, $fn = 6);
			}
		}
	}
}

module scaleTexture() {
	scaleCount = ceil($scaleCount * $diameter / textureReferenceDiameter);
	difference() {
		plainCylinder();
		for (row = [0:ceil($height / $scaleSpacing) - 1]) {
			z = 2 + row * $scaleSpacing;
			stagger = (row % 2) * 180 / scaleCount;
			for (column = [0:scaleCount - 1]) {
				rotate([0, 0, column * 360 / scaleCount + stagger])
					translate([$diameter / 2 - 0.2, 0, z])
						sphere(d = $scaleDiameter, $fn = 20);
			}
		}
	}
}

module taperedTexture() {
	cylinder(d1 = $diameter, d2 = $taperTopDiameter, h = $height, $fn = $fn);
}

module texturedBody() {
	if ($texture == "Smooth") {
		plainCylinder();
	} else if ($texture == "Dimples") {
		dimpleTexture();
	} else if ($texture == "Wave ribs") {
		waveRibTexture();
	} else if ($texture == "Honeycomb") {
		honeycombTexture();
	} else if ($texture == "Scales") {
		scaleTexture();
	} else if ($texture == "Tapered") {
		taperedTexture();
	} else {
		plainCylinder();
	}
}


module cleaner() {
	difference() {
		texturedBody();

		translate([0, 0, -0.1])
			cylinder(d = $bottomHoleDiameter, h = $bottomHoleDepth + 0.1, $fn = $fn);

		translate([-1.5 * $diameter / 2, -$bottomSlotWidth / 2, -0.1])
			cube([
				1.5 * $diameter,
				$bottomSlotWidth,
				$bottomSlotHeight + 0.1
			]);

		translate([- $bottomSlotWidth / 2, -1.5 * $diameter / 2, -0.1])
			cube([
				$bottomSlotWidth,
				1.5 * $diameter,
				$bottomSlotHeight + 0.1
			]);
	}
}

module base() {
	baseHeight = 6;
	translate([50, 0, 0])
		let($diameter = $baseDiameter, $height = baseHeight)
			texturedBody();

	cleaningNubInset = 2; // How far this top cylinder/nub gets inset (to compensate for the rounding)
	translate([50, 0, baseHeight-cleaningNubInset])
		roundedCylinder(
			d = $bottomHoleDiameter - $bottomSlotWidth - 1,
			h = min($topCylinderHeight, $bottomHoleDepth) + cleaningNubInset,
			sides = $fn
		);
}

cleaner();
base();
