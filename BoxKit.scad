
// https://github.com/Irev-Dev/Round-Anything
include <Round-Anything/polyround.scad>
include <Round-Anything/MinkowskiRound.scad>

// https://github.com/revarbat/BOSL/wiki
include <BOSL/constants.scad>
use <BOSL/transforms.scad>
use <BOSL/shapes.scad>

/* [Basic Dimensions:] */
// The "stock" refers to the panel material that will make up the sides of the box
stock_thickness = 3;

// How much space is added to the stock thickness to create slots where your stock is inserted
clearance = 0.1;

// How far the arms of the bracket extend from the corner of the stock
side_length = 20;

// How tall the corner parts are
height = 12;



/* [3d Printer Configuration:] */

// The number of perimeters your printer will use to create the sidewalls. This determines the thickness of the plastic surrounding the stock.
perimeters = 3;

// The width set in your slicer for 3d printing
extrusion_width = 0.45;




// The wall thickness determines:
// - the thickness of vertical walls that surround the stock
// - the thickness of the
wall_thickness = perimeters * extrusion_width;

// this affects the bottom corner piece only
// Instead of leaving a completely flat bottom, this creates a ledge,
// creating a more solid slot for the side walls to sit inside, and elevating the base of the entire tray by this amount
insideHeight = 0;

slot_thickness = stock_thickness + clearance;
total_wall = (wall_thickness * 2) + slot_thickness;

// how much rounding to apply to the corners
edge_corner_round = 1;

// how many faces are used when rendering curves. Use a small number like 10 for better performance when prototyping, and a large number like 60 for rendering for printing.
$fn = 60;

// interlock = true;

/* [Hinges:] */

// The type of hinging mechanism
hinge_type = "filament"; // [none, ball, filament]

// How far out the hinge protrudes from the edge of the parts
hinge_depth = 6;

// The width of the outside support of the hinge part. One is placed on each side of the hinge.
hinge_wing = 3.5;


// The amount of space allowed for clearance on each side of the hinge connection.
hinge_clearance = 0.3;

// Space added to the hinge extending from the bottom of the lid, provides space for the lid to close fully
hinge_lid_clearance = 0.2;


// Adds extra clearance for the the parts that contain the lid. I've found that this part prints a bit too tight compared to the other slots, due to the three-sided vertical support, rather than two-sided, like the others.
hinge_lid_slot_extra_clearance = .1;

hinge_inside_length = side_length - (hinge_wing + hinge_clearance) * 2;

// Multiplied by hinge_depth to determine the diameter of the ball used for ball hinges. You may need to increase the Hinge Ball Pullback as this ratio is increased
hinge_ball_ratio = 0.7;

// The size of the ball that is used for ball hinges
hinge_ball = hinge_depth * hinge_ball_ratio;

// The amount by which the indentation is increased to provide some clearance between the ball and the indentation
hinge_ball_clearance = .2;

// The percentage that the ball is protruding, or used to create the indentation. 0 represents a full half of the ball is protruding. 1 represents the ball not protruding at all
hinge_ball_pullback = .4;

hinge_filament_hole = 1.75 + .2;



echo("<b>Wall: ", wall_thickness);
echo("<b>Total Wall: ", total_wall);



// could do some parameter validation, but may be fine to leave that to the user


module slot() {
    translate([wall_thickness, wall_thickness, wall_thickness])
    cube([slot_thickness, side_length, height]);
}



// hiding this down here so it's not in the customizer
$fn = 60;


module bottom_corner_triangle_shape() {
    polygon(
        polyRound([
            [0,0, edge_corner_round],
            [0, side_length, edge_corner_round],
            [total_wall, side_length, edge_corner_round],
            [side_length, total_wall, edge_corner_round],
            [side_length, 0, edge_corner_round]
        ])
    );
}

module corner_shape() {
    polygon(
        polyRound([
            [0,0, edge_corner_round],
            [0, side_length, edge_corner_round],
            [total_wall, side_length, edge_corner_round],
            [total_wall, total_wall, edge_corner_round],
            [side_length, total_wall, edge_corner_round],
            [side_length, 0, edge_corner_round]
        ])
    );
}


module bottom_corner(interlock=false) {
    difference() {
        linear_extrude(height) {
            bottom_corner_triangle_shape();
        }

        // cutout slots for panels
        slot();
        zrot(270) left(total_wall) slot();

        // flatten out inside ledge, providing suppport for the bottom part
        translate([slot_thickness, slot_thickness, wall_thickness + insideHeight]) cube([side_length, side_length, height]);

        if (interlock) {
            interlock();
        }
    }
}


module top_corner(interlock=false) {
    union() {
        difference() {
            linear_extrude(height) {
                corner_shape();
            }

            slot();
            zrot(270) left(total_wall) slot();
        };

        if (interlock) {
            interlock();
        }
    }
}

module 3_way() {
    difference() {
        mirror_copy([0,1,0], 0, [0,(wall_thickness + slot_thickness/2),0]) top_corner();
        forward(side_length / 2) slot();
    }
}

module 4_way() {
    difference() {
        mirror_copy([1,0,0], 0, [(wall_thickness + slot_thickness/2),0,0]) 3_way();
        zrot(90) forward((wall_thickness*3) + side_length/2) slot();
    }
}

//module back_plate(side=10) {
//    plate_height = side * .6;
//
//    mirror_copy([0,0,1], 0, [0,0,total_wall/2])
//    difference() {
//        yrot(90) xflip() left(plate_height)
//        linear_extrude(side) polygon(
//            polyRound([
//                [0,0, 0],
//                [0, wall_thickness, 2],
//                [plate_height, wall_thickness, 4],
//                [plate_height, wall_thickness * 4, 0],
//                [plate_height + total_wall, wall_thickness * 4, 0],
//                [plate_height + total_wall, 0, 0],
//            ])
//        );
//
//        xrot(90, cp = [0,0,wall_thickness/2])  right(side/2) forward(plate_height/1.7)  cylinder(wall_thickness+.1, 4, 2);
//    }
//}

module lid_corner() {
    difference() {
        linear_extrude(total_wall + hinge_lid_slot_extra_clearance) {
            corner_shape();
        }

        // cut out slot for shelf sheet
        cut_depth = wall_thickness;
        translate([cut_depth, cut_depth, wall_thickness]) cube([side_length, side_length, slot_thickness + hinge_lid_slot_extra_clearance]);
    };
}


// old cylinder idea, never tried printing
module interlock() {
    radius = wall_thickness/3;
    translate([total_wall / 2, total_wall / 2, 0])
    zrot_copies([0, 90], r = total_wall/2)
    cyl(side_length - (total_wall*2), r=radius, fillet=radius, orient=ORIENT_X, center=false);
}

// protrusion from bottom corner. I like the idea but I'm not sure how to print it...
// maybe make an interlock as a separate piece that is glued on and inserted using a couple alignment pins?
//module interlock(scaleClearance = 1.15) {
//    difference() {
//        linear_extrude(wall_thickness) bottom_corner_triangle_shape();
//        translate([-.1, -.1, -.1]) scale([scaleClearance, scaleClearance, scaleClearance]) linear_extrude(wall_thickness + 1) corner_shape();
//
//    }
//}


//bottom_corner(true);

//top_corner(true);


/// distribution

bed_spacing = 2;

module bottom_corners(spacing=total_wall/2) {
    distance = (side_length) + spacing;
    rot_copies(n=4, delta = [distance,distance,0]) zrot(180) bottom_corner();
}

module top_corners_tight() {
    distance = side_length;// (side_length * 2) + (total_wall * 2) + (bed_spacing * 2);
    rot_copies(n=4, delta = [total_wall,side_length - total_wall,0]) zrot(180) xmove(-total_wall-wall_thickness) top_corner();
}

//bottom_corners(total_wall * 1.5);
//top_corners_tight();



// indent indicates that one side of the slot will be closed off
// so that only one side of filament needs to be sealed
module add_filament_hinge() {
    if (hinge_type == "filament") {
        difference() {
            children(0);
            // this movement closes off one side of the outside hinge, so the filament only needs
            // to be secured on one side, it does not affect the inside hinge.
            zmove(wall_thickness)
            cylinder(side_length, d=hinge_filament_hole);
        }
    } else {
        children();
    }
}

module add_ball_hinge(indent=true) {
    if (hinge_type == "ball") {
        if (indent) {
            diameter = hinge_ball + hinge_ball_clearance;
            copy_offset = (hinge_inside_length + (diameter/2 * hinge_ball_pullback)) / 2;
            difference() {
               children(0);
               zmove(side_length/2) zflip_copy(offset=copy_offset) sphere(d=diameter);
            }
        } else {
            diameter = hinge_ball;
            movement = (diameter/2) * hinge_ball_pullback;
            union() {
               children(0);
               zmove(movement) sphere(d=diameter);
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
    circle(d=hinge_depth);
}

module hinge_shape_bottom() {
    // top corner, where circle needs to be joined to the corner
    square([hinge_depth/2, hinge_depth/2]);

    // the circle that defines the center of rotation, and size of the hinge
    circle(d=hinge_depth);

    // now create a smooth transition from the outermost apex of the circle
    // down to the body of the part
    intersection() {
        // this square covers the bottom half of the circle, where we want to add a bottom support to the circle
        ymove(-hinge_depth/2) square([hinge_depth, hinge_depth], center=true);

        // now a double-sized circle that is translated over, so that the outermost apex of both circles are aligned
        move(x=hinge_depth/2) circle(r=hinge_depth);
    }
}

module hinge_knuckle_outside(extended=true) {
    add_filament_hinge() {
        union() {
            zmove(side_length/2)
            mirror_copy(offset=(side_length/2) - hinge_wing)
            add_ball_hinge(indent=false)
            linear_extrude(hinge_wing) hinge_shape_bottom();


            if (extended) {
                // now we take a projection of the side that goes against the body of the piece
                // we then extrude and position it, in order to remove unwanted rounded corners at the connection point
                distance = min(wall_thickness, edge_corner_round);

                // where does this .5 come from? It's not half the distance, not sure why I need it...
                move(z=side_length, x=hinge_wing - distance+.5)
                rotate([90,90,90])
                linear_extrude(distance)
                projection() yrot(90) hinge_knuckle_outside(extended=false);
            }
        }
    }
}

module hinge_knuckle_inside(flat_hinge=false) {
    ymove(-hinge_lid_clearance)
    add_filament_hinge() {
        add_ball_hinge(indent=true)
        zmove(side_length/2)
        mirror_copy(offset=-side_length/2)
        zmove(hinge_wing + hinge_clearance)
        linear_extrude(hinge_inside_length)
        hinge_shape_top();
    }

    // not entirely sure on the nicest rounding options, but I'll go with this for now.
    round_edges = flat_hinge ? [[1,1,1,1], [0,0,0,0], [0,1,1,0]] : EDGES_Z_LF;
    cube_thickness = flat_hinge ? total_wall : total_wall + hinge_lid_slot_extra_clearance;

    // add base that will be added to the flat corner
    move(x=-hinge_depth/2, y=hinge_depth/2)
    cuboid([hinge_depth + edge_corner_round,cube_thickness,side_length], fillet=edge_corner_round, edges=round_edges, center=false);
}


module lid_corner_hinge() {
    // just visual positioning
    zmove(hinge_depth) yrot(270)

    union() {
        lid_corner();
        zflip() xrot(270) move(x=-hinge_depth/2, y=-(hinge_depth)/2) hinge_knuckle_inside();
    }
}


// this is the top corner piece of the box, with a hinge attached to it
// this piece coins with a `lid_corner_hinge` piece
module top_corner_hinge() {
    union() {
        top_corner();
        xrot(270) move(x=-hinge_depth/2, y=-(hinge_depth)/2) hinge_knuckle_outside();

        // now we take a projection of the side that goes against the corner piece
        // we then extrude and position it, in order to remove unwanted rounded corners at the connection point

    }
}

module corner_hinge_set() {
//    yflip_copy() ymove(-bed_spacing - side_length)
    xdistribute(total_wall * 2 + bed_spacing) {
        ymove(side_length) yflip() lid_corner_hinge();
        top_corner_hinge();
    }
}

module flat_attachment() {
    difference() {
        cuboid([total_wall,side_length,height], fillet=edge_corner_round, edges=EDGES_Z_ALL, center=false);

        translate([wall_thickness, -.5, wall_thickness])
        cube([slot_thickness, side_length + 1, side_length + 1]);
    }
}

module flat_hinge_lid() {
    zmove(hinge_depth) yrot(270)

    union() {
        zmove(total_wall) rotate([0, 90]) flat_attachment();
        zflip() xrot(270) move(x=-hinge_depth/2, y=-hinge_depth/2) hinge_knuckle_inside(flat_hinge=true);
    }
}


module flat_hinge_knuckle_outside() {
    union() {
        flat_attachment();
        xrot(270) move(x=-hinge_depth/2, y=-hinge_depth/2) hinge_knuckle_outside();
    }
}

module flat_hinge_set() {
    xdistribute(side_length + 10 + bed_spacing) {
        ymove(side_length) yflip() flat_hinge_lid();
        flat_hinge_knuckle_outside();
    }
}


flat_hinge_set();

left(side_length + 40) corner_hinge_set();

//ydistribute(side_length * 2 + 10) {
//    bottom_corner(false);
//    top_corner(false);
////    bottom_corner(true);
////    top_corner(true);
//    3_way();
//    4_way();
//
//    lid_corner();
//}


