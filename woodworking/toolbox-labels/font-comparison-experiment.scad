// ------------------------------------------------------------
// Demonstration of useful OpenSCAD built‑in fonts for labels
// Text: "WRENCHES"
// Includes: Regular fonts + Italic/Oblique variants
// ------------------------------------------------------------

text_string = "WRENCHES";

// Vertical spacing between samples
y_step = 20;

// Helper module
module sample(y, fontname) {
    translate([0, y, 0])
        linear_extrude(height=2)
            text(text_string,
                 font=fontname,
                 size=12,
                 halign="left",
                 valign="baseline");
}

sample(5 * y_step, "Liberation Sans:style=Bold");
sample(4 * y_step, "Liberation Sans Narrow:style=Bold");
sample(3 * y_step, "Liberation Mono:style=Bold Italic");
sample(2 * y_step, "Liberation Sans:style=Bold Italic");
sample(1 * y_step, "DejaVu Sans:style=Bold Oblique");
