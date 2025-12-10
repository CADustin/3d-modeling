$holderDepth = 30;
$holderHeight = 10;

$cavityWidth = 120;
$cavityDepth = 13;
$cavityHeight = 4;

$rows = 4;
$spacingBetweenCavitys = 5;

difference() {
    minkowski() {
        cube([$cavityWidth + 8, $holderDepth, $cavityHeight], center = true);
        sphere(r=1); // rounding radius
    }
    
    $spacing = ($holderDepth - $cavityDepth*$rows)/2;
    echo($spacing);
    
    $totalCavitys = $holderDepth / ($cavityDepth + $spacingBetweenCavitys);
    echo($totalCavitys);
    echo($cavityDepth);
    $starting = -$holderDepth/2;
    for(i = [0:$rows-1]){
        $myPosition = i;
        translate([0,$myPosition,0])
        #cube([$cavityWidth*1.1, $cavityDepth, $cavityHeight], center = true);
    }
}