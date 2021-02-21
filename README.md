# BoxKit

A library of 3d printable parts for making low-cost boxes, trays, and bins.


3d printing can be a great way to make small bins and boxes, but it's not
always possible or economical to use for larger items.

BoxKit enables the easy creation of these types of bins using thin sheet goods
such as acrylic, plywood, or MDF panels, with small, cheap, 3d printed parts
for the corners. The corners can be secured in place with CA glue.

This is a quick, cheap, and efficient way of creating all sorts of small parts
bins.

I would like to make a video explaining and demonstrating some of the features
and process. Coming soon, I hope!

### Flexible, Modular, and Customizable

Quickly print a set of corners that will allow you to assemble a box of any
size.

Choose a simple tray or a box with a hinged lid. Optional features include
lid latches, magnets, independent hinges, and other configurable options, [as
detailed below](#boxkit-parts).

Parameters such as the thickness of the material, side length, height, hinge
configuration, and many other configuration options are available.

Modify the parameters using the [OpenSCAD](https://www.openscad.org) program.

No coding is required for changing parameters due to the Customizer, which
allows configuration through a friendly interface.


## Process

Steps to create a box include:

- sourcing materials
- configuring and printing parts
- cutting panels to size
- assembling

### Sourcing Materials

For me, a large part of the motivation for this project is that I had a lot of
the freely-acquired clear acrylic that was bound for the trash before I got it.

I can frequently find acrylic sheet scraps for free from a local plastics
supplier that throws out smaller offcuts in a bin next to their dumpster. You
can probably find something like this too!

I also think it could be a good use of smaller scrap offcuts of thin sheet goods
like MDF or plywood that you may have lying around the shop, or are able to
reclaim for free from somewhere.

I can often find such materials very cheaply at a local used building materials
yard, such as a [Habitat ReStore](https://www.habitat.org/restores), or similar.

I encourage you to use reclaimed materials where possible! Reducing waste and
making something useful out of "trash" is important, and has value that goes
beyond a simple monetary calculation, though it can also be very economical.


### 3d Part Configuration

All dimensions are in mm.

The wall thickness of the plastic is determined by the number of perimeters set
in the configuration, multiplied by the extrusion width. I have been pleasantly
surprised by the strength and suitability of using only two perimeters, but I
have experimented with both two (2p) and three (3p) perimeter configurations. 3p
is good for larger boxes and trays, but 2p is quite good too and uses only about
60% of the plastic that 3p does.

In my testing on a 3mm panel, a clearance of -.1 works well with 2p panels,
while a clearance of .1 works well with 3p panels.

### Cutting Panels

When making a box or tray, I like to have the bottom of the box completely inset
inside the walls of the box. I will expand on this process later, but for now,
it is an exercise for the reader. Stay safe — don't make any cuts that you're not
comfortable with. I'm sure you'll figure it out. ;)

### Assembly

I like to get everything lined up and test fit before starting the gluing
process, then go around and glue a corner at a time, top corners first. Then
inserting the bottom panel and gluing on the bottom corners after the top is set
up. Some gentle clamping may help too, depending on the size of everything.

Since the bottom corners are just flat in the base configuration, it can be a
little tricky to keep them on properly. See the "ledge height" option in the
"Bottom Corners" customizer section for another option that holds the sidewalls
better.

For gluing, I have used both [medium](https://amzn.to/2NJgU8P) or
[thick](https://amzn.to/3s0rSW3) 2P-10 CA glue and they both work well. Medium
can be quite runny and you have to be careful to not let it drip, but it's
slightly easier for me to work with than the thick. I try to apply a small
amount to the cavity of the part and then press in the panel. Thick tends to
have more squeeze-out and it's harder for me to control the application amount.

Watch out, as some plastics can be discolored by CA glue activators.


### How to use the OpenSCAD file

The OpenSCAD Customizer can be used to drive most changes that I expect you will
need. Let me know if there is anything missing!

Basic steps to get started are as follows:

- Install the [OpenSCAD](https://www.openscad.org) program.
- Install the libraries as detailed in the following links: [Round Anything](https://github.com/Irev-Dev/Round-Anything/discussions/21)
and [BOSL](https://github.com/revarbat/BOSL/wiki).
- Download the code for this project from GitHub — see the link on the top right
  of the project page.
- Open BoxKit.scad, and start exploring the Customizer options. Don't be afraid
  to edit the values in the code, too!
- Once you have something you want to try, you must first Render the part, and
  then Export as STL. Both of these are in the application menus, and available
  as icons in the interface.

Note: the OpenSCAD Customizer does not allow subdivisions of numbers that
started out as integers, for instance, if a value started out as "3",
the Customizer does not allow you to input 3.1. You can deal with this by
editing the code, though I've tried to work around the issue for some cases.

---

# BoxKit Parts

## Basic Box Types

### Tray

Four bottom corners and four top corners that are assembled to create a simple
tray or lidless box.


### Box

Just like a tray, but with a hinged lid. Two of the top corners are replaced
with hinge parts.  Additionally, two hinges are added for back of the lid, and
two covers for the front of the lid.


## Options and Accessories

### Hinges

The hinge type can be configured as:


#### Filament:

A pinned hinge, using a piece of filament as the pin. This is a very simple way
to create a nicely operating hinge that is less finicky than the "ball" hinge.
This is my preference.

#### Ball:

A snap-fit half-ball indentation that provides a convenient way to attach two
hinge pieces. I have had some success with the ball hinge, but I find it to be
more sensitive to small configuration changes. It can be hard to assemble if
the tolerances are too tight, and can damage the hinge slightly during assembly.
However, if tolerances are too loose, the hinge does not provide much friction
and becomes floppy. Due to this, I personally prefer the filament hinge. Also,
the ball hinge requires more rendering time in OpenSCAD.

### Edge Cap

In this simple design, there is a gap between the top of the box sides and the
bottom of the lid. This is suitable for many purposes. However, if a
more-refined and fully-enclosed box is desired, you can use an `edge_cap` piece
to fully cover the top edges of the box.

There is also an `edge cap tall` option that is explained in the Customizer.

### Lid Latch

A Lid Latch can be added to create a securely closing lid. Due to the printing
orientation, the layers of the lid can catch when closing, so this part should
be printed with finer layer height settings than other parts, like .1mm.

Some light filing/sanding also helps to get the latch to close smoothly. I am
open to other design ideas that could improve this situation, I have a couple
ideas but haven't had time to implement and test them yet.

The latch is an add-on to the edge cap part, so it can be printed on top of an
edge cap of variable width, allowing you to create a more enclosed box.

### Dividers

Dividers can be added by printing the three-way and four-way corner parts.

### Flat Hinges

Boxes are easily created by building a hinge into the top corner piece, but a
"flat" hinge piece is also available to retrofit lids to existing trays.

### Magnets!

Magnets can be embedded in the rear parts of a box. In a brief test using four
8mm diameter, 1mm thick magnets [such as these](https://amzn.to/3sdyssC), a
small box was able to hold some small items and remain stuck to the side of my
fridge, but it was not particularly strong with such small magnets. Perhaps
doubling the magnets or using a larger magnet would work well. Note that you may
need to increase the wall-thickness by increasing the number of perimeters if
you want your magnet to be fully-embedded.

---

## Open-Source

Modify and contribute improvements, new ideas, and new features!

#### Feature ideas:

- **Stackability**

  I would be interested in a good implementation of stackable boxes of the same
  size. I haven't found a great way to implement this in an elegant, printable
  way. One idea would be to have a separately-printed disc or triangle that
  glues into a cavity that is printed into the bottom of the bottom-corner part.
  But I don't find extra assembly steps to be very elegant or worthwhile. I
  experimented with an "interlock" feature that is in the code behind a feature
  flag, but I have not tried to print it and am skeptical of it anyway.


- **Shelf Slot**

  Okay, so it's not _exactly_ box related, but this would be pretty easy and
  might be a nice way to mount panels as shelves. I have this partially
  implemented (`back_plate()`), just haven't been able to finish and test it yet.


- **Automate Exports**

  I'd love to be able to change some parameters and run a command-line script
  that would export all the part types, named by convention. [This should be
  doable.][1]

[1]: https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Using_OpenSCAD_in_a_command_line_environment


### Known Issues

- some part layouts do not behave properly when exaggerated dimensions are used.
  I think in normal usage this shuold be ok, but let me know otherwise.
