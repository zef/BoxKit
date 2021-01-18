include <Round-Anything/polyround.scad>


stockThickness = 3;
wallThickness = 1.2;
clearance = 0.0;
height = 12;
sideLength = 20;
insideHeight = 0;


slotThickness = stockThickness + clearance;
totalWall = (wallThickness * 2) + slotThickness;

outsideCornerRound = 1;
edgeCornerRound = 1;

module slot() {
    translate([wallThickness, wallThickness, wallThickness]) 
    cube([slotThickness, sideLength, height]);
}

module bottom_corner() {
    difference() {
        linear_extrude(height) {    
            polygon(
                polyRound([
                    [0,0, outsideCornerRound], 
                    [0, sideLength, edgeCornerRound],
                    [totalWall, sideLength, edgeCornerRound],
                    [sideLength, totalWall, edgeCornerRound],
                    [sideLength, 0, edgeCornerRound]
                ])
            );
        }

        // cutout slots for panels 
        slot();
        rotate([0, 0, 270]) translate([-totalWall, 0, 0]) slot();
     
        // flatten out inside ledge, providing suppport for the bottom part
        translate([slotThickness, slotThickness, wallThickness + insideHeight]) cube([sideLength, sideLength, height]);   
    }
}


module top_corner() {
    difference() {
        linear_extrude(height) {    
            polygon(
                polyRound([
                    [0,0, outsideCornerRound], 
                    [0, sideLength, edgeCornerRound],
                    [totalWall, sideLength, edgeCornerRound],
                    [totalWall, totalWall, edgeCornerRound],    
                    [sideLength, totalWall, edgeCornerRound],
                    [sideLength, 0, edgeCornerRound]
                ])
            );
        }
        
        slot();
        rotate([0, 0, 270]) translate([-totalWall, 0, 0]) slot();
    };
}

module 3_way() {
    difference() {
        union() {
            top_corner();
            mirror([0, 1,0]) translate([0, -(slotThickness + wallThickness * 2),0]) top_corner();
        }
        translate([0, -wallThickness*2, 0]) slot();
    }
}

module 4_way() {
    difference() {
        union() {
            3_way();
            mirror([1,0,0]) translate([-(slotThickness + wallThickness * 2), 0,0]) 3_way();           
        }
        rotate([0, 0, 270]) translate([-totalWall, -wallThickness * 2, 0]) slot();
    }
}


bottom_corner();

translate([0, sideLength + 10, 0]) top_corner();
translate([0, sideLength * 3 + 20, 0]) 3_way();
translate([0, sideLength * 5 + 30, 0]) 4_way();




