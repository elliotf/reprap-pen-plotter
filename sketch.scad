include <config.scad>;
include <filament_drive.scad>;
use <util.scad>;
use <vitamins.scad>;
use <x-carriage.scad>;
use <y-carriage.scad>;
use <z-axis.scad>;

y_rail_len = 100;
x_rail_len = 100;

y_rail_pos_x = x_rail_len/2 + -1*(x_rail_end_relative_to_y_rail_x);
y_rail_pos_z = y_rail_dist_above_plate + 20;

//x_rail_pos_z = new_filament_drive_wall_thickness + motor_opening_side/2 - pulley_idler_diam/2;
//x_rail_pos_z = new_filament_drive_wall_thickness + motor_opening_side/2 + pulley_idler_diam/2;
x_rail_pos_z = y_rail_pos_z + x_rail_end_relative_to_y_rail_z;

// line_bearing_pos_y = 10;
// line_bearing_pos_x = x_rail_len/2 - line_bearing_diam/2;

module base_plate() {
  room_for_electronics = 3*inch;
  room_for_motors      = new_filament_drive_dist_motor_rail+motor_opening_side/2 + new_filament_drive_wall_thickness;
  room_for_idlers      = 30;
  overall_width = y_rail_pos_x*2 + 40 + room_for_electronics;
  // overall_depth = y_rail_len + motor_mount_thickness + motor_side;
  overall_depth = y_rail_len + room_for_motors + room_for_idlers;

  echo("BOM Base plate width: ", overall_width/25.4);
  echo("BOM Base plate depth: ", overall_depth/25.4);

  module body() {
    translate([-room_for_electronics/2,room_for_idlers/2-room_for_motors/2,0]) {
      square([overall_width,overall_depth],center=true);
      //rounded_square(overall_width,overall_depth,10);
    }
  }

  module holes() {
  }

  difference() {
    body();
    holes();
  }
}

// % base_plate();

for(x=[left,right]) {
  translate([x*y_rail_pos_x,0,0]) {
    translate([0,0,20+y_rail_dist_above_plate]) {
      mirror([1-x,0,0]) {
        y_carriage();
      }

      rotate([0,90,0]) {
        rotate([90,0,0]) {
          color("silver") extrusion_2040(y_rail_len);
        }
      }
    }

    mirror([1-x,0,0]) {
      translate([left*(y_rail_pos_x-x_rail_len/2-pulley_idler_diam/2),-y_rail_len/2-new_filament_drive_dist_motor_rail-1,nema17_len]) {
        filament_drive_assembly();
      }
    }
  }
}

//translate([0,0,y_rail_dist_above_plate+10]) {
translate([0,0,x_rail_pos_z]) {
  x_carriage();

  translate([0,-x_carriage_overall_depth/2,0]) {
    z_axis_assembly();
  }

  rotate([0,90,0]) {
    rotate([0,0,90]) {
      color("silver") extrusion_2040(x_rail_len);
    }
  }
}
