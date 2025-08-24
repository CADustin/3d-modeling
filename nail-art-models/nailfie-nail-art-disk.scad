/* [Size and Positions] */
// The thickness of the Nailfie (mm)
$thickness = 3; // [2:10]

// Diameter of the Nailfie (mm)
$mainDiameter = 110;

// Diameter of your thumb (mm)
$thumbDiameter = 25;

// Diamter of your finger (mm)
$fingerDiameter = 19;

// The hand you will use it in
$hand = 0; // [90:Right Hand, 0:Left Hand]

// Includes a label on the underside marking which hand it is intended for
$includeHandLabel = 1; // [0:No, 1:Yes]

/* [Text] */
// The thickness of both lines of text (mm)
$textThickness = 1;

// Line 1 Text
$line1Text = "Nails by Ceci";

// Line 1 Text Size (mm)
$line1Size = 12;

// Line 2 Text
$line2Text = "@mini_mani_magic";

// Line 2 Text Size (mm)
$line2Size = 6;

{}

$font1 = "Vladimir Script:style=Regular";
$font2 = "Cooper Black:style=Regular";

difference() {
    group() {
        // The main part of the Nailife
        linear_extrude($thickness) {
            difference() {
                // Main Cirule
                $radiusOfMainCircle = $mainDiameter / 2;
                circle(r = $radiusOfMainCircle, $fn = 120);
                
                $fingerOffset = $hand;
                
                // Thumb
                $thumbRadius = $thumbDiameter / 2;
                generateCircleAroundPerimeter($radiusOfMainCircle, $thumbRadius, 220 + $fingerOffset);
                
                // Fingers
                $fingerRadius = $fingerDiameter / 2;
                generateCircleAroundPerimeter($radiusOfMainCircle, $fingerRadius, 95 + $fingerOffset);
                generateCircleAroundPerimeter($radiusOfMainCircle, $fingerRadius, 50 + $fingerOffset);
                generateCircleAroundPerimeter($radiusOfMainCircle, $fingerRadius, 5 + $fingerOffset);
                generateCircleAroundPerimeter($radiusOfMainCircle, $fingerRadius, 325 + $fingerOffset);
            }
        }

        // The Text
        group() {
            translate([0,0,$thickness]) {
                // Line 1 Text
                color("red") {
                    linear_extrude($textThickness) {
                        translate([0, 11, 0])
                        text($line1Text, size = $line1Size, halign="center", valign="center", font = $font1);
                    }
                }
                
                // Line 2 Text
                color("blue") {
                    linear_extrude($textThickness) {
                        translate([0, -15, 0])
                        text($line2Text, size = $line2Size, halign="center", valign="center", font = $font2);
                    }
                }
            }
        }
    }
    
    // Negative Cutout on the underside
    if ($includeHandLabel == 1){
        mirror([180,0,0]) {
            linear_extrude(0.2) {
                $handText = $hand == 0 ? "L" : "R";
                #text($handText, size = 20, halign = "center", valign = "center");
            }
        }
    }
}



// Generate a circule thats around the perimeter of a main circle.
module generateCircleAroundPerimeter(radiusOfOutterCircle, cutOutRadius, angle) {
    // Normalize the angle between 0 and 360
    angle = angle % 360;
    if(angle < 0){
        angle = angle + 360;
    }
    
    translate([radiusOfOutterCircle * cos(angle), radiusOfOutterCircle * sin(angle), 0]) {
        circle(r = cutOutRadius);
    }
}
