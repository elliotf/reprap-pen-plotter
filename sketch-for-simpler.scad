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

module wheel_shaft_holder() {
  hull() {
    hole(mini_v_wheel_extrusion_spacing*2,20,resolution*1.5);
    translate([0,0,-sketch_xy_rail_dist_z+1+mini_v_wheel_thickness/2]) {
      hole(wheel_axle_diam+extrude_width*4,2,resolution*1.5);

      translate([0,0,-mini_v_wheel_thickness/2-1]) {
        % color("dimgrey") mini_v_wheel();
      }
    }
  }
}

module x_motor_endcap() {
  module body() {
  }

  module holes() {
  }

  difference() {
    body();
    holes();
  }
}

module x_idler_endcap() {
  module body() {
  }

  module holes() {
  }

  difference() {
    body();
    holes();
  }
}

module belt_idler_bearings() {
  diam = 10;
  stack_height = 8;
  flange_thickness = 1;
  flange_diam = diam+2;;

  module body() {
    hole(diam,stack_height,resolution);
    for(z=[top,bottom]) {
      translate([0,0,z*(stack_height/2-flange_thickness/2)]) {
        hole(flange_diam,flange_thickness,resolution);
      }
    }
  }

  module holes() {
    hole(5,stack_height+1,resolution);
  }

  difference() {
    body();
    holes();

  }
}

module wheeled_y_endcap() {
  thickness = mini_v_wheel_extrusion_spacing*2;
  bevel_height = 1;
  x_belt_idler_body_diam = m5_thread_into_plastic_hole_diam+wall_thickness*4;
  x_belt_idler_bevel_pos_z = -10 - bevel_height;
  x_belt_idler_spacing = nema17_side + m5_bolt_head_diam;
  x_belt_idler_pos_y = thickness-wall_thickness*2-wheel_axle_diam/2;
  x_motor_mount_thickness = (20 - m5_bolt_head_diam-tolerance) / 2;
  x_motor_pos_z = x_belt_idler_bevel_pos_z + bevel_height + x_motor_mount_thickness;
  x_motor_pos_y = thickness+nema17_side/2+0.2;

  y_motor_pos_x = left*3;
  y_motor_pos_y = front*(nema14_side/2+tolerance);
  y_motor_pos_z = 10+nema14_side/2;

  nema17_motor_mount_opening = nema17_len + tolerance*2;
  height = nema17_motor_mount_opening + x_motor_mount_thickness*2;

  m3_hole_diam = m3_diam + tolerance;
  m3_hole_body_diam = m3_hole_diam + wall_thickness*4;

  translate([y_motor_pos_x,y_motor_pos_y,y_motor_pos_z]) {
    rotate([0,-90,0]) {
      % motor_nema14();
    }
  }

  module body() {
    hull() {
      for(x=[left,right]) {
        // belt idlers
        translate([x*x_belt_idler_spacing/2,x_belt_idler_pos_y,-10+height/2]) {
          hole(x_belt_idler_body_diam,height,resolution*1.5);
        }
      }

      translate([0,thickness/2,-10+height/2]) {
        rounded_cube(40+thickness,thickness,height,thickness,resolution);
      }
    }

    for(x=[left,right]) {
      // restriction/support for shaft-side Y motor mounting holes
      translate([x*(nema17_side/2+wall_thickness+tolerance),0,0]) {
        hull() {
          translate([0,x_motor_pos_y-nema17_hole_spacing/2-3,-10+x_motor_mount_thickness/2]) {
            rounded_cube(wall_thickness*2,m3_hole_body_diam+6,x_motor_mount_thickness,wall_thickness*2,resolution);
          }

          translate([0,thickness-wall_thickness,20]) {
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
        translate([0,thickness/2,0]) {
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
        translate([0,thickness/2,0]) {
          cube([nema17_side,1,x_motor_mount_thickness],center=true);
        }
      }
    }

    // Y motor mount
    y_mount_height = height-20;
    y_mount_thickness = wall_thickness*4;
    translate([y_motor_pos_x-y_mount_thickness/2,y_motor_pos_y+nema14_side/2,-10+height-y_mount_height/2]) {
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
        translate([0,0,-4.05]) {
          % color("silver") belt_idler_bearings();
        }
      }
    }
  }

  module holes() {
    // wheel axle
    translate([0,mini_v_wheel_extrusion_spacing,-10]) {
      # hole(m5_thread_into_plastic_hole_diam,90,resolution);
    }
    // belt idlers
    for(x=[left,right]) {
      translate([x*x_belt_idler_spacing/2,x_belt_idler_pos_y,-10]) {
        # hole(m5_thread_into_plastic_hole_diam,90,resolution*1.5);
      }
    }
    for(x=[left,right]) {
      // mount to extrusion
      translate([x*10,thickness,0]) {
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
    translate([y_motor_pos_x,y_motor_pos_y,y_motor_pos_z]) {
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

  module body() {
    rotate([90,0,0]) {
      rotate([0,90,0]) {
        linear_extrude(height=x_carriage_width,center=true,convexity=3) {
          carriage_profile_body();
        }
      }
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
  }

  difference() {
    body();
    holes();
  }
}

module wheeled_sidemount() {
  length = 32;
  module body() {
    hull() {
      translate([mini_v_wheel_extrusion_spacing,0,0]) {
        translate([0,length-1,0]) {
          hole(mini_v_wheel_extrusion_spacing*2,20,resolution*1.5);
        }
        translate([0,-mini_v_wheel_extrusion_spacing,0]) {
          hole(mini_v_wheel_extrusion_spacing*2,20,resolution*1.5);
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

    for(y=[mini_v_wheel_extrusion_spacing,length-wheel_axle_diam/2-wall_thickness*4]) {
      translate([0,y,0]) {
        rotate([0,90,0]) {
          hole(wheel_axle_diam,50,8);
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
    mirror([1-x,0,0]) {
      translate([-x_rail_len/2,0,x_rail_pos_z]) {
        x_idler_endcap();
      }
    }
  }
}

translate([0,0,sketch_y_rail_pos_z]) {
  rotate([90,0,0]) {
    % color("silver") extrusion_2040(y_rail_len);
  }

  translate([0,-20,0]) {
    rotate([0,0,90]) {
      pen_carriage();
    }
    translate([right*x_carriage_overall_depth/2,0,0]) {
      rotate([0,0,90]) {
        z_axis_assembly();
      }
    }
  }

  translate([0,y_rail_len/2,0]) {
    wheeled_y_endcap();

    translate([0,-40,0]) {
      for(x=[left,right]) {
        mirror([1-x,0,0]) {
          translate([40/2,0,0]) {
            wheeled_sidemount();
          }
        }
      }
    }
  }
}

// a position something like this for a block-and-tackle version
translate([-x_rail_len/2-nema17_side/2,y_rail_len/2,nema17_side/2]) {
  rotate([-90,0,0]) {
    // % motor_nema17();
  }
}
