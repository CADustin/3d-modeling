// The width (in mm) of the miter slot that the jig will rest within.
$miterSlotWidth = 19; // [12:20]

// The depth (in mm) of the miter slot that the jig will rest within.
$miterSlotDepth = 9.5; // [6:0.5:19]

// The length (in mm) of the jig that rests in the miter slot.
$miterSlotLength = 100; // [25:25:150]

// The cutout size (in mm) that the jig is intended to help create.
$jigCutoutLength = 75; // [25:10:300]

// The width of the cutout (in mm) the jig will help create
$jigCutoutWidth = 24; // [12:0.5:25]

// The width (in mm) of the entire Jig, the wider the easier it is to rest the router on.
$jigWidth = 50; // [50:25:150]

// The thickness (in mm) of the jig.
$jigThickness = 6; // [6:25]

{}

rotate([0,180,0])    
group(){
    // Miter slot piece
    color("blue")
    cube([$miterSlotWidth, $miterSlotLength, $miterSlotDepth], center = true);

    difference(){
        $oal = $miterSlotLength + $jigCutoutLength + 20;
        
        // The top part of the jig where the router will rest.
        color("green")
        translate([0,($oal-$miterSlotLength)/2,($jigThickness+$miterSlotDepth)/2])
        cube([$jigWidth, $oal, $jigThickness], center = true);
            
        // The cutout for the jig
        translate([0,$oal/2,0])
        cube([$jigCutoutWidth, $jigCutoutLength, $jigThickness*10], center = true);
    }
}