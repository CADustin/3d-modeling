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

/*
Module: cenTecHoseAdapter
Purpose:
- Generate a 3D printable adapter that connects to a Cen-tec hose and provides a top connection with optional inner/outer diameter interpretation,
  a tapered section, and an airflow/suction adjustment cutout and ring.

Parameters:
- topDia (number, default 25) — Top diameter. Interpreted as inner or outer depending on `topDiaIsForOutter`.
- topDiaIsForOutter (bool, default false) — If true, `topDia` is treated as the outer diameter and reduced by `thickness` to compute inner diameter.
- topLen (number, default 30) — Length of the top section.
- thickness (number, default 2) — Wall thickness used for offsets and the ring.
- taperLength (number, default 15) — Length of the tapered transition between bottom and top.
- printFlowRingInline (bool, default true) — If true, the suction/flow ring is printed inline; otherwise, positioned separately.
- fn (number, default 100) — The $fn setting used for cylinder detail.

Example:
- cenTecHoseAdapter(topDia = topDiameter, topDiaIsForOutter = topDiameterIsForOutter, topLen = topLength, thickness = topThickness, taperLength = taperLength, printFlowRingInline = printAirFlowRingInline, fn = 100);
*/
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
    if (topDiaIsForOutter) {
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
    
    // Suction adjustment ring
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

/*
Module: knurl
Purpose:
- Create a simple knurled ring by placing small rectangular teeth around a given ring radius and ring height.

Parameters:
- tooth_width (number, default 1.5) — Width of each tooth.
- tooth_height (number, default 1) — Height of each tooth.
- ring_radius (number, default 30) — Radial distance from the center to place teeth.
- ring_height (number, default 10) — Height of the knurled ring (Z size).

Behavior / Notes:
- Places teeth at angles from 15° to 285° in 10° steps.
- Each tooth is a small rotated cube placed at `ring_radius` and offset up by half the ring height plus tooth height to sit on the ring.
- The rotation on each tooth creates the angled knurl appearance.
- Designed to be used by `cenTecHoseAdapter` to provide grip on the airflow ring.
*/
module knurl(tooth_width=1.5, tooth_height=1, ring_radius=30, ring_height=10) {
    for (angle = [15 : 10 : 285]) {
        rotate([0, 0, angle])
        translate([ring_radius, 0, ring_height/2+tooth_height])
        rotate([45, 0, 0])
        cube([tooth_width, tooth_width, ring_height], center=true);
    }
}