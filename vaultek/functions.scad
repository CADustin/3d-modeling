module accessoryBaseWithPins(baseWidth, baseHeight, baseThickness) {
    $fn = 100;
    
    // Pin Parameters
    pinDiameter=10;
    pinHeight = 10;
    pinSpacingX = 22;
    pinSpacingY = 34;
    cutoutThickness = 1.5;

    // Calculate number of pins
    numPinsX = max(1, floor(baseWidth / pinSpacingX));
    numPinsY = max(1, floor(baseHeight / pinSpacingY));

    // Total span of pins
    totalSpanX = (numPinsX - 1) * pinSpacingX;
    totalSpanY = (numPinsY - 1) * pinSpacingY;

    difference() {
        // Pins centered on top face
        rotate([90,0,0])
        for (i = [0 : numPinsX - 1])
            for (j = [0 : numPinsY - 1]) {
                xOffset = -totalSpanX/2 + i * pinSpacingX;
                zOffset = -totalSpanY/2 + j * pinSpacingY;
                translate([xOffset, zOffset, pinHeight/2 + baseThickness/2])
                    difference(){
                        rotate([0,180,180])
                        color("orange")
                        pin(pinDiameter, pinHeight, cutoutThickness);
                    }
            }
    }

    // Base
    cube([baseWidth, baseThickness, baseHeight], center = true);
}

module pin(pinDiameter = 10, pinHeight = 10, cutoutThickness = 1.5){
    $fn = 100;
    $innerD = 6;
    
    difference(){
        cylinder(h = pinHeight, r = pinDiameter / 2, center = true);

        translate([0,0,pinHeight/2-cutoutThickness/2+0.01])
        difference() {
            // Full washer
            cylinder(h=cutoutThickness, r=pinDiameter/2, center=true);
                
            // slightly taller to ensure clean subtraction
            cylinder(h=cutoutThickness, r=$innerD/2, center=true);

            // Cut it in half
            translate([-pinDiameter/2, -pinDiameter/2, -cutoutThickness])
            cube([pinDiameter, pinDiameter/2, cutoutThickness*2]);
        }
    }
}


// The Width of the accessory base
$accessoryBaseWidth = 44; // [14:250]

// The Height of the accessory base
$accessoryBaseHeight = 68; // [14:220]

// Thickness of the accessory base
$accessoryBaseThickness = 2; // {0:5]

accessoryBaseWithPins($accessoryBaseWidth, $accessoryBaseHeight, $accessoryBaseThickness);