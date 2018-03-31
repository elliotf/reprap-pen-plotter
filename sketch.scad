include <util.scad>;

/*

TODO
* z axis
  * instead of a set screw, make the cam a clamp around the stepper shaft
  * (maybe) instead of cam pushing on z carriage, cam could *pull* it up via some string/belt?
* pen holder
* motor mounts
  * have two for each motor?
    * one to attach motor to extrusion/base plate
    * one on the other side to keep motor from tilting up due to line tension?
* tensioning
  * belt
  * line (guitar tuners)
* endstops
  * x endstop on x carriage
  * y endstop on motor mount
  * z axis?
    * mount below carriage?
    * magnetic sensor with magnet on z carriage?
    * cam trips endstop at bottom of travel?
      * hall effect might be easier to fit in and mount
* board attachment points for motor and rear idler mount
* pulley for line-based

YAGNI
* get retentive about line positions by taking line thickness into account
* bracing to prevent tipping? (for rear idler mount)

PLANS
* base is melamine-coated particle board
  * https://www.homedepot.com/p/Melamine-White-Panel-Common-3-4-in-x-4-ft-x-8-ft-Actual-750-in-x-49-in-x-97-in-461877/100070209
* x/y carriages are wood/aluminum

 */

inch = 25.4;
resolution = 32;
left    = -1;
right   = 1;
front   = -1;
rear    = 1;
top     = 1;
bottom  = -1;
m3_diam = 3;
m3_nut_diam = 5.6; // actually 5.5, but add fudge
spacer  = 1;

approx_pi = 3.14159;

nema17_side = 43;
nema17_len = 43;
nema17_hole_spacing = 31;
nema17_shoulder_diam = 22;
nema17_shoulder_height = 2;
nema17_screw_diam = m3_diam;
nema17_shaft_diam = 5;
nema17_shaft_len = 24;

nema14_side = 35.3;
nema14_len = nema14_side;
nema14_hole_spacing = 26;
nema14_shoulder_diam = 22;
nema14_shoulder_height = 2;
nema14_screw_diam = m3_diam;
nema14_shaft_diam = 5;
nema14_shaft_len = 20;

motor_side = nema17_side;
motor_len = nema17_len;
motor_hole_spacing = nema17_hole_spacing;
motor_shoulder_diam = nema17_shoulder_diam;
motor_screw_diam = nema17_screw_diam;
motor_shaft_diam = nema17_shaft_diam;
motor_shaft_len = nema17_shaft_len;
motor_wire_hole_width = 9;
motor_wire_hole_height = 6;

zip_tie_thickness = 1.5;
zip_tie_width     = 2.75;

print_width = 1*1000;
print_depth = 1.5*1000;
print_width = 18*inch;
print_depth = 24*inch;

// potential size
print_width = 36*inch;
print_depth = 48*inch;

// debug/develop
print_width = 11*inch;
print_depth = 8.5*inch;

extrude_width = 0.4;
wall_thickness = extrude_width*4;

extrusion_width = 20;
extrusion_height = 40;
extrusion_screw_hole = 5;

plate_thickness = 1/4*inch;
extrusion_wheel_gap = 2;

wheel_screw_diam = 5;
plate_min_material = 5;

wheel_diam              = 15.23;
wheel_extrusion_spacing = 11.90/2; // edge of extrusion to wheel axle

y_carriage_plate_width = extrusion_height+2*(wheel_extrusion_spacing + wheel_diam/2);

// unused for now
rear_line_bearing_od = 16;
rear_line_bearing_id = 8;
rear_line_bearing_thickness = 10;

rear_idler_line_gap = 4;
function rear_idler_pos_y(side) = print_depth/2+8+rear_idler_line_gap*side;
// lift one side to provide line/belt clearance
function rear_idler_pos_z(side,is_motor) = belt_pos_z + (is_motor*abs(side-1)*line_bearing_thickness);


// filament-driven
line_height            = 1;
line_thickness         = 1;
line_bearing_diam      = 14-0.5*2; // 625zz v-groove for filament
line_bearing_thickness = 5;  // 625zz v-groove for filament

// belt-driven
line_height            = 6;
line_bearing_diam      = 10; // mr105zz for belt
line_bearing_thickness = 10; // 2x mr105zz for belt

line_bearing_inner     = 5;

line_pulley_diam = (16*2)/approx_pi;
line_pulley_diam = (20*2)/approx_pi;
line_pulley_height = 10;

y_rail_pos_x = print_width/2-extrusion_width/2;
y_rail_pos_z = extrusion_height/2;

x_rail_len = print_width - extrusion_width*2 - 5;
motor_mount_thickness = 10;
motor_mount_offset    = - extrusion_screw_hole/2 - extrude_width*2 - line_bearing_inner/2 + line_bearing_diam/2 + line_thickness + line_pulley_diam/2;
motor_pos_x = y_rail_pos_x-extrusion_width/2+nema17_side/2;
motor_pos_x = y_rail_pos_x + 6;
motor_pos_x = y_rail_pos_x + motor_mount_offset;

motor_pos_y = -print_depth/2-nema17_side/2-motor_mount_thickness;
y_carriage_pos_x = y_rail_pos_x;
y_carriage_pos_z = y_rail_pos_z + extrusion_height/2 + extrusion_wheel_gap + plate_thickness/2;
x_rail_pos_z     = y_carriage_pos_z - plate_thickness/2 - extrusion_width/2;
belt_pos_z  = y_carriage_pos_z + plate_thickness/2 + spacer + line_bearing_thickness/2;

motor_pos_z = motor_len + 1;

inner_line_idler_pos_x = motor_pos_x - line_pulley_diam/2 - line_bearing_diam/2;
outer_line_idler_pos_x = inner_line_idler_pos_x + line_bearing_diam + 2.5; // not sure how much room to leave for flanges/grooves/belt teeth

x_carriage_pos_z = x_rail_pos_z;

x_carriage_belt_spacing = 5;

y_carriage_depth = extrusion_width*2+20+wheel_diam;

x_carriage_width = extrusion_height + wheel_diam;
ptfe_diam      = 4;
ptfe_bushing_preload_amount = 0.0; // undersize by this much to ensure no slop

x_carriage_extrusion_carriage_gap = ptfe_diam*0.3 - ptfe_bushing_preload_amount;

x_carriage_opening_depth  = extrusion_height + x_carriage_extrusion_carriage_gap*2;
x_carriage_opening_height = extrusion_width  + x_carriage_extrusion_carriage_gap*2;

x_carriage_bushing_len   = 10;
x_carriage_bushing_pos_y = extrusion_height/2 + ptfe_diam/2 - ptfe_bushing_preload_amount;
x_carriage_bushing_pos_z = extrusion_width/2  + ptfe_diam/2 - ptfe_bushing_preload_amount;

x_carriage_overall_depth  = x_carriage_bushing_pos_y*2 + ptfe_diam + 2*(extrude_width*6);
x_carriage_overall_height  = x_carriage_bushing_pos_z*2 + ptfe_diam + 2*(extrude_width*6);

x_carriage_wall_thickness = (x_carriage_overall_height - x_carriage_opening_height)/2;

x_carriage_mounting_plate_hole_spacing_z = x_carriage_overall_height+m3_nut_diam+extrude_width*12;
x_carriage_mounting_plate_height = x_carriage_mounting_plate_hole_spacing_z+m3_nut_diam+extrude_width*12;

z_stepper_diam             = 28;
z_stepper_thickness        = 19;
z_stepper_flange_thickness = 0.5;
z_stepper_flange_diam      = 7;
z_stepper_hole_spacing     = 35;
z_stepper_rotate_around_y = -50;
z_stepper_rotate_around_y = 0;
z_stepper_shaft_diam = 5.05;
z_stepper_pos_x = 6;
//z_stepper_pos_y = front*(x_carriage_overall_depth/2);
z_stepper_pos_z = z_stepper_diam/2+1;
z_cam_thickness = 5.5;
z_cam_angle = z_stepper_rotate_around_y+0;
z_cam_len = 16;
z_cam_diam = z_stepper_shaft_diam + wall_thickness*2;
z_cam_shaft_height = 0;

stepper_hole_mount_spacing = 35;
z_rod_diam  = 3;
z_rod_spacing = 38.55 + z_rod_diam; // measure inside spacing + rod diam to get center to center
z_carriage_rod_clearance = 0.2;
z_rod_pos_x = stepper_hole_mount_spacing/2+wall_thickness+z_rod_diam/2;
z_rod_pos_x = z_rod_spacing/2;
z_rod_pos_y = front*(z_rod_diam/2+4);
z_rod_pos_y = front*(x_carriage_overall_depth/2+6);
z_stepper_pos_y = z_rod_pos_y+z_rod_diam/2+z_stepper_diam/2;
z_rod_len   = 3*inch;

x_carriage_mounting_plate_hole_spacing_x = (z_rod_pos_x-m3_nut_diam*2)*2;

pen_diam  = 9;
pen_len   = 6*inch;

max_paper_thickness = 7; // be able to draw on 1/4" aluminum?
z_rod_support_thickness = x_carriage_wall_thickness;
z_rod_top_support_pos_z = top*(x_carriage_opening_height/2+z_rod_support_thickness/2);
z_rod_bottom_support_pos_z = bottom*(x_rail_pos_z-z_rod_support_thickness/2-max_paper_thickness);
z_rod_support_depth = abs(z_rod_pos_y)-x_carriage_opening_depth/2 + z_rod_diam/2 + z_rod_support_thickness/2;
z_axis_opening_height = (z_rod_top_support_pos_z - z_rod_bottom_support_pos_z) - z_rod_support_thickness;

z_carriage_height     = 20;
z_axis_movement_range = z_axis_opening_height - z_carriage_height;

module wheel() {
  // see http://makerstore.cc/wp-content/uploads/2015/03/Xtreme-Mini-V-Wheel-Kit-7.jpg
  module profile() {
    hull() {
      translate([wheel_diam/4,0,0]) {
        square([wheel_diam/2,5.78],center=true);
      }
      translate([12.21/4,0,0]) {
        square([12.21/2,8.80],center=true);
      }
    }
  }

  rotate_extrude(convexity=10,$fn=resolution) {
    profile();
  }
}

module motor_nema17() {
  difference() {
    translate([0,0,-nema17_len/2]) cube([nema17_side,nema17_side,nema17_len],center=true);
    for(end=[left,right]) {
      for(side=[front,rear]) {
        translate([nema17_hole_spacing/2*side,nema17_hole_spacing/2*end,0]) cylinder(r=motor_screw_diam/2,h=100,center=true);
      }
    }
  }
  hole(nema17_shoulder_diam,nema17_shoulder_height*2,16);

  translate([0,0,nema17_shaft_len/2]) {
    hole(nema17_shaft_diam,nema17_shaft_len,16);
    hole(line_pulley_diam,line_pulley_height,16);
  }
}

module motor_nema14() {
  difference() {
    translate([0,0,-nema14_len/2]) cube([nema14_side,nema14_side,nema14_len],center=true);
    for(end=[left,right]) {
      for(side=[front,rear]) {
        translate([nema14_hole_spacing/2*side,nema14_hole_spacing/2*end,0]) cylinder(r=motor_screw_diam/2,h=100,center=true);
      }
    }
  }
  hole(nema14_shoulder_diam,nema14_shoulder_height*2,16);

  translate([0,0,nema14_shaft_len/2]) {
    hole(nema14_shaft_diam,nema14_shaft_len,16);
    hole(line_pulley_diam,line_pulley_height,16);
  }
}

module extrusion(length) {
  v_slot_depth     = 1.80;
  v_slot_gap       = 5.68;
  v_slot_width     = v_slot_gap+v_slot_depth*2;

  module groove_profile() {
    hull() {
      square([v_slot_depth*2,v_slot_gap],center=true);
      translate([0,0,0]) {
        square([0.001,v_slot_width],center=true);
      }
    }

    groove_depth = 12.2/2;
    x_carriage_opening_behind_slot = 1.64;
    x_carriage_opening_behind_slot_width = v_slot_gap+(groove_depth-x_carriage_opening_behind_slot-v_slot_depth)*2;

    for(side=[left,right]) {
      translate([side*v_slot_depth,0,0]) {
        hull() {
          translate([side*(groove_depth-v_slot_depth)/2,0,0]) {
            square([groove_depth-v_slot_depth,v_slot_gap],center=true);
          }
          translate([side*x_carriage_opening_behind_slot/2,0,0]) {
            square([x_carriage_opening_behind_slot,x_carriage_opening_behind_slot_width],center=true);
          }
        }
      }
    }
  }

  module profile() {
    open_space_between_sides = extrusion_width-v_slot_depth*2;
    difference() {
      square([extrusion_width,extrusion_height],center=true);

      square([open_space_between_sides,5.4],center=true);

      hull() {
        square([open_space_between_sides-1.96*2,5.4],center=true);
        square([5.68,12.2],center=true);
      }

      for(y=[top,bottom]) {
        translate([0,y*extrusion_height/4]) {
          accurate_circle(4.2,16);

          for(x=[left,right]) {
            translate([x*extrusion_width/2,0]) {
              groove_profile();
            }
          }
        }

        translate([0,y*extrusion_height/2]) {
          rotate([0,0,90]) {
            groove_profile();
          }
        }
      }
    }
  }

  linear_extrude(height=length,center=true,convexity=2) {
    profile();
  }
}




module x_carriage_position_at_wheels() {
  translate([0,extrusion_height/2+wheel_extrusion_spacing,0]) {
    children();
  }
  for(x=[left,right]) {
    translate([x*x_carriage_width/2,front*(extrusion_height/2+wheel_extrusion_spacing),0]) {
      children();
    }
  }
}

module round_corner_filler(diam,length) {
  linear_extrude(height=length,center=true,convexity=3) {
    round_corner_filler_profile(diam);
  }
}

module round_corner_filler_profile(diam) {
  difference() {
    translate([diam/4,diam/4,0]) {
      square([diam/2,diam/2],center=true);
    }
    translate([diam/2,diam/2,0]) {
      accurate_circle(diam,resolution);
    }
  }
}

module belt_teeth(belt_width,length) {
  tooth_diam  = 1.4;
  tooth_pitch = 2;
  num_teeth = floor(length / tooth_pitch);

  module belt_tooth_profile() {
    square([1,tooth_pitch*(2*num_teeth+1)],center=true);

    for(side=[left,right]) {
      for(i=[0:num_teeth]) {
        translate([0.5,2*i*side,0]) {
          accurate_circle(tooth_diam,6);
        }
      }
    }
  }

  linear_extrude(height=belt_width,center=true,convexity=3) {
    # belt_tooth_profile();
  }
}

module rounded_square(width,depth,diam,fn=resolution) {
  pos_x = width/2-diam/2;
  pos_y = depth/2-diam/2;

  hull() {
    for(x=[left,right]) {
      for(y=[front,rear]) {
        translate([x*pos_x,y*pos_y,0]) {
          accurate_circle(diam,fn);
        }
      }
    }
  }
}

module rounded_cube(width,depth,height,diam,resolution) {
  linear_extrude(height=height,center=true,convexity=3) {
    rounded_square(width,depth,diam,resolution);
  }
}

module x_carriage() {
  echo("Z AXIS MOVEMENT RANGE", z_axis_movement_range);

  stepper_mount_depth = z_stepper_thickness/2;

  inner_diam = x_carriage_extrusion_carriage_gap*2;
  outer_diam = x_carriage_overall_height - x_carriage_opening_height - inner_diam;

  module carriage_profile() {
    module body() {
      rounded_square(x_carriage_overall_height,x_carriage_overall_depth,outer_diam);

      // z axis mounting plate
      translate([0,front*(x_carriage_opening_depth/2+x_carriage_wall_thickness/2),0]) {
        rounded_square(x_carriage_mounting_plate_height,x_carriage_wall_thickness,inner_diam);

        // round out internal corners
        for(z=[top,bottom]) {
          translate([z*(x_carriage_overall_height/2),rear*x_carriage_wall_thickness/2,0]) {
            rotate([0,0,45+(z*-45)]) {
              round_corner_filler_profile(inner_diam);
            }
          }
        }
      }

      // belt area
      belt_body_pos_z = belt_pos_z - x_rail_pos_z;
      belt_body_height = line_height + 2;
      belt_body_depth  = x_carriage_belt_spacing + line_thickness + extrude_width*12;
      translate([(belt_body_pos_z+belt_body_height/2)/2,0]) {
        rounded_square(belt_body_pos_z+belt_body_height/2,belt_body_depth,inner_diam);
      }

      for(y=[front,rear]) {
        translate([x_carriage_overall_height/2,y*belt_body_depth/2,0]) {
          rotate([0,0,-45+45*y]) {
            round_corner_filler_profile(inner_diam);
          }
        }
      }
    }

    module holes() {
      rounded_square(x_carriage_opening_height,x_carriage_opening_depth,inner_diam);
    }

    difference() {
      body();
      holes();
    }
  }

  module body() {
    rotate([0,-90,0]) {
      linear_extrude(height=x_carriage_width,center=true,convexity=3) {
        carriage_profile();
      }
    }

    stepper_mount_width = x_carriage_width/2 - z_stepper_thickness - z_stepper_flange_thickness;

    /*
    translate([0,0,x_carriage_overall_height/2]) {
      stepper_position_relative_to_x_carriage_top() {
        translate([0,0,-z_stepper_flange_thickness]) {
          translate([0,0,-stepper_mount_depth/2-0]) {
            translate([right*stepper_hole_mount_spacing/2,0,0]) {
              hole(z_stepper_flange_diam+1,stepper_mount_depth,resolution);
            }
          }
        }
      }
      stepper_position_relative_to_x_carriage_top() {
        translate([0,0,-z_stepper_flange_thickness]) {
          translate([0,0,-stepper_mount_depth/2-0]) {
            translate([left*stepper_hole_mount_spacing/2,0,0]) {
              hole(z_stepper_flange_diam+1,stepper_mount_depth,resolution);
            }
          }
        }
      }
    }
    */
  }

  module holes() {
    bushing_from_wall = extrusion_width/4;
    bushing_from_end  = 2.5;

    // z axis mounting holes
    for (x=[left,right]) {
      for (z=[top,bottom]) {
        translate([x*x_carriage_mounting_plate_hole_spacing_x/2,front*x_carriage_opening_depth/2,z*x_carriage_mounting_plate_hole_spacing_z/2]) {
          rotate([90,0,0]) {
            hole(m3_diam,x_carriage_wall_thickness*3,6);
            hole(m3_nut_diam,3,6);
          }
        }
      }
    }

    for (y=[front,0,rear]) {
      for(x=[left,right]) {
        for(z=[top,bottom]) {
          // top bottom PTFE bushing cavities
          translate([x*(x_carriage_width/2-x_carriage_bushing_len/2-bushing_from_end),y*x_carriage_bushing_pos_y,z*(x_carriage_opening_height/2-bushing_from_wall)]) {
            rotate([0,90,0]) {
              hole(ptfe_diam,x_carriage_bushing_len,8);
            }
          }
          // front/rear PTFE bushing cavities
          translate([x*(x_carriage_width/2-x_carriage_bushing_len/2-bushing_from_end),y*(x_carriage_opening_depth/2-bushing_from_wall),z*x_carriage_bushing_pos_z]) {
            rotate([0,90,0]) {
              hole(ptfe_diam,x_carriage_bushing_len,8);
            }
          }
        }
      }
    }

    // belt retention/tension
    line_opening_height = line_height+2.1;
    for(y=[front,rear]) {
      translate([0,y*(x_carriage_belt_spacing/2),belt_pos_z-x_carriage_pos_z]) {
        rotate([0,0,-90*y]) {
          belt_teeth(line_opening_height,x_carriage_width);
        }
        // % cube([x_carriage_width+1,line_thickness,line_opening_height],center=true);
      }
    }

    // line slack exit
    hull() {
      translate([0,x_carriage_belt_spacing/2+10,belt_pos_z-x_rail_pos_z+line_opening_height/2]) {
        cube([5,20,line_opening_height*2],center=true);
        cube([5+line_opening_height*2+2,20,0.01],center=true);
      }
    }
  }

  difference() {
    body();
    holes();
  }
}

module stepper_position_relative_to_x_carriage_top() {
  translate([z_stepper_pos_x,z_stepper_pos_y,z_stepper_pos_z]) {
    rotate([0,0,-90]) {
      rotate([0,z_stepper_rotate_around_y,0]) {
        rotate([90,0,0]) {
          rotate([0,0,90]) {
            children();
          }
        }
      }
    }
  }
}

module x_carriage_assembly() {
  translate([0,0,-x_carriage_pos_z+x_rail_pos_z]) {
    x_carriage();
  }

  translate([-z_rod_pos_x/2,z_rod_pos_y,x_carriage_overall_height/2+z_axis_movement_range/2]) {
    //% cube([4,4,z_axis_movement_range],center=true);
  }

  // z rods
  translate([0,z_rod_pos_y,0]) {
    for(x=[left,right]) {
      translate([x*(z_rod_pos_x),0,0]) {
        // % hole(z_rod_diam,z_rod_len,resolution);
      }
    }

    z_carriage();
  }

  translate([0,front*(x_carriage_overall_depth/2+0.5),0]) {
    rotate([90,0,0]) {
      z_axis_mount();
    }
  }

  translate([0,0,80]) {
    //stepper28BYJ();
  }

  translate([0,0,x_carriage_overall_height/2]) {
    stepper_position_relative_to_x_carriage_top() {
      translate([0,0,0.01]) {
        //stepper28BYJ();
      }
    }
  }


  /*
  for(x=[left,right]) {
    translate([x*x_carriage_width/2,-extrusion_height/2-wheel_extrusion_spacing,-plate_thickness/2-extrusion_wheel_gap-extrusion_width/2]) {
      color("lightblue", 0.75) wheel();
    }
  }
  translate([0,extrusion_height/2+wheel_extrusion_spacing,-plate_thickness/2-extrusion_wheel_gap-extrusion_width/2]) {
    color("lightblue", 0.75) wheel();
  }
  */
}

module y_carriage_position_at_wheels() {
  translate([extrusion_width/2+wheel_extrusion_spacing,0]) {
    children();
  }
  for(y=[front,rear]) {
    translate([-extrusion_width/2-wheel_extrusion_spacing,y*(y_carriage_depth/2),0]) {
      children();
    }
  }
}

module y_carriage_plate(endstop=true) {
  module body() {
    hull() {
      y_carriage_position_at_wheels() {
        accurate_circle(wheel_diam,resolution);
      }

      translate([-extrusion_width/2-30,0,0]) {
        square([wheel_diam,extrusion_height],center=true);
      }

      if (endstop) {
        translate([extrusion_width/2+wheel_extrusion_spacing,-y_carriage_depth/2,0]) {
          accurate_circle(wheel_diam,resolution);
        }
      }
    }
  }

  module holes() {
    y_carriage_position_at_wheels() {
      accurate_circle(5,resolution);
    }

    // attach to X rail
    for(x=[-12,-30]) {
      for(y=[front,rear]) {
        translate([-extrusion_width/2+x,y*extrusion_width/2,0]) {
          accurate_circle(5,resolution);
        }
      }
    }

    // belt idlers
    // motor side
    translate([inner_line_idler_pos_x-y_carriage_pos_x,front*(line_bearing_diam/2+x_carriage_belt_spacing/2+line_thickness/2),0]) {
      accurate_circle(4.2,resolution);
    }
    // rear
    translate([inner_line_idler_pos_x-y_carriage_pos_x,rear*(line_bearing_diam/2+x_carriage_belt_spacing/2+line_thickness/2),0]) {
      accurate_circle(4.2,resolution);
    }
  }

  difference() {
    body();
    holes();
  }
}

module y_carriage_assembly() {
  linear_extrude(height=plate_thickness,center=true,convexity=2) {
    y_carriage_plate();
  }

  for(y=[front,rear]) {
    translate([-extrusion_width/2-wheel_extrusion_spacing,y*(y_carriage_depth/2),-plate_thickness/2-extrusion_wheel_gap-extrusion_width/2]) {
      color("lightblue", 0.75) wheel();
    }
  }
  translate([extrusion_width/2+wheel_extrusion_spacing,0,-plate_thickness/2-extrusion_wheel_gap-extrusion_width/2]) {
    color("lightblue", 0.75) wheel();
  }
}

module rear_idler_mount(side) {
  _outer_line_idler_pos_x = outer_line_idler_pos_x - y_rail_pos_x;
  _inner_line_idler_pos_x = inner_line_idler_pos_x - y_rail_pos_x;

  outer_line_idler_pos_y = rear_idler_pos_y(side)-print_depth/2;
  inner_line_idler_pos_y = rear_idler_pos_y(abs(1-side))-print_depth/2;

  coords = [
    [_outer_line_idler_pos_x,outer_line_idler_pos_y],
    [_inner_line_idler_pos_x,inner_line_idler_pos_y],
  ];

  hole_body_diam = line_bearing_inner + extrude_width*16;

  height_above_extrusion = belt_pos_z - line_bearing_thickness/2 - spacer - extrusion_height;

  overall_width = outer_line_idler_pos_x - inner_line_idler_pos_x + line_bearing_inner + extrude_width*6;

  module body() {
    overall_depth = max(outer_line_idler_pos_y, inner_line_idler_pos_y) + hole_body_diam/2;

    hull() {
      for(z=[extrusion_height*0.25,extrusion_height*0.75]) {
        translate([0,overall_depth/2,z]) {
          rotate([90,0,0]) {
            hole(hole_body_diam,overall_depth,16);
          }
        }
      }

      translate([0,0,extrusion_height/2+height_above_extrusion/2]) {
        translate([0,1,0]) {
          translate([_outer_line_idler_pos_x,0,0]) {
            cube([hole_body_diam,2,extrusion_height+height_above_extrusion],center=true);
          }
          translate([_inner_line_idler_pos_x,0,0]) {
            cube([hole_body_diam,2,extrusion_height+height_above_extrusion],center=true);
          }
          cube([extrusion_width,2,extrusion_height+height_above_extrusion],center=true);
        }
        for (coord=coords) {
          translate(coord) {
            hole(hole_body_diam,extrusion_height+height_above_extrusion,16);
          }
        }
      }
    }
  }

  module holes() {
    // extrusion bolt holes
    for(z=[extrusion_height*0.25,extrusion_height*0.75]) {
      translate([0,0,z]) {
        rotate([90,0,0]) {
          hole(5,extrusion_height*2,16);
        }
      }
    }

    // idler shafts
    translate([_outer_line_idler_pos_x,outer_line_idler_pos_y,extrusion_height/2]) {
      hole(4.8,extrusion_height*3,16);
    }

    translate([_inner_line_idler_pos_x,inner_line_idler_pos_y,extrusion_height/2]) {
      hole(4.8,extrusion_height*3,16);
    }
  }

  difference() {
    body();
    holes();
  }
}

// likely needs to be different between line/belt :(
module extrusion_motor_mount() {
  module body() {
    translate([0,motor_mount_thickness/2,-extrusion_height/2]) {
      cube([motor_side+extrude_width*16,motor_side+motor_mount_thickness,extrusion_height],center=true);
    }
  }

  module holes() {
    translate([-motor_mount_offset,0,0]) {
      for(z=[-extrusion_height*0.25,-extrusion_height*0.75]) {
        translate([0,0,z]) {
          rotate([90,0,0]) {
            hole(5,extrusion_height*2,16);
          }
        }
      }
    }
  }

  % motor_nema17();

  difference() {
    body();
    holes();
  }
}

translate([0,0,10]) {
  //color("red") extrusion(10);
}

module line_path(side=0) {
  // belt path
  colors = ["red", "blue"];
  % color(colors[side], 0.5) {
    // x carriage to motor side y carriage
    hull() {
      translate([0,-x_carriage_belt_spacing/2,belt_pos_z]) {
        // x carriage
        translate([4,0,0]) {
          cube([1,1,line_height],center=true);
        }
        // y carriage
        translate([inner_line_idler_pos_x,0,0]) {
          cube([1,1,line_height],center=true);
        }
      }
    }

    translate([inner_line_idler_pos_x,-x_carriage_belt_spacing/2-line_bearing_diam/2-line_thickness/2,belt_pos_z]) {
      difference() {
        hole(line_bearing_diam,line_bearing_thickness,resolution);
        hole(line_bearing_inner,line_bearing_thickness+1,resolution);
      }
    }

    // y carriage to motor
    hull() {
      translate([inner_line_idler_pos_x+line_bearing_diam/2,0,belt_pos_z]) {
        // motor side
        translate([0,motor_pos_y,0]) {
          cube([1,1,line_height],center=true);
        }
        // y carriage
        translate([0,-x_carriage_belt_spacing/2-line_bearing_diam/2,0]) {
          cube([1,1,line_height],center=true);
        }
      }
    }

    // motor to rear
    hull() {
      translate([motor_pos_x+line_pulley_diam/2,motor_pos_y,belt_pos_z]) {
        cube([1,1,line_height],center=true);
      }
      translate([outer_line_idler_pos_x+line_bearing_diam/2,rear_idler_pos_y(side),rear_idler_pos_z(side,1)]) {
        cube([1,1,line_height],center=true);
      }
    }

    translate([outer_line_idler_pos_x,rear_idler_pos_y(side),rear_idler_pos_z(side,1)]) {
      difference() {
        hole(line_bearing_diam,line_bearing_thickness,resolution);
        hole(line_bearing_inner,line_bearing_thickness+1,resolution);
      }
    }

    // rear across
    hull() {
      translate([outer_line_idler_pos_x,rear_idler_pos_y(side)+line_bearing_diam/2,rear_idler_pos_z(side,1)]) {
        cube([1,1,line_height],center=true);
      }
      translate([left*inner_line_idler_pos_x,rear_idler_pos_y(side)+line_bearing_diam/2,rear_idler_pos_z(side,0)]) {
        cube([1,1,line_height],center=true);
      }
    }

    translate([left*(inner_line_idler_pos_x),rear_idler_pos_y(side),rear_idler_pos_z(side,0)]) {
      difference() {
        hole(line_bearing_diam,line_bearing_thickness,resolution);
        hole(line_bearing_inner,line_bearing_thickness+1,resolution);
      }
    }

    // rear to non-motor-side y carriage
    hull() {
      translate([left*inner_line_idler_pos_x-line_bearing_diam/2,0,belt_pos_z]) {
        // motor side
        translate([0,rear_idler_pos_y(side),0]) {
          cube([1,1,line_height],center=true);
        }
        // y carriage
        translate([0,rear*(x_carriage_belt_spacing/2+line_bearing_diam/2),0]) {
          cube([1,1,line_height],center=true);
        }
      }
    }

    translate([left*inner_line_idler_pos_x,rear*(x_carriage_belt_spacing/2+line_bearing_diam/2+line_thickness/2),belt_pos_z]) {
      difference() {
        hole(line_bearing_diam,line_bearing_thickness,resolution);
        hole(line_bearing_inner,line_bearing_thickness+1,resolution);
      }
    }

    // non-motor-side y carriage to x carriage
    hull() {
      translate([0,rear*(x_carriage_belt_spacing/2),belt_pos_z]) {
        translate([left*inner_line_idler_pos_x,0,0]) {
          // y carriage
          cube([1,1,line_height],center=true);
        }
        // x carriage
        translate([-4,0,0]) {
          cube([1,1,line_height],center=true);
        }
      }
    }
  }
}

module assembly() {
  for(side=[0,1]) {
    mirror([side,0,0]) {
      translate([y_rail_pos_x,0,y_rail_pos_z]) {
        rotate([90,0,0]) {
          color("silver") extrusion(print_depth);
        }
      }

      line_path(side);

      translate([y_carriage_pos_x,0,y_carriage_pos_z]) {
        y_carriage_assembly();
      }

      translate([y_rail_pos_x,print_depth/2+0.1,0]) {
        rear_idler_mount(side);
      }

      translate([motor_pos_x,motor_pos_y,motor_pos_z]) {
        extrusion_motor_mount();
        // color("grey", 0.8) motor_nema17();
      }
    }

    translate([0,0,x_carriage_pos_z]) {
      x_carriage_assembly();
    }
  }

  translate([0,0,x_rail_pos_z]) {
    rotate([0,90,0]) {
        color("silver") extrusion(x_rail_len);
    }
  }
}

module pen(diam=pen_diam) {
  hull() {
    translate([0,0,pen_diam]) {
      hole(1,pen_diam*2,4);

      translate([0,0,pen_len/2]) {
        hole(diam,pen_len,32);
      }
    }
  }
}

module stepper28BYJ() {
  // 28BYJ-48 Stepper Motor Model
  // Mark Benson
  // 23/07/2013
  // Creative Commons Non Commerical
  // http://www.thingiverse.com/thing:122070

  rotate([0,0,180]) {
    translate([0,0,-19]) {
      difference() {
        union() {
          //Body
          color("SILVER") cylinder(r=z_stepper_diam/2, h=z_stepper_thickness, $fn=60);

          //Base of motor shaft
          color("SILVER") translate([0,8,19]) cylinder(r=9/2, h=1.5, $fn=40);

          //Motor shaft
          color("SILVER") translate([0,8,20.5])
          rotate([0,0,z_cam_angle+-z_stepper_rotate_around_y+90]) {
            intersection() {
              cylinder(r=5/2, h=9, $fn=40);
              cube([3,6,9],center=true);
            }
          }

          //Left mounting lug
          color("SILVER") translate([-35/2,0,18.5]) mountingLug();

          //Right mounting lug
          color("SILVER") translate([35/2,0,18.5]) rotate([0,0,180]) mountingLug();

          difference() {
            //Cable entry housing
            color("BLUE") translate([-14.6/2,-17,1.9]) cube([14.6,17,17]);

            cylinder(r=27/2, h=29, $fn=60);
          }
        }

        union() {
          //Flat on motor shaft
          //translate([-5,0,22]) cube([10,7,25]);
        }
      }
    }
  }

  module mountingLug() {
    difference() {
      hull() {
        cylinder(r=7/2, h=0.5, $fn=40);
        translate([0,-7/2,0]) {
          cube([7,7,0.5]);
        }
      }

      translate([0,0,-1]) cylinder(r=4.2/2, h=2, $fn=40);
    }
  }
}

module z_axis_cam() {
  shaft_flat_thickness = 3.1;
  tip_diam = z_cam_diam/2;

  module shaft(len) {
    linear_extrude(height=len,center=true,convexity=2) {
      hull() {
        accurate_circle(z_cam_diam,16);

        translate([0,-z_cam_diam/2,0]) {
          square([z_cam_diam,2],center=true);
        }
      }
    }
  }

  module body() {
    translate([0,0,z_cam_shaft_height]) {
      shaft(z_cam_thickness);
    }

    hull() {
      shaft(z_cam_thickness);
      translate([z_cam_len-tip_diam/2,0,0]) {
        hole(tip_diam,z_cam_thickness,resolution);
      }
    }
  }

  module holes() {
    intersection() {
      hole(z_stepper_shaft_diam,z_cam_thickness+0.2,resolution);

      cube([10,shaft_flat_thickness,z_cam_thickness+0.2],center=true);
    }
    // set screw
    translate([0,-z_cam_diam/2,z_cam_shaft_height]) {
      rotate([90,0,0]) {
        rotate([0,0,90]) {
          hole(3,z_cam_diam,6);
        }
      }
    }
  }

  translate([0,0,z_cam_thickness/2]) {
    rotate([0,0,z_stepper_rotate_around_y]) {
      difference() {
        body();
        holes();
      }
    }
  }
}

module z_axis_mount() {
  long_rod_length = 67;

  short_rod_long_shoulder = 5.3;
  short_rod_short_shoulder = 2.3;
  short_rod_small_diam = 1.6;
  short_rod_length = 44;
  short_rod_length = 36.5; // pretend like the short rod is shorter and ignore the narrower diameter
  short_rod_thick_length = short_rod_length - short_rod_short_shoulder - short_rod_long_shoulder;
  short_rod_thick_length = short_rod_length;

  overall_width = x_carriage_width;
  rounded_diam = 3;

  z_rod_from_surface = 6 - z_rod_diam/2;

  plate_thickness = x_carriage_wall_thickness;

  rod_retainer_thickness = zip_tie_width+extrude_width*12;
  rod_retainer_height    = z_rod_from_surface + z_rod_diam/2 + 2;

  bottom_pos_z = -x_carriage_mounting_plate_height/2;
  short_rod_pos_z = bottom_pos_z + rod_retainer_thickness/2 + short_rod_length/2 -1;
  long_rod_pos_z = bottom_pos_z + rod_retainer_thickness/2 + long_rod_length/2 -1;

  rod_to_side = x_carriage_width-(z_rod_pos_x*2);

  module short_rod() {
    total_length = short_rod_length+short_rod_long_shoulder+short_rod_short_shoulder;
    hole(z_rod_diam,short_rod_length,resolution);
    translate([0,0,-total_length/2+short_rod_length/2+short_rod_short_shoulder]) {
      hole(short_rod_small_diam,total_length,resolution);
    }
    //hole(short_rod_small_diam,short_rod_length,resolution);
    //translate([0,0,short_rod_short_shoulder]) {
    //translate([0,0,short_rod_short_shoulder]) {
    //  hole(z_rod_diam,short_rod_thick_length,resolution);
    //}
  }

  module position_motor() {
    translate([8,x_carriage_mounting_plate_height/2+z_stepper_diam/2+1,plate_thickness]) {
      rotate([0,0,-30]) {
        children();
      }
    }
  }

  module long_rod() {
    hole(z_rod_diam,long_rod_length,resolution);
  }

  translate([0,0,plate_thickness+z_rod_from_surface]) {
    translate([left*z_rod_pos_x,long_rod_pos_z,0]) {
      rotate([90,0,0]) {
        % long_rod();
      }
    }
    translate([right*z_rod_pos_x,short_rod_pos_z,0]) {
      rotate([90,0,0]) {
        % short_rod();
      }
    }
  }

  position_motor() {
    translate([0,0,z_stepper_flange_thickness+0.1]) {
      % stepper28BYJ();
    }
  }

  module position_rod_posts() {
    translate([right*z_rod_pos_x,short_rod_pos_z,0]) {
      for(z=[top,bottom]) {
        translate([0,z*(short_rod_length/2-1),0]) {
          children();
        }
      }
    }
    translate([left*z_rod_pos_x,long_rod_pos_z,0]) {
      for(z=[top,bottom]) {
        translate([0,z*(long_rod_length/2-1),0]) {
          children();
        }
      }
    }
  }

  module body() {
    translate([0,0,plate_thickness/2]) {
      linear_extrude(height=plate_thickness,center=true,convexity=3) {
        hull() {
          position_rod_posts() {
            rounded_square(rod_to_side,rod_retainer_thickness,rounded_diam);
          }
          position_motor() {
            for(x=[left,right]) {
              translate([x*(z_stepper_hole_spacing/2),0,0]) {
                accurate_circle(z_stepper_flange_diam,resolution);
              }
            }
          }
        }
      }
    }
    position_rod_posts() {
      translate([0,0,plate_thickness+rod_retainer_height/2]) {
        rounded_cube(rod_to_side,rod_retainer_thickness,rod_retainer_height,rounded_diam,resolution);
      }
    }

    // long rod mount posts
    // short rod mount posts
    // z stepper mounting holes
  }

  module holes() {
    // mounting holes
    for(x=[left,right]) {
      for(z=[top,bottom]) {
        translate([x*(x_carriage_mounting_plate_hole_spacing_x/2),z*(x_carriage_mounting_plate_hole_spacing_z/2),plate_thickness]) {
          hole(m3_diam+0.1,plate_thickness*2+1,resolution);
          hole(6,plate_thickness-1,resolution);
        }
      }
    }

    hole(x_carriage_mounting_plate_hole_spacing_z*0.7,plate_thickness*2+1,resolution);

    position_motor() {
      hole(z_stepper_diam+0.1,30,resolution);
      for(x=[left,right]) {
        translate([x*(z_stepper_hole_spacing/2),0,0]) {
          hole(m3_diam,30,16);
        }
      }
    }

    module zip_tie_cavity() {
      translate([0,0.25,0]) {
        for(x=[left,right]) {
          translate([x*(z_rod_diam/2+zip_tie_thickness/2-0.1),0,0]) {
            cube([zip_tie_thickness,zip_tie_width,50],center=true);
          }
        }

        translate([0,0,0]) {
          cube([z_rod_diam,zip_tie_width,2*(5+z_rod_diam)],center=true);
        }

        translate([0,0,-z_rod_from_surface-plate_thickness-5]) {
          cube([z_rod_diam,zip_tie_width,zip_tie_thickness*2],center=true);
        }
      }
    }

    // rod cavities
    translate([0,0,plate_thickness+z_rod_from_surface]) {
      translate([left*z_rod_pos_x,long_rod_pos_z,0]) {
        cube([z_rod_diam,long_rod_length,z_rod_diam],center=true);

        translate([0,long_rod_length/2,5.5]) {
          cube([rod_to_side+1,rod_retainer_thickness+3,10],center=true);

          translate([0,-zip_tie_width/2,0]) {
            zip_tie_cavity();
          }
        }
      }
      translate([right*z_rod_pos_x,short_rod_pos_z,0]) {
        cube([z_rod_diam,short_rod_length,z_rod_diam],center=true);
        cube([short_rod_small_diam,short_rod_length*2,short_rod_small_diam+1],center=true);

        translate([0,short_rod_length/2,5.5]) {
          cube([rod_to_side+1,rod_retainer_thickness+3,10],center=true);

          translate([0,-zip_tie_width/2,0]) {
            zip_tie_cavity();
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

module z_carriage() {
  min_pen_diam = 3;
  max_pen_diam = 15;
  pen_pos_y    = front*(z_rod_support_thickness+z_rod_diam+max_pen_diam/2);

  slider_thickness = z_rod_support_thickness+z_rod_diam+2;
  slider_width     = z_rod_pos_x*2 + slider_thickness;

  raised_pen_dist_to_paper = max_paper_thickness-1;

  contact_width = 4;

  module body() {
  }

  translate([0,pen_pos_y,-x_rail_pos_z+raised_pen_dist_to_paper]) {
    //% pen(max_pen_diam-1);
  }

  module holes() {
  }

  difference() {
    body();
    holes();
  }
}

translate([0,0,-1]) {
  // % cube([print_width,print_depth,2],center=true);
}
