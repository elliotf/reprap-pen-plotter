include <config.scad>;
include <lib/util.scad>;
include <lib/vitamins.scad>;

x_carriage_bushing_len   = 10;
x_carriage_bushing_pos_y = x_rail_extrusion_width/2 + ptfe_bushing_diam/2 - ptfe_bushing_preload_amount;
x_carriage_bushing_pos_z = x_rail_extrusion_height/2  + ptfe_bushing_diam/2 - ptfe_bushing_preload_amount;

module x_carriage() {
  tensioner_pos_x = x_carriage_width/2-tuner_thick_diam/2-printed_carriage_wall_thickness;
  tensioner_pos_y = x_carriage_line_spacing/2;
  tensioner_pos_z = 10+line_bearing_above_extrusion+tuner_thin_diam/2;
  tensioner_angle_around_x = 9;

  for(y=[front,rear]) {
    translate([0,y*x_carriage_line_spacing/2,10+line_bearing_above_extrusion]) {
      % cube([x_carriage_width+30,0.6,0.6],center=true);
    }
  }

  translate([0,0,50]) {
    // color("lightblue") carriage_profile();
  }
  module carriage_profile_body() {
    rounded_square(x_carriage_overall_depth,x_carriage_overall_height,printed_carriage_outer_diam);

    // z axis mounting plate
    translate([front*(x_carriage_opening_depth/2+printed_carriage_wall_thickness/2),-z_carriage_carrier_height/4]) {
      rounded_square(printed_carriage_wall_thickness,z_carriage_carrier_height/2,printed_carriage_inner_diam);
    }

    translate([front*(x_carriage_opening_depth/2),0]) {
      // round out internal corners
      for(z=[bottom]) {
        mirror([0,1-z]) {
          translate([0,x_carriage_overall_height/2]) {
            round_corner_filler_profile(printed_carriage_inner_diam);
          }
        }
      }
    }
  }

  module carriage_profile_holes() {
    rounded_square(x_carriage_opening_depth,x_carriage_opening_height,printed_carriage_inner_diam);

  }

  for(x=[right]) {
    position_for_tensioner(x) {
      mirror([0,0,0]) {
        %tuner();
      }
    }
  }

  module position_for_tensioner_shoulder(side) {
    position_for_tensioner(side) {
      rotate([0,-90,0]) {
        translate([0,0,tuner_hole_to_shoulder]) {
          children();
        }
      }
    }
  }

  module position_for_tensioner(side) {
    mirror([1-side,0,0]) {
      translate([tensioner_pos_x,tensioner_pos_y,tensioner_pos_z]) {
        rotate([0,0,0]) {
          rotate([tensioner_angle_around_x,0,0]) {
            mirror([0,0,0]) {
              rotate([0,10,0]) {
                rotate([0,0,-90]) {
                  children();
                }
              }
            }
          }
        }
      }
    }
  }

  rotate([0,90,0]) {
    rotate([0,0,90]) {
      % extrusion_2040(x_carriage_width+30);
    }
  }

  line_hole_diam = 1.5;

  module body() {
    rotate([90,0,0]) {
      rotate([0,90,0]) {
        linear_extrude(height=x_carriage_width,center=true,convexity=3) {
          carriage_profile_body();
        }
      }
    }

    // line guidance hole body
    line_body_depth = x_carriage_line_spacing+line_hole_diam+printed_carriage_wall_thickness;
    line_body_height = line_hole_diam+printed_carriage_wall_thickness;
    difference() {
      union() {
        translate([0,0,10+line_bearing_above_extrusion]) {
          rotate([0,-90,0]) {
            linear_extrude(height=x_carriage_width,center=true,convexity=3) {
              rounded_square(line_body_height,line_body_depth,printed_carriage_inner_diam);
              translate([-line_bearing_above_extrusion-10+x_carriage_overall_height/2,-line_body_depth/2]) {
                rotate([0,0,-90]) {
                  round_corner_filler_profile(printed_carriage_inner_diam);
                }
              }
            }
          }
        }
      }
      translate([0,0,10+line_bearing_above_extrusion]) {
        hull() {
          translate([0,0,line_body_height/2+0.5]) {
            cube([x_carriage_width-8,line_body_depth*2,1],center=true);

            translate([0,0,-line_body_height]) {
              cube([x_carriage_width-8-line_body_height*2,line_body_depth*2,1],center=true);
            }
          }
        }
      }
    }

    // tuner/tensioner body
    tuner_achor_depth = 10;
    hull() {
      translate([0,x_carriage_overall_depth/2-printed_carriage_outer_diam/2,x_carriage_overall_height/2-printed_carriage_outer_diam/2]) {
        rotate([0,90,0]) {
          hole(printed_carriage_outer_diam,x_carriage_width,resolution);
        }
      }

      for(x=[left,right]) {
        position_for_tensioner_shoulder(x) {
          translate([0,0,-tuner_thick_len]) {
            rotate([0,0,0]) {
              rotate([0,0,-10]) {
                rotate([90,0,0]) {
                  rounded_cube(tuner_thick_diam+printed_carriage_wall_thickness,tuner_thick_len*2,2*(x_carriage_width/2-tensioner_pos_x),printed_carriage_inner_diam);
                }
              }
            }
          }
        }
      }
    }
  }

  module holes() {
    rotate([90,0,0]) {
      rotate([0,90,0]) {
        linear_extrude(height=x_carriage_width+1,center=true,convexity=3) {
          carriage_profile_holes();
        }
      }
    }

    // tuner/tensioner cavities
    for(x=[left,right]) {
      position_for_tensioner_shoulder(x) {
        rotate([0,0,-10]) {
          hole(tuner_thick_diam+0.5,tuner_thick_len*2,8);
          hole(tuner_thin_diam+0.5,tuner_hole_to_shoulder*2,8);
        }

        translate([-tuner_body_diam/2,-tuner_body_diam/2,0]) {
          hole(tuner_anchor_screw_hole_diam-0.5,10,8);
        }

        // anchor holes for misc
        translate([0,-tensioner_pos_x,-tuner_thick_len+x*(5)]) { // Z, X from PoV of right side, Y-ish
          rotate([0,90,-10]) {
            hole(threaded_insert_diam,20,8);
          }
        }
      }
    }

    // line holes
    for(y=[front,rear]) {
      translate([0,y*x_carriage_line_spacing/2,10+line_bearing_above_extrusion]) {
        rotate([0,90,0]) {
          hole(line_hole_diam,x_carriage_width+4,12);
        }
      }
    }

    bushing_from_wall = x_rail_extrusion_height/5;

    // PTFE bushings
    for(x=[left,right]) {
      translate([x*(x_carriage_width/2-printed_carriage_bushing_from_end-printed_carriage_bushing_len/2),0]) {
        rotate([0,90,0]) {
          rotate([0,0,90]) {
            linear_extrude(height=printed_carriage_bushing_len,center=true) {
              ptfe_bushing_profile_for_2040_extrusion();
            }
          }
        }
      }
    }

    // z carriage carrier mounting holes
    for(x=[left,0,right]) {
      for (z=[top,0,bottom]) {
        if (z != top || x != 0) {
          translate([x*z_carriage_carrier_hole_spacing_x/2,front*(x_carriage_overall_depth/2-printed_carriage_wall_thickness/2),z*z_carriage_carrier_hole_spacing_z/2]) {
            rotate([90,0,0]) {
              hole(threaded_insert_diam,printed_carriage_wall_thickness+1,8);
            }
          }
        }
      }
    }

    // clearance for z stepper
    hull() {
      wide_width = z_carriage_carrier_hole_spacing_x-threaded_insert_diam;
      narrow_width = wide_width-(z_carriage_carrier_height-x_carriage_overall_height)-2;
      translate([0,front*(x_carriage_overall_depth/2-printed_carriage_wall_thickness/2),1]) {
        translate([0,0,z_carriage_carrier_height/2]) {
          cube([wide_width,printed_carriage_wall_thickness+5,2],center=true);
        }
        translate([0,0,x_carriage_overall_height/2]) {
          cube([narrow_width,printed_carriage_wall_thickness+5,2],center=true);
        }
      }
    }

    // mounting holes for x limit switches
    for(x=[left,right]) {
      translate([x*(x_carriage_width/2+1),rear*(10-mech_endstop_tiny_length*0.25),-x_carriage_overall_height/2-mech_endstop_tiny_width/2]) {
        rotate([0,x*-90,180]) {
          % mech_endstop_tiny();
          position_mech_endstop_tiny_mount_holes() {
            hole(m2_threaded_insert_diam,mech_endstop_tiny_width+2*(printed_carriage_wall_thickness-wall_thickness*2),8);
          }
        }
      }
    }

    // cat5/cat6 for x carriage?
    /*
     2+ pair for stepper

     1 5v DC
     Z limit signal
     X limit signal
     Ground

     */

    // mounting holes for z limit switch
    translate([z_limit_switch_pos_x,-x_carriage_overall_depth/2+printed_carriage_wall_thickness+mech_endstop_tiny_width/2,-z_carriage_carrier_height/2]) {
      rotate([0,180,90]) {
        % mech_endstop_tiny();
        position_mech_endstop_tiny_mount_holes() {
          hole(m2_threaded_insert_diam,mech_endstop_tiny_width+2*(printed_carriage_wall_thickness-wall_thickness*2),8);
        }
      }
    }

    // zip tie hole for limit switch wire tidying
    translate([0,x_carriage_overall_depth/2,0]) {
      zip_tie_cavity(printed_carriage_wall_thickness/2,zip_tie_thickness,zip_tie_width);
    }
    translate([0,10,-x_carriage_overall_height/2]) {
      rotate([-90,0,0]) {
        zip_tie_cavity(printed_carriage_wall_thickness/2,zip_tie_thickness,zip_tie_width);
      }
    }
  }

  difference() {
    body();
    holes();
  }
}

module to_print() {
  rotate([0,-90,0]) {
    x_carriage();
  }
}

to_print();
