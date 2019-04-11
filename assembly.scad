include <config.scad>;
use <filament-drive.scad>;
use <lib/util.scad>;
use <lib/vitamins.scad>;
use <x-carriage.scad>;
use <y-carriage.scad>;
use <z-axis-mount.scad>;
use <rear-idler-mounts.scad>;
use <base-plate.scad>;
use <misc.scad>;

base_plate_for_display();

for(x=[right]) {
  translate([x*y_rail_pos_x,0,y_rail_pos_z]) {
    mirror([1-x,0,0]) {
      y_carriage(x);

      translate([x_rail_end_relative_to_y_rail_x-line_bearing_diam+0.5,10,x_rail_end_relative_to_y_rail_z-x_rail_extrusion_height/2]) {
        rotate([0,90,0]) {
          rotate([0,0,90]) {
            endstop_flag();
          }
        }
      }
    }

    rotate([0,90,0]) {
      rotate([90,0,0]) {
        color("silver") extrusion_2040(y_rail_len);
      }
    }

    translate([0,y_rail_len/2,0]) {
      rear_idler_mount(x);
    }
  }

  mirror([-1+x,0,0]) {
    translate([motor_pos_x,-y_rail_len/2-0.05,0]) {
      motor_mount(x);
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
