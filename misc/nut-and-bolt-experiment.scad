include <threadlib/threadlib.scad>;

// small test sizes
major_d   = 10;     // mm
pitch     = 1.5;    // mm
bolt_len  = 10;     // mm
nut_thick = 5;      // mm

// -------------------------
// Bolt
// -------------------------
module test_bolt() {
    union() {
        // core
        cylinder(h = bolt_len, r = major_d/2 - pitch/2);

        // external thread (positional args)
        straight_thread(major_d, pitch, bolt_len, false);

        // hex head
        translate([0,0,bolt_len])
            cylinder(h = 4, r = 8, $fn=6);
    }
}

// -------------------------
// Nut
// -------------------------
module test_nut() {
    difference() {
        // hex body
        cylinder(h = nut_thick, r = 8, $fn=6);

        // internal thread (positional args)
        straight_thread(major_d + 0.3, pitch, nut_thick + pitch, true);
    }
}

// -------------------------
// Scene
// -------------------------
translate([-20,0,0]) test_bolt();
translate([ 20,0,0]) test_nut();
