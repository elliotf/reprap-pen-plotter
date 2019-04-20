include <config.scad>;
include <lib/util.scad>;
use <lib/vitamins.scad>;

y_carriage_depth = 40;

module ptfe_y_carriage(side) {
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

module preloaded_spring_y_carriage(side) {
  wall_thickness = extrude_width*4;
  y_carriage_overall_width  = y_rail_extrusion_width+printed_carriage_outer_skin_from_extrusion*2;
  y_carriage_overall_height  = y_rail_extrusion_height+printed_carriage_outer_skin_from_extrusion*2;

  line_bearing_pos_x = x_rail_end_relative_to_y_rail_x - line_bearing_diam/2;
  line_bearing_pos_z = x_rail_end_relative_to_y_rail_z + 10 + line_bearing_above_extrusion;
  line_bearing_hole_diam = line_bearing_inner+0.5;
  line_bearing_thickness_gap = line_bearing_thickness + tolerance;

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

  /*
  translate([0,0,50]) {
    color("blue") carriage_profile();

    rotate([0,0,90]) {
      color("grey") extrusion_2040(3);
    }
  }
  */

  spring_thickness = extrude_width*4;
  spring_gap_width = 1;
  preload = -0.2;

  cavity_overall_width = y_carriage_overall_width - wall_thickness*4;
  cavity_overall_height = y_carriage_overall_height - wall_thickness*4;

  bearing_arm_thickness = printed_carriage_wall_thickness;
  bearing_arm_support_joint_to_carriage_width = gap_between_x_rail_end_and_y_carriage + wall_thickness;
  bearing_arm_support_overall_height = line_bearing_thickness_gap+2*(bearing_bevel_height+bearing_arm_thickness);

  module carriage_profile() {
    module spring_profile() {
      contact_width = 8;
      translate([0,-preload+spring_thickness/2]) {
        translate([left*(y_rail_extrusion_width/2-contact_width/2),0,0]) {
          rounded_square(contact_width,spring_thickness,spring_thickness);
        }
        hull() {
          translate([left*(y_rail_extrusion_width/2-contact_width+spring_thickness/2),0,0]) {
            accurate_circle(spring_thickness,resolution);
          }
          translate([right*(y_rail_extrusion_width/2-spring_thickness),spring_gap_width/2,0]) {
            accurate_circle(spring_thickness,resolution);
          }
        }
        translate([right*(y_rail_extrusion_width/2-spring_thickness),2-spring_thickness/2+spring_gap_width/2,0]) {
          # rounded_square(spring_thickness,4,spring_thickness);
        }
      }
    }

    module profile_body() {
      for(z=[top,bottom]) {
        mirror([0,1-z,0]) {
          translate([0,y_rail_extrusion_height/2]) {
            spring_profile();
          }

          for(x=[left,right]) {
            mirror([1-x,0,0]) {
              translate([y_rail_extrusion_width/2,y_rail_extrusion_height/4,0]) {
                rotate([0,0,-90]) {
                  spring_profile();
                }
              }
            }
          }
        }
      }

      // arm to mount x rail / line bearing and support
      translate([line_bearing_pos_x,line_bearing_pos_z]) {
        for(z=[top,bottom]) {
          translate([0,z*(bearing_arm_support_overall_height/2-bearing_arm_thickness/2)]) {
            hull() {
              rounded_square(line_bearing_diam,bearing_arm_thickness,bearing_arm_thickness);
              translate([line_bearing_diam/2+bearing_arm_support_joint_to_carriage_width/2,0,0]) {
                square([bearing_arm_support_joint_to_carriage_width,bearing_arm_thickness],center=true);
              }
            }
          }
        }

        // join the top and bottom supports
        translate([line_bearing_diam/2+gap_between_x_rail_end_and_y_carriage+wall_thickness,0,0]) {
          rounded_square(wall_thickness*2,bearing_arm_support_overall_height,wall_thickness*2);
        }

        for(z=[top,bottom]) {
          translate([line_bearing_diam/2+gap_between_x_rail_end_and_y_carriage,z*(bearing_arm_support_overall_height/2-bearing_arm_thickness)]) {
            rotate([0,0,135+z*(45)]) {
              round_corner_filler_profile(bearing_bevel_height*2);
            }
          }
        }
      }

      // round top of y carriage with bearing holder
      translate([left*cavity_overall_width/2,y_carriage_overall_height/2,0]) {
        round_corner_filler_profile(printed_carriage_inner_diam*3);
      }
      translate([-y_carriage_overall_width/4,y_carriage_overall_height/2-wall_thickness,0]) {
        square([y_carriage_overall_width/2,wall_thickness*2],center=true);
      }

      translate([left*(y_rail_extrusion_width/2+printed_carriage_outer_skin_from_extrusion),line_bearing_pos_z-bearing_arm_support_overall_height/2,0]) {
        rotate([0,0,-180]) {
          round_corner_filler_profile(gap_between_x_rail_end_and_y_carriage);
        }
      }

      difference() {
        gap_width = cavity_overall_height - y_rail_extrusion_height;
        rounded_square(y_carriage_overall_width,y_carriage_overall_height,wall_thickness*8);
        rounded_square(cavity_overall_width,cavity_overall_height,gap_width);
      }
    }

    module profile_holes() {
    }

    difference() {
      profile_body();
      profile_holes();
    }
  }

  module body() {
    rotate([90,0,0]) {
      linear_extrude(height=y_carriage_depth,center=true,convexity=10) {
        carriage_profile();
      }
      // % rounded_cube(y_carriage_overall_width,y_carriage_overall_height,y_carriage_depth-1,wall_thickness*4);
      rotate([0,0,90]) {
        % extrusion_2040(10);
      }
      // brace between bearings, to go with the commented-out ramp below
      translate([line_bearing_pos_x,line_bearing_pos_z]) {
        // rounded_cube(line_bearing_diam,bearing_arm_support_overall_height,20-line_bearing_cavity_diam,bearing_arm_thickness);
      }
    }

    line_bearing_cavity_diam = line_bearing_diam+gap_between_x_rail_end_and_y_carriage*2+0.5;
    xz_position_for_line_bearing() {
      // ramp make it easier to feed the line through?
      /*
      difference() {
        translate([line_bearing_diam/4+1,0,0]) {
          cube([line_bearing_diam/2,20,line_bearing_thickness_gap+bearing_bevel_height*2+1],center=true);
        }
        for(y=[front,rear]) {
          translate([0,y*10,0]) {
            hole(line_bearing_cavity_diam,line_bearing_thickness_gap*2,16);
          }
        }
      }
      */

      // line bearing bevels
      for(y=[front,rear]) {
        for(z=[top,bottom]) {
          translate([0,y*10,z*(line_bearing_thickness_gap/2+bearing_bevel_height)]) {
            hull() {
              hole(line_bearing_hole_diam+extrude_width*2,bearing_bevel_height*2);
              translate([0,0,z*1]) {
                hole(line_bearing_hole_diam+(extrude_width+bearing_bevel_height)*2,2);
              }
            }
          }
        }
      }
    }
  }

  module holes() {
    bushing_from_wall = x_rail_extrusion_height/5;

    xz_position_for_line_bearing() {
      // line bearing holes
      for(y=[front,rear]) {
        translate([0,y*10,0]) {
          hole(line_bearing_hole_diam,30);
        }
      }
    }

    // mounting holes for misc
    if (side == right) {
      for(y=[-5,5]) {
        translate([0,y,y_carriage_overall_height/2]) {
          // hole(threaded_insert_diam,printed_carriage_wall_thickness*2+1,8);
        }
      }
    }
  }

  difference() {
    body();
    holes();
  }
}

module y_carriage(side) {
  if (1) {
    preloaded_spring_y_carriage(side);
  } else {
    ptfe_y_carriage(side);
  }
}

y_carriage(right);

// to_print();
