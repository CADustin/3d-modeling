// The thickness of the shell and its sides (in mm).
thickness = 3; // [2:8]

// The depth of the sides that will be on the outsides of the drawers (in mm).
sideDepth = 10; // [5:25]

// The depth of the inside of the tray (in mm).
trayDepth = 19; // [5:200]

// The width of the tray (in mm).
trayWidth = 40; // [20:200]

// An offset applied to angle the bottom of the tray inwards, creating slight slopes on the left and right side (in mm).
offset = 0; // [0:10]

{}

// Parameters for the US General Series 2 Drawers
$drawerID = 304;
$drawerOD = 310;

$metal = ($drawerOD - $drawerID) / 2;

$trayPoints=[
    [0,0],
    [thickness + $metal + thickness, 0],
    [thickness + $metal + thickness + offset, trayDepth],
    [thickness + $metal + thickness + ($drawerID - thickness * 2 - offset), trayDepth],
    [thickness + $metal + thickness + ($drawerID - thickness * 2), 0],

    [(thickness + $metal + thickness)*2 + ($drawerID - thickness * 2), 0],
    [(thickness + $metal + thickness)*2 + ($drawerID - thickness * 2) , sideDepth],
    [thickness*2 + $metal*2 + thickness*1 + ($drawerID - thickness * 2), sideDepth],
    [thickness*2 + $metal*2 + thickness*1 + ($drawerID - thickness * 2), thickness],
    [thickness*2 + $metal*1 + thickness*1 + ($drawerID - thickness * 2), thickness],

    [thickness + $metal + $drawerID- offset, thickness + trayDepth],
    [thickness + $metal + offset, thickness + trayDepth],
    [thickness + $metal, thickness],
    [thickness, thickness], // 14
    [thickness, thickness+sideDepth], //15

    [0, thickness+sideDepth],
];

linear_extrude(trayWidth + thickness * 2)
polygon($trayPoints);

$sides = [
    [0,0],
    [$drawerID,0],
    [$drawerID-offset,trayDepth+thickness],
    [offset,trayDepth+thickness],
];

//color("green")
translate([thickness + $metal,0,0])
linear_extrude(thickness)
polygon($sides);

//color("red")
translate([thickness + $metal,0,trayWidth + thickness])
linear_extrude(thickness)
polygon($sides);