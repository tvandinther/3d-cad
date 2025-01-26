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
    bottom_surface_height = 22;

    difference() {
        union() {
            right(box_width) up(8) yrot(180) import("../stl/esp32_cam/lid.stl");
            
            up(bottom_surface_height) {
                // USB hole fill
                let (width = 12, height = 6, depth = thickness) {
                    right(box_width / 2) back(2.8 + (height / 2)) up(depth / 2) 
                        cube([width, height, depth], center = true);
                }

                if (embedded_switch) {
                    // switch area fill
                    back(28) right(12.2) linear_extrude(thickness) xcopies(n=3, l=1) hexagon(2.34);
                }
            }
        }

        up(bottom_surface_height - 1) {
            back(28) if (embedded_switch) {
                // full switch cutout
                down(5) fwd(3.7 / 2) right(8.1) slide_switch_3pin();
            } else {
                // gap for switch
                right(12.2) linear_extrude(4) xcopies(n=3, l=1) hexagon(2.34);
            }

            // 3mm led hole
            back(16) right(8.5) cylinder(10, 1.5, 1.5, $fn = 30);
        }
    }
}

module box() {
    center = box_width / 2;
    thickness = 1.6;
    $fn = 50;

    union() {
        difference() {
            union(){
                import("../stl/esp32_cam/box.stl");
                
                // widen usb board cradle
                xflip_copy(x = box_width / 2)
                    right(4) back(1) up(thickness)
                        union() {
                            cube([6.3, 9.25, 20], center=false);
                            
                            back(9.25)
                                cube([7.1, 0.1, 20], center=false);
                        }
                
                // flatten usb board area
                let(width = 8.8)
                    right(center - width / 2) back(6.5) up(6.5) 
                        cube([width, 3.1, 2]);
            }

            // widen camera hole
            let(lens_diameter = 8.3, tolerance = 0.1)
                right(center) back(38.75)
                    cyl(l = thickness, r = (lens_diameter / 2) + tolerance, anchor = BOTTOM, rounding = -0.5);
            
            // usb board overhang removal
            let(width = 21.8)
                right(center - width / 2) back(8.2) up(8.5) 
                    cube([width, 2.2, 14]);
            
            // lid lip cutout
            intersection() {
                lid();
    
                left(3) fwd(5) up(20)
                    cube([40, 17, 5]);
            }
        }
        
        // SD Card hole fill
        right(8) back(50.4) up(4)
            cube([16, thickness, 6]);
        
        // Screw hole fill
        right(8) up(8)
            cube([16, 6.6, 6]);
    }
}

if (show_parts) {
    up(13.5 + (embedded_switch ? 1.5 : 0)) back(28 - (3.7/2)) right(8.1) slide_switch_3pin();
}

difference() {
    union() {
        if (show_lid) lid();
        if (show_box) box();
    }

    right(26.9) back(8.4) up(21.61)
        rotate([-90, 0, 180]) usbc_breakout();
}
