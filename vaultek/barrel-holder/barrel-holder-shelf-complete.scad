// The width of the shelf (in mm).
shelfWidth = 80; // [20:200]

// The shelf depth, you can reuse "spacingToBarrel" (in mm).
shelfDepth = 90; // [10:150]

// The nominal shelf thickness (in mm).
shelfThickness = 3; // [3:20]

// The notch height, which should probably be less than or equal to the holder height -- I've found ~20-25% is typically sufficient (in mm).
notchHeight = 10; // [0:50]

// The barrel diameter that was used when generating the barrel holder this will be paired with (in mm).
barrelDiameter = 20; // [10:50]

{}

$totalWidthForBarrelHolder = barrelDiameter*1.25;

barrelHolderShelf(shelfWidth, shelfDepth, shelfThickness, $totalWidthForBarrelHolder, notchHeight);

/******** Functions/Modules **********/

// Module: barrelHolderShelf
// Creates a shelf designed to slip over the barrel holders.
//
// Parameters:
// - shelfWidth (number): The total width of the shelf (in mm).
// - shelfDepth (number): The depth of the shelf (in mm).
// - shelfThickness (number): The thickness shelf (in mm).
// - notchWidth (number): The width of the notch used to slip over the barrel holder.
// - notchHeight (number): The height of the notch used to slip over the barrel holder.
module barrelHolderShelf(shelfWidth, shelfDepth, shelfThickness, notchWidth, notchHeight) {
linear_extrude(shelfDepth)
polygon(points=[
    [0,0], 
    [shelfWidth,0], 
    [shelfWidth,-shelfThickness], 
    [shelfWidth/2+notchWidth/2,-notchHeight-shelfThickness],
    [shelfWidth/2+notchWidth/2,-shelfThickness],
    [shelfWidth/2-notchWidth/2,-shelfThickness],
    [shelfWidth/2-notchWidth/2,-notchHeight-shelfThickness],
    [0,-shelfThickness], 
]);
}