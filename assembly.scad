include <config.scad>;
use <filament-drive.scad>;
use <lib/util.scad>;
use <lib/vitamins.scad>;
use <x-carriage.scad>;
use <y-carriage.scad>;
use <z-axis-mount.scad>;
use <rear-idler-mounts.scad>;
use <base-plate.scad>;

base_plate_thickness = 0.75*inch;
translate([0,0,-base_plate_thickness/2-1]) {
  color("ivory") {
    linear_extrude(height=base_plate_thickness,center=true,convexity=3) {
      base_plate();
    }
  }
}

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
  }

  mirror([-1+x,0,0]) {
    translate([motor_pos_x,-y_rail_len/2-0.05,0]) {
      motor_mount();
    }
  }

  translate([x*y_rail_pos_x,y_rail_len/2,20+y_rail_dist_above_plate]) {
    rear_idler_mount(x);
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
