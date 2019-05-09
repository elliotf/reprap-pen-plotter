include <config.scad>;
include <lib/util.scad>;
include <lib/vitamins.scad>;
use <x-carriage.scad>;
use <misc.scad>;

at_top_of_travel = 0;

z_wall_thickness = extrude_width*8;
m3_diam_to_thread_into = 2.7;

z_bushing_len = 12;

z_bushing_hole_diam = z_bushing_od+0.5;
z_bushing_hole_len = z_bushing_len+0.5;
z_bushing_holder_body_width = z_bushing_hole_diam+extrude_width*4;
z_bushing_holder_body_len = z_bushing_hole_len+extrude_width*4;
z_rod_spacing = z_carriage_carrier_hole_spacing_x-z_bushing_holder_body_width-3;

z_carriage_rod_dist = z_bushing_od/2+zip_tie_thickness+2;
z_rod_hole_diam = z_rod_diam + 0.5;
rounding_around_rod = z_rod_hole_diam+wall_thickness*4;
z_carriage_overall_width = 2*(z_rod_spacing/2 + rounding_around_rod/2);

z_spring_hook_thickness = extrude_width*6;
z_spring_dist_from_z_rod_x = (z_carriage_overall_width/2-z_rod_spacing/2)+z_spring_diam/2;

z_axis_mount_plate_thickness = 5;

z_rod_dist_from_z_mount = z_axis_mount_plate_thickness/2 + 1.5 + z_bushing_od/2;

z_lifter_arm_thickness = z_stepper_shaft_flat_length;
z_lifter_arm_len = 9;
z_lifter_small_diam = m3_diam_to_thread_into+extrude_width*3*4;
z_lifter_large_diam = z_stepper_shaft_diam+tolerance+extrude_width*3*4;
ensure_endstop_is_hit_at_top_of_travel = 4.5;

z_carriage_plate_thickness = wall_thickness*2;
z_carriage_top_bottom_height = zip_tie_width+extrude_width*3;
// calculated bottom to top
z_carriage_desired_travel = 7.5;
z_lifter_arm_top = z_stepper_dist_from_x_rail_z - z_stepper_shaft_from_center + z_lifter_large_diam/2;
z_carriage_height_calculated = z_carriage_top_bottom_height*2 +
                               z_carriage_carrier_height/2 +
                               z_carriage_desired_travel +
                               z_lifter_arm_top +
                               m3_nut_max_diam/2 +
                               - ensure_endstop_is_hit_at_top_of_travel
                               ;
z_carriage_height = z_carriage_height_calculated;
z_carriage_hole_spacing = 15;
z_carriage_hole_from_bottom = z_carriage_top_bottom_height;
z_carriage_pos_z = z_carriage_top_bottom_height-z_carriage_height/2+z_lifter_arm_top;

z_carriage_rounding_diam = z_carriage_plate_thickness;

z_spring_hook_diam = z_spring_diam-z_spring_wire_diam*2-0.5;
z_spring_offset_z = z_carriage_height/2-z_carriage_top_bottom_height+z_spring_hook_diam+z_spring_wire_diam/2;
z_spring_preload = 2;
z_spring_stretched_len = z_spring_len+z_spring_preload;

bottom_of_z_carrier = bottom*(z_carriage_carrier_hole_spacing_z/2);

module z_spring(top_rotation=0,bottom_rotation=0) {
  spring_portion = z_spring_stretched_len - z_spring_diam*2;

  rotations=[bottom_rotation,0,top_rotation];

  translate([0,0,-z_spring_stretched_len/2]) {
    color("silver") {
      for(z=[top,bottom]) {
        rotate([0,0,rotations[z+1]]) {
          translate([0,z_spring_diam/2-z_spring_wire_diam/2,z*(spring_portion/2+z_spring_diam/2)]) {
            rotate([90,0,0]) {
              difference() {
                hole(z_spring_diam,z_spring_wire_diam-0.05,resolution);
                hole(z_spring_diam-z_spring_wire_diam*2,z_spring_wire_diam*2,resolution);
              }
            }
          }
        }
      }
      translate([0,0,0]) {
        difference() {
          hole(z_spring_diam,spring_portion,resolution);
          hole(z_spring_diam-z_spring_wire_diam*2,spring_portion+1,resolution);
          cube([z_spring_diam+1,z_spring_diam+1,z_spring_preload],center=true);
        }
      }
    }
  }
}

module z_lifter_arm() {
  tolerance = 0.2;
  shaft_hole_diam = z_stepper_shaft_diam+tolerance*2;
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
        hole(shaft_hole_diam,2*(z_stepper_shaft_flat_length+1),12);
        translate([0,z_stepper_shaft_flat_offset,0]) {
          cube([shaft_hole_diam+2,z_stepper_shaft_flat_thickness+tolerance*2,z_lifter_arm_thickness*2+1],center=true);
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
  z_bushing_spacing_z = z_carriage_carrier_hole_spacing_z-z_bushing_len/2;
  z_spring_hook_height = z_spring_diam+2;
  z_spring_hook_pos_z = z_carriage_pos_z+z_spring_offset_z-z_spring_preload-z_spring_len+z_spring_hook_diam/2+z_spring_wire_diam;

  module position_z_bushings() {
    translate([0,front*(z_rod_dist_from_z_mount),0]) {
      rotate([90,0,0]) {
        position_z_bushings_2d() {
          rotate([-90,0,0]) {
            children();
          }
        }
      }
    }
  }

  module position_mounting_screws_2d() {
    coords = [
      [left*z_carriage_carrier_hole_spacing_x/2,top*z_carriage_carrier_hole_spacing_z/2],
      [left*z_carriage_carrier_hole_spacing_x/2,bottom*z_carriage_carrier_hole_spacing_z/2],
      [right*z_carriage_carrier_hole_spacing_x/2,top*z_carriage_carrier_hole_spacing_z/2],
      [right*z_carriage_carrier_hole_spacing_x/2,bottom*z_carriage_carrier_hole_spacing_z/2],
    ];

    for(coord=coords) {
      translate(coord) {
        children();
      }
    }
  }

  bottom_bushing_pos_z = bottom*(z_carriage_carrier_hole_spacing_z/2-z_bushing_holder_body_len/2-m3_nut_max_diam/2);

  module position_z_bushings_2d() {
    coords = [
      [z_rod_spacing/2,z_lifter_arm_top-z_bushing_holder_body_len/2],
      [z_rod_spacing/2,bottom_bushing_pos_z+1],
      //[-z_rod_spacing/2,top*(z_carriage_carrier_hole_spacing_z/2+z_bushing_holder_body_len/2+m3_nut_diam)],
      [-z_rod_spacing/2,z_carriage_carrier_hole_spacing_z/2+z_bushing_holder_body_len],
      [-z_rod_spacing/2,bottom_bushing_pos_z+1],
    ];
    for(coord=coords) {
      translate(coord) {
        children();
      }
    }
  }

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
        position_mounting_screws_2d() {
          accurate_circle(m3_loose_hole+printed_carriage_wall_thickness,resolution);
        }

        position_z_bushings_2d() {
          square([z_bushing_holder_body_width,z_bushing_holder_body_len],center=true);
        }

        // z stepper flange corners
        position_z_stepper_2d() {
          for(side=[left,right]) {
            translate([side*z_stepper_hole_spacing/2,0,0]) {
              accurate_circle(m3_loose_hole+wall_thickness*4,resolution);
            }
          }
        }

        // z spring body
        translate([left*(z_rod_spacing/2+z_spring_dist_from_z_rod_x),z_spring_hook_pos_z,0]) {
          accurate_circle(z_spring_hook_height,resolution);
        }
      }
    }

    module holes() {
      // mount screw holes
      // screw hole corners
      position_mounting_screws_2d() {
        accurate_circle(m3_loose_hole,12);
      }

      position_z_stepper_2d() {
        // z stepper mount screw holes
        for(side=[left,right]) {
          translate([side*z_stepper_hole_spacing/2,0,0]) {
            accurate_circle(m3_loose_hole,12);
          }
        }

        hull() {
          // opening for z bumper
          translate([0,-z_stepper_shaft_from_center,0]) {
            room_for_arm = 1;
            larger_diam = max(z_lifter_large_diam,z_stepper_shoulder_diam)+room_for_arm;
            smaller_diam = z_lifter_small_diam+room_for_arm;
            overall = larger_diam/2 + z_lifter_arm_len + smaller_diam/2;

            accurate_circle(z_stepper_shoulder_diam+tolerance,resolution);

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

      // endstop/limit switch wire routing
      translate([z_carriage_carrier_hole_spacing_x/2-4-6,z_carriage_carrier_height/2+1,0]) {
        rounded_square(12,6,3,resolution);
      }
    }

    difference() {
      body();
      holes();
    }
  }

  zip_tie_space_around_bushing = z_bushing_od;

  module body() {
    rotate([90,0,0]) {
      linear_extrude(height=z_axis_mount_plate_thickness,center=true,convexity=3) {
        profile();
      }
    }

    position_z_bushings() {
      translate([0,rear*z_bushing_od/2,0]) {
        cube([z_bushing_holder_body_width,z_bushing_od,z_bushing_holder_body_len],center=true);
      }
    }

    translate([left*(z_rod_spacing/2+z_spring_dist_from_z_rod_x),0,z_spring_hook_pos_z]) {
      rotate([90,0,0]) {
        hull() {
          translate([0,0,z_axis_mount_plate_thickness/2-0.5]) {
            hole(z_spring_hook_height,1,resolution);
          }
          translate([0,0,z_rod_dist_from_z_mount/2]) {
            hole(z_spring_hook_diam,z_rod_dist_from_z_mount,resolution);
          }
        }

        translate([0,0,z_rod_dist_from_z_mount]) {
          hole(z_spring_hook_diam,z_spring_wire_diam*2,resolution);

          translate([0,0,z_spring_wire_diam]) {
            hull() {
              hole(z_spring_hook_diam,0.1,resolution);

              translate([0,-2,4]) {
                hole(z_spring_hook_diam,0.2,resolution);
              }
            }
          }
        }
      }
    }
  }

  module holes() {
    position_z_bushings() {
      hole(z_bushing_hole_diam,z_bushing_hole_len,8);
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

    // zip ties for endstop/limit switch cable management
    translate([0,-1.25,z_carriage_carrier_hole_spacing_z/2-2]) {
      rotate([0,0,180]) {
        zip_tie_cavity(extrude_width*6,2.5,5);
      }
    }

    // Z endstop
    translate([0,front*(z_axis_mount_plate_thickness/2+mech_endstop_tiny_width/2),bottom_bushing_pos_z-mech_endstop_tiny_height-1]) {
      rotate([180,0,0]) {
        rotate([0,0,90]) {
          % mech_endstop_tiny();

          position_mech_endstop_tiny_mount_holes() {
            hole(m2_threaded_insert_diam,30,12);
          }
        }
      }
    }

    // x limit switches in front the plate
    for(x=[left,right]) {
      endstop_pos_x = x_carriage_width/2+1;
      endstop_pos_y = front*(z_axis_mount_plate_thickness/2+mech_endstop_tiny_width/2-1.5);
      endstop_pos_z = z_carriage_carrier_hole_spacing_z/2-4-mech_endstop_tiny_length/2;
      translate([x*(endstop_pos_x),endstop_pos_y,endstop_pos_z]) {
        rotate([0,0,x*90]) {
          rotate([90,0,0]) {
            % mech_endstop_tiny();

            position_mech_endstop_tiny_mount_holes() {
              hole(m2_threaded_insert_diam,mech_endstop_tiny_width+z_axis_mount_plate_thickness*2,12);
            }

            translate([0,0,-mech_endstop_tiny_height/2]) {
              cube([mech_endstop_tiny_width+1,mech_endstop_tiny_length+1,mech_endstop_tiny_height+1],center=true);
            }
          }
        }
      }
    }

    // holes to secure endstop wiring w/ zip tie
    translate([z_rod_spacing/2+z_bushing_od,0,x_carriage_overall_height/2+zip_tie_width]) {
      rotate([0,5,0]) {
        rotate([180,0,0]) {
          // zip_tie_cavity(wall_thickness*2,zip_tie_thickness,zip_tie_width);
        }
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
      rotate([0,0,-z_stepper_angle-90*at_top_of_travel]) { // bottom of travel (min Z)
        % z_lifter_arm();
      }
    }
    if (z_stepper_body_diam == round_nema14_body_diam) {
      % round_nema14(0);
    } else if (z_stepper_body_diam == byj_body_diam) {
      % stepper28BYJ(0);
    }
  }

  difference() {
    body();
    holes();
  }
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

  pen_holder_main_body_diam = pen_max_diam+wall_thickness*4;

  pen_min_to_max_dist = sqrt(pow(pen_max_diam/2,2)*2) - sqrt(pow(pen_min_diam/2,2)*2);

  outer_diam = pen_max_diam+wall_thickness*4;

  pen_min_pos_y = front*(clearance_for_z_bushings_and_zip_ties+z_carriage_plate_thickness+pen_min_diam/2);
  pen_max_pos_y = pen_min_pos_y+front*(pen_min_to_max_dist);

  set_screw_hole_diam = 4.7;
  set_screw_body_pos_y = pen_max_pos_y+front*(pen_holder_main_body_diam/2);
  set_screw_body_depth = wall_thickness*2;
  set_screw_body_height = set_screw_hole_diam+wall_thickness*4;

  overall_depth = pen_min_diam/2 + pen_min_to_max_dist + pen_holder_main_body_diam/2 + set_screw_body_depth/2;
  half_depth = abs(abs(pen_max_pos_y) - abs(set_screw_body_pos_y));

  pen_holder_height = pen_set_screw_height + set_screw_body_height/2 + overall_depth + 4;

  spring_hook_gap_pos_x = left*(z_rod_spacing/2+z_spring_dist_from_z_rod_x-z_spring_diam/2+z_spring_wire_diam);
  spring_hook_gap_width = z_spring_wire_diam*2;
  spring_hook_height = z_spring_diam-1;
  spring_hook_pos_z = z_spring_offset_z-spring_hook_height/2;
  spring_hook_pos_y = front*(z_spring_diam/2);

  module pen_holder_profile() {
    module hulled_holes(less_diam,more_diam) {
      hull() {
        translate([0,pen_max_pos_y,0]) {
          accurate_circle(more_diam,resolution);
        }
        translate([0,pen_min_pos_y,0]) {
          accurate_circle(less_diam,resolution);
        }
      }
    }

    module body() {
      hull() {
        hulled_holes(pen_min_diam+wall_thickness*4,pen_holder_main_body_diam);

        translate([0,front*(clearance_for_z_bushings_and_zip_ties+z_carriage_plate_thickness/2)]) {
          rounded_square(pen_holder_main_body_diam,z_carriage_plate_thickness,z_carriage_plate_thickness);
        }

        // meat for the pen set screw
        translate([0,set_screw_body_pos_y,0]) {
          rounded_square(m3_nut_max_diam+wall_thickness*4,set_screw_body_depth,wall_thickness);
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
    angled_bottom_height = z_carriage_top_bottom_height+(clearance_for_z_bushings_and_zip_ties+carriage_bottom_depth/2);
    // bottom
    hull() {
      translate([0,0,bottom*(z_carriage_height/2)]) {
        // rod side
        translate([0,0,z_carriage_top_bottom_height/2]) {
          rounded_cube(z_carriage_overall_width-0,rounding_around_rod,z_carriage_top_bottom_height,rounding_around_rod,8);
        }

        // main plate side
        translate([0,front*(clearance_for_z_bushings_and_zip_ties+z_carriage_plate_thickness/2),angled_bottom_height/2]) {
          rounded_cube(z_carriage_overall_width,z_carriage_plate_thickness,angled_bottom_height,z_carriage_rounding_diam);
        }
      }
    }

    // top
    top_depth = extrude_width*5 + z_rod_hole_diam/2 + clearance_for_z_bushings_and_zip_ties + z_carriage_plate_thickness;
    hull() {
      translate([0,0,top*(z_carriage_height/2-z_carriage_top_bottom_height/2)]) {
        translate([0,front*(clearance_for_z_bushings_and_zip_ties+z_carriage_plate_thickness/2),0]) {
          rounded_cube(z_carriage_overall_width,z_carriage_plate_thickness,z_carriage_top_bottom_height,z_carriage_plate_thickness);
        }
        rounded_cube(z_carriage_overall_width-0,rounding_around_rod,z_carriage_top_bottom_height,rounding_around_rod,8);
      }
    }

    // pen holder
    linear_extrude(height=z_carriage_height,convexity=3,center=true) {
      pen_holder_profile();
    }

    angled_plate_height_addition = (z_carriage_overall_width-pen_holder_main_body_diam)*0.6;

    angled_sections = [
      [top, (z_carriage_top_bottom_height-0.5)],
      [bottom, (angled_bottom_height-0.5)],
    ];
    for(arg=angled_sections) {
      z = arg[0];
      z_offset = arg[1];
      total_height = z_offset+angled_plate_height_addition-z_carriage_plate_thickness/2;
      largest_diam = z_carriage_plate_thickness*3;
      gradient_height = largest_diam*0.55;
      full_round_height = total_height-gradient_height;
      hull() {
        translate([0,front*(clearance_for_z_bushings_and_zip_ties+z_carriage_plate_thickness/2),z*(z_carriage_height/2-z_offset)]) {
          rounded_cube(z_carriage_overall_width,z_carriage_plate_thickness,1,z_carriage_plate_thickness);

          translate([0,0,-z*angled_plate_height_addition]) {
            rounded_cube(pen_holder_main_body_diam,z_carriage_plate_thickness,1,z_carriage_plate_thickness);
          }
        }
      }

      for(x=[left,right]) {
        translate([x*(pen_holder_main_body_diam/2),front*(clearance_for_z_bushings_and_zip_ties+z_carriage_plate_thickness),z*(z_carriage_height/2)]) {
          difference() {
            translate([x*(largest_diam/2),front*(largest_diam/2),-z*(total_height-gradient_height/2)]) {
              cube([largest_diam,largest_diam,gradient_height],center=true);
            }
            hull() {
              translate([x*(largest_diam),front*(largest_diam),-z*(total_height-gradient_height/2)]) {
                hole(largest_diam*2+0.05,gradient_height+1,8);
              }
              translate([x*(largest_diam/2),front*(largest_diam/2),-z*(total_height-gradient_height/2)]) {
                hole(largest_diam,gradient_height,resolution);
              }
              translate([x*1,-1,-z*(total_height+1)]) {
                cube([2,2,2],center=true);
              }
            }
          }
          translate([0,0,-z*(full_round_height/2)]) {
            rotate([0,0,-135+x*45]) {
              round_corner_filler(largest_diam,full_round_height);
            }
          }
        }
      }
    }

    // main plate
    translate([0,front*(clearance_for_z_bushings_and_zip_ties+z_carriage_plate_thickness/2),0]) {
      rounded_cube(pen_holder_main_body_diam,z_carriage_plate_thickness,z_carriage_height,z_carriage_rounding_diam);
    }

    translate([spring_hook_gap_pos_x,spring_hook_pos_y,spring_hook_pos_z]) {
      translate([-z_spring_diam/2+z_spring_wire_diam-0.05,0,z_spring_diam/2-z_spring_wire_diam/2]) {
        % z_spring(spring_top_rotation-90);
      }

      translate([0,0,0]) {
        rotate([0,90,0]) {
          hole(z_spring_hook_diam,spring_hook_gap_width+2,resolution);
        }
      }
      translate([left*(spring_hook_gap_width/2+1),0,0]) {
        rotate([-90,0,0]) {
          translate([0,front*(z_spring_hook_diam/2),0]) {
            mirror([1,0,0]) {
              rotate_extrude(angle=90,$fn=32) {
                translate([z_spring_hook_diam/2,0,0]) {
                  accurate_circle(z_spring_hook_diam,resolution);
                }
              }
            }
          }
        }

        tip_height = z_carriage_height/2-z_spring_offset_z+z_spring_wire_diam/2;
        translate([left*(z_spring_hook_diam/2),0,z_spring_hook_diam/2+tip_height/2]) {
          hole(z_spring_hook_diam,tip_height,resolution);
        }
      }
    }
  }

  module holes() {
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

    translate([0,0,pen_holder_height/2-z_carriage_height/2]) {
      // set screw hole for pen
      translate([0,pen_max_pos_y+front*(pen_holder_main_body_diam/2),-pen_holder_height/2+pen_set_screw_height]) {
        rotate([90,0,0]) {
          hole(set_screw_hole_diam,pen_holder_main_body_diam,8);
        }
      }

      // trim excess around pen holder
      translate([0,0,-pen_holder_height/2]) {
        hull() {
          translate([0,set_screw_body_pos_y-set_screw_body_depth/2-1,pen_set_screw_height+set_screw_body_height/2]) {
            cube([pen_holder_main_body_diam+1,2,1],center=true);

            translate([0,overall_depth/2+1-0.1,overall_depth/2]) {
              // cube to check against 45 deg angle
              //% cube([overall_depth,overall_depth,overall_depth],center=true);
            }

          }
          translate([0,pen_max_pos_y+front*(half_depth),pen_set_screw_height+set_screw_body_height/2+half_depth*1.2+z_carriage_height/2]) {
            cube([pen_holder_main_body_diam+1,half_depth*2,z_carriage_height],center=true);
          }
        }

        hull() {
          translate([0,set_screw_body_pos_y-set_screw_body_depth/2-1,pen_set_screw_height-set_screw_body_height/2]) {
            cube([pen_holder_main_body_diam*2,2,1],center=true);
          }
          translate([0,pen_min_pos_y+front*(pen_holder_main_body_diam-pen_min_diam/2),-1]) {
            cube([pen_holder_main_body_diam*2,pen_holder_main_body_diam*2,2],center=true);
          }
        }
      }
    }

    for(x=[left,right]) {
      // rods
      translate([x*z_rod_spacing/2,0,0]) {
        translate([0,0,z_carriage_top_bottom_height*0.25]) {
          translate([0,0,10]) {
            hole(z_rod_hole_diam,z_carriage_height+20,8);
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
            hole(m3_threaded_insert_diam,40,8);
          }
        }
      }
    }

    // endstop trigger
    translate([-2,1.5,-z_carriage_height/2]) {
      hole(2.9,30,resolution);
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
    // round sides of pen holder
    stiffening_rib_height = z_carriage_height-pen_set_screw_height;
    for(x=[left,right]) {
      translate([x*(pen_holder_main_body_diam/2-z_carriage_plate_thickness/2),pen_max_pos_y,z_carriage_height/2-stiffening_rib_height/2]) {
        hole(z_carriage_plate_thickness,stiffening_rib_height,resolution);
      }
    }
  }


  difference() {
    body();
    holes();
  }

  bridges();
}

module pen_wedge() {
}

pen_wedge();

module z_axis_assembly() {
  translate([0,-z_axis_mount_plate_thickness/2-0.5,0]) {
    z_axis_mount();

    translate([0,-z_rod_dist_from_z_mount,z_carriage_pos_z+z_carriage_desired_travel*at_top_of_travel]) {
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
