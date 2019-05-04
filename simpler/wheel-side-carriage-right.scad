include <../lib/util.scad>;
include <../config.scad>;
use <../sketch-for-simpler.scad>;

debug = false;

angle = (debug) ? 0 : 180;

rotate([0,angle,0]) {
  wheeled_sidemount(right);
  translate([-20,20,0]) {
    rotate([90,0,0]) {
      % color("silver",0.3) extrusion_2040(40);
    }
  }
}
