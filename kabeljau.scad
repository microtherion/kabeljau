/*
 * Kabeljau - Wall mounted cable holder
 *
 * Copyright (C) 2023 Matthias Neeracher <microtherion@gmail.com>
 */

$fn = $preview ? 32 : 64;

// Number of slots
slots         = 4;              // [1:1:20]

/* [Other Parameters - Tune if Needed] */
// Thickness of Walls
thickness     = 3.0;            // [2.0:0.25:5.0]

// Spacing Between Slots
spacing       = 15.0;           // [10.0:1.0:20.0]

// Width of Slots
width         = 4.8;            // [3.0:0.1:8.0]

// Diameter of Slot Aperture
aperture      = 6.5;            // [0.0:0.1:12.0]

// Length of Slots
length        = 10.0;           // [5.0:1.0:30.0]

// Height of Slip Barrier
barrier       = 10.0;           // [0.0:1.0:20.0]

// Mounting height above barrier
mount_height   = 20.0;          // [10.0:1.0:50.0]

// Diameter of Mounting Pad
mount_pad     = 10.0;           // [5.0:.25:20.0]

// Bottom Width of Mounting Stalk
stalk_bottom  =  8.0;           // [5.0:.5:20.0]

// Top Width of Mounting Stalk
stalk_top     =  2.0;           // [1.0:.5:20.0]

// Diameter of Mounting Hole
mount_hole    = 2.1;            // [1.0:0.1:10.0]

module round_plate(x, y, z) {
    r = thickness*0.5;
    hull() {
        // left back bottom
        translate([r, r, r]) sphere(r);

        // right back bottom
        translate([x-r, r, r]) sphere(r);

        // left back top
        translate([r, y-r, r]) sphere(r);

        // right back top
        translate([x-r, y-r, r]) sphere(r);

        // left front bottom
        translate([r, r, z-r]) sphere(r);

        // right front bottom
        translate([x-r, r, z-r]) sphere(r);

        // left front top
        translate([r, y-r, z-r]) sphere(r);

        // right front top
        translate([x-r, y-r, z-r]) sphere(r);
    }
}

module round_l(x) {
    round_plate(x, thickness, length+2*thickness);
    translate([0, 0, length+thickness]) round_plate(x, barrier+thickness, thickness);
}

module stalk(offset) {
    linear_extrude(height=thickness) {
        polygon([[-0.5*stalk_bottom, 0], [0.5*stalk_bottom, 0], [0.5*stalk_top+offset, mount_height], [-0.5*stalk_top+offset, mount_height]]);
    }
}

module eye(d1, d2, offset) {
    difference() {
        union() {
            cylinder(d=d1, h=thickness);
            translate([-offset, -mount_height, 0]) stalk(offset);
        }
        cylinder(d=d2, h=thickness);
    }
}

module kabeljau() {
    // Back plate
    round_plate(slots*spacing, thickness+barrier, thickness);

    // Mounting pads
    translate([0.5*mount_pad, 0.5*thickness+barrier+mount_height]) eye(mount_pad, mount_hole, 0.5*mount_pad-spacing);
    translate([slots*spacing-0.5*mount_pad, 0.5*thickness+barrier+mount_height]) eye(mount_pad, mount_hole, spacing-0.5*mount_pad);

    difference() {
        union() {
            round_l(0.5*(spacing-width));
            translate([(slots-1)*spacing+0.5*(spacing+width), 0, 0]) round_l(0.5*(spacing-width));

            for (slot=[1:1:slots-1]) {
                translate([(slot-1)*spacing+0.5*(spacing+width), 0, 0]) {
                    round_l(spacing-width);
                }
            }
        }
        for (slot=[1:1:slots]) {
            translate([(slot-0.5)*spacing, 0, thickness+0.5*length]) rotate(-90, [1, 0, 0]) cylinder(h=thickness, d=aperture);
        }
    }
}

rotate([90, 0, 0]) kabeljau();
