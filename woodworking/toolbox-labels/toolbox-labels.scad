include<_module-magneticLabel.scad>

// The text for the label.
labelText = "Impact Modules";

// The thickness (depth) of the plate.
plateThickness = 2.5; // [2:0.5:8]

// The thickness (depth) of the label.
letterThickness = 1; // [1:0.5:8]

// The size of the protruding text
size = 14; // [10:50]

// The margin around the text
margin = 2; // [1:8]

// The total number of magnets to add.
totalMagnets = 3; // [1, 3, 5]

// The diameter of the magnet
magnetDiameter = 6.1; // [5:0.1:24]

// The depth of the magnet
magnetDepth = 2; // [2:10]

{}

magneticLabel(labelText,
               plateThickness = plateThickness,
               letterThickness = letterThickness,
               size = size,
               margin = margin,
               totalMagnets = totalMagnets,
               magnetDiameter = magnetDiameter,
               magnetDepth = magnetDepth);
