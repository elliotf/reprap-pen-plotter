include <../lib/util.scad>;
include <../config.scad>;
use <../sketch-for-simpler.scad>;

rotate([0,180,0]) {
  wheeled_sidemount(left);
}
