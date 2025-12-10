
diameter = 75;

cutoutDepth = 0.5;

chamfer = 2;

$cutoutSize = diameter - 3 * chamfer;

difference(){
    cube([$cutoutSize-1,$cutoutSize-1, 3], center = true);
    
    cylinder(h = 4, r = 4, center = true);
}