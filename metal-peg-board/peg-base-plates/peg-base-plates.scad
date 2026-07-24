// Metal peg board base plate reconstructed from exported 3MF models.
//
// Customizer surface:
// - columns
// - rows
// - plateThickness
//
// Reuse from another file with:
// use <peg-base-plates.scad>
// pegBasePlate(columnCount = 2, rowCount = 2, boardThickness = 2);

/* [Plate] */

// Number of peg columns.
columns = 4; // [1:1:8]

// Number of peg rows.
rows = 2; // [1:1:6]

// Thickness of the plate body in millimeters.
plateThickness = 2; // [1:0.1:5]

/* [Hidden] */

pegDiameter = 10;
notchDiameter = 6;
pegLength = 10;
notchHeight = 1.49;

columnPitch = 22;
rowPitch = 32;

pegSegments = 32;
plateSingleSpan = 14;
plateEdgeMargin = 6;
plateTwoRowHeight = 46;

function plateWidth(columnCount) = columnCount == 1 ? plateSingleSpan : (columnCount - 1) * columnPitch + plateEdgeMargin * 2;
function plateHeight(rowCount) = rowCount == 1 ? plateSingleSpan : rowCount == 2 ? plateTwoRowHeight : rowCount * rowPitch - 18;

function columnCenter(columnIndex, columnCount) = (columnIndex - (columnCount - 1) / 2) * columnPitch;
function rowCenter(rowIndex, rowCount) = (rowIndex - (rowCount - 1) / 2) * rowPitch;

// Peg profile measured from the exported model.
// The small keyed notch near the plate lets the peg flex during insertion.
module pegNotchProfile() {
    union() {
        intersection() {
            circle(d = pegDiameter, $fn = pegSegments);
            translate([-pegDiameter / 2, 0])
                square([pegDiameter, pegDiameter / 2]);
        }

        intersection() {
            circle(d = notchDiameter, $fn = pegSegments);
            translate([-notchDiameter / 2, -notchDiameter / 2])
                square([notchDiameter, notchDiameter / 2]);
        }
    }
}

// Single peg with a short keyed notch at the plate end.
module peg() {
    rotate([90, 0, 0])
        linear_extrude(height = notchHeight)
            pegNotchProfile();

    translate([0, -notchHeight, 0])
        rotate([90, 0, 0])
            cylinder(h = pegLength - notchHeight, d = pegDiameter, $fn = pegSegments);
}

// Reusable plate module.
// columnCount: number of peg columns.
// rowCount: number of peg rows.
// boardThickness: thickness of the rectangular plate body.
module pegBasePlate(columnCount = columns, rowCount = rows, boardThickness = plateThickness) {
    boardWidth = plateWidth(columnCount);
    boardHeight = plateHeight(rowCount);

    union() {
        cube([boardWidth, boardThickness, boardHeight], center = true);

        for (rowIndex = [0 : rowCount - 1]) {
            for (columnIndex = [0 : columnCount - 1]) {
                translate([
                    columnCenter(columnIndex, columnCount),
                    -boardThickness / 2,
                    rowCenter(rowIndex, rowCount)
                ])
                    peg();
            }
        }
    }
}

// Standalone render using the current customizer values.
pegBasePlate();