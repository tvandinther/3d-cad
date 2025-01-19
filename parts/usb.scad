include <BOSL2/std.scad>

module usbc_receptacle(roundness = 2) {
    width = 8.96;
    height = 3.26;
    depth = 7.5 + 1;
    r = roundness / (width - 6.69);
    
    // right(r)
    back(depth)
    // up(r)
    xrot(90)
    linear_extrude(depth) usbc_shape(roundness = roundness);
}

module usbc_shape(roundness = 2) {
    width = 8.96;
    unrounded_width = 6.69;
    height = 3.26;
    r = roundness / (width - unrounded_width);
    
    up(1/2) back(height/2) offset(r = r, $fn = 20) {
        square([width - (r * 2), height - (r * 2)], center = true);
    }
}