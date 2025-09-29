// The Width of the accessory base (in mm).
accessoryBaseWidth = 14; // [14:250]

// The Height of the accessory base (in mm).
accessoryBaseHeight = 14; // [14:220]

// Thickness of the accessory base (in mm).
accessoryBaseThickness = 2; // [0:5]

{}

accessoryBaseWithPins(accessoryBaseWidth, accessoryBaseHeight, accessoryBaseThickness);

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

function pinDiameter() = 10;
function pinHeight() = 10;
function pinXSpacing() = 22;
function pinYSpacing() = 34;
function pinCutoutThickness() = 1.5;
function calculateRowsOfPins(distance) = max(1, ceil((distance-pinDiameter()) / pinYSpacing()));
function calculateColumnsOfPins(distance) = max(1, ceil((distance-pinDiameter()) / pinXSpacing()));