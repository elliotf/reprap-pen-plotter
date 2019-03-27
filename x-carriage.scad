use <main.scad>;
include <config.scad>;
include <util.scad>;
include <vitamins.scad>;

x_carriage_bushing_len   = 10;
x_carriage_bushing_pos_y = x_rail_extrusion_width/2 + ptfe_bushing_diam/2 - ptfe_bushing_preload_amount;
x_carriage_bushing_pos_z = x_rail_extrusion_height/2  + ptfe_bushing_diam/2 - ptfe_bushing_preload_amount;

module x_carriage() {
  tensioner_pos_x = x_carriage_width/2-tuner_thick_diam/2-printed_carriage_wall_thickness;
  tensioner_pos_y = x_carriage_line_spacing/2;
  tensioner_pos_z = 10+line_bearing_above_extrusion+tuner_thin_diam/2;
  tensioner_shoulder_pos_z = tuner_hole_to_shoulder;

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
    translate([front*(x_carriage_opening_depth/2+printed_carriage_wall_thickness/2),0]) {
      rounded_square(printed_carriage_wall_thickness,z_carriage_carrier_height,printed_carriage_inner_diam);
    }

    translate([front*(x_carriage_opening_depth/2),0]) {
      // round out internal corners
      for(z=[top,bottom]) {
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
          rotate([9,0,0]) {
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
      }
    }

    // line holes
    for(y=[front,rear]) {
      translate([0,y*x_carriage_line_spacing/2,10+line_bearing_above_extrusion]) {
        rotate([0,90,0]) {
          # hole(line_hole_diam,x_carriage_width+4,12);
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
    for(x=[left,right]) {
      for (z=[top, bottom]) {
        translate([x*z_carriage_carrier_hole_spacing_x/2,front*(x_carriage_overall_depth/2-printed_carriage_wall_thickness),z*z_carriage_carrier_hole_spacing_z/2]) {
          rotate([90,0,0]) {
            hole(3.2,printed_carriage_wall_thickness*3,8);
            // hole(m3_nut_diam,3,6);
          }
        }
      }
    }

    // clearance for z stepper
    translate([z_stepper_pos_x,front*(x_carriage_overall_depth/2-printed_carriage_wall_thickness/2),z_stepper_dist_from_x_rail_z]) {
      rotate([90,0,0]) {
        hole(z_stepper_diam+1,printed_carriage_wall_thickness+1,6);
      }
    }
  }

  difference() {
    body();
    holes();
  }
}

x_carriage();