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

x_carriage_pos_z = y_carriage_pos_z + extrusion_wheel_gap;

x_carriage_belt_spacing = 5;

y_carriage_depth = extrusion_width*2+20+wheel_diam;

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

x_carriage_width = extrusion_height + wheel_diam;
ptfe_diam      = 4;
ptfe_bushing_preload_amount = 0.0; // undersize by this much to ensure no slop

x_carriage_extrusion_carriage_gap = ptfe_diam*0.3 - ptfe_bushing_preload_amount;

x_carriage_wall_thickness = ptfe_diam - x_carriage_extrusion_carriage_gap + extrude_width*3;

x_carriage_opening_depth  = extrusion_height + x_carriage_extrusion_carriage_gap*2;
x_carriage_opening_height = extrusion_width  + x_carriage_extrusion_carriage_gap*2;

x_carriage_bushing_len   = 8;
x_carriage_bushing_pos_y = extrusion_height/2 + ptfe_diam/2 - ptfe_bushing_preload_amount;
x_carriage_bushing_pos_z = extrusion_width/2  + ptfe_diam/2 - ptfe_bushing_preload_amount;

x_carriage_overall_depth  = x_carriage_bushing_pos_y*2 + ptfe_diam + extrude_width*8;
x_carriage_overall_height  = x_carriage_bushing_pos_z*2 + ptfe_diam + extrude_width*8;

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

module x_carriage_plate() {
  module body() {
    hull() {
      x_carriage_position_at_wheels() {
        accurate_circle(wheel_diam,resolution);
      }
      for(side=[left,right]) {
        translate([side*(x_carriage_width/2),0,0]) {
          // accurate_circle(wheel_diam,resolution);
        }
      }
    }
  }

  module holes() {
    x_carriage_position_at_wheels() {
      accurate_circle(5,resolution);
    }
  }

  difference() {
    body();
    holes();
  }
}

module z_carriage() {
  module body() {
  }

  module holes() {
  }

  difference() {
    body();
    holes();
  }
}

module x_carriage_printed() {
  stepper_mount_depth = z_stepper_thickness/2;
  module body() {
    retainer_anchor_width = 2.5*(z_rod_retainer_diam/2 + abs(z_rod_pos_y) - abs(x_carriage_overall_depth/2));

    hull() {
      cube([x_carriage_width,x_carriage_overall_depth,x_carriage_overall_height],center=true);

      translate([0,z_rod_pos_y,0]) {
        cube([x_carriage_width,z_rod_retainer_diam,x_carriage_overall_height],center=true);
      }
    }

    translate([0,z_stepper_pos_y+z_stepper_flange_thickness+stepper_mount_depth/2,0]) {
      hull() {
        translate([right*x_carriage_width/2-1,0,0]) {
          cube([2,stepper_mount_depth,x_carriage_overall_height],center=true);
        }
        translate([z_stepper_diam/4,0,-z_stepper_diam/4]) {
          cube([z_stepper_diam/2,stepper_mount_depth,z_stepper_diam/2],center=true);
        }
        translate([z_stepper_pos_x,0,z_stepper_pos_z]) {
          rotate([0,z_stepper_rotate_around_y,0]) {
            translate([right*z_stepper_hole_spacing/2,0,0]) {
              rotate([90,0,0]) {
                hole(z_stepper_flange_diam+1,stepper_mount_depth,resolution);
              }
              rotate([0,-z_stepper_rotate_around_y,0]) {
                translate([15,0,0]) {
                  cube([30,stepper_mount_depth,z_stepper_flange_diam+1],center=true);
                }
              }
            }
          }
        }
      }

      hull() {
        translate([z_stepper_pos_x,0,z_stepper_pos_z]) {
          rotate([0,z_stepper_rotate_around_y,0]) {
            translate([left*z_stepper_hole_spacing/2,0,0]) {
              rotate([90,0,0]) {
                hole(z_stepper_flange_diam+1,stepper_mount_depth,resolution);
              }
              rotate([0,-z_stepper_rotate_around_y+90,0]) {
                translate([z_stepper_diam/4,0,z_stepper_diam/4-z_stepper_flange_diam/2+0.5]) {
                  cube([z_stepper_diam/2,stepper_mount_depth,z_stepper_diam/2+2],center=true);
                }
              }
            }
          }
        }
      }
    }
  }

  module holes() {
    cube([x_carriage_width+1,x_carriage_opening_depth,x_carriage_opening_height],center=true);

    translate([z_stepper_pos_x,z_stepper_pos_y,z_stepper_pos_z]) {
      rotate([0,z_stepper_rotate_around_y,0]) {
        rotate([90,0,0]) {
          hole(z_stepper_diam+1,(z_stepper_thickness+z_stepper_flange_thickness)*2+0.1,resolution);
        }

        translate([0,0,z_stepper_diam/2]) {
          cube([z_stepper_diam+1,(z_stepper_thickness+z_stepper_flange_thickness)*2+0.1,z_stepper_diam+1],center=true);
        }
      }
    }

    translate([0,z_stepper_pos_y+z_stepper_flange_thickness+stepper_mount_depth/2,0]) {
      translate([z_stepper_pos_x,0,z_stepper_pos_z]) {
        rotate([0,z_stepper_rotate_around_y,0]) {
          translate([right*z_stepper_hole_spacing/2,0,0]) {
            rotate([90,0,0]) {
              rotate([0,0,z_stepper_rotate_around_y]) {
                hole(3,stepper_mount_depth+1,8);
              }
            }
          }
          translate([left*z_stepper_hole_spacing/2,0,0]) {
            rotate([90,0,0]) {
              rotate([0,0,z_stepper_rotate_around_y]) {
                hole(3,stepper_mount_depth+1,8);
              }
            }
          }
        }
      }
    }

    // trim excess
    for(x=[left,right]) {
      translate([x*(x_carriage_width-0.1),0,0]) {
        cube([x_carriage_width,x_carriage_overall_depth*2,x_carriage_overall_height*10],center=true);
      }
    }

    //bushing_from_wall = x_carriage_bushing_len/2-x_carriage_wall_thickness/4;
    bushing_from_wall = x_carriage_bushing_len/2;

    for(x=[left,right]) {
      hull() {
        translate([x*z_rod_pos_x,0,0]) {
          translate([0,z_rod_pos_y,0]) {
            hole(z_rod_diam+z_rod_retainer_clearance*2,x_carriage_overall_height+1,8);
          }
        }
      }
    }

    for (y=[front,rear]) {
      for(x=[left,right]) {
        for(z=[top,bottom]) {
          // front/rear bushings
          translate([x*(x_carriage_width/2-2-ptfe_diam*0.5),y*x_carriage_bushing_pos_y,z*(x_carriage_opening_height/2-bushing_from_wall)]) {
            //hole(ptfe_diam,x_carriage_bushing_len+x_carriage_wall_thickness/2,8);
            hole(ptfe_diam,x_carriage_bushing_len,8);
          }
          // top/bottom bushings
          translate([x*(x_carriage_width/2-2-ptfe_diam*2.5),y*(x_carriage_opening_depth/2-bushing_from_wall),z*x_carriage_bushing_pos_z]) {
            rotate([90,0,0]) {
              //hole(ptfe_diam,x_carriage_bushing_len+x_carriage_wall_thickness/2,8);
              hole(ptfe_diam,x_carriage_bushing_len,8);
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

translate([0,0,extrusion_height*3.5]) {
  // x_carriage_printed();
}

module x_carriage_assembly() {
  translate([0,0,-x_carriage_pos_z+x_rail_pos_z]) {
    x_carriage_printed();
  }

  for(x=[left,right]) {
    translate([x*(z_rod_pos_x),z_rod_pos_y,0]) {
      % hole(z_rod_diam,z_rod_len,resolution);
    }
  }

  /*
  linear_extrude(height=plate_thickness,center=true,convexity=2) {
    x_carriage_plate();
  }
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
    translate([inner_line_idler_pos_x-y_carriage_pos_x,front*(line_bearing_diam/2+x_carriage_belt_spacing/2),0]) {
      accurate_circle(4.2,resolution);
    }
    // rear
    translate([inner_line_idler_pos_x-y_carriage_pos_x,rear*(line_bearing_diam/2+x_carriage_belt_spacing/2),0]) {
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

    translate([inner_line_idler_pos_x,-x_carriage_belt_spacing/2-line_bearing_diam/2,belt_pos_z]) {
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

    translate([left*inner_line_idler_pos_x,rear*(x_carriage_belt_spacing/2+line_bearing_diam/2),belt_pos_z]) {
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

for(side=[0,1]) {
  mirror([side,0,0]) {
    translate([y_rail_pos_x,0,0]) {
      translate([0,0,y_rail_pos_z]) {
        rotate([90,0,0]) {
          color("silver") extrusion(print_depth);
        }
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

pen_diam  = 9;
pen_len   = 6*inch;
module pen() {
  hull() {
    translate([0,0,pen_diam]) {
      hole(1,pen_diam*2,resolution);

      translate([0,0,pen_len/2]) {
        hole(pen_diam,pen_len,resolution);
      }
    }
  }
}

z_stepper_diam             = 28;
z_stepper_thickness        = 19;
z_stepper_flange_thickness = 0.5;
z_stepper_flange_diam      = 7;
z_stepper_hole_spacing     = 35;
z_stepper_rotate_around_y = -50;
z_stepper_rotate_around_y = -35;
z_stepper_shaft_diam = 5.05;
z_stepper_pos_x = 2;
z_stepper_pos_y = front*(x_carriage_overall_depth/2);
z_stepper_pos_z = x_carriage_overall_height/2+28/2+0;
z_cam_thickness = 5.5;
z_cam_angle = z_stepper_rotate_around_y+135;
z_cam_len = 16;
z_cam_diam = z_stepper_shaft_diam + wall_thickness*2;
z_cam_shaft_height = 0;

stepper_hole_mount_spacing = 35;
z_rod_diam  = 3;
z_rod_retainer_clearance = 0.2;
z_rod_retainer_diam = z_rod_diam+z_rod_retainer_clearance*2+extrude_width*8;
z_rod_pos_x = stepper_hole_mount_spacing/2+wall_thickness+z_rod_diam/2;
z_rod_pos_x = 28/2;
z_rod_pos_y = front*(z_rod_diam/2+4);
z_rod_pos_y = front*(x_carriage_overall_depth/2+8);
z_rod_len   = 3*inch;

module stepper28BYJ() {
  // 28BYJ-48 Stepper Motor Model
  // Mark Benson
  // 23/07/2013
  // Creative Commons Non Commerical
  // http://www.thingiverse.com/thing:122070

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
  rod_mount_height = 28;
  body_rear_pos_y  = 15;
  mount_plate_thickness = 4;

  module body() {
    for(x=[left,right]) {
      hull() {
        translate([x*z_rod_pos_x,0,0]) {
          translate([0,0,rod_mount_height/2]) {
            translate([0,z_rod_pos_y,0]) {
              hole(z_rod_diam+wall_thickness*2,rod_mount_height,resolution);
            }
            translate([0,body_rear_pos_y,0]) {
              hole(z_rod_diam+wall_thickness*2,rod_mount_height,resolution);
            }
          }
        }
      }
    }

    for(x=[left,right]) {
      hull() {
        translate([x*z_rod_pos_x,0,0]) {
          translate([0,0,rod_mount_height/2]) {
            translate([0,z_rod_pos_y,0]) {
              hole(z_rod_diam+wall_thickness*2,rod_mount_height,resolution);
            }
            translate([0,body_rear_pos_y/2,0]) {
              hole(z_rod_diam+wall_thickness*2,rod_mount_height,resolution);
            }
          }

          translate([0,body_rear_pos_y,mount_plate_thickness/2]) {
            hole(z_rod_diam+wall_thickness*2,mount_plate_thickness,resolution);
          }
        }
      }
    }
  }

  module holes() {
    for(x=[left,right]) {
      translate([x*z_rod_pos_x,z_rod_pos_y,0]) {
        hole(z_rod_diam+0.1,150,8);
      }
    }

    translate([0,0,mount_plate_thickness+z_stepper_diam/2]) {
      rotate([90,0,0]) {
        hole(z_stepper_diam+0.5,z_stepper_thickness*3,resolution);
      }
    }
  }

  difference() {
    body();
    holes();
  }
}

module z_axis_() {
  module body() {
  }

  module holes() {
  }

  difference() {
    body();
    holes();
  }
}

module z_axis_assembly() {
  // color("pink") z_axis_mount();

  translate([0,z_rod_pos_y+front*(z_rod_diam/2+3+pen_diam/2),-x_carriage_pos_z-plate_thickness/2]) {
    // % pen();
  }

  // between z rods at the bottom
  # cube([10,10,10],center=true);
  translate([z_stepper_pos_x,z_stepper_pos_y-0.1,z_stepper_pos_z]) {
    rotate([0,z_stepper_rotate_around_y,0]) {
      rotate([90,0,0]) {
        rotate([0,0,180]) {
          stepper28BYJ();

          translate([0,8,1.75]) {
            rotate([0,0,z_cam_angle]) {
              rotate([0,180,0]) {
                translate([0,0,-z_cam_shaft_height-z_cam_thickness]) {
                  z_axis_cam();
                }
              }
            }
          }
        }
      }
    }
  }

  /*
  // right side of x carriage
  translate([x_carriage_width/2,10-0.5,28/2+2]) {
    rotate([0,-90,0]) {
      rotate([0,0,180]) {
        stepper28BYJ();
      }
    }
  }
  */

  /*
  translate([0,10-0.5,28/2+10]) {
    rotate([0,z_stepper_rotate_around_y,0]) {
      rotate([90,0,0]) {
        rotate([0,0,180]) {
          stepper28BYJ();

          translate([0,8,1.75]) {
            rotate([0,0,0]) {
              rotate([0,180,0]) {
                translate([0,0,-z_cam_shaft_height-z_cam_thickness]) {
                  z_axis_cam();
                }
              }
            }
          }
        }
      }
    }
  }
  */
  /*

  for(side=[left,right]) {
    translate([side*z_rod_pos_x,z_rod_pos_y,0]) {
      % hole(z_rod_diam,z_rod_len,resolution*2);
    }
  }

  translate([0,z_rod_pos_y+front*(z_rod_diam/2+3+pen_diam/2),-x_carriage_pos_z-plate_thickness/2]) {
    % pen();
  }

  color("pink") z_axis_mount();

  translate([0,19-0.5,28/2+4]) {
    rotate([0,0,180]) {
      rotate([-90,0,0]) {
        rotate([0,0,z_stepper_rotate_around_y]) {
          stepper28BYJ();

          translate([0,8,19+1.75]) {
            rotate([0,180,0]) {
              rotate([0,0,180]) {
                translate([0,0,-z_cam_shaft_height-z_cam_thickness]) {
                  z_axis_cam();
                }
              }
            }
          }
        }
      }
    }
  }
  */
}

translate([0,0,extrusion_height*2]) {
}

translate([0,0,x_rail_pos_z]) {
  z_axis_assembly();

  translate([0,0,0]) {
  }

  for(side=[left,right]) {
    translate([0,-0.5,0]) {
      //# cube([z_stepper_hole_spacing,1,1],center=true);
    }
  }

}

translate([0,0,-1]) {
  // % cube([print_width,print_depth,2],center=true);
}
