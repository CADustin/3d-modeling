$fn = 128;

$lid_diameter = 80;
$lid_height = 10;

$holder_diameter = 40;
$holder_length = 70;

$base_height = 2;
$edge_radius = 1;

$slot_clearance = 0.6;

$clip_length = 12;
$clip_inset = 0.8;
$clip_height = 3.2;

holder_radius = $holder_diameter / 2;
base_diameter = sqrt(($holder_length * $holder_length) + ($holder_diameter * $holder_diameter)) + 2;
slot_width = $lid_height + $slot_clearance;
groove_radius = $lid_diameter / 2;
groove_center_z = groove_radius;

module holder_envelope() {
    minkowski() {
        intersection() {
            translate([-$holder_length / 2 + $edge_radius, 0, 0])
                rotate([0, 90, 0])
                    cylinder(h = $holder_length - (2 * $edge_radius), r = holder_radius - $edge_radius);

            translate([-$holder_length / 2 + $edge_radius, -holder_radius + $edge_radius, $edge_radius])
                cube([
                    $holder_length - (2 * $edge_radius),
                    $holder_diameter - (2 * $edge_radius),
                    holder_radius - (2 * $edge_radius)
                ]);
        }

        sphere(r = $edge_radius);
    }
}

module lid_groove() {
    translate([0, -slot_width / 2, groove_center_z])
        rotate([-90, 0, 0])
            cylinder(h = slot_width, r = groove_radius);
}

union() {
    translate([0, 0, -$base_height])
        cylinder(h = $base_height, d = base_diameter);

    difference() {
        holder_envelope();

        lid_groove();
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