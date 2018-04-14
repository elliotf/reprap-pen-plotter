include <util.scad>;

/*

TODO
* z axis
  * z cam
    * compensate for flat not being on entire shaft
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
m3_diam = 3.3;
m3_nut_diam = 5.7; // actually 5.5, but add fudge

base_plate_thickness = 3/4*inch;
base_plate_thickness = 1/2*inch;

m5_bolt_diam        = 5.25;
m5_bolt_head_height = 5;
m5_bolt_head_diam   = 10;
m5_nut_thickness    = 5;
m3_bolt_diam        = 3.25;
m3_bolt_head_height = 5;
m3_bolt_head_diam   = 7;

v_slot_depth     = 1.80;
v_slot_gap       = 5.68;
v_slot_width     = v_slot_gap+v_slot_depth*2;

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

zip_tie_thickness = 1.75;
zip_tie_width     = 3.25;

extrude_width = 0.4;
wall_thickness = extrude_width*4;

extrusion_width = 20;
extrusion_height = 40;
extrusion_screw_hole = 5;

plate_thickness = 1/4*inch;
extrusion_wheel_gap = 2;

wheel_screw_diam = 5;
wheel_spacer    = 6;
wheel_thickness = 8.8;
wheel_screw_length = wheel_thickness + wheel_spacer + plate_thickness + m5_nut_thickness;
plate_min_material = 5;

wheel_diam              = 15.23;
wheel_extrusion_spacing = 11.90/2; // edge of extrusion to wheel axle

y_carriage_plate_width = extrusion_height+2*(wheel_extrusion_spacing + wheel_diam/2);

rear_idler_line_gap = 4;

// hopefully final size
x_rail_len = 1000;
y_rail_len = 1500;

// prototype size
x_rail_len = 500;
y_rail_len = 500;

// development size
x_rail_len = 100;
y_rail_len = 100;

function rear_idler_pos_y(side) = y_rail_len/2+8+rear_idler_line_gap*side;
// lift one side to provide line/belt clearance
function rear_idler_pos_z(side,is_motor) = belt_pos_z + (is_motor*abs(side-1)*(line_bearing_thickness+1));

// filament-driven
line_height            = 1;
line_thickness         = 1;
line_bearing_diam      = 14-0.5*2; // 625zz v-groove for filament
line_bearing_thickness = 5;  // 625zz v-groove for filament

// belt-driven
line_height            = 6;
line_thickness         = 1;
line_bearing_diam      = 10; // mr105zz for belt
line_bearing_thickness = 10; // 2x mr105zz for belt

line_bearing_inner     = 5;

line_pulley_diam = (16*2)/approx_pi;
line_pulley_diam = (20*2)/approx_pi;
line_pulley_height = 10;

x_carriage_idler_spacing = 14+2;
x_carriage_belt_spacing = x_carriage_idler_spacing-line_bearing_diam - line_thickness;

x_carriage_width = extrusion_height + wheel_diam;
ptfe_diam      = 4;
ptfe_bushing_preload_amount = 0.0; // undersize by this much to ensure no slop

printed_carriage_extrusion_carriage_gap = ptfe_diam*0.3 - ptfe_bushing_preload_amount;
printed_carriage_outer_skin_from_extrusion = ptfe_diam -ptfe_bushing_preload_amount + extrude_width *6;
printed_carriage_wall_thickness = printed_carriage_outer_skin_from_extrusion - printed_carriage_extrusion_carriage_gap;
printed_carriage_bushing_from_end = 2.5;

x_carriage_opening_depth  = extrusion_height + printed_carriage_extrusion_carriage_gap*2;
x_carriage_opening_height = extrusion_width  + printed_carriage_extrusion_carriage_gap*2;

x_carriage_bushing_len   = 10;
x_carriage_bushing_pos_y = extrusion_height/2 + ptfe_diam/2 - ptfe_bushing_preload_amount;
x_carriage_bushing_pos_z = extrusion_width/2  + ptfe_diam/2 - ptfe_bushing_preload_amount;

y_carriage_depth = extrusion_width*2+20+wheel_diam;
y_carriage_len = extrusion_height + x_carriage_bushing_len*2 + printed_carriage_bushing_from_end*2;
//y_carriage_len = extrusion_height + printed_carriage_bushing_from_end*2;
x_rail_dist_from_y_carriage_end = printed_carriage_wall_thickness+3; // +3 to leave room for idler bolt

x_carriage_overall_depth  = x_carriage_bushing_pos_y*2 + ptfe_diam + 2*(extrude_width*6);
x_carriage_overall_depth  = extrusion_height+printed_carriage_outer_skin_from_extrusion*2;
x_carriage_overall_height  = x_carriage_bushing_pos_z*2 + ptfe_diam + 2*(extrude_width*6);
x_carriage_overall_height  = extrusion_width+printed_carriage_outer_skin_from_extrusion*2;

y_carriage_bushing_pos_x = extrusion_width/2 + ptfe_diam/2 - ptfe_bushing_preload_amount;
y_carriage_overall_width = extrusion_width+printed_carriage_outer_skin_from_extrusion*2;
y_carriage_opening_width = extrusion_width+printed_carriage_extrusion_carriage_gap*2;

x_carriage_wall_thickness = (x_carriage_overall_height - x_carriage_opening_height)/2;
z_axis_mount_thickness    = x_carriage_wall_thickness;

x_carriage_mounting_plate_hole_spacing_z = x_carriage_overall_height+m3_nut_diam+extrude_width*12;
x_carriage_mounting_plate_height = x_carriage_mounting_plate_hole_spacing_z+m3_nut_diam+extrude_width*12;

printed_carriage_inner_diam = printed_carriage_extrusion_carriage_gap*2;
printed_carriage_outer_diam = x_carriage_overall_height - x_carriage_opening_height - printed_carriage_inner_diam;
printed_carriage_outer_diam = (printed_carriage_outer_skin_from_extrusion-printed_carriage_extrusion_carriage_gap)*2;

x_rail_y_carriage_spacing = 1;
y_rail_pos_x = print_width/2-extrusion_width/2;
y_rail_pos_x = x_rail_len/2+5+extrusion_width/2;
y_rail_pos_x = x_rail_len/2+x_rail_y_carriage_spacing+printed_carriage_outer_skin_from_extrusion+extrusion_width/2;
y_rail_pos_z = extrusion_height/2;

motor_mount_thickness = 10;
motor_mount_offset    = -extrusion_screw_hole/2 - extrude_width*2 - line_bearing_inner/2 + line_bearing_diam/2 + line_thickness/2 + line_pulley_diam/2;
motor_pos_x = y_rail_pos_x-extrusion_width/2+nema17_side/2;
motor_pos_x = y_rail_pos_x + 6;
motor_pos_x = y_rail_pos_x + motor_mount_offset;

motor_pos_y = -y_rail_len/2-nema17_side/2-motor_mount_thickness;

motor_pos_z = motor_len + 2;

inner_line_idler_pos_x = motor_pos_x - line_pulley_diam/2 - line_thickness/2 - line_bearing_diam/2;
outer_line_idler_pos_x = inner_line_idler_pos_x + line_thickness/2 + line_bearing_diam + 2.5; // not sure how much room to leave for flanges/grooves/belt teeth

y_carriage_pos_x = y_rail_pos_x;
y_carriage_pos_z = y_rail_pos_z;
belt_pos_z  = y_carriage_pos_z + plate_thickness/2 + spacer + line_bearing_thickness/2;
belt_pos_z  = y_rail_pos_z + extrusion_height/2 + printed_carriage_outer_skin_from_extrusion + spacer + line_bearing_thickness/2;
x_rail_pos_z     = y_rail_pos_z + extrusion_width/2 + printed_carriage_wall_thickness;
x_rail_pos_z     = belt_pos_z - line_height/2 - x_carriage_overall_height/2;
x_rail_pos_z     = belt_pos_z - line_height/2 - x_carriage_overall_height/2;
x_rail_pos_z     = y_rail_pos_z + extrusion_width/2 + printed_carriage_extrusion_carriage_gap;
x_carriage_pos_z = x_rail_pos_z;

z_stepper_diam = 28;
z_stepper_height = 19.5; // body is 19, but flanges stick up

z_stepper_shaft_diam = 5;
z_stepper_flange_width = 42;
z_stepper_flange_diam = 7;
z_stepper_flange_thickness = 0.8;
z_stepper_flange_hole_diam = 4.2;
z_stepper_flange_hole_spacing = 35;

z_stepper_shaft_from_center = 8;
z_stepper_shaft_length = 7.9; // varies between 7.9 and 8.5, due to slop in the shaft
z_stepper_shaft_flat_length = 6.1;
z_stepper_shaft_flat_thickness = 3;
z_stepper_shaft_flat_cut_depth = (z_stepper_shaft_diam-z_stepper_shaft_flat_thickness)/2;
z_stepper_shaft_base_diam = 9.25;
z_stepper_shaft_base_height = 1.7; // what drawings say.  Actual measurement is 1.6

z_stepper_hump_height = 16.8;
z_stepper_hump_width = 15;
z_stepper_hump_depth = 17-z_stepper_diam/2;

z_cam_thickness = 7;
z_motor_angle = -25;
z_cam_angle = -z_motor_angle+0;
z_cam_len = 15;
z_cam_diam = z_stepper_shaft_diam + wall_thickness*2;
z_cam_shaft_height = 0;

stepper_hole_mount_spacing = 35;
z_rod_diam  = 3;
z_rod_from_surface = 6 - z_rod_diam/2;
z_rod_spacing = 38.55 + z_rod_diam; // measure inside spacing + rod diam to get center to center
z_rod_pos_x = z_rod_spacing/2;
z_rod_len   = 3*inch;
z_rod_retainer_thickness = zip_tie_width+extrude_width*12;
z_carriage_width = z_rod_pos_x*2;
z_carriage_height = 30;

x_carriage_mounting_plate_hole_spacing_x = (z_rod_pos_x-m3_nut_diam*2)*2;

pen_diam  = 9;
pen_len   = 6*inch;

max_paper_thickness = 7; // be able to draw on 1/4" aluminum?
z_rod_support_thickness = x_carriage_wall_thickness;
z_rod_top_support_pos_z = top*(x_carriage_opening_height/2+z_rod_support_thickness/2);
z_rod_bottom_support_pos_z = bottom*(x_rail_pos_z-z_rod_support_thickness/2-max_paper_thickness);
z_axis_opening_height = (z_rod_top_support_pos_z - z_rod_bottom_support_pos_z) - z_rod_support_thickness;

rear_idler_hole_body_diam = line_bearing_inner + extrude_width*16;
rear_idler_mount_overall_depth = max(rear_idler_pos_y(1), rear_idler_pos_y(0)) - y_rail_len/2 + rear_idler_hole_body_diam/2;

echo("BOM Wheel screw length: ", wheel_screw_length);
echo("BOM Y carriage to X axis screw length: ", 5+plate_thickness);
echo("BOM Y carriage idlers screw length: ", line_bearing_thickness+plate_thickness);
echo("BOM Motor mount screw length: ", motor_mount_thickness+10);
echo("BOM Rear Idler mount screw length: ", motor_mount_thickness+10);
echo("BOM Base plate screw length: ", base_plate_thickness+5);

module wheel() {
  // see http://makerstore.cc/wp-content/uploads/2015/03/Xtreme-Mini-V-Wheel-Kit-7.jpg
  module profile() {
    hull() {
      translate([wheel_diam/4,0,0]) {
        square([wheel_diam/2,5.78],center=true);
      }
      translate([12.21/4,0,0]) {
        square([12.21/2,wheel_thickness],center=true);
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
  module groove_profile() {
    hull() {
      square([v_slot_depth*2,v_slot_gap],center=true);
      translate([0,0,0]) {
        square([0.00001,v_slot_width],center=true);
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

module round_corner_filler_profile(diam,res=resolution) {
  difference() {
    translate([diam/4,diam/4,0]) {
      square([diam/2,diam/2],center=true);
    }
    translate([diam/2,diam/2,0]) {
      accurate_circle(diam,res);
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
    belt_tooth_profile();
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
  stepper_mount_depth = z_stepper_height/2;

  module carriage_profile() {
    module profile_body() {
      rounded_square(x_carriage_overall_height,x_carriage_overall_depth,printed_carriage_outer_diam);

      // z axis mounting plate
      translate([0,front*(x_carriage_opening_depth/2+x_carriage_wall_thickness/2),0]) {
        rounded_square(x_carriage_mounting_plate_height,x_carriage_wall_thickness,printed_carriage_inner_diam);

        // round out internal corners
        for(z=[top,bottom]) {
          translate([z*(x_carriage_overall_height/2),rear*x_carriage_wall_thickness/2,0]) {
            rotate([0,0,45+(z*-45)]) {
              round_corner_filler_profile(printed_carriage_inner_diam);
            }
          }
        }
      }

      // belt area
      belt_body_pos_z = belt_pos_z - x_rail_pos_z;
      belt_body_height = line_height + 2;
      belt_body_depth  = x_carriage_belt_spacing + line_thickness + extrude_width*12;
      translate([(belt_body_pos_z+belt_body_height/2)/2,0]) {
        rounded_square(belt_body_pos_z+belt_body_height/2,belt_body_depth,printed_carriage_inner_diam);
      }

      for(y=[front,rear]) {
        translate([x_carriage_overall_height/2,y*belt_body_depth/2,0]) {
          rotate([0,0,-45+45*y]) {
            round_corner_filler_profile(printed_carriage_inner_diam);
          }
        }
      }
    }

    module profile_holes() {
      rounded_square(x_carriage_opening_height,x_carriage_opening_depth,printed_carriage_inner_diam);
    }

    difference() {
      profile_body();
      profile_holes();
    }
  }

  module body() {
    rotate([0,-90,0]) {
      linear_extrude(height=x_carriage_width,center=true,convexity=3) {
        carriage_profile();
      }
    }

    stepper_mount_width = x_carriage_width/2 - z_stepper_height - z_stepper_flange_thickness;
  }

  module holes() {
    bushing_from_wall = extrusion_width/4;

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
          translate([x*(x_carriage_width/2-x_carriage_bushing_len/2-printed_carriage_bushing_from_end),y*x_carriage_bushing_pos_y,z*(x_carriage_opening_height/2-bushing_from_wall)]) {
            rotate([0,90,0]) {
              hole(ptfe_diam,x_carriage_bushing_len,8);
            }
          }
          // front/rear PTFE bushing cavities
          translate([x*(x_carriage_width/2-x_carriage_bushing_len/2-printed_carriage_bushing_from_end),y*(x_carriage_opening_depth/2-bushing_from_wall),z*x_carriage_bushing_pos_z]) {
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

module y_carriage_printed() {
  carriage_dist_from_bottom = 10;
  carriage_overall_height = extrusion_height - carriage_dist_from_bottom + printed_carriage_outer_skin_from_extrusion;

  x_rail_rel_pos_z = x_rail_pos_z - y_rail_pos_z;
  x_rail_rel_pos_y = y_carriage_len/2-x_rail_dist_from_y_carriage_end-extrusion_height/2;
  line_bearing_rel_pos_x = inner_line_idler_pos_x-y_rail_pos_x;
  line_bearing_rel_pos_z = belt_pos_z-y_rail_pos_z;

  x_rail_clamp_len = printed_carriage_wall_thickness + x_rail_y_carriage_spacing + 20;
  x_rail_clamp_depth = extrusion_height+x_rail_dist_from_y_carriage_end;
  arm_pos_x = extrusion_width/2+printed_carriage_extrusion_carriage_gap+printed_carriage_wall_thickness/2;

  module position_idlers() {
    translate([line_bearing_rel_pos_x,x_rail_rel_pos_y,0]) {
      for(side=[front,rear]) {
        translate([0,side*(x_carriage_idler_spacing/2),0]) {
          children();
        }
      }
    }
  }

  module clamp_profile() {
    // FIXME: either make this more parametric, or more tolerant of 625 bearings
    reinforcement_thickness = extrude_width*8;
    reinforcement_thickness = printed_carriage_wall_thickness;
    reinforcement_width     = outer_line_idler_pos_x - inner_line_idler_pos_x + line_bearing_diam/2 + reinforcement_thickness;
    reinforcement_height    = line_bearing_thickness+spacer*2+printed_carriage_wall_thickness*2;
    // reinforcement for line bearing shafts
    translate([line_bearing_rel_pos_x-line_bearing_diam/2+reinforcement_width/2-reinforcement_thickness/2,extrusion_height/2+printed_carriage_extrusion_carriage_gap+reinforcement_height-reinforcement_thickness/2]) {
      rounded_square(reinforcement_width,reinforcement_thickness,reinforcement_thickness);

      translate([reinforcement_width/2-reinforcement_thickness/2,-reinforcement_height/2+reinforcement_thickness/2]) {
        rounded_square(reinforcement_thickness,reinforcement_height,reinforcement_thickness);

        for(side=[top,bottom]) {
          translate([-reinforcement_thickness/2,side*(reinforcement_height/2-reinforcement_thickness),0]) {
            rotate([0,0,135+45*side]) {
              round_corner_filler_profile(printed_carriage_inner_diam);
            }
          }
        }

        translate([reinforcement_thickness/2,-reinforcement_height/2+reinforcement_thickness,0]) {
          round_corner_filler_profile(printed_carriage_inner_diam);
        }
      }
    }

    translate([-arm_pos_x+printed_carriage_wall_thickness/2,x_rail_rel_pos_z]) {
      // x rail top/bottom clamp
      for(side=[top,bottom]) {
        translate([-x_rail_clamp_len/2,side*(extrusion_width/2+printed_carriage_wall_thickness/2)]) {
          rounded_square(x_rail_clamp_len,printed_carriage_wall_thickness,printed_carriage_wall_thickness,resolution);
        }

        translate([-printed_carriage_wall_thickness,side*extrusion_width/2,0]) {
          rotate([0,0,135+45*side]) {
            round_corner_filler_profile(x_rail_y_carriage_spacing/2,resolution/2);
          }
        }
      }
    }
  }

  module carriage_profile() {
    colors = ["red","blue"];
    arm_lengths = [extrusion_width+printed_carriage_extrusion_carriage_gap+printed_carriage_wall_thickness/2,extrusion_width+printed_carriage_wall_thickness*2];
    module profile_body() {
      // main plate
      translate([0,extrusion_height/2+printed_carriage_extrusion_carriage_gap+printed_carriage_wall_thickness/2,0]) {
        rounded_square(y_carriage_overall_width,printed_carriage_wall_thickness,printed_carriage_wall_thickness);
      }

      for(side=[0,1]) {
        color(colors[side]) mirror([side,0,0]) {
          translate([arm_pos_x-printed_carriage_wall_thickness/2,0,0]) {
            translate([0,extrusion_width+printed_carriage_extrusion_carriage_gap,0]) {
              rotate([0,0,-180]) {
                round_corner_filler_profile(printed_carriage_inner_diam);
              }
            }

            // retainer for bushings that keep carriage on the rail
            translate([0,extrusion_width/2,0]) {
              hull() {
                translate([-v_slot_width/2,0,0]) {
                  square([0.001,0.001],center=true);
                }
                translate([1,0,0]) {
                  square([2,v_slot_width],center=true);
                }
              }
            }
          }

          hull() {
            translate([arm_pos_x,extrusion_height/2+printed_carriage_extrusion_carriage_gap+printed_carriage_wall_thickness,0]) {
              translate([0,-arm_lengths[side]/2,0]) {
                rounded_square(printed_carriage_wall_thickness,arm_lengths[side],printed_carriage_wall_thickness);
              }
            }
          }
        }
      }
    }


    module profile_holes() {
      // rounded_square(y_carriage_opening_width,extrusion_height+printed_carriage_extrusion_carriage_gap*2,printed_carriage_inner_diam);
    }

    difference() {
      profile_body();
      profile_holes();
    }
  }

  module body() {
    rotate([90,0,0]) {
      linear_extrude(height=y_carriage_len,center=true,convexity=3) {
        carriage_profile();
      }
    }
    translate([0,y_carriage_len/2-x_rail_clamp_depth/2,0]) {
      rotate([90,0,0]) {
        linear_extrude(height=x_rail_clamp_depth,center=true,convexity=3) {
          clamp_profile();
        }
      }
    }

    translate([-arm_pos_x+printed_carriage_wall_thickness/2-x_rail_clamp_len/2,y_carriage_len/2,x_rail_rel_pos_z]) {
      // x rail rear anchor
      translate([0,-x_rail_dist_from_y_carriage_end/2,0]) {
        rotate([90,0,0]) {
          rounded_cube(x_rail_clamp_len,extrusion_width-2,x_rail_dist_from_y_carriage_end,printed_carriage_wall_thickness,resolution);
        }
      }
    }
  }

  module holes() {
    // x rail clamp holes
    translate([left*(extrusion_width/2+printed_carriage_extrusion_carriage_gap+x_rail_clamp_len/2+printed_carriage_wall_thickness/2),y_carriage_len/2,x_rail_rel_pos_z]) {
      // top/bottom
      for(side=[front,rear]) {
        translate([0,-x_rail_dist_from_y_carriage_end-extrusion_height/2+side*(extrusion_width/2),0]) {
          hole(5.2,extrusion_height,8);
        }
      }
      // rear
      rotate([90,0,0]) {
        hole(5.2,extrusion_height,8);
      }
    }

    // idler holes
    position_idlers() {
      translate([0,0,extrusion_height/2+printed_carriage_extrusion_carriage_gap]) {
        translate([0,0,30]) {
          hole(5.1,printed_carriage_wall_thickness*2+60,8);
        }
        hole(m5_bolt_head_diam,(4-printed_carriage_extrusion_carriage_gap)*2,8);
      }
    }

    bushing_from_edge_of_extrusion = ptfe_diam/2+1;
    for(y=[front,0,rear]) {
      translate([0,y*(y_carriage_len/2-x_carriage_bushing_len/2-printed_carriage_bushing_from_end),0]) {
        // side bushing holes
        for(x=[left,right]) {
          for(z=[0,extrusion_height/2-ptfe_diam/2]) {
            translate([x*(extrusion_width/2-ptfe_bushing_preload_amount+ptfe_diam/2),0,z]) {
              rotate([90,0,0]) {
                # hole(ptfe_diam,x_carriage_bushing_len,resolution);
              }
            }
          }
        }

        // top bushing holes
        for(x=[left,right]) {
          translate([x*(extrusion_width/2-bushing_from_edge_of_extrusion),0,extrusion_height/2+ptfe_diam/2-ptfe_bushing_preload_amount]) {
            rotate([90,0,0]) {
              if (y || x > 0) { // avoid interference with line idler bearing bolts
                # hole(ptfe_diam,x_carriage_bushing_len,resolution);
              }
            }
          }
        }

        // bushings to keep carriage from popping off
        for(side=[0,1]) {
          //for(z=[extrusion_height/4+v_slot_width/2-ptfe_diam/2-v_slot_depth/2+xy_dist_to_corner(ptfe_diam/2)]) {
          //  translate([x*(extrusion_width/2+ptfe_diam/2-v_slot_depth/2-xy_dist_to_corner(ptfe_diam/2)),0,z]) {
          mirror([side,0,0]) {
            for(z=[extrusion_height/4+v_slot_width/2-v_slot_depth/2]) {
              translate([extrusion_width/2-v_slot_depth/2,0,z]) {
                rotate([90,0,0]) {
                  rotate([0,0,45]) {
                    translate([0,-ptfe_diam/2,0]) {
                      # hole(ptfe_diam,x_carriage_bushing_len,resolution);
                    }
                  }
                }
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

  translate([extrusion_width+printed_carriage_outer_skin_from_extrusion*2+x_rail_clamp_len+1,0,0]) {
    translate([0,-y_carriage_len/2+1,0]) {
      rotate([90,0,0]) {
        carriage_profile();
        clamp_profile();
      }
    }

    translate([0,0,carriage_overall_height*1.5]) {
      carriage_profile();
      clamp_profile();
    }
  }
}


module x_carriage_assembly() {
  translate([0,0,-x_carriage_pos_z+x_rail_pos_z]) {
    x_carriage();
  }

  z_carriage_pos_z_at_min = -x_carriage_mounting_plate_height/2+z_rod_retainer_thickness+z_carriage_height/2;
  translate([0,front*(x_carriage_overall_depth/2+0.5),0]) {
    rotate([90,0,0]) {
      z_axis_mount();
    }

    // echo("from surface: ", z_axis_mount_thickness+z_rod_from_surface+z_rod_diam/2+1.8);

    translate([0,front*(z_axis_mount_thickness+z_rod_from_surface+z_rod_diam/2+1.5),z_carriage_pos_z_at_min+0]) {
      color("dodgerblue") z_carriage();
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
    for(x=[-10,-30]) {
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
  translate([0,front*(y_carriage_len/2-extrusion_height/2-x_rail_dist_from_y_carriage_end),0]) {
    y_carriage_printed();
  }

  /*
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
  */
}

module rear_idler_mount(side) {
  _outer_line_idler_pos_x = outer_line_idler_pos_x - y_rail_pos_x;
  _inner_line_idler_pos_x = inner_line_idler_pos_x - y_rail_pos_x;

  outer_line_idler_pos_y = rear_idler_pos_y(side)-y_rail_len/2;
  inner_line_idler_pos_y = rear_idler_pos_y(abs(1-side))-y_rail_len/2;

  coords = [
    [_outer_line_idler_pos_x,outer_line_idler_pos_y],
    [_inner_line_idler_pos_x,inner_line_idler_pos_y],
  ];

  idler_shaft_hole_for_threading = 4.8;

  gap_to_bearing = spacer;

  height_above_extrusion = belt_pos_z - line_bearing_thickness/2 - gap_to_bearing - extrusion_height;
  overall_height = extrusion_height+height_above_extrusion;
  overall_width = outer_line_idler_pos_x - inner_line_idler_pos_x + line_bearing_inner + extrude_width*6;

  body_pos_z = extrusion_height/2+height_above_extrusion/2;

  outer_line_idler_pos_z = rear_idler_pos_z(side,1);
  inner_line_idler_pos_z = body_pos_z + overall_height + gap_to_bearing;

  function idler_bevel_base_width(idler_pos_z) = ( idler_pos_z > inner_line_idler_pos_z)
                                               ? rear_idler_hole_body_diam
                                               : idler_shaft_hole_for_threading+extrude_width*4;

  module position_inner_idler_shaft() {
    translate([_inner_line_idler_pos_x,inner_line_idler_pos_y,0]) {
      children();
    }
  }

  module position_outer_idler_shaft() {
    translate([_outer_line_idler_pos_x,outer_line_idler_pos_y,0]) {
      children();
    }
  }

  module position_idler_shafts() {
    position_inner_idler_shaft() {
      children();
    }
    position_outer_idler_shaft() {
      children();
    }
  }

  module body() {
    hull() {
      for(z=[extrusion_height*0.25,extrusion_height*0.75]) {
        translate([0,rear_idler_mount_overall_depth/2,z]) {
          rotate([90,0,0]) {
            hole(rear_idler_hole_body_diam,rear_idler_mount_overall_depth,16);
          }
        }
      }

      translate([0,0,body_pos_z]) {
        translate([0,1,0]) {
          translate([_outer_line_idler_pos_x,0,0]) {
            cube([rear_idler_hole_body_diam,2,overall_height],center=true);
          }
          translate([_inner_line_idler_pos_x,0,0]) {
            cube([rear_idler_hole_body_diam,2,overall_height],center=true);
          }
          cube([extrusion_width,2,overall_height],center=true);
        }
        for (coord=coords) {
          translate(coord) {
            hole(rear_idler_hole_body_diam,overall_height,16);
          }
        }

      }
    }
    position_inner_idler_shaft() {
      hull() {
        translate([0,0,body_pos_z+overall_height/2]) {
          hole(idler_shaft_hole_for_threading+(extrude_width*2)*2,gap_to_bearing*2,16);

          translate([0,0,-gap_to_bearing*2-overall_height/4]) {
            hole(rear_idler_hole_body_diam,2+overall_height/2,16);
          }
        }
      }
    }
    position_outer_idler_shaft() {
      hull() {
        translate([0,0,outer_line_idler_pos_z-line_bearing_thickness/2-1]) {
          hole(idler_shaft_hole_for_threading+(extrude_width*2)*2,2,16);

          translate([0,0,-gap_to_bearing*2-overall_height/4]) {
            hole(rear_idler_hole_body_diam,2+overall_height/2,16);
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

    position_idler_shafts() {
      translate([0,0,body_pos_z]) {
        hole(idler_shaft_hole_for_threading,extrusion_height*3,16);
      }
    }
  }

  difference() {
    body();
    holes();
  }
}

// likely needs to be different between line/belt :(
module motor_mount() {
  thickness = extrude_width*12;
  motor_tolerance = 0.1;
  overall_width = motor_side+(motor_tolerance+thickness)*2;
  overall_depth = motor_side+(motor_tolerance+thickness)*2;

  motor_cavity_side = motor_side + motor_tolerance*2;

  rail_pos_x = y_rail_pos_x - abs(motor_pos_x);
  rail_pos_y = abs(motor_pos_y) - y_rail_len/2;
  rail_pos_z = y_rail_pos_z - motor_pos_z;

  space_between_motor_and_extrusion = rail_pos_y - motor_side/2;
  // echo("RAIL POS Y", rail_pos_y);
  // echo("motor side", motor_side);
  // echo("space_between_motor_and_extrusion", space_between_motor_and_extrusion);

  module position_at_rail() {
    translate([rail_pos_x,rail_pos_y,rail_pos_z]) {
      children();
    }
  }

  module body() {
    hull() {
      position_at_rail() {
        translate([0,-space_between_motor_and_extrusion,0]) {
          cube([extrusion_width,space_between_motor_and_extrusion*2,extrusion_height],center=true);
        }
      }
      for(z=[-motor_pos_z+1,thickness-1]) {
        translate([0,0,z]) {
          cube([overall_width,overall_depth,2],center=true);
        }
      }
    }
  }

  module holes() {
    // motor shoulder
    hole(motor_shoulder_diam+2,motor_len*3,8);

    // motor mounting holes
    for(x=[left,right]) {
      for(y=[front,rear]) {
        translate([x*(motor_hole_spacing/2),y*(motor_hole_spacing/2),0]) {
          hole(m3_bolt_diam,motor_len*3,8);
        }
      }
    }

    // motor cavity
    translate([0,0,-motor_len]) {
      cube([motor_cavity_side,motor_cavity_side,motor_len*2],center=true);
    }

    // extrusion bolts
    position_at_rail() {
      for(z=[top,bottom]) {
        translate([0,-space_between_motor_and_extrusion,z*(extrusion_width/2)]) {
          rotate([90,0,0]) {
            hole(m5_bolt_diam,100,8);
            hole(m5_bolt_head_diam,m5_bolt_head_height*2,8);
          }
        }
      }
    }

    // make printable at an angle
    translate([0,-overall_depth/2-1,thickness]) {
      rotate([-45,0,0]) {
        translate([0,overall_depth,-motor_len]) {
          cube([overall_width*2,overall_depth*2,motor_len*2],center=true);
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

colors = ["red", "blue"];
module line_path(side=0) {
  // belt path
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

    //translate([inner_line_idler_pos_x,-x_carriage_belt_spacing/2-line_bearing_diam/2-line_thickness/2,belt_pos_z]) {
    translate([inner_line_idler_pos_x,-x_carriage_idler_spacing/2,belt_pos_z]) {
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
          color("silver") extrusion(y_rail_len);
        }
      }

      line_path(side);

      translate([y_carriage_pos_x,0,y_carriage_pos_z]) {
        y_carriage_assembly();
      }

      translate([y_rail_pos_x,y_rail_len/2+0.1,0]) {
        rear_idler_mount(side);
      }

      translate([motor_pos_x,motor_pos_y,motor_pos_z]) {
        motor_mount();
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
  /*
  */

  translate([0,0,-base_plate_thickness/2]) {
    % color("lightgrey") {
      linear_extrude(height=base_plate_thickness,center=true,convexity=2) {
        base_plate();
      }
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
  cable_distance_from_face = 1.75;
  cable_diam    = 1;
  num_cables    = 5;
  cable_pos_x   = [-2.4,-1.2,0,1.2,2.4];
  cable_colors  = ["yellow","orange","red","pink","royalblue"];
  cable_spacing = 1.2;
  cable_sample_len = 5;
  cable_opening_width = 7.3;

  resolution = 32;

  module position_at_flange_centers() {
    for(side=[left,right]) {
      translate([side*(z_stepper_flange_hole_spacing/2),0,0]) {
        children();
      }
    }
  }

  color("lightgrey") {
    // main body
    translate([0,0,-z_stepper_height/2]) {
      hole(z_stepper_diam,z_stepper_height,resolution*1.25);
    }

    // flanges
    translate([0,0,-z_stepper_flange_thickness/2]) {
      linear_extrude(height=z_stepper_flange_thickness,center=true,convexity=3) {
        difference() {
          hull() {
            position_at_flange_centers() {
              accurate_circle(z_stepper_flange_diam,resolution/2);
            }
          }
          position_at_flange_centers() {
            accurate_circle(z_stepper_flange_hole_diam,resolution/2);
          }
        }
      }
    }

    // shaft base
    translate([0,-z_stepper_shaft_from_center,0]) {
      hole(z_stepper_shaft_base_diam,z_stepper_shaft_base_height*2,resolution);
    }
  }

  // shaft
  color("gold") {
    translate([0,-z_stepper_shaft_from_center,0]) {
      rotate([0,0,z_cam_angle]) {
        difference() {
          hole(z_stepper_shaft_diam,(z_stepper_shaft_length+z_stepper_shaft_base_height)*2,resolution);

          translate([0,0,z_stepper_shaft_base_height+z_stepper_shaft_length]) {
            for(x=[left,right]) {
              translate([x*z_stepper_shaft_diam/2,0,0]) {
                cube([z_stepper_shaft_flat_cut_depth*2,z_stepper_shaft_diam,z_stepper_shaft_flat_length*2],center=true);
              }
            }
          }
        }
      }
    }
  }

  // hump
  translate([0,z_stepper_diam/2,-z_stepper_hump_height/2-0.05]) {
    color("dodgerblue") {
      difference() {
        cube([z_stepper_hump_width,z_stepper_hump_depth*2,z_stepper_hump_height],center=true);

        translate([0,z_stepper_hump_depth,z_stepper_hump_height/2-cable_distance_from_face-cable_diam/2]) {
          rotate([90,0,0]) {
            hull() {
              for(x=[left,right]) {
                translate([x*(cable_opening_width/2-cable_diam/2),0,0]) {
                  hole(cable_diam+0.1,8,10);
                }
              }
            }
          }
        }
      }
    }
  }

  // hump cables
  translate([0,z_stepper_diam/2+z_stepper_hump_depth,-cable_distance_from_face-cable_diam/2]) {
    rotate([90,0,0]) {
      for(c=[0:num_cables-1]) {
        translate([cable_pos_x[c],0,0]) {
          color(cable_colors[c]) {
            hole(cable_diam,cable_sample_len*2,8);
          }
        }
      }
    }
  }
}

module z_axis_cam() {
  tolerance = 0.1;

  clamp_screw_pos_x = left*(z_stepper_shaft_diam/2+m3_diam/2);
  clamp_body_width = extrude_width*6*2+m3_nut_diam;
  clamp_gap_width = 1;

  rounded_shaft_height = max((z_cam_thickness - z_stepper_shaft_flat_length + 0.5), 0);

  module body() {
    linear_extrude(height=z_cam_thickness,center=true,convexity=3) {
      difference() {
        hull() {
          accurate_circle(z_cam_diam,16);

          translate([clamp_screw_pos_x,0,0]) {
            square([clamp_body_width,z_cam_diam],center=true);
          }
        }
        // shaft with flat
        intersection() {
          accurate_circle(z_stepper_shaft_diam+tolerance,resolution);
          square([10,z_stepper_shaft_flat_thickness+tolerance],center=true);
        }

        // clamp gap
        translate([clamp_screw_pos_x,0,0]) {
          square([clamp_body_width+1,clamp_gap_width],center=true);
        }
      }
    }
  }

  module holes() {
    translate([clamp_screw_pos_x,0,0]) {
      // clamp screw
      translate([0,z_cam_diam/2,0]) {
        rotate([90,0,0]) {
          rotate([0,0,90]) {
            hole(3.1,z_cam_diam*2+1,8);
          }
        }
      }
    }

    // clearance for non-flat shaft portion
    translate([0,0,z_cam_thickness/2]) {
      hole(z_stepper_shaft_diam+tolerance,rounded_shaft_height*2,resolution);
    }
  }

  translate([0,0,0]) {
    difference() {
      body();
      holes();
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

  plate_thickness = z_axis_mount_thickness;

  z_rod_retainer_height    = z_rod_from_surface + z_rod_diam/2 + 2;
  z_rod_bottom_pos_z       = -x_carriage_mounting_plate_height/2 + z_rod_retainer_thickness/2;
  long_rod_pos_z = z_rod_bottom_pos_z + long_rod_length/2;
  short_rod_pos_z = z_rod_bottom_pos_z + short_rod_length/2;

  rod_to_side = x_carriage_width-(z_rod_pos_x*2);

  rod_tolerance = 0.5;

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
    translate([4,x_carriage_mounting_plate_height/2+z_stepper_diam/2+2,plate_thickness]) {
      rotate([0,0,z_motor_angle]) {
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
    //cam_thickness = 8.1;
    //cam_diam      = 12;
    translate([0,0,z_stepper_flange_thickness+0.1]) {
      % stepper28BYJ();

      // translate([0,-8,cam_thickness/2+2]) {
      //   hole(cam_diam,cam_thickness,16);
      // }
      translate([0,-8,3+z_cam_thickness/2]) {
        rotate([0,0,90+z_cam_angle]) {
          rotate([180,0,0]) {
            % color("dodgerblue") z_axis_cam();
          }
        }
      }
    }
  }

  module position_rod_post_tops() {
    coords = [
      [left*z_rod_pos_x,long_rod_pos_z+long_rod_length/2,0],
      [right*z_rod_pos_x,short_rod_pos_z+short_rod_length/2,0],
    ];
    translate([0,-zip_tie_width/2+rod_tolerance,0]) {
      for(coord=coords) {
        translate(coord) {
          children();
        }
      }
    }
  }

  module position_rod_post_bottoms() {
    for(x=[left,right]) {
      translate([x*z_rod_pos_x,z_rod_bottom_pos_z,0]) {
        children();
      }
    }
  }

  module position_rod_posts() {
    position_rod_post_tops() {
      children();
    }
    position_rod_post_bottoms() {
      children();
    }
  }

  module position_mounting_holes() {
    for(x=[left,right]) {
      for(z=[top,bottom]) {
        translate([x*(x_carriage_mounting_plate_hole_spacing_x/2),z*(x_carriage_mounting_plate_hole_spacing_z/2)]) {
          children();
        }
      }
    }
  }

  module body() {
    translate([0,0,plate_thickness/2]) {
      linear_extrude(height=plate_thickness,center=true,convexity=3) {
        difference() {
          hull() {
            position_rod_posts() {
              rounded_square(rod_to_side,z_rod_retainer_thickness,rounded_diam);
            }
            position_motor() {
              for(x=[left,right]) {
                translate([x*(z_stepper_flange_hole_spacing/2),0,0]) {
                  accurate_circle(z_stepper_flange_diam,16);
                }
              }
            }
          }

          // motor mounting holes
          position_motor() {
            accurate_circle(z_stepper_diam+0.25,30,resolution);
            for(x=[left,right]) {
              translate([x*(z_stepper_flange_hole_spacing/2),0,0]) {
                accurate_circle(m3_diam,8);

                difference() {
                  translate([x*(-z_stepper_flange_diam/2),z_stepper_flange_diam/2,0]) {
                    square([z_stepper_flange_diam,z_stepper_flange_diam],center=true);
                  }
                  accurate_circle(z_stepper_flange_diam,8);
                }
              }
            }
          }

          // z axis mounting holes for x carriage
          position_mounting_holes() {
            accurate_circle(m3_diam,8);
          }
        }
      }
    }
    position_rod_posts() {
      translate([0,0,plate_thickness+z_rod_retainer_height/2]) {
        rounded_cube(rod_to_side,z_rod_retainer_thickness,z_rod_retainer_height,rounded_diam,resolution);
      }
    }
  }

  module holes() {
    // mounting holes
    translate([0,0,plate_thickness]) {
      position_mounting_holes() {
        hole(7,2.5*2,8);
      }
    }

    hole(x_carriage_mounting_plate_hole_spacing_z*0.7,plate_thickness*2+1,resolution);

    module zip_tie_cavity() {
      translate([0,0,0]) {
        for(x=[left,right]) {
          translate([x*(z_rod_diam/2+zip_tie_thickness/2-0.1),0,0]) {
            cube([zip_tie_thickness,zip_tie_width,50],center=true);
          }
        }

        // clear area around z rod
        translate([0,0,0]) {
          cube([z_rod_diam+1,zip_tie_width,z_rod_diam],center=true);
        }

        // backside room for zip tie
        translate([0,0,-z_rod_from_surface-plate_thickness]) {
          cube([z_rod_diam,zip_tie_width,zip_tie_thickness*2],center=true);
        }

        // make access for z rod
        translate([0,0,z_rod_diam/4+5]) {
          cube([rod_to_side+1,z_rod_retainer_thickness+1,10],center=true);
        }
      }
    }

    // be able to see rod fitment at bottom
    position_rod_post_bottoms() {
      translate([0,0,plate_thickness+z_rod_from_surface+5.5]) {
        //cube([20,20,10],center=true);
      }
    }
    position_rod_post_tops() {
      translate([0,0,plate_thickness+z_rod_from_surface]) {
        zip_tie_cavity();
      }
    }

    // rod cavities
    translate([0,0,plate_thickness+z_rod_from_surface+rod_tolerance/2]) {
      translate([left*z_rod_pos_x,long_rod_pos_z,0]) {
        cube([z_rod_diam+rod_tolerance,long_rod_length,z_rod_diam+rod_tolerance],center=true);
      }
      translate([right*z_rod_pos_x,short_rod_pos_z,0]) {
        cube([z_rod_diam+rod_tolerance,short_rod_length,z_rod_diam+rod_tolerance],center=true);
        cube([short_rod_small_diam+rod_tolerance*2,short_rod_length*2,short_rod_small_diam+rod_tolerance*2],center=true);
      }
    }
  }

  difference() {
    body();
    holes();
  }
}

module z_carriage() {
  x_dist_from_left_rod = 17.5;
  hole_spacing_z = 7.5;
  hole_spacing_x = 10;
  hole_to_bottom = 9.5;
  // 10mm from left
  // 20mm from right
  // ~10mm in width

  max_pen_diam = 9;
  min_pen_diam = 6;

  rounded_diam = 4;
  plate_thickness = 6;

  pen_mount_body_diam = max_pen_diam+2*(extrude_width*4);
  pen_mount_connector_width = 7;
  pen_pos_x = z_rod_pos_x/2;
  pen_pos_x = pen_mount_body_diam/2-1;
  pen_pos_y = front*(plate_thickness*2+max_pen_diam/2);
  pen_pos_y = front*(plate_thickness+2+max_pen_diam/2);
  pen_clamp_gap_width = 4;
  pen_clamp_thickness = extrude_width*8;
  pen_clamp_depth = extrude_width*4+m3_nut_diam+extrude_width*4;

  module body() {
    linear_extrude(height=z_carriage_height,center=true,convexity=4) {
      translate([0,front*plate_thickness/2,0]) {
        rounded_square(z_carriage_width,plate_thickness,rounded_diam);
      }

      difference() {
        // pen mount main body
        union() {
          translate([pen_pos_x,0,0]) {
            translate([0,pen_pos_y/2,0]) {
              square([pen_mount_connector_width,abs(pen_pos_y)],center=true);
            }
            translate([0,pen_pos_y,0]) {
              accurate_circle(pen_mount_body_diam,20);

              for(x=[left,right]) {
                translate([x*(pen_clamp_gap_width/2+pen_clamp_thickness/2),front*(max_pen_diam/2+pen_clamp_depth/2-3),0]) {
                  rounded_square(pen_clamp_thickness,pen_clamp_depth+6,1.5,16);
                }
              }
            }
            for(x=[left,right]) {
              translate([x*(pen_mount_connector_width/2),front*(plate_thickness),0]) {
                rotate([0,0,-135+x*45]) {
                  round_corner_filler_profile(rounded_diam,16);
                }
              }
            }
          }
        }

        translate([pen_pos_x,pen_pos_y,0]) {
          accurate_circle(max_pen_diam,20);

          translate([0,front*(pen_mount_body_diam)]) {
            square([pen_clamp_gap_width,pen_mount_body_diam*2],center=true);
          }
        }

        // gap and flexion area
      }
    }
  }

  translate([pen_pos_x,pen_pos_y,0]) {
    // % hole(max_pen_diam,z_carriage_height*1.5,resolution);
  }

  module holes() {
    translate([-z_rod_pos_x+x_dist_from_left_rod,front*(plate_thickness),-z_carriage_height/2+hole_to_bottom]) {
      for(z=[top,bottom]) {
        translate([0,0,z*(hole_spacing_z/2)]) {
          rotate([90,0,0]) {
            rotate([0,0,90]) {
              hole(m3_diam,90,6);
              hole(m3_nut_diam,4,6);
            }
          }
        }
      }

      translate([-hole_spacing_x,0,0]) {
        rotate([90,0,0]) {
          rotate([0,0,90]) {
            hole(m3_diam,90,6);
            hole(m3_nut_diam,4,6);
          }
        }
      }
    }

    translate([pen_pos_x+left*(pen_clamp_gap_width/2+pen_clamp_thickness),pen_pos_y+front*(max_pen_diam/2+pen_clamp_depth/2-1),0]) {
      rotate([0,90,0]) {
        hole(m3_diam,90,6);
        hole(m3_nut_diam,2,6);
      }
    }
  }

  difference() {
    body();
    holes();
  }
}

module space_along_length(length,min_hole_spacing=4*inch,from_end=1*inch) {
  avail_length = length - (from_end*2);
  num_spaces   = floor(avail_length / min_hole_spacing);
  extra_space  = (avail_length - (num_spaces*min_hole_spacing)) / num_spaces;
  spacing      = min_hole_spacing + extra_space;

  // echo(length, num_spaces, spacing);

  translate([0,-length/2+from_end,0]) {
    for(y=[0:num_spaces]) {
      translate([0,y*spacing,0]) {
        children();
      }
    }
  }
}

module base_plate() {
  room_for_electronics = 3*inch;
  room_for_motors      = motor_side + motor_mount_thickness*2 + 10;
  room_for_idlers      = rear_idler_mount_overall_depth + 10;
  overall_width = y_rail_pos_x*2 + extrusion_width + motor_side*2;
  overall_width = (motor_pos_x+motor_side/2+10)*2 + room_for_electronics;
  overall_depth = y_rail_len + motor_mount_thickness + motor_side;
  overall_depth = y_rail_len + room_for_motors + room_for_idlers;

  echo("BOM Base plate width: ", overall_width/25.4);
  echo("BOM Base plate depth: ", overall_depth/25.4);

  module body() {
    translate([-room_for_electronics/2,room_for_idlers/2-room_for_motors/2,0]) {
      square([overall_width,overall_depth],center=true);
      //rounded_square(overall_width,overall_depth,10);
    }
  }

  module holes() {
    for(side=[left,right]) {
      translate([side*y_rail_pos_x,0,0]) {
        space_along_length(y_rail_len,4*inch) {
          accurate_circle(5.25,resolution);
        }
      }
    }
  }

  difference() {
    body();
    holes();
  }
}

translate([0,0,-1]) {
  // % cube([print_width,y_rail_len,2],center=true);
}
