include <main.scad>;

sample_len = 90;
sample_x_rail_len = 60;

sample_motor_pos_z = y_rail_pos_z - y_rail_extrusion_width/2 + nema17_len;
filament_motor_mount_dist_to_extrusion = 2;
sample_motor_pos_y = front*(nema17_side/2+filament_motor_mount_dist_to_extrusion);

x_rail_pos_z = y_rail_pos_z-10+printed_carriage_extrusion_carriage_gap;
x_rail_pos_x = 0;
sample_y_rail_pos_x = sample_x_rail_len/2 + 3 + y_rail_extrusion_height/2;
sample_motor_pos_x = sample_y_rail_pos_x-y_rail_extrusion_height/2+nema17_side/2;

filament_dist_from_motor_x = pulley_idler_diam/2+line_thickness/2;
filament_idler_dist_from_motor_z = nema17_shoulder_height + 3 - groove_height/2 - groove_depth;
filament_inner_dist_from_motor_z = filament_idler_dist_from_motor_z+groove_depth*2+groove_height/2;
filament_outer_dist_from_motor_z = filament_inner_dist_from_motor_z+idler_top_bottom_groove_dist;

filament_inner_pos_z = sample_motor_pos_z+filament_inner_dist_from_motor_z;
filament_outer_pos_z = sample_motor_pos_z+filament_outer_dist_from_motor_z;

translate([0,0,100]) {
  // y_carriage();
}

module y_carriage() {
  y_carriage_x_rail_offset_z = y_rail_pos_z-x_rail_pos_z;
  y_carriage_x_rail_offset_x = sample_y_rail_pos_x-sample_x_rail_len/2;
  dist_from_x_rail_end = y_carriage_x_rail_offset_x - y_rail_extrusion_height/2;

  rel_pos_to_motor_x = sample_motor_pos_x - sample_x_rail_len/2;

  width = y_carriage_x_rail_offset_x - printed_carriage_extrusion_carriage_gap;
  height = 40 - printed_carriage_extrusion_carriage_gap*2;
  length = x_rail_extrusion_width + 5;
  resolution = 16;

  bushing_from_edge_of_extrusion = ptfe_diam/2+1;
  // bushing_pos_z = length/2;
  bushing_pos_z = length/2-x_carriage_bushing_len/2-bushing_from_edge_of_extrusion;

  rel_to_origin_z = bottom*(x_rail_pos_z + y_carriage_x_rail_offset_z);

  line_bearing_shaft_body_diam = 2*(sample_motor_pos_x - pulley_idler_diam/2 - line_thickness - line_bearing_diam/2 - sample_x_rail_len/2);

  module position_line_bearing() {
    translate([-width/2+rel_pos_to_motor_x-filament_dist_from_motor_x-line_thickness/2-line_bearing_diam/2,rel_to_origin_z+filament_inner_pos_z,0]) {
      children();
    }
  }

  module carriage_profile() {
    square([width,height],center=true);

    for(y=[top,bottom]) {
      translate([dist_from_x_rail_end/2+printed_carriage_extrusion_carriage_gap/2,y*(height/2),0]) {
        // top/bottom stick-out things
        translate([0,0,0]) {
          hull() {
            translate([0,y*v_slot_width/2,0]) {
              square([0.001,0.001],center=true);
            }
            translate([0,-y*1,0]) {
              square([v_slot_width,2],center=true);
            }
          }
        }
      }

      // outside stick-out things
      translate([width/2,10,0]) {
        hull() {
          translate([v_slot_width/2,0]) {
            square([0.001,0.001],center=true);
          }
          translate([-1,0]) {
            square([2,v_slot_width],center=true);
          }
        }
      }
    }
  }

  module body() {
    linear_extrude(height=length,center=true,convexity=2) {
      carriage_profile();
    }
    position_line_bearing() {
      translate([0,-1*(rel_to_origin_z+filament_inner_pos_z),length/2+line_bearing_inner]) {
        rotate([90,0,0]) {
          hole(line_bearing_shaft_body_diam,height,16);
        }
        translate([0,0,-line_bearing_shaft_body_diam/2]) {
          cube([line_bearing_shaft_body_diam,height,line_bearing_shaft_body_diam],center=true);
        }
      }
    }
  }

  module pokey_out_holes() {
    for(side=[left,right]) {
      translate([0,side*(-v_slot_width/2-printed_carriage_extrusion_carriage_gap),0]) {
        rotate([0,0,side*-45]) {
          translate([-ptfe_diam/2+ptfe_bushing_preload_amount,side*(ptfe_diam/2+0.5),0]) {
            # hole(ptfe_diam,x_carriage_bushing_len,resolution);
          }
        }
      }
    }
  }

  module holes() {
    for(z=[front,rear]) {
      // top/bottom bushing holes
      translate([dist_from_x_rail_end/2,0,0]) {
        for(y=[top,bottom]) {
          translate([0,y*(x_rail_extrusion_width/2),z*(bushing_pos_z)]) {
            for(x=[left]) {
              translate([x*(x_rail_extrusion_height/4+ptfe_diam/2),y*(-ptfe_diam/2+ptfe_bushing_preload_amount),0]) {
                hole(ptfe_diam,x_carriage_bushing_len,resolution);
              }
            }

            translate([printed_carriage_extrusion_carriage_gap/2,y*(-printed_carriage_extrusion_carriage_gap),0]) {
              rotate([0,0,y*90]) {
                pokey_out_holes();
              }
            }
          }
        }
      }

      // bushings to keep carriage from popping off
      translate([dist_from_x_rail_end/2+x_rail_extrusion_height/2-printed_carriage_extrusion_carriage_gap/2,x_rail_extrusion_height/2,z*bushing_pos_z]) {
        pokey_out_holes();
      }

      for(y=[ptfe_diam/2]) {
        translate([width/2-printed_carriage_extrusion_carriage_gap/2+ptfe_bushing_preload_amount,y,z*bushing_pos_z]) {
          hole(ptfe_diam,x_carriage_bushing_len,resolution);
        }
      }

      translate([width/2,-y_carriage_x_rail_offset_z,0]) {
        // x_rail screws/bolts
        if (abs(z)) {
          translate([0,0,10*z]) {
            rotate([0,90,0]) {
              hole(extrusion_screw_hole,100,8);
              hole(10,10,8);
            }
          }
        }

        // bushings on either side of bolt holes
      }
    }

    // line bearings
    position_line_bearing() {
      translate([0,0,length/2+line_bearing_inner]) {
        rotate([90,0,0]) {
          hole(line_bearing_diam+4,line_bearing_thickness+2,resolution);
          hole(line_bearing_inner+1,height*2,8);
          color("magenta", 0.5) % hole(line_bearing_diam,line_bearing_thickness,resolution);
        }

        translate([-line_bearing_diam/2,0,0]) {
          cube([line_bearing_diam,line_bearing_thickness+2,line_bearing_diam+4],center=true);
        }
      }

      translate([0,0,0]) {
        rotate([90,0,0]) {
          hole(line_bearing_diam+4,line_bearing_thickness+2,resolution);
          hole(line_bearing_inner+1,height*2,8);
          color("magenta", 0.5) % hole(line_bearing_diam,line_bearing_thickness,resolution);
        }

        translate([-line_bearing_diam/2,0,0]) {
          cube([line_bearing_diam,line_bearing_thickness+2,line_bearing_diam+4],center=true);
        }
      }
    }
    /*
    translate([-width/2+rel_pos_to_motor_x-filament_dist_from_motor_x-line_thickness/2-line_bearing_diam/2,rel_to_origin_z+filament_inner_pos_z+line_bearing_thickness/2+0.5,0]) {
      for(side=[top,bottom]) {
        translate([0,side*(0.5+line_bearing_thickness/2),0]) {
          rotate([90,0,0]) {
            % hole(line_bearing_diam,line_bearing_thickness,resolution);
          }
          translate([0,0,0]) {
          }
        }
      }
      rotate([90,0,0]) {
        hole(line_bearing_diam+3,line_bearing_thickness*2+3,resolution);
        hole(line_bearing_inner+1,height*2,8);
      }

      translate([-line_bearing_diam/2,0,0]) {
        cube([line_bearing_diam,line_bearing_thickness*2+3,line_bearing_diam+3],center=true);
      }
    }
    */
  }

  translate([width/2,y_carriage_x_rail_offset_z,0]) {
    difference() {
      body();
      holes();
    }
  }
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

module filament_motor_mount_base() {
  mount_base_thickness = nema17_shoulder_height + 1;
  extrusion_relative_to_motor_z = y_rail_pos_z - sample_motor_pos_z;
  mount_height = extrusion_relative_to_motor_z + y_rail_extrusion_width/2;
  motor_screw_head_diam = 6.5;
  rounded_diam = (nema17_side-nema17_hole_spacing)/2;

  module motor_mount_profile() {
    difference() {
      hull() {
        translate([0,rear*nema17_side/2-1+filament_motor_mount_dist_to_extrusion,0]) {
          //square([nema17_side,2],center=true);
        }

        for(x=[left,right]) {
          for(y=[front*(nema17_side/2-rounded_diam/2),rear*(nema17_side/2-rounded_diam/2+filament_motor_mount_dist_to_extrusion)]) {
            translate([x*(nema17_side/2-rounded_diam/2),y,0]) {
              accurate_circle(rounded_diam,32);
            }
          }
        }

        translate([0,front*(filament_driver_idler_dist),0]) {
          accurate_circle(pulley_idler_diam,32);
        }
      }

    }
  }

  module motor_mount_cavity_profile() {
    hull() {
      for(x=[left,right]) {
        translate([x*(nema17_hole_spacing/2),nema17_hole_spacing/2,0]) {
          accurate_circle(motor_screw_head_diam,32);
        }
      }

      translate([0,front*filament_driver_idler_dist,0]) {
        square([nema17_hole_spacing+motor_screw_head_diam,pulley_idler_diam+10],center=true);
      }
    }
  }

  module extrusion_hole_profile() {
  }

  module body() {
    translate([0,0,mount_height/2]) {
      linear_extrude(height=mount_height,center=true,convexity=2) {
        motor_mount_profile();
      }
    }
  }

  module holes() {
    // extrusion mounting holes
    translate([sample_y_rail_pos_x-sample_motor_pos_x,rear*(nema17_side/2),extrusion_relative_to_motor_z]) {
      for(pos=[[10,0,10],[10,0,30],[-10,0,30]]) {
        translate(pos) {
          rotate([90,0,0]) {
            hole(extrusion_screw_hole,nema17_side,8);

            translate([0,0,nema17_side/2+10]) {
              hole(8,nema17_side,16);
            }
          }
        }
      }
    }

    // motor mounting holes
    for(x=[left,right]) {
      for(y=[front,rear]) {
        translate([x*(nema17_hole_spacing/2),y*(nema17_hole_spacing/2),0]) {
          hole(3.2,nema17_len*2,16);
        }
      }
    }
    // motor shoulder
    hole(nema17_shoulder_diam+2,nema17_len*2,32);

    // filament path
    translate([left*(filament_dist_from_motor_x),0,filament_inner_dist_from_motor_z]) {
      rotate([90,0,0]) {
        hole(3,nema17_side*2,16);
      }
    }
    translate([right*(filament_dist_from_motor_x),0,filament_outer_dist_from_motor_z]) {
      rotate([90,0,0]) {
        hole(3,nema17_side*2,16);
      }
    }

    // make driver/idler accessible
    translate([0,0,mount_base_thickness+50]) {
      linear_extrude(height=100,center=true,convexity=2) {
        motor_mount_cavity_profile();
      }
    }
    hull() {
      translate([0,front*(nema17_side/2+10),mount_height]) {
        cube([nema17_side+10,20,(mount_height-mount_base_thickness)*2],center=true);
      }
      translate([0,rear*(nema17_hole_spacing/2),mount_height+1]) {
        cube([nema17_side+10,motor_screw_head_diam,2],center=true);
      }
    }
  }

  difference() {
    body();
    holes();
  }
}

translate([sample_y_rail_pos_x,sample_len/2,y_rail_pos_z]) {
  rotate([90,0,0]) {
    rotate([0,0,90]) {
      color("silver") extrusion_cbeam(sample_len);
    }
  }

  translate([0,-20,70]) {
    y_carriage();
  }
}

translate([x_rail_pos_x,sample_len/2,x_rail_pos_z]) {
  translate([-x_carriage_width/2,0,0]) {
    % x_carriage();
  }
  rotate([0,0,90]) {
    rotate([90,0,0]) {
      color("silver") extrusion_2040(sample_x_rail_len);
    }
  }

  translate([sample_x_rail_len/2,0,0]) {
    rotate([90,0,]) {
      y_carriage();
    }
  }
}

filament_driver_idler_dist = pulley_idler_bearing_id/2+wall_thickness+nema17_side/2;

translate([sample_motor_pos_x,sample_motor_pos_y,sample_motor_pos_z]) {
  % motor_nema17();

  filament_motor_mount_base();
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


translate([0,0,80]) {
  // y_carriage_assembly();
}
