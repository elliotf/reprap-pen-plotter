include <config.scad>;
use <x-carriage.scad>;
include <lib/util.scad>;
include <lib/vitamins.scad>;

z_wall_thickness = extrude_width*8;
m3_diam_to_thread_into = 2.7;

z_bushing_holder_body_width = z_bushing_od+wall_thickness*2;
z_rod_spacing = z_carriage_carrier_hole_spacing_x-z_bushing_holder_body_width;

z_carriage_rod_dist = z_bushing_od/2+zip_tie_thickness+2;
z_rod_hole_diam = z_rod_diam + 0.2;
z_carriage_overall_width = 2*(z_rod_spacing/2 + z_rod_hole_diam + wall_thickness*2);

z_spring_hook_thickness = extrude_width*6;
z_spring_dist_from_z_rod_x = z_bushing_od/2 + z_spring_diam/2 + 1;
z_spring_offset_z = -8;

z_axis_mount_plate_thickness = 5;

z_rod_dist_from_z_mount = z_axis_mount_plate_thickness/2 + 1.5 + z_bushing_od/2;

z_lifter_arm_thickness = z_stepper_shaft_flat_length;
z_lifter_arm_len = 9;
z_lifter_small_diam = m3_diam_to_thread_into+extrude_width*3*4;
z_lifter_large_diam = z_stepper_shaft_diam+tolerance+extrude_width*3*4;

z_carriage_plate_thickness = wall_thickness*2;
z_carriage_top_bottom_height = zip_tie_width+extrude_width*3;
// calculated bottom to top
z_carriage_desired_travel = 8;
z_lifter_arm_top = z_stepper_dist_from_x_rail_z - z_stepper_shaft_from_center + z_lifter_large_diam/2;
z_carriage_height_calculated = z_carriage_top_bottom_height*2 +
                               z_carriage_carrier_height/2 +
                               z_carriage_desired_travel +
                               z_lifter_arm_top;
z_carriage_height = z_carriage_height_calculated;
z_carriage_hole_spacing = 15;
z_carriage_hole_from_bottom = z_carriage_top_bottom_height;
z_carriage_pos_z = z_carriage_top_bottom_height-z_carriage_height/2+z_lifter_arm_top;

z_carriage_rounding_diam = wall_thickness*2;

module z_spring(top_rotation=0,bottom_rotation=0) {
  spring_portion = z_spring_len - z_spring_diam*2;

  rotations=[bottom_rotation,0,top_rotation];

  color("silver") {
    for(z=[top,bottom]) {
      rotate([0,0,rotations[z+1]]) {
        translate([0,z_spring_diam/2-z_spring_wire_diam/2,z*(spring_portion/2+z_spring_diam/2)]) {
          rotate([90,0,0]) {
            difference() {
              hole(z_spring_diam,z_spring_wire_diam,resolution);
              hole(z_spring_diam-z_spring_wire_diam*2,z_spring_wire_diam*2,resolution);
            }
          }
        }
      }
    }
    difference() {
      hole(z_spring_diam,spring_portion,resolution);
      hole(z_spring_diam-z_spring_wire_diam*2,spring_portion+1,resolution);
    }
  }
}

module z_lifter_arm() {
  tolerance = 0.2;
  shaft_hole_diam = z_stepper_shaft_diam+tolerance;
  overall_thickness = z_lifter_arm_thickness+z_stepper_extra_meat_for_set_screw;

  module body() {
    difference() {
      translate([0,0,z_stepper_extra_meat_for_set_screw/2]) {
        hull() {
          hole(z_lifter_large_diam,overall_thickness,resolution);

          translate([-z_lifter_arm_len,0,0]) {
            hole(z_lifter_small_diam,overall_thickness,resolution);
          }
        }
      }
    }

  }

  module holes() {

    // set screw
    translate([0,10,-z_lifter_arm_thickness/2+overall_thickness/2]) {
      rotate([90,0,0]) {
        hole(m3_diam_to_thread_into,20,8);
      }
    }

    // stepper shaft cavity
    translate([0,0,0]) {
      intersection() {
        hole(shaft_hole_diam,2*(z_stepper_shaft_flat_length+1),16);
        translate([0,z_stepper_shaft_flat_offset,0]) {
          cube([shaft_hole_diam+2,z_stepper_shaft_flat_thickness+tolerance,z_lifter_arm_thickness*2+1],center=true);
        }
      }
    }
  }

  difference() {
    color("purple") body();
    holes();
  }
}

module printable_sideways_cavity(diam,len) {
  linear_extrude(height=len,center=true) {
    intersection() {
      rotate([0,0,45]) {
        square([diam,diam],center=true);
      }
      square([diam*2,diam],center=true);
    }
  }
}

module z_axis_mount() {
  z_bushing_len = 12;
  z_bushing_spacing_z = z_carriage_carrier_hole_spacing_z-z_bushing_len/2;
  z_bushing_bias_z = 3;
  z_spring_hook_height = z_spring_diam+2;
  z_hook_preload = 1;

  module profile() {
    module position_z_stepper_2d() {
      translate([z_stepper_pos_x,z_stepper_dist_from_x_rail_z,0]) {
        rotate([0,0,z_stepper_angle]) {
          children();
        }
      }
    }

    module body() {
      hull() {
        // screw hole corners
        for(x=[left,right]) {
          for(z=[top,bottom]) {
            translate([x*z_carriage_carrier_hole_spacing_x/2,z*z_carriage_carrier_hole_spacing_z/2]) {
              accurate_circle(m3_loose_hole+printed_carriage_wall_thickness,resolution);
            }
          }
        }

        // z stepper flange corners
        position_z_stepper_2d() {
          for(side=[left,right]) {
            translate([side*z_stepper_hole_spacing/2,0,0]) {
              accurate_circle(threaded_insert_diam+wall_thickness*4,resolution);
            }
          }
        }

        // z spring body
        translate([left*(z_rod_spacing/2+z_spring_dist_from_z_rod_x),z_spring_offset_z-z_hook_preload,0]) {
          rounded_square(z_spring_hook_thickness,z_spring_hook_height,extrude_width*2);
        }
      }
    }

    module holes() {
      // mount screw holes
      for(x=[left,0,right]) {
        for(z=[0,bottom]) {
          if (z == 0 || x == 0) {
            translate([x*z_carriage_carrier_hole_spacing_x/2,z*z_carriage_carrier_hole_spacing_z/2]) {
              accurate_circle(m3_loose_hole,12);
            }
          }
        }
      }

      position_z_stepper_2d() {
        // z stepper mount screw holes
        for(side=[left,right]) {
          translate([side*z_stepper_hole_spacing/2,0,0]) {
            accurate_circle(threaded_insert_diam,12);
          }
        }

        hull() {
          // opening for z bumper
          translate([0,-z_stepper_shaft_from_center,0]) {
            room_for_arm = 1;
            larger_diam = max(z_lifter_large_diam,z_stepper_shoulder_diam)+room_for_arm;
            smaller_diam = z_lifter_small_diam+room_for_arm;
            overall = larger_diam/2 + z_lifter_arm_len + smaller_diam/2;

            accurate_circle(z_stepper_shoulder_diam+1,resolution);

            rotate([0,0,-z_stepper_angle]) {
              translate([0,0,0]) {
                accurate_circle(larger_diam,resolution);
                translate([-z_lifter_arm_len,0,0]) {
                  accurate_circle(smaller_diam,resolution);
                }
              }

              translate([larger_diam/2-overall/2,20,0]) {
                square([overall,40],center=true);
              }
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

  zip_tie_space_around_bushing = z_bushing_od;

  module position_z_bushings() {
    for(x=[left,right]) {
      translate([x*(z_rod_spacing/2),front*(z_rod_dist_from_z_mount),z_bushing_bias_z]) {
        for(z=[top,bottom]) {
          translate([0,0,z*z_bushing_spacing_z/2]) {
            children();
          }
        }
      }
    }
  }

  module body() {
    rotate([90,0,0]) {
      linear_extrude(height=z_axis_mount_plate_thickness,center=true,convexity=3) {
        profile();
      }
    }

    position_z_bushings() {
      translate([0,rear*z_bushing_od/2,0]) {
        cube([z_bushing_holder_body_width,z_bushing_od,z_bushing_len+wall_thickness*2],center=true);
      }
    }
  }

  module holes() {
    position_z_bushings() {
      hole(z_bushing_od+0.5,z_bushing_len,8);
      rotate([0,0,90]) {
        hole(z_rod_diam+1,z_bushing_len*2,6);
      }

      // zip ties for z bushings
      translate([0,rear*(z_rod_dist_from_z_mount+z_axis_mount_plate_thickness/2-zip_tie_space_around_bushing/2-zip_tie_thickness),0]) {
        mirror([0,1,0]) {
          zip_tie_cavity(zip_tie_space_around_bushing,zip_tie_thickness,zip_tie_width);
        }
      }

      % color("ivory", 0.9) difference() {
        hole(z_bushing_od,z_bushing_len,16);
        hole(z_bushing_id,z_bushing_len+1,8);
      }
    }
  }

  module position_z_stepper() {
    translate([z_stepper_pos_x,rear*(z_axis_mount_plate_thickness/2),z_stepper_dist_from_x_rail_z]) {
      rotate([90,0,0]) {
        rotate([0,0,z_stepper_angle]) {
          children();
        }
      }
    }
  }

  position_z_stepper() {
    translate([0,-z_stepper_shaft_from_center,z_stepper_shoulder_height+z_lifter_arm_thickness/2+1]) {
      rotate([0,0,-z_stepper_angle]) { // bottom of travel (min Z)
        % z_lifter_arm();
      }
    }
    if (z_stepper_body_diam == round_nema14_body_diam) {
      % round_nema14(0);
    } else if (z_stepper_body_diam == byj_body_diam) {
      % stepper28BYJ(0);
    }
  }

  module bridges() {
    translate([left*(z_rod_spacing/2+z_spring_dist_from_z_rod_x),0,z_spring_offset_z-z_hook_preload]) {
      rotate([90,0,0]) {
        hull() {
          translate([0,0,z_axis_mount_plate_thickness/2-0.5]) {
            rounded_cube(z_spring_hook_thickness,z_spring_hook_height,1,extrude_width*2);
          }
          translate([0,0,z_rod_dist_from_z_mount/2]) {
            rounded_cube(z_spring_hook_thickness,z_spring_diam-2,z_rod_dist_from_z_mount,extrude_width*2);
          }
        }

        translate([0,0,z_rod_dist_from_z_mount]) {
          rounded_cube(z_spring_hook_thickness,z_spring_diam-2,2,extrude_width*2);
        }

        translate([0,0,z_rod_dist_from_z_mount+1]) {
          hull() {
            rounded_cube(z_spring_hook_thickness,z_spring_diam-2,0.1,extrude_width*2);

            translate([0,-1,2]) {
              rounded_cube(z_spring_hook_thickness,z_spring_diam-2,0.2,extrude_width*2);
            }
          }
        }
      }
    }
  }

  difference() {
    body();
    holes();
  }

  bridges();
}

module z_carriage() {
  pen_min_diam = 5;
  pen_max_diam = 14;
  pen_set_screw_height = 20;
  z_rod_len = 150;
  bevel_offset = -20;
  bevel_height = 15;

  spring_anchor_thickness = 3;

  spring_top_rotation = 0;

  carriage_bottom_depth = z_rod_hole_diam + wall_thickness*4;

  module position_spring_screw() {
    pos_z = top*(z_spring_len-z_spring_diam/2-z_spring_screw_diam/2-z_spring_wire_diam)+z_spring_offset_z-z_carriage_pos_z;
    translate([left*(z_rod_spacing/2+z_spring_dist_from_z_rod_x),front*(z_spring_diam/2),pos_z]) {
      rotate([0,0,spring_top_rotation]) {
        translate([0,front*(z_spring_diam/2),0]) {
          rotate([-90,0,0]) {
            children();
          }
        }
      }
    }
  }

  position_spring_screw() {
    rotate([90,0,0]) {
      translate([0,z_spring_diam/2,-z_spring_len/2+z_spring_screw_diam/2]) {
        % z_spring(spring_top_rotation-180);
      }
    }
  }

  module pen_holder() {
    min_to_max_dist = sqrt(pow(pen_max_diam/2,2)*2) - sqrt(pow(pen_min_diam/2,2)*2);

    outer_diam = pen_max_diam+wall_thickness*4;

    min_pos_y = front*(clearance_for_z_bushings_and_zip_ties+z_carriage_plate_thickness+pen_min_diam/2);
    max_pos_y = min_pos_y+front*(min_to_max_dist);
    main_body_diam = pen_max_diam+wall_thickness*4;

    set_screw_hole_diam = 4.7;
    set_screw_body_pos_y = max_pos_y+front*(main_body_diam/2);
    set_screw_body_depth = wall_thickness*2;
    set_screw_body_height = set_screw_hole_diam+wall_thickness*4;

    overall_depth = pen_min_diam/2 + min_to_max_dist + main_body_diam/2 + set_screw_body_depth/2;

    pen_holder_height = pen_set_screw_height + set_screw_body_height/2 + overall_depth + 4;

    module pen_holder_profile() {
      module hulled_holes(less_diam,more_diam) {
        hull() {
          translate([0,max_pos_y,0]) {
            accurate_circle(more_diam,resolution);
          }
          translate([0,min_pos_y,0]) {
            accurate_circle(less_diam,resolution);
          }
        }
      }

      module body() {
        hull() {
          translate([0,min_pos_y+pen_min_diam/2,0]) {
            square([main_body_diam,2],center=true);
          }

          hulled_holes(pen_min_diam+wall_thickness*4,main_body_diam);

          // meat for the pen set screw
          translate([0,set_screw_body_pos_y,0]) {
            rounded_square(m3_nut_max_diam+wall_thickness*4,set_screw_body_depth,wall_thickness);
          }
        }

        for(x=[left,right]) {
          translate([x*main_body_diam/2,min_pos_y+pen_min_diam/2,0]) {
            rotate([0,0,-135+x*45]) {
              round_corner_filler_profile(wall_thickness,resolution);
            }
          }
        }
      }

      module holes() {
        hulled_holes(pen_min_diam,pen_max_diam);
      }

      difference() {
        body();
        holes();
      }
    }

    module body() {
      // pen holder
      linear_extrude(height=pen_holder_height,convexity=3,center=true) {
        pen_holder_profile();
      }
    }

    module holes() {
      // set screw hole for pen
      translate([0,max_pos_y+front*(main_body_diam/2),-pen_holder_height/2+pen_set_screw_height]) {
        rotate([90,0,0]) {
          hole(set_screw_hole_diam,main_body_diam,8);
        }
      }

      // trim excess
      translate([0,0,-pen_holder_height/2]) {
        hull() {
          translate([0,set_screw_body_pos_y-set_screw_body_depth/2-1,pen_set_screw_height+set_screw_body_height/2]) {
            cube([main_body_diam+1,2,1],center=true);

            translate([0,overall_depth/2+1-0.1,overall_depth/2]) {
              // cube to check against 45 deg angle
              //% cube([overall_depth,overall_depth,overall_depth],center=true);
            }
          }
          translate([0,min_pos_y+front*(main_body_diam-pen_min_diam/2),pen_holder_height+0.01]) {
            cube([main_body_diam+1,main_body_diam*2,0.02],center=true);
          }
        }

        hull() {
          translate([0,set_screw_body_pos_y-set_screw_body_depth/2-1,pen_set_screw_height-set_screw_body_height/2]) {
            cube([main_body_diam+1,2,1],center=true);
          }
          translate([0,min_pos_y+front*(main_body_diam-pen_min_diam/2),-1]) {
            cube([main_body_diam+1,main_body_diam*2,2],center=true);
          }
        }
      }
    }

    translate([0,0,pen_holder_height/2]) {
      difference() {
        body();
        holes();
      }
    }
  }

  module body() {
    // bottom
    hull() {
      translate([0,0,bottom*(z_carriage_height/2-z_carriage_top_bottom_height/2)]) {
        rounded_cube(z_carriage_overall_width,carriage_bottom_depth,z_carriage_top_bottom_height,z_carriage_rounding_diam);
      }

      angled_bottom_height = z_carriage_top_bottom_height+(clearance_for_z_bushings_and_zip_ties+carriage_bottom_depth/2);
      // main plate
      translate([0,front*(clearance_for_z_bushings_and_zip_ties+z_carriage_plate_thickness/2),bottom*(z_carriage_height/2-angled_bottom_height/2)]) {
        rounded_cube(z_carriage_overall_width,z_carriage_plate_thickness,angled_bottom_height,z_carriage_rounding_diam);
      }
    }

    // top
    top_depth = extrude_width*5 + z_rod_hole_diam/2 + clearance_for_z_bushings_and_zip_ties + z_carriage_plate_thickness;
    translate([0,front*(clearance_for_z_bushings_and_zip_ties+z_carriage_plate_thickness-top_depth/2),top*(z_carriage_height/2-z_carriage_top_bottom_height/2)]) {
      rounded_cube(z_carriage_overall_width,top_depth,z_carriage_top_bottom_height,z_carriage_rounding_diam);
    }

    // main plate
    translate([0,front*(clearance_for_z_bushings_and_zip_ties+z_carriage_plate_thickness/2),0]) {
      rounded_cube(z_carriage_overall_width,z_carriage_plate_thickness,z_carriage_height,z_carriage_rounding_diam);
    }

    // meat for z spring screw anchor
    hull() {
      position_spring_screw() {
        translate([0,0,-z_carriage_plate_thickness/2-1]) {
          hole(z_spring_diam,z_carriage_plate_thickness+2,resolution);
        }
      }

      translate([left*(z_carriage_overall_width/2-z_spring_diam/2),front*(clearance_for_z_bushings_and_zip_ties+z_carriage_plate_thickness/2),z_spring_len-z_spring_screw_diam-threaded_insert_diam/2+z_spring_offset_z-z_carriage_pos_z]) {
        rounded_cube(z_spring_diam,z_carriage_plate_thickness,z_spring_diam*3,z_carriage_rounding_diam);
      }
    }

    // reinforce z rod zip tie holes
    meat_between_zip_ties = wall_thickness*2;
    meat_between_zip_tie_and_outside = z_carriage_overall_width/2-z_rod_spacing/2-meat_between_zip_ties/2-zip_tie_thickness;
    meat_depth = clearance_for_z_bushings_and_zip_ties-z_rod_hole_diam/2+z_carriage_plate_thickness;
    meat_height = zip_tie_width+1;
    zip_tie_spacing = meat_between_zip_ties+zip_tie_thickness;
    module zip_tie_meat(width) {
      hull() {
        translate([0,front*(z_rod_hole_diam/2+width/2),0]) {
          hole(width,meat_height,resolution);
        }
        translate([0,front*(clearance_for_z_bushings_and_zip_ties+z_carriage_plate_thickness/2),0]) {
          cube([width,0.1,meat_height],center=true);
        }
      }
    }
    for(x=[left,right]) {
      translate([x*(z_rod_spacing/2),0,z_carriage_height/2-z_carriage_top_bottom_height-zip_tie_width/2]) {
        zip_tie_meat(meat_between_zip_ties);
      }
      translate([x*(z_carriage_overall_width/2-meat_between_zip_tie_and_outside/2),0,z_carriage_height/2-z_carriage_top_bottom_height-zip_tie_width/2]) {
        zip_tie_meat(meat_between_zip_tie_and_outside);
      }
    }

    translate([0,0,-z_carriage_height/2]) {
      pen_holder();
    }
  }

  module holes() {
    position_spring_screw() {
      translate([0,0,-2]) {
        hole(threaded_insert_diam,20,8);
      }
    }

    // room for z stepper shaft
    if ((z_stepper_shaft_length+z_stepper_shoulder_height) > (z_axis_mount_plate_thickness/2+z_rod_dist_from_z_mount+clearance_for_z_bushings_and_zip_ties)) {
      translate([z_stepper_pos_x,0,z_stepper_dist_from_x_rail_z-z_carriage_pos_z]) {
        hull() {
          translate([0,0,1]) {
            rotate([90,0,0]) {
              hole(z_stepper_shaft_diam+1,z_carriage_height,16);
            }
          }
          translate([0,0,-z_carriage_desired_travel-1]) {
            rotate([90,0,0]) {
              hole(z_stepper_shaft_diam+1,z_carriage_height,16);
            }
          }
        }
      }
    }

    for(x=[left,right]) {
      // rods
      translate([x*z_rod_spacing/2,0,0]) {
        translate([0,0,z_carriage_top_bottom_height*0.25]) {
          translate([0,0,10]) {
            hole(z_rod_hole_diam,z_carriage_height+20,12);
          }

          translate([0,z_rod_hole_diam,z_carriage_height/2]) {
            // cube([z_rod_hole_diam,z_rod_hole_diam*2,z_carriage_height/2],center=true);
          }

          translate([0,0,z_rod_len/2-z_carriage_height/2]) {
            color("silver", 0.7) % hole(z_rod_diam,z_rod_len,8);
          }
        }
      }

      // set screws
      translate([x*z_rod_spacing/2,0,bottom*(z_carriage_height/2-z_carriage_top_bottom_height)]) {
        translate([0,front*20,0]) {
          rotate([90,0,0]) {
            hole(threaded_insert_diam,40,8);
          }
        }
      }

      // z limit flag
      /*
      // try something in the middle and mount the z limit switch on the z carriage carrier ?
      // in the bottom
      z_limit_flag_screw_length = 25;
      z_limit_flag_screw_diam = 2.5;
      translate([z_limit_switch_pos_x,rear*(z_limit_flag_screw_length/2-carriage_bottom_depth*.5),bottom*(z_carriage_height/2-z_carriage_top_bottom_height/2)]) {
        rotate([90,0,0]) {
          % hole(z_limit_flag_screw_diam,z_limit_flag_screw_length,8);
        }
      }
      */

      // zip ties to hold z rods? -- unnecessary?
      translate([x*(z_rod_spacing/2),front*(clearance_for_z_bushings_and_zip_ties+z_carriage_plate_thickness/2),z_carriage_height/2-z_carriage_top_bottom_height-zip_tie_width/2]) {
        for(side=[left,right]) {
          translate([side*(wall_thickness+zip_tie_thickness/2),0,0]) {
            rotate([-90,0,0]) {
              rounded_cube(zip_tie_thickness,zip_tie_width,z_carriage_plate_thickness+1,zip_tie_thickness/2,4);
            }
          }
        }
      }
    }
  }

  for(x=[left,right]) {
    translate([x*z_rod_spacing/2,0,z_carriage_top_bottom_height*0.25]) {
      translate([0,0,z_rod_len/2-z_carriage_height/2]) {
        color("silver", 0.7) % hole(z_rod_diam,z_rod_len,8);
      }
    }
  }

  module bridges() {
    // stiffening ribs
    stiffening_rib_depth = 6;
    stiffening_rib_width = extrude_width*4;
    stiffening_rib_height = z_carriage_height-pen_set_screw_height;
    for(x=[left,right]) {
      // main plate stiffening
      translate([x*(pen_max_diam/2+wall_thickness*2-stiffening_rib_width/2),front*(clearance_for_z_bushings_and_zip_ties+z_carriage_plate_thickness),z_carriage_height/2-stiffening_rib_height/2]) {
        for(side=[left,right]) {
          translate([side*stiffening_rib_width/2,0,0]) {
            rotate([0,0,-135+45*side]) {
              round_corner_filler(wall_thickness,stiffening_rib_height);
            }
          }
        }
        hull() {
          cube([stiffening_rib_width,1,stiffening_rib_height],center=true);
          translate([0,front*(stiffening_rib_depth-wall_thickness/2),0]) {
            rounded_cube(stiffening_rib_width,wall_thickness,stiffening_rib_height,stiffening_rib_width);
          }
        }
      }
    }
  }


  difference() {
    body();
    holes();
  }

  bridges();
}

module endstop_flag() {
  flag_length = 16;
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

  color("lightblue") difference() {
    body();
    holes();
  }
}

module z_axis_assembly() {
  translate([0,-z_axis_mount_plate_thickness/2-0.5,0]) {
    z_axis_mount();

    translate([0,-z_rod_dist_from_z_mount,z_carriage_pos_z]) {
      // color("grey", 0.4) %
      z_carriage();
    }
  }
}

translate([0,0,0]) {
  translate([0,x_carriage_overall_depth/2,0]) {
    x_carriage();

    for(x=[left,right]) {
      mirror([x-1,0,0]) {
        translate([x_carriage_width/2+20,10,-x_rail_extrusion_height/2]) {
          rotate([0,90,0]) {
            rotate([0,0,90]) {
              endstop_flag();
            }
          }
        }
      }
    }
  }

  z_axis_assembly();
}

module to_print() {
  rotate([-90,0,0]) {
    z_axis_mount();
  }
}
