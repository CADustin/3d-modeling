// Woodworking-specific label set for US General Series 2 toolbox
// This file uses the modules defined in us-general-series2-label-slips.scad

renderDefaultSingleLabel = false;
include <us-general-series2-label-slips.scad>

/* [Woodworking Labels] */

// Woodworking-focused label list
woodworkingLabels = [
    "Bench Cookies",
    "Belt Sander Belts",
    "Blades",
    "Chisels",
    "Clamps",
    "Fasteners",
    "Files",
    "Flush Trim Bits",
    "Forstner Bits",
    "Hand Planes",
    "Hardware",
    "Hinges",
    "Knobs",
    "Measuring Tools",
    "Rasps",
    "Router Bits",
    "Sandpaper",
    "Saw Blades",
    "Screws",
    "Squares",
    "Stains & Finishes"
];

// Generate labels for woodworking tools using the base label settings
labelsFromTextList(
    labelTexts=woodworkingLabels,
    printBedSize=printBedSize,
    columnSpacing=userMultiLabelSpacing,
    rowSpacing=userMultiLabelSpacing,
    font=internalFont,
    textHeight=userTextHeight,
    size=userTextSize,
    labelHeight=userLabelHeight,
    labelThickness=userLabelThickness,
    lengthPadding=userLengthPadding,
    allCaps=userAllCaps,
    textAlignment=internalTextAlignment,
    bodyColor=internalBodyColor,
    textColor=internalTextColor,
    separateParts=internalSeparateParts,
    roundCorners=userRoundCorners,
    cornerRadius=userCornerRadius,
    addEdgeBevel=userAddEdgeBevel,
    edgeBevelSize=userEdgeBevelSize
);
