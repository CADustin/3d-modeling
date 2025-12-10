$baseWidth = 90;
$baseDepth = 70;
$baseThickness = 9;

$topDepth = 20;
$topThickness = 6;
$topHeight = 75;

$sideWallThickness = 3;


// Base

difference(){
cube([$baseWidth, $baseDepth, $baseThickness], center = true);

translate([0,$baseDepth/2 - 4,2])
#cube([55, 2, $baseThickness], center = true);

translate([0,$baseDepth/2 - 20,2])
#cube([$baseWidth*1.1, 2, $baseThickness], center = true);
    
translate([0,$baseDepth/2 - 40,2])
#cube([$baseWidth*1.1, 2, $baseThickness], center = true);
}


translate([200,200,0])
group(){
// Top
difference(){
cube([$baseWidth, $topDepth, $topThickness], center = true);

// Left
translate([$baseWidth/3, 0, 0])
#cylinder($fn=50, h=$topThickness*1.1, d = 10, center = true);

// Middle
#cylinder($fn=50, h=$topThickness*1.1, d = 15, center = true);
    
// Right
translate([-$baseWidth/3, 0, 0])
#cylinder($fn=50, h=$topThickness*1.1, d = 10, center = true);
}

// Top, Side 1
difference(){
    translate([$baseWidth/2 - $sideWallThickness/2,0,$topHeight/2 - $topThickness/2])
    cube([$sideWallThickness, $topDepth, $topHeight], center=true);
    
    translate([$baseWidth/2 - $sideWallThickness/2,0,$topHeight -$sideWallThickness/2 - $sideWallThickness*2])
    #cube([$sideWallThickness*1.1,$topDepth - $sideWallThickness * 2,$sideWallThickness], center = true);
}
// Top, Side 2
difference(){
translate([-($baseWidth/2 - $sideWallThickness/2),0,$topHeight/2 - $topThickness/2])
cube([$sideWallThickness, $topDepth, $topHeight], center=true);
    
translate([-($baseWidth/2 - $sideWallThickness/2),0,$topHeight - $sideWallThickness/2 - $sideWallThickness*2])
#cube([$sideWallThickness*1.1,$topDepth - $sideWallThickness * 2,$sideWallThickness], center = true);
}
}