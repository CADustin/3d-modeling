/* [Lint Roll] */
///////////////////////////////////////////////////////////////////
// The inner diameter of the cardboard tube (in mm).
$rollerTubeDiameter = 38.2;

// The Length of the roller tube (in mm).
$rollerTubeLength = 100;

// The Outter Diameter of the roller with all sheets (in mm).
$rollerTubeOutterDiameter = 70; // [30:90]

/* [Pieces to generate] */
///////////////////////////////////////////////////////////////////
// Generate the top shell (aka the Lid).
$topShell = true;

// Generate the bottom shell.
$bottomShell = true;

// Generate the roller caps (they are pressed into the tube of the lint roll).
//$rollerCaps = true;

{}

/* [Misc. properties] */
// The size in mm for the pins on the end of the tubes (in mm).
$pinSizeForTubeEnds = 5; // [3:6]

 // The thichness of the walls
$wallThickness = 2;

// The wiggleroom for the lid ... this seems to be fairly easy to pop apart (2025/03/23).
$wiggleRoom = 1; 


// Geherate an octagon of a certain width (between the flat edges).
///////////////////////////////////////////////////////////////////
module octagon(width) {
    sides = 8; // Number of sides for the octagon
    radius = width / sqrt(2 + sqrt(2)); // Adjusted radius for accurate width
    polygon(
        points=[
            for (i = [0:sides-1])
                [radius * cos(i * 360 / sides), radius * sin(i * 360 / sides)]
        ]
    );
}



// Generate the shell of an octagon.
///////////////////////////////////////////////////////////////////
module OctagonShell(rollerTubeLength, rollerTubeOutterDiameter, wallThickness) {
    difference() {
        // Outter Extruded Octogon
        linear_extrude(height = rollerTubeLength + (wallThickness * 2) * 2, center = true)
        octagon(rollerTubeOutterDiameter+(wallThickness*2));

        // Cutout of the center of the Outter Octogon
        linear_extrude(height = rollerTubeLength + 4, center = true)
        octagon(rollerTubeOutterDiameter);

        // Cutoff more than half so its an open cavity
        rotate([0,0,22.5])
        translate([rollerTubeOutterDiameter*.6,0,0])
        cube([rollerTubeOutterDiameter, rollerTubeOutterDiameter*1.5, rollerTubeLength *1.2], center = true);
    }
}



// Outside Shell
///////////////////////////////////////////////////////////////////
if($topShell) {
    rotate([0,-90,0])
    rotate([0,0,-22.5])
    group() {
        $oal = $rollerTubeLength + ($wallThickness * 2) + $wiggleRoom;
        OctagonShell($oal, $rollerTubeOutterDiameter + ($wallThickness * 2) + $wiggleRoom, $wallThickness);

        // Add pins to the ends
        color("red")
        translate([0,0,($oal + $pinSizeForTubeEnds)/2])
        difference(){
            sphere($fn=25, d = $pinSizeForTubeEnds * 0.9);
            translate([0,0,$pinSizeForTubeEnds * 0.9])
            cube(size=$pinSizeForTubeEnds*2, center = true);
        }
                    
        color("blue")
        translate([0,0,-($oal+$pinSizeForTubeEnds)/2])
        difference(){
            sphere($fn=25, d = $pinSizeForTubeEnds * 0.9);
            translate([0,0,-$pinSizeForTubeEnds * 0.9])
            cube(size=$pinSizeForTubeEnds*2, center = true);
        }
    }
}



// Inside Shell
///////////////////////////////////////////////////////////////////
if($bottomShell) {   
    translate([0, $rollerTubeOutterDiameter + $wallThickness*4, -($wallThickness + $wiggleRoom/2)])
    rotate([0,-90,0])
    rotate([0,0,-22.5])
    difference() {
        // Main Body
        group() {
            OctagonShell($rollerTubeLength, $rollerTubeOutterDiameter, $wallThickness);

            // Add pins to the ends
            color("red")
            translate([0,0,($rollerTubeLength + $pinSizeForTubeEnds)/2])
            sphere($fn=25, d = $pinSizeForTubeEnds * 0.9);
                    
            color("blue")
            translate([0,0,-($rollerTubeLength + $pinSizeForTubeEnds)/2])
            sphere($fn=25, d = $pinSizeForTubeEnds * 0.9);
        }

        // Inner Cover Pin Cutouts
        translate([0,0,($rollerTubeLength + 10)/2]) sphere($fn=25, d = $pinSizeForTubeEnds);
        translate([0,0,-($rollerTubeLength + 10)/2]) sphere($fn=25, d = $pinSizeForTubeEnds);
    }
}