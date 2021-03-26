include <config.scad>;
use <sketch-for-simpler.scad>;
use <z-axis-mount.scad>;
use <lib/vitamins.scad>;

belt_above_extrusion = 12;

belt_width = 6;
pulley_diam = gt2_16t_pulley_diam;

bevel_height = 1;

measuring_tape_dragchain_min_diam = 35;

translate([0,0,20+mini_v_wheel_plate_thickness+mini_v_wheel_plate_above_extrusion]) {
  /*
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
  */
}
for(x=[right]) {
  translate([x*x_rail_len/2,0,0]) {
    mirror([x-1,0,0]) {
      translate([0,-40,mini_v_wheel_plate_above_extrusion]) {
        xy_carriage();
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

      motor_mount_cap();

      endstop_flag_mount();
    }
    translate([x_rail_len/2,y_rail_len/2,-40/2]) {
      y_idler_mount();
    }
  }
}

large_idler_diam = 16; // F625 bearing
large_idler_width = 10; // F625 bearing doubled up

small_idler_diam = 10; // MR105 bearing
small_idler_width = 8; // MR105 bearing doubled up

top_idler_diam = small_idler_diam;
top_idler_width = small_idler_width;

bottom_idler_diam = small_idler_diam;
bottom_idler_width = small_idler_width;

motor_pos_x = left*(20/2+nema17_shoulder_height);
motor_pos_y = front*(motor_side/2);
motor_pos_z = -40/2+10+m5_loose_hole/2+extrude_width*4+m3_loose_hole/2+nema17_hole_spacing/2;

top_idler_pos_z = 20+belt_above_extrusion - top_idler_diam/2;
bottom_idler_pos_z = motor_pos_z - nema17_hole_spacing/2 + bottom_idler_diam/2 + m3_loose_hole/2 + wall_thickness*2 + 3;
idler_pos_y = motor_pos_y + front*(motor_side/2 + top_idler_diam/2 + 1);

idler_shaft_diam = m3_loose_hole;
idler_shaft_body_diam = idler_shaft_diam+wall_thickness*4;

motor_mount_cap_thickness = 20/2 - top_idler_width/2 - bevel_height;
screw_body_overhead = m3_loose_hole + wall_thickness*4;

module motor_mount_cap() {
  module profile() {
    module body() {
      translate([motor_pos_y,motor_pos_z]) {
        inside_square = nema17_hole_spacing - screw_body_overhead-2;
        hull() {
          accurate_circle(inside_square,resolution);
          translate([-inside_square/2,0,0]) {
            square([10,inside_square],center=true);
          }
        }
        for(y=[front,rear]) {
          mirror([0,y-1]) {
            translate([-nema17_hole_spacing/2+screw_body_overhead/2,inside_square/2,0]) {
              round_corner_filler_profile(screw_body_overhead,resolution);
            }
          }
        }
      }
      hull() {
        translate([motor_pos_y,motor_pos_z]) {
          translate([-nema17_hole_spacing/2,0,0]) {
            for(y=[front,rear]) {
              translate([0,y*nema17_hole_spacing/2,0]) {
                accurate_circle(screw_body_overhead,resolution);
              }
            }
          }
        }
        for(z=[top_idler_pos_z,bottom_idler_pos_z]) {
          translate([idler_pos_y,z]) {
            accurate_circle(idler_shaft_body_diam,resolution);
          }
        }
      }
    }

    module holes() {
      translate([motor_pos_y,motor_pos_z]) {
        accurate_circle(top_idler_diam+0.2,16);
        translate([-nema17_hole_spacing/2,0,0]) {
          for(y=[front,rear]) {
            translate([0,y*nema17_hole_spacing/2,0]) {
              accurate_circle(m3_loose_hole,resolution);
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

  module body() {
    translate([20/2,0,0]) {
      translate([0,0,30]) {
        // profile();
      }

      rotate([0,90,0]) {
        rotate([0,0,90]) {
          translate([0,0,-motor_mount_cap_thickness/2]) {
            linear_extrude(height=motor_mount_cap_thickness,center=true,convexity=2) {
              profile();
            }
          }
        }
      }
    }

    for(z=[top_idler_pos_z,bottom_idler_pos_z]) {
      translate([top_idler_width/2,idler_pos_y,z]) {
        rotate([0,-90,0]) {
          bevel(idler_shaft_body_diam,idler_shaft_diam+extrude_width*4,bevel_height);
        }
      }
    }
  }

  module holes() {
    for(z=[top_idler_pos_z,bottom_idler_pos_z]) {
      translate([20/2,idler_pos_y,z]) {
        rotate([0,-90,0]) {
          hole(m3_thread_into_plastic_hole_diam,50,16);
        }
      }
    }
  }

  difference() {
    body();
    holes();
  }
}

module motor_mount() {
  overall_depth = abs(idler_pos_y) + m5_thread_into_plastic_hole_diam/2 + wall_thickness*2;
  overall_height = 40/2+motor_pos_z + nema17_side/2;
  overall_thickness = 20/2 + abs(motor_pos_x);

  extrusion_mount_thickness = screw_body_overhead/2+(abs(motor_pos_y)-nema17_hole_spacing/2);
  extrusion_mount_rounded_diam = screw_body_overhead/2;

  bottom_belt_pos_z = bottom_idler_pos_z - bottom_idler_diam/2;

  motor_plate_thickness = abs(motor_pos_x) - top_idler_width/2 - bevel_height;

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
    translate([motor_pos_x-24.5,motor_pos_y,motor_pos_z]) {
      rotate([0,-90,0]) {
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
    translate([0,sample_belt_len/2,top_idler_diam/2+0.5]) {
      color("lightgreen", 0.2) cube([belt_width,sample_belt_len,1],center=true);
    }
  }

  % translate([0,idler_pos_y,bottom_idler_pos_z]) {
    rotate([0,90,0]) {
      hole(bottom_idler_diam,bottom_idler_width,resolution);
    }
    translate([0,sample_belt_len/2,-bottom_idler_diam/2-0.5]) {
      color("lightgreen", 0.2) cube([belt_width,sample_belt_len,1],center=true);
    }
  }

  position_motor() {
    # motor_nema17(nema17_len);

    translate([0,0,24.5]) {
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

      // make room for motor cap
      room_for_cap_x = screw_body_overhead+1;
      room_for_cap_z = motor_mount_cap_thickness+0.1;
      translate([0,-nema17_hole_spacing/2,overall_thickness]) {
        cube([nema17_side+1,room_for_cap_x,2*(room_for_cap_z)],center=true);
        for(y=[front,rear]) {
          translate([y*nema17_hole_spacing/2,0]) {
            for(y2=[front,rear]) {
              mirror([y2-1,0,0]) {
                translate([screw_body_overhead/2,room_for_cap_x/2,0]) {
                  rotate([0,0,90]) {
                    round_corner_filler(screw_body_overhead,room_for_cap_z*2);
                  }
                }
              }
            }
          }
        }
      }
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

    // pulley set screw access
    set_screw_access_width = 10;
    set_screw_access_height = 7;
    translate([motor_pos_x+nema17_shoulder_height+set_screw_access_height/2,motor_pos_y,motor_pos_z+nema17_hole_spacing/2]) {
      difference() {
        cube([set_screw_access_height,set_screw_access_width+screw_body_overhead,screw_body_overhead+1],center=true);
        for(y=[front,rear]) {
          translate([0,y*(set_screw_access_width/2+screw_body_overhead/2),0]) {
            rotate([0,90,0]) {
              hole(screw_body_overhead,50,resolution);
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

module y_idler_mount() {
  rounded_diam = 3;
  idler_diam = 10; // MR105
  idler_width = 8; // MR105 doubled up

  idler_shaft_diam = m3_loose_hole;

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
      translate([0,-10]) {
        rounded_square(idler_mount_width,60,rounded_diam);
      }
      for(x=[left,right]) {
        translate([x*(bearing_opening_width/2),40/2,0]) {
          rotate([0,0,45+x*45]) {
            round_corner_filler_profile(rounded_diam);
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
        hull() {
          for(z=[top_idler_pos_z,bottom_idler_pos_z]) {
            translate([0,idler_pos_y,z]) {
              rotate([0,90,0]) {
                rotate_extrude($fn=64,convexity=2) {
                  translate([idler_diam/2,0,0]) {
                    for(y=[front,rear]) {
                      translate([0,y*(idler_arm_width/2-rounded_diam/2),0]) {
                        accurate_circle(rounded_diam,resolution);
                      }
                    }
                  }
                }
              }
            }
          }
          translate([0,extrusion_mount_thickness/2,rounded_diam/2]) {
            rotate([90,0,0]) {
              rounded_cube(idler_arm_width,40+rounded_diam,extrusion_mount_thickness,rounded_diam);
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
    for(z=[10,-10,-30]) {
      translate([0,extrusion_mount_thickness,z]) {
        rotate([90,0,0]) {
          hole(5.4,extrusion_mount_thickness*2+1,resolution);
          m5_countersink_screw();
        }
      }
    }

    for(z=[top_idler_pos_z,bottom_idler_pos_z]) {
      translate([0,idler_pos_y,z]) {
        rotate([0,90,0]) {
          hole(idler_shaft_diam,idler_mount_width*2,resolution);
        }
      }
    }
  }

  difference() {
    body();
    holes();
  }
}

//belt_inside_extrusion_x_belt_offset_y = front*(9.5 + pulley_diam/2);
x_belt_offset_y = -10+v_slot_cavity_depth/2-0.5;

module endstop_flag_mount() {
  rounded_diam = 3;

  space_for_extrusion = 0.2;
  flag_thickness = 3;
  endstop_mount_thickness = flag_thickness + 4;
  width = 10;

  pos_x = 10+flag_thickness/2;
  pos_y = width/2+1;

  module position_endstop() {
    translate([pos_x,pos_y,20+mech_endstop_tiny_length/2+space_for_extrusion]) {
      rotate([-90,0,0]) {
        children();
      }
    }
  }

  module position_endstop_mounting_holes() {
    position_endstop() {
      for(y=[front,rear]) {
        translate([0,y*mech_endstop_mounting_hole_spacing_y/2,0]) {
          rotate([0,90,0]) {
            children();
          }
        }
      }
    }
  }

  translate([flag_thickness/2+mech_endstop_tiny_width/2,mech_endstop_tiny_mounting_hole_from_top,0]) {
    position_endstop() {
      % mech_endstop_tiny();
    }
  }

  module body() {
    hull() {
      position_endstop() {
        rotate([0,90,0]) {
          rounded_cube(width,mech_endstop_tiny_length,flag_thickness,rounded_diam,resolution);
        }
      }
      translate([pos_x,pos_y,10]) {
        //cube([flag_thickness,width,10],center=true);
        rotate([0,90,0]) {
          rounded_cube(20,width,flag_thickness,rounded_diam,resolution);
        }
      }
    }
    // dip into v-slot
    hull() {
      translate([pos_x-flag_thickness/2+0.1,pos_y,10]) {
        cube([0.2,width,v_slot_width-tolerance],center=true);
        cube([0.2+v_slot_depth*2,width,v_slot_opening-tolerance],center=true);
      }
    }
    position_endstop() {
      translate([flag_thickness/2-endstop_mount_thickness/2,0,0]) {
        rotate([0,90,0]) {
          rounded_cube(width,mech_endstop_tiny_length,endstop_mount_thickness,rounded_diam,resolution);
        }
      }
    }
  }

  module holes() {
    position_endstop_mounting_holes() {
      hole(m2_thread_into_plastic_hole_diam,50,8);
    }
    translate([pos_x,pos_y,10]) {
      rotate([0,90,0]) {
        hole(m3_loose_hole,40,16);
      }
    }
  }

  difference() {
    body();
    holes();
  }
}

module x_idler_mount() {
  mount_thickness = 4;
  rounded_diam = wall_thickness*2;

  idler_diam = 10;
  idler_width = 8;
  idler_shaft_diam = m3_loose_hole;

  idler_pos_x = left *(mount_thickness + 2 + idler_diam/2);
  idler_pos_y = x_belt_offset_y - idler_diam/2;
  idler_pos_z = -10;

  idler_arm_thickness = wall_thickness*4;
  idler_arm_width = idler_shaft_body_diam+rounded_diam;
  idler_arm_height = abs(idler_pos_x)+idler_diam/2;

  belt_access_hole_height = 10;
  belt_access_hole_width = 4;

  module position_idler() {
    translate([idler_pos_x,idler_pos_y,idler_pos_z]) {
      children();
    }
  }

  % position_idler() {
    hole(idler_diam,idler_width,resolution);
  }

  module body() {
    translate([left*(mount_thickness/2),0,0]) {
      hull() {
        rotate([0,90,0]) {
          rounded_cube(40,20+rounded_diam,mount_thickness,rounded_diam);
        }
        translate([0,idler_pos_y,idler_pos_z]) {
          rotate([0,90,0]) {
            rounded_cube(idler_width+(idler_arm_thickness+bevel_height)*2,idler_arm_width,mount_thickness,rounded_diam);
          }
        }
      }
    }

    position_idler() {
      for(z=[top,bottom]) {
        mirror([0,0,z-1]) {
          translate([0,0,-idler_width/2]) {
            bevel(idler_shaft_body_diam,idler_shaft_diam+extrude_width*4,bevel_height);
          }
        }
      }
    }

    // idler arms
    for(z=[top,bottom]) {
      translate([0,idler_pos_y,idler_pos_z+z*(idler_width/2+bevel_height+idler_arm_thickness/2)]) {
        hull() {
          translate([left*(idler_arm_height/2),0,0]) {
            rotate([0,90,0]) {
              rounded_cube(idler_arm_thickness,idler_arm_width,idler_arm_height,rounded_diam);
            }
          }
          translate([left*(mount_thickness/2),idler_arm_height,0]) {
            rotate([0,90,0]) {
              rounded_cube(idler_arm_thickness,idler_arm_width,mount_thickness,rounded_diam);
            }
          }
        }
      }
    }
  }

  module holes() {
    // extrusion mounting holes
    for(z=[top,bottom]) {
      translate([left*mount_thickness,0,z*20/2]) {
        rotate([0,90,0]) {
          m5_countersink_screw();
          hole(5.4,30,resolution);
        }
      }
    }

    // belt access
    position_idler() {
      for(y=[front,rear]) {
        translate([-idler_pos_x,y*idler_diam/2,0]) {
          rotate([0,90,0]) {
            rounded_cube(belt_access_hole_height,belt_access_hole_width,mount_thickness*3,rounded_diam);
          }
        }
      }
    }

    // idler shaft
    position_idler() {
      hole(idler_shaft_diam,50,resolution);
    }
  }

  difference() {
    body();
    holes();
  }
}

module belt_inside_extrusion_x_idler_mount() {
  mount_thickness = 4;
  rounded_diam = 1;

  idler_diam = 10;
  idler_width = 8;
  idler_shaft_diam = m3_loose_hole;

  idler_pos_x = left *(mount_thickness + 2 + idler_diam/2);
  idler_pos_y = x_belt_offset_y + idler_diam/2;
  idler_pos_z = 0;

  idler_arm_thickness = wall_thickness*4;
  idler_arm_width = idler_shaft_body_diam+rounded_diam;
  idler_arm_height = abs(idler_pos_x)+idler_diam/2;

  belt_access_hole_height = 20 - m5_fsc_head_diam - extrude_width*4;
  belt_access_hole_width = 15;

  module position_idler() {
    translate([idler_pos_x,idler_pos_y,idler_pos_z]) {
      children();
    }
  }

  % position_idler() {
    hole(idler_diam,idler_width,resolution);
  }

  module body() {
    translate([left*(mount_thickness/2),0,0]) {
      rotate([0,90,0]) {
        hull() {
          rounded_cube(40,20+rounded_diam,mount_thickness,rounded_diam);
          translate([0,idler_pos_y,0]) {
            rounded_cube(idler_width+(idler_arm_thickness+bevel_height)*2,idler_arm_width,mount_thickness,rounded_diam);
          }
        }
      }
    }

    position_idler() {
      for(z=[top,bottom]) {
        mirror([0,0,z-1]) {
          translate([0,0,-idler_width/2]) {
            bevel(idler_shaft_body_diam,idler_shaft_diam+extrude_width*4,bevel_height);
          }
        }
      }
    }

    // idler arms
    for(z=[top,bottom]) {
      translate([left*(idler_arm_height/2),idler_pos_y,idler_pos_z+z*(idler_width/2+bevel_height+idler_arm_thickness/2)]) {
        rotate([0,90,0]) {
          rounded_cube(idler_arm_thickness,idler_arm_width,idler_arm_height,rounded_diam);
        }
      }
    }
  }

  module holes() {
    // extrusion mounting holes
    for(z=[top,bottom]) {
      translate([left*mount_thickness,0,z*20/2]) {
        rotate([0,90,0]) {
          # m5_countersink_screw();
          hole(5.4,30,resolution);
        }
      }
    }

    // belt access
    rotate([0,90,0]) {
      rounded_cube(belt_access_hole_height,11,mount_thickness*3,rounded_diam);
    }

    // idler shaft
    position_idler() {
      hole(idler_shaft_diam,50,resolution);
    }
  }

  difference() {
    body();
    holes();
  }
}

module x_motor_mount() {
  rounded_diam = wall_thickness*2;

  sample_belt_len = 200;
  belt_width = 6;

  mount_thickness = 4;

  belt_access_hole_height = 10;
  belt_access_hole_width = 4;

  pulley_hole_diam = 15;

  motor_pos_x = mount_thickness+nema17_side/2;
  // motor_pos_y = -10-pulley_diam/2+v_slot_cavity_depth/2;
  motor_pos_y = x_belt_offset_y - pulley_diam/2;
  motor_pos_z = -20;

  mount_height = 30;
  mount_width = abs(motor_pos_y) + pulley_diam/2 + belt_access_hole_width + 10 + rounded_diam;
  mount_pos_y = 10+rounded_diam/2-mount_width/2;

  motor_mount_thickness = nema17_shoulder_height+extrude_width*4;
  motor_mount_width = abs(motor_pos_y)+nema17_side/2+10+rounded_diam;
  motor_mount_pos_y = motor_pos_y-nema17_side/2-rounded_diam/2+motor_mount_width/2;

  module position_motor() {
    translate([motor_pos_x,motor_pos_y,motor_pos_z]) {
      children();
    }
  }

  module body() {
    translate([mount_thickness/2,0,0]) {
      // extrusion mount
      hull() {
        translate([0,0,10]) {
          rotate([0,90,0]) {
            rounded_cube(20,20+rounded_diam,mount_thickness,rounded_diam);
          }
        }
        translate([0,motor_mount_pos_y,motor_pos_z+motor_mount_thickness/2]) {
          rotate([0,90,0]) {
            rounded_cube(motor_mount_thickness,motor_mount_width,mount_thickness,rounded_diam);
          }
        }
        translate([0,mount_pos_y,motor_pos_z+mount_height/2]) {
          rotate([0,90,0]) {
            rounded_cube(mount_height,mount_width,mount_thickness,rounded_diam);
          }
        }
      }
    }

    // motor plate
    translate([motor_pos_x-mount_thickness/2,motor_mount_pos_y,motor_pos_z+motor_mount_thickness/2]) {
      rotate([0,90,0]) {
        rounded_cube(motor_mount_thickness,motor_mount_width,nema17_side+mount_thickness,rounded_diam);
      }
    }

    // bracing
    for(y=[mount_pos_y-mount_width/2+rounded_diam/2,mount_pos_y+mount_width/2-rounded_diam/2]) {
      hull() {
        brace_height = mount_height;
        brace_depth = nema17_side+mount_thickness;
        translate([mount_thickness/2,y,motor_pos_z+brace_height/2]) {
          rotate([0,90,0]) {
            rounded_cube(brace_height,rounded_diam,mount_thickness,rounded_diam);
          }
        }
        translate([brace_depth/2,y,motor_pos_z+motor_mount_thickness/2]) {
          rotate([0,90,0]) {
            rounded_cube(motor_mount_thickness,rounded_diam,brace_depth,rounded_diam);
          }
        }
      }
    }
  }

  module holes() {
    // extrusion mounting holes
    for(z=[top,bottom]) {
      translate([mount_thickness,0,z*20/2]) {
        rotate([0,90,0]) {
          m5_countersink_screw();
          hole(5.4,30,resolution);
        }
      }
    }

    position_motor() {
      // motor shoulder room
      hull() {
        hole(nema17_shoulder_diam,nema17_shoulder_height*2,resolution);
        translate([0,0,-1]) {
          hole(nema17_shoulder_diam+nema17_shoulder_height*2,2,resolution);
        }
      }
      // motor mounting screws
      for(x=[left,right],y=[front,rear]) {
        translate([x*(nema17_hole_spacing/2),y*(nema17_hole_spacing/2),motor_mount_thickness+5]) {
          hole(m3_loose_hole,nema17_len,16);
          hole(m3_bolt_head_diam+0.1,10,resolution);
        }
      }
      hull() {
        hole(pulley_hole_diam,motor_mount_thickness*3,resolution);
        translate([pulley_hole_diam/2-1,0,0]) {
          cube([2,pulley_hole_diam/2,motor_mount_thickness*3],center=true);
        }
      }
    }

    // belt passthrough
    position_motor() {
      % motor_nema17(nema17_len);

      translate([0,0,10]) {
        % hole(pulley_diam,belt_width,resolution);
        for(y=[front,rear]) {
          translate([0,y*(pulley_diam/2),0]) {
            rotate([0,90,0]) {
              rounded_cube(belt_access_hole_height,belt_access_hole_width,60,rounded_diam);
            }
          }
          translate([-sample_belt_len/2,y*pulley_diam/2,0]) {
            % color("lightgreen", 0.2) cube([sample_belt_len,1,belt_width],center=true);
            % color("lightgreen", 0.2) cube([sample_belt_len,belt_width,1],center=true);
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

module belt_inside_extrusion_x_motor_mount() {
  rounded_diam = wall_thickness*2;

  sample_belt_len = 200;
  belt_width = 6;

  belt_access_hole_height = 20 - m5_fsc_head_diam - extrude_width*4;
  belt_access_hole_width = 15;

  mount_thickness = 4;

  motor_mount_thickness = nema17_shoulder_height+extrude_width*4;

  motor_pos_x = mount_thickness+nema17_side/2;
  motor_pos_y = x_belt_offset_y + pulley_diam/2;
  motor_pos_z = -10-m5_fsc_head_diam/2-motor_mount_thickness-0.5;

  extrusion_mount_width = abs(motor_pos_y+nema17_side/2) + 10 + mount_thickness*2;

  pulley_hole_diam = 15;

  side_brace_thickness = wall_thickness*2;
  side_brace_pos_y = motor_pos_y+nema17_side/2;

  module position_motor() {
    translate([motor_pos_x,motor_pos_y,motor_pos_z]) {
      children();
    }
  }

  module body() {
    translate([mount_thickness/2,0,0]) {
      // extrusion mount
      hull() {
        translate([0,-10,0]) {
          rotate([0,90,0]) {
            rounded_cube(40,rounded_diam,mount_thickness,rounded_diam);
          }
        }
        translate([0,side_brace_pos_y,0]) {
          rotate([0,90,0]) {
            rounded_cube(40,side_brace_thickness,mount_thickness,side_brace_thickness);
          }
        }
      }
    }

    // side motor brace
    hull() {
      translate([mount_thickness/2,side_brace_pos_y,20-side_brace_thickness/2]) {
        rotate([0,90,0]) {
          hole(side_brace_thickness,mount_thickness,resolution);
        }
      }
      translate([motor_pos_x-mount_thickness/2,side_brace_pos_y,motor_pos_z+motor_mount_thickness/2]) {
        rotate([0,90,0]) {
          rounded_cube(motor_mount_thickness,side_brace_thickness,nema17_side+mount_thickness,wall_thickness*2);
        }
      }
    }

    // motor plate
    hull() {
      translate([motor_pos_x-mount_thickness/2,0,motor_pos_z+motor_mount_thickness/2]) {
        translate([0,motor_pos_y-nema17_side/2,0]) {
          rotate([0,90,0]) {
            rounded_cube(motor_mount_thickness,rounded_diam,nema17_side+mount_thickness,rounded_diam);
          }
        }
        translate([0,side_brace_pos_y,0]) {
          rotate([0,90,0]) {
            rounded_cube(motor_mount_thickness,side_brace_thickness,nema17_side+mount_thickness,rounded_diam);
          }
        }
      }
    }

    position_motor() {
      % motor_nema17(nema17_len);

      translate([0,0,-motor_pos_z]) {
        % hole(pulley_diam,belt_width,resolution);
      }
    }

    // center motor brace
    //motor_brace_width = 10-m5_fsc_head_diam/2+rounded_diam/2;
    motor_brace_width = 20/2+rounded_diam/2-belt_access_hole_width/2;
    motor_brace_height = nema17_side/2-pulley_hole_diam/2+mount_thickness/3;
    motor_brace_depth = nema17_side/2-pulley_hole_diam/2+mount_thickness/3;
    motor_brace_pos_y = front*(belt_access_hole_width/2+motor_brace_width/2);
    hull() {
      // toward pulley
      translate([motor_pos_x-pulley_hole_diam/2-1,motor_brace_pos_y,motor_pos_z+motor_mount_thickness/2]) {
        rotate([0,90,0]) {
          rounded_cube(motor_mount_thickness,motor_brace_width,2,rounded_diam);
        }
      }
      translate([mount_thickness/2,0,0]) {
        translate([0,motor_brace_pos_y,0]) {
          // top center by extrusion
          translate([0,0,40/2-rounded_diam/2]) {
            rotate([0,90,0]) {
              rounded_cube(rounded_diam,motor_brace_width,mount_thickness,rounded_diam);
            }
          }
          translate([0,0,motor_pos_z+motor_mount_thickness/2]) {
            // intersection of plate and extrusion
            rotate([0,90,0]) {
              rounded_cube(motor_mount_thickness,motor_brace_width,mount_thickness,rounded_diam);
            }
          }
        }
        // corner of motor plate
        translate([0,motor_pos_y-nema17_side/2,motor_pos_z+motor_mount_thickness/2]) {
          rotate([0,90,0]) {
            rounded_cube(motor_mount_thickness,rounded_diam,mount_thickness,rounded_diam);
          }
        }
      }
    }
  }

  module holes() {
    // extrusion mounting holes
    for(z=[top,bottom]) {
      translate([mount_thickness,0,z*20/2]) {
        rotate([0,90,0]) {
          m5_countersink_screw();
          hole(5.4,30,resolution);
        }
      }
    }

    // belt through extrusion
    rotate([0,90,0]) {
      hull() {
        rounded_cube(belt_access_hole_height,11,mount_thickness*3,rounded_diam);
        rounded_cube(rounded_diam+2,belt_access_hole_width,mount_thickness*3,rounded_diam);
      }
    }

    position_motor() {
      // pulley hole
      hull() {
        hole(pulley_hole_diam,motor_mount_thickness*3,resolution);
        translate([pulley_hole_diam/2-1,0,0]) {
          cube([2,pulley_hole_diam/2,motor_mount_thickness*3],center=true);
        }
      }

      // shoulder room
      hull() {
        hole(nema17_shoulder_diam,nema17_shoulder_height*2,resolution);
        translate([0,0,-1]) {
          hole(nema17_shoulder_diam+nema17_shoulder_height*2,2,resolution);
        }
      }
      // motor mounting screws
      for(x=[left,right],y=[front,rear]) {
        translate([x*(nema17_hole_spacing/2),y*(nema17_hole_spacing/2),motor_mount_thickness+5]) {
          hole(m3_loose_hole,nema17_len,16);
          hole(m3_bolt_head_diam+0.1,10,resolution);
        }
      }

      // clear belt path to pen carriage
      translate([0,-pulley_diam/2,-motor_pos_z]) {
        rotate([0,90,0]) {
          rounded_cube(belt_access_hole_height,6,60,rounded_diam);
        }
        for(y=[0,pulley_diam]) {
          translate([-sample_belt_len/2,y,0]) {
            % color("lightgreen", 0.2) cube([sample_belt_len,1,belt_width],center=true);

            if (y) {
              //% color("lightgreen", 0.2) cube([sample_belt_len,belt_width,1],center=true);

              rotate([0,90,0]) {
                // % color("lightgreen", 0.2) hole(belt_width,sample_belt_len,resolution);
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

module slotted_measuring_tape_dragchain_anchor() {
  module body() {
  }

  module holes() {
  }

  difference() {
    body();
    holes();
  }
}

module supported_measuring_tape_dragchain_anchor() {
  module body() {
  }

  module holes() {
  }

  difference() {
    body();
    holes();
  }
}

module xy_carriage() {
  wheel_overhead = 11.9;

  eccentric_shaft_diam = 7.4;
  eccentric_head_diam = 12;
  eccentric_body_width = eccentric_head_diam + wall_thickness*4;

  plain_shaft_diam = m5_loose_hole;
  plain_head_diam = 10.1;

  extrusion_width=20;
  screw_mount_depth = 10;
  screw_mount_height = 20;

  wheel_spacing_x = wheel_overhead+extrusion_width;

  size_y = extrusion_width+screw_mount_depth*2+eccentric_head_diam*2+wall_thickness*4;
  wheel_spacing_y=extrusion_width+screw_mount_depth*2+eccentric_head_diam;

  head_depth = 3;
  rounded_diam = plain_head_diam+wall_thickness*4;
  small_rounded_diam = 4;

  belt_width = 6;
  belt_thickness = 1;

  belt_anchor_thickness = 2;
  belt_anchor_depth = rounded_diam-wall_thickness*2;
  belt_anchor_width = wheel_spacing_x-eccentric_head_diam;
  belt_anchor_height = belt_above_extrusion-mini_v_wheel_plate_above_extrusion+belt_anchor_thickness+belt_thickness;

  screw_mount_width = wheel_spacing_x/2+eccentric_body_width/2-belt_width/2;

  belt_position_x = -wheel_spacing_x/2+wheel_overhead/2+10;

  echo("rounded_diam: ", rounded_diam);

  module position_eccentric_holes() {
    for(y=[front,rear,0]) {
      translate([right*(wheel_spacing_x/2),y*(size_y/2-eccentric_body_width/2),0]) {
        children();
      }
    }
  }

  module position_plain_holes() {
    translate([left*(wheel_spacing_x/2),0]) {
      for(y=[front,rear,0]) {
        translate([0,y*(size_y/2-rounded_diam/2),0]) {
          children();
        }
      }
    }
  }

  module plate_profile() {
    module body() {
      hull() {
        for(y=[front,rear]) {
          position_plain_holes() {
            accurate_circle(rounded_diam,resolution);
          }
          translate([wheel_spacing_x/2,y*(size_y/2-eccentric_body_width/2),0]) {
            accurate_circle(eccentric_body_width,resolution);
          }
          translate([wheel_spacing_x/2+eccentric_body_width/2-small_rounded_diam/2,y*(size_y/2-small_rounded_diam/2),0]) {
            // accurate_circle(small_rounded_diam,resolution);
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

  module belt_anchor() {
    post_width = (belt_anchor_width-belt_width)/2;
    translate([0,size_y/2-belt_anchor_depth/2,0]) {
      for(x=[left,right]) {
        translate([x*(belt_anchor_width/2-post_width/2),0,belt_anchor_height/2]) {
          rounded_cube(post_width,belt_anchor_depth,belt_anchor_height,small_rounded_diam,resolution);
        }
      }
    }
    translate([0,size_y/2-belt_anchor_depth/2,belt_anchor_height-belt_anchor_thickness/2]) {
      rounded_cube(belt_anchor_width,belt_anchor_depth,belt_anchor_thickness,small_rounded_diam,resolution);
    }
  }

  module body() {
    translate([0,0,mini_v_wheel_plate_thickness/2]) {
      linear_extrude(height=mini_v_wheel_plate_thickness,center=true,convexity=3) {
        plate_profile();
      }
    }

    // extrusion anchor
    translate([belt_width/2+screw_mount_width/2,10+screw_mount_depth/2,mini_v_wheel_plate_thickness+screw_mount_height/2]) {
      rounded_cube(screw_mount_width,screw_mount_depth,screw_mount_height,small_rounded_diam,resolution);
    }

    translate([belt_anchor_width/2,10+screw_mount_depth,belt_anchor_height/2]) {
      // round_corner_filler(small_rounded_diam,belt_anchor_height);
    }

    belt_anchor();

    rotate([0,0,180]) {
      belt_anchor();
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
    translate([wheel_spacing_x/2,10+screw_mount_depth,mini_v_wheel_plate_thickness+10]) {
      rotate([90,0,0]) {
        hole(5.4,size_y*2+1,resolution);
        m5_countersink_screw();
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

