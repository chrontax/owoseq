WALL_THICKNESS = 4; // .1
USB_WALL_THICKNESS = 2; // .1
USB_WALL_WIDTH = 14; // [10:1:17]
BASE_THICKNESS = 4; // .1
ADDITIONAL_ELEVATION = 0; // .1
SCREW_HEAD_DIAMETER = 5.5; // .1
SCREW_HEAD_THICKNESS = 3; // .1
SCREW_DIAMETER = 3; // .1
SCREW_PADDING = 2; // .1
HEADER_PIN_COUNT = 10; // [9:1:11]

/* [Hidden] */

sqrt_2_2 = sqrt(2) / 2;

board_width = 115;
board_height = 58;

padded_screw_diameter = SCREW_HEAD_DIAMETER + SCREW_PADDING * 2;

$fn = 200;

difference() {
    union() {
        difference() {
            // base
            translate([0, 0, BASE_THICKNESS / 2])
            cube([board_width + WALL_THICKNESS * 2, board_height + WALL_THICKNESS * 2, BASE_THICKNESS], center = true);
            
            
            // cut off corners
            if (WALL_THICKNESS < padded_screw_diameter - padded_screw_diameter / 2 * (1 - sqrt_2_2))
                for (x = [-1, 1], y = [-1, 1])
                    translate([x * (board_width / 2 + padded_screw_diameter - padded_screw_diameter / 4 * sqrt_2_2), y * (board_height / 2 + padded_screw_diameter - padded_screw_diameter / 4 * sqrt_2_2), BASE_THICKNESS / 2])
                    cube([padded_screw_diameter, padded_screw_diameter, BASE_THICKNESS], center = true);
        }
        
        translate([0, 0, BASE_THICKNESS + ADDITIONAL_ELEVATION]) {
            // black pill support
            translate([-board_width / 2 + 5, board_height / 2 - 20 - 20, 0])
            cube([10, 20, 2 + ADDITIONAL_ELEVATION]);
            
            // keyboard pcb support
            translate([board_width / 2 - 15 - 60, board_height / 2 - 20 - 20, 0])
            cube([60, 20, 14 + ADDITIONAL_ELEVATION]);
            
            // wall under header
            translate([board_width / 2, -board_height / 2 + 30 + 0.5 - 2.54 + (11 - HEADER_PIN_COUNT) * 2.54, 0])
            cube([WALL_THICKNESS, HEADER_PIN_COUNT * 2.54, 14 - 2.5 + ADDITIONAL_ELEVATION]);
        }
        
        // screw padding
        if (WALL_THICKNESS < padded_screw_diameter - padded_screw_diameter / 2 * (1 - sqrt_2_2))
            for (x = [-1, 1], y = [-1, 1])
                translate([x * (board_width / 2 + padded_screw_diameter / 2 * sqrt_2_2), y * (board_height / 2 + padded_screw_diameter / 2 * sqrt_2_2), 0])
                cylinder(BASE_THICKNESS, d = padded_screw_diameter);
    }
    
    // screw hole
    for (x = [-1, 1], y = [-1, 1])
        translate([x * (board_width / 2 + padded_screw_diameter / 2 * sqrt_2_2), y * (board_height / 2 + padded_screw_diameter / 2 * sqrt_2_2), 0]){
            cylinder(SCREW_HEAD_THICKNESS, d = SCREW_HEAD_DIAMETER);
            
            translate([0, 0, SCREW_HEAD_THICKNESS])
            cylinder(BASE_THICKNESS - SCREW_HEAD_THICKNESS, d = SCREW_DIAMETER);
        }
    
    // usb port indent
    translate([-(board_width / 2 - (10 - USB_WALL_WIDTH / 2)), board_height / 2 + USB_WALL_THICKNESS, 0])
    cube([USB_WALL_WIDTH, WALL_THICKNESS - USB_WALL_THICKNESS, BASE_THICKNESS]);
}