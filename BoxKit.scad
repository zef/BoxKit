// https://github.com/zef/BoxKit


// https://github.com/Irev-Dev/Round-Anything
include <Round-Anything/polyround.scad>

// https://github.com/revarbat/BOSL/wiki
include <BOSL/constants.scad>
use <BOSL/transforms.scad>
use <BOSL/shapes.scad>


/* [Part Selections:] */

// bottom

// What do you want to print?
print_parts = "box"; //[box, hinged box, top corner pair, top corner set, bottom corners, 3-way divider, 4-way divider, hinges only — corners, hinges only — flat, edge cap, lid latch]


/* [Basic Dimensions] */
// The "stock" refers to the panel material that will make up the sides of the box
stock_thickness = 3;

// How much space is added to the stock thickness to create slots where your stock is inserted
clearance = 0.1;

// How far the arms of the bracket extend from the corner of the stock
side_length = 20;

// How tall the corner parts are
height = 12;

// How much rounding to apply to the corners
corner_radius = 0.8;

/* [Wall Thickness and 3d Printer Configuration] */

// The number of perimeters your printer will use to create the sidewalls. This determines the thickness of the plastic surrounding the stock.
perimeters = 3;

// The width set in your slicer for 3d printing
extrusion_width = 0.45;


/* [Bottom Corners] */

// Instead of leaving a completely flat bottom, this creates slots for the side walls to sit inside, and a ledge that elevates the base panel by this amount
ledge_height = 0;



// The wall thickness determines:
// - the thickness of vertical walls that surround the stock
// - the thickness of the
wall_thickness = perimeters * extrusion_width;
slot_thickness = stock_thickness + clearance;
total_wall = (wall_thickness * 2) + slot_thickness;

// interlock = true;

/* [Hinges] */

// The type of hinging mechanism
hinge_type = "filament"; // [none, ball, filament]

// How far out the hinge protrudes from the edge of the parts
hinge_depth = 6;

// The width of the outside support of the hinge part. One is placed on each side of the hinge.
hinge_wing = 3.5;


// The amount of space allowed for clearance on each side of the hinge connection.
hinge_clearance = 0.3;

// Space added to the hinge extending from the bottom of the lid, provides space for the lid to close fully
hinge_lid_clearance = 0.4;


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

// The diameter used for the filament hinge hole. Default is 1.75 filament, + .2 clearance.
hinge_filament_hole = 1.95;


/* [Magnets!] */

// Do you want to embed magnets in the back of your corner pieces? Note that with hinged boxes, the front of the box must be the magnetic side.
magnets_on = true;

// What diameter are the magnets?
magnet_diameter = 8;

// How much clearance should the magnet hole have?
magnet_clearance = 0.15;

// How thick are the magnets? If they are deeper than the thickness of the walls, the hole will go all the way through the wall.
magnet_thickness = 10;


/* [Edge Caps] */

// How long do you want the edge cap to be? This should be the "empty" space left between the corners on your box.
edge_cap_length = 40;

// Make the edge cap taller, so it will fill the gap left by the lid above the box. You can print a separate edge cap for the lid, or set this to true to print only one edge cap that fills both gaps.
edge_cap_tall = false;

/* [Latches] */

// How wide do you want the latching mechanism to be?
latch_length = 12;

// how wide you want the edge cap attached to the latch to be?
latch_edge_cap_length = 40;

// How much extra space should be given to the latch for clearance?
latch_clearance = 0.1;

// Do you want to print an extra edge cap for the bottom of the box? One is needed for the latch to catch on.
latch_include_edge_cap = true;



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
            [0,0, corner_radius],
            [0, side_length, corner_radius],
            [total_wall, side_length, corner_radius],
            [side_length, total_wall, corner_radius],
            [side_length, 0, corner_radius]
        ])
    );
}

module corner_shape() {
    polygon(
        polyRound([
            [0,0, corner_radius],
            [0, side_length, corner_radius],
            [total_wall, side_length, corner_radius],
            [total_wall, total_wall, corner_radius],
            [side_length, total_wall, corner_radius],
            [side_length, 0, corner_radius]
        ])
    );
}

module magnet() {
    if (magnets_on) {
        // get rid of OpenSCAD artifact
        pull = .2;
        magnet_diameter = magnet_diameter + magnet_clearance;

        magnet_thickness = min(magnet_thickness, wall_thickness) + pull;
        move(x=magnet_thickness/2 - pull/2, y=side_length/2, z=height/2)
        xcyl(l=magnet_thickness, d=magnet_diameter);
    }
}

module bottom_corner(interlock=false, magnets=false) {

    difference() {
        linear_extrude(height) {
            bottom_corner_triangle_shape();
        }

        // cutout slots for panels
        slot();
        zrot(270) left(total_wall) slot();

        // flatten out inside ledge, providing suppport for the bottom part
        translate([slot_thickness, slot_thickness, wall_thickness + ledge_height]) cube([side_length, side_length, height]);

        if (magnets) {
            magnet();
        }

        if (interlock) {
            interlock();
        }
    }
}


module top_corner(interlock=false, magnets=false) {
    union() {
        difference() {
            linear_extrude(height) {
                corner_shape();
            }

            slot();
            zrot(270) left(total_wall) slot();

            if (magnets) {
                magnet();
            }
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



/////////////////////////////
// Hinges
/////////////////////////////

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
    // top inside corner, where the circle needs to be joined to the box corner
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
                distance = min(wall_thickness, corner_radius);

                move(z=side_length, x=hinge_depth/2)
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
    cuboid([hinge_depth + corner_radius,cube_thickness,side_length], fillet=corner_radius, edges=round_edges, center=false);
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

// tall is passed as a variable here because the function is used internally, as well as to create
// the edge cap part that looks at the edge_cap_tall variable, and passes it into here
module edge_cap(length=side_length, height=height, tall=false) {
    difference() {
        cap_height = tall ? height + wall_thickness : height;
        cuboid([total_wall,length,cap_height], fillet=corner_radius, edges=EDGES_Z_ALL, center=false);

        // the - .5 and the + 1 are to get rid of the visual artifact from the OpenSCAD difference implementation when the items share an outside plane
        z_offset = tall ? wall_thickness * 2 : wall_thickness;
        translate([wall_thickness, -.5, z_offset])
        cube([slot_thickness, length + 1, height]);
    }
}

module flat_hinge_lid() {
    // rotate into printable orientation
    zmove(hinge_depth) yrot(270)

    union() {
        zmove(total_wall) rotate([0, 90]) edge_cap(length=side_length, height=total_wall);
        zflip() xrot(270) move(x=-hinge_depth/2, y=-hinge_depth/2) hinge_knuckle_inside(flat_hinge=true);
    }
}


module flat_hinge_knuckle_outside() {
    union() {
        edge_cap(length=side_length, height=height);
        xrot(270) move(x=-hinge_depth/2, y=-hinge_depth/2) hinge_knuckle_outside();
    }
}


// the lid latch part attaches to the lid of the box
// and is meant to snap onto an edge_cap piece
module lid_latch() {
    
    if (latch_include_edge_cap) {
        xmove(-total_wall - bed_spacing)
        edge_cap(length=latch_edge_cap_length, height=total_wall);
    }
    
    union() {
        edge_cap(length=latch_edge_cap_length, height=total_wall);

        move(x=total_wall-wall_thickness, y=(latch_edge_cap_length + latch_length)/2)
        xrot(90)
        linear_extrude(latch_length) {
            lid_latch_shape();
        }
    }
}

module lid_latch_shape() {
    
    // in the way we have it oriented, you can think of the polygon coordinates as [x, z, rounding]
    polygon(
        polyRound([
            // start at bottom of edge cap, right where the slot ends
            [0,0,0],
            // move to the bottom end of the latch
            [total_wall * 2 + wall_thickness, 0, 0.2],
            // come up and over a bit, towards the ledge, providing a nice rounding point
            [total_wall * 2, wall_thickness*.9, wall_thickness*2],
            // this creates the latching point, where the corner slips over the edge cap
            [total_wall + wall_thickness + latch_clearance, wall_thickness * 2, .2],
            // the bottom of the latching point. Coming back a tiny bit here to create a negative slope.
            [total_wall + wall_thickness + latch_clearance + .2, wall_thickness, 0],
    
            // end at corner of slot, right above the start point
            [0, wall_thickness, 0],
        ])
    );
}

/////////////////////////////
// Printable Sets
/////////////////////////////

bed_spacing = 2;

module corner_hinge_set() {
    xmove(-side_length/4)
    yflip_copy() ymove(-bed_spacing - side_length)
    xdistribute(hinge_depth * 2 + bed_spacing) {
        // lid front corners
        move(y=side_length, x=bed_spacing * 2) yflip() yrot(270) lid_corner();
        ymove(side_length) yflip() lid_corner_hinge();
        top_corner_hinge();
    }
}

module flat_hinge_set() {
    xdistribute(hinge_depth * 2 + bed_spacing) {
        ymove(side_length) yflip() flat_hinge_lid();
        flat_hinge_knuckle_outside();
    }
}


module bottom_corners(spacing=bed_spacing) {
    distance = (side_length) + spacing;
    xdistribute(-side_length * 2 - spacing) {
        xflip() yflip_copy(offset=-distance) bottom_corner();
        yflip_copy(offset=-distance) bottom_corner(magnets=true);
    }
//    rot_copies(n=2, delta = [distance,distance,0]) zrot(180) bottom_corner();
}

// `magnets` determinse whether magnets sholuld be shown, but only if the master magnets_on is also true.
module top_corner_pair(magnets=false) {
    // this is implemented to mirror the parts so that magnetic parts are correctly printed
    total_length = side_length + (total_wall + bed_spacing)*2;
    move(x=-total_length/2, y= -side_length/2) {
        move(x=total_length, y=side_length) yflip() zrot(90) top_corner(magnets=magnets);
        top_corner(magnets=magnets);
    }
}
module top_corner_set() {
    top_corner_pair();
    zrot(90) top_corner_pair(magnets=true);
}


quadrant_spacing = side_length * 2 + bed_spacing * 6;

if (print_parts == "box") {
    ydistribute(quadrant_spacing) {
        bottom_corners();
        top_corner_set();
    }
}

if (print_parts == "hinged box") {
    ydistribute(quadrant_spacing) {
        bottom_corners();
        corner_hinge_set();
        top_corner_pair(magnets=true);
    }
}

if (print_parts == "top corner pair") {
    top_corner_pair(magnets=true);
}

if (print_parts == "top corner set") {
    top_corner_set();
}

if (print_parts == "bottom corners") {
    bottom_corners();
}

if (print_parts == "3-way divider") {
    3_way();
}

if (print_parts == "4-way divider") {
    4_way();
}

if (print_parts == "hinges only — corners") {
    corner_hinge_set();
}

if (print_parts == "hinges only — flat") {
    ymove(-side_length/2) flat_hinge_set();
}

if (print_parts == "edge cap") {
    ymove(-edge_cap_length/2) edge_cap(height=total_wall, length=edge_cap_length, tall=edge_cap_tall);
}

if (print_parts == "lid latch") {
    lid_latch();
}


//xdistribute(quadrant_spacing) {
//    ydistribute(quadrant_spacing) {
//    }
//    ydistribute(quadrant_spacing) {
//    }
//}


