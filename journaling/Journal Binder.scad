// Overall Length of the tool (in mm).
$overallLength = 292; // [200:520]

// The width/height of the tool (in mm).
$width = 32; // [30:40]

// The total width of the center cutout at its highest point on the model (in mm).
$cutoutWidth = 28; // [22:30]

// The height of the lip inside the sloped area (in mm).
$lipHeight = 2; // [0:8]

// The width of the center punch slot (in mm).
$punchSlotWidth = 4; // [3:12]

// The thickness of the donut (in mm).
$donutThickness = 8; // [4:12]

// The donut sqush factor.
$donutSqushFactor = 0.5; // [0.4:0.1:1]

// The diameter of the holes (in mm).
$holeDiameter = 3.5;

// The edge to edge gap between the holes (in mm).
$edgeGapBetweenHoles = 9;
        
//// Smoothness (lower numbers may help improve print time).
$fn = 50; // [16:128]

{}

// When we specify the width of the cutout, we're really taking 
// in the diagonal length of a square ... so we need to know how
// long the sides of that square is (or the hypotenuse of the right
// triangle) ... to get that we can use (diagonal length) / sqrt(2).
$cubSides = $cutoutWidth/sqrt(2);

translate([0,0,$width/2])
difference(){
    // Main Body
    group(){
        color("lightblue")
        minkowski() {
            // Main body of the tool.
            cube([$width,$overallLength,$width], center = true);
            
            // The second function (after cube) defined in a minkowski
            // applies itself to the first function's (the cube) edges 
            // -- so this effectively makes a round cube.
            sphere(2);
        }

        outer_diameter = $width-$donutThickness;

        // Create the doughnut
        color("lightgreen")
        translate([0,-$overallLength/2 + $donutThickness,$width/2])
        rotate([90,0,0])
        scale([1,1,$donutSqushFactor]) {
            rotate_extrude(angle = 360) {
                
                translate([(outer_diameter)/2, 0, 0])
                circle(d = $donutThickness);
            }
        }
    }
    
    // Cutouts
    group() {
        translate([0,12,$width/2-$lipHeight/2+1])
        difference(){
            group(){
           
                // Main body of the top triangular cutout area
                rotate([0,45,0])
                cube([$cubSides,$overallLength,$cubSides], center = true);
                
                // The top inset part of the Punch Cutout
                color("green")
                translate([0,0,$lipHeight/2])
                cube([$cutoutWidth,$overallLength,$lipHeight], center = true);
                
                // Punch Slot Cutout
                color("blue")
                cube([$punchSlotWidth,$overallLength,$width*1.5], center = true);
            }
            
            // Slice off all extra geometry
            translate([0,0,$lipHeight+$width/2])
            cube([$cutoutWidth*sqrt(2),$overallLength*1.1,$width], center = true);
        }
    }
}

translate([$width*1.5,0,-$lipHeight/2])
rotate([180,0,0])
difference() {
    $topPieceLength = $overallLength - ($donutThickness + $donutThickness*$donutSqushFactor);

    rotate([0,45,0])
    cube([$cubSides,$topPieceLength,$cubSides], center=true);

    // Slice off all extra geometry
    translate([0,0,$width/2])
        cube([$cutoutWidth*sqrt(2),$topPieceLength*1.1,$width], center=true);

    $holePitch = $edgeGapBetweenHoles + $holeDiameter;
    $holeCount = floor( ($topPieceLength + $edgeGapBetweenHoles) / $holePitch ) - 2;
    for (i = [0:$holeCount-1]) {
        translate([0, -(($holeCount-1)*$holePitch)/2 + i*$holePitch, 0])
                cylinder(d=$holeDiameter, $width*2, center=true, $fn=48);
    }

}
