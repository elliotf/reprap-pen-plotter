include <config.scad>;
include <util.scad>;
include <vitamins.scad>;

teflon_bushing_profile_for_2040_extrusion();

translate([0,0,-0.1]) {
  % extrusion_2040_profile();
}
