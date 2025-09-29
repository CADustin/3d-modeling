include <../common/functions.scad>

// The width of the shelf (in mm).
$shelfWidth = 80; // [20:200]

// The shelf depth, you can reuse "spacingToBarrel" (in mm).
$shelfDepth = 90; // [10:150]

// The nominal shelf thickness (in mm).
$shelfThickness = 3; // [3:20]

// The notch height, which should probably be less than or equal to the holder height -- I've found ~20-25% is typically sufficient (in mm).
$notchHeight = 10; // [0:50]

// The barrel diameter that was used when generating the barrel holder this will be paired with (in mm).
$barrelDiameter = 20; // [10:50]

{}

$totalWidthForBarrelHolder = $barrelDiameter*1.25;

barrelHolderShelf($shelfWidth, $shelfDepth, $shelfThickness, $totalWidthForBarrelHolder, $notchHeight);