include <config.scad>;
include <lib/util.scad>;
use <lib/vitamins.scad>;

function y_spacing_for_side(side) = (side+1)*2;
function overall_depth_for_side(side) = 2+line_bearing_diam+y_spacing_for_side(side);

max_y_spacing = y_spacing_for_side(right);
plate_pos_z = -20-y_rail_dist_above_plate;
colors = ["crimson", "green", "royalblue"];

relative_x_line_pos_x = x_line_pos_x - y_rail_pos_x;

body_width = 5.2+printed_carriage_wall_thickness*2;

allot_space_y_for_rear_idler = overall_depth_for_side(right) + plate_anchor_diam*2;

module position_rear_idler_anchor_holes(pos_z=0) {
  diam = plate_anchor_diam;
  translate([body_width/2+diam/2,diam/2,pos_z]) {
    children();
  }
  translate([relative_x_line_pos_x-line_bearing_diam/2-diam,diam/2,pos_z]) {
    children();
  }
  translate([0,overall_depth_for_side(right)+diam/2,pos_z]) {
    children();
  }
}

module rear_idler_mount(side) {
  overall_depth = overall_depth_for_side(side);
  line_color = colors[side+1];
  opposite_line_color = colors[-side+1];

  overall_height = abs(plate_pos_z)+15;

  relative_motor_line_pos_x = motor_line_pos_x - y_rail_pos_x;

  y_spacing = y_spacing_for_side(side);
  other_y_spacing = (-side+1)*3;
  motor_line_pos_y = 1+line_bearing_diam/2+y_spacing;
  x_line_pos_y = 1+line_bearing_diam/2;


  relative_x_line_pos_z = x_line_pos_z+(plate_pos_z);
  relative_motor_line_pos_z = motor_line_pos_z+(plate_pos_z);

  dist_from_line_to_line_z = abs(relative_x_line_pos_z - relative_motor_line_pos_z);
  dist_from_line_to_line_x = abs(relative_x_line_pos_x+y_rail_pos_x + relative_motor_line_pos_x+ y_rail_pos_x);

  angular_distance = sqrt(pow(dist_from_line_to_line_x,2)+pow(dist_from_line_to_line_z,2));
  y_line_angle = atan2(dist_from_line_to_line_z,dist_from_line_to_line_x);
  z_line_angle = atan2(y_spacing,dist_from_line_to_line_x);
  other_z_line_angle = atan2(other_y_spacing,dist_from_line_to_line_x);

  line_bearing_screw_hole_diam = 4.8;

  module position_xy_bearing() {
    translate([relative_x_line_pos_x,x_line_pos_y,relative_x_line_pos_z]) {
      rotate([0,0,-other_z_line_angle]) {
        rotate([0,-y_line_angle,0]) {
          translate([-line_bearing_diam/2,0,0]) {
            children();
          }
        }
      }
    }
  }

  module position_motor_bearing() {
    translate([relative_motor_line_pos_x,motor_line_pos_y,relative_motor_line_pos_z]) {
      rotate([0,0,z_line_angle]) {
        rotate([0,y_line_angle,0]) {
          translate([-line_bearing_diam/2,0,0]) {
            children();
          }
        }
      }
    }
  }

  module bearing_bevel(angle) {
    small_diam = line_bearing_screw_hole_diam+wall_thickness;
    large_diam = line_bearing_screw_hole_diam+wall_thickness*4;

    rotate([0,0,angle]) {
      translate([0,0,-line_bearing_thickness/2-bearing_bevel_height*1.5]) {
        difference() {
          hull() {
            hole(small_diam,bearing_bevel_height*3,resolution);
            hole(large_diam,bearing_bevel_height,resolution);
          }
          hole(line_bearing_screw_hole_diam,200,8);
        }
      }
    }
  }

  module main_body() {
    translate([0,overall_depth/2,plate_pos_z+overall_height/2]) {
      rounded_cube(body_width,overall_depth,overall_height,printed_carriage_inner_diam,resolution);
    }
  }

  module body() {
    hull() {
      main_body();
    }

    hull() {
      translate([0,overall_depth/2,plate_pos_z+wall_thickness]) {
        rounded_cube(body_width,overall_depth,wall_thickness*2,printed_carriage_inner_diam,resolution);
      }
      position_rear_idler_anchor_holes(plate_pos_z+plate_anchor_thickness/2) {
        hole(plate_anchor_diam,plate_anchor_thickness,resolution);
      }
    }

    hull() {
      main_body();
      position_xy_bearing() {
        height = relative_x_line_pos_z + 20 + y_rail_dist_above_plate + 0;
        translate([0,0,-line_bearing_thickness/2-bearing_bevel_height-height/2]) {
          rotate([0,0,other_z_line_angle]) {
            hole(line_bearing_screw_hole_diam+wall_thickness*4,height,resolution);
          }
        }
      }
      position_motor_bearing() {
        height = relative_motor_line_pos_z + 20 + y_rail_dist_above_plate + 0;
        translate([0,0,-line_bearing_thickness/2-bearing_bevel_height-height/2]) {
          rotate([0,0,-z_line_angle]) {
            hole(line_bearing_screw_hole_diam+wall_thickness*4,height,resolution);
          }
        }
      }
    }

    translate([body_width/2,overall_depth/2,plate_pos_z+overall_height/2+wall_thickness*2]) {
      depth = overall_depth_for_side(side) - 10;
      rotate([0,90,0]) {
        rotate([0,0,90]) {
          if (side == left) {
            mirror([1,0,0]) {
              letter_L(depth,depth*2);
            }
          } else {
            letter_R(depth,depth*2);
          }
        }
      }
    }
  }

  module holes() {
    position_motor_bearing() {
      rotate([0,0,-z_line_angle]) {
        hole(line_bearing_diam+1,line_bearing_thickness+bearing_bevel_height*2,resolution);
        hole(line_bearing_screw_hole_diam,200,8);

        intersection() {
          rotate_extrude(convexity=3) {
            translate([line_bearing_diam/2,10,0]) {
              square([3,20],center=true);
            }
            translate([line_bearing_diam/2,0,0]) {
              circle(r=3/2,$fn=6);
            }
          }
          translate([line_bearing_diam/2,line_bearing_diam/2,0]) {
            cube([line_bearing_diam+0.05,line_bearing_diam+0.05,line_bearing_diam],center=true);
          }
        }
        translate([line_bearing_diam/2,0,0]) {
            rotate([-90,0,0]) {
              translate([0,0,-25]) {
                cylinder(r=3/2,h=50,$fn=6,center=true);
              }
            }
        }
        translate([0,line_bearing_diam/2,0]) {
          translate([-line_bearing_diam,0,10]) {
            cube([line_bearing_diam*2,3,20],center=true);
          }
          rotate([0,-90,0]) {
            translate([0,0,25]) {
              rotate([0,0,90]) {
                cylinder(r=3/2,h=50,$fn=6,center=true);
              }
            }
          }
        }
      }
    }
    position_xy_bearing() {
      rotate([0,0,other_z_line_angle]) {
        hole(line_bearing_diam+1,line_bearing_thickness+bearing_bevel_height*2,resolution);
        hole(line_bearing_screw_hole_diam,200,8);
      }
    }

    position_rear_idler_anchor_holes(plate_pos_z+plate_anchor_thickness/2) {
      hole(line_bearing_screw_hole_diam,wall_thickness*2+1,resolution);
    }

    // trim excess off bottom
    translate([0,0,plate_pos_z-50]) {
      cube([100,100,100],center=true);
    }
  }

  module bridges() {
    position_xy_bearing() {
      bearing_bevel(other_z_line_angle);
    }

    position_motor_bearing() {
      bearing_bevel(-z_line_angle);
    }
  }

  mirror([1-side,0,0]) {
    position_xy_bearing() {
      % color(opposite_line_color) line_bearing();

      rotate([0,0,other_z_line_angle]) {
        translate([line_bearing_diam/2,front*(25),0]) {
          % color(opposite_line_color) cube([0.5,50,0.5],center=true);
        }
      }
    }

    position_motor_bearing() {
      % color(line_color) line_bearing();

      rotate([0,0,-z_line_angle]) {
        translate([line_bearing_diam/2,front*(25),0]) {
          % color(line_color) cube([0.5,50,0.5],center=true);
        }
      }

      translate([line_bearing_diam/2-angular_distance/2,line_bearing_diam/2,0]) {
        % color(line_color) cube([angular_distance-line_bearing_diam,0.5,0.5],center=true);
      }
    }

    difference() {
      union() {
        translate([0,0,0]) {
          difference() {
            body();
            holes();
          }
        }
        bridges();
      }

      // mount y rail
      for(z=[top,bottom]) {
        translate([0,0,z*10]) {
          rotate([90,0,0]) {
            hole(5.2,100,8);
          }
        }
      }
    }
  }
}

module to_print() {
  for(side=[left,right]) {
    translate([-side*(overall_depth_for_side(side)/2),0,0]) {
      rotate([0,0,side*90]) {
        rear_idler_mount(side);
      }
    }
  }
}
