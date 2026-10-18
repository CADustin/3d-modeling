$diameter = 20; // [10:1:40]
$height = 60; // [20:1:100]
$bottomHoleDiameter = 14; // [4:1:18]
$bottomHoleDepth = 25; // [5:1:50]
$topCylinderHeight = 8; // [1:1:50]
$bottomSlotHeight = 10; // [2:1:20]
$bottomSlotWidth = 5; // [2:0.5:10]
$texture = "Smooth"; // [Smooth, Tapered, Scales, Honeycomb, Wave ribs, Dimples]

$dimpleSpacing = 5; // [3:1:10]
$dimpleCount = 16; // [8:2:32]
$dimpleDiameter = 1.6; // [0.8:0.2:3]
$waveRibCount = 8; // [4:1:16]
$waveAmplitude = 14; // [0:2:30]
$wavePeriod = 18; // [8:2:40]
$waveWidth = 1.8; // [0.8:0.2:3]
$honeycombSpacing = 5; // [3:1:10]
$honeycombCount = 16; // [8:2:32]
$honeycombSize = 2.6; // [1.5:0.5:4]
$honeycombDepth = 2.5; // [1:0.5:5]
$scaleSpacing = 3; // [2:0.5:8]
$scaleCount = 16; // [8:2:32]
$scaleDiameter = 3.5; // [2:0.5:6]
$taperTopDiameter = 16; // [8:1:32]

$fn = 64;
textureReferenceDiameter = $diameter;

module plainCylinder(sides = $fn) {
	cylinder(d = $diameter, h = $height, $fn = sides);
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
	translate([50, 0, 0])
		let($diameter = 40, $height = 6)
			texturedBody();

	translate([50, 0, 6])
		cylinder(
			d = $bottomHoleDiameter - $bottomSlotWidth - 1,
			h = min($topCylinderHeight, $bottomHoleDepth),
			$fn = $fn
		);
}

cleaner();
base();
