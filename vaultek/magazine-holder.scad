include <BOSL2/std.scad>
include <functions.scad>

$magazineHeight = 60;
$magazineWidth = 15;
$magazineDepth = 36;
$magazineSpacing = 4;

module magazineHolder(magazinesDeep, magazinesWide, holderHeight, magazineWidth, magazineDepth, spacing){
    
    difference(){
        $totalWidth = magazinesWide * (magazineWidth + spacing) + spacing;
        $totalDepth = magazinesDeep * (magazineDepth + spacing) + spacing;
    
        group(){
            color("blue")
            translate([0,-$totalDepth/2,0])
            accessoryBaseWithPins($totalWidth-4, holderHeight, 0);

            cuboid([$totalWidth, $totalDepth, holderHeight], rounding = 2, $fn = 50);
        }
        
        $startingX = $totalWidth/2;
        $startingY = -$totalDepth/2 + spacing;
        for(i = [1 : magazinesWide]){
            for(j = [0 : magazinesDeep - 1]){
                $newX = $startingX - i * (magazineWidth + spacing);
                $newY = j * (magazineDepth + spacing);
                translate([$newX, $startingY + $newY,-holderHeight/2+3])
                #cube([magazineWidth,magazineDepth,holderHeight]);
            }
        }
    }
}


magazineHolder(2, 4, $magazineHeight, $magazineWidth, $magazineDepth, $magazineSpacing);