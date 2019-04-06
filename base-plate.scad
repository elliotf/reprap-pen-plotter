include <config.scad>;
include <lib/util.scad>;
include <filament-drive.scad>;
include <rear-idler-mounts.scad>;

module base_plate() {
  allot_space_x = (y_rail_extrusion_width/2 + motor_side)*2;
  room_for_electronics = 4*inch;
  offset_x = room_for_electronics/2;

  function overallSheetWidth() = (x_rail_len >= 1000) ? 60*inch
                             : (x_rail_len >= 500) ? 24*inch
                             : (x_rail_len >= 250) ? 18*inch
                             : x_rail_len + 3*inch;
  function overallWidth() = x_rail_len + allot_space_x + room_for_electronics;
  function overallLength() = (y_rail_len >= 1000) ? 60*inch
                           : (y_rail_len >= 500) ? 36*inch
                           : (y_rail_len >= 250) ? 24*inch
                           : y_rail_len + allot_space_y_for_motor_mount + allot_space_y_for_rear_idler;

  module body() {
    overall_length = overallLength();
    overall_width = overallWidth();
    translate([offset_x,-overall_length/2+y_rail_len/2+allot_space_y_for_rear_idler,0]) {
      square([overall_width,overall_length],center=true);
    }
  }

  module holes() {
    for(x=[left,right]) {
      mirror([-1+x,0,0]) {
        translate([motor_pos_x,-y_rail_len/2-0.05,0]) {
          position_motor_mount_anchor_holes() {
            accurate_circle(5,resolution);
          }
        }

        translate([y_rail_pos_x,y_rail_len/2,0]) {
          position_rear_idler_anchor_holes() {
            accurate_circle(5,resolution);
          }
        }
      }
    }
  }

  difference() {
    body();
    holes();
  }
}

module for_render() {
  base_plate();
}

for_render();
