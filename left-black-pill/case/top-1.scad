WALL_THICKNESS = 4; // .1
USB_WALL_THICKNESS = 2; // .1
USB_WALL_WIDTH = 14; // [10:1:17]
BASE_THICKNESS = 4; // .1
CEILING_THICKNESS = 2; // [.1:.1:2]
ADDITIONAL_ELEVATION = 0; // .1
SCREW_HEAD_DIAMETER = 5.5; // .1
SCREW_HEAD_THICKNESS = 3; // .1
SCREW_DIAMETER = 3; // .1
SCREW_PADDING = 2; // .1
SCREW_LENGTH = 10; // .1

/* [Hidden] */

sqrt_2_2 = sqrt(2) / 2;

board_width = 115;
board_height = 58;

padded_screw_diameter = SCREW_HEAD_DIAMETER + SCREW_PADDING * 2;

screw_hole_length = SCREW_LENGTH - (BASE_THICKNESS - SCREW_HEAD_THICKNESS);

wall_height = 10 + ADDITIONAL_ELEVATION;

$fn = 200;

difference() {
    union() {
        difference() {
            union() {
                // base
                translate([0, (17 + WALL_THICKNESS) / 2, CEILING_THICKNESS / 2])
                cube([board_height + WALL_THICKNESS * 2, 17 + WALL_THICKNESS, CEILING_THICKNESS], center = true);
                
                // long wall
                translate([-(board_height / 2 + WALL_THICKNESS), 17, 0])
                cube([board_height + WALL_THICKNESS * 2, WALL_THICKNESS, wall_height]);
                
                // side walls
                for (x = [-1, 1])
                    translate([x * (board_height + WALL_THICKNESS) / 2, 17 / 2, wall_height / 2])
                    cube([WALL_THICKNESS, 17 + (x == -1 ? 3 : 0), wall_height], center = true);
            }
            
            // cut off corners
            if (WALL_THICKNESS < padded_screw_diameter - padded_screw_diameter / 2 * (1 - sqrt_2_2))
                for (x = [-1, 1])
                    translate([x * (board_height / 2 + padded_screw_diameter - padded_screw_diameter / 4 * sqrt_2_2), 17 + padded_screw_diameter - padded_screw_diameter / 4 * sqrt_2_2, CEILING_THICKNESS / 2])
                    cube([padded_screw_diameter, padded_screw_diameter, CEILING_THICKNESS], center = true);
        }
        
        // screw padding
        if (WALL_THICKNESS < padded_screw_diameter - padded_screw_diameter / 2 * (1 - sqrt_2_2))
            for (x = [-1, 1])
                translate([x * (board_height / 2 + padded_screw_diameter / 2 * sqrt_2_2), 17 + padded_screw_diameter / 2 * sqrt_2_2, 0])
                cylinder(wall_height, d = padded_screw_diameter);
    }
    
    // screw hole
    for (x = [-1, 1])
        translate([x * (board_height / 2 + padded_screw_diameter / 2 * sqrt_2_2), 17 + padded_screw_diameter / 2 * sqrt_2_2, 0]){
            translate([0, 0, wall_height - screw_hole_length])
            cylinder(screw_hole_length, d = SCREW_DIAMETER);
        }
    
    // usb port indent
    translate([-(board_height / 2 + WALL_THICKNESS), 17 - (10 - USB_WALL_WIDTH / 2) - USB_WALL_WIDTH, 0])
    cube([WALL_THICKNESS - USB_WALL_THICKNESS, USB_WALL_WIDTH, wall_height]);
    
    // usb hole
    #translate([-(board_height + USB_WALL_THICKNESS) / 2, 17 - (10 - USB_WALL_WIDTH / 2) - USB_WALL_WIDTH / 2 - 0.5, 4.5])
    rotate([90, 0, 90])
    union() {
        cube([6, 3, USB_WALL_THICKNESS], center = true);
        
        for (x = [-1, 1])
                translate([x * 3, 0, 0])
                cylinder(USB_WALL_THICKNESS, r = 1.5, center = true);
        
    }
}