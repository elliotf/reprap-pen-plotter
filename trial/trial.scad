include <../config.scad>;
use <../filament-drive.scad>;
use <../lib/util.scad>;
use <../lib/vitamins.scad>;
use <../x-carriage.scad>;
use <../misc.scad>;

plate_pos_z = -20-y_rail_dist_above_plate;

body_width = y_rail_extrusion_width;

overall_depth = line_bearing_diam + wall_thickness*3;

overall_height = abs(plate_pos_z)+15;

line_bearing_screw_hole_diam = 4.9;

motor_to_idler_line_pos_x = motor_line_pos_x - y_rail_pos_x;
motor_to_idler_line_pos_z = motor_line_pos_z+(plate_pos_z);

motor_line_pos_y = 1+line_bearing_diam/2+2;

carriage_depth = 40;

return_bearing_angle = 45;
carriage_to_idler_line_pos_x = motor_to_idler_line_pos_x-(cos(return_bearing_angle)*line_bearing_diam);
carriage_to_idler_line_pos_z = motor_to_idler_line_pos_z+(sin(return_bearing_angle)*line_bearing_diam);

module trial_carriage() {
  carriage_overall_width = y_rail_extrusion_width+printed_carriage_outer_skin_from_extrusion*2;
  carriage_overall_height = y_rail_extrusion_height+printed_carriage_outer_skin_from_extrusion*2;

  tuner_rotation_around_x = -10;
  tuner_rotation_around_y = -15;
  tuner_rotation_around_z = -10;

  tuner_mount_hole_diam = tuner_thick_diam+tolerance;
  tuner_mount_body_diam = tuner_mount_hole_diam+wall_thickness*4;
  tuner_mount_body_width = tuner_thick_len+5;

  motor_to_carriage_line_pos_x = -y_rail_pos_x+x_line_pos_x;
  motor_to_carriage_line_pos_z = -y_rail_pos_z+x_line_pos_z;

  module position_tuner() {
    translate([carriage_to_idler_line_pos_x,carriage_depth/2-tuner_thick_diam/2-printed_carriage_wall_thickness,carriage_to_idler_line_pos_z+tuner_thin_diam/2]) {
      rotate([0,0,tuner_rotation_around_z]) {
        rotate([0,tuner_rotation_around_y,0]) {
          rotate([tuner_rotation_around_x,0,0]) {
            mirror([1,0,0]) {
              children();
            }
          }
        }
      }
    }
  }

  module position_tuner_shoulder() {
    position_tuner() {
      translate([-tuner_hole_to_shoulder,0,0]) {
        children();
      }
    }
  }

  module position_tuner_anchor_hole() {
    position_tuner_shoulder() {
      translate([0,-tuner_body_diam/2,-tuner_body_diam/2]) {
        children();
      }
    }
  }

  motor_line_director_angle_x = 15;
  motor_line_director_angle_z = -15;
  module position_motor_line_redirector() {
    translate([motor_to_carriage_line_pos_x,-carriage_depth/2,motor_to_carriage_line_pos_z]) {
      rotate([motor_line_director_angle_x,0,motor_line_director_angle_z]) {
        children();
      }
    }
  }

  module body() {
    rotate([90,0,0]) {
      rounded_cube(carriage_overall_width,carriage_overall_height,carriage_depth,printed_carriage_outer_diam);
    }

    // tuner holder
    hull() {
      position_tuner_shoulder() {
        translate([tuner_mount_body_width/2,0,0]) {
          rotate([0,90,0]) {
            hole(tuner_mount_body_diam,tuner_mount_body_width,resolution);

            translate([0,-tuner_mount_body_diam/2,0]) {
              // hole(tuner_anchor_screw_hole_diam+wall_thickness*6,tuner_mount_body_width,resolution);
            }
          }
          translate([2,-tuner_mount_body_diam/4-15,-tuner_mount_body_diam]) {
            cube([tuner_mount_body_width-4,tuner_mount_body_diam/2,1],center=true);
          }
        }
      }
      position_tuner_anchor_hole() {
        rotate([0,90,0]) {
          translate([0,0,tuner_mount_body_width/2]) {
            hole(tuner_anchor_screw_hole_diam+wall_thickness*6,tuner_mount_body_width,resolution);
          }
        }
      }
      translate([carriage_overall_width/2-printed_carriage_outer_diam/2,carriage_depth/2-1,carriage_overall_height/2-printed_carriage_outer_diam/2]) {
        rotate([90,0,0]) {
          hole(printed_carriage_outer_diam,2,resolution);
        }
        translate([-6,0,printed_carriage_outer_diam/2-1]) {
          cube([6,2,2],center=true);
        }
      }
      translate([5,-carriage_depth/2+1,carriage_overall_height/2-1]) {
        cube([10,2,2],center=true);
      }
    }

    hull() {
      motor_line_redirector_thickness = 8;
      translate([-y_carriage_opening_depth/2,-carriage_depth/2-0.5,y_carriage_opening_height/2]) {
        rotate([0,0,0]) {
          cube([printed_carriage_wall_thickness*2, 1, printed_carriage_wall_thickness*2],center=true);
        }
      }
      position_motor_line_redirector() {
        translate([0,motor_line_redirector_thickness/2,0]) {
          rotate([90,0,0]) {
            hole(10,motor_line_redirector_thickness*2,resolution);
          }
          translate([0,motor_line_redirector_thickness+1,0]) {
            rotate([-motor_line_director_angle_x,0,-motor_line_director_angle_z]) {
              rotate([90,0,0]) {
                hole(10,2,resolution);
              }
            }
          }
        }
      }
    }

    position_tuner() {
      % tuner();
    }

    translate([carriage_to_idler_line_pos_x,0,carriage_to_idler_line_pos_z]) {
      % color("red") cube([1,50,1],center=true);
    }
  }

  module holes() {
    rotate([90,0,0]) {
      rounded_cube(y_carriage_opening_depth,y_carriage_opening_height,carriage_depth+1,printed_carriage_inner_diam);
    }
    for(y=[front,rear]) {
      translate([0,y*(carriage_depth/2-printed_carriage_bushing_from_end-printed_carriage_bushing_len/2),0]) {
        rotate([90,0,0]) {
          rotate([0,0,90]) {
            linear_extrude(height=printed_carriage_bushing_len,center=true) {
              ptfe_bushing_profile_for_2040_extrusion();
            }
          }
        }
      }
    }
    position_tuner_anchor_hole() {
      rotate([0,90,0]) {
        rotate([0,0,-tuner_rotation_around_x+2.5]) {
          hole(m2_threaded_insert_diam,20,8);
        }
      }
    }
    position_tuner_shoulder() {
      translate([0,0,0]) {
        rotate([0,90,0]) {
          rotate([0,0,-tuner_rotation_around_x+2.5]) {
            hole(tuner_mount_hole_diam,tuner_thick_len*2+1,8);
            hole(tuner_thin_diam+0.5,tuner_mount_body_width*4+1,8);
          }
        }
      }
    }

    position_motor_line_redirector() {
      rotate([90,0,0]) {
        hole(1.5,carriage_depth+1,8);
        // color("red") cube([1,50,1.1],center=true);
      }
    }

    translate([0,-carriage_depth,0]) {
      cube([carriage_overall_width*2,carriage_depth,carriage_overall_height*2],center=true);
    }

    /*
    position_tuner() {
      rotate([0,0,0]) {
        translate([0,0,0]) }
        }
      }
    }
    */
  }

  difference() {
    body();
    holes();
  }
}

module rear_idler_mount(side=right) {
  bearing_bolt_support_length = 20;

  module position_motor_bearing() {
    translate([motor_to_idler_line_pos_x,motor_line_pos_y,motor_to_idler_line_pos_z]) {
      rotate([0,return_bearing_angle,0]) {
        translate([-line_bearing_diam/2,0,0]) {
          children();
        }
      }
    }
  }

  module bearing_bevel(angle) {
    small_diam = line_bearing_screw_hole_diam+wall_thickness;
    large_diam = line_bearing_screw_hole_diam+wall_thickness*4;

    rotate([0,0,angle]) {
      translate([0,0,-line_bearing_thickness/2-bearing_bevel_height*1.5]) {
        difference() {
          hull() {
            hole(small_diam,bearing_bevel_height*3,resolution);
            hole(large_diam,bearing_bevel_height,resolution);
          }
          hole(line_bearing_screw_hole_diam,200,8);
        }
      }
    }
  }

  module body() {
    translate([0,overall_depth/2,plate_pos_z+overall_height/2]) {
      rounded_cube(body_width,overall_depth,overall_height,printed_carriage_inner_diam,resolution);
    }

    hull() {
      merge_main_body_height = 30;
      translate([-body_width/2+body_width/8,overall_depth/2,plate_pos_z+overall_height-merge_main_body_height/2]) {
        rounded_cube(body_width/4,overall_depth,merge_main_body_height,printed_carriage_inner_diam,resolution);
      }
      position_motor_bearing() {
        translate([0,0,-line_bearing_thickness/2-bearing_bevel_height-bearing_bolt_support_length/2]) {
          hole(m5_tight_hole+wall_thickness*4,bearing_bolt_support_length,resolution);
        }
      }
    }
  }

  module holes() {
    // trim excess off bottom
    translate([0,0,plate_pos_z-50]) {
      cube([100,100,100],center=true);
    }

    position_motor_bearing() {
      hole(line_bearing_diam+1,line_bearing_thickness+bearing_bevel_height*2,resolution);
      hole(m5_tight_hole,bearing_bolt_support_length*3+1,8);
      translate([0,0,-line_bearing_thickness/2-bearing_bevel_height-bearing_bolt_support_length-20]) {
        rotate([0,-return_bearing_angle,0]) {
          rotate([90,0,0]) {
            hole(40,40,8);
          }
        }
      }
    }

    // mount y rail
    for(z=[top,bottom]) {
      translate([0,0,z*10]) {
        rotate([90,0,0]) {
          hole(m5_tight_hole,100,8);
        }
      }
    }

    // passthrough for endstop wiring
    if (side == right) {
      //wire_passthrough_diam = 10;
      wire_passthrough_diam = 10+m5_tight_hole/2-wall_thickness*2;
      translate([side*(wire_passthrough_diam/2-m5_tight_hole/2),0,0]) {
        rotate([90,0,0]) {
          hole(wire_passthrough_diam,overall_depth*2+1,8);
        }
      }

      translate([10+mech_endstop_tiny_width/2,-1,-y_rail_extrusion_height/2+mech_endstop_tiny_length/2]) {
        rotate([90,0,0]) {
          rotate([0,0,180]) {
            % mech_endstop_tiny();
            position_mech_endstop_tiny_mount_holes() {
              hole(m2_threaded_insert_diam,mech_endstop_tiny_width+5*2);
            }
          }
        }
      }
    }
  }

  module bridges() {
    position_motor_bearing() {
      % line_bearing();
      bearing_bevel(0);
    }
  }

  difference() {
    body();
    holes();
  }

  bridges();
}

translate([-y_rail_pos_x,0,0]) {
  for(x=[right]) {
    translate([x*y_rail_pos_x,0,y_rail_pos_z]) {

      translate([0,0,0]) {
        trial_carriage();
      }

      rotate([0,90,0]) {
        rotate([90,0,0]) {
          % color("silver") extrusion_2040(y_rail_len);
        }
      }

      translate([0,y_rail_len/2,0]) {
        //% color("lightblue")
        rear_idler_mount(x);
      }
    }

    mirror([-1+x,0,0]) {
      translate([motor_pos_x,-y_rail_len/2-0.05,0]) {
        // % color("orange")
        motor_mount(x);
      }
    }

  }
}
