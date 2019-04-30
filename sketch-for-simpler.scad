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

// base_plate_for_display();


sketch_x_rail_pos_z = 10;
sketch_space_between_rails = 2;
sketch_y_rail_pos_z = sketch_x_rail_pos_z + 20 + sketch_space_between_rails;
sketch_xy_rail_dist_z = sketch_y_rail_pos_z - sketch_x_rail_pos_z;

wheel_axle_diam = 5;

y_pulley_tooth_count = 16;
y_pulley_tooth_pitch = 2;
y_pulley_diam = y_pulley_tooth_pitch*y_pulley_tooth_count/pi;

belt_width = 6;
belt_pos_x = 0;

y_relative_y_motor_pos_x = right*(belt_width/2+4+nema14_shoulder_height);
y_relative_y_motor_pos_y = front*(nema14_side/2+tolerance);
y_relative_y_motor_pos_z = 10+nema14_side/2;

y_belt_idler_od = mr105_bearing_od;
y_belt_idler_id = mr105_bearing_id;
y_belt_idler_thickness = mr105_bearing_thickness*2;
y_relative_y_belt_idler_pos_z = 10 + y_belt_idler_od/2 + printed_carriage_outer_skin_from_extrusion + 2;

x_belt_idler_od = mr105_bearing_od;
x_belt_idler_id = mr105_bearing_id;
x_belt_idler_thickness = mr105_bearing_thickness*2;

belt_thickness = 0.95;

motor_side_belt_pos_z = y_relative_y_motor_pos_z-y_pulley_diam/2-belt_thickness/2;
idler_side_belt_pos_z = y_relative_y_belt_idler_pos_z-y_belt_idler_od/2-belt_thickness/2;

y_motor_endcap_thickness = mini_v_wheel_extrusion_spacing*2;
bevel_height = 1;
x_belt_idler_body_diam = m5_thread_into_plastic_hole_diam+wall_thickness*4;
x_belt_idler_bevel_pos_z = -10 - bevel_height;
x_belt_idler_spacing = nema17_side + m5_bolt_head_diam;
x_belt_idler_pos_y = y_motor_endcap_thickness-wall_thickness*2-wheel_axle_diam/2;
x_motor_mount_thickness = (20 - m5_bolt_head_diam-tolerance) / 2;
x_motor_pos_z = x_belt_idler_bevel_pos_z + bevel_height + x_motor_mount_thickness;
x_motor_pos_y = y_motor_endcap_thickness+nema17_side/2+0.2;

module belt_teeth(leng,side=bottom) {
  tooth_diam  = 1.4;
  tooth_pitch = 2;
  num_teeth = floor(leng / tooth_pitch);

  // belt teeth
  translate([0,belt_width/2,0]) {
    cube([tooth_pitch*(2*num_teeth+1),belt_width*2,belt_thickness],center=true);
    for(x=[left,right]) {
      for(i=[0:num_teeth]) {
        translate([2*i*x,0,-side*belt_thickness/2]) {
          rotate([90,0,0]) {
            rotate([0,0,90]) {
              hole(tooth_diam,belt_width*2,6);
            }
          }
        }
      }
    }
  }
}

module y_belt_idler() {
  difference() {
    union() {
      hole(y_belt_idler_od,y_belt_idler_thickness,resolution);
      for(z=[top,bottom]) {
        translate([0,0,z*(y_belt_idler_thickness/2-0.5)]) {
          hole(y_belt_idler_od+2,1,resolution);
        }
      }
    }
    hole(y_belt_idler_id,y_belt_idler_thickness+1,resolution);
  }
}

module wheel_shaft_holder() {
  hull() {
    translate([0,0,-1]) {
      hole(mini_v_wheel_extrusion_spacing*2,18,resolution*1.5);
    }
    translate([0,0,-sketch_xy_rail_dist_z+1+mini_v_wheel_thickness/2]) {
      hole(wheel_axle_diam+extrude_width*4,2,resolution*1.5);

      translate([0,0,-mini_v_wheel_thickness/2-1]) {
        % color("dimgrey") mini_v_wheel();
      }
    }
  }
}

module x_endcap(side) {
  belt_pos_y = 20+x_belt_idler_pos_y-x_belt_idler_od/2-belt_thickness/2;
  belt_additional_width = 12;

  thickness = 10;
  width = 40 + belt_additional_width;
  height = 20;

  module body() {
    translate([thickness/2,0,0]) {
      rotate([0,-90,0]) {
        rounded_cube(height,40,thickness,5,resolution);
      }
      translate([thickness/2,10+m5_bolt_head_diam/2+belt_additional_width/2,0]) {
        rotate([0,-90,0]) {
          rounded_cube(height,belt_additional_width,thickness*2,5,resolution);
        }
      }

      endstop_trigger_width = 10;
      translate([0,-10,10]) {
        rotate([0,90,0]) {
          rounded_cube(20,endstop_trigger_width,thickness,3,resolution);

          for(y=[front,rear]) {
            translate([0,y*endstop_trigger_width/2,0]) {
              rotate([0,0,135-y*45]) {
                round_corner_filler(3,thickness);
              }
            }
          }
        }
      }
    }
  }

  module holes() {
    for(y=[front,rear]) {
      translate([0,y*10,0]) {
        rotate([0,90,0]) {
          hole(5,50,8);
        }
      }
    }

    translate([0,belt_pos_y,height/2-belt_width]) {
      rotate([90,0,0]) {
        belt_teeth(30);
      }
    }
  }

  mirror([1-side,0,0]) {
    difference() {
      body();
      holes();
    }
  }
}

module belt_idler_bearings() {
  difference() {
    union() {
      hole(x_belt_idler_od,x_belt_idler_thickness,resolution);
      for(z=[top,bottom]) {
        translate([0,0,z*(x_belt_idler_thickness/2-0.5)]) {
          hole(x_belt_idler_od+2,1,resolution);
        }
      }
    }
    hole(x_belt_idler_id,x_belt_idler_thickness+1,resolution);
  }
}

module y_motor_extrusion_anchor() {
  bolt_pos_x = 10-y_relative_y_motor_pos_x;
  bolt_pos_y = -nema14_side/2-wall_thickness*2-m5_bolt_head_diam/2-tolerance;
  bolt_body_diam = 5+tolerance+wall_thickness*4;

  min_pos_x = -wall_thickness*4;
  max_pos_x = bolt_pos_x+bolt_body_diam;
  min_pos_y = bolt_pos_y-bolt_body_diam/2;
  max_pos_y = -nema14_hole_spacing/2+3/2+tolerance+wall_thickness*2;

  bolt_head_hole_diam = m5_bolt_head_diam+tolerance*2;

  width = max_pos_x-min_pos_x;
  depth = max_pos_y-min_pos_y;
  height = nema14_side+1;

  module body() {
    translate([min_pos_x+width/2,min_pos_y+depth/2,-nema14_side/2+height/2]) {
      rotate([0,90,0]) {
        rounded_cube(height,depth,width,5,resolution);
      }
    }
  }

  module holes() {
    translate([bolt_pos_x,bolt_pos_y,0]) {
      # hole(5+tolerance,nema14_side*2,8);

      translate([0,0,-nema14_side/2+mini_v_wheel_extrusion_spacing*2]) {
        translate([0,0,20]) {
          cube([40,bolt_head_hole_diam,40],center=true);
        }
      }
    }

    translate([nema14_len/2,0,0]) {
      cube([nema14_len,nema14_side,nema14_side+10],center=true);
    }

    rotate([0,90,0]) {
      hole(nema14_shoulder_diam+1.5,30,resolution);
    }

    for(z=[top,bottom]) {
      translate([0,-nema14_hole_spacing/2,z*nema14_hole_spacing/2]) {
        rotate([0,90,0]) {
          hole(m3_diam+tolerance,30,resolution);
        }
      }
    }
  }

  difference() {
    body();
    holes();
  }
}

module y_endcap_with_motor() {
  nema17_motor_mount_opening = nema17_len + tolerance*2;
  height = nema17_motor_mount_opening + x_motor_mount_thickness*2;

  m3_hole_diam = m3_diam + tolerance;
  m3_hole_body_diam = m3_hole_diam + wall_thickness*4;

  translate([y_relative_y_motor_pos_x,y_relative_y_motor_pos_y,y_relative_y_motor_pos_z]) {
    % rotate([0,-90,0]) {
      translate([0,0,nema14_shoulder_height+y_relative_y_motor_pos_x-2]) {
        hole(y_pulley_diam,6,resolution);
      }
      motor_nema14();
    }


    % color("green") y_motor_extrusion_anchor();

    /*
    translate([-y_relative_y_motor_pos_x,-nema14_hole_spacing/2,-nema14_side/2]) {
      % color("green") y_motor_extrusion_anchor();
    }
    */
  }

  module body() {
    hull() {
      for(x=[left,right]) {
        // belt idlers
        translate([x*x_belt_idler_spacing/2,x_belt_idler_pos_y,-10+height/2]) {
          hole(x_belt_idler_body_diam,height,resolution*1.5);
        }
      }

      translate([0,y_motor_endcap_thickness/2,-10+height/2]) {
        rounded_cube(40+y_motor_endcap_thickness,y_motor_endcap_thickness,height,y_motor_endcap_thickness,resolution);
      }
    }

    for(x=[left,right]) {
      // restriction/support for shaft-side Y motor mounting holes
      translate([x*(nema17_side/2+wall_thickness+tolerance),0,0]) {
        hull() {
          translate([0,x_motor_pos_y-nema17_hole_spacing/2-3,-10+x_motor_mount_thickness/2]) {
            rounded_cube(wall_thickness*2,m3_hole_body_diam+6,x_motor_mount_thickness,wall_thickness*2,resolution);
          }

          translate([0,y_motor_endcap_thickness-wall_thickness,20]) {
            hole(wall_thickness*2,1,resolution);
          }
        }
      }
    }

    translate([0,mini_v_wheel_extrusion_spacing,0]) {
      wheel_shaft_holder();
    }


    translate([0,x_motor_pos_y,x_motor_pos_z]) {
      rotate([0,180,0]) {
        % motor_nema17();
      }
    }

    // X shaft-side motor mounting holes
    translate([0,0,x_motor_pos_z-x_motor_mount_thickness/2]) {
      hull() {
        width = nema17_side+wall_thickness*2+tolerance*2;
        translate([0,x_motor_pos_y-nema17_hole_spacing/2,0]) {
          cube([width,m3_hole_body_diam,x_motor_mount_thickness],center=true);
        }
        translate([0,y_motor_endcap_thickness/2,0]) {
          cube([width,1,x_motor_mount_thickness],center=true);
        }
      }
    }

    // X non-shaft-side y motor mounting holes
    translate([0,0,-10+height-x_motor_mount_thickness/2]) {
      hull() {
        translate([0,x_motor_pos_y-nema17_hole_spacing/2,0]) {
          rounded_cube(nema17_side,m3_hole_body_diam,x_motor_mount_thickness,m3_hole_body_diam,resolution);
        }
        translate([0,y_motor_endcap_thickness/2,0]) {
          cube([nema17_side,1,x_motor_mount_thickness],center=true);
        }
      }
    }

    // Y motor mount
    y_mount_height = height-20;
    y_mount_thickness = wall_thickness*4;
    translate([y_relative_y_motor_pos_x-y_mount_thickness/2,y_relative_y_motor_pos_y+nema14_side/2,-10+height-y_mount_height/2]) {
      rounded_cube(y_mount_thickness,2*(nema14_side-nema14_hole_spacing),y_mount_height,y_mount_thickness,resolution);
    }

    // belt idler bevels
    for(x=[left,right]) {
      translate([x*x_belt_idler_spacing/2,x_belt_idler_pos_y,x_belt_idler_bevel_pos_z]) {
        hull() {
          translate([0,0,bevel_height+1]) {
            hole(x_belt_idler_body_diam,2,resolution*1.5);
          }
          translate([0,0,bevel_height]) {
            hole(m5_thread_into_plastic_hole_diam+extrude_width*4,bevel_height*2,resolution*1.5);
          }
        }
        translate([0,0,-x_belt_idler_thickness/2-0.05]) {
          % color("silver") belt_idler_bearings();
        }
      }
    }
  }

  module holes() {
    // wheel axle
    translate([0,mini_v_wheel_extrusion_spacing,-10]) {
      hole(m5_thread_into_plastic_hole_diam,90,resolution);
    }
    // belt idlers
    for(x=[left,right]) {
      translate([x*x_belt_idler_spacing/2,x_belt_idler_pos_y,-10]) {
        hole(m5_thread_into_plastic_hole_diam,90,resolution*1.5);
      }
    }
    for(x=[left,right]) {
      // mount to extrusion
      translate([x*10,y_motor_endcap_thickness,0]) {
        rotate([90,0,0]) {
          hole(5,50,8);
          rotate([0,0,90]) {
            hole(m5_bolt_head_diam+tolerance,m5_bolt_head_height*2,8);
          }
        }
      }
    }
    // mount X motor
    for(x=[left,right]) {
      translate([x*nema17_hole_spacing/2,x_motor_pos_y-nema17_hole_spacing/2,-10+height]) {
        hole(m3_hole_diam,height,resolution);
      }

      translate([x*nema17_hole_spacing/2,x_motor_pos_y-nema17_hole_spacing/2,-10+x_motor_mount_thickness/2-0.2]) {
        hole(m3_hole_diam,x_motor_mount_thickness,resolution);
      }
    }

    // mount Y motor
    translate([y_relative_y_motor_pos_x,y_relative_y_motor_pos_y,y_relative_y_motor_pos_z]) {
      rotate([0,90,0]) {
        hole(nema14_shoulder_diam+2,20,16);
      }

      for(z=[top,bottom]) {
        translate([0,nema14_hole_spacing/2,z*nema14_hole_spacing/2]) {
          rotate([0,90,0]) {
            hole(m3_diam+tolerance,20,16);
          }
        }
      }
    }
  }

  difference() {
    body();
    holes();
  }
}

// y belt
% color("red", 0.5) {
  translate([0,0,sketch_y_rail_pos_z]) {
    // motor to idler
    hull() {
      translate([0,y_rail_len/2+y_relative_y_motor_pos_y,motor_side_belt_pos_z+y_pulley_diam+belt_thickness]) {
        cube([belt_width,1,belt_thickness],center=true);
      }
      translate([0,-y_rail_len/2-y_belt_idler_od,idler_side_belt_pos_z+y_belt_idler_od+belt_thickness]) {
        cube([belt_width,1,belt_thickness],center=true);
      }
    }

    // idler to carriage
    hull() {
      translate([0,0,idler_side_belt_pos_z]) {
        translate([0,-y_rail_len/2-y_belt_idler_od,0]) {
          cube([belt_width,1,belt_thickness],center=true);
        }
        translate([0,-x_carriage_width+30,0]) {
          cube([belt_width,1,belt_thickness],center=true);
        }
      }
    }

    // motor to carriage
    hull() {
      translate([0,0,motor_side_belt_pos_z]) {
        translate([0,y_rail_len/2+y_relative_y_motor_pos_y,0]) {
          cube([belt_width,1,belt_thickness],center=true);
        }
        translate([0,-20,0]) {
          cube([belt_width,1,belt_thickness],center=true);
        }
      }
    }
  }
}

module y_endcap_with_idler() {
  foot_bearing_od = 625_bearing_od;
  foot_bearing_id = 625_bearing_id;
  foot_bearing_thickness = 625_bearing_thickness;
  foot_bearing_pos_x = 10;
  foot_bearing_pos_z = -sketch_y_rail_pos_z+foot_bearing_od/2;

  bevel_height = 1;

  plate_thickness = 20;
  idler_arm_thickness = wall_thickness*4;
  idler_bearing_opening = y_belt_idler_thickness+tolerance*2;

  module body() {
    // main body
    hull() {
      translate([0,-plate_thickness/2,0]) {
        rotate([90,0,0]) {
          rounded_cube(40,20,plate_thickness,20,resolution);
        }

        translate([foot_bearing_pos_x,0,foot_bearing_pos_z]) {
          rotate([90,0,0]) {
            hole(m5_thread_into_plastic_hole_diam+wall_thickness*4,plate_thickness,resolution);
          }
        }
      }
    }

    // belt idler support main body
    translate([0,-plate_thickness/2,0]) {
      difference() {
        hull() {
          cube([idler_bearing_opening+bevel_height*2+wall_thickness*4,plate_thickness,1],center=true);

          translate([0,0,y_relative_y_belt_idler_pos_z-y_belt_idler_id]) {
            cube([idler_bearing_opening+bevel_height*2+wall_thickness*4,plate_thickness,1],center=true);
          }
        }
        translate([0,0,y_relative_y_belt_idler_pos_z]) {
          rotate([0,90,0]) {
            hole(y_belt_idler_od+8,idler_bearing_opening*2,resolution);
          }
          translate([0,plate_thickness/2,0]) {
            cube([idler_bearing_opening*2,plate_thickness,y_belt_idler_od+8],center=true);
          }
        }
      }
    }

    // belt idler support arms
    for(x=[left,right]) {
      translate([x*(idler_bearing_opening/2+bevel_height+idler_arm_thickness/2),-plate_thickness/2,0]) {
        hull() {
          cube([idler_arm_thickness,plate_thickness,1],center=true);

          translate([0,0,y_relative_y_belt_idler_pos_z+idler_arm_thickness/2]) {
            rotate([90,0,0]) {
              rounded_cube(idler_arm_thickness,y_belt_idler_id+wall_thickness*4,plate_thickness,idler_arm_thickness,resolution);
            }
          }
        }

        translate([-x*(idler_arm_thickness/2),0,y_relative_y_belt_idler_pos_z]) {
          hull() {
            rotate([0,x*90,0]) {
              hole(m5_thread_into_plastic_hole_diam+extrude_width*4,bevel_height*2,8);
              translate([0,0,1]) {
                hole(m5_thread_into_plastic_hole_diam+wall_thickness*4,2,8);
              }
            }
          }
        }
      }
    }

    // limit switch trigger
    hull() {
      translate([20,-plate_thickness/2,0]) {
        rotate([-90,0,0]) {
          translate([0,0,plate_thickness/2-2]) {
            rounded_cube(36,10,4,10,resolution);
          }
          translate([-5,0,-plate_thickness/2+0.1]) {
            hole(10,0.2,resolution);
          }
        }
      }
    }

    // foot bearing bevel
    translate([foot_bearing_pos_x,-plate_thickness,foot_bearing_pos_z]) {
      rotate([-90,0,0]) {
        hull() {
          hole(m5_thread_into_plastic_hole_diam+extrude_width*4,bevel_height*2,resolution);
          translate([0,0,1]) {
            hole(m5_thread_into_plastic_hole_diam+wall_thickness*4,2,resolution);
          }
        }
      }
    }
  }

  module holes() {
    // mount to extrusion
    for(x=[left,right]) {
      translate([x*10,0,0]) {
        rotate([90,0,0]) {
          hole(5,plate_thickness*2+1,8);
        }
      }
    }

    // belt idler
    translate([0,-plate_thickness/2,y_relative_y_belt_idler_pos_z]) {
      rotate([0,90,0]) {
        hole(5,40,8);

        % color("silver") y_belt_idler();
      }
    }

    // wheel foot
    translate([foot_bearing_pos_x,-plate_thickness-bevel_height-foot_bearing_thickness/2,foot_bearing_pos_z]) {
      rotate([90,0,0]) {
        hole(m5_thread_into_plastic_hole_diam,plate_thickness*3,16);
        % color("silver") difference() {
          hole(foot_bearing_od,foot_bearing_thickness,resolution);
          hole(foot_bearing_id,foot_bearing_thickness+1,resolution);
        }
      }
    }
  }

  difference() {
    body();
    holes();
  }
}

module pen_carriage() {
  tensioner_pos_x = x_carriage_width/2-tuner_thick_diam/2-printed_carriage_wall_thickness;
  tensioner_pos_y = x_carriage_line_spacing/2;
  tensioner_pos_z = 10+line_bearing_above_extrusion+tuner_thin_diam/2;
  tensioner_angle_around_x = 9;

  carriage_wall_thickness = extrude_width*8;
  cavity_width = x_carriage_overall_depth-carriage_wall_thickness*2;
  cavity_height = x_carriage_overall_height-carriage_wall_thickness*2;

  extra_meat_for_endstop = 4;
  mech_endstop_pos_z = -x_carriage_overall_height/2-extra_meat_for_endstop;
  mech_endstop_pos_y = rear*(10-mech_endstop_tiny_length*0.25);

  module spring_cavity_profile() {
    gap_width = cavity_height - x_rail_extrusion_height;

    rounded_square(cavity_width+0.1,cavity_height+0.1,gap_width);
  }

  module carriage_profile_body() {
    rotate([0,0,90]) {
      // rotated because it was originally designed for y carriage, which is rotated 90deg
      printed_extrusion_carriage_profile(x_carriage_overall_height,x_carriage_overall_depth);
    }

    // z axis mounting plate
    difference() {
      translate([front*(x_carriage_opening_depth/2+printed_carriage_wall_thickness/2),0]) {
        rounded_square(printed_carriage_wall_thickness,z_carriage_carrier_height,printed_carriage_inner_diam);

        translate([printed_carriage_wall_thickness/2,0,0]) {
          square([printed_carriage_wall_thickness,x_carriage_overall_height],center=true);
        }
      }

      spring_cavity_profile();
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

  line_hole_diam = 2;

  belt_clamp_extra_hole_depth = 1.5;
  belt_clamp_body_extra = wall_thickness*2;
  belt_clamp_extra_opening_side = 1.5;
  belt_clamp_body_width = belt_width+belt_clamp_extra_opening_side+belt_clamp_extra_hole_depth+belt_clamp_body_extra;

  module body() {
    rotate([90,0,0]) {
      rotate([0,90,0]) {
        linear_extrude(height=x_carriage_width,center=true,convexity=3) {
          carriage_profile_body();
        }
      }
    }

    module belt_clamp(belt_pos_z) {
      rotate([90,0,0]) {
        rotate([0,90,0]) {
          linear_extrude(height=x_carriage_width/2,center=true,convexity=3) {
            translate([belt_clamp_extra_opening_side+belt_width/2-belt_clamp_body_width/2,0]) {
              translate([0,x_carriage_overall_height/2,0]) {
                for(y=[front,rear]) {
                  translate([y*belt_clamp_body_width/2,0,0]) {
                    rotate([0,0,45-y*45]) {
                      round_corner_filler_profile(4,resolution);
                    }
                  }
                }
              }

              hull() {
                translate([0,belt_pos_z+belt_thickness/2]) {
                  rounded_square(belt_clamp_body_width,wall_thickness*4,4,resolution);
                }
                translate([0,x_carriage_overall_height/2,0]) {
                  square([belt_clamp_body_width,1],center=true);
                }
              }
            }
          }
        }
      }
    }

    translate([-x_carriage_width/4,0,0]) {
      belt_clamp(idler_side_belt_pos_z);
    }
    translate([x_carriage_width/4,0,0]) {
      belt_clamp(motor_side_belt_pos_z);
    }
  }

  module holes() {
    // z carriage carrier mounting holes
    for(x=[left,right]) {
      for (z=[top,bottom]) {
        translate([x*z_carriage_carrier_hole_spacing_x/2,front*(x_carriage_overall_depth/2-printed_carriage_wall_thickness/2),z*z_carriage_carrier_hole_spacing_z/2]) {
          rotate([90,0,0]) {
            hole(m3_threaded_insert_diam,printed_carriage_wall_thickness+1,8);
          }
        }
      }
    }

    translate([0,-belt_clamp_extra_hole_depth,0]) {
      // motor to carriage
      translate([0,0,motor_side_belt_pos_z]) {
        translate([x_carriage_width,0,0]) {
          belt_teeth(x_carriage_width);
        }
      }

      // idler to carriage
      translate([0,0,idler_side_belt_pos_z]) {
        translate([-x_carriage_width/2,0,0]) {
          belt_teeth(x_carriage_width/2,top);
        }
      }
    }
  }

  difference() {
    body();
    holes();
  }
}

module wheeled_sidemount(side) {
  length = 32;
  height = 16;
  width = mini_v_wheel_extrusion_spacing*2;

  mount_bolt_positions = [wall_thickness*2,length-wheel_axle_diam/2-wall_thickness*2];
  mount_bolt_dist = abs(mount_bolt_positions[0] - mount_bolt_positions[1]);
  module body() {
    hull() {
      translate([width/2,0,0]) {
        translate([0,length-1,0]) {
          hole(width,height,resolution*1.5);
        }
        translate([0,-mini_v_wheel_extrusion_spacing,0]) {
          hole(width,height,resolution*1.5);
        }
      }
    }
    if (side == right) {
      hull() {
        translate([width/2,-mini_v_wheel_extrusion_spacing*1.5,0]) {
          translate([width/2,0,0]) {
            rounded_cube(width,width/2,height,width/4,resolution);
          }
          translate([2,0,0]) {
            cube([4,width/2,height],center=true);
          }
        }
      }
    }
    translate([mini_v_wheel_extrusion_spacing,-mini_v_wheel_extrusion_spacing,0]) {
      wheel_shaft_holder();
    }
  }

  module holes() {
    translate([mini_v_wheel_extrusion_spacing,-mini_v_wheel_extrusion_spacing,0]) {
      hole(wheel_axle_diam,50,resolution);
    }

    for(y=mount_bolt_positions) {
      translate([0,y,0]) {
        rotate([0,90,0]) {
          hole(wheel_axle_diam,50,8);
        }
      }
    }

    translate([mini_v_wheel_extrusion_spacing*2,mount_bolt_positions[0]+mount_bolt_dist/2,-height/2+mech_endstop_tiny_width/2]) {
      cube([width*2+1,mech_endstop_tiny_length+1,mech_endstop_tiny_width+1],center=true);
      rotate([0,90,0]) {
        % mech_endstop_tiny();

        position_mech_endstop_tiny_mount_holes() {
          hole(m2_threaded_insert_diam,30,12);
        }
      }
    }
  }

  difference() {
    body();
    holes();
  }
}

translate([0,y_rail_len/2-20,sketch_x_rail_pos_z]) {
  rotate([90,0,90]) {
    % color("silver") extrusion_2040(x_rail_len);
  }
  for(x=[left,right]) {
    translate([x*x_rail_len/2,0,0]) {
      x_endcap(x);
    }
  }
}


translate([0,0,sketch_y_rail_pos_z]) {
  rotate([90,0,0]) {
    % color("silver") extrusion_2040(y_rail_len);
  }

  translate([0,-20,0]) {
    rotate([0,0,90]) {
      color("lightblue") pen_carriage();
    }
    translate([right*x_carriage_overall_depth/2,0,0]) {
      rotate([0,0,90]) {
        z_axis_assembly();
      }
    }
  }

  translate([0,y_rail_len/2,0]) {
    y_endcap_with_motor();

    translate([0,-40,0]) {
      for(x=[left,right]) {
        mirror([1-x,0,0]) {
          translate([40/2,0,0]) {
            wheeled_sidemount(x);
          }
        }
      }
    }
  }

  translate([0,-y_rail_len/2,0]) {
    y_endcap_with_idler();
  }
}

// a position something like this for a block-and-tackle version
translate([-x_rail_len/2-nema17_side/2,y_rail_len/2,nema17_side/2]) {
  rotate([-90,0,0]) {
    // % motor_nema17();
  }
}
