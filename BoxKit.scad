
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

$fn = 80;

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

//module back_plate(side = 10) {
//    plate_height = side * .6;
//
//    mirror_copy([0,0,1], 0, [0,0,totalWall/2])
//    difference() {
//        yrot(90) xflip() left(plate_height)
//        linear_extrude(side) polygon(
//            polyRound([
//                [0,0, 0],
//                [0, wallThickness, 2],
//                [plate_height, wallThickness, 4],
//                [plate_height, wallThickness * 4, 0],
//                [plate_height + totalWall, wallThickness * 4, 0],
//                [plate_height + totalWall, 0, 0],
//            ])
//        );
//
//        xrot(90, cp = [0,0,wallThickness/2])  right(side/2) forward(plate_height/1.7)  cylinder(wallThickness+.1, 4, 2);
//    }
//}

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
    cyl(sideLength - (totalWall*2), r=radius, fillet=radius, orient=ORIENT_X, center=false);
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


/// distribution

module bottom_corners(spacing = totalWall/2) {
    distance = (sideLength) + spacing;
    rot_copies(n=4, delta = [distance,distance,0]) zrot(180) bottom_corner();
}

module top_corners_tight() {
    distance = sideLength;// (sideLength * 2) + (totalWall * 2) + (bed_spacing * 2);
    rot_copies(n=4, delta = [totalWall,sideLength - totalWall,0]) zrot(180) xmove(-totalWall-wallThickness) top_corner();
}

//bottom_corners(totalWall * 1.5);
//top_corners_tight();

hinge_depth = totalWall;

// the width of the outside support of the hinge part. One is placed on each side of the hinge.
hinge_wing = totalWall;


// the amount of space allowed for clearance on each side of the hinge connection.
hinge_clearance = 0.3;
hinge_inside_length = sideLength - (hinge_wing + hinge_clearance) * 2;

// the size of the ball that is used for ball hinges
hinge_ball = hinge_depth * .6;

// the amount by which the indentation is increased to provide some clearance between
// the ball and the indentation
hinge_ball_clearance = hinge_clearance;

// the percentage that the ball is protruded from the wing
// 0: a full half of the ball is protruding
// 1: the ball is not protruding at all
// the indentation is likewise adjusted
hinge_ball_pullback = .2;


hinge_type = "filament"; // [none, ball, filament]


// indent indicates that one side of the slot will be closed off
// so that only one side of filament needs to be sealed
module add_filament_hinge(diameter = 1.75) {
    if (hinge_type == "filament") {
        difference() {
            children(0);
            // this movement closes off one side of the outside hinge, so the filament only needs
            // to be secured on one side, it does not affect the inside hinge.
            zmove(wallThickness)
            cylinder(sideLength, d = diameter);
        }
    } else {
        children();
    }
}

module add_ball_hinge(indent = true) {
    if (hinge_type == "ball") {
        if (indent) {
            diameter = hinge_ball + hinge_clearance;
            copy_offset = hinge_inside_length / 2 + (diameter/2 * hinge_ball_pullback);
            difference() {
               children(0);
               zmove(sideLength/2) zflip_copy(offset=copy_offset) sphere(d = diameter);
            }
        } else {
            diameter = hinge_ball;
            movement = (diameter/2) * hinge_ball_pullback;
            union() {
               children(0);
               zmove(movement) sphere(d = diameter);
            }
        }
    } else {
        children();
    }
}

module hinge_shape_top() {
    // covers top half of the circle, to connect the circle to the square above it
    // also moves half the distance through the section above it, allowing us to get rid of an unwanted rounded corner there
    ymove(hinge_depth/2) square([hinge_depth, hinge_depth], true);
    circle(d = hinge_depth);
}

module hinge_shape_bottom() {
    // top corner, where circle needs to be joined to the corner
    square([hinge_depth/2, hinge_depth/2]);

    // the circle that defines the center of rotation, and size of the hinge
    circle(d = hinge_depth);

    // now create a smooth transition from the outermost apex of the circle
    // down to the body of the part
    intersection() {
        // this square covers the bottom half of the circle, where we want to add a bottom support to the circle
        ymove(-hinge_depth/2) square([hinge_depth, hinge_depth], center=true);

        // now a double-sized circle that is translated over, so that the outermost apex of both circles are aligned
        move(x = hinge_depth/2) circle(r = hinge_depth);
    }
}

module hinge_bottom() {
    add_filament_hinge() {
        union() {
            zmove(sideLength/2)
            mirror_copy(offset = (sideLength/2) - hinge_wing)
            add_ball_hinge(indent = false)
            linear_extrude(hinge_wing) hinge_shape_bottom();
        }
    }
}

module hinge_top() {
    add_filament_hinge() {
        add_ball_hinge(indent = true)
        zmove(sideLength/2)
        mirror_copy(offset = -sideLength/2)
        zmove(hinge_wing + hinge_clearance)
        linear_extrude(hinge_inside_length)
        hinge_shape_top();
    }

    // add base that will be added to the flat corner
    move(x=-hinge_depth/2, y=hinge_depth/2)
    cuboid([totalWall + edgeCornerRound,totalWall,sideLength], fillet=edgeCornerRound, edges=EDGES_Z_LF, center= false);
}


module flat_corner_hinge() {
    flat_corner();
    zflip() xrot(270) move(x=-hinge_depth/2, y=-hinge_depth/2) hinge_top();
}


module top_corner_hinge() {
    top_corner();
    xrot(270) move(x=-hinge_depth/2, y=-hinge_depth/2) hinge_bottom();

//    projection()

}


xdistribute(sideLength * 2) {
    flat_corner_hinge();
    top_corner_hinge();
//    hinge_top();
//    hinge_bottom();
}

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


