// The thickness of the shell and its sides (in mm).
thickness = 2; // [2:8]

// The depth of the sides that will be on the outsides of the drawers (in mm).
sideDepth = 10; // [5:25]

// The depth of the clip (in mm).
trayDepth = 15; // [5:200]

// The width of the clip (in mm).
trayWidth = 10; // [20:200]

// An offset applied to angle the bottom of the tray inwards, creating slight slopes on the left and right side (in mm).
offset = 0; // [0:10]

// Print with the bottom of the tray on the print bed (if possible).
printBottomDown = true;

{}

// Parameters for the US General Series 2 Drawers
$drawerID = 10; // 20250930: 302-305mm

$metal = 3;

// The points that make up the tray's body/shape.
$trayPoints=[
    [0,0],
    [thickness + $metal + thickness, 0],
    [thickness + $metal + thickness + offset, trayDepth],
    [thickness + $metal + thickness + ($drawerID - thickness * 2 - offset), trayDepth],
    [thickness + $metal + thickness + ($drawerID - thickness * 3), 0],

    [thickness * 2 + $metal + thickness + ($drawerID - thickness * 3), thickness],

    [thickness + $metal + $drawerID - offset, thickness + trayDepth],
    [thickness + $metal + offset, thickness + trayDepth],
    [thickness + $metal, thickness],
    [thickness, thickness],
    [thickness, thickness+sideDepth],

    [0, thickness+sideDepth],
];

group() {
    linear_extrude(trayWidth + thickness * 2)
    polygon($trayPoints);
}