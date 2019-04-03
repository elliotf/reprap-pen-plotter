include <../config.scad>;
use <../z-axis-mount.scad>;


module to_print() {
  translate([0,rear*(clearance_for_z_bushings_and_zip_ties),0]) {
    rotate([0,-90,0]) {
      z_carriage();
    }
  }
}

to_print();
