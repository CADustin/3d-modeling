// The number of slots to cut to hold edge banding
$slots = 5; // [1:8]

// The width of each slot
$slotWidth = 28; // [20:50]

// The height of each slot
$slotHeight = 50; // [25:100]

// The spacing between each slot
$slotToSlotSpacing = 20; // [10:30]

// The thickness of the mount
$thickness = 10; // [6:20]

// The thickness of the mount that gets mounted to the ceiling.
$mountThickness = 4; // [3:10]

// The width of the mount that gets mounted to the ceiling.
$mountWidth = 50; // [40:100]

{}

include <BOSL2/std.scad>

$mountHeight = $slotHeight + $thickness*2;
$totalWidth = ($slots * $slotWidth) + (($slots + 1) * $slotToSlotSpacing);

difference(){
    // The top part of the map that mounts to the ceiling
    translate([0,0,-($slotHeight + $thickness*2)/2])
    cube([$totalWidth, $mountWidth, $mountThickness], center = true);

    // The screw hole size
    $screwHoleRadius = 1.8;
    $screwHeadRadius = 4.8;
    
    // How many screw holes should be cut
    $screwHoles = ceil($slots / 2);
    $screwSpacing = $totalWidth / ($screwHoles + 1);
    $yScrewOffset = ($mountWidth/2 - $thickness);
    
    // Cut out all of the screw holes
    for(i = [1:1:$screwHoles]){
        translate([$totalWidth/2 - $screwSpacing * i,$yScrewOffset,-$mountHeight/2])
        cylinder($mountThickness*1.5, $screwHoleRadius, $screwHeadRadius, center = true); 
        
        translate([$totalWidth/2 - ($screwSpacing * i),-$yScrewOffset,-$mountHeight/2])
        cylinder($mountThickness*1.5, $screwHoleRadius, $screwHeadRadius, center = true); 
    }    
}

difference() {
    // The overall main body of the holder
    cuboid([$totalWidth, $thickness, $mountHeight], rounding = 5, edges = [TOP]);
    
    // Cut each slot
    $xOffsetForAllSlots = ($totalWidth - ($slotWidth + $slotToSlotSpacing*2))/2;
    $zOffsetForAllSlots = $thickness/2 - $thickness;
    for(i = [0:1:$slots - 1]){
        $xOffsetForThisLot = i*($slotToSlotSpacing + $slotWidth);
        translate([$xOffsetForAllSlots - $xOffsetForThisLot, 0, $zOffsetForAllSlots])
        cube([$slotWidth, $thickness*1.2, $slotHeight], center = true);
    }
}