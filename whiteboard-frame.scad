echo("BEGIN");
echo("");
echo("");
echo("");
echo("");
echo("");

include <config.scad>;
use <sketch-for-simpler.scad>;
use <z-axis-mount.scad>;
use <lib/vitamins.scad>;
use <moar-wheels.scad>;

sketch_pos_x = 0;
// max for debug is ~ +110
// min for debug is ~ -20
sketch_pos_y = 0;

//debug = 0;
debug = 0;

//whiteboard_x = (debug) ? 150 : 580;
//whiteboard_y = (debug) ? 175 : 890;
extra_room_for_electronics = 60;
whiteboard_x = (debug) ? 150+extra_room_for_electronics : 585;
whiteboard_y = (debug) ? 200 : 890;

//brace_extrusion_length = (debug) ? 200+extra_room_for_electronics : (whiteboard_x + 20*2 + 20*2);
brace_extrusion_length = (debug) ? 200+extra_room_for_electronics : 750;
echo("brace_extrusion_length: ", brace_extrusion_length);
rail_extrusion_length = (debug) ? (whiteboard_y+40) : 1000;


whiteboard_rim_frontside_width = 22;
whiteboard_rim_backside_width = 14.6;
whiteboard_rim_thickness = 17;
whiteboard_rim_thickness_edge = 14;
whiteboard_rim_thickness_above_surface = 3.7;
whiteboard_rim_thickness_below_surface = 10;
whiteboard_surface_thickness = whiteboard_rim_thickness - whiteboard_rim_thickness_above_surface - whiteboard_rim_thickness_below_surface;

whiteboard_frame_spacing = 1;

whiteboard_pos_y = -rail_extrusion_length/2+whiteboard_y/2+40+4;

module whiteboard_rim_profile() {
  module body() {
    intersection() {
      translate([0,-60+whiteboard_rim_thickness_edge,0]) {
        accurate_circle(61*2,resolution*10);
      }
      translate([0,whiteboard_rim_thickness_edge,0]) {
        square([whiteboard_rim_frontside_width,whiteboard_rim_thickness_edge*2],center=true);
      }
    }
  }

  module holes() {

  }

  difference() {
    body();
    holes();
  }
}

module whiteboard_frame_anchor() {
  thickness = wall_thickness*2;
  echo("whiteboard frame anchor thickness: ", thickness);
  //rail_side_thickness = 5;
  rail_side_thickness = thickness;
  whiteboard_rim_empty_height = 4; // go up this amount to tap into a more solid part of the whiteboard frame
  holes_above_bottom = whiteboard_rim_empty_height+(whiteboard_rim_thickness_edge-4)/2;

  alignment_rim = thickness; // make orientation clear

  echo("whiteboard_frame_anchor thickness: ", thickness);

  length = 40;
  width = 20;
  height = 20;

  slop_amount = 1.5;
  sloppy_hole = 5 + slop_amount; // extra room to be able to move around to ensure sides are parallel and level

  module body() {
    translate([-alignment_rim/2,0,height/2-rail_side_thickness/2]) {
      rounded_cube(width+alignment_rim,length,rail_side_thickness,thickness,resolution);
    }
    translate([left*width/2+thickness/2,0,0]) {
      rounded_cube(thickness,length,height,thickness,resolution);
    }

    for(y=[front,0,rear]) {
      translate([0,y*(length/2-thickness/2),0]) {
        hull() {
          translate([0,0,height/2-rail_side_thickness/2]) {
            rounded_cube(width,thickness,rail_side_thickness,thickness,resolution);
          }
          translate([left*width/2+thickness/2,0,0]) {
            rounded_cube(thickness,thickness,height,thickness,resolution);
          }
        }
      }
    }
  }

  module holes() {
    for(y=[front,rear],r=[0,90]) {
      translate([0,y*20/2,-height/2+holes_above_bottom]) {
        rotate([0,r,0]) {
          hole(sloppy_hole,height*2,resolution);
        }
      }
    }
  }

  difference() {
    body();
    holes();
  }
}

module whiteboard() {
  module parallel_rims(outer_dist,length) {
    for(x=[right,left]) {
      translate([x*(outer_dist/2-whiteboard_rim_frontside_width/2),0]) {
        difference() {
          rotate([90,0,0]) {
            color("#aaa") linear_extrude(height=length,center=true,convexity=5) {
              whiteboard_rim_profile();
            }
          }
          for(y=[front,rear]) {
            translate([x*whiteboard_rim_frontside_width/2,y*length/2,0]) {
              rotate([0,0,y*x*45]) {
                translate([-x*whiteboard_rim_frontside_width,y*whiteboard_rim_frontside_width,0]) {
                  cube([whiteboard_rim_frontside_width*2,whiteboard_rim_frontside_width*2,whiteboard_rim_thickness*3],center=true);
                }
              }
            }
          }
        }
      }
    }
  }

  parallel_rims(whiteboard_x,whiteboard_y);
  rotate([0,0,90]) {
    parallel_rims(whiteboard_y,whiteboard_x);
  }
  translate([0,0,whiteboard_rim_thickness_below_surface+whiteboard_surface_thickness/2]) {
    color("#eee") cube([whiteboard_x-whiteboard_rim_frontside_width,whiteboard_y-whiteboard_rim_frontside_width,whiteboard_surface_thickness],center=true);
  }
}

translate([0,whiteboard_pos_y,-20]) {
  whiteboard();
}

//frame_outer_width = whiteboard_x+whiteboard_frame_spacing*2+20*2;
frame_outer_width = whiteboard_x+40;

echo("frame_outer_width: ", frame_outer_width);

for(x=[left,right]) {
  mirror([x+1,0,0]) {
    translate([frame_outer_width/2-20/2,0,40/2]) {
      rotate([90,0,0]) {
        rotate([0,0,90]) {
          color("lightgrey") extrusion_2040(rail_extrusion_length);
        }
      }
      translate([0.05,0,-40/2-20/2]) {
        whiteboard_frame_anchor();
      }

      translate([0,rail_extrusion_length/2,0]) {
        rotate([0,0,180]) {
          mirror([1,0,0]) {
            motor_mount();

            translate([0.5,0,0]) {
              motor_mount_cap();
            }

            endstop_flag_mount();
          }
        }
      }
      translate([0,front*rail_extrusion_length/2,0]) {
        rotate([0,0,180]) {
          y_idler_mount();
        }
      }
    }
  }
}

// X axis
translate([0,sketch_pos_y,0]) {
  x_rail_len = frame_outer_width + 35;
  translate([0,0,40+mini_v_wheel_plate_above_extrusion]) {
    translate([0,0,20+mini_v_wheel_plate_thickness]) {
      rotate([0,90,0]) {
        color("lightgrey") extrusion_2040(x_rail_len);
      }

      translate([x_rail_len/2,0,0]) {
        x_motor_mount();

        translate([-35,0,0]) {
          mirror([0,1,0]) {
            rotate([0,0,90]) {
              endstop_flag_mount();
            }
          }
        }
      }

      translate([-x_rail_len/2,0,0]) {
        x_idler_mount();
      }

      translate([sketch_pos_x,0,0]) {
        wheeled_pen_carriage_assembly();
      }
    }

    for(x=[left,right]) {
      mirror([x-1,0,0]) {
        translate([frame_outer_width/2-20/2,0,0]) {
          xy_carriage();
        }
      }
    }
  }
}

// cross braces
for(y=[front,rear]) {
  translate([-whiteboard_x/2-30-20+brace_extrusion_length/2,whiteboard_pos_y+y*(whiteboard_y/2+40/2+2),-20/2]) {
    rotate([0,90,0]) {
      rotate([0,0,90]) {
        color("lightgrey") extrusion_2040(brace_extrusion_length);
      }
    }

  }
}
/*
for(y=[0]) {
  translate([0,y*(whiteboard_y/2-whiteboard_rim_backside_width/2+40/2),-20/2]) {
    for(x=[left,right],y2=[front,rear]) {
      mirror([0,y2-1,0]) {
        translate([x*(frame_outer_width/2-20/2),40/2+20/2,0]) {
          rotate([180,0,0]) {
            corner_bracket_2020();
          }
        }
        // anchor top of brace to side rail, probably don't need?
        translate([x*(frame_outer_width/2+20/2),20/2,20]) {
          rotate([0,0,90]) {
            // corner_bracket_2020();
          }
        }
      }
    }
    rotate([0,90,0]) {
      rotate([0,0,90]) {
        color("lightgrey") extrusion_2040(brace_extrusion_length);
      }
    }
  }
}
for(y=[front,rear]) {
  translate([0,y*(rail_extrusion_length/2-20),-10]) {
    for(x=[left,right]) {
      translate([x*(frame_outer_width/2-20/2),y*-60/2,0]) {
        rotate([180-45-(45*y),0,0]) {
          corner_bracket_2020();
        }
      }
    }
    rotate([0,90,0]) {
      rotate([0,0,90]) {
        color("lightgrey") extrusion_2040(brace_extrusion_length);
      }
    }
  }
}
*/
