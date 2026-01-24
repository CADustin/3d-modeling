// Helper: text shape (so we don't repeat font settings)
module label_text(txt, size=14) {
    text(txt,
         font = "DejaVu Sans:style=Bold Oblique",
         size = size,
         halign = "center",
         valign = "center");
}

// convertString(str, toUpper)
// If toUpper == true, returns an uppercase version of str.
// If toUpper == false, returns str unchanged.
function convertString(str, toUpper=true) =
    toUpper
        ? _toUpper(str)
        : str;

// Internal helper: convert entire string to uppercase
function _toUpper(str, i=0) =
    i >= len(str)
        ? ""
        : str(
            _upperChar(str[i]),
            _toUpper(str, i+1)
        );

// Internal helper: convert a single character to uppercase
function _upperChar(c) =
    let(
        lower = "abcdefghijklmnopqrstuvwxyz",
        upper = "ABCDEFGHIJKLMNOPQRSTUVWXYZ",
        idx = search(c, lower)
    )
    (idx == [] ? c : upper[idx[0]]);

// Get the bounding box around the text
function text_bounds(txt, size=14) =
    textmetrics(txt, size=size, font="DejaVu Sans:style=Bold Oblique");


// Main module
// txt:              label text
// plateThickness:   thickness of the base plate
// letterThickness:  height of raised letters above plate
// size:             font size
// margin:           extra outline around letters for plate
// totalMagnets:     the number of magnets to add
// magnetDiameter:         magnet diameter
// magnetDepth:     magnet recess depth
module magneticLabel(txt,
                      plateThickness,
                      letterThickness,
                      size,
                      margin,
                      totalMagnets,
                      magnetDiameter = 0,
                      magnetDepth = 0) {

    $fn = 50;
    
    // Raised text
    color("white")
    translate([0, 0, plateThickness])
    linear_extrude(height = letterThickness)
    label_text(txt, size);
        
    difference() {
        magnetOffsets = [
            for (i = [0 : totalMagnets-1])
                i - floor(totalMagnets/2)
        ];
        
        bounds = text_bounds(txt, size);
        textWidth  = bounds.size[0] - 2;
            
        spacing = textWidth / totalMagnets;
        
        color("black")
        group(){
            textHeight = magnetDiameter + margin*2; //bounds.size[1];

            //color("gray")
            translate([-textWidth/2, -textHeight/2, 0])
            cube([textWidth, textHeight, plateThickness]);

            linear_extrude(height = plateThickness)
            offset(r = margin)
            label_text(txt, size);
            
            // Places an enlarged cylinder around the area we will cut magnet holes.
            for (i = magnetOffsets) {
                myZ = -plateThickness + magnetDepth + (plateThickness - magnetDepth);
                            
                //color("green")
                translate([i * spacing, 0, myZ])
                cylinder(d = magnetDiameter + margin*2, h = plateThickness, $fn = 64);
            }
        }

        // Place magnet holes
        for (i = magnetOffsets) {
            myZ = -plateThickness + magnetDepth + (plateThickness - magnetDepth);
            
            translate([i * spacing, 0, myZ])
            #cylinder(d = magnetDiameter, h = magnetDepth + 0.1, $fn = 64);
        }
    }
}
