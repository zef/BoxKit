# BoxKit

A library of 3d printable parts for making low-cost boxes, trays, and bins.


3d printing can be a great way to make small bins and boxes, but it's not
always possible or economical to use for larger items.

BoxKit enables the easy creation of these types of bins using thin sheet goods
such as acrylic, plywood, or MDF panels, with small, cheap, 3d printed parts
for the corners. The corners can be secured in place with CA glue.

This is a quick, cheap, and efficient way of creating all sorts of small parts
bins.


## Part Types

### Tray
- 4 bottom corners
- 4 top corners

### Box

Just like a tray, but with a hinged lid. Two of the top corners are replaced
with hinge parts.  Additionally, two hinges are added for back of the lid, and
two covers for the front of the lid.



## Options and Accessories

### Hinges

The hinge type can be configured as:


#### Filament

A pinned hinge, using a piece of filament as the pin. This is a very simple way
to create a nicely operating hinge that is less finicky than the "ball" hinge.

#### Ball

A snap-fit half-ball indentation that provides a convenient way to attach two
hinge pieces. I have had some success with the ball hinge, but I find it to be
more sensitive to small configuration changes. It can be hard to assemble if
the tolerances are too tight, and can damage the hinge slightly during assembly.
However, if tolerances are too loose, the hinge does not provide much friction
and becomes floppy. Due to this, I personally prefer the filament hinge. Also,
the ball hinge requires more rendering time in OpenSCAD.

### Edge Cap

The edge cap is an optional part that can be printed to create a more
fully-enclosed box, removing the gap left between the box and the lid on the
long edges.


### Lid Latch

A Lid Latch can be added to create a securely closing lid. Due to the printing
orientation, the layers of the lid can catch when closing, so this part should
be printed with finer layer height settings than other parts, like .1mm.

Some light filing/sanding also helps to get the latch to close smoothly. I am
open to other design ideas that could improve this situation, I have a couple
ideas but haven't had time to implement and test them yet.

The latch is an add-on to the edge cap part, so it can be printed on top of an
edge cap of variable width, allowing you to create a more enclosed box.


## Dividers

Dividers can be added by printing the three-way and four-way corner parts.

## Flat Hinges

Boxes are easily created by building a hinge into the top corner piece, but a
"flat" hinge piece is also available to retrofit lids to existing trays.


## Edge Cap

In this simple design, there is a gap between the top of the box sides and the
bottom of the lid. This is suitable for many purposes. However, if a
more-refined and fully enclosed box is desired, you can use an `edge_cap` piece
to enclose the box, or extend the `side_length` to enclose your box.

Ideas for improvement:
- allow printing of taller edge cap that goes on the box, and fully closes the
  lid gap without a part added to the lid.

## Magnet Holes

Magnets can be embedded in the rear parts of a box. In a brief test using four
8mm diameter, 1mm thick magnets [such as these](https://amzn.to/3sdyssC), a
small box was able to hold some small items and remain stuck to the side of my
fridge, but it was not particularly strong. Perhaps doubling the magnets or
using a larger magnet would work well.



### Flexible and Modular

Quickly print a set of corners that will allow you to assemble a box.

Choose whether you want your tray to have a lid with hinges.


### Assembly

I have used both [medium](https://amzn.to/2NJgU8P) or
[thick](https://amzn.to/3s0rSW3) 2P-10 CA glue and they both work well. Medium
can be quite drippy and you have to be careful to not let it run, but it's
slightly easier for me to work with than the thick. I try to apply a small
amount to the cavity of the part and then press in the panel. Thick tends to
have more squeeze out and it's harder for me to control the application amount.

Watch out, as some plastics can be discolored by CA glue activators.


### Customizable

Parameters such as the thickness of the material, side length, height, hinge
configuration, and many other configuration options are available.

Modify the parameters using the [OpenSCAD](https://www.openscad.org) program.

No coding is required for changing parameters due to the Customizer, which
allows configuration through a friendly interface.

### How to use the OpenSCAD file

Install the [OpenSCAD](https://www.openscad.org) program,


### Open-Source

Modify and contribute improvements, new ideas, and new features!

#### Feature ideas:

- Stackability
  I would be interested in a good implementation of stackable boxes of the same
  size. I haven't found a great way to implement this in an elegant, printable
  way. One idea would be to have a separately-printed disc or triangle that
  glues into a cavity that is printed into the bottom of the bottom-corner part.
  But I don't find extra assembly steps to be very elegant or worthwhile. I
  experimented with an "interlock" feature that is in the code behind a feature
  flag, but I have not tried to print it and am skeptical of it anyway.




## A note about sourcing materials

For me, a large part of the motivation for this project is that I had a lot of
the freely-acquired clear acrylic that was bound for the trash before I got it.

I can frequently find acrylic sheet scraps for free from a local plastics
supplier that throws out smaller offcuts in a bin next to their dumpster.

I also think it could be a good use of smaller scrap offcuts of thin sheet goods
like MDF or plywood that you may have lying around the shop, or are able to
reclaim for free from somewhere.

I can often find such materials very cheaply at a local used building materials
yard, such as a [Habitat ReStore](https://www.habitat.org/restores), or similar.

I encourage you to use reclaimed materials where possible! Reducing waste and
making something useful out of "trash" is important, and has value that goes
beyond a simple monetary calculation, though it can also be very economical.


https://www.amazon.com/gp/product/B0006IUWCM?tag=zef08-20

### Known Issues

- some part layouts do not behave properly when exaggerated dimensions are used.
  I think in normal usage this shuold be ok, but let me know otherwise.
