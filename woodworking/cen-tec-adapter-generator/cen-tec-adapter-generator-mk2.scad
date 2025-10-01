module cenTecHoseAdapter(
    topDia       = 25,
    topDiaIsForOutter = false,
    topLen       = 30,
    thickness    = 2,
    taperLength  = 15,
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
        [$br+thickness, $bl+$cutoutHeight],
        [$br-$cutoutDepth+thickness, $bl+$cutoutHeight],
        [$br-$cutoutDepth+thickness, $bl+thickness],
        [$br+thickness, $bl+thickness],
        [$br+thickness,0],
    ];

    $startingOfCutout = $totalLen/2-$cutoutHeight/2-$bl-thickness/2;

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
    
    $ringThickness = 3;
    $suctionRingHeight = $cutoutHeight - 0.1;
    color("green")
    rotate([0,0,15])
    translate([0,0,-$startingOfCutout - $suctionRingHeight/2 - 1])
    rotate_extrude(angle = 325)
    polygon([[$br-thickness-0.8,thickness],[$br,thickness], [$br,$suctionRingHeight], [$br-thickness-0.8,$suctionRingHeight]]);
}



cenTecHoseAdapter(
    topDia       = 32,
    topLen       = 10,
    thickness    = 2,
    taperLength  = 15,
    fn = 100);











