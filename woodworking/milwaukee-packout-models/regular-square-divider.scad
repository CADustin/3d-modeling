// Length of the Divider ... Regular 4" Square, X-Style: 113mm was a tad loose, 114mm was too tight, 113.5 fits but is a tad tight.
$lengthAtTop = 113.25;

// Thickness of the Divider
$thickness = 2; // [2:10]

// The proportion of the total height to use for scaling.
$heightPercentage = 100; // [10:100]

// Width of the Divider Edge
$widthOfDividerEdge = 6; // [6:10]

// The Length of the Chamfer
$chamferLength = 10; // [6:14]

// Cutout Location for connecting dividers together
$cutOutLocation = 1; // [1:Bottom, -1:Top, 0:None]

// Width of the notch at the bottom of the divider
$bottomNotchWidth = 40; // [25:50]
    
{} // All Parameters Above

// Object Generation
/////////////////////////////////////////////////
GenerateDivider($lengthAtTop, $thickness, $heightPercentage, $widthOfDividerEdge, $chamferLength, $cutOutLocation, $bottomNotchWidth);

// Generate the Divider
/////////////////////////////////////////////////
module GenerateDivider(lengthAtTop, thickness, heightPercentage, widthOfDividerEdge, chamferLength, cutOutLocation, bottomNotchWidth) {

    // THe Height of the Divider
    $height = 82;

    // The height (or depth) of the notch at the bottom of the divider
    $bottomNotchHeight = 2; // [0:10]

    // Angle of the Container Sides
    $complementAngle = 1.4;
    $angle = 90 - $complementAngle;

    difference() {
        IsoTrapezoid(lengthAtTop, $height, $angle, thickness, widthOfDividerEdge);
        
        $heightProportion = heightPercentage * .01;
        
        $precentageToRemove = (1 - $heightProportion);
        
        // Cut from the Top Down
        $amountToRemoveFromTop = $height * $precentageToRemove;
        $topEdgeFromCenter = -$height / 2;
        translate([0, 0, $topEdgeFromCenter + $amountToRemoveFromTop / 2]) cube([lengthAtTop, widthOfDividerEdge * 2, $amountToRemoveFromTop], center = true);
        
        // Cutouts For Divider
        if (cutOutLocation != 0) {
            $cutOutHeight = ($height * $heightProportion) / 2;

            $bottomOfDividerFromCenter =  $height / 2;

            $zOffSetForCutout = ($bottomOfDividerFromCenter - ($cutOutHeight / 2));
            
            if(cutOutLocation == -1){
                translate([0,0, $zOffSetForCutout - $cutOutHeight])
                #cube([thickness, thickness*1.1, $cutOutHeight], center = true);
            }
            else{
                translate([0,0, $zOffSetForCutout])
                #cube([thickness, thickness*1.1, $cutOutHeight], center = true);
            }
        }
        
        // Cutouts For Divider
        //if (cutOutLocation == -1) {
         //   $cutOutHeight = ($height * $heightProportion) / 2;

         //   $bottomOfDividerFromCenter =  $height / 2;

          //  $zOffSetForCutout = ($bottomOfDividerFromCenter - ($cutOutHeight / 2));

          //  #translate([0,0, $zOffSetForCutout - $cutOutHeight])
          //      cube([thickness, thickness*1.1, $cutOutHeight], center = true);
        //}
        

        
        // Notch at bottom
        translate([0,0,(($height)/2)-($bottomNotchHeight/2)])
            cube([bottomNotchWidth, thickness*1.1, $bottomNotchHeight], center = true);
        
        // Notch for the small sphere often in the bottom of the containers
        translate([0,0,($height/2)-$bottomNotchHeight])
            sphere(d = 5);

        // Cutoffs needed for the Chamfers in the corners
        $overcutFactor = 2;
        $zHeightOfChamfer = ($height/2);
        translate([(lengthAtTop / 2), 0,$zHeightOfChamfer])
            rotate([45,0,90])
            cube([widthOfDividerEdge * $overcutFactor,  chamferLength,  chamferLength], center = true);
        
        
        translate([-(lengthAtTop / 2), 0,$zHeightOfChamfer])
            rotate([45,0,90])
            cube([widthOfDividerEdge * $overcutFactor,  chamferLength,  chamferLength], center = true);
    }
}

// Generate an Trapezoid with a tapered angle
/////////////////////////////////////////////////
module IsoTrapezoid(longEdge, height, angle, thickness, widthOfDividerEdge){
    $baseOfTriangle = height / tan(angle);
    
    cube([longEdge - ($baseOfTriangle * 2), thickness, height], center = true);

    // Render the triangle with specified angle and height
    color("red")
        translate([(longEdge/2),-thickness/2,-(height/2)])
        rotate([90,0,180])
        triangle(angle, height, thickness);

    color("blue")
        translate([-(longEdge/2),thickness/2,-(height/2)])
        rotate([90,0,0])
        triangle(angle, height, thickness);

    $halfChamferOffSet = ($height / tan($angle))/2;
    
    translate([(longEdge/2)-$halfChamferOffSet,0,0])
        rotate([$complementAngle, 0, -90])
        triangle2(widthOfDividerEdge, height);

    translate([-(longEdge/2)+$halfChamferOffSet,0,0])
        rotate([$complementAngle, 0, 90])
        triangle2(widthOfDividerEdge, height);
}

// Create the triangle module with angle and height as arguments
/////////////////////////////////////////////////
module triangle(angle, height, thickness) {
    // Calculate the base length based on the angle and height
    base_length = height / tan(angle);

    linear_extrude(thickness)
    // Create the triangle
    polygon(points=[
        [0, 0], // First vertex
        [base_length, 0], // Second vertex
        [base_length, height] // Third vertex
    ]);
}

// Create a right triangle
/////////////////////////////////////////////////
module triangle2(sizeOfBase,length){
    difference(){   
        rotate([0,0,45]){
            cube([sizeOfBase,sizeOfBase,length], center = true);
        }
        
        translate([0,sizeOfBase/2,0]){
            cube([sizeOfBase*1.5,sizeOfBase,length*1.1], center = true);
        }
    }
}