include <MCAD/units/metric.scad>
use <MCAD/shapes/polyhole.scad>
use <fillet.scad>

function mm (x) = length_mm (x);
function centroid (a, b, c) = [
    (a[0] + b[0] + c[0]) / 3,
    (a[1] + b[1] + c[1]) / 3,
    (a[2] + b[2] + c[2]) / 3
];

function get_fragments_from_r (r) = (
    (r < 0.00000095367431640625) ? 3 :
    ceil (max (min (360 / $fa, r * 2 * PI / $fs), 5))
);

screwholes = [
    [0, 0],
    [mm (163), 0],
    [mm (48.125767), mm (105.546)]
];

$fs = 0.5;
$fa = 1;

clearance = mm (0.3);
screw_d = 4;
shaft_d = 5;
wall_thickness = 6;
outer_d = screw_d + wall_thickness + clearance;
plate_thickness = mm (5);

arm_distance = mm (35);
arm_thickness = mm (5);
arm_width = mm (30);
arm_height = mm (35);

fillet_r = mm (5);

module place_screws () {
    for (point = screwholes)
    translate (point)
    children ();
}

module arm ()
{
    module place_arm_screwhole ()
    translate ([0, 0, arm_height - arm_width / 2 + plate_thickness])
    rotate (90, X)
    children ();

    difference () {
        hull () {
            place_arm_screwhole ()
            cylinder (d=arm_width, h=arm_thickness, center=true);

            translate ([0, 0, epsilon / 2])
            cube ([arm_width, arm_thickness, epsilon], center=true);
        }

        place_arm_screwhole ()
        translate ([0, 0, -arm_width])
        polyhole (d=shaft_d + clearance, h=arm_width * 2);
    }
}

module place_arm (i)
{
    translate (centroid (screwholes[0], screwholes[1], screwholes[2]))
    translate ([0, i * (arm_distance + arm_thickness) / 2, 0])
    children ();
}

module plate ()
{
    linear_extrude (height=plate_thickness)
    difference () {
        hull ()
        place_screws ()
        circle (d=outer_d);

        place_screws ()
        polyhole (d=screw_d + clearance, h=-1);
    }
}

fillet (r=fillet_r, steps=fillet_r / 0.2) {
    render ()
    fillet (r=fillet_r, steps=fillet_r / 0.2) {
        plate ();

        place_arm (1)
        arm ();
    }

    place_arm (-1)
    arm ();
}
