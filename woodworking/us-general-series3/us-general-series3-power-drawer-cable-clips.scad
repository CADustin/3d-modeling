// The thickness of the shell and its sides (in mm).
thickness = 2; // [2:4]

// The depth of the sides that will be on the outsides of the drawers (in mm).
sideDepth = 8; // [5:16]

// The depth of the clip (in mm).
clipDepth = 15; // [15:50]

// The size of the clip's opening (in mm).
$clipOpening = 6; // [5:30]

{}


$metal = 6;

$drawerID = $clipOpening + $metal;

$inset = 1;

// The points that make up the clips body/shape.
$clipPoints=[
    [0,0],
    [thickness + $metal + thickness, 0],
    [thickness + $metal + thickness - $inset, clipDepth],
    [thickness + $metal + thickness + ($drawerID - thickness * 2), clipDepth],
    [thickness + $metal + thickness + ($drawerID - thickness * 3), 0],

    [thickness * 2 + $metal + thickness + ($drawerID - thickness * 3), thickness],

    [thickness + $metal + $drawerID, thickness + clipDepth],
    [thickness + $metal - $inset, thickness + clipDepth],
    [thickness + $metal, thickness],
    [thickness, thickness],
    [thickness, thickness+sideDepth],

    [0, thickness+sideDepth],
];

group() {
    linear_extrude(clipDepth)
    polygon($clipPoints);
    
    // Support block
    translate([thickness*2,clipDepth-thickness,0])
    cube([$metal-2,thickness*2,clipDepth]);
}