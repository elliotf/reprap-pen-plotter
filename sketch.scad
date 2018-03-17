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
print_width = 8*inch;
print_depth = 11*inch;

extrusion_width = 20;
extrusion_height = 40;

plate_thickness = 1/4*inch;
extrusion_wheel_gap = 2;

wheel_screw_diam = 5;
plate_min_material = 5;

y_carriage_plate_width = extrusion_height+2*(wheel_screw_diam/2+plate_min_material);

module motor() {
  difference() {
    translate([0,0,-motor_len/2]) cube([motor_side,motor_side,motor_len],center=true);
    for(end=[left,right]) {
      for(side=[front,rear]) {
        translate([motor_hole_spacing/2*side,motor_hole_spacing/2*end,0]) cylinder(r=motor_screw_diam/2,h=100,center=true);
      }
    }
  }

  translate([0,0,motor_shaft_len/2]) {
    hole(motor_shaft_diam,motor_shaft_len,16);
    hole(z_pulley_diam,z_pulley_height,16);
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

module y_carriage_plate() {
  square([extrusion_height+20,extrusion_height+20],center=true);
}

translate([0,0,10]) {
  //color("red") extrusion(10);
}

motor_pos_x = print_width/2-motor_side/2;
motor_pos_y = -print_depth/2-motor_side/2;
y_carriage_pos_z = extrusion_width + extrusion_wheel_gap + plate_thickness/2;
belt_pos_z  = y_carriage_pos_z + plate_thickness/2 + spacer + z_line_bearing_thickness/2;

for(side=[left,right]) {
  mirror([1-side,0,0]) {
    translate([print_width/2-extrusion_height/2,0,0]) {
      translate([0,0,extrusion_width/2]) {
        rotate([90,0,0]) {
          rotate([0,0,90]) {
            color("silver") extrusion(print_depth);
          }
        }
      }
    }

    % hull() {
      translate([motor_pos_x+z_pulley_diam/2,0,belt_pos_z]) {
        translate([0,motor_pos_y,0]) {
          cube([1,1,6],center=true);
        }
        translate([0,-motor_pos_y,0]) {
          cube([1,1,6],center=true);
        }
      }
    }

    translate([print_width/2-y_carriage_plate_width/2+wheel_screw_diam/2+plate_min_material,0,y_carriage_pos_z]) {
      linear_extrude(height=plate_thickness,center=true,convexity=2) {
        y_carriage_plate();
      }
    }

    translate([motor_pos_x,motor_pos_y,extrusion_width+extrusion_wheel_gap+plate_thickness/2]) {
      % motor();
    }
  }
}

translate([0,0,extrusion_width + extrusion_wheel_gap + plate_thickness + extrusion_height/2]) {
  rotate([0,90,0]) {
    rotate([0,0,90]) {
      color("silver") extrusion(print_width-motor_side);
    }
  }
}

translate([0,0,-1]) {
  % cube([print_width,print_depth,2],center=true);
}
