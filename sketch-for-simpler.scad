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
use <electronics-mount.scad>;

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

pulley_opening_diam = 15;
pulley_tooth_pitch = 2;
x_pulley_tooth_count = 16;
y_pulley_tooth_count = 16;

x_pulley_diam = pulley_tooth_pitch*x_pulley_tooth_count/pi;
y_pulley_diam = pulley_tooth_pitch*y_pulley_tooth_count/pi;

belt_width = 6;
belt_pos_x = 0;
belt_hole_opening_width = belt_width+4;

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
extra_belt_thickness_room = 0.0;
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

x_belt_pos_z = wall_thickness*2 + tolerance + nema17_side/2 + x_pulley_diam/2;
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

dragchain_10_20_width_outer = 27.5;
dragchain_10_20_width_inner = 20;
dragchain_10_20_height_outer = 15;
dragchain_10_20_height_inner = 10;
dragchain_10_20_anchor_thickness = 3;
dragchain_10_20_anchor_depth = 33;
dragchain_10_20_min_outer_diam = (18+dragchain_10_20_height_outer)*2;
//dragchain_10_20_min_outer_diam = 60;

dragchain_10_10_width_outer = 20;
dragchain_10_10_width_inner = 10;
dragchain_10_10_height_outer = 15;
dragchain_10_10_height_inner = 10;
dragchain_10_10_anchor_thickness = 3;
dragchain_10_10_anchor_depth = 29;
dragchain_10_10_min_outer_diam = (18+dragchain_10_20_height_outer)*2;

y_dragchain_width = 13;
y_dragchain_height = 10;

module position_dragchain_10_20_anchor_holes() {
  pair_holes_from_end = 4;
  pair_holes_spacing = 12;
  single_hole_from_end = 12;
  for(x=[left,right]) {
    translate([x*pair_holes_spacing/2,-pair_holes_from_end,0]) {
      children();
    }
  }
  translate([0,-single_hole_from_end,0]) {
    children();
  }
}

module position_dragchain_10_10_anchor_holes() {
  hole_from_end = [-4,-12];

  for(y=hole_from_end) {
    translate([0,y,0]) {
      children();
    }
  }
}

module dragchain_10_10_anchor() {
  module body() {
    hull() {
      translate([0,-1,dragchain_10_10_anchor_thickness/2]) {
        cube([dragchain_10_10_width_outer,2,dragchain_10_10_anchor_thickness],center=true);
      }
      nose_rounded_diam = 5;
      translate([0,-nose_rounded_diam/2,nose_rounded_diam]) {
        rotate([0,90,0]) {
          hole(nose_rounded_diam,dragchain_10_10_width_outer,resolution);
        }
      }
      translate([0,-dragchain_10_10_anchor_depth+dragchain_10_10_height_outer/2,dragchain_10_10_height_outer/2]) {
        rotate([0,90,0]) {
          hole(dragchain_10_10_height_outer,dragchain_10_10_width_outer,resolution);
        }
      }
    }
  }

  module holes() {
    translate([0,-dragchain_10_10_anchor_depth/2+dragchain_10_10_height_inner-0.5,dragchain_10_10_height_outer/2+dragchain_10_10_anchor_thickness]) {
      cube([dragchain_10_10_width_inner,dragchain_10_10_anchor_depth,dragchain_10_10_height_outer],center=true);
    }
    translate([0,-dragchain_10_10_anchor_depth,0]) {
      cube([dragchain_10_10_width_inner,dragchain_10_10_height_inner*2,dragchain_10_10_height_outer*3],center=true);
    }

    position_dragchain_10_10_anchor_holes() {
      translate([0,0,dragchain_10_10_anchor_thickness]) {
        hole(2.5,10,resolution);
      }
    }
  }

  difference() {
    body();
    holes();
  }
}

module dragchain_10_20_anchor() {
  module body() {
    hull() {
      translate([0,-1,dragchain_10_20_anchor_thickness/2]) {
        cube([dragchain_10_20_width_outer,2,dragchain_10_10_anchor_thickness],center=true);
      }
      nose_rounded_diam = 5;
      translate([0,-nose_rounded_diam/2,nose_rounded_diam]) {
        rotate([0,90,0]) {
          hole(nose_rounded_diam,dragchain_10_20_width_outer,resolution);
        }
      }
      translate([0,-dragchain_10_20_anchor_depth+dragchain_10_20_height_outer/2,dragchain_10_20_height_outer/2]) {
        rotate([0,90,0]) {
          hole(dragchain_10_20_height_outer,dragchain_10_20_width_outer,resolution);
        }
      }
    }
  }

  module holes() {
    translate([0,-dragchain_10_20_anchor_depth/2+dragchain_10_10_height_inner-0.5,dragchain_10_20_height_outer/2+dragchain_10_20_anchor_thickness]) {
      cube([dragchain_10_20_width_inner,dragchain_10_20_anchor_depth,dragchain_10_20_height_outer],center=true);
    }
    translate([0,-dragchain_10_20_anchor_depth,0]) {
      cube([dragchain_10_20_width_inner,dragchain_10_20_height_inner*2,dragchain_10_20_height_outer*3],center=true);
    }

    position_dragchain_10_20_anchor_holes() {
      translate([0,0,dragchain_10_20_anchor_thickness]) {
        hole(3.2,10,resolution);
      }
    }
  }

  difference() {
    body();
    holes();
  }
}

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

module old_x_min_endcap() {
  motor_offset_x = -10;
  plate_thickness = 3;
  x_motor_offset_x = -nema17_side/2-plate_thickness;
  x_motor_offset_y = extrusion_width/2 + nema14_shoulder_height - 2;
  x_motor_offset_z = x_belt_pos_z - x_pulley_diam/2 - extrusion_height/2;

  overall_height = x_motor_offset_z + extrusion_height/2 + nema17_side/2;
  overall_width = nema17_side + plate_thickness;
  overall_depth = x_motor_offset_y + extrusion_width/2;

  endstop_mount_hole_diam = mech_endstop_tiny_mounting_hole_diam-0.2;
  endstop_mount_height = 10;
  endstop_mount_width = mech_endstop_tiny_mounting_hole_from_top*2-3;
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
          translate([0,-extrusion_width/2+y,0]) {
            rotate([0,90,0]) {
              hole(m5_bolt_head_diam+1,30,8);
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

module x_min_endcap() {
  plate_thickness = nema14_shoulder_height + wall_thickness*2;
  top_plate_thickness = wall_thickness*2;
  extrusion_mount_thickness = wall_thickness*2 + m5_bolt_head_height + 2;
  x_motor_offset_x = left*(nema17_side/2+tolerance+extrusion_mount_thickness);
  x_motor_offset_y = x_belt_offset_y-belt_hole_opening_width/2-plate_thickness; //extrusion_width/2;
  x_motor_offset_z = x_belt_pos_z - x_pulley_diam/2 - extrusion_height/2;

  overall_height = extrusion_height/2 + x_motor_offset_z + nema17_side/2 + tolerance + top_plate_thickness;
  overall_width = abs(x_motor_offset_x) + nema17_side/2 + tolerance;
  overall_depth = x_motor_offset_y + extrusion_width/2;

  endstop_mount_hole_diam = mech_endstop_tiny_mounting_hole_diam-0.2;
  endstop_mount_height = 10;
  endstop_mount_width = mech_endstop_tiny_mounting_hole_from_top*2-3;
  endstop_mount_depth = mech_endstop_tiny_length+1;

  module position_endstop() {
    translate([1.5,extrusion_width/2-endstop_mount_depth/2,-extrusion_height/2+overall_height+mech_endstop_tiny_width/2]) {
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
      rotate([-90,0,0]) {
        children();
      }
    }
  }

  module body() {
    rounded_diam = 2;
    translate([-extrusion_mount_thickness/2,0,-extrusion_height/2+overall_height/2]) {
      rotate([0,90,0]) {
        rounded_cube(overall_height,extrusion_width,extrusion_mount_thickness,rounded_diam,resolution);
      }
    }

    translate([0,0,-extrusion_height/2+overall_height/2]) {
      rotate([0,-90,0]) {
        rotate([0,0,90]) {
          translate([x_motor_offset_y+plate_thickness/2,0,overall_width/2]) {
            cube([plate_thickness,overall_height-1,overall_width],center=true);
          }
          translate([0,-overall_height/2+top_plate_thickness/2,0]) {
            hull() {
              translate([0,0,extrusion_mount_thickness-1]) {
                rounded_cube(extrusion_width,top_plate_thickness,2,rounded_diam,resolution);
              }
              translate([x_motor_offset_y+plate_thickness/2,0,overall_width-1]) {
                rounded_cube(plate_thickness+rounded_diam*2,top_plate_thickness,2,rounded_diam,resolution);
              }
            }
          }
          bottom_plate_thickness = x_motor_offset_z - tolerance + extrusion_height/2 - nema17_side/2;
          translate([0,overall_height/2-bottom_plate_thickness/2,0]) {
            hull() {
              translate([0,0,extrusion_mount_thickness-1]) {
                rounded_cube(extrusion_width,bottom_plate_thickness,2,rounded_diam,resolution);
              }
              translate([x_motor_offset_y+plate_thickness/2,0,overall_width-10]) {
                rounded_cube(plate_thickness+rounded_diam*2,bottom_plate_thickness,20,rounded_diam,resolution);
              }
              translate([extrusion_width/2,0,overall_width-10]) {
                rounded_cube(20,bottom_plate_thickness,20,rounded_diam,resolution);
              }
            }
          }
          translate([x_motor_offset_y+plate_thickness,-overall_height/2+top_plate_thickness,overall_width/2]) {
            round_corner_filler(rounded_diam,overall_width);
          }
          translate([x_motor_offset_y+plate_thickness,overall_height/2-bottom_plate_thickness,overall_width/2]) {
            rotate([0,0,-90]) {
              round_corner_filler(rounded_diam,overall_width);
            }
          }
        }
      }
    }
  }

  module holes() {
    // mount to aluminum extrusion
    for(y=[front,rear]) {
      translate([-extrusion_mount_thickness,10*y,0]) {
        rotate([0,90,0]) {
          hole(m5_loose_hole,30,resolution);
          hole(m5_bolt_head_diam+1,(m5_bolt_head_height+1)*2,resolution);
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
        rounded_cube(x_pulley_diam+5,belt_hole_opening_width,30,6,resolution);
      }
    }

    // make room for wheeled carriage holes
    translate([0,wheeled_sidemount_rear_bolt_pos_y,extrusion_height+sketch_space_between_rails]) {
      translate([0,-extrusion_width/2,0]) {
        rotate([0,90,0]) {
          hole(m5_bolt_head_diam+3,(m5_bolt_head_height+2)*2,resolution);
        }
      }
    }

    position_motor() {
      % color("#333", 0.7) motor_nema17();

      // motor shoulder
      hull() {
        hole(nema17_shoulder_diam+1,nema14_shoulder_height*2,resolution);
        translate([0,0,-0.1]) {
          hole(nema17_shoulder_diam+(nema14_shoulder_height+1)*2,0.2,resolution);
        }
      }

      // pulley hole
      hull() {
        hole(pulley_opening_diam,nema14_shaft_len,resolution);
        translate([-pulley_opening_diam/2+1,0,0]) {
          cube([2,pulley_opening_diam/2,nema14_shaft_len],center=true);
        }
      }

      translate([0,0,10]) {
        % hole(x_pulley_diam,6,resolution);

        for(z=[top,bottom]) {
          translate([0,0,z*9/2]) {
            % hole(x_pulley_diam+2,1,resolution);
          }
        }
      }

      // motor mount holes
      for(x=[left,right],y=[front,rear]) {
        translate([x*(nema17_hole_spacing/2),y*(nema17_hole_spacing/2),plate_thickness]) {
          hole(m3_diam+tolerance,40,8);
          hull() {
            translate([0,0,0.1]) {
              hole(m3_nut_max_diam+(tolerance+nema14_shoulder_height)*2,0.2,resolution);
            }
            hole(m3_nut_max_diam+(tolerance)*2,nema14_shoulder_height*2,resolution);
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

  y_motor_pos_x = y_belt_offset_x - m5_bolt_head_diam - motor_mount_thickness;
  y_motor_pos_y = y_motor_endcap_thickness+nema17_side/2+1;
  y_motor_pos_z = y_belt_offset_z - x_pulley_diam/2;

  //body_top_pos_z = y_motor_pos_z+nema17_side/2+6;
  body_top_pos_z = y_motor_pos_z+nema17_side/2 + motor_mount_thickness;

  position_motor() {
    % motor_nema17();
  }

  x_belt_pos_y = -y_rail_motor_endcap_offset-extrusion_width/2+x_belt_offset_y;
  x_belt_min_pos_x = -extrusion_width/2-belt_thickness-belt_tooth_diam/2;
  x_belt_max_pos_x = extrusion_width/2+belt_thickness;

  x_belt_relative_pos_z = bottom*(extrusion_height + sketch_space_between_rails - x_belt_pos_z + extrusion_height/2);
  belt_access_hole_height = x_pulley_diam+3;

  module position_x_dragchain() {
    translate([12.5,y_motor_endcap_thickness/2+mini_v_wheel_od/2+5+dragchain_10_20_width_outer/2,body_top_pos_z]) {
      rotate([0,0,90]) {
        rotate([0,0,0]) {
          children();
        }
      }
    }
  }

  module position_y_dragchain() {
    translate([-10,y_motor_endcap_thickness/2,body_top_pos_z]) {
      children();
    }
  }

  position_x_dragchain() {
    % color("#333", 0.7) dragchain_10_20_anchor();
  }

  position_y_dragchain() {
    % y_dragchain_clamp();
  }

  module position_motor() {
    translate([y_motor_pos_x,y_motor_pos_y,y_motor_pos_z]) {
      rotate([0,90,0]) {
        children();
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
    motor_mount_plate_height = body_top_pos_z - y_motor_pos_z + nema17_side/2;
    translate([y_motor_pos_x+motor_mount_thickness/2,y_motor_pos_y-y_motor_endcap_thickness/2,body_top_pos_z-motor_mount_plate_height/2]) {
      rounded_cube(motor_mount_thickness,nema17_side+y_motor_endcap_thickness,motor_mount_plate_height,motor_mount_thickness/2);
    }
    translate([y_motor_pos_x+motor_mount_thickness,y_motor_endcap_thickness,y_motor_pos_z]) {
      round_corner_filler(3,nema17_side);
    }
    // motor mount plate reinforcement
    hull() {
      translate([0,0,body_top_pos_z-motor_mount_thickness/2]) {
        linear_extrude(height=motor_mount_thickness,center=true,convexity=3) {
          translate([y_motor_pos_x+motor_mount_thickness/2,y_motor_pos_y-y_motor_endcap_thickness/2,0]) {
            rounded_square(motor_mount_thickness,nema17_side+y_motor_endcap_thickness,motor_mount_thickness/2);
          }
          for(x=[left,right]) {
            translate([x*wheel_spacing/2,y_motor_endcap_thickness/2,0]) {
              accurate_circle(y_motor_endcap_thickness,resolution);
            }
          }
          position_x_dragchain() {
            position_dragchain_10_20_anchor_holes() {
              accurate_circle(y_motor_endcap_thickness,resolution);
            }
          }
        }
      }
    }

    x_belt_greater_anchor_height = body_top_pos_z - x_belt_relative_pos_z - belt_thickness;
    x_belt_lesser_anchor_height = body_top_pos_z - y_motor_pos_z - belt_access_hole_height/2;

    // x belt anchor (min/max)
    for(x=[left,right]) {
      mirror([-x+1,0,0]) {
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

          // curved path for belt
          translate([x_belt_min_pos_x-belt_thickness_cavity/2-0.1,x_belt_pos_y-belt_width/2+0.5,body_top_pos_z-x_belt_greater_anchor_height]) {
            rotate([90,0,0]) {
              rotate([0,0,90]) {
                round_corner_filler(width*1.75,belt_width*2);
              }
            }
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
            // % hole(m5_bolt_head_diam+tolerance,m5_bolt_head_height,resolution);
          }
          hole(m5_bolt_head_diam+1,2*(m5_bolt_head_height+0.5),resolution);
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
        translate([pulley_opening_diam/2-1,0,0]) {
          cube([2,pulley_opening_diam/2,nema17_shaft_len],center=true);
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

    position_x_dragchain() {
      position_dragchain_10_20_anchor_holes() {
        hole(m3_thread_into_plastic_hole_diam,40,resolution);
      }
    }

    // some sort of anchor system for I-don't-know-what-yet
    translate([0,y_motor_endcap_thickness/2,body_top_pos_z]) {
      for(x=[left,0,right]) {
        translate([x*extrusion_width/2,0,0]) {
          hole(m3_threaded_insert_diam,10*2,resolution);
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

  dragchain_surface_z = solid_cavity_y+outer_rounded_diam/2+2+wall_thickness*2;

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
          accurate_circle(spring_arm_thickness,resolution);
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
      translate([y_belt_offset_x-belt_width/2-1+belt_retainer_width/2,0,0]) {
        hull() {
          translate([0,y_belt_offset_z,0]) {
            rounded_square(belt_retainer_width,belt_retainer_height,wall_thickness*2);
          }
          translate([0,solid_cavity_y+outer_rounded_diam/2,0]) {
            square([belt_retainer_width,1],center=true);
          }
        }
        for(x=[left,right]) {
          mirror([1-x,0,0]) {
            translate([belt_retainer_width/2,solid_cavity_y+outer_rounded_diam/2,0]) {
              round_corner_filler_profile(3);
            }
          }
        }
      }

      // dragchain attachment
      translate([-10,0,0]) {
        hull() {
          rounded_diam = wall_thickness*2;
          translate([0,dragchain_surface_z-rounded_diam/2,0]) {
            rounded_square(belt_retainer_width,rounded_diam,rounded_diam);
          }
          translate([0,solid_cavity_y+outer_rounded_diam/2,0]) {
            square([belt_retainer_width,0.1],center=true);
          }
        }
        for(x=[left,right]) {
          mirror([1-x,0,0]) {
            translate([belt_retainer_width/2,solid_cavity_y+outer_rounded_diam/2,0]) {
              round_corner_filler_profile(3);
            }
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
    translate([20,z_stepper_pos_x,z_stepper_dist_from_x_rail_z]) {
      rotate([0,90,0]) {
        hole(z_stepper_body_diam+1,40,resolution);
      }
    }
    translate([y_belt_offset_x-belt_width/2,z_stepper_pos_x,y_belt_offset_z+20]) {
      cut_width = 12;
      hull() {
        cube([(belt_width+1)*2,cut_width,40],center=true);
        translate([-belt_width/2,(belt_width+1)/2,0]) {
          cube([0.1,cut_width+(belt_width+1),40],center=true);
        }
      }
    }

    // dragchain anchor
    translate([-10,0,0]) {
      for(y=[front,0,rear]) {
        translate([0,y*extrusion_width/2,solid_cavity_y+rounded_diam/2+wall_thickness*2+10]) {
          hole(m3_threaded_insert_diam,20,resolution);
        }
      }

      translate([0,10,dragchain_surface_z+0.1]) {
        % y_on_carriage_dragchain_anchor_mount();
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

module y_on_carriage_dragchain_anchor_mount() {
  thickness = 4;
  main_diam = m3_loose_hole+wall_thickness*6;

  translate([0,0,thickness]) {
    % y_dragchain_clamp();
  }

  module position_dragchain() {
    translate([0,-10-main_diam/2,thickness+y_dragchain_height/2]) {
      children();
    }
  }

  dragchain_mount_hole_pos = [-main_diam/2-4,-main_diam/2-12];

  hang_over_y_carriage = 15;

  module profile() {
    diam = m3_thread_into_plastic_hole_diam+wall_thickness*4;
    module body() {
      hull() {
        for(y=[front,rear]) {
          translate([0,y*20/2,0]) {
            accurate_circle(m3_loose_hole+wall_thickness*4,resolution);
          }
        }
        for(y=[-20/2+x_carriage_width/2+1+hang_over_y_carriage-diam/2,0]) {
          translate([0,y,0]) {
            for(x=[left,right]) {
              translate([x*20/2,0,0]) {
                accurate_circle(diam,resolution);
              }
            }
          }
        }
      }

      width = 40+diam;
      translate([-10-diam/2+width/2,-20/2+x_carriage_width/2+1+hang_over_y_carriage/2,0]) {
        rounded_square(width,hang_over_y_carriage,diam,resolution);
        
        
      }
    }

    module holes() {
      for(y=[front,rear]) {
        translate([0,y*20/2,0]) {
          accurate_circle(m3_loose_hole,resolution);
        }
      }
      for(x=[left,right]) {
        translate([x*20/2,0,0]) {
          accurate_circle(m3_thread_into_plastic_hole_diam,resolution);
        }
      }

      for(y=dragchain_mount_hole_pos) {
        translate([0,y,0]) {
          // accurate_circle(m2_5_thread_into_plastic_hole_diam,12);
        }
      }
    }

    difference() {
      body();
      holes();
    }
  }

  module body() {
    translate([0,0,thickness/2]) {
      linear_extrude(height=thickness,center=true,convexity=5) {
        profile();
      }
    }
  }

  module holes() {
  }

  color("orange") difference() {
    body();
    holes();
  }
}

module y_dragchain_clamp() {
  thickness = 4;
  main_diam = m3_loose_hole+wall_thickness*4;
  dragchain_hole_body_diam = m2_5_thread_into_plastic_hole_diam+wall_thickness*4;

  translate([0,0,y_dragchain_height/2]) {
    % color("#333", 0.7) cube([y_dragchain_width,16,y_dragchain_height],center=true);
  }

  dragchain_mount_hole_pos = [-main_diam/2-4,-main_diam/2-12];

  module profile() {
    module body() {
      rounded_square(20+main_diam,main_diam,main_diam,resolution);
    }

    module holes() {
      for(x=[left,right]) {
        translate([x*20/2,0,0]) {
          accurate_circle(m3_loose_hole,resolution);
        }
      }
    }

    difference() {
      body();
      holes();
    }
  }

  module body() {
    translate([0,0,thickness/2+y_dragchain_height/2]) {
      linear_extrude(height=thickness+y_dragchain_height,center=true,convexity=5) {
        profile();
      }
    }
  }

  module holes() {
    cube([y_dragchain_width+tolerance,30,y_dragchain_height*2],center=true);
  }

  color("orange", 0.7) difference() {
    body();
    holes();
  }
}

module shim(id,od,thickness) {
  difference() {
    hole(od,thickness,resolution);
    hole(id,thickness+1,resolution);
  }
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

translate([-x_rail_len/2-nema17_side/2-20,y_rail_len/2-40-nema17_len-40,50]) {
  rotate([0,0,-0]) {
    rotate([0,-90,0]) {
      // electronics_mount();
    }
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
      y_carriage();
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

base_extra_min_x = nema17_side + 10 + 1*inch;
base_extra_max_x = 15 + 1*inch;
base_extra_min_y = 15 + 1*inch;
echo("base_extra_min_x (mm), base_extra_max_x (mm): ", base_extra_min_x, base_extra_max_x);
echo("base_extra_min_y (mm), base_extra_max_y (mm): ", base_extra_min_y, base_extra_max_y);
echo("base_extra_min_x (in), base_extra_max_x (in): ", base_extra_min_x/25.4, base_extra_max_x/25.4);
echo("base_extra_min_y (in), base_extra_max_y (in): ", base_extra_min_y/25.4, base_extra_max_y/25.4);
base_extra_max_y = nema17_side + y_motor_endcap_thickness + 2 + 1*inch;
base_sheet_len_x = x_rail_len + base_extra_min_x + base_extra_max_x;
base_sheet_len_y = y_rail_len + base_extra_min_y + base_extra_max_y;
base_sheet_pos_x = -x_rail_len/2-base_extra_min_x + base_sheet_len_x/2;
base_sheet_pos_y = -y_rail_len/2-base_extra_min_y+base_sheet_len_y/2;
base_sheet_thickness = 4;
module base_sheet() {
  x_rail_hole_pos_y = base_sheet_len_y/2-base_extra_max_y - 10;
  echo("x_rail_hole_pos_y: ", x_rail_hole_pos_y);
  echo("x_rail_holes_from_top: base_extra_max_y+10: ", base_extra_max_y+10);
  echo("base_sheet_len_y: ", base_sheet_len_y);

  module body() {
    square([base_sheet_len_x,base_sheet_len_y],center=true);
  }

  module holes() {
    translate([0,x_rail_hole_pos_y,0]) {
      for(x=[base_extra_min_x:10:base_sheet_len_x-base_extra_max_x]) {
        translate([-base_sheet_len_x/2+x,0,0]) {
          # accurate_circle(5,resolution);
          
        }
      }
      % color("red") {
        square([x_rail_len,1],center=true);
      }
    }
  }
  
  difference() {
    color("cyan", 0.2) body();
    holes();
  }
}

echo("base width/height: ", base_sheet_len_x/25.4, base_sheet_len_y/25.4);

translate([base_sheet_pos_x,base_sheet_pos_y,-base_sheet_thickness/2]) {
  //color("cyan", 0.2) {
    //linear_extrude(height=base_sheet_thickness,center=true,convexity=5) {
      base_sheet();
    //}
  //}
  /*
  translate([0,base_sheet_len_y/2-base_extra_max_y-10,-base_sheet_thickness]) {
    color("red") {
      cube([2000,0.1,0.1],center=true);
    }
  }
  */
}

translate([-x_rail_len/2 - 10,y_rail_len/2 - extrusion_width - nema17_len - 60 ,42]) {
  rotate([-90,0,0]) {
    rotate([0,0,180]) {
      electronics_mount();
    }
  }
}

module whiteboard_tslot_anchor(anchor_length=m5_bolt_head_diam+4) {
  overall_width = 14.9; // outside-to-outside, actual measurement 14.87;
  opening_width = 9.4; // measured at 9.4
  top_to_bottom = 3.7; // measured at 3.86
  overhang_width = 1.5; // measured/guess of 1.5; very hard to measure, made an attempt at the corner
  overhang_thickness = 1; // measured/guess of 0.7; also hard to measure
  overall_depth = top_to_bottom+extrude_width*6;
  rounded_diam = extrude_width*4;

  module divider_profile() {
    gap_width = 0.4;
    translate([0,-extrude_width*6+overall_depth/2,0]) {
      square([gap_width,overall_depth+1],center=true);
    }
  }

  module profile() {
    module body() {
      translate([0,-overall_depth/2+top_to_bottom,0]) {
        rounded_square(overall_width,overall_depth,rounded_diam,resolution);
      }
      translate([0,top_to_bottom/2,0]) {
        % color("orange",0.2) square([overall_width,top_to_bottom],center=true);
      }
    }

    module holes() {
      for(x=[left,right]) {
        translate([x*(opening_width/2+overhang_width),0,0]) {
          rounded_square((overhang_width+tolerance)*2,overhang_thickness,overhang_thickness,resolution);
        }

        for(y=[front,rear]) {
          mirror([x-1,0,0]) {
            mirror([0,y-1,0]) {
              translate([overall_width/2,overhang_thickness/2,0]) {
                rotate([0,0,90]) {
                  round_corner_filler_profile(rounded_diam);
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

  module body() {
    linear_extrude(height=anchor_length,center=true,convexity=5) {
      profile();
    }
  }

  module holes() {
    translate([0,0,0.2]) {
      linear_extrude(height=anchor_length,center=true,convexity=5) {
        divider_profile();
      }
    }

    translate([0,-extrude_width*6,0]) {
      rotate([90,0,0]) {
        countersink_screw(m3_thread_into_plastic_hole_diam,m3_fsc_head_diam,0.5,overall_depth+1);
      }
    }
  }

  difference() {
    body();
    holes();
  }
}
