// US General Series 2 Toolbox - Track End Cap
// Caps the sharp end of a label track to prevent injury.
// The wedge inserts into the track channel to retain the cap.

/* [Cap Body] */

// Length of the cap (mm).
capLength = 19.5; // [19:0.25:22]

// Width of the cap (mm).
capWidth = 4; // [4:0.25:6]

// Thickness of the cap body (mm).
capThick = 1; // [1:0.2:4]

// Radius of the rounded corners (mm).
cornerRadius = 0.5; // [0:0.1:1]

// Radius used to round the perimeter edges of the face (mm).
faceRadius = 0.4; // [0:0.1:1]

/* [Wedge] */

// Maximum height of the wedge (mm).
wedgeHeight = 17.2; // [16:0.1:18]

// Width of the retaining wedge (mm).
wedgeWidth = 2.1; // [1.5:0.1:2.4]

// Length of the retaining wedge (mm).
wedgeLength = 6; // [2:1:10]

/* [Hidden] */

$fn = 32;

// ── Modules ──────────────────────────────────────────────────────────────────

module roundedRect2D(length, width, radius) {
    hull() {
        translate([ length/2 - radius,  width/2 - radius]) circle(r=radius);
        translate([-length/2 + radius,  width/2 - radius]) circle(r=radius);
        translate([ length/2 - radius, -width/2 + radius]) circle(r=radius);
        translate([-length/2 + radius, -width/2 + radius]) circle(r=radius);
    }
}

// Cap body: flat on the wedge side (Z=0), rounded edges on the face (Z=capThick).
// A top-half sphere in the minkowski sum only rounds the upper perimeter edges.
module capBody() {
    minkowski() {
        linear_extrude(height = capThick - faceRadius)
            roundedRect2D(
                capLength - faceRadius * 2,
                capWidth  - faceRadius * 2,
                max(cornerRadius - faceRadius, 0.01)
            );
        // Half-sphere (positive-Z hemisphere only) — leaves the bottom face flat.
        intersection() {
            sphere(r = faceRadius);
            translate([0, 0, faceRadius / 2])
                cube([faceRadius * 4, faceRadius * 4, faceRadius], center = true);
        }
    }
}

// Rectangular prism extending downward from Z = 0.
module wedge() {
    translate([0, 0, -wedgeLength/2])
        cube([wedgeHeight, wedgeWidth, wedgeLength], center=true);
}

// ── Assembly ──────────────────────────────────────────────────────────────────

rotate([0, 180, 0])
union() {
    capBody();
    wedge();
}
