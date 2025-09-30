include <../common/functions.scad>

// The number of pegs high to use (vertically).
pegsHigh = 3; // [1:10]

// The thickness of the hooks (in mm).
thickness = 5; // [4:10]

// The height of the hooks (in mm).
height = 10; // [5:10]

// The depth of the hooks (in mm)
depth = 5; // [5:20]

{}

$totalHeight = pegsHigh * pinYSpacing();
$totalWidth = 1 * pinXSpacing();

rotate([0,0,180])
accessoryBaseWithPins($totalWidth,$totalHeight,2);

translate([0,0,-$totalHeight/2 - height])
group() {
    $totalKeyHooksHigh = floor(($totalHeight) / (height*2 + thickness));
    for(i = [1 : $totalKeyHooksHigh]) {
        translate([0, -height-thickness,(height*2 + thickness) * i])
        keyHook(thickness,height, depth );
    }
}

module keyHook(thickness = 5, height = 10, depth = 5) {
    hookPaths = [[0,0], [depth+thickness, 0], [depth+thickness, height+thickness], [depth, height+thickness], [depth, thickness], [0, thickness], ];

    translate([-thickness/2,0,(height+thickness)/2])
    rotate([0,90,0])
    minkowski()
    {
        $fn=30;
        linear_extrude(thickness)
        polygon(hookPaths);
        sphere(.25);
    }
}