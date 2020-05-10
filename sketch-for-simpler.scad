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
// cable chain mounts for Y
// cable chain mounts for X
// tensioning for pen/Y carriage?

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

t_slot_nut_length = 11;

extrusion_height = 20;
extrusion_width = 40;

y_relative_y_motor_pos_x = right*(belt_width/2+4+nema14_shoulder_height);
y_relative_y_motor_pos_y = front*(nema14_side/2+tolerance);
//y_relative_y_motor_pos_z = 10+nema14_side/2;
y_relative_y_motor_pos_z = 10+nema14_side/2;

y_belt_idler_od = mr105_bearing_od;
y_belt_idler_id = mr105_bearing_id;
y_belt_idler_thickness = mr105_bearing_thickness*2;

x_belt_idler_od = mr105_bearing_od;
x_belt_idler_id = mr105_bearing_id;
x_belt_idler_thickness = mr105_bearing_thickness*2;

belt_thickness = 0.63;
extra_belt_thickness_room = 0.15;
belt_thickness_cavity = 1.15;
belt_tooth_diam  = 1.4;

wheel_holder_body_diam = m5_thread_into_plastic_hole_diam+(wall_thickness*2)*2;

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

x_belt_pos_z = extrusion_height - belt_width/2 + x_pulley_diam + belt_thickness/2 + 1;
y_belt_offset_z = extrusion_height/2 - belt_width/2 + x_pulley_diam + belt_thickness/2 + 1;
y_belt_offset_x = extrusion_width/4;
x_belt_offset_y = 10;
//y_relative_y_belt_idler_pos_z = extrusion_height/2 + y_belt_idler_od/2 + printed_carriage_outer_skin_from_extrusion + 3;
y_relative_y_belt_idler_pos_z = y_belt_offset_z - y_belt_idler_od/2;

motor_side_belt_pos_z = y_relative_y_motor_pos_z-y_pulley_diam/2-belt_thickness/2;
idler_side_belt_pos_z = y_relative_y_belt_idler_pos_z-y_belt_idler_od/2-belt_thickness/2;

wheeled_sidemount_spacing = 28;
wheeled_sidemount_front_bolt_pos_y = front*(mini_v_wheel_extrusion_spacing+m5_thread_into_plastic_hole_diam/2+wall_thickness*2+m5_loose_hole/2);
wheeled_sidemount_rear_bolt_pos_y = wheeled_sidemount_front_bolt_pos_y + wheeled_sidemount_spacing;
wheeled_sidemount_bolt_positions = [
  wheeled_sidemount_front_bolt_pos_y,
  wheeled_sidemount_rear_bolt_pos_y
];

module belt_teeth(length,opening_side=top) {
  tooth_pitch = 2;
  num_teeth = floor(length / tooth_pitch);
  extra_room_in_cavity = 2;
  overall_width = belt_width+extra_room_in_cavity;

  module belt_tooth_profile() {
    translate([-extra_belt_thickness_room/2,0,0]) {
      square([belt_thickness_cavity,tooth_pitch*(2*num_teeth+1)],center=true);
    }

    for(side=[left,right]) {
      for(i=[0:num_teeth]) {
        translate([0.5,2*i*side,0]) {
          accurate_circle(belt_tooth_diam,6);
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

  overall_height = x_motor_offset_z + extrusion_height/2 + nema17_side/2;
  overall_width = nema17_side + plate_thickness;
  overall_depth = x_motor_offset_y + extrusion_width/2;

  endstop_mount_hole_diam = mech_endstop_tiny_mounting_hole_diam-0.2;
  endstop_mount_height = 10;
  endstop_mount_width = mech_endstop_tiny_mounting_hole_from_top*2-2.5;
  endstop_mount_depth = mech_endstop_tiny_length+1;

  module position_main_block() {
    translate([x_motor_offset_x-nema17_side/2+overall_width/2,-extrusion_width/2+overall_depth/2,-extrusion_height/2+overall_height/2]) {
      children();
    }
  }

  module position_endstop() {
    translate([1.5,extrusion_width/2-endstop_mount_depth/2,x_motor_offset_z+nema17_side/2+mech_endstop_tiny_width/2+endstop_mount_height/2]) {
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
        }
      }

      position_main_block() {
        translate([0,0,overall_height/2-1]) {

          translate([-overall_width/2+1,overall_depth/2-plate_thickness/2,0]) {
            cube([2,plate_thickness,2],center=true);
          }
          translate([overall_width/2-plate_thickness/2,-overall_depth/2+1,0]) {
            cube([plate_thickness,2,2],center=true);
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
          hole(m5_loose_hole,30,8);
        }
      }
    }

    // mount endstop
    position_endstop() {
      for(y=[front,rear]) {
        translate([0,y*mech_endstop_mounting_hole_spacing_y/2,-mech_endstop_tiny_mounting_hole_from_top]) {
          rotate([0,90,0]) {
            hole(endstop_mount_hole_diam,20,8);
          }
        }
      }
    }

    // belt hole
    translate([0,x_belt_offset_y,x_motor_offset_z]) {
      rotate([0,90,0]) {
        rounded_cube(x_pulley_diam+5,10,30,6,8);
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

    // make room for wheeled carriage holes
    translate([0,wheeled_sidemount_rear_bolt_pos_y,extrusion_height+sketch_space_between_rails]) {
      hull() {
        for(y=[front,rear]) {
          translate([0,-extrusion_width/2+y*2,0]) {
            rotate([0,90,0]) {
              hole(m5_bolt_head_diam+2,30,8);
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
        rounded_cube(nema17_side-wall_thickness*4,nema17_side-wall_thickness*4,50,wall_thickness*2);
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
  rounded_diam = 3;
  overall_height = extrusion_height;
  overall_width = extrusion_width;
  endcap_thickness = 15;
  bevel_height = 1;
  idler_arm_thickness = wall_thickness*4;
  idler_bearing_opening = y_belt_idler_thickness+tolerance*2+bevel_height*2;

  idler_pos_x = endcap_thickness/2;
  idler_pos_z = -extrusion_width/2+x_belt_pos_z+x_pulley_diam/2;

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

  module body_profile() {
    module body() {
      translate([-rounded_diam/4,0,0]) {
        rounded_square(overall_width+rounded_diam/2,overall_height,rounded_diam,resolution);
      }

      // belt idler support arms
      idler_arm_pos_x = idler_bearing_opening/2+idler_arm_thickness/2;
      translate([x_belt_offset_y,0,0]) {
        for(x=[left,right]) {
          translate([x*(idler_arm_pos_x),0,0]) {
            hull() {
              square([idler_arm_thickness,1],center=true);

              translate([0,idler_pos_z+idler_arm_thickness/2]) {
                rounded_square(idler_arm_thickness,m5_thread_into_plastic_hole_diam+wall_thickness*4,rounded_diam,resolution);
              }
            }
          }
        }
        translate([left*(idler_arm_pos_x+idler_arm_thickness/2),overall_height/2]) {
          rotate([0,0,45-left*45]) {
            round_corner_filler_profile(3,endcap_thickness);
          }
        }
      }
    }

    module holes() {
      // mount to extrusion
      for(x=[left,right]) {
        translate([x*extrusion_width/4,0,0]) {
          accurate_circle(5+tolerance,resolution);
        }
      }

      // room for y idler
      translate([y_belt_offset_x,idler_pos_z,0]) {
        rounded_square(idler_bearing_opening,x_pulley_diam+4,rounded_diam,resolution);
      }
    }

    difference() {
      body();
      holes();
    }
  }

  module body() {
    translate([endcap_thickness/2,0,0]) {
      rotate([0,0,90]) {
        rotate([90,0,0]) {
          linear_extrude(height=endcap_thickness,center=true,convexity=3) {
            body_profile();
          }
        }
      }
    }

    position_idler() {
      for(z=[top,bottom]) {
        mirror([0,0,z+1]) {
          translate([0,0,-idler_bearing_opening/2+bevel_height]) {
            bevel(idler_bearing_outer,idler_bearing_inner+extrude_width*4,1);
          }
        }
      }
    }
  }

  module holes() {
    // screw for idler
    position_idler() {
      hole(m5_thread_into_plastic_hole_diam,50,16);
    }
  }

  difference() {
    difference() {
      body();
      holes();
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

module y_endcap_with_motor() {
  rounded_diam = 3;

  m3_hole_diam = m3_diam;
  m3_hole_body_diam = m3_hole_diam + wall_thickness*4;

  wheel_spacing = extrusion_width+(wheel_holder_body_diam);

  thread_into_motor = 4;
  non_shaft_side_screw_length = 50;
  shaft_side_screw_length = x_belt_idler_thickness + bevel_height + x_motor_mount_thickness + thread_into_motor;
  echo("shaft_side_screw_length: ", shaft_side_screw_length);

  non_shaft_side_screw_head_pos_z = x_motor_pos_z + thread_into_motor + 1 + non_shaft_side_screw_length;

  motor_shoulder_room = nema17_shoulder_height+0.1;
  motor_mount_thickness = motor_shoulder_room+wall_thickness*2;

  belt_hole_opening_width = belt_width+2;

  //pulley_opening_diam = x_pulley_diam + 3; // too small
  pulley_opening_diam = 15;

  motor_angle = 45;
  shaft_to_screw = sqrt(pow(nema17_hole_spacing,2)/2);

  //y_motor_pos_x = y_belt_offset_x+belt_hole_opening_width/2+motor_mount_thickness;
  //y_motor_pos_x = y_belt_offset_x+m5_bolt_head_diam/2+tolerance*2+motor_mount_thickness;
  //y_motor_pos_x = extrusion_width/2+motor_mount_thickness+0.1;
  y_motor_pos_x = wheel_spacing/2+y_motor_endcap_thickness/2;
  //y_motor_pos_y = y_motor_endcap_thickness+5;
  y_motor_pos_y = -m3_nut_max_diam/2-0.5+shaft_to_screw;
  y_motor_pos_z = y_belt_offset_z - x_pulley_diam/2;

  //body_top_pos_z = y_motor_pos_z+nema17_side/2+6;
  body_top_pos_z = y_motor_pos_z+shaft_to_screw+(nema17_side/2-nema17_hole_spacing/2);

  position_motor() {
    % motor_nema17();
  }

  x_belt_pos_y = -y_rail_motor_endcap_offset-extrusion_width/2+x_belt_offset_y;
  x_belt_min_pos_x = -extrusion_width/2-belt_thickness-belt_tooth_diam/2;
  x_belt_max_pos_x = extrusion_width/2+belt_thickness;

  x_belt_relative_pos_z = bottom*(extrusion_height + sketch_space_between_rails - x_belt_pos_z + extrusion_height/2);
  belt_access_hole_height = x_pulley_diam+3;

  module position_motor() {
    translate([y_motor_pos_x,y_motor_pos_y,y_motor_pos_z]) {
      rotate([0,-90,0]) {
        rotate([0,0,motor_angle]) {
          children();
        }
      }
    }
  }

  % translate([y_belt_offset_x,0,y_belt_offset_z]) {
    translate([0,y_motor_pos_y,-x_pulley_diam/2]) {
      rotate([0,-90,0]) {
        hole(y_pulley_diam,6,resolution);
      }
    }
    color("red", 0.5) {
      translate([0,-y_rail_len/2,0]) {
        cube([belt_width,y_rail_len,belt_thickness],center=true);
      }
      translate([0,-y_rail_len/2,-x_pulley_diam]) {
        cube([belt_width,y_rail_len,belt_thickness],center=true);
        cube([belt_thickness,y_rail_len,belt_width],center=true);
      }
    }
  }

  module body() {
    // main plate
    translate([0,y_motor_endcap_thickness/2,]) {
      hull() {
        for(x=[left,right]) {
          bottom_pos_z = -sketch_xy_rail_dist_z+bevel_height+mini_v_wheel_thickness/2;
          translate([x*wheel_spacing/2,0,bottom_pos_z+1]) {
            hole(y_motor_endcap_thickness,2,resolution);
          }
          translate([x*wheel_spacing/2,0,body_top_pos_z-1]) {
            hole(y_motor_endcap_thickness,2,resolution);
          }
        }
        // fill rounded gap between main plate and motor plate
        translate([extrusion_width/2,0,0]) {
          translate([0,0,-extrusion_height/2+1]) {
            rounded_cube(motor_mount_thickness,y_motor_endcap_thickness,2,2);
          }
          translate([0,0,body_top_pos_z-1]) {
            rounded_cube(motor_mount_thickness,y_motor_endcap_thickness,2,2);
          }
        }
      }
    }

    // wheel mount
    for(x=[left,right]) {
      translate([x*(wheel_spacing/2),y_motor_endcap_thickness/2,0]) {
        wheel_shaft_holder();
      }
    }

    // motor mount plate
    hull() {
      top_joiner_length = 21.8;
      for(z=[top,bottom]) {
        translate([y_motor_pos_x-motor_mount_thickness/2,1,y_motor_pos_z+z*(shaft_to_screw)]) {
          rounded_cube(motor_mount_thickness,2,nema17_side-nema17_hole_spacing,2);
        }
      }
      position_motor() {
        for(x=[left,right],y=[front,rear]) {
          translate([x*(nema17_hole_spacing/2),y*(nema17_hole_spacing/2),motor_mount_thickness/2]) {
            rotate([0,0,-motor_angle]) {
              rotate([0,90,0]) {
                rounded_cube(motor_mount_thickness,nema17_side-nema17_hole_spacing,6,2);
                rounded_cube(motor_mount_thickness,6,nema17_side-nema17_hole_spacing,2);
              }
            }
          }
        }
      }
    }

    // brace between motor plate and main plate to resist belt tension
    for(z=[top]) {
      brace_thickness = 1.2;
      brace_length = 22;
      brace_angle_height = 15;
      translate([y_motor_pos_x-motor_mount_thickness,y_motor_endcap_thickness,y_motor_pos_z+z*(pulley_opening_diam/2+brace_thickness/2+0.2)]) {
        hull() {
          translate([1,brace_length/2,0]) {
            cube([2,brace_length,brace_thickness],center=true);
          }
          translate([-brace_length/2,-1,0]) {
            cube([brace_length,2,brace_thickness],center=true);
          }
          translate([1,-1,z*brace_angle_height]) {
            cube([2,2,1],center=true);
          }
        }
      }
    }
    for(z=[top]) {
      brace_thickness = 1.2;
      brace_length = 19;
      brace_width = 11.5;
      brace_angle_height = 13;
      translate([y_motor_pos_x-motor_mount_thickness,y_motor_endcap_thickness,y_motor_pos_z-(shaft_to_screw-m3_nut_max_diam/2-brace_thickness/2-0.2)]) {
        hull() {
          translate([1,brace_length/2,0]) {
            cube([2,brace_length,brace_thickness],center=true);
          }
          translate([-brace_width/2,-1,0]) {
            cube([brace_width,2,brace_thickness],center=true);
          }
          translate([1,-1,z*brace_angle_height]) {
            cube([2,2,1],center=true);
          }
        }
      }
    }

    x_belt_greater_anchor_height = body_top_pos_z - x_belt_relative_pos_z - belt_thickness;
    x_belt_lesser_anchor_height = body_top_pos_z - y_motor_pos_z - belt_access_hole_height/2;

    // x belt anchor (max)
    translate([0,0,0]) {
      //height = body_top_pos_z + extrusion_height + sketch_space_between_rails - x_belt_pos_z + extrusion_height/2 - belt_thickness;
      width = y_motor_pos_x-extrusion_width/2-tolerance;
      translate([0,0,body_top_pos_z]) {
        translate([0,0,-x_belt_greater_anchor_height/2]) {
          linear_extrude(height=x_belt_greater_anchor_height,center=true,convexity=3) {
            hull() {
              translate([y_motor_pos_x-width/2,0,0]) {
                rounded_square(width,rounded_diam*2,rounded_diam,resolution);

                translate([0,x_belt_pos_y,0]) {
                  rounded_square(width,belt_width+rounded_diam,rounded_diam,resolution);
                }
              }
            }
          }
        }
        anchor_width = width+6;
        translate([y_motor_pos_x-anchor_width/2,0,-x_belt_lesser_anchor_height/2]) {
          translate([-anchor_width/2,0,0]) {
            rotate([0,0,180]) {
              round_corner_filler(rounded_diam,x_belt_lesser_anchor_height);
            }
          }
          hull() {
            for(y=[x_belt_pos_y,0]) {
              translate([0,y,0]) {
                rounded_cube(anchor_width,belt_width+rounded_diam,x_belt_lesser_anchor_height,rounded_diam,resolution);
              }
            }
          }
        }
      }
    }

    // x belt anchor (min)
    difference() {
      lesser_height = x_belt_greater_anchor_height-extrusion_height/2-sketch_space_between_rails-1.5;
      width = y_motor_endcap_thickness-tolerance-belt_thickness-belt_tooth_diam;
      anchor_width = width + 7;

      union() {
        translate([0,0,body_top_pos_z]) {
          translate([0,0,-x_belt_greater_anchor_height/2]) {
            linear_extrude(height=x_belt_greater_anchor_height,center=true,convexity=3) {
              hull() {
                translate([-wheel_spacing/2,y_motor_endcap_thickness/2,0]) {
                  accurate_circle(y_motor_endcap_thickness,resolution);
                }
                translate([-wheel_spacing/2-y_motor_endcap_thickness/2+width/2,x_belt_pos_y,0]) {
                  rounded_square(width,belt_width+rounded_diam,rounded_diam,resolution);
                }
              }
              translate([-wheel_spacing/2-y_motor_endcap_thickness/2,0,0]) {
                translate([anchor_width,0,0]) {
                  rotate([0,0,-90]) {
                    round_corner_filler_profile(rounded_diam);
                  }
                }
                hull() {
                  for(y=[x_belt_pos_y,0]) {
                    translate([anchor_width/2,y,0]) {
                      rounded_square(anchor_width,belt_width+rounded_diam,rounded_diam,resolution);
                    }
                  }
                }
              }
            }
          }
        }
      }

      // clearance for extrusion on min-side
      translate([0,-19,0]) {
        hull() {
          translate([-extrusion_width/4,0,0]) {
            cube([extrusion_width/2,40,extrusion_height+tolerance*2],center=true);
          }
          translate([x_belt_min_pos_x,0,0]) {
            cube([belt_thickness_cavity+tolerance,40,extrusion_height+tolerance*2],center=true);
          }
        }
      }

      translate([x_belt_min_pos_x-belt_thickness_cavity/2-0.1,0,body_top_pos_z-x_belt_greater_anchor_height]) {
        rotate([90,0,0]) {
          rotate([0,0,90]) {
            round_corner_filler(width*1.75,40);
          }
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
      translate([x*10,y_motor_endcap_thickness,0]) {
        rotate([-90,0,0]) {
          hole(5+tolerance,50,16);

          translate([0,0,m5_bolt_head_height/2]) {
            % hole(m5_bolt_head_diam+tolerance,m5_bolt_head_height,resolution);
          }
          translate([0,0,10]) {
            hole(m5_bolt_head_diam+1,20,resolution);
          }
        }
      }
    }

    
    // Y belt access
    translate([extrusion_width/4,0,y_motor_pos_z]) {
      rotate([90,0,0]) {
        //  rounded_cube();
        rounded_cube(belt_hole_opening_width,belt_access_hole_height,30,3,resolution);
      }
    }

    // mount Y motor
    position_motor() {
      translate([0,0,0]) {
        hull() {
          translate([0,0,-0.1]) {
            hole(nema17_shoulder_diam+(nema17_shoulder_height+1)*2,0.2,resolution);
          }
          hole(nema17_shoulder_diam+1,motor_shoulder_room*2,resolution);
        }
      }
      hull() {
        hole(pulley_opening_diam,nema17_shaft_len,resolution);
        rotate([0,0,-motor_angle]) {
          translate([-pulley_opening_diam/2+1,0,0]) {
            cube([2,pulley_opening_diam/2,nema17_shaft_len],center=true);
          }
        }
      }
      // screw holes
      for(x=[left,right],y=[front,rear]) {
        translate([x*(nema17_hole_spacing/2),y*(nema17_hole_spacing/2),motor_mount_thickness+2]) {
          hole(3.2,motor_mount_thickness*4,16);
          translate([0,0,10]) {
            hole(m3_nut_max_diam+tolerance,4+20,16);
          }
        }
      }
    }

    // X min-side belt anchor
    for(x=[x_belt_min_pos_x,x_belt_max_pos_x]) {
      translate([x,x_belt_pos_y,0]) {
        rotate([90,0,0]) {
          belt_teeth(50);
        }
        translate([0,-belt_width,0]) {
          hull() {
            cube([belt_thickness,belt_width,100],center=true);
            cube([belt_width,0.1,100],center=true);
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
  foot_diam = m5_thread_into_plastic_hole_diam+wall_thickness*4;
  foot_bearing_pos_x = extrusion_width/2-foot_diam/2;
  foot_bearing_pos_z = -sketch_y_rail_pos_z+foot_bearing_od/2;

  rounded_diam = 3;

  overall_height = extrusion_height;
  overall_width = extrusion_width;

  bevel_height = 1;

  endcap_thickness = 15;
  idler_arm_thickness = wall_thickness*4;
  idler_bearing_opening = y_belt_idler_thickness+tolerance*2+bevel_height*2;


  // add bevels to idler holder

  module body_profile() {
    module body() {
      translate([-rounded_diam/4,0,0]) {
        rounded_square(overall_width+rounded_diam/2,overall_height,rounded_diam,resolution);
      }

      // belt idler support arms
      idler_arm_pos_x = idler_bearing_opening/2+idler_arm_thickness/2;
      translate([y_belt_offset_x,0,0]) {
        for(x=[left,right]) {
          translate([x*(idler_arm_pos_x),0,0]) {
            hull() {
              square([idler_arm_thickness,1],center=true);

              translate([0,y_relative_y_belt_idler_pos_z+idler_arm_thickness/2]) {
                rounded_square(idler_arm_thickness,y_belt_idler_id+wall_thickness*4,rounded_diam,resolution);
              }
            }
          }
        }
        translate([left*(idler_arm_pos_x+idler_arm_thickness/2),overall_height/2]) {
          rotate([0,0,45-left*45]) {
            round_corner_filler_profile(3,endcap_thickness);
          }
        }
      }

      // roller bearing foot
      translate([foot_bearing_pos_x,0,0]) {
        for(x=[left]) {
          translate([x*foot_diam/2,-overall_height/2]) {
            rotate([0,0,-135+x*45]) {
              round_corner_filler_profile(foot_diam/2);
            }
          }
        }
        hull() {
          translate([0,-overall_height/2,0]) {
            square([foot_diam,rounded_diam*2],center=true);
          }
          translate([0,foot_bearing_pos_z]) {
            accurate_circle(foot_diam,resolution);
          }
        }
      }
    }

    module holes() {
      // mount to extrusion
      for(x=[left,right]) {
        translate([x*extrusion_width/4,0,0]) {
          accurate_circle(5+tolerance,resolution);
        }
      }

      // room for y idler
      translate([y_belt_offset_x,y_relative_y_belt_idler_pos_z,0]) {
        rounded_square(idler_bearing_opening,x_pulley_diam+5,rounded_diam,resolution);
      }
    }

    difference() {
      body();
      holes();
    }
  }

  module body() {
    translate([0,-endcap_thickness/2,0]) {
      rotate([90,0,0]) {
        linear_extrude(height=endcap_thickness,center=true,convexity=3) {
          body_profile();
        }
      }
    }

    // belt idler bevels
    idler_arm_pos_x = idler_bearing_opening/2+idler_arm_thickness/2;
    translate([y_belt_offset_x,0,0]) {
      for(x=[left,right]) {
        translate([x*(idler_bearing_opening/2-bevel_height),-endcap_thickness/2,y_relative_y_belt_idler_pos_z]) {
          rotate([0,-x*90,0]) {
            bevel(endcap_thickness-rounded_diam,m5_thread_into_plastic_hole_diam+2,bevel_height);
          }
        }
      }
    }

    // foot bearing bevel
    translate([foot_bearing_pos_x,-endcap_thickness-bevel_height,foot_bearing_pos_z]) {
      rotate([90,0,0]) {
        bevel(foot_diam,m5_thread_into_plastic_hole_diam+extrude_width*4,bevel_height);
      }
    }
  }

  module holes() {
    // belt idler
    translate([y_belt_offset_x,-endcap_thickness/2,y_relative_y_belt_idler_pos_z]) {
      rotate([0,90,0]) {
        hole(m5_thread_into_plastic_hole_diam,40,16);

        % color("silver") y_belt_idler();
      }
    }

    // wheel foot
    translate([foot_bearing_pos_x,-endcap_thickness-bevel_height-foot_bearing_thickness/2,foot_bearing_pos_z]) {
      rotate([90,0,0]) {
        hole(m5_thread_into_plastic_hole_diam,endcap_thickness*3,resolution);

        % color("silver") difference() {
          hole(foot_bearing_od,foot_bearing_thickness,resolution);
          hole(foot_bearing_id,foot_bearing_thickness+1,resolution);
        }
      }
    }
  }

  difference() {
    color("lightgreen") body();
    holes();
  }
}

module y_carriage() {
  //wall_thickness = 0.8;
  rounded_diam = wall_thickness*2;

  preload = -0.3; // negative makes more slack both for print and UHMWPE tape

  contact_width = 5;
  contact_depth = 12;
  gap_between_contact = (extrusion_width/2-contact_width*2);

  outer_rounded_diam = rounded_diam+wall_thickness*4;

  solid_side_overhead = rounded_diam;
  spring_arm_thickness = extrude_width*4;
  spring_arm_spacing = 2;
  spring_side_overhead = -preload + spring_arm_thickness + spring_arm_spacing;

  cavity_width   = extrusion_width +solid_side_overhead+spring_side_overhead-rounded_diam/2;
  cavity_height  = extrusion_height+solid_side_overhead+spring_side_overhead-rounded_diam/2;

  spring_cavity_x=extrusion_width/2+spring_side_overhead-rounded_diam/2;
  spring_cavity_y=extrusion_height/2+spring_side_overhead-rounded_diam/2;
  solid_cavity_x=extrusion_width/2+rounded_diam/2;
  solid_cavity_y=extrusion_height/2+rounded_diam/2;

  outer_pos_x = x_carriage_overall_depth/2-outer_rounded_diam/2;

  belt_retainer_width = belt_width+2+wall_thickness*2;
  belt_retainer_height = belt_thickness_cavity + belt_tooth_diam + wall_thickness*4;

  module spring_profile() {
    translate([-extrusion_height/2,0,0]) {
      square([spring_arm_thickness,rounded_diam-spring_arm_spacing/2],center=true);
    }
    translate([0,spring_side_overhead-spring_arm_thickness/2+preload,0]) {
      translate([extrusion_width/4-contact_width/2,0,0]) {
        # rounded_square(contact_width,spring_arm_thickness,spring_arm_thickness);
      }

      hull() {
        translate([-extrusion_height/2,-spring_arm_spacing,0]) {
          # accurate_circle(spring_arm_thickness,resolution);
        }
        translate([extrusion_height/2+spring_arm_thickness/2-contact_width,0,0]) {
          accurate_circle(spring_arm_thickness,resolution);
        }
      }
    }
  }

  module spring_arm() {
    hull() {
      translate([-extrusion_width/4,0,-x_carriage_width/4-1]) {
        cube([spring_arm_thickness,rounded_diam-spring_arm_spacing/2,x_carriage_width/2+2],center=true);

        translate([0,spring_side_overhead-spring_arm_spacing-spring_arm_thickness/2+preload,0]) {
          hole(spring_arm_thickness,x_carriage_width/2+2,resolution);
        }
      }
    }
    translate([0,spring_side_overhead-spring_arm_thickness/2+preload]) {
      hull() {
        translate([extrusion_width/4-spring_arm_thickness/2,0,-contact_depth/2]) {
          hole(spring_arm_thickness,contact_depth,resolution);
        }
        translate([extrusion_width/4-contact_width+spring_arm_thickness/2,0,-contact_depth/2-contact_width/4]) {
          hole(spring_arm_thickness,contact_depth+contact_width/2,resolution);
        }
      }
      hull() {
        translate([extrusion_width/4-contact_width+spring_arm_thickness/2,0,-contact_depth/2-contact_width/4]) {
          hole(spring_arm_thickness,contact_depth+contact_width/2,resolution);
        }
        translate([-extrusion_width/4,-spring_arm_spacing,-contact_depth/2-contact_width/2-extrusion_width/8]) {
          hole(spring_arm_thickness,contact_depth+contact_width+extrusion_width/4,resolution);
        }
      }
    }
  }

  module solid_glider(width=contact_width,depth=10) {
    solid_bump_diam = rounded_diam+(preload);
    extra_len = rounded_diam*2;
    overall_len = depth + extra_len;

    module body() {
      hull() {
        rotate([90,0,0]) {
          rounded_cube(width,solid_bump_diam*2,depth,solid_bump_diam);
        }
        translate([0,-depth/2,0.1]) {
          cube([width,extra_len*2,0.2],center=true);
        }
      }

      translate([0,-extra_len/2,0]) {
        for(x=[left,right]) {
          translate([x*(width/2+solid_bump_diam/4),0,0]) {
            cube([solid_bump_diam/2,overall_len,solid_bump_diam],center=true);
          }
        }
      }
    }

    module holes() {
      for(x=[left,right]) {
        translate([x*(width/2),0,0]) {
          translate([x*(solid_bump_diam/2),0,-solid_bump_diam/2]) {
            rotate([90,0,0]) {
              hole(solid_bump_diam,depth+1,resolution);
            }
          }

          hull() {
            translate([x*(solid_bump_diam/2),-depth/2-1,-solid_bump_diam/2]) {
              rotate([90,0,0]) {
                hole(solid_bump_diam,2,resolution);
              }
              translate([0,-extra_len,-0.05]) {
                cube([solid_bump_diam+0.05,2,solid_bump_diam+0.05],center=true);
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

  module body_profile() {
    outer_coords = [
      [-spring_cavity_x,solid_cavity_y,0],
      [-spring_cavity_x,-spring_cavity_y,0],
      [outer_pos_x,solid_cavity_y,0],
      [outer_pos_x,-spring_cavity_y,0],
    ];

    cavity_coords = [
      [-spring_cavity_x,solid_cavity_y,0],
      [-spring_cavity_x,-spring_cavity_y,0],
      [solid_cavity_x,solid_cavity_y,0],
      [solid_cavity_x,-spring_cavity_y,0],
    ];
    module body() {
      // main body
      hull() {
        for(coord=outer_coords) {
          translate(coord) { accurate_circle(outer_rounded_diam,resolution); }
        }
      }

      // belt attachment
      hull() {
        translate([y_belt_offset_x-belt_width/2-1+belt_retainer_width/2,0,0]) {
          translate([0,y_belt_offset_z,0]) {
            rounded_square(belt_retainer_width,belt_retainer_height,wall_thickness*2);
          }
          translate([0,solid_cavity_y+outer_rounded_diam/2,0]) {
            square([belt_retainer_width,1],center=true);
          }
        }
      }
    }

    module holes() {
      // main cavity
      hull() {
        for(coord=cavity_coords) {
          translate(coord) { accurate_circle(rounded_diam,resolution); }
        }
      }

      // belt opening
      translate([y_belt_offset_x,y_belt_offset_z,0]) {
        square([belt_width+2,belt_thickness],center=true);
        translate([-belt_width,0,0]) {
          hull() {
            square([belt_width,belt_thickness],center=true);
            square([0.1,belt_width],center=true);
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
    rotate([90,0,0]) {
      linear_extrude(height=x_carriage_width,center=true,convexity=3) {
        body_profile();
      }
    }

    for(y=[front,rear]) {
      mirror([0,y-1,0]) {
        translate([0,x_carriage_width/2-contact_depth/2,0]) {
          // front rail gliders
          translate([extrusion_width/2+rounded_diam,0,0]) {
            rotate([0,90,0]) {
              solid_glider(extrusion_height,contact_depth);
            }
          }

          // top center glider
          translate([0,0,extrusion_height/2+rounded_diam]) {
            solid_glider(contact_width*2,contact_depth);

            for(x=[left,right]) {
              translate([x*(extrusion_width/2-contact_width/2),0,0]) {
                solid_glider(contact_width,contact_depth);
              }
            }
          }
        }
      }

      mirror([0,y+1,0]) {
        for(x=[left,right]) {
          mirror([x-1,0,0]) {
            translate([extrusion_width/4,-x_carriage_width/2,-extrusion_height/2-spring_side_overhead]) {
              rotate([90,0,0]) {
                spring_arm();
              }
            }
          }
        }

        translate([-extrusion_width/2-spring_side_overhead,-x_carriage_width/2,0]) {
          rotate([0,90,0]) {
            rotate([90,0,0]) {
              spring_arm();
            }
          }
        }
      }
    }
  }

  module holes() {
    // z carriage mounting
    for(y=[front,rear]) {
      translate([x_carriage_overall_depth/2,y*z_carriage_carrier_hole_spacing_x/2,0]) {
        rotate([0,90,0]) {
          hole(m3_threaded_insert_diam,printed_carriage_wall_thickness*4,resolution);
        }
      }
    }

    // belt teeth
    translate([y_belt_offset_x,0,y_belt_offset_z]) {
      translate([0,-x_carriage_width/2,0]) {
        rotate([0,-90,0]) {
          belt_teeth(x_carriage_width/2);
        }
      }
      translate([0,x_carriage_width/2,0]) {
        rotate([0,90,0]) {
          belt_teeth(x_carriage_width/2,bottom);
        }
      }
    }

    // make room for stepper
    translate([0,z_stepper_pos_x,z_stepper_dist_from_x_rail_z]) {
      rotate([0,90,0]) {
        hole(round_nema14_body_diam+1,50,resolution);
      }
    }
    translate([y_belt_offset_x-belt_width/2,z_stepper_pos_x,y_belt_offset_z+20]) {
      cut_width = 17;
      hull() {
        cube([(belt_width+1)*2,cut_width,40],center=true);
        translate([-belt_width/2,(belt_width+1)/2,0]) {
          cube([0.1,cut_width+(belt_width+1),40],center=true);
        }
      }
    }
  }

  difference() {
    body();
    holes();
  }
}

module wheeled_sidemount(side) {
  width = wheel_holder_body_diam;

  height = 16;
  rounded_diam = wall_thickness*4;

  dist_from_mount_hole_to_end = m5_loose_hole/2+wall_thickness*2;
  overall_length = wheeled_sidemount_spacing + dist_from_mount_hole_to_end*2;
  mount_bolt_dist = abs(wheeled_sidemount_bolt_positions[0] - wheeled_sidemount_bolt_positions[1]);

  support_width = extrude_width*4;
  support_height = (height - v_slot_gap)/2 + 0.2;
  support_pos_x = -5-extrude_width-support_width/2;
  support_bridge_pos_z = height/2-support_height+0.1;

  module body() {
    translate([0,wheeled_sidemount_front_bolt_pos_y-dist_from_mount_hole_to_end+overall_length/2,0]) {
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
    for(y=wheeled_sidemount_bolt_positions) {
      translate([width+m5_bolt_head_height/2,y,0]) {
        rotate([0,90,0]) {
          % hole(m5_bolt_head_diam+tolerance,m5_bolt_head_height,16);
        }
      }
      translate([-5,y,0]) {
        rotate([0,90,0]) {
          hole(wheel_axle_diam+tolerance,50,8);
        }
        cube([10,t_slot_nut_length,height],center=true);
      }
    }
  }

  module bridges() {
    translate([0,wheeled_sidemount_bolt_positions[0]+mount_bolt_dist/2,support_bridge_pos_z]) {
      // cube([8,mount_bolt_dist-t_slot_nut_length,0.2],center=true);
    }
    translate([support_pos_x,wheeled_sidemount_front_bolt_pos_y-dist_from_mount_hole_to_end+overall_length/2,v_slot_gap/2+support_height/2-0.2]) {
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

translate([-1*28,0,sketch_y_rail_pos_z]) {
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
      color("lightblue") y_carriage();
      translate([right*x_carriage_overall_depth/2,0,0]) {
        rotate([0,0,90]) {
          z_axis_assembly();
        }
      }
    }

    translate([0,y_rail_len/2,0]) {
      y_endcap_with_motor();
    }

    translate([0,-y_rail_len/2,0]) {
      y_endcap_with_idler();
    }
  }
}
