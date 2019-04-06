include <config.scad>;
use <x-carriage.scad>;
include <lib/util.scad>;
include <lib/vitamins.scad>;

z_wall_thickness = extrude_width*8;

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

z_lifter_arm_thickness = z_stepper_shaft_flat_length-0.1;

z_carriage_plate_thickness = wall_thickness*2;
z_carriage_height = 81;
z_carriage_hole_spacing = 15;
z_carriage_top_bottom_height = zip_tie_width+extrude_width*8;
z_carriage_hole_from_bottom = z_carriage_top_bottom_height;

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
  z_lifter_arm_len = 9;
  z_lifter_bearing_thickness = 4;
  tolerance = 0.2;
  shaft_hole_diam = z_stepper_shaft_diam+tolerance;
  z_lifter_bearing_od = 10;
  z_lifter_bearing_id = 3;
  extra_meat_for_set_screw = 4;
  m3_diam_to_thread_into = 2.7;

  module z_lifter_bearing() {
    linear_extrude(height=z_lifter_bearing_thickness,convexity=3,center=true) {
      difference() {
        accurate_circle(z_lifter_bearing_od,resolution);
        accurate_circle(z_lifter_bearing_id,resolution);
      }
    }
  }

  module profile() {
  }

  module body() {
    difference() {
      translate([0,0,extra_meat_for_set_screw/2]) {
        hull() {
          hole(shaft_hole_diam+wall_thickness*4,z_lifter_arm_thickness+extra_meat_for_set_screw,resolution);

          translate([-z_lifter_arm_len,0,0]) {
            hole(m3_diam_to_thread_into+wall_thickness*3,z_lifter_arm_thickness+extra_meat_for_set_screw,resolution);
          }
        }
      }
      translate([-z_lifter_arm_len,0,z_lifter_arm_thickness/2+extra_meat_for_set_screw]) {
        hole(z_lifter_bearing_od+2,extra_meat_for_set_screw*2,resolution);
      }
    }

    translate([-z_lifter_arm_len,0,z_lifter_arm_thickness/2-1]) {
      hull() {
        hole(m3_diam_to_thread_into+wall_thickness,bearing_bevel_height*2+2,resolution);
        hole(m3_diam_to_thread_into+wall_thickness*3,2,resolution);
      }
    }
  }

  module holes() {
    translate([-z_lifter_arm_len,0,z_lifter_arm_thickness/2+bearing_bevel_height+z_lifter_bearing_thickness/2+0.1]) {
      hole(m3_diam_to_thread_into,z_lifter_arm_thickness*4,12);
      % color("silver") z_lifter_bearing();
    }

    // set screw
    translate([0,10,z_lifter_arm_thickness/2-m3_diam_to_thread_into/2]) {
      rotate([90,0,0]) {
        hole(m3_diam_to_thread_into,20,8);
      }
    }

    // stepper shaft cavity
    translate([0,0,-z_lifter_arm_thickness/2]) {
      intersection() {
        hole(shaft_hole_diam,2*(z_stepper_shaft_flat_length+1),16);
        cube([shaft_hole_diam+2,z_stepper_shaft_flat_thickness+tolerance,z_lifter_arm_thickness*2+1],center=true);
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

module zip_tie_cavity(inner_diam_input,fn=resolution) {
  inner_diam = inner_diam_input -0.05;
  overall_width = inner_diam+zip_tie_thickness*2;

  module profile() {
    for(x=[left,right]) {
      translate([x*(inner_diam/2+zip_tie_thickness/2),overall_width,0]) {
        square([zip_tie_thickness,overall_width*2],center=true);
      }
    }

    intersection() {
      translate([0,-overall_width,0]) {
        square([overall_width*2,overall_width*2],center=true);
      }
      difference() {
        accurate_circle(inner_diam+zip_tie_thickness*2,fn);
        accurate_circle(inner_diam,fn);
      }
    }
  }

  linear_extrude(height=zip_tie_width,convexity=3,center=true) {
    profile();
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
            translate([side*z_stepper_flange_hole_spacing/2,0,0]) {
              accurate_circle(z_stepper_flange_diam+2,resolution);
            }
          }
        }

        // z spring body
        translate([left*(z_rod_spacing/2+z_spring_dist_from_z_rod_x),z_spring_offset_z-z_hook_preload,]) {
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
          translate([side*z_stepper_flange_hole_spacing/2,0,0]) {
            accurate_circle(threaded_insert_diam,12);
          }
        }

        hull() {
          // opening for z bumper
          translate([0,-z_stepper_shaft_from_center,0]) {
            larger_diam = z_stepper_shaft_base_diam+4;
            smaller_diam = 9;
            dist = 9;
            overall = larger_diam/2 + dist + smaller_diam/2;

            rotate([0,0,-z_stepper_angle]) {
              translate([0,0,0]) {
                accurate_circle(larger_diam,resolution);
                translate([-dist,-larger_diam/2+smaller_diam/2,0]) {
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
          zip_tie_cavity(zip_tie_space_around_bushing);
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
    translate([0,-z_stepper_shaft_from_center,z_stepper_shaft_base_height+z_stepper_shaft_length-z_lifter_arm_thickness/2-0.08]) {
      rotate([0,0,-z_stepper_angle-7]) { // bottom of travel (min Z)
        % z_lifter_arm();
      }
    }
    % stepper28BYJ(-z_stepper_angle-5);
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
  combined_z_carriage_printed_vertically();
}

module combined_z_carriage_printed_vertically() {
  pen_min_diam = 5;
  pen_max_diam = 14;
  pen_set_screw_height = 20;
  z_rod_len = 150;
  bevel_offset = -20;
  bevel_height = 15;

  spring_anchor_thickness = 3;

  spring_top_rotation = 0;

  translate([left*(z_rod_spacing/2+z_spring_dist_from_z_rod_x),front*(z_spring_diam/2),z_spring_len/2-z_spring_diam/2+z_spring_offset_z]) {
    % z_spring(spring_top_rotation-180);
  }

  module position_spring_screw() {
    translate([left*(z_rod_spacing/2+z_spring_dist_from_z_rod_x),front*(z_spring_diam/2),top*(z_spring_len-z_spring_diam/2-z_spring_screw_diam/2-z_spring_wire_diam)+z_spring_offset_z]) {
      rotate([0,0,spring_top_rotation]) {
        translate([0,front*(z_spring_diam/2),0]) {
          rotate([-90,0,0]) {
            children();
          }
        }
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
    bottom_depth = z_rod_hole_diam + wall_thickness*4;
    // bottom
    hull() {
      translate([0,0,bottom*(z_carriage_height/2-z_carriage_top_bottom_height/2)]) {
        rounded_cube(z_carriage_overall_width,bottom_depth,z_carriage_top_bottom_height,z_carriage_rounding_diam);
      }

      angled_bottom_height = z_carriage_top_bottom_height+(clearance_for_z_bushings_and_zip_ties+bottom_depth/2);
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

      translate([left*(z_carriage_overall_width/2-z_spring_diam/2),front*(clearance_for_z_bushings_and_zip_ties+z_carriage_plate_thickness/2),z_spring_len-z_spring_screw_diam-threaded_insert_diam/2+z_spring_offset_z]) {
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
        rotate([0,0,x*0]) {
          translate([0,front*20,0]) {
            rotate([90,0,0]) {
              hole(threaded_insert_diam,40,8);
            }
          }
        }
      }

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

module z_carriage_printed_vertically() {
  z_rod_len = 150;
  bevel_offset = -20;
  bevel_height = 15;

  spring_anchor_thickness = 3;

  translate([left*(z_rod_spacing/2+z_spring_dist_from_z_rod_x),front*(z_spring_diam/2),z_spring_len/2-z_spring_diam/2]) {
    % z_spring(-160);
  }

  module position_spring_screw() {
    translate([left*(z_rod_spacing/2+z_spring_dist_from_z_rod_x),front*(z_spring_diam/2),top*(z_spring_len-z_spring_diam/2-z_spring_screw_diam/2-z_spring_wire_diam)]) {
      rotate([0,0,20]) {
        translate([0,front*(z_spring_diam/2),0]) {
          rotate([-90,0,0]) {
            children();
          }
        }
      }
    }
  }

  module body() {
    bottom_depth = z_rod_hole_diam + wall_thickness*4;
    // bottom
    hull() {
      translate([0,0,bottom*(z_carriage_height/2-z_carriage_top_bottom_height/2)]) {
        rounded_cube(z_carriage_overall_width,bottom_depth,z_carriage_top_bottom_height,wall_thickness);
      }

      angled_bottom_height = z_carriage_top_bottom_height+(clearance_for_z_bushings_and_zip_ties+bottom_depth/2);
      // main plate
      translate([0,front*(clearance_for_z_bushings_and_zip_ties+z_carriage_plate_thickness/2),bottom*(z_carriage_height/2-angled_bottom_height/2)]) {
        rounded_cube(z_carriage_overall_width,z_carriage_plate_thickness,angled_bottom_height,wall_thickness);
      }
    }

    // top
    top_depth = wall_thickness + z_rod_hole_diam/2 + clearance_for_z_bushings_and_zip_ties + z_carriage_plate_thickness;
    translate([0,front*(clearance_for_z_bushings_and_zip_ties+z_carriage_plate_thickness-top_depth/2),top*(z_carriage_height/2-z_carriage_top_bottom_height/2)+1]) {
      rounded_cube(z_carriage_overall_width,top_depth,z_carriage_top_bottom_height+2,wall_thickness);
    }

    // main plate
    translate([0,front*(clearance_for_z_bushings_and_zip_ties+z_carriage_plate_thickness/2),0]) {
      rounded_cube(z_carriage_overall_width,z_carriage_plate_thickness,z_carriage_height,wall_thickness);
    }

    // meat for z spring screw anchor
    hull() {
      position_spring_screw() {
        translate([0,0,-1]) {
          hole(z_spring_diam,2,resolution);
        }
      }
      translate([left*(z_carriage_overall_width/2-z_spring_diam/2),front*(clearance_for_z_bushings_and_zip_ties+z_carriage_plate_thickness/2),z_spring_len-z_spring_diam/2+z_spring_offset_z]) {
        rounded_cube(z_spring_diam,z_carriage_plate_thickness,z_spring_diam*2,wall_thickness);
      }
    }
  }

  module holes() {
    position_spring_screw() {
      translate([0,0,-2]) {
        hole(threaded_insert_diam,10,8);
      }
    }

    for(x=[left,right]) {
      // rods
      translate([x*z_rod_spacing/2,0,0]) {
        translate([0,0,z_carriage_top_bottom_height*0.25]) {
          hole(z_rod_hole_diam,z_carriage_height,12);

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
        rotate([0,0,x*50]) {
          translate([0,front*20,0]) {
            rotate([90,0,0]) {
              hole(threaded_insert_diam,40,8);
            }
          }
        }
      }
    }

    translate([0,front*(clearance_for_z_bushings_and_zip_ties+z_carriage_plate_thickness/2),-z_carriage_height/2]) {
      z_carriage_mounting_holes();
    }
  }

  difference() {
    body();
    holes();
  }
}

module z_carriage_mounting_holes(height=z_carriage_plate_thickness+1) {
  low = z_carriage_hole_from_bottom;
  for(x=[left,right,0]) {
    for(z=[0,1,2,3]) {
      if (z > 0 || x == 0) {
        translate([x*z_carriage_hole_spacing,0,low+z_carriage_hole_spacing*z]) {
          rotate([90,0,0]) {
            hole(threaded_insert_diam,height,8);
          }
        }
      }
    }
  }
}

module pen_holder(min_diam,max_diam,height) {
  min_to_max_dist = sqrt(pow(max_diam/2,2)*2) - sqrt(pow(min_diam/2,2)*2);

  outer_diam = max_diam+wall_thickness*4;

  min_pos_y = front*(wall_thickness*2+min_diam/2);
  max_pos_y = min_pos_y+front*(min_to_max_dist);
  main_body_diam = max_diam+wall_thickness*4;

  set_screw_hole_diam = 4.7;

  module profile() {
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
        translate([0,-wall_thickness,0]) {
          square([main_body_diam,wall_thickness*2],center=true);
        }

        hulled_holes(min_diam+wall_thickness*4,main_body_diam);

        // meat for the pen set screw
        translate([0,max_pos_y+front*(main_body_diam/2),0]) {
          rounded_square(m3_nut_max_diam+wall_thickness*4,wall_thickness*2,wall_thickness);
        }
      }

      for(x=[left,right]) {
        translate([x*main_body_diam/2,-wall_thickness*2,0]) {
          rotate([0,0,-135+x*45]) {
            round_corner_filler_profile(wall_thickness,resolution);
          }
        }
      }

      translate([0,-wall_thickness,0]) {
        rounded_square(z_carriage_overall_width-wall_thickness*2,wall_thickness*2,wall_thickness);
      }
    }

    module holes() {
      hulled_holes(min_diam,max_diam);
    }

    difference() {
      body();
      holes();
    }
  }

  module body() {
    linear_extrude(height=height,convexity=3,center=true) {
      profile();
    }
  }

  module holes() {
    // mounting holes
    translate([0,0,-height/2]) {
      low = z_carriage_hole_from_bottom;
      for(x=[left,right]) {
        for(z=[1,2,3]) {
          translate([x*z_carriage_hole_spacing,0,low+z_carriage_hole_spacing*z]) {
            rotate([90,0,0]) {
              hole(3,height,8);
            }
          }
        }
      }
    }

    // set screw hole
    translate([0,max_pos_y+front*(main_body_diam/2),-height/2+height*0.4]) {
      rotate([90,0,0]) {
        hole(set_screw_hole_diam,main_body_diam,8);
      }
    }

    // trim excess
    hull() {
      translate([0,-wall_thickness*2-main_body_diam,height/2+1]) {
        cube([main_body_diam+1,main_body_diam*2,2],center=true);
      }
      translate([0,max_pos_y+front*(main_body_diam/2+wall_thickness+1),-height/2+height*0.4+set_screw_hole_diam/2+wall_thickness]) {
        # cube([main_body_diam+1,2,1],center=true);
      }
    }
  }

  difference() {
    body();
    holes();
  }
}

module z_axis_assembly() {
  translate([0,-z_axis_mount_plate_thickness/2-0.5,0]) {
    z_axis_mount();

    translate([0,-z_rod_dist_from_z_mount,0]) { // bottom of travel (min Z)
    // translate([0,-z_rod_dist_from_z_mount,7]) { // top of travel (max Z)
      //color("grey", 0.4) %
      combined_z_carriage_printed_vertically();

      pen_holder_height = z_carriage_hole_spacing*3;
      translate([0,front*(clearance_for_z_bushings_and_zip_ties+z_carriage_plate_thickness+0.1),-z_carriage_height/2+pen_holder_height/2]) {
        // pen_holder(5,14,pen_holder_height);
      }
    }
  }
}

translate([0,0,0]) {
  translate([0,x_carriage_overall_depth/2,0]) {
    x_carriage();
  }

  z_axis_assembly();
}

module to_print() {
  rotate([-90,0,0]) {
    z_axis_mount();
  }
}
