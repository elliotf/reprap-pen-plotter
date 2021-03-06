include <config.scad>;
use <lib/util.scad>;
use <lib/vitamins.scad>;
use <pulleys.scad>;

small_diam = 3;
large_diam = motor_mount_wall_thickness;
super_large_diam = plate_anchor_diam;

idler_pulley_pos_y = front*(3+pulley_idler_diam/2);
motor_shaft_pos_y = idler_pulley_pos_y+front*(pulley_idler_diam/2+1+motor_mount_motor_opening/2);

new_filament_drive_shaft_dist = abs(abs(idler_pulley_pos_y) - abs(motor_shaft_pos_y));
new_filament_drive_wall_thickness = motor_mount_wall_thickness;

rel_y_rail_pos_x = y_rail_pos_x - motor_pos_x;

idler_pulley_pos_z = motor_line_pos_z - groove_height - groove_depth;
driver_pulley_pos_z = idler_pulley_pos_z + (groove_height/2 + groove_depth);
motor_pos_z = driver_pulley_pos_z - 2 - nema17_shoulder_height;

overall_width = motor_mount_motor_opening + motor_mount_wall_thickness*2;
overall_height = motor_pos_z;

extrusion_mount_width = 5+wall_thickness*4+small_diam*2;
extrusion_mount_height = y_rail_pos_z+y_rail_extrusion_height/2;
extrusion_mount_thickness = wall_thickness*4;

clamp_gap_width = 17;
clamp_mount_thickness = 5;

allot_space_y_for_motor_mount = abs(motor_shaft_pos_y) + motor_mount_motor_opening/2 + large_diam + plate_anchor_diam + 10;

idler_body_width = abs(idler_pulley_pos_y) + rel_y_rail_pos_x + y_rail_extrusion_width/2;
idler_body_depth = abs(idler_pulley_pos_y)*2;

rel_center_x = -motor_pos_x;
rel_center_z = 0;

module position_anchor_inside_extrusion() {
  translate([-overall_width/2+plate_anchor_diam/2,idler_pulley_pos_y,0]) {
    children();
  }
}

module position_anchor_outside_extrusion() {
  translate([rel_y_rail_pos_x+y_rail_extrusion_width/2+plate_anchor_diam/2,idler_pulley_pos_y,0]) {
    children();
  }
}

module position_anchor_by_motor_clamp() {
  translate([clamp_gap_width/2+clamp_mount_thickness+plate_anchor_diam/2,motor_shaft_pos_y-motor_mount_motor_opening/2-motor_mount_wall_thickness-plate_anchor_diam/2,0]) {
    children();
  }
}

module position_motor_mount_anchor_holes() {
  position_anchor_inside_extrusion() {
    children();
  }
  position_anchor_outside_extrusion() {
    children();
  }

  position_anchor_by_motor_clamp() {
    children();
  }
}

module motor_mount(side) {
  module position_extrusion_mount() {
    translate([rel_y_rail_pos_x+left*(y_rail_extrusion_width/2+extrusion_mount_thickness/2),extrusion_mount_width/2,0]) {
      children();
    }
  }

  translate([0,100,120]) {
    // color("pink") profile();
  }

  module profile() {

    module body() {
      // main motor body
      translate([0,motor_shaft_pos_y,0]) {
        rounded_square(overall_width,overall_width,large_diam);
      }

      // area around idler shaft
      translate([0,-pulley_idler_diam/2,0]) {
        accurate_circle(pulley_idler_diam,resolution);
      }
      // outside of idler mount
      translate([0,-idler_body_depth/2-pulley_idler_diam/2,0]) {
        square([pulley_idler_diam,idler_body_depth],center=true);
      }
      // inside of idler mount
      translate([-abs(idler_pulley_pos_y),,0]) {
        translate([idler_body_width/4,-idler_body_depth/2,0]) {
          rounded_square(idler_body_width/2,idler_body_depth,large_diam);
        }
      }

      translate([0,motor_shaft_pos_y+overall_width/2,0]) {
        translate([-abs(idler_pulley_pos_y),0,0]) {
          rotate([0,0,90]) {
            round_corner_filler_profile(super_large_diam,resolution);
          }
        }
        translate([pulley_idler_diam/2,0,0]) {
          round_corner_filler_profile(super_large_diam,resolution);
        }
      }

      // avoid gap between rounded shapes of profile and extrusion mount
      position_extrusion_mount() {
        translate([0,-extrusion_mount_width/2,0]) {
          square([extrusion_mount_thickness,10],center=true);
        }
      }

      // motor clamp stuffs
      for(x=[left,right]) {
        translate([x*(clamp_gap_width/2+clamp_mount_thickness/2),motor_shaft_pos_y-motor_mount_motor_opening/2-motor_mount_wall_thickness,0]) {
          square([clamp_mount_thickness,large_diam],center=true);
          translate([x*(clamp_mount_thickness/2),0,0]) {
            rotate([0,0,-135+x*45]) {
              round_corner_filler_profile(large_diam,resolution);
            }
          }
        }
      }
    }

    module holes() {
      translate([0,motor_shaft_pos_y,0]) {
        square([motor_mount_motor_opening,motor_mount_motor_opening],center=true);

        translate([0,-motor_mount_motor_opening/2,0]) {
          square([clamp_gap_width,motor_mount_motor_opening],center=true);
        }
      }

      // round off clamp opening
      for(x=[left,right]) {
        translate([x*(clamp_gap_width/2),motor_shaft_pos_y-motor_mount_motor_opening/2,0]) {
          rotate([0,0,-135+x*45]) {
            round_corner_filler_profile(large_diam,resolution);
          }
        }
      }
    }

    difference() {
      body();
      holes();
    }
  }

  module body() {
    translate([0,0,overall_height/2]) {
      linear_extrude(height=motor_pos_z,convexity=3,center=true) {
        profile();
      }
    }

    module blocks_around_extrusion(going_up_to_y,height) {
      width = y_rail_extrusion_width + extrusion_mount_thickness;
      hull() {
        translate([rel_y_rail_pos_x+y_rail_extrusion_width/2-width/2,0,height/2]) {
          translate([0,motor_shaft_pos_y+overall_width/2,0]) {
            cube([width,motor_mount_wall_thickness,height],center=true);
          }
          translate([0,going_up_to_y-small_diam/2,0]) {
            rounded_cube(width,small_diam,height,small_diam);
          }
        }
      }
    }

    higher_block_height = y_rail_dist_above_plate+15;
    blocks_around_extrusion(0,higher_block_height);
    blocks_around_extrusion(extrusion_mount_width,y_rail_dist_above_plate);
    translate([rel_y_rail_pos_x+y_rail_extrusion_width/2,motor_shaft_pos_y+overall_width/2,higher_block_height/2]) {
      round_corner_filler(super_large_diam,higher_block_height);
    }

    position_extrusion_mount() {
      height = y_rail_dist_above_plate+y_rail_extrusion_height;
      translate([0,0,height/2]) {
        rounded_cube(extrusion_mount_thickness,extrusion_mount_width,height,small_diam);
      }
    }

    // anchor to plate by extrusion
    hull() {
      translate([0,0,plate_anchor_thickness/2]) {
        translate([rel_y_rail_pos_x-extrusion_mount_thickness/2,extrusion_mount_width/2,0]) {
          rounded_cube(y_rail_extrusion_width+extrusion_mount_thickness,extrusion_mount_width,plate_anchor_thickness,small_diam);
        }
        position_anchor_inside_extrusion() {
          hole(plate_anchor_diam,plate_anchor_thickness,resolution);
        }
        position_anchor_outside_extrusion() {
          hole(plate_anchor_diam,plate_anchor_thickness,resolution);
        }

        translate([0,motor_shaft_pos_y+overall_width/2,0]) {
          cube([overall_width,motor_mount_wall_thickness,plate_anchor_thickness],center=true);
        }
      }
    }

    // anchor to plate by clamp
    hull() {
      translate([0,0,plate_anchor_thickness/2]) {
        translate([overall_width/2,motor_shaft_pos_y-motor_mount_motor_opening/2-motor_mount_wall_thickness,0]) {
          motor_mount_portion_width = (overall_width - clamp_gap_width) / 2;
          translate([-motor_mount_portion_width/2,0,0]) {
            rounded_cube(motor_mount_portion_width,motor_mount_wall_thickness*2,plate_anchor_thickness,motor_mount_wall_thickness);
          }
        }
        position_anchor_by_motor_clamp() {
          hole(plate_anchor_diam,plate_anchor_thickness,resolution);
        }
      }
    }

    // clamp
    for(x=[left,right]) {
      hull() {
        translate([x*(clamp_gap_width/2+clamp_mount_thickness/2),motor_shaft_pos_y-motor_mount_motor_opening/2-motor_mount_wall_thickness/2,overall_height/2]) {
          translate([0,-motor_mount_wall_thickness/2,0]) {
            rounded_cube(clamp_mount_thickness,motor_mount_wall_thickness*2,overall_height,motor_mount_wall_thickness);
          }

          translate([0,front*(motor_mount_wall_thickness+m3_nut_max_diam+motor_mount_wall_thickness),0]) {
            rounded_cube(clamp_mount_thickness,motor_mount_wall_thickness,m3_nut_max_diam+motor_mount_wall_thickness*2,motor_mount_wall_thickness);
          }
        }
      }
    }
  }

  module holes() {
    // avoid rounded corner interference
    corner_cavity_diam = 2;
    position_extrusion_mount() {
      translate([extrusion_mount_thickness/2,-extrusion_mount_width/2,overall_height/2+y_rail_dist_above_plate]) {
        hull() {
          hole(corner_cavity_diam,overall_height,16);
          rotate([0,0,45]) {
            translate([10,0,0]) {
              cube([20,corner_cavity_diam,overall_height],center=true);
            }
          }
        }
      }
    }

    // idler shaft
    translate([0,idler_pulley_pos_y,overall_height/2]) {
      hole(pulley_idler_bearing_id+tolerance, overall_height+1, 8);
    }

    // screw holes to bolt to extrusion
    position_extrusion_mount() {
      translate([0,0,y_rail_dist_above_plate+y_rail_extrusion_height/2]) {
        for(z=[top,bottom]) {
          translate([0,0,10*z]) {
            rotate([0,90,0]) {
              hole(m5_loose_hole,20,8);
            }
          }
        }
      }
    }

    // clamp screw/nut
    translate([0,motor_shaft_pos_y-motor_mount_motor_opening/2-motor_mount_wall_thickness*1.5-m3_nut_max_diam/2,overall_height/2]) {
      rotate([0,90,0]) {
        for(side=[left,right]) {
          translate([0,0,side*(clamp_gap_width/2+clamp_mount_thickness)]) {
            nut_cavity_depth = 2;
            hole(m3_nut_diam,nut_cavity_depth*2,6);
          }
        }
        hole(m3_loose_hole,overall_width,8);
      }
    }

    position_motor_mount_anchor_holes() {
      hole(plate_anchor_screw_hole_diam,plate_anchor_thickness*2+1,resolution);
    }

    // endstop mount
    if (side == right) {
      translate([rel_y_rail_pos_x+y_rail_extrusion_width/2+mech_endstop_tiny_width/2,extrusion_mount_width+1,plate_anchor_thickness+mech_endstop_tiny_length/2+0.5]) {
        rotate([-90,0,0]) {
          % mech_endstop_tiny();
          position_mech_endstop_tiny_mount_holes() {
            hole(m2_threaded_insert_diam,mech_endstop_tiny_width+5*2);
          }
        }
      }
    }

    translate([rel_y_rail_pos_x+y_rail_extrusion_width/2,idler_pulley_pos_y,y_rail_dist_above_plate]) {
      rotate([90,0,0]) {
        rotate([0,0,-90]) {
          zip_tie_cavity(wall_thickness*4,zip_tie_thickness,zip_tie_width);
        }
      }
    }
  }

  echo("rel_center_x: ", rel_center_x);
  echo("motor_pos_x: ", motor_pos_x);
  translate([rel_center_x,idler_pulley_pos_y+50,rel_center_z]) {
    translate([x_line_pos_x,0,x_line_pos_z]) {
      % color(lineColorForSide(side)) cube([1,100,1],center=true);
    }
    translate([motor_line_pos_x,0,motor_line_pos_z]) {
      % color(lineColorForSide(side)) cube([1,100,1],center=true);
    }
  }

  translate([0,idler_pulley_pos_y,idler_pulley_pos_z]) {
    % hole(pulley_idler_bearing_id, motor_len*2, 32);
    % idler_pulley();
  }

  translate([0,motor_shaft_pos_y,0]) {
    translate([0,0,driver_pulley_pos_z]) {
      % driver_pulley();
    }

    translate([0,0,motor_pos_z]) {
      % motor_nema17();

      translate([0,0,motor_shaft_len-0.5]) {
        % color("silver") hole(625_bearing_od-0.5, 625_bearing_thickness, 16);
      }
    }
  }

  difference() {
    body();
    holes();
  }

  translate([0,motor_shaft_pos_y,motor_pos_z+0.1]) {
    % color("lightblue") motor_mount_brace();
  }
}

module motor_mount_brace() {
  body_height = 10;
  brace_pos_z = motor_shaft_len -625_bearing_thickness/2 + 1.5 + body_height/2;
  overall_height = brace_pos_z + body_height/2;

  module body() {
    translate([0,0,brace_pos_z]) {
      hull() {
        hole(625_bearing_od+new_filament_drive_wall_thickness*2, body_height, 16);

        // FIXME: make room for bolt/screw head
        translate([0,new_filament_drive_shaft_dist,0]) {
          hole(pulley_idler_bearing_id+new_filament_drive_wall_thickness*3, body_height, 16);
        }

        for(side=[front,rear]) {
          translate([-motor_hole_spacing/2,motor_hole_spacing/2*side,0]) {
            hole(6+new_filament_drive_wall_thickness*2, body_height, 16);
          }
        }
      }
    }

    hull() {
      for(side=[front,rear]) {
        translate([-motor_hole_spacing/2,motor_hole_spacing/2*side,motor_shaft_len/2]) {
          hole(6+new_filament_drive_wall_thickness*2, motor_shaft_len, 16);
        }
      }
    }
  }

  module holes() {
    translate([0,new_filament_drive_shaft_dist,0]) {
      hole(pulley_idler_bearing_id+0.2, motor_len*3);
    }

    translate([0,0,motor_shaft_len]) {
      hole(625_bearing_od, 625_bearing_thickness, 16);
      hole(625_bearing_od-2, motor_shaft_len*2, 16);
    }

    hole(motor_shoulder_diam+8, (brace_pos_z-body_height/2)*2, 32);

    for(side=[front,rear]) {
      translate([-motor_hole_spacing/2,motor_hole_spacing/2*side,-0.5]) {
        hole(m3_loose_hole, 20, 16);
      }
      translate([-motor_hole_spacing/2,motor_hole_spacing/2*side,motor_shaft_len+10]) {
        hole(6, motor_shaft_len*2, 16);
      }
    }
  }

  translate([0,0,motor_shaft_len]) {
    // % hole(625_bearing_od, 625_bearing_thickness, 16);
  }

  difference() {
    body();
    holes();
  }
}
