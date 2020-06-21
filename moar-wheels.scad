include <config.scad>;
use <sketch-for-simpler.scad>;
use <z-axis-mount.scad>;
use <lib/vitamins.scad>;

belt_above_extrusion = 12;

belt_width = 6;
pulley_diam = gt2_16t_pulley_diam;

bevel_height = 2;

translate([0,0,20+mini_v_wheel_plate_thickness+mini_v_wheel_plate_above_extrusion]) {
  translate([0,-10,0]) {
    rotate([90,0,0]) {
      rotate([0,0,90]) {
        // module mini_v_wheel_plate(extrusion_width=20,wheel_spacing_y=10+20+wall_thickness*4)
        mini_v_wheel_plate(40);
      }
    }
  }

  rotate([0,90,0]) {
    color("silver", 0.3) extrusion_2040(y_rail_len+50);
  }
}
for(x=[left,right]) {
  translate([x*x_rail_len/2,0,0]) {
    mirror([x-1,0,0]) {
      translate([0,0,mini_v_wheel_plate_above_extrusion]) {
        mini_v_wheel_plate();
      }
    }

    % translate([0,0,-20]) {
      rotate([90,0,0]) {
        rotate([0,0,90]) {
          color("silver", 0.3) extrusion_2040(y_rail_len);
        }
      }
    }

    /*
    % for(y=[front,rear]) {
      translate([0,y*(y_rail_len/2+motor_side/2),mini_v_wheel_belt_above_extrusion-pulley_diam/2]) {
        rotate([0,90,0]) {
          // hole(pulley_diam,belt_width,resolution);
        }
        for(z=[top,bottom]) {
          translate([0,-y*(y_rail_len/4),z*(pulley_diam/2)]) {
            cube([belt_width,y_rail_len/2,1],center=true);
            if (z < 0) {
              rotate([0,90,0]) {
                cube([belt_width,y_rail_len/2,1],center=true);
              }
            }
          }
        }
      }
    }
    */
  }

  mirror([0,0,0]) {
    translate([x_rail_len/2,-y_rail_len/2,-40/2]) {
      motor_mount();
    }
    translate([x_rail_len/2,y_rail_len/2,-40/2]) {
      idler_mount();
    }
  }
}


module motor_mount() {
  large_idler_diam = 16; // F625 bearing
  large_idler_width = 10; // F625 bearing doubled up

  small_idler_diam = 10; // MR105 bearing
  small_idler_width = 8; // MR105 bearing doubled up

  top_idler_diam = small_idler_diam;
  top_idler_width = small_idler_width;

  bottom_idler_diam = small_idler_diam;
  bottom_idler_width = small_idler_width;

  motor_pos_x = left*(20/2+nema17_shoulder_height+3);
  motor_pos_y = front*(motor_side/2);
  //motor_pos_z = top_idler_pos_z - (abs(top_idler_pos_z - bottom_idler_pos_z)/2)-5;
  motor_pos_z = -40/2+10+m5_loose_hole/2+extrude_width*4+m3_loose_hole/2+nema17_hole_spacing/2;

  //top_idler_pos_z = 40/2+mini_v_wheel_belt_above_extrusion - top_idler_diam/2 + 4;
  //top_idler_pos_z = motor_pos_z+nema17_hole_spacing/2 + 1;
  top_idler_pos_z = 20+belt_above_extrusion - top_idler_diam/2;
  //top_idler_pos_z = 40/2+mini_v_wheel_belt_above_extrusion -5 - top_idler_diam/2;
  //bottom_idler_pos_z = bottom_idler_diam/2;
  bottom_idler_pos_z = motor_pos_z - nema17_hole_spacing/2 + bottom_idler_diam/2 + m3_loose_hole/2 + wall_thickness*2 + 3;

  echo("top_idler_pos_z + top_idler_diam/2: ", top_idler_pos_z + top_idler_diam/2);

  idler_pos_y = motor_pos_y + front*(motor_side/2 + top_idler_diam/2 + 1);

  overall_depth = abs(idler_pos_y) + m5_thread_into_plastic_hole_diam/2 + wall_thickness*2;
  overall_height = 40/2+motor_pos_z + nema17_side/2;
  overall_thickness = 20/2 + abs(motor_pos_x);

  screw_body_overhead = m3_loose_hole + wall_thickness*4;
  extrusion_mount_thickness = screw_body_overhead/2+(abs(motor_pos_y)-nema17_hole_spacing/2);
  extrusion_mount_rounded_diam = screw_body_overhead/2;

  bottom_belt_pos_z = bottom_idler_pos_z - bottom_idler_diam/2;

  motor_plate_thickness = abs(motor_pos_x) - top_idler_width/2 - bevel_height;

  idler_shaft_diam = m5_loose_hole;
  idler_shaft_body_diam = idler_shaft_diam+wall_thickness*4;

  module motor_plate_profile() {
    hull() {
      // idlers
      translate([idler_pos_y,0]) {
        translate([0,top_idler_pos_z,0]) {
          accurate_circle(idler_shaft_body_diam,resolution);
        }
        translate([0,bottom_idler_pos_z,0]) {
          accurate_circle(idler_shaft_body_diam,resolution);
        }
      }
      // motor screw mounts
      translate([motor_pos_y-nema17_hole_spacing/2,motor_pos_z,0]) {
        for(z=[top,bottom]) {
          translate([0,z*nema17_hole_spacing/2,]) {
            accurate_circle(screw_body_overhead,resolution);
          }
        }
      }
    }
    translate([motor_pos_y,motor_pos_z,0]) {
      for(z=[top,bottom]) {
        translate([-nema17_hole_spacing/2+screw_body_overhead/2,z*(nema17_hole_spacing/2-screw_body_overhead/2),0]) {
          rotate([0,0,-45-z*45]) {
            round_corner_filler_profile(screw_body_overhead);
          }
        }
      }
    }
  }

  module main_profile() {
    // top/bottom motor screw mounts
    translate([motor_pos_y,motor_pos_z,0]) {
      for(z=[top,bottom]) {
        translate([0,z*nema17_hole_spacing/2,0]) {
          rounded_square(nema17_hole_spacing+screw_body_overhead,screw_body_overhead,screw_body_overhead);
        }
        translate([nema17_hole_spacing/2-screw_body_overhead/2,z*(nema17_hole_spacing/2-screw_body_overhead/2),0]) {
          rotate([0,0,135+z*45]) {
            round_corner_filler_profile(screw_body_overhead);
          }
        }
      }
      translate([nema17_hole_spacing/2-screw_body_overhead/2,bottom*(nema17_hole_spacing/2+screw_body_overhead/2),0]) {
        rotate([0,0,180]) {
          round_corner_filler_profile(screw_body_overhead);
        }
      }
    }
    // mount to extrusion
    hull() {
      for(z=[top,bottom]) {
        translate([motor_pos_y+nema17_hole_spacing/2,motor_pos_z+z*nema17_hole_spacing/2]) {
          accurate_circle(screw_body_overhead,resolution);
        }
      }
      translate([-extrusion_mount_thickness/2,0,0]) {
        rounded_square(extrusion_mount_thickness,40+extrusion_mount_rounded_diam,extrusion_mount_rounded_diam);
      }
    }
  }

  module position_motor() {
    translate([motor_pos_x,motor_pos_y,motor_pos_z]) {
      rotate([0,90,0]) {
        children();
      }
    }
  }

  module body() {
    translate([motor_pos_x+overall_thickness/2,-overall_depth/2,-40/2+overall_height/2]) {
      rotate([0,90,0]) {
        // color("tan",0.2) rounded_cube(overall_height,overall_depth,overall_thickness,3);
      }

    }
    translate([motor_pos_x,0,0]) {
      rotate([0,90,0]) {
        rotate([0,0,90]) {
          translate([0,0,motor_plate_thickness/2]) {
            linear_extrude(height=motor_plate_thickness,center=true,convexity=2) {
              motor_plate_profile();
            }
          }
          translate([0,0,overall_thickness/2]) {
            linear_extrude(height=overall_thickness,center=true,convexity=2) {
              main_profile();
            }
          }
        }
      }
    }

    translate([-top_idler_width/2,idler_pos_y,0]) {
      for(z=[top_idler_pos_z,bottom_idler_pos_z]) {
        translate([0,0,z]) {
          rotate([0,90,0]) {
            bevel(idler_shaft_body_diam,idler_shaft_diam+extrude_width*4,bevel_height);
          }
        }
      }
    }
  }

  sample_belt_len = 500;

  % translate([0,idler_pos_y,top_idler_pos_z]) {
    rotate([0,90,0]) {
      hole(top_idler_diam,top_idler_width,resolution);
    }
    translate([0,sample_belt_len/2,top_idler_diam/2+1]) {
      color("lightgreen", 0.2) cube([belt_width,sample_belt_len,1],center=true);
    }
  }

  % translate([0,idler_pos_y,bottom_idler_pos_z]) {
    rotate([0,90,0]) {
      hole(bottom_idler_diam,bottom_idler_width,resolution);
    }
    translate([0,sample_belt_len/2,-bottom_idler_diam/2-1]) {
      color("lightgreen", 0.2) cube([belt_width,sample_belt_len,1],center=true);
    }
  }

  position_motor() {
    % motor_nema17();

    translate([0,0,-motor_pos_x]) {
      % hole(pulley_diam,belt_width,resolution);
    }
  }

  module holes() {
    // mount to extrusion
    for(z=[top,bottom]) {
      translate([0,-extrusion_mount_thickness,z*10]) {
        rotate([90,0,0]) {
          hole(5.4,extrusion_mount_thickness*2+1,resolution);
          m5_countersink_screw();

          room_to_insert_bottom_extrusion_screw = nema17_shoulder_diam-1;
          translate([0,0,room_to_insert_bottom_extrusion_screw/2]) {
            hole(m5_bolt_head_diam+1,room_to_insert_bottom_extrusion_screw,resolution);
          }
          translate([0,0,room_to_insert_bottom_extrusion_screw]) {
            m5_countersink_screw();
          }
        }
      }
    }

    position_motor() {
      for(x=[left,right],y=[front,rear]) {
        translate([x*(nema17_hole_spacing/2),y*(nema17_hole_spacing/2),0]) {
          hole(m3_loose_hole,overall_thickness*3,16);
        }
      }
      hole(nema17_shoulder_diam+0.5,50,resolution);
    }

    // belt opening
    hull() {
      rounded_diam = 3;
      translate([0,0,10-m5_loose_hole/2-wall_thickness*2-rounded_diam/2-1]) {
        rotate([90,0,0]) {
          rounded_cube(belt_width+4,rounded_diam,50,rounded_diam);
        }
      }
      translate([0,0,motor_pos_z-nema17_hole_spacing/2+screw_body_overhead/2+rounded_diam/2]) {
        rotate([90,0,0]) {
          rounded_cube(belt_width+4,rounded_diam,50,rounded_diam);
        }
      }
    }

    translate([0,idler_pos_y,0]) {
      for(z=[top_idler_pos_z,bottom_idler_pos_z]) {
        translate([0,0,z]) {
          rotate([0,90,0]) {
            hole(idler_shaft_diam,50,16);
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

module idler_mount() {
  rounded_diam = 3;
  idler_diam = 10; // MR105
  idler_width = 8; // MR105 doubled up

  extrusion_mount_thickness = 8;
  idler_mount_width = 20+rounded_diam;

  bearing_opening_width = idler_width+bevel_height*2;

  idler_pos_y = extrusion_mount_thickness + 2 + idler_diam/2;
  top_idler_pos_z = 20+belt_above_extrusion - idler_diam/2;
  bottom_idler_pos_z = idler_diam/2-1;

  idler_arm_width = idler_mount_width/2 - bearing_opening_width/2;
  idler_arm_depth = idler_pos_y + idler_diam/2 + 3;
  overall_height = 40/2+top_idler_pos_z+idler_diam/2+rounded_diam/2;

  module main_plate_profile() {
    module body() {
      rounded_square(idler_mount_width,40,rounded_diam);
      for(x=[left,right]) {
        translate([x*(bearing_opening_width/2),40/2,0]) {
          rotate([0,0,45+x*45]) {
            # round_corner_filler_profile(rounded_diam);
          }
        }
      }
    }

    module holes() {
      belt_hole_height = 8;
      translate([0,-10+m5_fsc_head_diam/2+belt_hole_height/2+0.8,0]) {
        rounded_square(10,belt_hole_height,rounded_diam);
      }
    }

    difference() {
      body();
      holes();
    }
  }

  module body() {
    translate([0,extrusion_mount_thickness/2,0]) {
      rotate([90,0,0]) {
        linear_extrude(height=extrusion_mount_thickness,center=true,convexity=2) {
          main_plate_profile();
        }
      }
    }
    for(x=[left,right]) {
      translate([x*(idler_mount_width/2-idler_arm_width/2),0,0]) {
        rotate([90,0,0]) {
          hull() {
            translate([0,rounded_diam/2,-extrusion_mount_thickness/2]) {
              rounded_cube(idler_arm_width,40+rounded_diam,extrusion_mount_thickness,rounded_diam);
            }
            for(z=[top_idler_pos_z,bottom_idler_pos_z]) {
              translate([0,z,-idler_pos_y]) {
                rounded_cube(idler_arm_width,idler_diam+rounded_diam,idler_diam+3,rounded_diam);
              }
            }
          }
        }
      }
    }

    for(z=[top_idler_pos_z,bottom_idler_pos_z]) {
      translate([0,idler_pos_y,z]) {
        rotate([0,90,0]) {
          % hole(idler_diam,idler_width,resolution);
        }

        for(x=[left,right]) {
          translate([x*idler_width/2,0,0]) {
            rotate([0,x*-90,0]) {
              bevel(idler_diam,m5_loose_hole,bevel_height);
            }
          }
        }
      }
    }
  }

  module holes() {
    for(z=[top,bottom]) {
      translate([0,extrusion_mount_thickness,z*10]) {
        rotate([90,0,0]) {
          hole(5.4,extrusion_mount_thickness*2+1,resolution);
          m5_countersink_screw();
        }
      }
    }

    for(z=[top_idler_pos_z,bottom_idler_pos_z]) {
      translate([0,idler_pos_y,z]) {
        rotate([0,90,0]) {
          hole(m5_loose_hole,idler_mount_width*2,resolution);
        }
      }
    }
  }

  difference() {
    body();
    holes();
  }
}

module mini_v_wheel_plate(extrusion_width=20,wheel_spacing_y=10+20+wall_thickness*4) {
}

module xy_carriage(extrusion_width=20,wheel_spacing_y=10+20+wall_thickness*4) {
  wheel_overhead = 11.9;
  wheel_spacing_x = wheel_overhead+extrusion_width;
  eccentric_shaft_diam = 7.4;
  eccentric_head_diam = 12;
  plain_shaft_diam = m5_loose_hole;
  plain_head_diam = 10.1;
  head_depth = 3;
  rounded_diam = plain_head_diam+wall_thickness*4;
  small_rounded_diam = 4;
  eccentric_body_width = eccentric_head_diam + wall_thickness*4;
  size_y = wheel_spacing_y + rounded_diam;

  screw_mount_height = 20;
  screw_mount_thickness = 6;

  mounted_extrusion_offset_y = wheel_spacing_y/2-plain_head_diam/2-extrusion_width/2-screw_mount_thickness;

  belt_position_x = -wheel_spacing_x/2+wheel_overhead/2+10;
  
  overall_length = wheel_spacing_y+rounded_diam;

  zip_tie_width = 4.5;
  zip_tie_thickness = 3;

  module position_eccentric_holes() {
    translate([right*(wheel_spacing_x/2),0]) {
      children();
    }
  }

  module position_plain_holes() {
    translate([left*(wheel_spacing_x/2),0]) {
      for(y=[front,rear]) {
        translate([0,y*wheel_spacing_y/2,0]) {
          children();
        }
      }
    }
  }

  module plate_profile() {
    module body() {
      hull() {
        for(y=[front,rear]) {
          translate([-wheel_spacing_x/2,y*wheel_spacing_y/2,0]) {
            accurate_circle(rounded_diam,resolution);
          }
          translate([wheel_spacing_x/2+eccentric_body_width/2-small_rounded_diam/2,y*(size_y/2-small_rounded_diam/2),0]) {
            accurate_circle(small_rounded_diam,resolution);
          }
        }
      }
    }

    module holes() {
      position_eccentric_holes() {
        accurate_circle(eccentric_shaft_diam,resolution);
      }
      position_plain_holes() {
        accurate_circle(plain_shaft_diam,resolution);
      }
    }

    difference() {
      body();
      holes();
    }
  }

  module screw_mount_profile() {
    module body() {
      hull() {
        translate([0,wheel_spacing_y/2,0]) {
          translate([-wheel_spacing_x/2+plain_head_diam/2+small_rounded_diam/2,0,0]) {
            rounded_square(small_rounded_diam,rounded_diam,small_rounded_diam,resolution);
          }
          translate([wheel_spacing_x/2,0,0]) {
            rounded_square(eccentric_body_width,rounded_diam,small_rounded_diam,resolution);
          }
        }
      }
    }

    module holes() {
    }

    difference() {
      body();
      holes();
    }
  }

  belt_width = 6;
  zip_tie_anchor_diam = belt_width + 2;

  module body() {
    translate([0,0,mini_v_wheel_plate_thickness/2]) {
      linear_extrude(height=mini_v_wheel_plate_thickness,center=true,convexity=3) {
        plate_profile();
      }
    }

    translate([0,0,mini_v_wheel_plate_thickness+screw_mount_height/2]) {
      linear_extrude(height=screw_mount_height,center=true,convexity=3) {
        screw_mount_profile();
      }
    }

    // open side zip tie anchor
    translate([0,0,-mini_v_wheel_plate_above_extrusion+belt_above_extrusion+zip_tie_width/2+0.5]) {
      anchor_height = zip_tie_width*3;
      translate([0,-overall_length/2+4,0]) {
        hull() {
          translate([0,zip_tie_anchor_diam/2,0]) {
            hole(zip_tie_anchor_diam,anchor_height,resolution);
          }
          cube([belt_width,8,anchor_height],center=true);
        }
        for(z=[top,bottom]) {
          hull() {
            translate([0,zip_tie_anchor_diam/2,z*anchor_height/2]) {
              translate([0,0,z*-0.5]) {
                hole(zip_tie_anchor_diam+zip_tie_width,1,resolution);
              }
              translate([0,0,z*-zip_tie_width/2]) {
                hole(zip_tie_anchor_diam,zip_tie_width,resolution);

                translate([0,-zip_tie_anchor_diam/2,0]) {
                  cube([belt_width,8,zip_tie_width],center=true);
                }
              }
            }
          }
        }
      }
    }
  }

  module holes() {
    translate([0,0,mini_v_wheel_plate_thickness+50-head_depth]) {
      position_eccentric_holes() {
        hole(eccentric_head_diam,100,resolution);
      }
      position_plain_holes() {
        hole(plain_head_diam,100,resolution);
      }
    }

    // extrusion anchor
    translate([wheel_spacing_x/2,overall_length/2,mini_v_wheel_plate_thickness+10]) {
      rotate([90,0,0]) {
        hole(5.4,overall_length*2+1,resolution);
        m5_countersink_screw();
      }
    }

    module zip_tie_anchor_profile() {
      dist_from_edge = 4;
      translate([0,-dist_from_edge,0]) {
        difference() {
          hull() {
            accurate_circle(zip_tie_anchor_diam+zip_tie_thickness*2,resolution);
            translate([0,zip_tie_anchor_diam,0]) {
              square([zip_tie_anchor_diam+zip_tie_thickness*2,zip_tie_anchor_diam],center=true);
            }
          }
          hull() {
            accurate_circle(zip_tie_anchor_diam,resolution);
            translate([0,dist_from_edge,0]) {
              square([belt_width,0.2],center=true);
            }
          }
        }
      }
    }


    // extrusion anchor side ziptie anchor
    translate([0,overall_length/2,-mini_v_wheel_plate_above_extrusion+belt_above_extrusion+zip_tie_width/2+0.5]) {
      linear_extrude(height=zip_tie_width,center=true,convexity=2) {
        zip_tie_anchor_profile();
      }
    }
  }

  % translate([0,0,-20/2-mini_v_wheel_plate_above_extrusion]) {
    position_plain_holes() {
      color("#444") mini_v_wheel();
    }
    position_eccentric_holes() {
      color("#444") mini_v_wheel();
    }
  }

  difference() {
    body();
    holes();
  }
}


//linear_extrude(height=2,center=true) {
//y_carriage();
//rotate([90,0,0]) {
//  color("silver", 0.3) extrusion_2040(y_rail_len);
//}
//}

//y_dragchain_clamp();
//y_endcap_with_motor();
//y_on_carriage_dragchain_anchor_mount();

/*
translate([0,0,0.1]) {
  % color("lightgrey") extrusion_2040_profile();
}
*/

/*
use <lib/util.scad>;
use <lib/ISOThread.scad>;

height = 10;

difference() {
  cube([10,10,height],center=true);
  hole(5,height+1,16);
}
translate([0,0,-height/2]) {
  thread_in_pitch(5,height,0.8);			// make an M8 x 10 thread with 1mm pitch
}
*/

