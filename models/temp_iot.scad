include <BOSL2/std.scad>

$fn = 20;

case_width = 30;
case_length = 70;
case_height = 15;
case_dimensions = [case_length, case_width, case_height];
wall_thickness = 2;

cut_height = case_height * 2 / 3;
cut_size = case_length * 2 + 1;

center = [case_length / 2, case_width / 2, case_height / 2];

back(case_width + 10) xrot(180, cp = center) top_half(z = cut_height, s = cut_size) case();
bottom_half(z = cut_height, s = cut_size) case();

function func1(x=3) = 2*x+1;
function thickness_to_scale(thickness, dimension_length) = 1 - (2 * (thickness / dimension_length));

function thickness_to_scales(dimensions) = [for (d = dimensions) 1 - (2 * (wall_thickness / d))];

module case() {
    module box() cuboid(
            case_dimensions, 
            anchor = LEFT + FRONT + BOTTOM,
            rounding = 2
        );
    
    union() {
        difference() {
            box();

            right(wall_thickness) back(wall_thickness) up(wall_thickness)
                scale(thickness_to_scales(case_dimensions))
                    box();
        }

        // interior edges / lips
        let(lip_height = 2, lip_size = 2)
        right(wall_thickness) back(wall_thickness) up(wall_thickness)
            difference() {
                cuboid(list_set(add_scalar(case_dimensions, -2*wall_thickness), 2, lip_height), anchor = LEFT + FRONT + BOTTOM);
                
                let (rounding = 1)
                right(lip_size) back(lip_size)
                    cuboid(list_set(add_scalar(case_dimensions, -2*(wall_thickness + lip_size)), 2, lip_height + rounding), anchor = LEFT + FRONT + BOTTOM, rounding = rounding);
            }
    }
}
