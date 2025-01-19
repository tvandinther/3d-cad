include <BOSL2/std.scad>
use <../parts/switches.scad>
use <../parts/boards.scad>

offset = 11.25;
plug_width = 9.441;
box_width = 32;
show_box = true;
show_lid = false;
show_parts = false;
embedded_switch = true;

module lid() {
    thickness = 1.6;

    difference() {
        union() {
            right(box_width) up(8) yrot(180) import("../stl/esp32_cam/lid.stl");
            
            // USB hole fill
            right(10) back(2.8) up(22) cube([12, 6, thickness]);

            if (embedded_switch) {
                // switch area fill
                up(22) back(28) right(12.2) linear_extrude(thickness) xcopies(n=3, l=1) hexagon(2.34);
            }
        }

        if (embedded_switch) {
            // full switch cutout
            up(16) back(28 - (3.7/2)) right(8.1) slide_switch_3pin();
        } else {
            // gap for switch
            up(21) back(28) right(12.2) linear_extrude(4) xcopies(n=3, l=1) hexagon(2.34);
        }

        // 3mm led hole
        up(21) back(16) right(8.5) cylinder(10, 1.5, 1.5, $fn = 30);
    }
}

module box() {
    center = box_width/2;
    union() {
        difference() {
            union(){
                import("../stl/esp32_cam/box.stl");
                
                translate([4, 1, 1.6])
                    extension();

                translate([28, 1, 21.6])
                    rotate([0,180,0])
                        extension();
                
                w = 8.8;
                up(6.5) right(center - w/2) back(6.5) cube([w, 3.1, 2]);   
            }
            
            right(center - 21.8/2) back(8.2) up(8.5) cube([21.8, 2.2, 14]);
            
            intersection() {
                lid();
    
                translate([-3,-5, 20])
                    cube([40, 17, 5]);
            }
        }
        
        // SD Card hole fill
        translate([8,50.4,4]) cube([16, 1.6, 6]);
        
        // Screw hole fill
        translate([8,0,8]) cube([16, 6.6, 6]);
    }
}

module extension() {
    union() {
        cube([6.3, 9.25, 20], center=false);
        translate([0,9.25,0]) cube([7.1, 0.1, 20], center=false);
    }
}



if (show_parts) {
    up(13.5 + (embedded_switch ? 1.5 : 0)) back(28 - (3.7/2)) right(8.1) slide_switch_3pin();
    translate([0, -20, 0]) usbc_breakout();
}

difference() {
    union() {
        if (show_lid) lid();
        if (show_box) box();
    }

    translate([26.9, 8.4, 21.61]) rotate([-90, 0, 180]) usbc_breakout();
}
