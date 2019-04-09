include <config.scad>;
include <lib/vitamins.scad>;

module endstop_flag() {
  flag_length = line_bearing_diam-1;
  flag_height = printed_carriage_outer_skin_from_extrusion+mech_endstop_tiny_width+2;
  overall_width = v_slot_width + wall_thickness*4;

  module profile() {
    hull() {
      square([v_slot_gap,2*v_slot_depth],center=true);

      translate([0,-wall_thickness]) {
        square([v_slot_width,wall_thickness*2],center=true);
      }
    }

    hull() {
      translate([0,bottom*(wall_thickness)]) {
        rounded_square(overall_width,wall_thickness*2,wall_thickness);
      }
      translate([right*(overall_width/2-wall_thickness),-flag_height/2,0]) {
        rounded_square(wall_thickness*2,flag_height,wall_thickness);
      }
    }
  }

  module body() {
    linear_extrude(height=flag_length,center=true,convexity=2) {
      profile();
    }
  }

  module holes() {
    hull() {
      translate([0,bottom*(wall_thickness*2+flag_height),flag_length/2+1]) {
        cube([overall_width+1,flag_height*2,2],center=true);
      }

      translate([0,bottom*(flag_height+1),-flag_height/2+wall_thickness*2]) {
        cube([overall_width+1,2,2],center=true);
      }
    }

    translate([left*(wall_thickness*2),bottom*(wall_thickness*2+flag_height/2),wall_thickness*2]) {
      cube([overall_width,flag_height,flag_length],center=true);
    }

    rotate([90,0,0]) {
      hole(m3_loose_hole,40,8);
    }
  }

  translate([0,0,flag_length/2]) {
    color("lightblue") difference() {
      body();
      holes();
    }
  }
}


