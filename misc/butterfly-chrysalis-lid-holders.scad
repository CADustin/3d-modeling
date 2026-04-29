$fn = 128;

/* [Lid] */
lidDiameter = 80; // [60:1:120]
lidHeight = 10; // [5:0.5:20]

/* [Holder] */
holderDiameter = 40; // [20:1:60]
holderLength = 70; // [50:1:120]

/* [Base] */
baseHeight = 2; // [1:0.5:6]
baseEdgeRadius = 1; // [0.5:0.1:3]
edgeRadius = 1; // [0.5:0.1:4]

/* [Fit] */
slotClearance = 0.6; // [0:0.1:2]

/* [Clip] */
clipLength = 12; // [4:1:30]
clipInset = 0.8; // [0.2:0.1:2]
clipHeight = 3.2; // [1:0.1:8]

holderRadius = holderDiameter / 2;
baseDiameter = sqrt((holderLength * holderLength) + (holderDiameter * holderDiameter)) + 2;
slotWidth = lidHeight + slotClearance;
grooveRadius = lidDiameter / 2;
grooveCenterZ = grooveRadius;

module holder_base() {
    baseRadius = baseDiameter / 2;

    union() {
        cylinder(h = baseHeight, r = baseRadius - baseEdgeRadius);
        cylinder(h = baseHeight - baseEdgeRadius, r = baseRadius);

        translate([0, 0, baseHeight - baseEdgeRadius])
            rotate_extrude()
                translate([baseRadius - baseEdgeRadius, 0, 0])
                    circle(r = baseEdgeRadius);
    }
}

module holder_envelope() {
    minkowski() {
        intersection() {
            translate([-holderLength / 2 + edgeRadius, 0, 0])
                rotate([0, 90, 0])
                    cylinder(h = holderLength - (2 * edgeRadius), r = holderRadius - edgeRadius);

            translate([-holderLength / 2 + edgeRadius, -holderRadius + edgeRadius, edgeRadius])
                cube([
                    holderLength - (2 * edgeRadius),
                    holderDiameter - (2 * edgeRadius),
                    holderRadius - (2 * edgeRadius)
                ]);
        }

        sphere(r = edgeRadius);
    }
}

module lid_groove() {
    translate([0, -slotWidth / 2, grooveCenterZ])
        rotate([-90, 0, 0])
            cylinder(h = slotWidth, r = grooveRadius);
}

union() {
    translate([0, 0, -baseHeight])
        holder_base();

    difference() {
        holder_envelope();

        lid_groove();
    }

    intersection() {
        holder_envelope();

        translate([-clipLength / 2, -slotWidth / 2, holderRadius - clipHeight])
            cube([clipLength, clipInset, clipHeight]);
    }

    intersection() {
        holder_envelope();

        translate([-clipLength / 2, slotWidth / 2 - clipInset, holderRadius - clipHeight])
            cube([clipLength, clipInset, clipHeight]);
    }
}