use <main.scad>;
include <config.scad>;
include <util.scad>;
include <vitamins.scad>;

x_carriage_width = 50;

x_carriage_bushing_len   = 10;
x_carriage_bushing_pos_y = x_rail_extrusion_width/2 + ptfe_bushing_diam/2 - ptfe_bushing_preload_amount;
x_carriage_bushing_pos_z = x_rail_extrusion_height/2  + ptfe_bushing_diam/2 - ptfe_bushing_preload_amount;

z_bearing_id = 3.5;
z_bearing_od = 6;
z_bearing_len = x_carriage_overall_height + zip_tie_width*2;
//z_bearing_len = x_carriage_overall_height+;
z_wall_thickness = extrude_width*8;
z_carriage_carrier_height = z_bearing_len + z_wall_thickness*2;
z_carriage_height = z_carriage_carrier_height + 25;
z_carriage_plate_thickness = z_wall_thickness*2;

z_rod_offset_from_x_carriage = front*x_carriage_overall_depth/2 - z_bearing_od/2;
z_carriage_carrier_thickness = abs(z_rod_offset_from_x_carriage) - x_carriage_opening_depth/2;
// z_rod_spacing = 25.4;
z_rod_spacing = x_carriage_width - z_bearing_od - printed_carriage_wall_thickness*2;

z_carriage_rod_dist = z_bearing_od/2+zip_tie_thickness+2;
z_carriage_width = z_rod_spacing+z_rod_diam+z_wall_thickness*3;

z_stepper_pulley_diam = 15;

z_stepper_angle = 60;
z_stepper_mount_depth = sin(z_stepper_angle)*z_stepper_flange_hole_spacing+z_stepper_flange_diam;
so_that_z_stepper_mount_clears_z_carriage = 5;
z_stepper_pos_x = x_carriage_width/2-z_stepper_height+3;
z_stepper_pos_y = z_rod_offset_from_x_carriage+z_stepper_mount_depth/2+so_that_z_stepper_mount_clears_z_carriage;
z_stepper_pos_z = x_carriage_overall_height/2+z_stepper_diam/2+0.5;

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

module stepper_with_lifter(angle) {
  translate([0,-z_stepper_shaft_from_center,z_stepper_shaft_length/2+z_stepper_shaft_base_height+1]) {
    rotate([0,0,angle]) {
      color("pink") z_axis_lifter();
    }
  }

  stepper28BYJ(angle);
}

translate([0,0,50]) {
  // % stepper_with_lifter();
}

module x_carriage() {
  tensioner_pos_x = tuner_anchor_screw_hole_pos_z-tuner_anchor_diam/2+2;
  tensioner_pos_y = x_carriage_overall_depth/2+tuner_thick_diam/2;
  tensioner_shoulder_pos_z = tuner_hole_to_shoulder;
  //z_carrier_height_above_x_carriage = 0;
  z_carrier_height_above_x_carriage = (z_carriage_carrier_height-x_carriage_overall_height)/2;
  z_carrier_z_adjustment = -(z_carriage_carrier_height-x_carriage_overall_height)/2 + z_carrier_height_above_x_carriage;

  translate([0,0,50]) {
    // color("lightblue") carriage_profile();
  }

  module carriage_profile() {
    module profile_body() {
      rounded_square(x_carriage_overall_depth,x_carriage_overall_height,printed_carriage_outer_diam);

      // z axis mounting plate
      translate([front*(x_carriage_opening_depth/2+z_carriage_carrier_thickness/2),x_carriage_overall_height/2-z_carriage_carrier_height/2+z_carrier_height_above_x_carriage]) {
        rounded_square(z_carriage_carrier_thickness,z_carriage_carrier_height,printed_carriage_inner_diam);
      }

      translate([front*(x_carriage_opening_depth/2),0]) {
        // round out internal corners
        for(z=[top,bottom]) {
          mirror([0,1-z]) {
            translate([0,x_carriage_overall_height/2]) {
              if (z==bottom || (z==top && z_carrier_height_above_x_carriage > printed_carriage_inner_diam/2)) {
                round_corner_filler_profile(printed_carriage_inner_diam);
              }
              translate([0,-printed_carriage_wall_thickness/2]) {
                square([5,printed_carriage_wall_thickness],center=true);
              }
            }
          }
        }
      }
    }

    module profile_holes() {
      rounded_square(x_carriage_opening_depth,x_carriage_opening_height,printed_carriage_inner_diam);
    }

    difference() {
      profile_body();
      profile_holes();
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
    mirror([side+1,0,0]) {
      translate([tensioner_pos_x,tensioner_pos_y,-5]) {
        rotate([-2,0,0]) {
          rotate([0,-5,0]) {
            rotate([0,0,90]) {
              rotate([0,90,0]) {
                children();
              }
            }
          }
        }
      }
    }
  }

  module z_stepper_mount_profile() {
    module body() {
      spacing = (z_stepper_mount_depth-z_stepper_flange_diam)/2;
      translate([z_stepper_pos_y,0,0]) {
        for(side=[left,right]) {
          translate([-spacing-z_stepper_flange_diam/2,x_carriage_overall_height/2+z_carrier_height_above_x_carriage,0]) {
            rotate([0,0,90]) {
              round_corner_filler_profile(printed_carriage_inner_diam);
            }
          }
          translate([side*spacing,x_carriage_overall_height/2,0]) {
            for(x=[left,right]) {
              translate([x*z_stepper_flange_diam/2,0,0]) {
                rotate([0,0,45-x*45]) {
                  round_corner_filler_profile(printed_carriage_inner_diam);
                }
              }
            }
          }
          hull() {
            translate([-side*spacing,x_carriage_overall_height/2,0]) {
              square([z_stepper_flange_diam,1],center=true);
            }
            translate([0,z_stepper_pos_z,0]) {
              rotate([0,0,90+z_stepper_angle]) {
                translate([side*z_stepper_flange_hole_spacing/2,0]) {
                  accurate_circle(z_stepper_flange_diam,32);
                }
              }
            }
          }
        }
      }
    }

    module holes() {
      translate([z_stepper_pos_y,z_stepper_pos_z,0]) {
        rotate([0,0,z_stepper_angle]) {
          accurate_circle(z_stepper_diam+0.5,32);
        }
      }
      for(side=[left,right]) {
        translate([z_stepper_pos_y,z_stepper_pos_z,0]) {
          rotate([0,0,90+z_stepper_angle]) {
            translate([side*z_stepper_flange_hole_spacing/2,0]) {
              accurate_circle(2.5,32);
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

  rotate([0,90,0]) {
    rotate([0,0,90]) {
      % extrusion_2040(x_carriage_width+30);
    }
  }

  // sketch
  translate([z_stepper_pos_x,z_stepper_pos_y,z_stepper_pos_z]) {
    rotate([z_stepper_angle,0,0]) {
      rotate([0,-90,0]) {
        % stepper_with_lifter(z_stepper_angle);
      }
    }
  }

  translate([0,0,0]) {
  }

  translate([-0,-x_carriage_opening_depth/2,x_carriage_overall_height/2+z_stepper_diam/2]) {
    rotate([90,0,0]) {
      rotate([0,0,z_stepper_angle]) {
        translate([0,0,0]) {
          // stepper28BYJ(90-z_stepper_angle);
        }
      }
    }
  }

  module body() {
    rotate([90,0,0]) {
      rotate([0,90,0]) {
        linear_extrude(height=x_carriage_width,center=true,convexity=3) {
          carriage_profile();
        }
      }
    }

    z_stepper_mount_width = x_carriage_width/2-z_stepper_pos_x-z_stepper_flange_thickness;
    translate([z_stepper_pos_x+z_stepper_mount_width/2+z_stepper_flange_thickness,0,0]) {
      rotate([90,0,0]) {
        rotate([0,90,0]) {
          linear_extrude(height=z_stepper_mount_width,center=true,convexity=3) {
            z_stepper_mount_profile();
          }
        }
      }
    }

    // tensioner mount
    hull() {
      translate([0,x_carriage_overall_depth/2-printed_carriage_wall_thickness/2,x_carriage_overall_height/2-printed_carriage_wall_thickness/2]) {
        translate([0,3,0]) {
          rotate([0,90,0]) {
            hole(printed_carriage_wall_thickness,x_carriage_width,32);
            translate([printed_carriage_wall_thickness,-printed_carriage_wall_thickness/4,0]) {
              cube([printed_carriage_wall_thickness,printed_carriage_wall_thickness/2-0.85,x_carriage_width],center=true);
            }
          }
        }
        rotate([0,90,0]) {
          translate([-printed_carriage_wall_thickness/4,-printed_carriage_wall_thickness/4,0]) {
            cube([printed_carriage_wall_thickness/2,printed_carriage_wall_thickness/2,x_carriage_width],center=true);
          }
        }
      }
      for(x=[left,right]) {
        position_for_tensioner_shoulder(x) {
          translate([-tuner_body_diam/2,tuner_body_diam/2,0.5]) {
            hole(tuner_anchor_diam,1,16);
          }
          translate([0,0,-5]) {
            hole(tuner_body_diam,10,32);
          }
        }
      }
    }
  }

  module holes() {
    bushing_from_wall = x_rail_extrusion_height/5;

    // PTFE bushings
    for (y=[front,0,rear]) {
      for(x=[left,right]) {
        for(z=[top,bottom]) {
          // short side bushings
          translate([x*(x_carriage_width/2-x_carriage_bushing_len/2-printed_carriage_bushing_from_end),y*x_carriage_bushing_pos_y,z*(x_carriage_opening_height/2-bushing_from_wall)]) {
            rotate([0,90,0]) {
              hole(ptfe_bushing_diam,x_carriage_bushing_len,8);
            }
          }

          // long side bushings
          translate([x*(x_carriage_width/2-x_carriage_bushing_len/2-printed_carriage_bushing_from_end),y*(x_carriage_opening_depth/2-bushing_from_wall),z*x_carriage_bushing_pos_z]) {
            rotate([0,90,0]) {
              hole(ptfe_bushing_diam,x_carriage_bushing_len,8);
            }
          }
        }
      }
    }

    translate([0,0,z_carrier_z_adjustment]) {
      // Z rod holder
      for(x=[left,right]) {
        translate([x*z_rod_spacing/2,z_rod_offset_from_x_carriage,0]) {
          % difference() {
            hole(z_bearing_od,z_bearing_len,16);
            hole(z_bearing_id,z_bearing_len+1,16);
          }
          printable_sideways_cavity(z_bearing_id+1,z_carriage_carrier_height+1);
         
          printable_sideways_cavity(z_bearing_od,z_bearing_len);

          for(z=[top,bottom]) {
            translate([0,1,z*(z_bearing_len/2-zip_tie_width/2)]) {
              # ring(z_bearing_od+2.5,zip_tie_thickness,zip_tie_width,16);
            }
          }
        }
      }
    }

    // clearance for Z stepper
    z_carrier_above_x_carriage = (z_carriage_carrier_height-x_carriage_overall_height)/2;
    z_stepper_notch_width = 12;
    translate([z_stepper_pos_x+z_stepper_flange_thickness-z_stepper_notch_width/2,z_rod_offset_from_x_carriage,z_carriage_carrier_height/2]) {
      hull() {
        cube([z_stepper_notch_width,z_carriage_carrier_thickness*3,z_carrier_above_x_carriage*2],center=true);
        translate([-z_carrier_above_x_carriage/2,0,1]) {
          cube([z_stepper_notch_width+z_carrier_above_x_carriage,z_carriage_carrier_thickness*3,2],center=true);
        }
      }
    }

    for(x=[left,right]) {
      // tensioner holes
      position_for_tensioner_shoulder(x) {
        translate([-tuner_body_diam/2,tuner_body_diam/2,0]) {
          hole(tuner_anchor_screw_hole_diam-0.5,5,8);
        }
        translate([0,0,-5]) {
          hole(tuner_thick_diam,30,8);
        }
      }

      // notch to maintain line position
      mirror([x-1,0,0]) {
        translate([x_carriage_width/2,x_carriage_overall_depth/2-printed_carriage_wall_thickness/2,0]) {
          for(side=[rear]) {
            translate([0,side*printed_carriage_wall_thickness/2,0]) {
              rotate([0,-10,0]) {
                rotate([0,0,60]) {
                  rotate([90,0,0]) {
                    cylinder(r=2,h=printed_carriage_wall_thickness*2,center=true,$fn=4);
                  }
                }
              }
            }
          }
        }
      }
    }
  }

  for(x=[left,right]) {
    position_for_tensioner(x) {
      mirror([0,1,0]) {
        %tuner();
      }
    }
  }

  difference() {
    body();
    holes();
  }
}

module z_carriage() {
  pen_diam = 18;
  z_carriage_plate_pos_y = -z_carriage_rod_dist-z_carriage_plate_thickness/2;
  pen_pos_y = z_carriage_plate_pos_y - pen_diam/2;

  module body() {
    // rod holders
    for(z=[top,bottom]) {
      translate([0,0,z*(z_carriage_height/2-z_wall_thickness/2)]) {
        hull() {
          translate([0,z_carriage_plate_pos_y,0]) {
            // plate side
            cube([z_carriage_width,z_carriage_plate_thickness,z_wall_thickness],center=true);
          }
          translate([0,0,0]) {
            // rod retainer side
            cube([z_carriage_width,z_wall_thickness*2+z_rod_diam,z_wall_thickness],center=true);
          }
        }
      }
    }
    // pen holder
    hull() {
      translate([0,z_carriage_plate_pos_y,0]) {
        cube([z_carriage_width,z_carriage_plate_thickness,z_carriage_height],center=true);
      }
      translate([0,pen_pos_y,0]) {
        hole(pen_diam+z_wall_thickness*3,z_carriage_height,8);
        cube([z_carriage_width,1,z_carriage_height],center=true);
      }
    }
  }

  module holes() {
    for(x=[left,right]) {
      translate([x*z_rod_spacing/2,0,0]) {
        hole(z_rod_diam+0.1,z_carriage_height+0.1,8);
        % hole(z_rod_diam,z_carriage_height+0.1,16);
      }
    }

    // pen cavity
    translate([0,pen_pos_y,0]) {
      linear_extrude(height=z_carriage_height+1,center=true) {
        hull() {
          accurate_circle(pen_diam,8);
          rotate([0,0,45]) {
            translate([pen_diam/4,pen_diam/4]) {
              accurate_circle(pen_diam/2,8);
              // square([pen_diam/2,pen_diam/2],center=true);
            }
          }
        }
      }
    }

    translate([0,0,-5]) {
      // trim excess pen holder
      for(z=[top,bottom]) {
        translate([0,z_carriage_plate_pos_y-z_carriage_plate_thickness/2-20,z*z_carriage_height/2]) {
          cube([z_carriage_width+1,40,z_carriage_height*0.6],center=true);
        }
      }

      // screw hole to retain pen
      translate([0,pen_pos_y-pen_diam/2,0]) {
        rotate([90,0,0]) {
          hole(2.5,pen_diam,8);
        }
      }
    }
  }

  difference() {
    body();
    holes();
  }

  pen_len = 5*inch;
  translate([0,pen_pos_y,pen_len/2-z_carriage_height/2]) {
    % hull() {
      hole(pen_diam, pen_len, 24);
      translate([0,0,-pen_len/2]) {
        hole(0.1,20);
      }
    }
  }
}

module z_axis_lifter() {
  tolerance = 0.2;
  lifter_thickness = 8;
  shaft_hole = z_stepper_shaft_diam + tolerance;
  lifter_len = 20;
  clamp_screw_diam = 3.2;

  lifter_diam = shaft_hole+extrude_width*14;

  module profile() {
    module body() {
      hull() {
        accurate_circle(lifter_diam,32);

        translate([shaft_hole/2+clamp_screw_diam/2,0,0]) {
          square([lifter_diam,lifter_diam],center=true);

          translate([0,-shaft_hole/2-extrude_width*8,0]) {
            square([lifter_diam,6],center=true);
          }
        }

        translate([0,-lifter_len,0]) {
          accurate_circle(extrude_width*8,32);
        }
      }
    }

    module holes() {
      intersection() {
        accurate_circle(shaft_hole,32);
        square([shaft_hole+2,z_stepper_shaft_flat_thickness+tolerance],center=true);
      }

      translate([shaft_hole,0,0]) {
        square([shaft_hole+4,2],center=true);
      }

      translate([shaft_hole/2+clamp_screw_diam/2,-shaft_hole/2-extrude_width*8,0]) {
        square([5.5,3],center=true);
      }
    }

    difference() {
      body();
      holes();
    }
  }

  module body() {
    linear_extrude(height=lifter_thickness,center=true) {
      profile();
    }
  }

  module holes() {
    translate([shaft_hole/2+clamp_screw_diam/2,0,0]) {
      rotate([90,0,0]) {
        hole(clamp_screw_diam,lifter_len*3,8);
      }
    }

    translate([0,0,-lifter_thickness/2]) {
      hole(shaft_hole,2,32);
    }
  }

  difference() {
    body();
    holes();
  }
}

module z_axis_assembly() {
  x_carriage();

  translate([0,z_rod_offset_from_x_carriage,0]) {
    // z_carriage_carrier();
    translate([0,0,0]) {
      color("orange", 0.3) z_carriage();
    }
  }
}

z_axis_assembly();
