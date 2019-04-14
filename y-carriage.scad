include <config.scad>;
include <lib/util.scad>;
use <lib/vitamins.scad>;

y_carriage_depth = 40;

module y_carriage(side) {
  y_carriage_overall_width  = y_rail_extrusion_width+printed_carriage_outer_skin_from_extrusion*2;
  y_carriage_overall_height  = y_rail_extrusion_height+printed_carriage_outer_skin_from_extrusion*2;

  line_bearing_pos_x = x_rail_end_relative_to_y_rail_x - line_bearing_diam/2;
  line_bearing_pos_z = x_rail_end_relative_to_y_rail_z + 10 + line_bearing_above_extrusion;
  line_bearing_hole_diam = line_bearing_inner+0.5;

  module xz_position_for_line_bearing() {
    translate([line_bearing_pos_x,0,line_bearing_pos_z]) {
      children();
    }
  }

  for(y=[front,rear]) {
    translate([0,y*10,0]) {
      xz_position_for_line_bearing() {
        % line_bearing();
      }
    }
  }

  translate([x_rail_end_relative_to_y_rail_x,0,x_rail_end_relative_to_y_rail_z]) {
    translate([-20,0,0]) {
      rotate([0,90,0]) {
        rotate([0,0,90]) {
          % extrusion_2040(40);
        }
      }
    }
  }

  module carriage_profile() {
    module profile_body() {
      rounded_square(y_carriage_overall_width,y_carriage_overall_height,printed_carriage_outer_diam);

      // arm to mount x rail / line bearing and support
      arm_support_joint_to_carriage_width = gap_between_x_rail_end_and_y_carriage + printed_carriage_wall_thickness;
      arm_support_overall_height = line_bearing_thickness+2*(bearing_bevel_height+printed_carriage_wall_thickness);
      translate([line_bearing_pos_x,line_bearing_pos_z]) {
        translate([arm_support_joint_to_carriage_width/2,0,0]) {
          for(z=[top,bottom]) {
            translate([0,z*(arm_support_overall_height/2-printed_carriage_wall_thickness/2)]) {
              rounded_square(line_bearing_diam+arm_support_joint_to_carriage_width,printed_carriage_wall_thickness,printed_carriage_inner_diam);
            }
          }
        }

        // join the top and bottom supports
        translate([line_bearing_diam/2+gap_between_x_rail_end_and_y_carriage+printed_carriage_wall_thickness/2,0,0]) {
          rounded_square(printed_carriage_wall_thickness,arm_support_overall_height,printed_carriage_inner_diam);
        }

        for(z=[top,bottom]) {
          translate([line_bearing_diam/2+gap_between_x_rail_end_and_y_carriage,z*(arm_support_overall_height/2-printed_carriage_wall_thickness)]) {
            rotate([0,0,135+z*(45)]) {
              round_corner_filler_profile(bearing_bevel_height*2);
            }
          }
        }
      }

      translate([line_bearing_pos_x+line_bearing_diam/2+arm_support_joint_to_carriage_width,y_carriage_overall_height/2,0]) {
        round_corner_filler_profile(printed_carriage_inner_diam);
      }

      translate([-y_carriage_overall_width/2,line_bearing_pos_z-arm_support_overall_height/2,0]) {
        rotate([0,0,-180]) {
          round_corner_filler_profile(gap_between_x_rail_end_and_y_carriage);
        }
      }
    }

    module profile_holes() {
      rounded_square(y_carriage_opening_depth,y_carriage_opening_height,printed_carriage_inner_diam);
    }

    difference() {
      profile_body();
      profile_holes();
    }
  }

  translate([0,0,40]) {
    color("green") {
      // carriage_profile();
    }
  }

  module body() {
    rotate([90,0,0]) {
      linear_extrude(height=y_carriage_depth,center=true,convexity=3) {
        carriage_profile();
      }
    }

    xz_position_for_line_bearing() {
      // make it easier to feed the line through?
      difference() {
        translate([line_bearing_diam/4+1,0,0]) {
          cube([line_bearing_diam/2,20,line_bearing_thickness+bearing_bevel_height*2+1],center=true);
        }
        for(y=[front,rear]) {
          translate([0,y*10,0]) {
            hole(line_bearing_diam+gap_between_x_rail_end_and_y_carriage*2+0.5,line_bearing_thickness*2,32);
          }
        }
      }

      // line bearing bevels
      for(y=[front,rear]) {
        for(z=[top,bottom]) {
          translate([0,y*10,z*(line_bearing_thickness/2+bearing_bevel_height+1)]) {
            hull() {
              hole(line_bearing_hole_diam+extrude_width*2,(bearing_bevel_height+1)*2);
              hole(line_bearing_hole_diam+(extrude_width+bearing_bevel_height)*2,2);
            }
          }
        }
      }
    }
  }

  module holes() {
    bushing_from_wall = x_rail_extrusion_height/5;

    // PTFE bushings
    for(y=[front,rear]) {
      translate([0,y*(y_carriage_depth/2-printed_carriage_bushing_from_end-printed_carriage_bushing_len/2),0]) {
        rotate([90,0,0]) {
          rotate([0,0,90]) {
            linear_extrude(height=printed_carriage_bushing_len,center=true) {
              ptfe_bushing_profile_for_2040_extrusion();
            }
          }
        }
      }
    }

    xz_position_for_line_bearing() {
      // line bearing holes
      for(y=[front,rear]) {
        for(z=[top,bottom]) {
          translate([0,y*10,0]) {
            hull() {
              hole(line_bearing_hole_diam,30);
            }
          }
        }
      }
    }

    // mounting holes for misc
    if (side == right) {
      for(y=[-5,5]) {
        translate([0,y,y_carriage_overall_height/2]) {
          hole(threaded_insert_diam,printed_carriage_wall_thickness*2+1,8);
        }
      }
    }
  }

  difference() {
    body();
    holes();
  }
}

module to_print(side) {
  rotate([-90,0,0]) {
    y_carriage(side);
  }
}

to_print();
