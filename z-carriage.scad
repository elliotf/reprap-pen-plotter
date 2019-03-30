include <config.scad>;
use <z-axis-mount.scad>;


module to_print() {
  rotate([0,-90,0]) {
    z_carriage();
  }
}

to_print();
