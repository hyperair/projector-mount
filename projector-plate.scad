include <MCAD/units/metric.scad>
use <MCAD/shapes/polyhole.scad>
use <fillet.scad>
use <arm.scad>

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
    [mm (164), 0],
    [mm (118.05), mm (106.51)]
];
center = centroid (screwholes[0], screwholes[1], screwholes[2]);

$fs = 0.5;
$fa = 1;

clearance = mm (0.3);
screw_d = 4;
shaft_d = 5;
wall_thickness = 10;
outer_d = screw_d + wall_thickness * 2 + clearance;
plate_thickness = mm (5);

arm_distance = mm (30);
arm_thickness = mm (5);
arm_width = mm (30);
arm_height = mm (35);

fillet_r = mm (5);
fillet_steps = get_fragments_from_r (fillet_r) * 0.25; // 90° joint

module place_screws () {
    for (point = screwholes)
    translate (point)
    children ();
}

module place_arm (i)
{
    translate (center)
    translate ([0, i * (arm_distance + arm_thickness) / 2, 0])
    children ();
}

module single_arm ()
arm (height = arm_height, width = arm_width, thickness = arm_thickness,
    shaft_d = shaft_d + clearance);

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

plate ();

for (i=[1, -1])
place_arm (i)
single_arm ();

fillet (r=fillet_r, steps=fillet_steps, include=false) {
    plate ();

    place_arm (-1)
    single_arm ();
}

fillet (r=fillet_r, steps=fillet_steps, include=false) {
    plate ();

    place_arm (1)
    single_arm ();
}
