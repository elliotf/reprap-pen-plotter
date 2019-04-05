include <../config.scad>;
use <../z-axis-mount.scad>;


module to_print() {
  translate([0,rear*(clearance_for_z_bushings_and_zip_ties),0]) {
    rotate([180,0,0]) {
      //z_carriage();
      combined_z_carriage_printed_vertically(5,14,45);
    }
  }
}

to_print();
