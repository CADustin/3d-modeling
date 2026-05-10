/* [Label Text] */

// Enter one label per quoted item.
userLabelTexts = [
    "Sockets",
    "Deep Sockets",
    "Impact Sockets",
    "Ratchets",
    "Extensions",
    "Adapters",
    "Wrenches",
    "Stubby Wrenches",
    "Allen Keys",
    "Torx Keys",
    "Screwdrivers",
    "Nut Drivers",
    "Pliers",
    "Needle Nose",
    "Channel Locks",
    "Vise Grips",
    "Picks",
    "Pry Bars",
    "Hammers",
    "Electrical"
];

// Woodworking-focused alternate list:
// userLabelTexts = [
//     "Chisels",
//     "Hand Planes",
//     "Block Plane",
//     "Marking Tools",
//     "Squares",
//     "Measuring",
//     "Layout Tools",
//     "Router Bits",
//     "Drill Bits",
//     "Forstner Bits",
//     "Countersinks",
//     "Clamps",
//     "Glue Supplies",
//     "Sanding",
//     "Files",
//     "Rasps",
//     "Carving Tools",
//     "Sharpening",
//     "Fasteners",
//     "Hardware"
// ];

// Font name installed on your system. Verdana is the recommended choice for readability.
userFont = "Verdana:style=Bold"; // ["Verdana:style=Bold", "Arial:style=Bold", "Tahoma:style=Bold"]

// Convert label text to uppercase before rendering.
userAllCaps = false;

// Text alignment inside the label.
userTextAlignment = "center"; // ["center", "left"]

// Text size in mm.
userTextSize = 10; // [6:0.5:14]

// Extra blank space added to each end of the label.
userLengthPadding = 5; // [2:0.5:12]

/* [Shape] */

// Enable rounded label corners.
userRoundCorners = true;

// Rounded corner radius in mm.
userCornerRadius = 1; // [0:0.1:3]

// Add a small 45-degree bevel around the top perimeter edge.
userAddEdgeBevel = true;

// Top edge bevel size in mm.
userEdgeBevelSize = 0.4; // [0:0.05:1]

/* [Colors] */

// Preview color for the main label body.
userBodyColor = "Blue"; // [Blue, White, Black, Gray, LightGray, Red, Orange, Yellow, Green, Teal, Cyan, Purple, Brown]

// Preview color for the raised text.
userTextColor = "White"; // [White, Black, Blue, Gray, LightGray, Red, Orange, Yellow, Green, Teal, Cyan, Purple, Brown]

// Keep body and text as separate parts for multicolor printing.
userSeparateParts = true;

/* [Layout] */

// Print bed size in mm.
printBedSize = 256; // [180, 256, 320]

// Space between labels in the same row.
userColumnSpacing = 6; // [2:1:20]

// Space between rows of labels.
userRowSpacing = 8; // [2:1:20]

/* [Printer Reference] */

// 180 = Bambu A1 Mini
// 256 = Bambu A1, P1P, P1S, X1C
// 320 = Bambu H2D, H2S

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

// 3D body: fixed 17mm tall and 2mm thick, with optional top perimeter bevel.
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
    lengthPadding=5,
    allCaps=false,
    textAlignment="center",
    bodyColor="Blue",
    textColor="White",
    separateParts=true,
    roundCorners=true,
    cornerRadius=1,
    addEdgeBevel=true,
    edgeBevelSize=0.4
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
            labelBody(textLength, 17, 2, roundCorners, cornerRadius, addEdgeBevel, edgeBevelSize);

        color(textColor)
            translate([textX, 17 / 2, 2])
                linear_extrude(height=1)
                    text(text=renderedText, size=size, font=font, halign=horizontalAlign, valign="center");
    } else {
        // Single-body workflow: combine geometry into one solid.
        union() {
            color(bodyColor)
                labelBody(textLength, 17, 2, roundCorners, cornerRadius, addEdgeBevel, edgeBevelSize);

            color(textColor)
                translate([textX, 17 / 2, 2])
                    linear_extrude(height=1)
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
    lengthPadding=5,
    allCaps=false,
    textAlignment="center",
    bodyColor="Blue",
    textColor="White",
    separateParts=true,
    roundCorners=true,
    cornerRadius=1,
    addEdgeBevel=true,
    edgeBevelSize=0.4
) {
    for (i = [0 : len(labelTexts) - 1]) {
        placementState = labelPlacementState(labelTexts, i, printBedSize, font, size, lengthPadding, columnSpacing, allCaps, roundCorners, cornerRadius);
        xOffset = placementState[0];
        yOffset = -placementState[1] * (17 + rowSpacing);

        translate([xOffset, yOffset, 0])
            labelWithText(
                text=labelTexts[i],
                font=font,
                size=size,
                lengthPadding=lengthPadding,
                allCaps=allCaps,
                textAlignment=textAlignment,
                bodyColor=bodyColor,
                textColor=textColor,
                separateParts=separateParts,
                roundCorners=roundCorners,
                cornerRadius=cornerRadius,
                addEdgeBevel=addEdgeBevel,
                edgeBevelSize=edgeBevelSize
            );
    }
}

// Generate one label for each text entry using the user settings above.
labelsFromTextList(
    labelTexts=userLabelTexts,
    printBedSize=printBedSize,
    columnSpacing=userColumnSpacing,
    rowSpacing=userRowSpacing,
    font=userFont,
    size=userTextSize,
    lengthPadding=userLengthPadding,
    allCaps=userAllCaps,
    textAlignment=userTextAlignment,
    bodyColor=userBodyColor,
    textColor=userTextColor,
    separateParts=userSeparateParts,
    roundCorners=userRoundCorners,
    cornerRadius=userCornerRadius,
    addEdgeBevel=userAddEdgeBevel,
    edgeBevelSize=userEdgeBevelSize
);