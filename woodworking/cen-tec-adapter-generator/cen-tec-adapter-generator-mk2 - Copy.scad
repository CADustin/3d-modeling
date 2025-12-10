$bottomDia = 40;
$bottomLen = 20;
$br = $bottomDia/2;
$bl = $bottomLen;

$thickness = 2;

$cutoutDepth = 5;
$cd = $cutoutDepth;
$cutoutHeight = 10 + $thickness;
$ch = $cutoutHeight;

$taperLength  = 15;
$t = $thickness;

$topDia = 25;
$topLen = 30;
$tr = $topDia/2;
$tl = $topLen;

$fn = 100;

$totalLen = $bl+$ch+3+$taperLength+$tl;
pts = [
[$br,0],
[$br, $bl],
[$br-$cd, $bl],
[$br-$cd, $bl+$ch+$t],
//[$br, $bl+$ch+$t],
//[$br, $bl+$ch+3],
[$tr, $bl+$ch+3+$taperLength],
[$tr, $bl+$ch+3+$taperLength+$tl],

[$tr+$t, $bl+$ch+3+$taperLength+$tl],
[$tr+$t, $bl+$ch+3+$taperLength],
[$br+$t, $bl+$ch+3],
[$br+$t, $bl+$ch],
[$br-$cd+$t, $bl+$ch],
[$br-$cd+$t, $bl+$t],
[$br+$t, $bl+$t],
[$br+$t,0],



//[0,12],
//[6,12],
//[6,24],
//[0,24],
//[0,30],
//[8,38],
//[8,46],

//[10,46],
//[10,36],
//[2,28],
//[2,26],
//[8,26],
//[8,10],
//[2,10]

];


difference(){
    translate([0, 0, -$totalLen/2]) // Center the adapter
rotate_extrude(angle = 180, convexity = 10)
polygon(pts);


$startingOfCutout = $bl+$t+5;
translate([0,0,-$startingOfCutout/2])
#cube([15,50,10], center = true);

}
















