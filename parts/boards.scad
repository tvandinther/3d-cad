include <BOSL2/std.scad>
use <./usb.scad>
use <./inserts.scad>

usbc_breakout = false;

module usbc_breakout() {
    $fn = 50;
    fit_clearance = 0.1;

    pcb_thickness = 1.6;
    pcb_width = 21.8;
    pcb_depth = 13.0 + fit_clearance;
    
    screw_hole_offset_x = 1;
    screw_hole_offset_y = 1;
    screw_hole_radius = 1.5;
    
    embed_nut_outer_diameter = 3.77 + fit_clearance;
    embed_nut_length = 3;
    
    screw_hole_center_x = screw_hole_offset_x + screw_hole_radius;
    screw_hole_center_y = screw_hole_offset_y + screw_hole_radius;
    
    difference() {
        union() {
            // pcb
            cube([pcb_width, pcb_depth, pcb_thickness + 0.05], center = false);
        
            // surface
            up(pcb_thickness) {
                // clearance
                difference() {
                    clearance_height = 1;
                    cube([pcb_width, pcb_depth, clearance_height], center = false);

                    let (sub_nudge = 0.1, subtracted_clearance = clearance_height + sub_nudge) {
                        xflip_copy(x = pcb_width / 2) {
                            fwd(sub_nudge) {
                                // embedded nut standoff
                                cube([screw_hole_offset_x + embed_nut_outer_diameter, screw_hole_offset_x + embed_nut_outer_diameter + sub_nudge, subtracted_clearance]);
                            
                                // side standoff
                                left(sub_nudge) 
                                    cube([1 + sub_nudge, pcb_depth + (2 * sub_nudge), subtracted_clearance]);
                            }                                
                                
                            // rear standoff
                            let (x = 2, y = 2) {
                                back(pcb_depth - y) 
                                cube([x, y + sub_nudge, subtracted_clearance]);
                            }
                        }
                    }
                }
                
                right(pcb_width / 2) {
                    // plug
                    fwd(2) usbc_receptacle();
                
                    // plug clearance
                    xrot(90)
                    linear_extrude(5)
                    offset(r = 0.25)
                    usbc_shape();
                }
                
                // inserts
                xflip_copy(offset = screw_hole_center_x, x = pcb_width / 2)
                    back(screw_hole_center_y)
                        chamfered_insert(embed_nut_length, embed_nut_outer_diameter);
            } 
        }
    
        // screw hole
        show_holes = false;
        if (show_holes) xflip_copy(offset=screw_hole_center_x, x=pcb_width/2) back(screw_hole_center_y) down(1)
            cylinder(pcb_thickness + embed_nut_length + 2, screw_hole_radius, screw_hole_radius);
    }
}

if (usbc_breakout) usbc_breakout();
