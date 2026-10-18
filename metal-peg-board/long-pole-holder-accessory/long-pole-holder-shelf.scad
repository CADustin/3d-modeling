// Metal peg board long pole holder shelf insert.
//
// Procedural reconstruction that does not depend on external mesh imports.

/* [Shelf] */

// Barrel diameter profile in millimeters.
barrelDiameterMm = 20; // [20:5:30]

// Shelf depth in millimeters.
shelfDepthMm = 60; // [60:1:95]

/* [Hidden] */

shelfWidth = 80;
shelfThickness = 13;
shelfRailInset = 9;
shelfRailDepth = 2;

module longPoleHolderShelf(diameter = barrelDiameterMm, depth = shelfDepthMm) {
    if (!(diameter == 20 || diameter == 25 || diameter == 30)) {
        echo("Unsupported shelf diameter", diameter);
    } else if (!(depth == 60 || depth == 95)) {
        echo("Unsupported shelf depth", depth);
    } else {
        difference() {
            cube([shelfWidth, shelfThickness, depth]);

            // Center relief creates two side rails that lock into the holder body.
            translate([shelfRailInset, 0, 0])
                cube([shelfWidth - shelfRailInset * 2, shelfRailDepth, depth]);

            // Diameter-based center clearance keeps the shelf from interfering
            // with the cradle opening on larger pole sizes.
            translate([shelfWidth / 2, shelfThickness - 0.01, depth / 2])
                rotate([90, 0, 0])
                    cylinder(h = shelfThickness / 2, d = diameter * 0.8, $fn = 48);
        }
    }
}

longPoleHolderShelf();
