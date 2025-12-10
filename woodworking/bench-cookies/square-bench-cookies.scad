include <BOSL2/std.scad>
include <BOSL2/threading.scad>

diameter = 75;
thickness = 20;

cutoutDepth = 0.5;

chamfer = 2;

$cutoutSize = diameter - 3 * chamfer;

rotate([90,0,0])
difference() {
    cuboid([diameter, diameter, thickness], chamfer=chamfer, trimcorners=false);

    $distanceToPlaceCutoutFromCenter = thickness/2 - cutoutDepth/2*.99;
    translate([0,0,$distanceToPlaceCutoutFromCenter])
    cube([$cutoutSize,$cutoutSize, cutoutDepth], center = true);
    
    translate([0,0,-$distanceToPlaceCutoutFromCenter])
    cube([$cutoutSize,$cutoutSize, cutoutDepth], center = true);
    
    // https://github.com/BelfrySCAD/BOSL2/wiki/threading.scad
    threaded_rod(
        d=(1/4*25.4), // 1/4" 
        pitch=(1/20*25.4), // 20 Threads per inch
        l=thickness,
        blunt_start=true,
        internal=true
    );
}
