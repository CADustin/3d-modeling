// The total height of the barrel holder (in mm).
holderHeight = 46; // [20:100]

// The spacing from the back of the safe to the beginning of where the barrel will rest (in mm) **Note:** The typical Vaultek spacers are ~38mm, so if your replacing 1 spacer 38mm is a good start.
spacingToBarrel = 76; // [10:150]

// The barrel diameter (in mm).
barrelDiameter = 25.4; // [10:50]

{}

$totalWidth = barrelDiameter*1.25;

$depth = spacingToBarrel + barrelDiameter;

translate([0,-$depth/2,0])
accessoryBaseWithPins($totalWidth,holderHeight,0);

difference() {
    cube([$totalWidth,$depth,holderHeight], center = true);
    translate([0,$depth/2 - barrelDiameter/2 + 0.01,0])
        group() {
            cylinder(h = holderHeight + 0.1, d = barrelDiameter, center = true, $fn = 50);

            translate([0,barrelDiameter/4,0])
            cube([barrelDiameter, barrelDiameter/2, holderHeight+0.1], center = true);
        }
}

/******** Functions/Modules **********/

// Module: accessoryBaseWithPins
// Generates a rectangular base with evenly spaced pins on its top surface.
// The pins are arranged in a grid pattern, and their number is calculated
// based on the dimensions of the base and the spacing between pins.
//
// Parameters:
// - baseWidth (number): The width of the base in the X direction.
// - baseHeight (number): The height of the base in the Y direction.
// - baseThickness (number): The thickness of the base in the Z direction.
module accessoryBaseWithPins(baseWidth, baseHeight, baseThickness) {
    $fn = 100;
    
    // Pin Parameters
    pinDiameter = pinDiameter();
    pinHeight = pinHeight();
    pinSpacingX = pinXSpacing();
    pinSpacingY = pinYSpacing();
    cutoutThickness = 1.5;

    // Calculate number of pins
    numPinsX = calculateColumnsOfPins(baseWidth);
    numPinsY = calculateRowsOfPins(baseHeight);

    // Total span of pins
    totalSpanX = (numPinsX - 1) * pinSpacingX;
    totalSpanY = (numPinsY - 1) * pinSpacingY;

    difference() {
        // Pins centered on top face
        rotate([90, 0, 0])
        for (i = [0 : numPinsX - 1])
            for (j = [0 : numPinsY - 1]) {
                xOffset = -totalSpanX / 2 + i * pinSpacingX;
                zOffset = -totalSpanY / 2 + j * pinSpacingY;
                translate([xOffset, zOffset, pinHeight / 2 + baseThickness / 2])
                    difference() {
                        rotate([0, 180, 180])
                        pin();
                    }
            }
    }

    // Base
    cube([baseWidth, baseThickness, baseHeight], center = true);
}

// Module: pin
// Creates a single pin with a cylindrical shape and a cutout on its top surface.
// The cutout is a washer-like structure with a half-cylinder removed.
//
// Parameters:
// - pinDiameter (number): The diameter of the pin.
// - pinHeight (number): The height of the pin.
// - cutoutThickness (number): The thickness of the washer-like cutout on the top of the pin.
module pin(pinDiameter = pinDiameter(), pinHeight = pinHeight(), cutoutThickness = pinCutoutThickness()) {
    $fn = 100;
    $innerD = 6;
    
    difference() {
        cylinder(h = pinHeight, r = pinDiameter / 2, center = true);

        translate([0, 0, pinHeight / 2 - cutoutThickness / 2 + 0.01])
        difference() {
            // Full washer
            cylinder(h = cutoutThickness, r = pinDiameter / 2, center = true);
                
            // Slightly taller to ensure clean subtraction
            cylinder(h = cutoutThickness, r = $innerD / 2, center = true);

            // Cut it in half
            translate([-pinDiameter / 2, -pinDiameter / 2, -cutoutThickness])
            cube([pinDiameter, pinDiameter / 2, cutoutThickness * 2]);
        }
    }
}

// Module: barrelHolderShelf
// Creates a shelf designed to slip over the barrel holders.
//
// Parameters:
// - shelfWidth (number): The total width of the shelf (in mm).
// - shelfDepth (number): The depth of the shelf (in mm).
// - shelfThickness (number): The thickness shelf (in mm).
// - notchWidth (number): The width of the notch used to slip over the barrel holder.
// - notchHeight (number): The height of the notch used to slip over the barrel holder.
module barrelHolderShelf(shelfWidth, shelfDepth, shelfThickness, notchWidth, notchHeight) {
linear_extrude(shelfDepth)
polygon(points=[
    [0,0], 
    [shelfWidth,0], 
    [shelfWidth,-shelfThickness], 
    [shelfWidth/2+notchWidth/2,-notchHeight-shelfThickness],
    [shelfWidth/2+notchWidth/2,-shelfThickness],
    [shelfWidth/2-notchWidth/2,-shelfThickness],
    [shelfWidth/2-notchWidth/2,-notchHeight-shelfThickness],
    [0,-shelfThickness], 
]);
}

function pinDiameter() = 10;
function pinHeight() = 10;
function pinXSpacing() = 22;
function pinYSpacing() = 34;
function pinCutoutThickness() = 1.5;
function calculateRowsOfPins(distance) = max(1, ceil((distance-pinDiameter()) / pinYSpacing()));
function calculateColumnsOfPins(distance) = max(1, ceil((distance-pinDiameter()) / pinXSpacing()));