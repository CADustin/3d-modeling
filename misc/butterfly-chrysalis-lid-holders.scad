$fn = 128;

$lid_diameter = 80;
$lid_height = 10;

$holder_diameter = 40;
$holder_length = 80;

$base_height = 2;

$slot_clearance = 0.6;
$slot_depth = 12;

$clip_length = 12;
$clip_inset = 0.8;
$clip_height = 3.2;

holder_radius = $holder_diameter / 2;
base_diameter = sqrt(($holder_length * $holder_length) + ($holder_diameter * $holder_diameter)) + 2;
slot_width = $lid_height + $slot_clearance;
slot_length = $holder_length + 2;

module holder_envelope() {
    intersection() {
        translate([-$holder_length / 2, 0, 0])
            rotate([0, 90, 0])
                cylinder(h = $holder_length, r = holder_radius);

        translate([-$holder_length / 2, -holder_radius, 0])
            cube([$holder_length, $holder_diameter, holder_radius]);
    }
}

union() {
    translate([0, 0, -$base_height])
        cylinder(h = $base_height, d = base_diameter);

    difference() {
        holder_envelope();

        translate([-$holder_length / 2 - 1, -slot_width / 2, holder_radius - $slot_depth])
            cube([slot_length, slot_width, $slot_depth + 1]);
    }

    intersection() {
        holder_envelope();

        translate([-$clip_length / 2, -slot_width / 2, holder_radius - $clip_height])
            cube([$clip_length, $clip_inset, $clip_height]);
    }

    intersection() {
        holder_envelope();

        translate([-$clip_length / 2, slot_width / 2 - $clip_inset, holder_radius - $clip_height])
            cube([$clip_length, $clip_inset, $clip_height]);
    }
}