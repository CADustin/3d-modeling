$baseWidth = 90;
$baseDepth = 70;
$baseThickness = 9;

{}

$topDepth = 20;
$topThickness = 6;
$topHeight = 75;

$sideWallThickness = 3;
$topSideWallGap = 0.4;
$pinDiameter = 10;
$pinLength = 5;
$pinSocketClearance = 0.6;
$pinSocketDiameter = $pinDiameter + $pinSocketClearance;
$pinSocketDepth = $pinLength + 0.6;
$pinLeadInDepth = 2;
$pinLeadInDiameter = $pinSocketDiameter + 2;
topPinY = 0;
$socketInsetFromNegativeY = 4;
$pinSocketY = -($baseDepth/2 - $pinSocketDiameter/2 - $socketInsetFromNegativeY);
$topPinZ = $topHeight - $sideWallThickness/2 - $sideWallThickness*2;
$socketAxisZ = 0;
$pinSocketZ = $socketAxisZ;
viewMode = "separated"; // [separated, assembledUp, assembledFolded]
$separatedTopOffset = [100,100,0];
$topPrintFlipX = 180;
$assembledUpXAngle = 180;
$assembledFoldedXAngle = 90;
$assembledUpYAngle = 0;
$assembledFoldedYAngle = 0;


module basePiece(){
	difference(){
		cube([$baseWidth, $baseDepth, $baseThickness], center = true);

		translate([0,$baseDepth/2 - 4,2])
		#cube([55, 2, $baseThickness], center = true);

		translate([0,$baseDepth/2 - 20,2])
		#cube([$baseWidth*1.1, 2, $baseThickness], center = true);
		
		translate([0,$baseDepth/2 - 40,2])
		#cube([$baseWidth*1.1, 2, $baseThickness], center = true);

		translate([$baseWidth/2 - $pinSocketDepth/2 + 0.01, $pinSocketY, $pinSocketZ])
		rotate([0,90,0])
		cylinder($fn=50, h=$pinSocketDepth, d=$pinSocketDiameter, center=true);

		translate([$baseWidth/2 - $pinLeadInDepth/2 + 0.01, $pinSocketY, $pinSocketZ])
		rotate([0,90,0])
		cylinder($fn=50, h=$pinLeadInDepth, d1=$pinLeadInDiameter, d2=$pinSocketDiameter, center=true);

		translate([-($baseWidth/2 - $pinSocketDepth/2 + 0.01), $pinSocketY, $pinSocketZ])
		rotate([0,90,0])
		cylinder($fn=50, h=$pinSocketDepth, d=$pinSocketDiameter, center=true);

		translate([-($baseWidth/2 - $pinLeadInDepth/2 + 0.01), $pinSocketY, $pinSocketZ])
		rotate([0,90,0])
		cylinder($fn=50, h=$pinLeadInDepth, d1=$pinLeadInDiameter, d2=$pinSocketDiameter, center=true);
	}
}

module topPiece(){
	group(){
		// Top
		difference(){
			cube([$baseWidth, $topDepth, $topThickness], center = true);

			// Left
			translate([$baseWidth/3, 0, 0])
			#cylinder($fn=50, h=$topThickness*1.1, d = 10, center = true);

			// Middle
			#cylinder($fn=50, h=$topThickness*1.1, d = 15, center = true);
			
			// Right
			translate([-$baseWidth/3, 0, 0])
			#cylinder($fn=50, h=$topThickness*1.1, d = 10, center = true);
		}

		// Top, Side 1
		translate([$baseWidth/2 + $sideWallThickness/2 + $topSideWallGap,0,$topHeight/2 - $topThickness/2])
		cube([$sideWallThickness, $topDepth, $topHeight], center=true);

		translate([
			$baseWidth/2 + $sideWallThickness/2 + $topSideWallGap - $pinLength/2,
			topPinY,
			$topPinZ
		])
		rotate([0,90,0])
		cylinder($fn=50, h=$pinLength, d=$pinDiameter, center=true);

		// Top, Side 2
		translate([-($baseWidth/2 + $sideWallThickness/2 + $topSideWallGap),0,$topHeight/2 - $topThickness/2])
		cube([$sideWallThickness, $topDepth, $topHeight], center=true);

		translate([
			-($baseWidth/2 + $sideWallThickness/2 + $topSideWallGap) + $pinLength/2,
			topPinY,
			$topPinZ
		])
		rotate([0,90,0])
		cylinder($fn=50, h=$pinLength, d=$pinDiameter, center=true);
	}
}

module topPieceAssembled(xAngle=0, yAngle=0){
	translate([0, $pinSocketY, $pinSocketZ])
	rotate([xAngle,yAngle,0])
	translate([0, -topPinY, -$topPinZ])
	topPiece();
}

if(viewMode == "separated"){
	basePiece();
	translate($separatedTopOffset)
	rotate([$topPrintFlipX,0,0])
	topPiece();
} else if(viewMode == "assembledUp"){
	basePiece();
	topPieceAssembled($assembledUpXAngle, $assembledUpYAngle);
} else if(viewMode == "assembledFolded"){
	basePiece();
	topPieceAssembled($assembledFoldedXAngle, $assembledFoldedYAngle);
} else {
	echo("Unknown viewMode. Use separated, assembledUp, or assembledFolded.");
	basePiece();
}