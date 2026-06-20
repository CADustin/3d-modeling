// Clip Parameters
$clipDepth = 40;
$slotThickness = 3.175; // 1/8"

// Shelf Parameters
$wireThickness = 2.32;
$distanceBetweenWires = 13.6;

{} // Prevents the customizer from picking up anything below this

$fn = 100;

difference(){
    // Main Clip Body
    $clipWidth = $distanceBetweenWires + $wireThickness * 3;
    cylinder(h = $clipDepth, d = $clipWidth, center = true);

    // Cut the Body in Half
    translate([0,$clipWidth/4+0.25,0])
    cube([$clipWidth,$clipWidth/2,$clipDepth*1.1], center = true);  
    
    // Cutouts to Clip Onto Wires
    $wireOffset = $distanceBetweenWires/2+ $wireThickness/2;
    translate([$wireOffset,0,0])
    cylinder(h = $clipDepth * 1.1, d = $wireThickness, center = true);
    
    translate([-$wireOffset,0,0])
    cylinder(h = $clipDepth * 1.1, d = $wireThickness, center = true);

    // Cut the Slot for the Dividor
    translate([0,-$distanceBetweenWires/1.5,0])
    cube([$slotThickness,$clipWidth/2,$clipDepth*1.1], center = true);  
}

