/* [Lint Roll] */
///////////////////////////////////////////////////////////////////
// The inner diameter of the cardboard tube (in mm).
$rollerTubeDiameter = 38.2;

{}
/* [Misc. properties] */
// The size in mm for the pins on the end of the tubes (in mm).
$pinSizeForTubeEnds = 5; // [3:6]

difference(){
    group(){
        cylinder($fn=25, h = 10, d = $rollerTubeDiameter);
        cylinder($fn=100, h = 2, d = $rollerTubeDiameter+2);
    }
    
    color("green")
    sphere($fn = 25, d = $pinSizeForTubeEnds);
}