include <config.scad>;
include <lib/util.scad>;
include <filament-drive.scad>;
include <rear-idler-mounts.scad>;

allot_space_x = (y_rail_extrusion_width/2 + motor_side)*2;
room_for_electronics = 4*inch;

function overallWidth() = (x_rail_len >= 1000) ? 60*inch
                           : (x_rail_len >= 500) ? 24*inch
                           : (x_rail_len >= 250) ? 18*inch
                           : x_rail_len + allot_space_x + room_for_electronics;
function overallLength() = (y_rail_len >= 1000) ? 60*inch
                         : (y_rail_len >= 500) ? 36*inch
                         : (y_rail_len >= 250) ? 24*inch
                         : y_rail_len + allot_space_y_for_motor_mount + allot_space_y_for_rear_idler;
function offsetForX() = (x_rail_len >= 1000) ? 8*inch
                      : (x_rail_len >= 500) ? 0*inch
                      : (x_rail_len >= 250) ? 2*inch
                      : 0;

base_width = overallWidth();
base_length = overallLength();

pos_x = offsetForX();
pos_y = -base_length/2+y_rail_len/2+allot_space_y_for_rear_idler;

module base_plate() {
  echo("SHEET WIDTH: ", base_width/25.4);
  echo("SHEET LENGTH: ", base_length/25.4);

  module body() {
    translate([pos_x,pos_y,0]) {
      square([base_width,base_length],center=true);
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

module base_plate_for_display() {
  base_plate_thickness = 0.75*inch;

  translate([0,0,-base_plate_thickness/2-1]) {
    color("lightgreen") {
      linear_extrude(height=base_plate_thickness,center=true,convexity=3) {
        base_plate();
      }
    }
  }
}

base_plate_for_display();
