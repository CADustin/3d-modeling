/* [Label Text] */

// Enter one label per quoted item.
// Mechanic-focused alternate list:
// userLabelTexts = [
//     "Adapters",
//     "Allen Keys",
//     "Channel Locks",
//     "Deep Sockets",
//     "Electrical",
//     "Extensions",
//     "Hammers",
//     "Impact Sockets",
//     "Needle Nose",
//     "Nut Drivers",
//     "Picks",
//     "Pliers",
//     "Pry Bars",
//     "Ratchets",
//     "Screwdrivers",
//     "Sockets",
//     "Stubby Wrenches",
//     "Torx Keys",
//     "Vise Grips",
//     "Wrenches"
// ];

// Woodworking-focused list:
userLabelTexts = [
    "Block Plane",
    "Carving Tools",
    "Chisels",
    "Countersinks",
    "Clamps",
    "Drill Bits",
    "Fasteners",
    "Files",
    "Forstner Bits",
    "Glue Supplies",
    "Hand Planes",
    "Hardware",
    "Layout Tools",
    "Marking Tools",
    "Measuring",
    "Rasps",
    "Router Bits",
    "Sanding",
    "Sharpening",
    "Squares"
];

// Convert label text to uppercase before rendering.
userAllCaps = false;

// Text size in mm.
userTextSize = 10; // [6:0.5:14]

// Height the text sticks up from the label surface in mm.
userTextHeight = 0.8; // [0.2:0.1:3]

// Extra blank space added to each end of the label.
userLengthPadding = 5; // [2:0.5:12]

// Label body height in mm.
userLabelHeight = 17; // [10:0.2:30]

// Label body thickness in mm.
userLabelThickness = 2; // [0.8:0.2:5]

/* [Shape] */

// Enable rounded label corners.
userRoundCorners = true;

// Rounded corner radius in mm.
userCornerRadius = 1; // [0:0.1:3]

// Add a small 45-degree bevel around the top perimeter edge.
userAddEdgeBevel = true;

// Top edge bevel size in mm.
userEdgeBevelSize = 0.4; // [0:0.05:1]

/* [Layout] */

// Print bed size in mm.
printBedSize = 180; // [180, 256, 320]

// Space between labels in both directions when printing multiple labels.
userMultiLabelSpacing = 2; // [2:1:20]

/* [Printer Reference] */

// 180 = Bambu A1 Mini
// 256 = Bambu A1, P1P, P1S, X1C
// 320 = Bambu H2D, H2S

/* [{}] */

// Internal fixed settings (not user-editable in Customizer).
internalFont = "Verdana:style=Bold";
internalTextAlignment = "center";
internalBodyColor = "Blue";
internalTextColor = "White";
internalSeparateParts = true;

// 2D label footprint with optional rounded corners.
module labelProfile2D(length, height=17, roundCorners=true, cornerRadius=1) {
    r = roundCorners ? max(0, min(cornerRadius, min(length, height) / 2 - 0.01)) : 0;

    if (r <= 0) {
        square([length, height], center=false);
    } else {
        translate([r, r])
            offset(r=r)
                square([length - 2 * r, height - 2 * r], center=false);
    }
}

function upperAsciiChar(character) =
    let(characterCode = ord(character))
        (characterCode >= 97 && characterCode <= 122)
            ? chr(characterCode - 32)
            : character;

function upperAsciiText(inputText, index=0) =
    (index >= len(inputText))
        ? ""
        : str(upperAsciiChar(inputText[index]), upperAsciiText(inputText, index + 1));

function displayLabelText(labelText, allCaps=false) = allCaps ? upperAsciiText(labelText) : labelText;

function effectiveTextInset(lengthPadding=5, roundCorners=true, cornerRadius=1) =
    max(lengthPadding, roundCorners ? cornerRadius + 1 : lengthPadding);

function fontWidthFactor(font="Verdana:style=Bold", allCaps=false) =
    font == "Verdana:style=Bold"
        ? (allCaps ? 0.82 : 0.92)
        : font == "Tahoma:style=Bold"
            ? (allCaps ? 0.78 : 0.70)
            : (allCaps ? 0.80 : 0.72);

function labelSafetyMargin(textSize=10) = max(1, textSize * 0.12);

function labelLengthFromText(labelText, font="Verdana:style=Bold", textSize=10, lengthPadding=5, allCaps=false, roundCorners=true, cornerRadius=1) =
    let(
        renderedText = displayLabelText(labelText, allCaps),
        textWidth = len(renderedText) * textSize * fontWidthFactor(font, allCaps),
        textInset = effectiveTextInset(lengthPadding, roundCorners, cornerRadius),
        safetyMargin = labelSafetyMargin(textSize)
    )
        max(20, textWidth + textInset * 2 + safetyMargin * 2);

function labelPlacementState(labelTexts, index, printBedSize=256, font="Verdana:style=Bold", textSize=10, lengthPadding=5, columnSpacing=6, allCaps=false, roundCorners=true, cornerRadius=1) =
    let(labelWidth = labelLengthFromText(labelTexts[index], font, textSize, lengthPadding, allCaps, roundCorners, cornerRadius))
        (index <= 0)
            ? [0, 0, labelWidth]
            : let(
                previousState = labelPlacementState(labelTexts, index - 1, printBedSize, font, textSize, lengthPadding, columnSpacing, allCaps, roundCorners, cornerRadius),
                nextWidth = previousState[2] + columnSpacing + labelWidth,
                fitsOnRow = nextWidth <= printBedSize,
                xOffset = fitsOnRow ? previousState[2] + columnSpacing : 0,
                rowIndex = fitsOnRow ? previousState[1] : previousState[1] + 1,
                rowWidth = fitsOnRow ? nextWidth : labelWidth
            )
                [xOffset, rowIndex, rowWidth];

// 3D body with optional top perimeter bevel.
module labelBody(
    length,
    height=17,
    thickness=2,
    roundCorners=true,
    cornerRadius=1,
    addEdgeBevel=false,
    edgeBevelSize=0.4
) {
    b = addEdgeBevel ? max(0, min(edgeBevelSize, thickness - 0.05, min(length, height) / 2 - 0.05)) : 0;

    if (b <= 0) {
        linear_extrude(height=thickness)
            labelProfile2D(length, height, roundCorners, cornerRadius);
    } else {
        baseH = thickness - b;

        if (baseH > 0) {
            linear_extrude(height=baseH)
                labelProfile2D(length, height, roundCorners, cornerRadius);
        }

        // Create a 45-degree bevel around the top perimeter edges.
        hull() {
            translate([0, 0, baseH])
                linear_extrude(height=0.01)
                    labelProfile2D(length, height, roundCorners, cornerRadius);

            translate([0, 0, thickness])
                linear_extrude(height=0.01)
                    offset(delta=-b)
                        labelProfile2D(length, height, roundCorners, cornerRadius);
        }
    }
}

// Function to generate rectangular labels with text for the toolbox drawer
module labelWithText(
    text="",
    font="Verdana:style=Bold",
    size=10,
    labelHeight=17,
    labelThickness=2,
    lengthPadding=5,
    allCaps=false,
    textAlignment="center",
    bodyColor="Blue",
    textColor="White",
    separateParts=true,
    roundCorners=true,
    cornerRadius=1,
    addEdgeBevel=true,
    edgeBevelSize=0.4,
    textHeight=0.8
) {
    // Auto-size the label using a conservative width estimate for a few predictable fonts.
    renderedText = displayLabelText(text, allCaps);
    textLength = labelLengthFromText(text, font, size, lengthPadding, allCaps, roundCorners, cornerRadius);
    textInset = effectiveTextInset(lengthPadding, roundCorners, cornerRadius);
    textX = textAlignment == "left" ? textInset + labelSafetyMargin(size) : textLength / 2;
    horizontalAlign = textAlignment == "left" ? "left" : "center";

    if (separateParts) {
        // Multicolor workflow: keep body and text as separate solids for slicer part colors.
        color(bodyColor)
            labelBody(textLength, labelHeight, labelThickness, roundCorners, cornerRadius, addEdgeBevel, edgeBevelSize);

        color(textColor)
            translate([textX, labelHeight / 2, labelThickness])
                linear_extrude(height=textHeight)
                    text(text=renderedText, size=size, font=font, halign=horizontalAlign, valign="center");
    } else {
        // Single-body workflow: combine geometry into one solid.
        union() {
            color(bodyColor)
                labelBody(textLength, labelHeight, labelThickness, roundCorners, cornerRadius, addEdgeBevel, edgeBevelSize);

            color(textColor)
                translate([textX, labelHeight / 2, labelThickness])
                    linear_extrude(height=textHeight)
                        text(text=renderedText, size=size, font=font, halign=horizontalAlign, valign="center");
        }
    }
}

module labelsFromTextList(
    labelTexts=["Sockets"],
    printBedSize=256,
    columnSpacing=6,
    rowSpacing=8,
    font="Verdana:style=Bold",
    size=10,
    labelHeight=17,
    labelThickness=2,
    lengthPadding=5,
    allCaps=false,
    textAlignment="center",
    bodyColor="Blue",
    textColor="White",
    separateParts=true,
    roundCorners=true,
    cornerRadius=1,
    addEdgeBevel=true,
    edgeBevelSize=0.4,
    textHeight=0.8
) {
    for (i = [0 : len(labelTexts) - 1]) {
        placementState = labelPlacementState(labelTexts, i, printBedSize, font, size, lengthPadding, columnSpacing, allCaps, roundCorners, cornerRadius);
        xOffset = placementState[0];
        yOffset = -placementState[1] * (labelHeight + rowSpacing);

        translate([xOffset, yOffset, 0])
            labelWithText(
                text=labelTexts[i],
                font=font,
                size=size,
                labelHeight=labelHeight,
                labelThickness=labelThickness,
                lengthPadding=lengthPadding,
                allCaps=allCaps,
                textAlignment=textAlignment,
                bodyColor=bodyColor,
                textColor=textColor,
                separateParts=separateParts,
                roundCorners=roundCorners,
                cornerRadius=cornerRadius,
                addEdgeBevel=addEdgeBevel,
                edgeBevelSize=edgeBevelSize,
                textHeight=textHeight
            );
    }
}

// Generate one label for each text entry using the user settings above.
labelsFromTextList(
    labelTexts=userLabelTexts,
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