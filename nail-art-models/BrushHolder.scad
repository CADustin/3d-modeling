// User Parameters
baseWidth = 90;
baseDepth = 70;
baseThickness = 10;

viewMode = "separated"; // [separated, assembledUp, assembledFolded]

{}

topThickness = 6;
foldClearance = -2;

sideWallThickness = 3;
topSideWallGap = 0.2;
pinLength = 5;
pinSocketClearance = 0.6;
socketInsetFromNegativeY = 4;
topPinY = 0;
separatedTopOffset = [100,100,0];
topPrintFlipX = 180;
assembledUpXAngle = 180;
assembledFoldedXAngle = 90;
assembledUpYAngle = 0;
assembledFoldedYAngle = 0;

// Internal Calculations
pinDiameter = baseThickness - 4;
pinSocketDiameter = pinDiameter + pinSocketClearance;
pinSocketY = -(baseDepth/2 - pinSocketDiameter/2 - socketInsetFromNegativeY);
topHeight = baseDepth - foldClearance;
topHoleDiameter = baseThickness - 4;
pinSocketDepth = pinLength + 0.6;
pinLeadInDepth = 2;
pinLeadInDiameter = pinSocketDiameter + 2;
topPinZ = topHeight - sideWallThickness/2 - sideWallThickness*2;
pinSocketZ = 0;

baseGrooveWidth = 55;
baseGrooveDepth = 2;
baseGrooveZ = 2;
baseGroove1InsetFromPositiveY = 4;
baseGroove2InsetFromPositiveY = 20;
baseGroove3InsetFromPositiveY = 40;


module basePiece(){
	difference(){
		cube([baseWidth, baseDepth, baseThickness], center = true);

		translate([0, baseDepth/2 - baseGroove1InsetFromPositiveY, baseGrooveZ])
		cube([baseGrooveWidth, baseGrooveDepth, baseThickness], center = true);

		translate([0, baseDepth/2 - baseGroove2InsetFromPositiveY, baseGrooveZ])
		cube([baseWidth*1.1, baseGrooveDepth, baseThickness], center = true);
		
		translate([0, baseDepth/2 - baseGroove3InsetFromPositiveY, baseGrooveZ])
		cube([baseWidth*1.1, baseGrooveDepth, baseThickness], center = true);

		translate([baseWidth/2 - pinSocketDepth/2 + 0.01, pinSocketY, pinSocketZ])
		rotate([0,90,0])
		cylinder($fn=50, h=pinSocketDepth, d=pinSocketDiameter, center=true);

		translate([baseWidth/2 - pinLeadInDepth/2 + 0.01, pinSocketY, pinSocketZ])
		rotate([0,90,0])
		cylinder($fn=50, h=pinLeadInDepth, d1=pinLeadInDiameter, d2=pinSocketDiameter, center=true);

		translate([-(baseWidth/2 - pinSocketDepth/2 + 0.01), pinSocketY, pinSocketZ])
		rotate([0,90,0])
		cylinder($fn=50, h=pinSocketDepth, d=pinSocketDiameter, center=true);

		translate([-(baseWidth/2 - pinLeadInDepth/2 + 0.01), pinSocketY, pinSocketZ])
		rotate([0,90,0])
		cylinder($fn=50, h=pinLeadInDepth, d1=pinLeadInDiameter, d2=pinSocketDiameter, center=true);
	}
}

module topPiece(){
	group(){
		// Top
		difference(){
			cube([baseWidth, baseThickness, topThickness], center = true);

			// Left
			translate([baseWidth/3, 0, 0])
			cylinder($fn=50, h=topThickness*1.1, d=topHoleDiameter, center=true);

			// Middle
			cylinder($fn=50, h=topThickness*1.1, d=topHoleDiameter, center=true);
			
			// Right
			translate([-baseWidth/3, 0, 0])
			cylinder($fn=50, h=topThickness*1.1, d=topHoleDiameter, center=true);
		}

		// Top, Side 1
		translate([baseWidth/2 + sideWallThickness/2 + topSideWallGap,0,topHeight/2 - topThickness/2])
		cube([sideWallThickness, baseThickness, topHeight], center=true);

		translate([
			baseWidth/2 + sideWallThickness/2 + topSideWallGap - pinLength/2,
			topPinY,
			topPinZ
		])
		rotate([0,90,0])
		cylinder($fn=50, h=pinLength, d=pinDiameter, center=true);

		// Top, Side 2
		translate([-(baseWidth/2 + sideWallThickness/2 + topSideWallGap),0,topHeight/2 - topThickness/2])
		cube([sideWallThickness, baseThickness, topHeight], center=true);

		translate([
			-(baseWidth/2 + sideWallThickness/2 + topSideWallGap) + pinLength/2,
			topPinY,
			topPinZ
		])
		rotate([0,90,0])
		cylinder($fn=50, h=pinLength, d=pinDiameter, center=true);
	}
}

module topPieceAssembled(xAngle=0, yAngle=0){
	translate([0, pinSocketY, pinSocketZ])
	rotate([xAngle,yAngle,0])
	translate([0, -topPinY, -topPinZ])
	topPiece();
}

if(viewMode == "separated"){
	basePiece();
	translate(separatedTopOffset)
	rotate([topPrintFlipX,0,0])
	topPiece();
} else if(viewMode == "assembledUp"){
	basePiece();
	topPieceAssembled(assembledUpXAngle, assembledUpYAngle);
} else if(viewMode == "assembledFolded"){
	basePiece();
	topPieceAssembled(assembledFoldedXAngle, assembledFoldedYAngle);
} else {
	echo("Unknown viewMode. Use separated, assembledUp, or assembledFolded.");
	basePiece();
}