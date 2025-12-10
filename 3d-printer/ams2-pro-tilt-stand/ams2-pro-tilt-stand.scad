include <BOSL2/std.scad>;

amsDepth = 245; // Hyp
angle = 15; // ang

$fn = 40;

rise = hyp_ang_to_opp(amsDepth, angle); // Opp
echo (rise);

run = hyp_ang_to_adj(amsDepth, angle); // Adj
echo (run);

// Define triangle points
p0 = [0, 0];            // origin
p1 = [run, 0];          // adjacent side
p2 = [run, rise];        // opposite side

rotate([0,0,90-angle])
difference(){
linear_extrude(40)
polygon(round_corners(
    path=[p0, p1, p2],
    radius=2,         // radius of rounding
    closed=true
));


sF = 0.8;

translate([40,5,0])
linear_extrude(70)
scale([sF,sF,sF]){
    #polygon(round_corners(
        path=[p0, p1, p2],
        radius=2,         // radius of rounding
        closed=true
    ));
}
}

nubDepth = 38;
nubThickness = 11;
frontTo1stNub = 29;
translate([0,frontTo1stNub,0])
rotate([0,0,90])
cube([nubDepth, 20, nubThickness]);

frontTo2ndNub = 204;
translate([0,frontTo2ndNub,0])
rotate([0,0,90])
cube([nubDepth, 20, nubThickness]);