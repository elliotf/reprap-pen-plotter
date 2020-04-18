include <config.scad>;
//use <filament-drive.scad>;
use <lib/util.scad>;
use <lib/vitamins.scad>;
use <x-carriage.scad>;
use <y-carriage.scad>;
use <z-axis-mount.scad>;
use <rear-idler-mounts.scad>;
use <base-plate.scad>;
use <misc.scad>;

// TODO
// make X endstop static
// move Y endstop to XY carriage (off of X carriage)
//   include trigger flag on z axis mount
// make X motor static
// make it so that Y belt can be flipped
//   Y- side should have teeth pointing up

// base_plate_for_display();
resolution = 64;

sketch_x_rail_pos_z = 10;
sketch_space_between_rails = 2;
sketch_y_rail_pos_z = sketch_x_rail_pos_z + 20 + sketch_space_between_rails;
sketch_xy_rail_dist_z = sketch_y_rail_pos_z - sketch_x_rail_pos_z;

wheel_axle_diam = 5;

pulley_tooth_pitch = 2;
x_pulley_tooth_count = 16;
y_pulley_tooth_count = 16;

x_pulley_diam = pulley_tooth_pitch*x_pulley_tooth_count/pi;
y_pulley_diam = pulley_tooth_pitch*y_pulley_tooth_count/pi;

belt_width = 6;
belt_pos_x = 0;

y_relative_y_motor_pos_x = right*(belt_width/2+4+nema14_shoulder_height);
y_relative_y_motor_pos_y = front*(nema14_side/2+tolerance);
//y_relative_y_motor_pos_z = 10+nema14_side/2;
y_relative_y_motor_pos_z = 10+nema14_side/2;

y_belt_idler_od = mr105_bearing_od;
y_belt_idler_id = mr105_bearing_id;
y_belt_idler_thickness = mr105_bearing_thickness*2;
y_relative_y_belt_idler_pos_z = 10 + y_belt_idler_od/2 + printed_carriage_outer_skin_from_extrusion + 3;

x_belt_idler_od = mr105_bearing_od;
x_belt_idler_id = mr105_bearing_id;
x_belt_idler_thickness = mr105_bearing_thickness*2;

belt_thickness = 0.63;

motor_side_belt_pos_z = y_relative_y_motor_pos_z-y_pulley_diam/2-belt_thickness/2;
idler_side_belt_pos_z = y_relative_y_belt_idler_pos_z-y_belt_idler_od/2-belt_thickness/2;

wheel_holder_body_diam = m5_thread_into_plastic_hole_diam+(extrude_width*3+extrude_width*2)*2;

y_motor_endcap_thickness = wheel_holder_body_diam;
y_rail_motor_endcap_offset = mini_v_wheel_extrusion_spacing-y_motor_endcap_thickness/2;
y_rail_pos_y = y_rail_motor_endcap_offset;
bevel_height = 1;

x_belt_idler_body_diam = m3_diam+wall_thickness*4;
x_belt_idler_spacing = nema14_hole_spacing;

x_motor_mount_thickness = 3;
x_motor_pos_z = -m5_bolt_head_diam/2-tolerance-0.2;
x_motor_pos_y = y_motor_endcap_thickness+nema14_side/2+tolerance+belt_thickness*2;
x_belt_idler_pos_y = x_motor_pos_y-nema14_hole_spacing/2;
x_belt_idler_bevel_pos_z = x_motor_pos_z-x_motor_mount_thickness-bevel_height;

t_slot_nut_length = 11;

extrusion_height = 20;
extrusion_width = 40;

x_belt_pos_z = extrusion_height - belt_width/2 + x_pulley_diam + belt_thickness/2 + 1;
x_belt_offset_y = 10;

module belt_teeth(length,opening_side=top) {
  tooth_diam  = 1.4;
  tooth_pitch = 2;
  num_teeth = floor(length / tooth_pitch);
  extra_room_in_cavity = 2;
  overall_width = belt_width+extra_room_in_cavity;

  extra_belt_thickness_room = 0.15;

  module belt_tooth_profile() {
    translate([-extra_belt_thickness_room/2,0,0]) {
      square([1+extra_belt_thickness_room,tooth_pitch*(2*num_teeth+1)],center=true);
    }

    for(side=[left,right]) {
      for(i=[0:num_teeth]) {
        translate([0.5,2*i*side,0]) {
          accurate_circle(tooth_diam,6);
        }
      }
    }
  }

  // belt opening, to make it easier to insert the belt
  rotate([90,0,0]) {
    linear_extrude(height=length*2,center=true,convexity=3) {
      translate([0,opening_side*overall_width/2]) {
        hull() {
          // belt cavity
          translate([-extra_belt_thickness_room/2,0,0]) {
            square([1+ extra_belt_thickness_room,3],center=true);

            translate([-0.5+1.5,opening_side*3]) {
              square([3+extra_belt_thickness_room,1],center=true);
            }
          }
        }
      }
    }
  }
  // belt teeth
  translate([0,0,0]) {
    linear_extrude(height=overall_width,center=true,convexity=5) {
      belt_tooth_profile();
    }
  }
}

module y_belt_idler() {
  difference() {
    union() {
      hole(y_belt_idler_od,y_belt_idler_thickness,resolution);
      for(z=[top,bottom]) {
        translate([0,0,z*(y_belt_idler_thickness/2-0.5)]) {
          hole(y_belt_idler_od+2,1,resolution);
        }
      }
    }
    hole(y_belt_idler_id,y_belt_idler_thickness+1,resolution);
  }
}

module wheel_shaft_holder(length=(sketch_xy_rail_dist_z-bevel_height-mini_v_wheel_thickness/2)) {
  bevel_pos = -sketch_xy_rail_dist_z+mini_v_wheel_thickness/2;
  hull() {
    translate([0,0,bevel_pos]) {
      translate([0,0,bevel_height+length/2]) {
        hole(wheel_holder_body_diam,length,resolution);
      }
    }
    translate([0,0,-sketch_xy_rail_dist_z+1+mini_v_wheel_thickness/2]) {
      hole(m5_thread_into_plastic_hole_diam+extrude_width*4,2,resolution);

      translate([0,0,-mini_v_wheel_thickness/2-1]) {
        % color("dimgrey") mini_v_wheel();
      }
    }
  }
}

module x_min_endcap() {
  motor_offset_x = -10;
  plate_thickness = 3;
  // between the X/Y extrusions, requires more space between extrusions
  // x_motor_offset_y = extrusion_width/2 + nema14_shoulder_height + 2;
  // x_motor_offset_z = extrusion_height/2 + x_pulley_diam/2 + sketch_space_between_rails - 1;
  // running in one of the channels with motor aligned with Y axis
  x_motor_offset_x = -nema17_side/2-plate_thickness;
  x_motor_offset_y = extrusion_width/2 + nema14_shoulder_height - 2;
  //x_motor_offset_z = extrusion_height/2 + sketch_space_between_rails + x_pulley_diam/2 - belt_width/2 - 1;
  //x_motor_offset_z = extrusion_height/2+x_pulley_diam/2-v_slot_depth-v_slot_cavity_depth+belt_thickness+belt_width/2+1; // recent
  x_motor_offset_z = x_belt_pos_z - x_pulley_diam/2 - extrusion_height/2;
  // running in one of the channels with motor aligned with Z axis
  //x_motor_offset_y = extrusion_width/2-x_pulley_diam/2+1;
  //x_motor_offset_z = extrusion_height/2 + nema17_shoulder_height + sketch_space_between_rails + 2.5;

  rounded_diam = wall_thickness*2;
  overall_height = x_motor_offset_z + extrusion_height/2 + nema17_side/2;
  overall_width = nema17_side + plate_thickness;
  overall_depth = x_motor_offset_y + extrusion_width/2;

  endstop_mount_hole_diam = mech_endstop_tiny_mounting_hole_diam+0.2;
  endstop_mount_height = 10;
  endstop_mount_width = endstop_mount_hole_diam+wall_thickness*4;
  endstop_mount_depth = mech_endstop_tiny_length+4;

  module position_main_block() {
    translate([x_motor_offset_x-nema17_side/2+overall_width/2,-extrusion_width/2+overall_depth/2,-extrusion_height/2+overall_height/2]) {
      children();
    }
  }

  module position_endstop() {
    translate([mech_endstop_tiny_height,extrusion_width/2+mech_endstop_tiny_length/2-3,x_motor_offset_z+nema17_side/2+mech_endstop_tiny_width/2]) {
      rotate([0,90,0]) {
        rotate([0,0,0]) {
          children();
        }
      }
    }
  }

  position_endstop() {
    translate([-0.1,0,0]) {
      % mech_endstop_tiny();
    }
  }

  module position_motor() {
    translate([x_motor_offset_x,x_motor_offset_y,x_motor_offset_z]) {
      rotate([90,0,0]) {
        children();
      }
    }
  }

  module body() {
    position_main_block() {
      cube([overall_width,overall_depth,overall_height],center=true);
    }

    hull() {
      position_endstop() {
        translate([mech_endstop_tiny_width/2+endstop_mount_height/2,0,-mech_endstop_tiny_mounting_hole_from_top]) {
          cube([endstop_mount_height,endstop_mount_depth,endstop_mount_width],center=true);

          translate([0,-endstop_mount_depth/2,-endstop_mount_width/2+0.1]) {
            rotate([90,0,0]) {
              cube([endstop_mount_height,0.2,endstop_mount_width*2],center=true);
            }
          }
        }
      }
    }
  }

  module holes() {
    // mount to aluminum extrusion
    for(y=[front,rear]) {
      translate([-6,10*y,0]) {
        rotate([0,90,0]) {
          hole(5.1,30,resolution);
        }
      }
    }

    // mount endstop
    position_endstop() {
      for(y=[front,rear]) {
        translate([0,y*mech_endstop_mounting_hole_spacing_y/2,-mech_endstop_tiny_mounting_hole_from_top]) {
          rotate([0,90,0]) {
            hole(endstop_mount_hole_diam,50,8);
          }
        }
      }
    }

    // belt hole
    translate([0,x_belt_offset_y,x_motor_offset_z]) {
      rotate([0,90,0]) {
        rounded_cube(x_pulley_diam+5,10,30,6,resolution);
      }
    }

    // cut away most of the material
    hull() {
      position_main_block() {
        translate([-overall_width/2-1,-plate_thickness,0]) {
          cube([2,overall_depth,overall_height+1],center=true);
        }
        translate([-plate_thickness,-overall_depth/2-1,0]) {
          cube([overall_width,2,overall_height+1],center=true);
        }
      }
    }

    // cut away the when-printing peak
    position_main_block() {
      round_amount = 2;
      translate([overall_width/2,overall_depth/2,-endstop_mount_height]) {
        linear_extrude(height=overall_height,center=true) {
          difference() {
            square([round_amount,round_amount],center=true);
            translate([-round_amount/2,-round_amount/2,0]) {
              accurate_circle(round_amount,32);
            }
          }
        }
      }
    }

    position_motor() {
      % motor_nema17();

      // motor shoulder
      hull() {
        hole(nema17_shoulder_diam+1,nema17_len*2,resolution);
        translate([nema17_shoulder_diam/2,0,0]) {
          cube([1,10,50],center=true);
        }
      }

      // main opening
      translate([0,0,plate_thickness+25]) {
        rounded_cube(nema17_side-wall_thickness*4,nema17_side-wall_thickness*4,50,4);
      }

      translate([0,0,10]) {
        % hole(x_pulley_diam,6,resolution);

        for(z=[top,bottom]) {
          translate([0,0,z*9/2]) {
            % hole(x_pulley_diam+2,1,resolution);
          }
        }
      }

      for(x=[left,right],y=[front,rear]) {
        translate([x*(nema17_hole_spacing/2),y*(nema17_hole_spacing/2),0]) {
          hole(m3_diam+tolerance,extrusion_width*4,8);
        }
      }
    }

    /*
    // motor aligned with the Z axis and travelling in a x rail channel
    translate([left*(nema17_side/2),x_motor_offset_y,x_motor_offset_z]) {
      rotate([180,0,0]) {
        % motor_nema17();

        # translate([0,0,8]) {
          % hole(x_pulley_diam,6,resolution);

          for(z=[top,bottom]) {
            translate([0,0,z*9/2]) {
              % hole(x_pulley_diam+2,1,resolution);
            }
          }
        }
      }
    }
    */

    // cut away most of the block
    cut_diam = 2*(nema14_side);
    translate([-cut_diam/2+motor_offset_x,x_motor_offset_y+cut_diam/2+6,0]) {
      //hole(cut_diam,nema14_side*2,resolution*2);
    }

    translate([-nema14_side/2+motor_offset_x,x_motor_offset_y,x_motor_offset_z]) {
      /*
      rotate([90,0,0]) {
        % motor_nema14();

        # translate([0,0,8]) {
          % hole(x_pulley_diam,6,resolution);

          for(z=[top,bottom]) {
            translate([0,0,z*9/2]) {
              % hole(x_pulley_diam+2,1,resolution);
            }
          }
        }
      }
      */

      rotate([-90,0,0]) {
        /*
        % motor_nema14();

        # translate([0,0,10]) {
          % hole(x_pulley_diam,6,resolution);

          for(z=[top,bottom]) {
            translate([0,0,z*9/2]) {
              % hole(x_pulley_diam+2,1,resolution);
            }
          }
        }
        */

        /*
        for(y=[front,rear]) {
          translate([-nema14_hole_spacing/2,y*nema14_hole_spacing/2,0]) {
            spacing = (nema14_side-nema14_hole_spacing);
            difference() {
              translate([-1*spacing/2,y*spacing/2,0]) {
                cube([spacing,spacing,nema14_len],center=true);
              }
              hole(spacing,nema14_len,8);
            }
          }
        }

        // motor shoulder and shaft
        hull() {
          hole(nema14_shoulder_diam*0.75,nema14_len*3,resolution);
          rounded_cube(nema14_shoulder_diam+1,10,nema14_len*3,2,resolution);
        }
        hull() {
          hole(nema14_shoulder_diam+1,nema14_shoulder_height*2,resolution);
          hole(nema14_shoulder_diam+1+nema14_shoulder_height,0.05,resolution);
        }

        // main motor body
        translate([0,0,-nema14_len]) {
          cube([nema14_side+0.5,nema14_side+0.5,nema14_len*2],center=true);
        }

        translate([0,0,-motor_offset_y]) {
          % hole(x_pulley_diam,6,resolution);

          for(z=[top,bottom]) {
            translate([0,0,z*9/2]) {
              % hole(x_pulley_diam+2,1,resolution);
            }
          }
        }

        // motor mounting holes
        for(x=[left,right]) {
          for(y=[front,rear]) {
            translate([x*nema14_hole_spacing/2,y*nema14_hole_spacing/2,0]) {
              hole(3.1,100,8);

              translate([0,0,6+20]) {
                hole(7.1,40,8);
              }
            }
          }
        }
        */
      }
    }
  }

  difference() {
    body();
    holes();
  }
}

module bevel(outer,inner,height) {
  hull() {
    translate([0,0,-height-0.1]) {
      hole(outer,0.2,resolution);
    }
    translate([0,0,-0.1]) {
      hole(inner,0.2,resolution);
    }
  }
}

module x_max_endcap() {
  endcap_thickness = 12;
  idler_pos_z = -extrusion_width/2+x_belt_pos_z+x_pulley_diam/2;
  idler_pos_x = endcap_thickness/2;

  idler_bearing_height = 8;
  idler_bearing_inner = 3;
  idler_bearing_outer = 10;

  module position_idler() {
    translate([idler_pos_x,x_belt_offset_y,idler_pos_z]) {
      rotate([90,0,0]) {
        children();
      }
    }
  }

  module body() {
    hull() {
      position_idler() {
        hole(endcap_thickness,extrusion_width/2,12);

        //translate([idler_pos_x,x_belt_offset_y,idler_pos_z-idler_bearing_outer/2]) {
        translate([0,-idler_bearing_outer,0]) {
          cube([endcap_thickness,1,extrusion_width/2],center=true);
        }
      }
    }
    translate([endcap_thickness/2,0,0]) {
      rotate([0,90,0]) {
        rounded_cube(extrusion_height,extrusion_width,endcap_thickness,1);
      }
    }
  }

  module holes() {
    // mount to aluminum extrusion
    for(y=[front,rear]) {
      translate([6,10*y,0]) {
        rotate([0,90,0]) {
          hole(5.1,30,resolution);

          translate([0,0,-nema14_side/4]) {
            // hole(8.6,nema14_side/2,resolution);
          }
        }
      }
    }

    // belt hole
    translate([0,x_belt_offset_y,idler_pos_z+10]) {
      rotate([0,90,0]) {
        rounded_cube(x_pulley_diam+5+20,10,nema14_side*3,6,resolution);
      }
    }

    position_idler() {
    }
  }

  module bridges() {
    position_idler() {
      for(z=[top,bottom]) {
        mirror([0,0,z+1]) {
          translate([0,0,-idler_bearing_height/2]) {
            bevel(idler_bearing_outer,idler_bearing_inner+extrude_width*4,1);
          }
        }
      }
    }
  }

  difference() {
    union() {
      difference() {
        body();
        holes();
      }
      bridges();
    }

    // screw for idler
    position_idler() {
      hole(idler_bearing_inner,50,8);
      translate([0,0,-extrusion_width/2/2]) {
        hole(m3_nut_diam,3*2,6);
      }
    }
  }

  position_idler() {
    % hole(10,8,resolution);
  }
}

module belt_idler_bearings() {
  difference() {
    union() {
      hole(x_belt_idler_od,x_belt_idler_thickness,resolution);
      for(z=[top,bottom]) {
        translate([0,0,z*(x_belt_idler_thickness/2-0.5)]) {
          hole(x_belt_idler_od+2,1,resolution);
        }
      }
    }
    hole(x_belt_idler_id,x_belt_idler_thickness+1,resolution);
  }
}

module y_endcap() {
  height = 20 + nema14_side;

  m3_hole_diam = m3_diam;
  m3_hole_body_diam = m3_hole_diam + wall_thickness*4;

  wheel_spacing = 20+wheel_holder_body_diam+m5_bolt_head_diam+tolerance;

  thread_into_motor = 4;
  non_shaft_side_screw_length = 50;
  shaft_side_screw_length = x_belt_idler_thickness + bevel_height + x_motor_mount_thickness + thread_into_motor;
  echo("shaft_side_screw_length: ", shaft_side_screw_length);

  non_shaft_side_screw_head_pos_z = x_motor_pos_z + thread_into_motor + 1 + non_shaft_side_screw_length;

  translate([y_relative_y_motor_pos_x,y_relative_y_motor_pos_y,y_relative_y_motor_pos_z]) {
    % rotate([0,-90,0]) {
      translate([0,0,nema14_shoulder_height+y_relative_y_motor_pos_x-2]) {
        hole(y_pulley_diam,6,resolution);
      }
      motor_nema14();
    }
  }

  module body() {
    hull() {
      for(x=[left,right]) {
        bottom_pos_z = -sketch_xy_rail_dist_z+bevel_height+mini_v_wheel_thickness/2;
        translate([x*wheel_spacing/2,y_motor_endcap_thickness/2,bottom_pos_z+1]) {
          hole(y_motor_endcap_thickness,2,resolution);
        }
        translate([x*wheel_spacing/2,y_motor_endcap_thickness/2,10+nema14_side-1]) {
          hole(y_motor_endcap_thickness,2,resolution);
        }
      }
    }

    for(x=[left,right]) {
      // wheels
      translate([x*(wheel_spacing/2),y_motor_endcap_thickness/2,0]) {
        wheel_shaft_holder();
      }
      // put bracing between wheel shafts to make it easier to print because of less retraction?
    }

    // Y motor mount
    y_mount_height = height-20;
    y_mount_thickness = wall_thickness*4;
    translate([y_relative_y_motor_pos_x-y_mount_thickness/2,y_relative_y_motor_pos_y+nema14_side/2,-10+height-y_mount_height/2]) {
      length_on_motor_side = nema14_side-nema14_hole_spacing;

      hull() {
        cube([y_mount_thickness,1,y_mount_height],center=true);
        translate([0,-length_on_motor_side/2,0]) {
          rounded_cube(y_mount_thickness,length_on_motor_side,y_mount_height,y_mount_thickness,resolution);
        }
      }
    }
  }

  module holes() {
    for(x=[left,right]) {
      // wheel axle
      translate([x*wheel_spacing/2,y_motor_endcap_thickness/2,-sketch_xy_rail_dist_z-mini_v_wheel_thickness/2]) {
        hole(m5_thread_into_plastic_hole_diam,50*2,resolution);
      }

      // mount to extrusion
      translate([x*10,x_motor_pos_y-nema14_side/2,0]) {
        rotate([90,0,0]) {
          hole(5+tolerance,50,8);
          rotate([0,0,90]) {
            hole(m5_bolt_head_diam+tolerance,(m5_bolt_head_height+1)*2,8);
          }
        }
      }
    }

    // mount Y motor
    translate([y_relative_y_motor_pos_x,y_relative_y_motor_pos_y,y_relative_y_motor_pos_z]) {
      rotate([0,90,0]) {
        hole(nema14_shoulder_diam+2,20,resolution);
      }

      for(z=[top,bottom]) {
        translate([0,nema14_hole_spacing/2,z*nema14_hole_spacing/2]) {
          rotate([0,90,0]) {
            hole(m3_diam+tolerance,20,16);
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

module y_endcap_with_idler() {
  foot_bearing_od = 625_bearing_od;
  foot_bearing_id = 625_bearing_id;
  foot_bearing_thickness = 625_bearing_thickness;
  foot_bearing_pos_x = 10;
  foot_bearing_pos_z = -sketch_y_rail_pos_z+foot_bearing_od/2;

  rounded_diam = 5;

  bevel_height = 1;

  plate_thickness = 15;
  idler_arm_thickness = wall_thickness*4;
  idler_bearing_opening = y_belt_idler_thickness+tolerance*2;

  module body() {
    // main body
    translate([0,-plate_thickness/2,0]) {
      rotate([90,0,0]) {
        rounded_cube(40,20+rounded_diam,plate_thickness,rounded_diam,resolution);
      }
    }

    translate([foot_bearing_pos_x,-plate_thickness/2,0]) {
      diam = m5_thread_into_plastic_hole_diam+wall_thickness*4;
      for(x=[left,right]) {
        translate([x*diam/2,0,-20/2]) {
          rotate([90,0,0]) {
            rotate([0,0,-135+x*45]) {
              round_corner_filler(diam/2,plate_thickness);
            }
          }
        }
      }
      hull() {
        translate([0,0,-20/2]) {
          cube([diam,plate_thickness,1],center=true);
        }
        translate([0,0,foot_bearing_pos_z]) {
          rotate([90,0,0]) {
            hole(diam,plate_thickness,resolution);
          }
        }
      }
    }

    // belt idler support main body
    translate([0,-plate_thickness/2,0]) {
      difference() {
        hull() {
          cube([idler_bearing_opening+bevel_height*2+wall_thickness*4,plate_thickness,1],center=true);

          translate([0,0,y_relative_y_belt_idler_pos_z-y_belt_idler_id]) {
            cube([idler_bearing_opening+bevel_height*2+wall_thickness*4,plate_thickness,1],center=true);
          }
        }
        translate([0,0,y_relative_y_belt_idler_pos_z]) {
          rotate([0,90,0]) {
            hole(y_belt_idler_od+8,idler_bearing_opening*2,resolution);
          }
          translate([0,plate_thickness/2,0]) {
            cube([idler_bearing_opening*2,plate_thickness,y_belt_idler_od+8],center=true);
          }
        }
      }
    }

    // belt idler support arms
    for(x=[left,right]) {
      idler_arm_pos_x = idler_bearing_opening/2+bevel_height+idler_arm_thickness/2;
      translate([x*(idler_arm_pos_x),-plate_thickness/2,0]) {
        hull() {
          cube([idler_arm_thickness,plate_thickness,1],center=true);

          translate([0,0,y_relative_y_belt_idler_pos_z+idler_arm_thickness/2]) {
            rotate([90,0,0]) {
              rounded_cube(idler_arm_thickness,y_belt_idler_id+wall_thickness*4,plate_thickness,idler_arm_thickness,resolution);
            }
          }
        }

        translate([-x*(idler_arm_thickness/2),0,y_relative_y_belt_idler_pos_z]) {
          hull() {
            rotate([0,x*90,0]) {
              hole(m5_thread_into_plastic_hole_diam+extrude_width*4,bevel_height*2,8);
              translate([0,0,1]) {
                hole(m5_thread_into_plastic_hole_diam+wall_thickness*4,2,8);
              }
            }
          }
        }
      }
      translate([x*(idler_arm_pos_x+idler_arm_thickness/2),-plate_thickness/2,20/2]) {
        rotate([90,0,0]) {
          rotate([0,0,45-x*45]) {
            round_corner_filler(10,plate_thickness);
          }
        }
      }
    }

    // endstop / limit switch trigger
    /*
    hull() {
      translate([20,-plate_thickness/2,0]) {
        rotate([-90,0,0]) {
          translate([0,0,plate_thickness/2-2]) {
            rounded_cube(36,10,4,10,resolution);
          }
          translate([-5,0,-plate_thickness/2+0.1]) {
            hole(10,0.2,resolution);
          }
        }
      }
    }
    */

    // foot bearing bevel
    translate([foot_bearing_pos_x,-plate_thickness,foot_bearing_pos_z]) {
      rotate([-90,0,0]) {
        hull() {
          hole(m5_thread_into_plastic_hole_diam+extrude_width*4,bevel_height*2,resolution);
          translate([0,0,1]) {
            hole(m5_thread_into_plastic_hole_diam+wall_thickness*4,2,resolution);
          }
        }
      }
    }
  }

  module holes() {
    // mount to extrusion
    for(x=[left,right]) {
      translate([x*10,0,0]) {
        rotate([90,0,0]) {
          hole(5,plate_thickness*2+1,8);
        }
      }
    }

    // belt idler
    translate([0,-plate_thickness/2,y_relative_y_belt_idler_pos_z]) {
      rotate([0,90,0]) {
        hole(5,40,8);

        % color("silver") y_belt_idler();
      }
    }

    // wheel foot
    translate([foot_bearing_pos_x,-plate_thickness-bevel_height-foot_bearing_thickness/2,foot_bearing_pos_z]) {
      rotate([90,0,0]) {
        hole(m5_thread_into_plastic_hole_diam,plate_thickness*3,16);
        % color("silver") difference() {
          hole(foot_bearing_od,foot_bearing_thickness,resolution);
          hole(foot_bearing_id,foot_bearing_thickness+1,resolution);
        }
      }
    }
  }

  difference() {
    body();
    holes();
  }
}

module pen_carriage() {
  tensioner_pos_x = x_carriage_width/2-tuner_thick_diam/2-printed_carriage_wall_thickness;
  tensioner_pos_y = x_carriage_line_spacing/2;
  tensioner_pos_z = 10+line_bearing_above_extrusion+tuner_thin_diam/2;
  tensioner_angle_around_x = 9;

  carriage_wall_thickness = extrude_width*8;
  cavity_width = x_carriage_overall_depth-carriage_wall_thickness*2;
  cavity_height = x_carriage_overall_height-carriage_wall_thickness*2;

  module spring_cavity_profile() {
    gap_width = cavity_height - x_rail_extrusion_height;

    rounded_square(cavity_width+0.1,cavity_height+0.1,gap_width);
  }

  module carriage_profile_body() {
    rotate([0,0,90]) {
      // rotated because it was originally designed for y carriage, which is rotated 90deg
      printed_extrusion_carriage_profile(x_carriage_overall_height,x_carriage_overall_depth);
    }

    // z axis mounting plate
    difference() {
      translate([front*(x_carriage_opening_depth/2+printed_carriage_wall_thickness/2),0]) {
        rounded_square(printed_carriage_wall_thickness,z_carriage_carrier_height,printed_carriage_inner_diam);

        translate([printed_carriage_wall_thickness/2,0,0]) {
          square([printed_carriage_wall_thickness,x_carriage_overall_height],center=true);
        }
      }

      spring_cavity_profile();
    }

    translate([front*(x_carriage_opening_depth/2),0]) {
      // round out internal corners
      for(z=[top,bottom]) {
        mirror([0,1-z]) {
          translate([0,x_carriage_overall_height/2]) {
            round_corner_filler_profile(printed_carriage_inner_diam);
          }
        }
      }
    }
  }

  line_hole_diam = 2;

  belt_clamp_extra_hole_depth = 1.5;
  belt_clamp_body_extra = wall_thickness*2;
  belt_clamp_extra_opening_side = 1.5;
  belt_clamp_body_width = belt_width+belt_clamp_extra_opening_side+belt_clamp_extra_hole_depth+belt_clamp_body_extra;

  module body() {
    rotate([90,0,0]) {
      rotate([0,90,0]) {
        linear_extrude(height=x_carriage_width,center=true,convexity=3) {
          carriage_profile_body();
        }
      }
    }

    module belt_clamp(belt_pos_z) {
      rotate([90,0,0]) {
        rotate([0,90,0]) {
          linear_extrude(height=x_carriage_width/2,center=true,convexity=3) {
            translate([belt_clamp_extra_opening_side+belt_width/2-belt_clamp_body_width/2,0]) {
              translate([0,x_carriage_overall_height/2,0]) {
                for(y=[front,rear]) {
                  translate([y*belt_clamp_body_width/2,0,0]) {
                    rotate([0,0,45-y*45]) {
                      round_corner_filler_profile(4,resolution);
                    }
                  }
                }
              }

              hull() {
                translate([0,belt_pos_z+belt_thickness/2]) {
                  rounded_square(belt_clamp_body_width,wall_thickness*4,4,resolution);
                }
                translate([0,x_carriage_overall_height/2,0]) {
                  square([belt_clamp_body_width,1],center=true);
                }
              }
            }
          }
        }
      }
    }

    translate([-x_carriage_width/4,0,0]) {
      belt_clamp(idler_side_belt_pos_z);
    }
    translate([x_carriage_width/4,0,0]) {
      belt_clamp(motor_side_belt_pos_z);
    }
  }

  module holes() {
    // z carriage carrier mounting holes
    for(x=[left,right]) {
      for (z=[top,bottom]) {
        translate([x*z_carriage_carrier_hole_spacing_x/2,front*(x_carriage_overall_depth/2-printed_carriage_wall_thickness/2),z*z_carriage_carrier_hole_spacing_z/2]) {
          rotate([90,0,0]) {
            hole(m3_threaded_insert_diam,printed_carriage_wall_thickness+1,8);
          }
        }
      }
    }

    translate([0,belt_pos_x,0]) {
      // motor to carriage
      translate([0,0,motor_side_belt_pos_z]) {
        translate([x_carriage_width/2,0,0]) {
          rotate([0,-90,90]) {
            belt_teeth(x_carriage_width,bottom);
          }
        }
      }

      // idler to carriage
      translate([0,0,idler_side_belt_pos_z]) {
        translate([-x_carriage_width/2,0,0]) {
          rotate([0,-90,90]) {
            belt_teeth(x_carriage_width/2,bottom);
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

module old_wheeled_sidemount(side) {
  width = wheel_holder_body_diam;

  length_in_front = mini_v_wheel_od/2+mini_v_wheel_extrusion_spacing+1;
  length = length_in_front+36; // leave a few mm before the end to be able to tighten against X extrusion
  height = 16;
  rounded_diam = wall_thickness*4;
  m5_hole_diam = 5+tolerance;

  mount_bolt_positions = [
    -mini_v_wheel_extrusion_spacing+m5_thread_into_plastic_hole_diam/2+wall_thickness*2+m5_hole_diam/2,
    -length_in_front+length-wheel_axle_diam-wall_thickness*2,
  ];
  mount_bolt_dist = abs(mount_bolt_positions[0] - mount_bolt_positions[1]);

  support_width = extrude_width*4;
  support_height = (height - v_slot_gap)/2 + 0.2;
  support_pos_x = -5-extrude_width-support_width/2;
  support_bridge_pos_z = height/2-support_height+0.1;

  module body() {
    translate([0,-length_in_front+length/2,0]) {
      // main body
      translate([width/2,0,0]) {
        rounded_cube(width,length,height,rounded_diam,resolution);
      }

      // anti-tilt material that pushes against v slot angle
      hull() {
        translate([rounded_diam/2+tolerance,0,0]) {
          rounded_cube(rounded_diam+v_slot_depth*2,length,v_slot_gap,rounded_diam,resolution);
          dist = width/2-rounded_diam/2-tolerance;
          translate([dist,0,0]) {
            rounded_cube(rounded_diam,length,v_slot_width+dist*2,rounded_diam,resolution);
          }
        }
      }

      // anti-tilt material that fits in slot
      translate([width/2-5,0,0]) {
        rounded_cube(width,length,v_slot_gap,rounded_diam,resolution);
      }

      // bridge support
      translate([0,0,support_bridge_pos_z]) {
        cube([abs(support_pos_x)*2,length,0.2],center=true);
      }
    }

    // wheel shaft holder  :)
    translate([width/2,-mini_v_wheel_extrusion_spacing,0]) {
      wheel_shaft_holder();
    }
  }

  module holes() {
    // wheel shaft
    translate([width/2,-mini_v_wheel_extrusion_spacing,0]) {
      hole(m5_thread_into_plastic_hole_diam,50,resolution);
    }

    // bolt holes to mount to extrusion
    for(y=mount_bolt_positions) {
      translate([-5,y,0]) {
        rotate([0,90,0]) {
          hole(wheel_axle_diam+tolerance,50,8);
        }
        cube([10,t_slot_nut_length,height],center=true);
      }
    }
  }

  module bridges() {
    translate([0,mount_bolt_positions[0]+mount_bolt_dist/2,support_bridge_pos_z]) {
      cube([8,mount_bolt_dist-t_slot_nut_length,0.2],center=true);
    }
    translate([support_pos_x,-length_in_front+length/2,v_slot_gap/2+support_height/2-0.2]) {
      rounded_cube(support_width,length,support_height,support_width,resolution);
    }
  }

  difference() {
    body();
    holes();
  }
  bridges();
}

module wheeled_sidemount(side) {
  width = wheel_holder_body_diam;

  mount_spacing = 28;

  height = 16;
  rounded_diam = wall_thickness*4;
  m5_hole_diam = 5+tolerance;

  front_pos_y = front*(mini_v_wheel_extrusion_spacing+m5_thread_into_plastic_hole_diam/2+wall_thickness*2+m5_hole_diam/2);
  rear_pos_y = front_pos_y + mount_spacing;

  mount_bolt_positions = [
    front_pos_y,
    rear_pos_y
  ];

  dist_from_mount_hole_to_end = m5_hole_diam/2+wall_thickness*2;
  overall_length = mount_spacing + dist_from_mount_hole_to_end*2;
  mount_bolt_dist = abs(mount_bolt_positions[0] - mount_bolt_positions[1]);

  support_width = extrude_width*4;
  support_height = (height - v_slot_gap)/2 + 0.2;
  support_pos_x = -5-extrude_width-support_width/2;
  support_bridge_pos_z = height/2-support_height+0.1;

  module body() {
    translate([0,front_pos_y-dist_from_mount_hole_to_end+overall_length/2,0]) {
      translate([width/2,0,0]) {
        rounded_cube(width,overall_length,height,rounded_diam,resolution);
      }

      // anti-tilt material that pushes against v slot angle
      hull() {
        translate([rounded_diam/2+tolerance,0,0]) {
          rounded_cube(rounded_diam+v_slot_depth*2,overall_length,v_slot_gap,rounded_diam,resolution);
          dist = width/2-rounded_diam/2-tolerance;
          translate([dist,0,0]) {
            rounded_cube(rounded_diam,overall_length,v_slot_width+dist*2,rounded_diam,resolution);
          }
        }
      }

      // anti-tilt material that fits in slot
      translate([width/2-5,0,0]) {
        rounded_cube(width,overall_length,v_slot_gap,rounded_diam,resolution);
      }

      // bridge support
      translate([0,0,support_bridge_pos_z]) {
        cube([abs(support_pos_x)*2,overall_length,0.2],center=true);
      }
    }

    // wheel shaft holder  :)
    translate([width/2,-mini_v_wheel_extrusion_spacing,0]) {
      wheel_shaft_holder();
    }
  }

  module holes() {
    // wheel shaft
    translate([width/2,-mini_v_wheel_extrusion_spacing,0]) {
      hole(m5_thread_into_plastic_hole_diam,50,resolution);
    }

    // bolt holes to mount to extrusion
    for(y=mount_bolt_positions) {
      translate([-5,y,0]) {
        rotate([0,90,0]) {
          hole(wheel_axle_diam+tolerance,50,8);
        }
        cube([10,t_slot_nut_length,height],center=true);
      }
    }
  }

  module bridges() {
    translate([0,mount_bolt_positions[0]+mount_bolt_dist/2,support_bridge_pos_z]) {
      // cube([8,mount_bolt_dist-t_slot_nut_length,0.2],center=true);
    }
    translate([support_pos_x,front_pos_y-dist_from_mount_hole_to_end+overall_length/2,v_slot_gap/2+support_height/2-0.2]) {
      rounded_cube(support_width,overall_length,support_height,support_width,resolution);
    }
  }

  difference() {
    body();
    holes();
  }
  bridges();
}

translate([0,y_rail_len/2-20,sketch_x_rail_pos_z]) {

  translate([0,x_belt_offset_y,x_belt_pos_z-sketch_x_rail_pos_z]) {
    % color("red", 0.5) cube([x_rail_len+50,belt_width,belt_thickness],center=true);

    translate([0,0,-x_pulley_diam]) {
      % color("red", 0.5) cube([x_rail_len+50,belt_width,belt_thickness],center=true);
      % color("red", 0.5) cube([x_rail_len+50,belt_thickness,belt_width],center=true);
    }
  }

  rotate([90,0,90]) {
    color("silver") extrusion_2040(x_rail_len);
  }
  translate([x_rail_len/2,0,0]) {
    x_max_endcap();
  }
  translate([-x_rail_len/2,0,0]) {
    x_min_endcap();
  }
}

translate([1*-29,0,sketch_y_rail_pos_z]) {
  // y belt
  % color("red", 0.5) {
    // motor to idler
    hull() {
      translate([0,y_rail_pos_y+y_rail_len/2+y_relative_y_motor_pos_y,motor_side_belt_pos_z+y_pulley_diam+belt_thickness]) {
        cube([belt_width,1,belt_thickness],center=true);
      }
      translate([0,y_rail_pos_y+-y_rail_len/2-y_belt_idler_od,idler_side_belt_pos_z+y_belt_idler_od+belt_thickness]) {
        cube([belt_width,1,belt_thickness],center=true);
      }
    }

    // idler to carriage
    hull() {
      translate([0,0,idler_side_belt_pos_z]) {
        translate([0,y_rail_pos_y+-y_rail_len/2-y_belt_idler_od,0]) {
          cube([belt_width,1,belt_thickness],center=true);
        }
        translate([0,-x_carriage_width+30,0]) {
          cube([belt_width,1,belt_thickness],center=true);
        }
      }
    }

    // motor to carriage
    hull() {
      translate([0,0,motor_side_belt_pos_z]) {
        translate([0,y_rail_pos_y+y_rail_len/2+y_relative_y_motor_pos_y,0]) {
          cube([belt_width,1,belt_thickness],center=true);
        }
        translate([0,-20,0]) {
          cube([belt_width,1,belt_thickness],center=true);
        }
      }
    }
  }

  translate([0,y_rail_len/2,]) {
    translate([0,-40,0]) {
      for(x=[left,right]) {
        mirror([1-x,0,0]) {
          translate([40/2,0,0]) {
            wheeled_sidemount(x);
          }
        }
      }
    }
  }

  translate([-mech_endstop_mounting_hole_spacing_y/2-10,0,extrusion_height/2+mech_endstop_tiny_width/2]) {
    rotate([0,0,-90]) {
      rotate([0,90,0]) {
        % mech_endstop_tiny();
      }
    }
  }

  translate([0,y_rail_pos_y,0]) {
    rotate([90,0,0]) {
      color("silver") extrusion_2040(y_rail_len);
    }

    translate([0,-27.5,0]) {
      rotate([0,0,90]) {
        color("lightblue") pen_carriage();
      }
      translate([right*x_carriage_overall_depth/2,0,0]) {
        rotate([0,0,90]) {
          z_axis_assembly();
        }
      }
    }

    translate([0,y_rail_len/2,0]) {
      y_endcap();
    }

    translate([0,-y_rail_len/2,0]) {
      y_endcap_with_idler();
    }
  }
}
