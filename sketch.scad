include <config.scad>;
include <util.scad>;

// YAGNI (TODO):
//   * get retentive about line positions by taking line thickness into account

// x carriage is a piece of wood/metal riding on bearings
// base plate is a piece of plywood
// could also use conduit?

inch = 25.4;

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

extrusion_width = 20;
extrusion_height = 40;

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

rear_idler_pos_y = print_depth/2+8;
rear_idler_line_gap = 4;

line_height            = 6;

line_bearing_diam      = 10;
line_bearing_thickness = 8;
line_bearing_inner     = 5;

line_pulley_diam = (16*2)/approx_pi;
line_pulley_diam = (20*2)/approx_pi;
line_pulley_height = 10;

y_rail_pos_x = print_width/2-extrusion_width/2;
y_rail_pos_z = extrusion_height/2;

x_rail_len = print_width - extrusion_width*2 - 5;
motor_pos_x = y_rail_pos_x+extrusion_width/4;
motor_pos_y = -print_depth/2-nema17_side/2;
y_carriage_pos_x = y_rail_pos_x;
y_carriage_pos_z = y_rail_pos_z + extrusion_height/2 + extrusion_wheel_gap + plate_thickness/2;
x_rail_pos_z     = y_carriage_pos_z - plate_thickness/2 - extrusion_width/2;
belt_pos_z  = y_carriage_pos_z + plate_thickness/2 + spacer + line_bearing_thickness/2;

motor_pos_z = y_rail_pos_z + extrusion_height/2;

x_carriage_pos_z = y_carriage_pos_z + extrusion_wheel_gap;

x_carriage_belt_spacing = 5;

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
    opening_behind_slot = 1.64;
    opening_behind_slot_width = v_slot_gap+(groove_depth-opening_behind_slot-v_slot_depth)*2;

    for(side=[left,right]) {
      translate([side*v_slot_depth,0,0]) {
        hull() {
          translate([side*(groove_depth-v_slot_depth)/2,0,0]) {
            square([groove_depth-v_slot_depth,v_slot_gap],center=true);
          }
          translate([side*opening_behind_slot/2,0,0]) {
            square([opening_behind_slot,opening_behind_slot_width],center=true);
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

y_carriage_depth = extrusion_width*2+20+wheel_diam;

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
    translate([(motor_pos_x-y_rail_pos_x)-line_pulley_diam/2-line_bearing_diam/2,front*(line_bearing_diam/2+x_carriage_belt_spacing/2),0]) {
      accurate_circle(4.2,resolution);
    }
    // rear
    translate([(motor_pos_x-y_rail_pos_x)-line_bearing_diam,rear*(line_bearing_diam/2+x_carriage_belt_spacing/2),0]) {
      accurate_circle(4.2,resolution);
    }
  }

  difference() {
    body();
    holes();
  }
}

module rear_idler_mount(side) {
  motor_idler_pos_x = motor_pos_x - y_rail_pos_x;
  non_motor_idler_pos_x = (motor_pos_x - line_bearing_diam) - y_rail_pos_x;

  height_above_extrusion = belt_pos_z - line_bearing_thickness/2 - spacer - extrusion_height;

  module body() {
    translate([0,extrusion_width/2,-extrusion_height/2]) {
      cube([extrusion_width,extrusion_width,extrusion_height+height_above_extrusion],center=true);
    }
  }

  module holes() {
    // extrusion bolt holes
    for(z=[extrusion_height*0.25,extrusion_height*0.75]) {
      translate([0,0,z]) {
        rotate([90,0,0]) {
          hole(5,extrusion_height*2,8);
        }
      }
    }

    // idler shafts
    translate([motor_idler_pos_x,rear_idler_pos_y-print_depth/2,extrusion_height/2]) {
      # hole(4.8,extrusion_height*3,16);
    }

    translate([non_motor_idler_pos_x,rear_idler_pos_y-print_depth/2+rear_idler_line_gap,extrusion_height/2]) {
      # hole(4.8,extrusion_height*3,16);
    }
  }

  mirror([side,0,0]) {
    difference() {
      translate([0,0,extrusion_height+height_above_extrusion/2]) {
        body();
      }
      holes();
    }
  }
}

translate([0,0,10]) {
  //color("red") extrusion(10);
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

    // belt path
    colors = ["lightgreen", "pink"];
    % color(colors[side], 0.5) {
      // x carriage to motor side y carriage
      hull() {
        translate([0,-x_carriage_belt_spacing/2,belt_pos_z]) {
          translate([motor_pos_x-line_pulley_diam/2-line_bearing_diam/2,0,0]) {
            // y carriage
            cube([1,1,line_height],center=true);
          }
          // x carriage
          translate([4,0,0]) {
            cube([1,1,line_height],center=true);
          }
        }
      }

      translate([motor_pos_x-line_pulley_diam/2-line_bearing_diam/2,-x_carriage_belt_spacing/2-line_bearing_diam/2,belt_pos_z]) {
        difference() {
          hole(line_bearing_diam,line_bearing_thickness,resolution);
          hole(line_bearing_inner,line_bearing_thickness+1,resolution);
        }
      }

      // y carriage to motor
      hull() {
        translate([motor_pos_x-line_pulley_diam/2,0,belt_pos_z]) {
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
        translate([motor_pos_x+line_bearing_diam/2,rear_idler_pos_y+(rear_idler_line_gap*side),belt_pos_z+line_bearing_thickness+1]) {
          cube([1,1,line_height],center=true);
        }
      }

      translate([motor_pos_x,rear_idler_pos_y+(rear_idler_line_gap*side),belt_pos_z+line_bearing_thickness+1]) {
        difference() {
          hole(line_bearing_diam,line_bearing_thickness,resolution);
          hole(line_bearing_inner,line_bearing_thickness+1,resolution);
        }
      }
      /*
      hull() {
        translate([motor_pos_x+line_pulley_diam/2,motor_pos_y,belt_pos_z]) {
          cube([1,1,line_height],center=true);
        }
        translate([motor_pos_x+rear_line_bearing_od/2,rear_idler_pos_y+(rear_idler_line_gap*side),belt_pos_z+rear_line_bearing_thickness+1]) {
          cube([1,1,line_height],center=true);
        }
      }

      translate([motor_pos_x,rear_idler_pos_y+(rear_idler_line_gap*side),belt_pos_z+line_bearing_thickness+1]) {
        hole(rear_line_bearing_od,rear_line_bearing_thickness,resolution);
      }
      */

      // rear across
      hull() {
        translate([motor_pos_x,rear_idler_pos_y+(rear_idler_line_gap*side)+line_bearing_diam/2,belt_pos_z+line_bearing_thickness+1]) {
          cube([1,1,line_height],center=true);
        }
        translate([-motor_pos_x+line_pulley_diam/2+line_bearing_diam/2,rear_idler_pos_y+(rear_idler_line_gap*side)+line_bearing_diam/2,belt_pos_z]) {
          cube([1,1,line_height],center=true);
        }
      }

      translate([left*(motor_pos_x-line_bearing_diam/2-line_bearing_diam/2),rear_idler_pos_y+(rear_idler_line_gap*side),belt_pos_z]) {
        difference() {
          hole(line_bearing_diam,line_bearing_thickness,resolution);
          hole(line_bearing_inner,line_bearing_thickness+1,resolution);
        }
      }

      // rear to non-motor-side y carriage
      hull() {
        translate([left*(motor_pos_x-line_bearing_diam/2),0,belt_pos_z]) {
          // motor side
          translate([0,rear_idler_pos_y+(rear_idler_line_gap*side),0]) {
            cube([1,1,line_height],center=true);
          }
          // y carriage
          translate([0,rear*(x_carriage_belt_spacing/2+line_bearing_diam/2),0]) {
            cube([1,1,line_height],center=true);
          }
        }
      }

      translate([left*(motor_pos_x-line_bearing_diam/2-line_bearing_diam/2),rear*(x_carriage_belt_spacing/2+line_bearing_diam/2),belt_pos_z]) {
        difference() {
          hole(line_bearing_diam,line_bearing_thickness,resolution);
          hole(line_bearing_inner,line_bearing_thickness+1,resolution);
        }
      }

      // non-motor-side y carriage to x carriage
      hull() {
        translate([0,rear*(x_carriage_belt_spacing/2),belt_pos_z]) {
          translate([left*(motor_pos_x-line_pulley_diam/2-line_bearing_diam/2),0,0]) {
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

    // y carriage + wheels
    translate([y_carriage_pos_x,0,y_carriage_pos_z]) {
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

    // x carriage + wheels
    translate([0,0,x_carriage_pos_z]) {
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
    }

    // rear idler mount
    translate([y_rail_pos_x,print_depth/2+0.1,0]) {
      rear_idler_mount(side);
    }

    translate([motor_pos_x,motor_pos_y,motor_pos_z]) {
      color("grey", 0.8) motor_nema17();
    }
  }
}

translate([0,0,x_rail_pos_z]) {
  rotate([0,90,0]) {
      color("silver") extrusion(x_rail_len);
  }
}

translate([0,0,-1]) {
  // % cube([print_width,print_depth,2],center=true);
}
