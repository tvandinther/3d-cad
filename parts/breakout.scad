include <BOSL2/std.scad>
use <./usb.scad>

module usbc_breakout() {
    $fn = 30;
    pcb_thickness = 1.6;
    pcb_width = 21.8;
    pcb_depth = 13.0 + 0.1;
    screw_hole_radius = 1.5;
    screw_hole_offset_y = 1;
    screw_hole_offset_x = 1;
    embed_nut_outer_diameter = 4.2;
    embed_nut_length = 3;
    
    screw_hole_center_x = screw_hole_offset_x + screw_hole_radius;
    screw_hole_center_y = screw_hole_offset_y + screw_hole_radius;
    
    difference() {
        union() {
            // pcb
            cube([pcb_width, pcb_depth, pcb_thickness + 0.05], center=false);
        
            // surface
            up(pcb_thickness) {
                // clearance
                difference() {
                //translate([2, pcb_depth, 0])
                    cube([pcb_width, pcb_depth, 1], center=false);

                xflip_copy(x=pcb_width/2) {
                    // embedded nut standoff
                    cube([(screw_hole_offset_x*1) + embed_nut_outer_diameter, (screw_hole_offset_x*1) + embed_nut_outer_diameter, 1]);
                    
                    // side standoff
                    cube([1, pcb_depth, 1]);
                        
                    // rear standoff
                    back(pcb_depth-2) cube([2, 2, 1]);
                }
                }
                // plug
                translate([((pcb_width)/ 2), -2, 0])
                    usbc_receptacle();
                
                // plug clearance
                right(pcb_width/2)
                xrot(90)
                linear_extrude(5)
                offset(r=0.25)
                usbc_shape();
                
                // embedded nuts
                xflip_copy(offset=screw_hole_center_x, x=pcb_width/2)
                    back(screw_hole_offset_y + screw_hole_radius)
                        cylinder(embed_nut_length, embed_nut_outer_diameter/2, embed_nut_outer_diameter/2);
            } 
        }
    // screw hole
    show_holes = false;
    if (show_holes) xflip_copy(offset=screw_hole_center_x, x=pcb_width/2) back(screw_hole_center_y) down(1)
        cylinder(pcb_thickness + embed_nut_length + 2, screw_hole_radius, screw_hole_radius);
    }
}