use <util.scad>;
include <config.scad>;
include <filament_drive.scad>;

y_rail_len = 200;
x_rail_len = 200;

y_rail_pos_x = x_rail_len/2 + 15;

//x_rail_pos_z = new_filament_drive_wall_thickness + motor_opening_side/2 - pulley_idler_diam/2;
x_rail_pos_z = new_filament_drive_wall_thickness + motor_opening_side/2 + pulley_idler_diam/2;

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

color("white") base_plate();

for(x=[left,right]) {
  translate([x*y_rail_pos_x,0,0]) {
    translate([0,0,20+y_rail_dist_above_plate]) {
      rotate([0,90,0]) {
        rotate([90,0,0]) {
          color("silver") extrusion_2040(y_rail_len);
        }
      }
    }

    mirror([1-x,0,0]) {
      translate([-15,-y_rail_len/2-new_filament_drive_dist_motor_rail-1,new_filament_drive_overall_width/2]) {
        rotate([0,-90,0]) {
          filament_drive_assembly();
        }
      }
    }
  }
}

//translate([0,0,y_rail_dist_above_plate+10]) {
translate([0,0,x_rail_pos_z]) {
  rotate([0,90,0]) {
    rotate([0,0,90]) {
      color("silver") extrusion_2040(x_rail_len);
    }
  }
}
