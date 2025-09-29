
$sideDepth = 10;
$sideThickness = 3;
$trayDepth = 40;

$length = 60;

{}

$drawerID = 304;

$drawerOD = 310;

$metal = ($drawerOD - $drawerID) / 2;


linear_extrude(60)
polygon(points=[
[0,0],
[$sideThickness + $metal + $sideThickness, 0],
[$sideThickness + $metal + $sideThickness, $trayDepth],
[$sideThickness + $metal + $sideThickness + ($drawerID - $sideThickness * 2), $trayDepth],
[$sideThickness + $metal + $sideThickness + ($drawerID - $sideThickness * 2), 0],

[($sideThickness + $metal + $sideThickness)*2 + ($drawerID - $sideThickness * 2), 0],
[($sideThickness + $metal + $sideThickness)*2 + ($drawerID - $sideThickness * 2), $sideDepth],
[$sideThickness*2 + $metal*2 + $sideThickness*1 + ($drawerID - $sideThickness * 2), $sideDepth],
[$sideThickness*2 + $metal*2 + $sideThickness*1 + ($drawerID - $sideThickness * 2), $sideThickness],
[$sideThickness*2 + $metal*1 + $sideThickness*1 + ($drawerID - $sideThickness * 2), $sideThickness],

[$sideThickness + $metal + $drawerID, $sideThickness + $trayDepth],
[$sideThickness + $metal, $sideThickness + $trayDepth],
[$sideThickness + $metal, $sideThickness],
[$sideThickness, $sideThickness], // 14
[$sideThickness, $sideThickness+$sideDepth], //15

[0, $sideThickness+$sideDepth],

]);

color("green")
translate([$sideThickness + $metal,0,0])
cube([$drawerID, $trayDepth + $sideThickness,$sideThickness]);

color("red")
translate([$sideThickness + $metal,0,$length-$sideThickness])
cube([$drawerID, $trayDepth + $sideThickness,$sideThickness]);