include <config.scad>;
use <y-carriage.scad>;
include <util.scad>;
include <vitamins.scad>;

module line_return_end_cap(side) {
  colors = ["red", "green", "blue"];
  line_color = colors[side+1];
  opposite_line_color = colors[-side+1];
  overall_depth = 20;
  overall_height = 35+y_rail_dist_above_plate;

  x_line_pos_x = x_rail_end_relative_to_y_rail_x;
  x_line_pos_z = x_rail_end_relative_to_y_rail_z+10+line_bearing_above_extrusion;

  y_spacing = (side+1)*3;
  other_y_spacing = (-side+1)*3;
  motor_line_pos_y = line_bearing_diam/2+y_spacing;
  x_line_pos_y = line_bearing_diam/2;
  
  motor_line_pos_x = x_line_pos_x + (pulley_idler_diam + line_thickness/2);
  motor_line_pos_z = x_line_pos_z - idler_wraps * (groove_height + groove_height);

  dist_from_line_to_line_z = abs(x_line_pos_z - motor_line_pos_z);
  dist_from_line_to_line_x = abs(x_line_pos_x+y_rail_pos_x + motor_line_pos_x+ y_rail_pos_x);

  echo("dist_from_line_to_line_x", dist_from_line_to_line_x);
  echo("dist_from_line_to_line_z", dist_from_line_to_line_z);

  angular_distance = sqrt(pow(dist_from_line_to_line_x,2)+pow(dist_from_line_to_line_z,2));
  y_line_angle = atan2(dist_from_line_to_line_z,dist_from_line_to_line_x);
  z_line_angle = atan2(y_spacing,dist_from_line_to_line_x);
  other_z_line_angle = atan2(other_y_spacing,dist_from_line_to_line_x);

  line_bearing_screw_hole_diam = 4.8;

  module position_xy_bearing() {
    translate([x_line_pos_x,x_line_pos_y,x_line_pos_z]) {
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
    translate([motor_line_pos_x,motor_line_pos_y,motor_line_pos_z]) {
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
    translate([-10,overall_depth/2,-20-y_rail_dist_above_plate+overall_height/2]) {
      // rounded_cube(40,overall_depth,overall_height,printed_carriage_inner_diam);
    }
    translate([0,overall_depth/2,0]) {
      rounded_cube(width,overall_depth,height,printed_carriage_inner_diam,resolution);
    }
    width = 5.2+printed_carriage_wall_thickness*2;
    height = 20 + 10;
    /*
    for(z=[top,bottom]) {
      translate([0,overall_depth/2,z*10]) {
        rotate([90,0,0]) {
          # hole(5.2+printed_carriage_wall_thickness*2,overall_depth,resolution);
        }
      }
    }
    */
  }

  module body() {
    hull() {
      main_body();
    }

    hull() {
      main_body();
      position_xy_bearing() {
        height = x_line_pos_z + 20 + y_rail_dist_above_plate + 0;
        translate([0,0,-line_bearing_thickness/2-bearing_bevel_height-height/2]) {
          rotate([0,0,other_z_line_angle]) {
            hole(line_bearing_screw_hole_diam+wall_thickness*4,height,resolution);
          }
        }
      }
      position_motor_bearing() {
        height = motor_line_pos_z + 20 + y_rail_dist_above_plate + 0;
        translate([0,0,-line_bearing_thickness/2-bearing_bevel_height-height/2]) {
          rotate([0,0,-z_line_angle]) {
            hole(line_bearing_screw_hole_diam+wall_thickness*4,height,resolution);
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

        translate([line_bearing_diam/2,0,0]) {
          rotate([0,-y_line_angle,0]) {
            rotate([90,0,0]) {
              rotate([0,0,90]) {
                hole(3,50,6);
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

    translate([0,0,-20-y_rail_dist_above_plate-50]) {
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

      translate([line_bearing_diam/2-angular_distance/2,line_bearing_diam/2,0]) {
        % color(opposite_line_color) cube([angular_distance,0.5,0.5],center=true);
      }
    }

    position_motor_bearing() {
      % color(line_color) line_bearing();

      translate([line_bearing_diam/2-angular_distance/2,line_bearing_diam/2,0]) {
        % color(line_color) cube([angular_distance,0.5,0.5],center=true);
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

module old_rear_idler_mount(side) {
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

  height_above_extrusion = belt_pos_z - line_bearing_thickness/2 - gap_to_bearing - x_rail_extrusion_height;
  overall_height = x_rail_extrusion_height+height_above_extrusion;
  overall_width = outer_line_idler_pos_x - inner_line_idler_pos_x + line_bearing_inner + extrude_width*6;

  body_pos_z = x_rail_extrusion_height/2+height_above_extrusion/2;

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
      for(z=[x_rail_extrusion_height*0.25,x_rail_extrusion_height*0.75]) {
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
          cube([x_rail_extrusion_width,2,overall_height],center=true);
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
    for(z=[x_rail_extrusion_height*0.25,x_rail_extrusion_height*0.75]) {
      translate([0,0,z]) {
        rotate([90,0,0]) {
          hole(5,x_rail_extrusion_height*2,16);
        }
      }
    }

    position_idler_shafts() {
      translate([0,0,body_pos_z]) {
        hole(idler_shaft_hole_for_threading,x_rail_extrusion_height*3,16);
      }
    }
  }

  difference() {
    body();
    holes();
  }
}
