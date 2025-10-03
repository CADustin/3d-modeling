module cenTecHoseAdapter(
    topDia       = 25,
    topDiaIsForOutter = false,
    topLen       = 30,
    thickness    = 2,
    taperLength  = 15,
    printFlowRingInline = true,
    fn = 100
) {
    // If the inn
    if(topDiaIsForOutter) {
        topDia = topDia - thickness;
    }
    
    // Variables to control the bottom part, I.e., that connects to the Cen-tec hose.
    $bottomDia = 45.1;
    $bottomLen = 30;

    // The cutout size for the suction adjustment.
    $cutoutDepth = 5;
    $cutoutHeight = 10 + thickness;

    $br = $bottomDia/2;
    $tr = topDia/2;

    $bl = $bottomLen;
    $tl = topLen;

    $fn = fn;

    $totalLen = $bl+$cutoutHeight+3+taperLength+$tl;

    // The points used to render the polygon
    pts = [
        [$br,0],
        [$br, $bl],
        [$br-$cutoutDepth, $bl],
        [$br-$cutoutDepth, $bl+$cutoutHeight+thickness],
        //[$br, $bl+$cutoutHeight+$thickness],
        //[$br, $bl+$cutoutHeight+3],
        [$tr, $bl+$cutoutHeight+3+taperLength],
        [$tr, $bl+$cutoutHeight+3+taperLength+$tl],

        [$tr+thickness, $bl+$cutoutHeight+3+taperLength+$tl],
        [$tr+thickness, $bl+$cutoutHeight+3+taperLength],
        [$br+thickness, $bl+$cutoutHeight+3],
        [$br+thickness, $bl+$cutoutHeight],                 /////////
        [$br-$cutoutDepth+thickness, $bl+$cutoutHeight],    /////////
        [$br-$cutoutDepth+thickness, $bl+thickness],
        [$br+thickness, $bl+thickness],
        [$br+thickness,0],
    ];

    $startingOfCutout = $totalLen/2-$cutoutHeight/2-$bl-thickness/2;

    rotate([180,0,0])
    difference(){
        // Render the adapter body
        translate([0, 0, -$totalLen/2]) // Center the adapter
        rotate_extrude(angle = 360, convexity = 10)
        polygon(pts);

        // Suction adustment hole
        translate([$bottomDia/2,0,-$startingOfCutout])
        cube([$bottomDia/2,15,8], center = true);

        // Connection point hole
        cutoutDia = 10;
        
        translate([0,0,(-$totalLen/2) + cutoutDia/2 + 11]) //9 was not quite enough
        rotate([90,0,0])
        group(){
            cylinder(h = 100, d = cutoutDia, center = true, $fn = 100);
         
            translate([0,3,0])
            cube([10,6,100], center = true);
        }
    }
    
    

    $ringThickness = 0;
    $suctionRingHeight = $cutoutHeight - 0.5;
    
    $ringYPosition = printFlowRingInline ? 0 : 60;
    $ringZPosition = printFlowRingInline ? -$startingOfCutout - $suctionRingHeight/2 - 1 : -$totalLen/2 - thickness;

    color("green")
    rotate([0,0,15+90])
    translate([0,0,$ringZPosition])
    
    difference() {
        rotate_extrude(angle = 300)
        polygon([[$br-thickness-0.8,thickness],[$br + $ringThickness,thickness], [$br+ $ringThickness,$suctionRingHeight], [$br-thickness-0.8,$suctionRingHeight]]);
        
        knurl(tooth_width=0.6, tooth_height=0.8, ring_radius=$br + $ringThickness, ring_height=$suctionRingHeight);
    }
}

// The top diameter of the top dust adapter.
topDiameter = 32; // [10:55]

// True calculates the size assuming the "topDiameter" is the Outter Diameter -- otherwise, its treated as the Inner Diameter.
topDiameterIsForOutter = false;

// The top part of the adapter's length (in mm).
topLength = 10; // [5:100]

// The thickness of the top part of the adapter (in mm).
topThickness = 2; // [1:8]

// The length of the taper between the lower and upper part of the adapter (in mm).
taperLength = 15; // [0:25]

// True prints the Airflow control ring inline.
printAirFlowRingInline = false;

cenTecHoseAdapter(
    topDia       = topDiameter,
    topDiaIsForOutter = topDiameterIsForOutter,
    topLen       = topLength,
    thickness    = topThickness,
    taperLength  = taperLength,
    printFlowRingInline = printAirFlowRingInline,
    fn = 100);



module knurl(tooth_width=1.5, tooth_height=1, ring_radius=30, ring_height=10) {
    for (angle = [15 : 10 : 285]) {
        rotate([0, 0, angle])
        translate([ring_radius, 0, ring_height/2+tooth_height])
        rotate([45, 0, 0])
        cube([tooth_width, tooth_width, ring_height], center=true);
    }
}




