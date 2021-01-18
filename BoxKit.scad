
// https://github.com/Irev-Dev/Round-Anything
include <Round-Anything/polyround.scad>

// https://github.com/revarbat/BOSL/wiki
include <BOSL/constants.scad>
use <BOSL/transforms.scad>

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
        zrot(270) left(totalWall) slot();

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
        zrot(270) left(totalWall) slot();
    };
}

module 3_way() {
    difference() {
        mirror_copy([0,1,0], 0, [0,(wallThickness + slotThickness/2),0]) top_corner();
        forward(sideLength / 2) slot();
    }
}

module 4_way() {
    difference() {
        mirror_copy([1,0,0], 0, [(wallThickness + slotThickness/2),0,0]) 3_way();
        zrot(90) forward((wallThickness*3) + sideLength/2) slot();
    }
}

bottom_corner();

back(sideLength + 10) top_corner();
back(sideLength * 3 + 20) 3_way();
back(sideLength * 5 + 30) 4_way();




