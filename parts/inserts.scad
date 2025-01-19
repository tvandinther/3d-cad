include <BOSL2/std.scad>

module chamfered_insert(l, d, lx = 0.5) {
        cyl(
            l + lx,
            d = d, 
            anchor = DOWN,
            chamfer1 = -0.5
        );
}