# BoxKit

A library of 3d printable parts for making low-cost boxes, trays, and bins.


3d printing can be a great way to make small bins and boxes, but it's not always
possible or economical to use for larger items.

BoxKit enables the easy creation of these types of bins using thin sheet goods
such as acrylic, plywood, or MDF panels, with small, cheap, 3d printed parts for
the corners. The corners can be secured in place with CA glue.

This is a quick, cheap, and efficient way of creating all sorts of small parts
bins.


## Part Types

A basic box consists of
- 4 bottom corners
- 4 top corners

## Dividers

Dividers can be added by printing the three-way and four-way corner parts.


## Lids

Boxes can also include lids with hinges.

Hinges can be built into the corner pieces, or "flat" pieces can be printed to
retrofit a hinge to an existing box.

The hinge type can be configured as:

- a snap-fit half-ball indentation: "ball" in the Configurator
- a pinned hinge, using a piece of filament as the pin: "filament" in the
  Configurator


## Edge Cap

In this simple design, there is a gap between the top of the box sides and the
bottom of the lid. This is suitable for many purposes. However, if a
more-refined and fully enclosed box is desired, you can use an `edge_cap` piece
to enclose the box, or extend the `side_length` to enclose your box.

Ideas for improvement:
- allow printing of taller edge cap that goes on the box, and fully closes the
  lid gap without a part added to the lid.



### Flexible and Modular

Quickly print a set of corners that will allow you to assemble a box.

Choose whether you want your tray to have a lid with hinges.


I use a [Thick 2P-10 CA glue (Amazon affiliate link)](https://amzn.to/3s0rSW3).

Watch out, as some plastics can be discolored by CA glue activators.


### Customizable

Parameters such as the thickness of the material, side length, and oth

Modify the parameters using the [OpenSCAD](https://www.openscad.org) program.

No coding is required for changing parameters due to the Customizer, which
allows configuration through a friendly interface.


### Open-Source

Modify and contribute improvements, new ideas, and new features.

Feature ideas:
- embeddable magnets
- good implementation of stackable boxes of the same size.

  I haven't found a great way to implement this in an elegant, printable way.
  one idea would be to have a separately-printed disc or triangle that glues
  into a cavity that is printed into the bottom of the bottom-corner part.


- edge cap — small part that covers top exposed edges. having one on the top of
  a box and one on the lid would close off the gaps in a lidded box.
  Nice idea, or wasteful?



## A note about sourcing materials

For me, the sheet goods are acquired freely, very cheaply, or are smaller scrap
offcuts that I have lying around the shop.

I can frequently find acrylic sheet scraps for free from a local plastics
supplier that throws out smaller offcuts in a bin next to their dumpster.

I can also find such materials very cheaply at a local used building materials
yard, such as a [Habitat ReStore](https://www.habitat.org/restores), or similar.

I encourage you to use reclaimed materials where possible!


https://www.amazon.com/gp/product/B0006IUWCM?tag=zef08-20
