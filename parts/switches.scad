include <BOSL2/std.scad>

module slide_switch_3pin() {
    translate([0, 0, 4.8]) cube([8.5, 3.7, 3.7]);
    
    // pins
    xcopies(n=3, l=8.5-(1.9*2), sp=[0,0,0]) translate([1.9, (3.7-0.3)/2, 0]) cube([0.3, 0.3, 4.8]);
    
    up(8.5) back((3.7-1.4)/2) right(2) {
        // on position
        cube([1.4, 1.4, 3.8]);
        // off position
        right(4.5-1.4) cube([1.4, 1.4, 3.8]);
    }
}