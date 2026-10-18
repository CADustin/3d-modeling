// Metal peg board long pole holder accessory.
//
// Unified entrypoint that routes to procedural holder and shelf models.

use <long-pole-holder.scad>
use <long-pole-holder-shelf.scad>

/* [Accessory] */

// 0 = Holder, 1 = Shelf, 2 = Magnetic Holder
accessoryType = 0; // [0:1:2]

// Barrel diameter profile in millimeters.
barrelDiameterMm = 20; // [20:5:30]

// Holder spacing in millimeters (holder variants only).
spacingMm = 20; // [10:1:95]

// Shelf depth in millimeters (shelf variants only).
shelfDepthMm = 60; // [60:1:95]

// Only used for the 20mm, 10mm-spacing holder variant.
useShortHolder = false;

/* [Hidden] */

module longPoleHolderAccessory(
    type = accessoryType,
    diameter = barrelDiameterMm,
    spacing = spacingMm,
    depth = shelfDepthMm,
    shortHolder = useShortHolder
) {
    if (type == 0)
        longPoleHolder(diameter = diameter, spacing = spacing, magnetic = false, shortHolder = shortHolder);
    else if (type == 1)
        longPoleHolderShelf(diameter = diameter, depth = depth);
    else if (type == 2)
        longPoleHolder(diameter = diameter, spacing = spacing, magnetic = true, shortHolder = false);
    else
        echo("Unsupported accessory type", type);
}

longPoleHolderAccessory();
