include<_module-magneticLabel.scad>

// The text for the label.
labels = [
"Impact Modules",
"Hull Breach Initiators",
"Torque Calibrators",
"Quantum Fit Adapters",
"Grip Manipulators",
"Precision Scanners",
"Auxiliary Thrusters",
"Access Drivers",
];


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
magnetDiameter = 6; // [5:24]

// The depth of the magnet
magnetDepth = 2; // [2:10]

{}

spacing = size + margin * 4;

for (i = [0 : len(labels)-1]) {
    translate([0, i * spacing, 0]) {
		magneticLabel(labels[i],
				   plateThickness = plateThickness,
				   letterThickness = letterThickness,
				   size = size,
				   margin = margin,
				   totalMagnets = totalMagnets,
				   magnetDiameter = magnetDiameter,
				   magnetDepth = magnetDepth);
	}
}
