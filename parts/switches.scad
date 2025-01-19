include <BOSL2/std.scad>

slide_switch_3pin = false;

module slide_switch_3pin() {
    length = 8.5;
    height = 3.7;
    depth = height;
    pin_length = length - height;

    // box
    up(pin_length)
        cube([length, height, depth]);
    
    // pins
    let(pin_side = 0.3, offset = 1.9, pin_count = 3)
        xcopies(n = pin_count, l = length - (offset * 2), sp = [offset, depth / 2, 0])
                cube([pin_side, pin_side, pin_length], anchor = BOTTOM);
    
    let(switch_stick_height = 3.8, switch_stick_side = 1.4)
        up(height + pin_length) back(depth / 2)
            xflip_copy(x = length / 2, offset = 2)
                cube([switch_stick_side, switch_stick_side, switch_stick_height], anchor = BOTTOM);
}

if (slide_switch_3pin) slide_switch_3pin();