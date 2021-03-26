include <../config.scad>;
use <../lib/util.scad>;
use <../lib/vitamins.scad>;

mount_thickness = 1.4;

module motor_mount(motor_side,hole_spacing,shoulder_diam) {
  wall_thickness = extrude_width*4;
  round_diam = wall_thickness*2;

  overall_motor_side = motor_side+2*(tolerance*2+wall_thickness*2);
  overall_mount_width = overall_motor_side + tolerance*2 + m5_bolt_head_diam*2 + round_diam;
  mounting_hole_pos_x = overall_mount_width/2-m5_bolt_head_diam/2-round_diam/2; // motor_side/2+wall_thickness+tolerance+m5_bolt_head_diam/2;
  mounting_hole_pos_z = -m5_bolt_head_diam/2-5-tolerance;
  mount_height = abs(mounting_hole_pos_z) + m5_bolt_head_diam/2 + tolerance + wall_thickness;

  echo("wall_thickness: ", wall_thickness);

  module body() {
    translate([0,0,mount_thickness/2]) {
      hull() {
        translate([0,-(wall_thickness*2+tolerance)/2,0]) {
          rounded_cube(overall_motor_side,motor_side+tolerance+wall_thickness*2,mount_thickness,round_diam,resolution);
        }
        translate([0,-overall_motor_side/2+round_diam/2,0]) {
          rounded_cube(overall_mount_width,round_diam,mount_thickness,round_diam,resolution);
        }
      }
    }

    for (x=[left,right]) {
      translate([x*(overall_motor_side/2-round_diam/2),0,0]) {
        hull() {
          translate([0,motor_side/2-round_diam/2,mount_thickness/2]) {
            hole(wall_thickness*2,mount_thickness,resolution);
          }
          translate([0,-(overall_motor_side/2-round_diam),-mount_height/2]) {
            hole(wall_thickness*2,mount_height,resolution);
          }
        }
      }
    }

    translate([0,-overall_motor_side/2+round_diam/2,-mount_height/2]) {
      rounded_cube(overall_mount_width,round_diam,mount_height,round_diam,resolution);
    }
  }

  module holes() {
    hole(shoulder_diam+2,mount_thickness*4,resolution*2);

    for (x=[left,right]) {
      for (y=[front,rear]) {
        translate([x*hole_spacing/2,y*hole_spacing/2,mount_thickness/2]) {
          hole(3+tolerance,mount_thickness*3,resolution);
        }
      }


      translate([x*mounting_hole_pos_x,-motor_side/2,mounting_hole_pos_z]) {
        rotate([90,0,0]) {
          # hole(m5_loose_hole,30,resolution);
        }
      }
    }
  }

  difference() {
    body();
    holes();
  }

  % motor_nema17();
}

module nema17_motor_mount() {
  motor_mount(nema17_side,nema17_hole_spacing,nema17_shoulder_diam);
}

nema17_motor_mount();
