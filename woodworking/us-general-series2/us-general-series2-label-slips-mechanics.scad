// Mechanics-specific label set for US General Series 2 toolbox
// This file uses the modules defined in us-general-series2-label-slips.scad

renderDefaultSingleLabel = false;
include <us-general-series2-label-slips.scad>

/* [Mechanics Labels] */

// Mechanics-focused label list
mechanicsLabels = [
    "Adapters",
    "Allen Keys",
    "Channel Locks",
    "Deep Sockets",
    "Electrical",
    "Extensions",
    "Hammers",
    "Impact Sockets",
    "Needle Nose",
    "Nut Drivers",
    "Picks",
    "Pliers",
    "Pry Bars",
    "Ratchets",
    "Screwdrivers",
    "Sockets",
    "Stubby Wrenches",
    "Torx Keys",
    "Vise Grips",
    "Wrenches"
];

// Generate labels for mechanics tools using the base label settings
labelsFromTextList(
    labelTexts=mechanicsLabels,
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
