//
// taperedHoseAdapter.scad
//
// A hollow, 8-point adapter with adjustable taper length.
//  
// Parameters:
//   thickness     : wall thickness of the adapter
//   topInnerDiameter      : inner diameter at the top
//   topConnectionLength : axial length of the small-end cylinder

//   bottomInnerDiameter      : inner diameter at the bottom
//   bottomConnectionLength : axial length of the large-end cylinder

//   taperLength  : axial length of the topConnectionLengthoped (taper) section
//   $fn            : resolution for rotate_extrude()
//

module taperedHoseAdapter(
    thickness     = 2,
    innerDiameter1      = 20,
    connectionLength1 = 10,
    
    innerDiameter2      = 40,
    connectionLength2 = 5,     // straight section at large end
    
    taperLength  = 15,
    $fn           = 200
) {
    // inner & outer radii
    r_s = innerDiameter1/2;
    r_l = innerDiameter2/2;
    
    // alias local lengths for readability
    sl = connectionLength1;
    tl = taperLength;
    ll = connectionLength2;
    
    // total axial span
    total_len = sl + tl + ll;
 
    // eight‐point cross‐section
    pts = [
      // inner wall, bottom -> top
      [   0,       r_s],            // 0: start inner bottom
      [  sl,       r_s],            // 1: inner horizontal
      [ sl+tl,     r_l],            // 2: diagonal up
      [sl+tl+ll,   r_l],            // 3: inner top horizontal
      
      // outer wall, top -> bottom
      [sl+tl+ll, r_l + thickness],  // 4: outer top vertical
      [ sl+tl,   r_l + thickness],  // 5: outer horizontal back
      [  sl,     r_s + thickness],  // 6: diagonal down
      [   0,     r_s + thickness]   // 7: inner top back to start
    ];

    translate([0, 0, -total_len/2]) // Center the adapter
    rotate_extrude(convexity=10, $fn=$fn)
    rotate([0,0,90]) // Flip the cross section 
    polygon(points=pts, paths=[[0,1,2,3,4,5,6,7]]);

}

module centecHoseAdapter(
    adapterDiameter)
{
    fixedConnectionDiameter = 45.1;
    fixedConnectionLength = 30;
    
    variableConnectionLength = adapterDiameter/2;
    taperLength = adapterDiameter/3;
    
    difference(){
        taperedHoseAdapter(
                thickness = 2, 
                innerDiameter1 = fixedConnectionDiameter, 
                connectionLength1 = fixedConnectionLength, 

                innerDiameter2 = adapterDiameter, 
                connectionLength2 = variableConnectionLength,

                taperLength = taperLength
                );
                    
        $total_len = fixedConnectionLength + variableConnectionLength + taperLength;
        cutoutDia = 10;
        translate([0,0,(-$total_len/2) + cutoutDia/2 + 11]) //9 was not quite enough
        rotate([90,0,0])
        //resize([cutoutDia,cutoutDia*0.75])
        cylinder(h = 100, d = cutoutDia, center = true, $fn = 100);
    }
}

centecHoseAdapter(43);


























