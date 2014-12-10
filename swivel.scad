use <arm.scad>
use <fillet.scad>
use <MCAD/shapes/polyhole.scad>
include <MCAD/units/metric.scad>

$fs = 0.5;
$fa = 1;

module single_arm ()
rotate (90, Z)
arm (height=45, width=30, thickness=5, shaft_d=5.3);

module place_arm (i)
{
    translate ([i * 17.5, 0, 0])
    children ();
}

module base_plate ()
difference () {
    linear_extrude (height=10)
    square ([40, 30], center=true);

    translate ([0, 0, -epsilon])
    polyhole (d=5.3, h=10 + epsilon * 2);
}

fillet (r=5, steps=20) {
    place_arm (1)
    single_arm ();

    base_plate ();
}

fillet (r=5, steps=20) {
    place_arm (-1)
    single_arm ();

    base_plate ();
}
