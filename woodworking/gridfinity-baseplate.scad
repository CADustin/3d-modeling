// Gridfinity baseplate generator for drawers (standard 42 mm pitch)
// Bambu Studio may import the exported 3MF as one object even though the
// separated plates and spacers are disconnected. Use Split > To objects in
// Bambu Studio before arranging them. Set pieceIndex to export one piece at a time.
// Fills a drawer with baseplate cells, optional spacers for the leftover gap,
// and splits everything into pieces that fit a maximum print bed.

/* [Drawer] */
// Interior drawer width (X) in mm
drawerWidth = 400;
// Interior drawer depth (Y) in mm
drawerDepth = 300;
// Total slack subtracted from the drawer so the plates slide in easily
fitClearance = 0.5;

/* [Spacers] */
// Where the leftover gap is filled with spacer strips
spacerPlacement = "center"; // [center:Split on both sides, start:Left and front only, end:Right and back only, none:No spacers]
// Gaps narrower than this are ignored (mm)
minSpacerWidth = 2;

/* [Print Bed] */
// Split into pieces that fit the bed
splitForBed = true;
bedWidth = 180;
bedDepth = 180;

/* [Plate] */
// Solid floor under the cells (0 = open grid, lighter and faster; raised automatically when magnet holes are on)
bottomThickness = 0;
magnetHoles = false;
magnetDiameter = 6.5;
magnetDepth = 2.4;

/* [View] */
// 0 = all pieces assembled, otherwise show only that piece at the origin for printing
pieceIndex = 0; // [0:1:100]
// Space the pieces apart so they export as separate bodies; turn off to see the assembled drawer for measuring
separatePieces = true;
// Gap between pieces in mm when separated
pieceGap = 5; // [1:1:20]

/* [Gridfinity Standard] */
gridPitch = 42;
plateProfileHeight = 4.65;
pocketRadius = 4;

/* [Hidden] */
$fn = 48;
eps = 0.01;

// Magnet holes need material under them, so force a minimum floor when enabled
floorThickness = magnetHoles ? max(bottomThickness, magnetDepth + 0.6) : bottomThickness;
plateHeight = plateProfileHeight + floorThickness;
usableWidth = drawerWidth - fitClearance;
usableDepth = drawerDepth - fitClearance;
cellsX = floor(usableWidth / gridPitch);
cellsY = floor(usableDepth / gridPitch);
gridWidth = cellsX * gridPitch;
gridDepth = cellsY * gridPitch;

function gapSize(total, grid) = total - grid;
function usableGap(g) = (spacerPlacement != "none" && g >= minSpacerWidth) ? g : 0;
gapX = usableGap(gapSize(usableWidth, gridWidth));
gapY = usableGap(gapSize(usableDepth, gridDepth));
startX = spacerPlacement == "center" ? gapX / 2 : (spacerPlacement == "start" ? gapX : 0);
endX = gapX - startX;
startY = spacerPlacement == "center" ? gapY / 2 : (spacerPlacement == "start" ? gapY : 0);
endY = gapY - startY;

// Evenly split `count` items into groups of at most `maxPer`
function groupSizes(count, maxPer) =
    let (n = ceil(count / maxPer), base = floor(count / n), extra = count - base * n)
    [for (i = [0:n - 1]) base + (i < extra ? 1 : 0)];
function sumTo(list, i) = i <= 0 ? 0 : list[i - 1] + sumTo(list, i - 1);
// Evenly split a length into pieces no longer than maxLen
function lengthParts(length, maxLen) =
    let (n = ceil(length / maxLen - 0.0001)) [for (i = [0:n - 1]) [i * length / n, length / n]];

maxCellsX = splitForBed ? max(1, floor(bedWidth / gridPitch)) : max(cellsX, 1);
maxCellsY = splitForBed ? max(1, floor(bedDepth / gridPitch)) : max(cellsY, 1);
colSizes = cellsX > 0 ? groupSizes(cellsX, maxCellsX) : [];
rowSizes = cellsY > 0 ? groupSizes(cellsY, maxCellsY) : [];
spacerLenX = splitForBed ? bedWidth : usableWidth;
spacerLenY = splitForBed ? bedDepth : usableDepth;

// Piece format: [type, x, y, width, depth, cellsX, cellsY]
platePieces = [for (c = [0:len(colSizes) - 1], r = [0:len(rowSizes) - 1])
    ["plate", startX + sumTo(colSizes, c) * gridPitch, startY + sumTo(rowSizes, r) * gridPitch,
     colSizes[c] * gridPitch, rowSizes[r] * gridPitch, colSizes[c], rowSizes[r]]];

// Left/right strips run the full drawer depth; front/back strips fit between them
sideStrips = [
    if (startX > 0) each [for (p = lengthParts(usableDepth, spacerLenY)) ["spacer", 0, p[0], startX, p[1], 0, 0]],
    if (endX > 0) each [for (p = lengthParts(usableDepth, spacerLenY)) ["spacer", startX + gridWidth, p[0], endX, p[1], 0, 0]]
];
endStrips = cellsX > 0 ? [
    if (startY > 0) each [for (p = lengthParts(gridWidth, spacerLenX)) ["spacer", startX + p[0], 0, p[1], startY, 0, 0]],
    if (endY > 0) each [for (p = lengthParts(gridWidth, spacerLenX)) ["spacer", startX + p[0], startY + gridDepth, p[1], endY, 0, 0]]
] : [];

pieces = concat(platePieces, sideStrips, endStrips);

// Number of distinct start positions below v, used to space pieces apart
function uniqueSorted(list) = [for (i = [0:len(list) - 1]) if (len([for (j = [0:i - 1]) if (abs(list[j] - list[i]) < 0.01) 1]) == 0) list[i]];
function rankOf(v, list) = len([for (u = list) if (u < v - 0.01) 1]);
activeGap = separatePieces ? pieceGap : 0;
pieceXs = uniqueSorted([for (p = pieces) p[1]]);
pieceYs = uniqueSorted([for (p = pieces) p[2]]);

// Pocket profile, top to bottom: 0.7 chamfer, 1.8 vertical, 2.15 chamfer
module pocketSlab(inset, z) {
    translate([inset, inset, z])
        linear_extrude(eps)
            offset(r = max(pocketRadius - inset, 0.8))
                translate([max(pocketRadius - inset, 0.8), max(pocketRadius - inset, 0.8)])
                    square(gridPitch - 2 * inset - 2 * max(pocketRadius - inset, 0.8));
}

module pocket() {
    top = plateHeight;
    profile = [[top + eps, -eps], [top - 0.7, 0.7], [top - 2.5, 0.7], [floorThickness, 2.85]];
    for (i = [0:len(profile) - 2])
        hull() {
            pocketSlab(max(profile[i][1], 0), profile[i][0]);
            pocketSlab(profile[i + 1][1], profile[i + 1][0]);
        }
}

module magnetCutouts() {
    for (mx = [-1, 1], my = [-1, 1])
        translate([gridPitch / 2 + mx * 13, gridPitch / 2 + my * 13, floorThickness - magnetDepth])
            cylinder(d = magnetDiameter, h = magnetDepth + eps);
}

module platePiece(w, d, cx, cy) {
    difference() {
        cube([w, d, plateHeight]);
        for (x = [0:cx - 1], y = [0:cy - 1])
            translate([x * gridPitch, y * gridPitch, 0]) {
                pocket();
                if (magnetHoles) magnetCutouts();
            }
    }
}

module spacerPiece(w, d) {
    cube([w, d, plateHeight]);
}

module showPiece(p) {
    if (p[0] == "plate") platePiece(p[3], p[4], p[5], p[6]);
    else spacerPiece(p[3], p[4]);
}

echo(str("Grid: ", cellsX, " x ", cellsY, " cells; spacer gaps X=", gapX, " Y=", gapY,
    "; pieces: ", len(pieces), " (use pieceIndex 1..", len(pieces), ")"));

for (i = [0:len(pieces) - 1])
    echo(str("pieceIndex ", i + 1, ": ", pieces[i][0], " ", pieces[i][3], " x ", pieces[i][4], " mm"));

if (pieceIndex == 0) {
    for (p = pieces)
        translate([p[1] + rankOf(p[1], pieceXs) * activeGap, p[2] + rankOf(p[2], pieceYs) * activeGap, 0])
            showPiece(p);
} else if (pieceIndex <= len(pieces)) {
    showPiece(pieces[pieceIndex - 1]);
}
