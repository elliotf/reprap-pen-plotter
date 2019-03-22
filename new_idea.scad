include <main.scad>;

sample_len = 90;
sample_x_rail_len = 60;

sample_motor_pos_z = y_rail_pos_z - y_rail_extrusion_width/2 + nema17_len;
filament_motor_mount_dist_to_extrusion = 2;
sample_motor_pos_y = front*(nema17_side/2+filament_motor_mount_dist_to_extrusion);

sample_y_rail_pos_x = sample_x_rail_len/2 + 3 + y_rail_extrusion_height/2;
sample_motor_pos_x = sample_y_rail_pos_x-y_rail_extrusion_height/2+nema17_side/2;

filament_dist_from_motor_x = pulley_idler_diam/2+line_thickness/2;
filament_idler_dist_from_motor_z = nema17_shoulder_height + 3 - groove_height/2 - groove_depth;
filament_inner_dist_from_motor_z = filament_idler_dist_from_motor_z+groove_depth*2+groove_height/2;
filament_outer_dist_from_motor_z = filament_inner_dist_from_motor_z+idler_top_bottom_groove_dist;

filament_inner_pos_z = sample_motor_pos_z+filament_inner_dist_from_motor_z;
filament_outer_pos_z = sample_motor_pos_z+filament_outer_dist_from_motor_z;

sample_x_rail_height = 20;
sample_x_rail_width = 40;
sample_y_rail_height = 40;
sample_y_rail_width = 20;
sample_y_rail_x_rail_dist = ptfe_diam + extrude_width*4;
sample_y_rail_pos_z = sample_y_rail_height/2;
sample_x_rail_pos_z = sample_y_rail_pos_z + sample_y_rail_height/2 + sample_x_rail_height/2 + sample_y_rail_x_rail_dist;

line_bearing_pos_y = sample_x_rail_width/2+line_bearing_inner/2+extrude_width*4;

translate([0,0,100]) {
  // y_carriage();
}

module y_carriage() {
  thickness = ptfe_diam + extrude_width*4 - printed_carriage_extrusion_carriage_gap;

  module body_profile() {
    width = sample_y_rail_width + printed_carriage_extrusion_carriage_gap*2 + thickness*2;
    for(side=[left,right]) {
      translate([side*(sample_y_rail_width/2+printed_carriage_extrusion_carriage_gap+thickness/2),0,0]) {
        square([thickness,10], center=true);
      }
    }

    translate([0,sample_y_rail_width/2+printed_carriage_extrusion_carriage_gap+thickness/2,0]) {
      square([width,thickness], center=true);
    }
  }

  module body() {
    rotate([90,0,0]) {
      linear_extrude(height=sample_x_rail_width,center=true,convexity=2) {
        body_profile();
      }
    }
  }


  for(side=[front,rear]) {
    translate([0,side*line_bearing_pos_y,sample_y_rail_width/2+printed_carriage_extrusion_carriage_gap+thickness+sample_x_rail_height/2]) {
      line_bearing(32);
    }
  }

  module holes() {
    ptfe_from_corner = 0.5;
    for(side=[left,right]) {
      translate([(sample_y_rail_width/2+ptfe_diam/2)*side,0,0]) {
        // top/sides
        translate([0,0,sample_y_rail_width/2+ptfe_diam/2]) {
          translate([0,0,-(ptfe_diam+ptfe_from_corner)]) {
            rotate([90,0,0]) {
              # hole(ptfe_diam,sample_x_rail_len,16);
            }
          }
          translate([-side*(ptfe_diam+ptfe_from_corner),0,0]) {
            rotate([90,0,0]) {
              # hole(ptfe_diam,sample_x_rail_len,16);
            }
          }
        }

        // angled, to keep y carriage from popping off
        translate([-side*(v_slot_depth/2+ptfe_diam/2),0,(9.5-v_slot_depth)/2]) {
          rotate([90,0,0]) {
            rotate([0,0,side*45]) {
              translate([0,-ptfe_diam/2,0]) {
                # hole(ptfe_diam,sample_x_rail_len,16);
              }
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

module line_bearing(resolution=16) {
  module profile() {
    difference() {
      translate([line_bearing_diam/4,0]) {
        square([line_bearing_diam/2,line_bearing_thickness], center=true);
      }
      translate([line_bearing_inner/4,0]) {
        square([line_bearing_inner/2,line_bearing_thickness+1], center=true);
      }

      // groove
      translate([line_bearing_diam/2,0,0]) {
        rotate([0,0,0]) {
          accurate_circle(1,6);
        }
      }
    }
  }

  rotate_extrude(convexity=3,$fn=resolution) {
    profile();
  }

  // hole(line_bearing_diam,line_bearing_thickness,resolution);
  // hole(line_bearing_inner,line_bearing_thickness+1,resolution);
}

module filament_motor_mount_top() {
  module body() {
  }

  module holes() {
  }

  difference() {
    body();
    holes();
  }
}

translate([sample_y_rail_pos_x,sample_x_rail_len/2,sample_y_rail_pos_z]) {
  rotate([90,0,0]) {
    rotate([0,0,90]) {
      color("silver") extrusion_2040(sample_x_rail_len);
    }
  }

  translate([0,0,sample_y_rail_height/4]) {
    y_carriage();
  }
}

translate([0,sample_x_rail_len/2,sample_x_rail_pos_z]) {
  rotate([0,0,90]) {
    rotate([90,0,0]) {
      color("silver") extrusion_2040((sample_y_rail_pos_x+20)*2);
    }
  }
}

filament_driver_idler_dist = pulley_idler_bearing_id/2+wall_thickness+nema17_side/2;

if (0) {
  translate([sample_motor_pos_x,sample_motor_pos_y,sample_motor_pos_z]) {
    % motor_nema17();

    translate([0,0,0]) { // TODO: translate to make it at the top of the shaft
      rotate([0,180,0]) {
        # filament_motor_mount_top();
      }
    }

    translate([0,0,filament_idler_dist_from_motor_z]) {
      translate([0,front*(filament_driver_idler_dist),0]) {
        idler_pulley();
        % hole(pulley_idler_bearing_id,nema17_len,32);
      }

      translate([0,0,groove_height/2+groove_depth]) {
        driver_pulley();
      }
    }
  }
}


translate([0,0,80]) {
  // y_carriage_assembly();
}
