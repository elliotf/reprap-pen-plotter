include <NopSCADlib/lib.scad>;
echo("BEGIN");
echo("");
echo("");
echo("");
echo("");
echo("");

// TODO:
// * Y dragchain
// * X dragchain
// * electronics mount

include <config.scad>;
include <lumpyscad/lib.scad>;
use <sketch-for-simpler.scad>;
use <z-axis-mount.scad>;
use <lib/vitamins.scad>;
use <moar-wheels.scad>;

//debug = 0;
debug = 0;

//whiteboard_x = (debug) ? 150 : 580;
//whiteboard_y = (debug) ? 175 : 890;
extra_room_for_electronics = 60;
whiteboard_x = (debug) ? 150+extra_room_for_electronics : 585;
whiteboard_y = (debug) ? 200 : 890;

//brace_extrusion_length = (debug) ? 200+extra_room_for_electronics : (whiteboard_x + 20*2 + 20*2);
brace_extrusion_length = (debug) ? whiteboard_x+80+nema17_side+20 : 750;
echo("brace_extrusion_length: ", brace_extrusion_length);
rail_extrusion_length = (debug) ? (whiteboard_y+88) : 1000;

echo("rail_extrusion_length: ", rail_extrusion_length);

whiteboard_rim_frontside_width = 22;
whiteboard_rim_backside_width = 14.6;
whiteboard_rim_thickness = 17;
whiteboard_rim_thickness_edge = 14;
whiteboard_rim_thickness_above_surface = 3.7;
whiteboard_rim_thickness_below_surface = 10;
whiteboard_surface_thickness = whiteboard_rim_thickness - whiteboard_rim_thickness_above_surface - whiteboard_rim_thickness_below_surface;

whiteboard_frame_spacing = 1;

//whiteboard_pos_y = -rail_extrusion_length/2+whiteboard_y/2+40+4;
whiteboard_pos_y = -rail_extrusion_length/2+whiteboard_y/2+40+2;
//whiteboard_pos_y = 0;

sketch_pos_x = 0;
// max for debug is ~ +110
// min for debug is ~ -20
sketch_pos_y = 0;
whiteboard_writable_y = whiteboard_y-whiteboard_rim_frontside_width*2;

pen_pos_y = whiteboard_pos_y-whiteboard_writable_y/2+whiteboard_writable_y*sketch_pos_y+40;

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

module anchor_2020_base(units_wide=1, units_high=1, unit_size=20, thickness=wall_thickness*2) {
  width = unit_size*units_wide;
  height = unit_size*units_high;

  module body() {
    translate([0,0,-height/2+thickness/2]) {
      rounded_cube(width,height,thickness,thickness,resolution);
    }
    translate([0,height/2-thickness/2,0]) {
      rounded_cube(width,thickness,height,thickness,resolution);
    }
    translate([left*(width)/2,0,0]) {
      for(i=[0:units_wide]) {
        translate([i*unit_size,0,0]) {
          adjust_x = (i==0) ? thickness/2
                          : (i==units_wide) ? -thickness/2
                                            : 0;
          hull() {
            translate([adjust_x,0,0]) {
              translate([0,height/2-thickness/2,0]) {
                rounded_cube(thickness,thickness,height,thickness,resolution);
              }
              translate([0,0,-height/2+thickness/2]) {
                rounded_cube(thickness,height,thickness,thickness,resolution);
              }
            }
          }
        }
      }
    }
  }

  module holes() {
    translate([-width/2,height/2,-height/2]) {
      for(side=[0,1]) {
        mirror([0,side,side]) {
          for(x=[0:units_wide-1],y=[0:units_high-1]) {
            translate([unit_size/2+x*unit_size,-unit_size/2+y*-unit_size,thickness]) {
              hole(5.25,thickness*3,resolution);
            }
          }
        }
      }
    }
  }

  translate([0,-height/2,height/2]) {
    difference() {
      body();
      holes();
    }
  }
}

module electronics_mount_combined() {
  extrude_width = 0.5;
  mount_thickness = extrude_width*4;
  base_thickness = 3;
  rounded_diam = mount_thickness;
  room_for_wires = 12;
  bevel_height = 3;
  mounting_hole_diam = 5.2;
  mounting_bevel = mounting_hole_diam+wall_thickness*2+bevel_height*2;

  rpi = RPI3;
  board = BTT_SKR_MINI_E3_V2_0;

  rpi_hole_d = pcb_hole_d(rpi);
  board_hole_d = pcb_hole_d(board);

  rpi_width = pcb_width(rpi);
  rpi_length = pcb_length(rpi);
  board_width = pcb_width(board);
  board_length = pcb_length(board);

  overall_width = board_length + room_for_wires + 0.5 + mount_thickness*2;
  overall_depth = board_width + 10;
  overall_height = 55;

  middle_pos_z = 10-bevel_height-mount_thickness/2;

  module position_board() {
    translate([board_length/2+room_for_wires+mount_thickness,front*(board_width/2+mount_thickness+5),middle_pos_z+mount_thickness/2+bevel_height]) {
      rotate([0,0,0]) {
        children();
      }
    }
  }

  module position_rpi() {
    position_board() {
      translate([board_length/2-rpi_length/2-2,front*(board_width/2-rpi_width/2),bottom*(mount_thickness+bevel_height*2)]) {
        rotate([180,0,0]) {
          children();
        }
      }
    }
  }

  module position_mounting_holes() {
    // for(z=[-20+20/2,-20+overall_height-20/2]) {
    //for(x=[left,left*0.33,right*0.33,right]) {
    for(x=[0:5]) {
      //translate([overall_width/2+x*(overall_width/2-mount_thickness/2-mounting_bevel/2),front*(base_thickness+bevel_height),-20+20/2]) {
      translate([10+20*x,front*(base_thickness+bevel_height),-20+20/2]) {
        rotate([90,0,0]) {
          children();
        }
      }
    }
  }

  position_rpi() {
    % pcb(rpi);
  }
  position_board() {
    % pcb(board);
  }

  module profile() {
    module body() {
      translate([0,middle_pos_z,0]) {
        square([overall_width,mount_thickness],center=true);
      }
      for(x=[left,right]) {
        translate([x*(overall_width/2-mount_thickness/2),-20+overall_height/2,0]) {
          rounded_square(mount_thickness,overall_height,mount_thickness,resolution);
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

  module bounding_box() {
    translate([overall_width/2,front*overall_depth/2,-20+overall_height/2]) {
      cube([overall_width-mount_thickness,overall_depth-mount_thickness,overall_height-mount_thickness],center=true);
    }
  }

  module position_rpi_holes() {
    position_rpi() {
      pcb_hole_positions(rpi) {
        children();
      }
    }
  }

  module position_board_holes() {
    intersection() {
      position_board() {
        pcb_hole_positions(board) {
          children();
        }
      }
      bounding_box();
    }
  }

  module body() {
    translate([overall_width/2,front*base_thickness/2,-20+overall_height/2]) {
      rotate([90,0,0]) {
        rounded_cube(overall_width,overall_height,base_thickness,rounded_diam);
      }
    }
    translate([overall_width/2,front*(overall_depth/2),0]) {
      rotate([90,0,0]) {
        linear_extrude(height=overall_depth,center=true,convexity=5) {
          profile();
        }
      }
    }
    position_mounting_holes() {
      bevel(mounting_bevel,mounting_hole_diam+wall_thickness*2,bevel_height,resolution);
    }
    position_rpi_holes() {
      top_d = rpi_hole_d+wall_thickness*2;
      base_d = top_d+bevel_height*2;
      bevel(base_d,top_d,bevel_height,resolution);
    }
    position_board_holes() {
      top_d = board_hole_d+wall_thickness*2;
      base_d = top_d+bevel_height*2;
      bevel(base_d,top_d,bevel_height,resolution);
    }

    for(x=[left,right],z=[top,bottom]) {
      nub_stickout = mount_thickness*1.5;
      support_height = 30;
      support_tip_height = support_height-nub_stickout;
      translate([overall_width/2+x*(overall_width/2-mount_thickness/2),front*(base_thickness+mount_thickness+60-support_height/2),-20+overall_height/2+z*(overall_height/2-mount_thickness/2)]) {
        rotate([90,0,0]) {
          hull() {
            hole(mount_thickness,support_height,resolution);
            translate([-x*nub_stickout,0,support_height/2-support_tip_height/2]) {
              hole(mount_thickness,support_tip_height,resolution);
            }
          }
        }
      }

      for(y=[0:2]) {
        nub_height = 6;
        nub_tip_height = nub_height-nub_stickout;
        translate([overall_width/2+x*(overall_width/2-mount_thickness/2),front*(base_thickness+mount_thickness+nub_height/2+y*(nub_height+mount_thickness)),-20+overall_height/2+z*(overall_height/2-mount_thickness/2)]) {
          rotate([90,0,0]) {
            hull() {
              hole(mount_thickness,nub_height,resolution);
              translate([-x*nub_stickout,0,nub_height/2-nub_tip_height/2]) {
                hole(mount_thickness,nub_tip_height,resolution);
              }
            }
          }
        }
      }
    }
  }

  module holes() {
    // usb port on rpi
    position_rpi() {
      hole_height = 10;
      hole_width = 16;
      translate([rpi_length/2+2+mount_thickness/2,1,hole_height/2-0.5]) {
        rotate([0,90,0]) {
          rounded_cube(hole_height,hole_width,mount_thickness*4,4,8);
        }
      }
    }

    position_board() {
      microusb_hole_height = 5;
      microusb_hole_width = 10;
      translate([board_length/2+2+mount_thickness/2,9,microusb_hole_height/2+0.5]) {
        rotate([0,90,0]) {
          rounded_cube(microusb_hole_height,microusb_hole_width,mount_thickness*4,4,8);
        }
      }

      sdcard_hole_height = 5;
      sdcard_hole_width = 17;
      translate([board_length/2+2+mount_thickness/2,rear*(board_width/2-9.5),sdcard_hole_height/2+0.5]) {
        rotate([0,90,0]) {
          rounded_cube(sdcard_hole_height,sdcard_hole_width,mount_thickness*4,4,8);
        }
      }

      passthrough_hole_length = 20;
      passthrough_hole_width = 12;
      translate([-board_length/2-passthrough_hole_width/2+4,-2+5+passthrough_hole_length/2,0]) {
        rounded_cube(passthrough_hole_width,passthrough_hole_length,20,4,8);
      }
    }

    position_mounting_holes() {
      hole(mounting_hole_diam,2*inch,resolution);
    }
    position_rpi_holes() {
      hole(rpi_hole_d,2*bevel_height,resolution);
    }
    position_board_holes() {
      hole(board_hole_d,2*bevel_height,resolution);
    }

    // wire access cutouts
    for(x=[left*0.7,left*0.25,right*0.25,right*0.7]) {
      cable_hole_width = 8;
      cable_hole_depth = 12;
      translate([overall_width/2+x*overall_width/2,front*base_thickness/2,-20+overall_height]) {
        rotate([90,0,0]) {
          rounded_cube(cable_hole_width,cable_hole_depth*2,base_thickness*3,cable_hole_width,resolution);
          for(x=[left,right]) {
            translate([x*(cable_hole_width/2),0,0]) {
              rotate([0,0,45+135*-x]) {
                round_corner_filler(rounded_diam*2,base_thickness*3);
              }
            }
          }
        }
      }
    }

    for(z=[top,bottom]) {
      translate([overall_width/2,front*overall_depth,-20+overall_height/2+z*overall_height/2]) {
        rotate([45-45*z,0,0]) {
          rotate([0,90,0]) {
            round_corner_filler(30,overall_width*1.5);
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

module electronics_mount_base(width,depth) {
  module profile() {
    module body() {
    }

    module holes() {
    }

    difference() {
      body();
      holes();
    }
  }

  module body() {
  }

  module holes() {
  }

  difference() {
    body();
    holes();
  }
}

module electronics_mount_rpi() {
  board_type = RPI3;
  board_width = pcb_width(board_type);
  board_length = pcb_length(board_type);

  module position_board() {
    translate([board_length/2,front*board_width/2,0]) {
      rotate([0,0,0]) {
        children();
      }
    }
  }

  position_board() {
    %pcb(board_type);
  }

  module body() {
  }

  module holes() {
  }

  difference() {
    body();
    holes();
  }
}

module electronics_mount_controller() {
  board_type = BTT_SKR_MINI_E3_V2_0;
  board_width = pcb_width(board_type);
  board_length = pcb_length(board_type);

  module position_board() {
    translate([board_length/2,front*board_width/2,0]) {
      rotate([0,0,0]) {
        children();
      }
    }
  }

  position_board() {
    %pcb(board_type);
  }

  module body() {
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

// cross braces
cross_brace_pos_y = [
  whiteboard_pos_y+front*(whiteboard_y/2+40/2+2),
  whiteboard_pos_y+rear*(whiteboard_y/2+40/2+2),
  //rail_extrusion_length/2-40/2,
];

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

      translate([0,front*rail_extrusion_length/2,0]) {
        translate([0,2,-40/2]) {
          translate([0,40,0]) {
            rotate([180,0,0]) {
              // anchor_2020_base(1,1);
            }
          }
          for(x=[left,right]) {
            mirror([x-1,0,0]) {
              translate([20/2,40/2,0]) {
                rotate([0,0,90]) {
                  // anchor_2020_base(2,1);
                }
              }
            }
          }
        }
        motor_mount();

        translate([0.5,0,0]) {
          motor_mount_cap();
        }

        endstop_flag_mount();
      }

      translate([0,rear*rail_extrusion_length/2,0]) {
        y_idler_mount();
      }

      for(y=[front,rear]) {
        translate([0,whiteboard_pos_y+y*(whiteboard_y/2+2),0]) {
          translate([0,0,-40/2]) {
            rotate([-45+135*y,0,0]) {
              anchor_2020_base(1,1);
            }
            for(x=[left,right]) {
              mirror([x-1,0,0]) {
                translate([20/2,y*40/2,0]) {
                  rotate([0,0,90]) {
                    anchor_2020_base(2,1);
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

// X axis
mirror([0,0,0]) {
  translate([0,pen_pos_y,0]) {
    x_rail_len = frame_outer_width + 35;
    translate([0,0,40+mini_v_wheel_plate_above_extrusion]) {
      translate([0,0,20+mini_v_wheel_plate_thickness]) {
        rotate([0,90,0]) {
          color("lightgrey") extrusion_2040(x_rail_len);
        }

        translate([x_rail_len/2,0,0]) {
          x_motor_mount();

          translate([0,0,0]) {
            //mirror([0,1,0]) {
              rotate([0,0,0]) {
                rotate([0,0,0]) {
                  //endstop_flag_mount();
                }
              }
            //}
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
}

for(y=cross_brace_pos_y) {
  translate([right*(-whiteboard_x/2-40-20+brace_extrusion_length/2),y,-20/2]) {
    rotate([0,90,0]) {
      rotate([0,0,90]) {
        color("lightgrey") extrusion_2040(brace_extrusion_length);
      }
    }

  }
}

translate([frame_outer_width/2-200,whiteboard_pos_y-whiteboard_y/2-40-2,0.5]) {
  translate([0,0,0]) {
    rotate([0,0,0]) {
      electronics_mount_combined();
    }
  }
}

translate([frame_outer_width/2+60,whiteboard_pos_y-whiteboard_y/2-2-40-60,0.5]) {
  rotate([0,0,90]) {
    rotate([-90,0,0]) {
      electronics_mount_combined();
    }
  }
}

translate([frame_outer_width/2,whiteboard_pos_y-whiteboard_y/2,0]) {
  /*
  translate([0,40,0]) {
    rotate([0,0,90]) {
      electronics_mount_combined();
    }
  }

  translate([0,40,0]) {
    rotate([0,0,90]) {
      electronics_mount_controller();
    }
  }

  translate([0,200,0]) {
    rotate([0,0,90]) {
      electronics_mount_rpi();
    }
  }
  */
}

translate([0,-whiteboard_pos_y-whiteboard_y/2-200,0]) {
  //electronics_mount_combined();
  /*
  translate([-whiteboard_x/3,0,0]) {
    debug_axes(2);
    electronics_mount_controller();
  }
  translate([whiteboard_x/3,0,0]) {
    debug_axes(2);
    electronics_mount_rpi();
  }
  */
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
