totalLength = 36; // [32:100]


{}

screwShaftLength = 30;

screwHeadDiameter = 15;
screwDiameter = 11;

part1Length = 5;
part2Length = 10;
part3Lenght = totalLength - part1Length - part2Length;

$fn = 100;
difference() {
    minkowski() {
        group() {
            // Part 1
            cylinder(h = part1Length, d = 25);

            // Part 2
            translate([0,0,part1Length])
            cylinder(h = part2Length, d1=25, d2=34);

            // Part 3
            translate([0,0,part2Length + part1Length])
            cylinder(h = part3Lenght, d=34);
        }
        
        sphere(.5);
    }

    // Cut out for the full length of the screw
    translate([0,0,totalLength/2])
    cylinder(h = totalLength * 1.1, d = screwDiameter, center = true);
    
    // Cut out for the head of the screw
    screwHeadCutoutHeight = (totalLength - screwShaftLength);
    translate([0,0,screwShaftLength])
    cylinder(h = screwHeadCutoutHeight*1.1, d = screwHeadDiameter);
}