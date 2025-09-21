include <BOSL2/std.scad>
include <../common/functions.scad>

// The number of magazines wide that you want to store.
$numberOfMagazinesWide = 4;

// The number of magazines deep that you want to store.
$numberOfMagazinesDeep = 2;

// The height of the magazine holder (in mm).
$holderHeight = 60; // [25:150]

// The thickness of the front, left, and right sides of the holder (in mm).
$holderThickess = 3;

// The width of the magazine (in mm).
$magazineWidth = 15; // [7:200]

// The magazine depth (in mm).
$magazineDepth = 36; // [7:200]

// The amount og spacing between each magazine (in mm).
$magazineSpacing = 4; // [2:12]

// The depth of the magnet holes, set to 0mm for no magnets (in mm).
$magnetDepth = 2; // [0:3]

// The diameter of the magnets.
$magnetDiameter = 12; // [5:12]

magazineHolder($numberOfMagazinesDeep, $numberOfMagazinesWide, $holderHeight, $holderThickess, $magazineWidth, $magazineDepth, $magazineSpacing);

// Module: magazineHolder
// Creates a customizable magazine holder with slots for multiple magazines and optional magnet cutouts.
// The holder consists of a rounded cuboid base, magazine slots, and holes for magnets.
//
// Parameters:
// - magazinesDeep (number): Number of magazines to store in depth (Y direction).
// - magazinesWide (number): Number of magazines to store in width (X direction).
// - holderHeight (number): Height of the magazine holder in mm.
// - holderThickess (number): Thickness of the magazine holder in mm.
// - magazineWidth (number): Width of each magazine in mm.
// - magazineDepth (number): Depth of each magazine in mm.
// - spacing (number): Space between magazines in mm.
//
// Behavior:
// - Generates a base with pins using accessoryBaseWithPins.
// - Arranges magazine slots in a grid pattern.
// - Adds rounded corners to the holder.
// - Optionally creates cylindrical cutouts for magnets along the front edge.
module magazineHolder(magazinesDeep, magazinesWide, holderHeight, holderThickess, magazineWidth, magazineDepth, spacing){
    
    difference(){
        $totalWidth = (magazinesWide - 1) * (magazineWidth + spacing) + magazineWidth + holderThickess*2;
        $totalDepth = magazinesDeep * (magazineDepth + spacing) + holderThickess;
        
        $cutoutDirection = $magazineWidth < $magazineDepth;
        
        group(){
            color("blue")
            translate([0,-$totalDepth/2,0])
            accessoryBaseWithPins($totalWidth-4, holderHeight-4, 0);

            cuboid([$totalWidth, $totalDepth, holderHeight], rounding = 2, $fn = 50);
        }
        
        $startingX = $totalWidth/2 - magazineWidth - holderThickess;
        $startingY = -$totalDepth/2 + spacing;
        for(i = [0 : magazinesWide - 1]){
            for(j = [0 : magazinesDeep - 1]){
                $newX = $startingX - i * (magazineWidth + spacing);
                $newY = j * (magazineDepth + spacing);
                translate([$newX, $startingY + $newY,-holderHeight/2+3])
                #cube([magazineWidth,magazineDepth,holderHeight]);
                
                if(i == 1 && $cutoutDirection) {
                    //translate([-$startingX+spacing,$startingY + $newY + magazineDepth/6,-holderHeight/2+3])
                   
                    translate([-$startingX - magazineWidth,$startingY + $newY + magazineDepth/6,-holderHeight/2+3])
                    #cube([$totalWidth-holderThickess*2,magazineDepth*2/3,holderHeight]);
                }
                
                if(j == 0 && !$cutoutDirection) {
                   // translate([$newX + magazineWidth/6,$startingY,-holderHeight/2+3])
                    translate([$newX + magazineWidth/6,$startingY,-holderHeight/2+3])
                    #cube([magazineWidth*2/3,$totalDepth-holderThickess-spacing,holderHeight]);
                }
            }
        }
        
        numPinsY = calculateRowsOfPins(holderHeight);
        
        magnetSpacingOffset = (numPinsY % 2)*pinDiameter();
        
        magnetCutouts = max(1, magazinesWide-1);
        $magnetSpacing = ($totalWidth - (magnetCutouts * $magnetDiameter))/(magnetCutouts+1);
        
        $startingCutoutX = -$totalWidth/2+$magnetDiameter/2 + $magnetSpacing;
        for(i = [0 : magnetCutouts-1]){
            translate([i*($magnetSpacing+$magnetDiameter)+$startingCutoutX,-$totalDepth/2 + $magnetDepth/2,magnetSpacingOffset])
            rotate([90,0,0])
            #cylinder(h = $magnetDepth, d = $magnetDiameter, center = true);
            
        }
    }
}
