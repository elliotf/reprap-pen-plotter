include <config.scad>;
include <util.scad>;

// YAGNI (TODO):
//   * get retentive about line positions by taking line thickness into account

// x carriage is a piece of wood/metal riding on bearings
// base plate is a piece of plywood
// could also use conduit?

inch = 25.4;

print_width = 18*inch;
print_depth = 24*inch;

extrusion_width = 0.4;
motor_bracket_height = motor_shaft_len + 1;
motor_pulley_mount_height = 25;
wall_thickness = extrusion_width*4;
resolution = 32;

pi = 3.14159;
pulley_tooth_pitch = 2;
pulley_tooth_count = 16;
pulley_circ  = pulley_tooth_pitch*pulley_tooth_count;
pulley_diam  = pulley_circ/pi;

motor_screw_head_diam = 7; // m3 is ~6 to 6.5 + some space

front_back_line_x = print_width/2 + pulley_diam/2;

motor_mount_width = 30;

// assuming F623ZZ
line_bearing_diam      = 10;
line_bearing_inner     = 3;
line_bearing_thickness = 8; // doubled F623zz bearing
washer_thickness       = 1;

rear_idler_pos_x = front_back_line_x - line_bearing_diam/2;
rear_idler_pos_z = front_back_line_x - line_bearing_diam/2;

// https://www.discountsteel.com/items/6063_Aluminum_Equal_Leg_Angle.cfm?item_id=145&size_no=5&pieceLength=full&len_ft=0&len_in=0&len_fraction=0&itemComments=&qty=1#skus
angle_aluminum_width     = (3/4)*inch;
angle_aluminum_thickness = (1/8)*inch;

driver_wraps         = 6;
idler_wraps          = driver_wraps + 1;

steps_per_turn = 200*32; // 1.8deg stepper at 1/32 microstepping
desired_steps_per_mm = 160;
driver_circumference = 16*2;
driver_circumference = steps_per_turn/desired_steps_per_mm;
idler_circumference  = driver_circumference;

driver_diam = driver_circumference/pi;
idler_diam  = idler_circumference/pi;

groove_height  = 0.7;
groove_depth   = 0.5;

top_bottom_groove_dist = (idler_wraps+1)*groove_height+(idler_wraps+1)*groove_depth;

idler_shaft_diam = 5.1;
idler_shaft_nut_diam = 8.1;
driver_idler_dist = motor_side/2 + wall_thickness/2 + idler_shaft_nut_diam/2;

motor_pos_x = print_width/2-angle_aluminum_width-15;

upper_line_pos_x = motor_pos_x + 2.2;
lower_line_pos_x = upper_line_pos_x + top_bottom_groove_dist;
lower_line_pos_z = wall_thickness + motor_side/2 - idler_diam/2;
upper_line_pos_z = lower_line_pos_z + idler_diam;

mount_motor_plate_thickness = 3;

mount_pos_y = -print_depth/2+motor_shaft_len;
x_motor_pos_x = -motor_side-20;
x_motor_pos_y = mount_pos_y+motor_mount_width;
y_motor_pos_x = -x_motor_pos_x;
y_motor_pos_y = mount_pos_y;

module line_bearing() {
  hole(line_bearing_diam,line_bearing_thickness-1,resolution);
  for(z=[top,bottom]) {
    translate([0,0,z*(line_bearing_thickness/2-0.5)]) {
      hole(line_bearing_diam+2,1,resolution);
    }
  }
}

module angle_aluminum(length,width=angle_aluminum_width,height=angle_aluminum_width,thickness=angle_aluminum_thickness) {
  linear_extrude(height=length,center=true,convexity=2) {
    for(x=[left,right]) {
      translate([x*(width/2-thickness/2),height/2]) {
        square([thickness,height],center=true);
      }
    }
    translate([0,thickness/2]) {
      square([width,thickness],center=true);
    }
  }
}

module motor() {
  difference() {
    translate([0,0,-motor_len/2]) cube([motor_side,motor_side,motor_len],center=true);
    for(end=[left,right]) {
      for(side=[front,rear]) {
        translate([motor_hole_spacing/2*side,motor_hole_spacing/2*end,0]) cylinder(r=motor_screw_diam/2,h=100,center=true);
      }
    }
  }

  translate([0,0,motor_shaft_len/2]) cylinder(r=motor_shaft_diam/2,h=motor_shaft_len,center=true);
}

module assembly() {
  translate([0,0,-1]) {
    % cube([print_width,print_depth,2],center=true);
  }

  translate([x_motor_pos_x,x_motor_pos_y,0]) {
    rotate([0,0,90]) {
      motor_mount();
    }
  }

  translate([y_motor_pos_x,y_motor_pos_y,0]) {
    rotate([0,0,-90]) {
      motor_mount();
    }
  }
}

module x_lines() {
  
}

module filament_pulley(circumference=16*2, base_height=6, wraps=5,hole_od=0,od_height=0) {
  diam           = circumference/pi;
  height         = wraps*groove_height+2*(wraps+1)*groove_depth;
  base_diam      = diam+groove_depth*2;
  steps_per_mm   = steps_per_turn/circumference;
  echo("CIRCUMF:   ", steps_per_mm);
  echo("STEPS/MM:  ", steps_per_mm);
  echo("DIAM:      ", diam);
  echo("BASE_DIAM: ", base_diam);
  echo("HEIGHT:    ", height+base_height-groove_depth);

  base_pos_z     = height+base_height/2-groove_depth;
  bottom_pos_z   = 0;
  top_pos_z      = (base_height > 0) ? base_pos_z + base_height/2 : height;

  module profile() {
    difference() {
      union() {
        translate([diam/4,height/2,0]) {
          square([diam/2,height],center=true);
        }

        translate([base_diam/4,base_pos_z,0]) {
          square([base_diam/2,base_height],center=true);
        }

        for (z=[0:wraps]) {
          translate([diam/2,groove_depth+z*(groove_height+groove_depth*2)]) {
            hull() {
              translate([-0.5,0,0]) {
                square([1,groove_depth*2],center=true);
              }
              translate([0,0,0]) {
                square([groove_depth*2,0.005],center=true);
              }
            }
          }
        }
      }
    }
  }

  translate([0,0,height+1]) {
    % difference() {
      profile();
      hole_profile();
    }
  }

  module body() {
    rotate_extrude(convexity=10,$fn=resolution) {
      profile();
    }

    translate([diam/2+1,0,groove_depth*2+groove_height/2]) {
      % cube([1,1,groove_height],center=true);
    }
  }

  module hole_profile() {
    hole_id_diff = 1;
    hole_id = hole_od - hole_id_diff*1.75;

    for (z=[top_pos_z,bottom_pos_z]) {
      translate([0,z]) {
        hull() {
          translate([hole_od/4,0]) {
            square([hole_od/2,od_height*2],center=true);
          }
          translate([hole_id/4,0]) {
            square([hole_id/2,(od_height+hole_id_diff)*2],center=true);
          }
        }
      }
    }

    translate([hole_id/4,0,0]) {
      square([hole_id/2,2*(height+base_height)],center=true);
    }
  }

  module holes() {
    // for driver
    nut_thickness = 2.70;
    nut_diam      = 5.55;
    screw_diam    = 3.15;
    shaft_diam    = 5.1;
    d_cut_depth   = shaft_diam-4.6;
    d_cut_height  = base_height+3;
    d_cut_height  = 100;

    // idler branch
    if (hole_od) {
      rotate_extrude(convexity=10,$fn=12) {
        hole_profile();
      }

      for(z=[top_pos_z+0.1,bottom_pos_z-0.1]) {
        translate([0,0,z]) {
          % hole(hole_od,0.05,resolution);
        }
      }
    }

    // driver
    if (base_height) {
      difference() {
        hole(shaft_diam,50,12);

        translate([shaft_diam/2,0,0]) {
          cube([d_cut_depth*2,shaft_diam+1,d_cut_height*2],center=true);
        }
      }
      translate([shaft_diam/2-d_cut_depth-0.1+nut_thickness/2,0,top_pos_z-nut_diam/2]) {
        rotate([0,90,0]) {
          rotate([0,0,90]) {
            hole(nut_diam,nut_thickness,6);
          }
          translate([0,0,10]) {
            hole(screw_diam,20,16);
          }
        }
        translate([0,0,nut_diam/2]) {
          cube([nut_thickness,nut_diam,nut_diam],center=true);
        }
      }
    }
  }

  difference() {
    body();
    holes();
  }
}

module driver_pulley() {
  base_height   = 6;

  filament_pulley(idler_circumference,base_height,driver_wraps);
}

module idler_pulley() {
  // 625
  bearing_od     = 16;
  bearing_height = 5;

  // MR105 or 623
  bearing_od     = 10.2;
  bearing_height = 4;

  filament_pulley(idler_circumference,0,idler_wraps,bearing_od,bearing_height);
}

module drive_assembly_v2() {
  //rotate([0,0,90]) {
    //rotate([90,0,0]) {
      translate([0,0,1]) {
        //driver_pulley();
      }
      translate([0,0,-motor_len/2-8]) {
        // cube([motor_side,motor_side,motor_len],center=true);
      }

      translate([driver_idler_dist,0,groove_depth+groove_height/2]) {
        //idler_pulley();
      }

      translate([0,0,-motor_pulley_mount_height/2]) {
        motor_mount_v2();
      }
    //}
  //}
}

module motor_mount() {
  mount_base_thickness = 5;
  mount_depth = motor_side+10;
  mount_height = mount_base_thickness+motor_side/2;
  wall_around_motor = 5;

  motor_pos_z = mount_height/2+mount_base_thickness+motor_side/2-mount_height/2;

  idler_shaft_supported_len = 20;

  // m5 bolt/nut
  bed_anchor_area = 10;
  bed_anchor_screw_diam = 5.2;

  // MR105 or 623
  bearing_od     = 10.125;
  bearing_height = 4;

  shaft_support_diam = idler_shaft_diam+8;

  module body_profile() {
    hull() {
      // motor body
      translate([0,0,0]) {
        for(x=[left,right]) {
          for(y=[front,rear]) {
            translate([x*motor_side/2,y*motor_side/2,0]) {
              accurate_circle(wall_around_motor*2,resolution);
            }
          }
        }
      }

      // shaft support
      translate([-driver_idler_dist,0,0]) {
        accurate_circle(shaft_support_diam,resolution);
      }
    }

    hull() {
      for(side=[left,right]) {
        translate([motor_side/2+wall_around_motor/2,side*(motor_side/2+wall_around_motor+bed_anchor_area)]) {
          accurate_circle(wall_around_motor,resolution);
        }
      }
    }
  }

  module body_profile_holes() {
    // motor mount holes
    translate([0,0,0]) {
      for(x=[left,right]) {
        for(y=[front,rear]) {
          translate([x*motor_hole_spacing/2,y*motor_hole_spacing/2,0]) {
            accurate_circle(motor_screw_diam+0.1,8);
          }
        }
      }
    }

    // motor shoulder diam
    accurate_circle(motor_shoulder_diam+1,resolution);
  }

  module body() {
    translate([-motor_mount_width/2,0,motor_pos_z]) {
      rotate([0,90,0]) {
        linear_extrude(height=motor_mount_width,center=true,convexity=2) {
          difference() {
            body_profile();
            body_profile_holes();
          }
        }
      }
    }
  }

  module holes() {
    // motor body
    translate([-mount_motor_plate_thickness,0,motor_pos_z]) {
      rotate([0,90,0]) {
        % motor();
      }
      translate([-motor_len/2,0,0]) {
        cube([motor_len,motor_side,motor_side],center=true);
      }
      for(y=[front,rear]) {
        for(z=[top,bottom]) {
          translate([0,y*motor_hole_spacing/2,z*motor_hole_spacing/2]) {
            rotate([0,90,0]) {
              hole(motor_screw_diam+0.1,motor_bracket_height+1,8);
            }
          }
        }
      }
    }

    // idler shaft support
    threaded_idler_shaft_diam = idler_shaft_diam-0.75;
    translate([0,0,motor_pos_z+driver_idler_dist]) {
      rotate([0,90,0]) {
        translate([0,0,0]) {
          hull() {
            hole(idler_shaft_diam,2*(idler_shaft_supported_len-6),8);
            hole(threaded_idler_shaft_diam,2*(idler_shaft_supported_len-4),8); // last 4mm is for threaded
          }
        }
        // threaded portion of idler shaft
        translate([0,0,0]) {
          hole(threaded_idler_shaft_diam,2*(motor_mount_width-5),8); // FIXME: make the correct depth according to shaft len
        }
      }
    }

    // bed anchor holes
    for(side=[left,right]) {
      translate([-motor_mount_width/2,side*(motor_side/2+wall_around_motor+bed_anchor_area/2),0]) {
        hole(bed_anchor_screw_diam,wall_around_motor*4,8);
      }
    }
  }

  difference() {
    body();
    holes();
  }

  /*
  translate([0,0,motor_side*2]) {
    difference() {
      body_profile();
      body_profile_holes();
    }
  }
  */
}
