
// https://github.com/Irev-Dev/Round-Anything
include <Round-Anything/polyround.scad>
include <Round-Anything/MinkowskiRound.scad>

// https://github.com/revarbat/BOSL/wiki
include <BOSL/constants.scad>
use <BOSL/transforms.scad>
use <BOSL/shapes.scad>

// the "stock" refers to the panel material that will make up the sides of the box
stockThickness = 3;
perimeters = 3;
extrusionWidth = 0.45;

// how much space is added to the stock thickness
clearance = 0.0;

// the height determines how far the corner material will come up past the edge of the stock, or how tall the corner parts are
height = 12;

// sideLength determines how far the arms of the bracket extend from the corner of the stock
sideLength = 26;


// the wall thickness determines:
// - the thickness of vertical walls that surround the stock
// - the thickness of the
wallThickness = perimeters * extrusionWidth;

// this affects the bottom corner piece only
// Instead of leaving a completely flat bottom, this creates a ledge,
// creating a more solid slot for the side walls to sit inside, and elevating the base of the entire tray by this amount
insideHeight = 0;

slotThickness = stockThickness + clearance;
totalWall = (wallThickness * 2) + slotThickness;

outsideCornerRound = 1;
edgeCornerRound = 1;

// interlock = true;


// could do some parameter validation, but may be fine to leave that to the user


module slot() {
    translate([wallThickness, wallThickness, wallThickness])
    cube([slotThickness, sideLength, height]);
}

module bottom_corner_triangle_shape() {
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

module corner_shape() {
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



module bottom_corner(interlock = false) {
    difference() {
        linear_extrude(height) {
            bottom_corner_triangle_shape();
        }

        // cutout slots for panels
        slot();
        zrot(270) left(totalWall) slot();

        // flatten out inside ledge, providing suppport for the bottom part
        translate([slotThickness, slotThickness, wallThickness + insideHeight]) cube([sideLength, sideLength, height]);

        if (interlock) {
            interlock();
        }
    }
}


module top_corner(interlock = false) {
    union() {
        difference() {
            linear_extrude(height) {
                corner_shape();
            }

            slot();
            zrot(270) left(totalWall) slot();
        };

        if (interlock) {
            interlock();
        }
    }
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

module back_plate(side = 10) {

    plate_height = side * .6;

    mirror_copy([0,0,1], 0, [0,0,totalWall/2])
    difference() {
        yrot(90) xflip() left(plate_height)
        linear_extrude(side) polygon(
            polyRound([
                [0,0, 0],
                [0, wallThickness, 2],
                [plate_height, wallThickness, 4],
                [plate_height, wallThickness * 4, 0],
                [plate_height + totalWall, wallThickness * 4, 0],
                [plate_height + totalWall, 0, 0],
            ], fn = 20)
        );

    xrot(90, cp = [0,0,wallThickness/2])  right(side/2) forward(plate_height/1.7)  cylinder(wallThickness+.1, 4, 2, $fn = 30, center = true);

    }


}

module flat_corner() {
    overhang = 8;
    side = sideLength + 4;

    difference() {
        linear_extrude(totalWall) {
            corner_shape();
        }

        // cut out slot for shelf sheet
        cutDepth = wallThickness;
        translate([cutDepth, cutDepth, wallThickness]) cube([side, side, slotThickness]);
    };
}


// old cylinder idea, never tried printing
module interlock() {
    radius = wallThickness/3;
    translate([totalWall / 2, totalWall / 2, 0])
    zrot_copies([0, 90], r = totalWall/2)
    cyl(sideLength - (totalWall*2), r=radius, fillet=radius, orient=ORIENT_X, center=false, $fn=20);
}

// protrusion from bottom corner. I like the idea but I'm not sure how to print it...
// maybe make an interlock as a separate piece that is glued on and inserted using a couple alignment pins?
//module interlock(scaleClearance = 1.15) {
//    difference() {
//        linear_extrude(wallThickness) bottom_corner_triangle_shape();
//        translate([-.1, -.1, -.1]) scale([scaleClearance, scaleClearance, scaleClearance]) linear_extrude(wallThickness + 1) corner_shape();
//
//    }
//}


//bottom_corner(true);

//top_corner(true);

hingeDepth = 5;

module flat_corner_hinge() {
    move(y=-hingeDepth) cube([sideLength, hingeDepth, totalWall]);
//    move(y= -wallThickness)
    flat_corner();
}


module top_corner_hinge() {
    radius = hingeDepth/2;
    top_corner(false);
    move(z = radius, y = -radius) yrot(90) cyl(sideLength, r=radius, center=false, $fn=40);
//    move(y = -radius *2) xrot(90) flat_corner();
}


//top_corner_hinge();
//
//move(z= -hingeDepth-1)
//    flat_corner_hinge();

module bottom_corners(spacing = totalWall/2) {
    distance = (sideLength) + spacing;
    rot_copies(n=4, delta = [distance,distance,0]) zrot(180) bottom_corner();
}

module top_corners_tight() {
    distance = sideLength;// (sideLength * 2) + (totalWall * 2) + (bed_spacing * 2);
    rot_copies(n=4, delta = [totalWall,sideLength - totalWall,0]) zrot(180) xmove(-totalWall-wallThickness) top_corner();
}

bottom_corners();


bottom_corners(totalWall * 1.5);
//top_corners();
top_corners_tight();

//ydistribute(sideLength * 2 + 10) {
//    bottom_corner(false);
//    top_corner(false);
////    bottom_corner(true);
////    top_corner(true);
//    3_way();
//    4_way();
//
//    flat_corner();
//}


