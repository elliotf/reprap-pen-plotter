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
use <sketch-for-simpler.scad>;

// board dimensions are lengthwise along x
// akin to drawings:
//   ender3: https://github.com/bigtreetech/BIGTREETECH-SKR-mini-E3/blob/aa91937b29419ff2382c2c2ad9bfeaca86d08bdb/BTT%20SKR%20MINI%20E3%20V1.1(new%20version%20board)/Hardware/BTT%20SKR%20MINI%20E3%20V1.1%20SIZE.pdf
//   raspi A+ : https://www.raspberrypi-spy.co.uk/wp-content/uploads/2012/03/raspberry_pi_a_plus_mechanical-1024x780.png
//   raspi B+ : https://www.raspberrypi-spy.co.uk/wp-content/uploads/2012/03/raspberry_pi_3_b_plus_mechanical.png

brace_thickness = wall_thickness*2;

ender3_board_max_x = 100;
ender3_board_max_y = 70.25;
ender3_board_hole_coords = [
  [100-2.54,2.54],
  [2.54,70.25-38.20],
  [20.40,70.25-2.54],
  [82.55,70.25-2.54],
];

rasp_a_plus_max_x = 65;
rasp_a_plus_max_y = 56;
rasp_hole_spacing_x = 58;
rasp_hole_spacing_y = 49;
rasp_hole_coords = [
  [3.5,3.5], // bottom left
  [3.5,3.5+rasp_hole_spacing_y], // top left
  [3.5+rasp_hole_spacing_x,3.5+rasp_hole_spacing_y], // top right
  [3.5+rasp_hole_spacing_x,3.5], // bottom right
];

rasp_a_plus_usb_socket_offset_y = 31.45;

bevel_height = 2.5;

// raspi isn't actually this tall, but the buck converter is
//raspi_side_depth = 14 + bevel_height;
raspi_side_depth = buck_conv_width + bevel_height + 2;
controller_side_depth = 23 + bevel_height;
overall_depth = raspi_side_depth + controller_side_depth + brace_thickness;

module position_ender3_holes() {
  for(coord=ender3_board_hole_coords) {
    translate(coord) {
      children();
    }
  }
}

module position_pi_holes() {
  for(coord=rasp_hole_coords) {
    translate(coord) {
      children();
    }
  }
}

module electronics_mount() {
  screw_area_diam = m3_threaded_insert_diam+wall_thickness*4;
  screw_area_height = 8;
  room_for_screw_terminal_cables = 8;
  room_above_ender3_board = 4;
  room_below_ender3_board = 10;
  board_space = 2;
  main_height = ender3_board_max_x + bevel_height*2 + room_below_ender3_board + room_above_ender3_board;
  main_width = ender3_board_max_y + board_space + room_for_screw_terminal_cables + brace_thickness*2;
  base_thickness = 3;

  echo("electronics mount height: ", main_height);
  echo("electronics mount width: ", main_width);
  echo("electronics mount depth: ", overall_depth);

  module position_ender3_board() {
    translate([right*(brace_thickness/2+bevel_height),ender3_board_max_y/2-room_for_screw_terminal_cables/2,room_below_ender3_board/2-room_above_ender3_board/2]) {
      rotate([0,-90,0]) {
        rotate([180,0,0]) {
          // push ender board aside slightly to make room for cables to screw-in terminals
          translate([-ender3_board_max_x/2,0,0]) {
            children();
          }
        }
      }
    }
  }

  module position_pi_board() {
    translate([left*(brace_thickness/2+bevel_height),ender3_board_max_y/2-rasp_a_plus_max_y/2-room_for_screw_terminal_cables/2,main_height/2-rasp_a_plus_max_x/2-20]) {
      rotate([0,-90,0]) {
        translate([-rasp_a_plus_max_x/2,-rasp_a_plus_max_y/2,0]) {
          children();
        }
      }
    }
  }

  module position_mounting_holes() {
    // if mounted vertically, screw holes to mount
    for(y=[front,rear]) {
      translate([brace_thickness/2+m3_threaded_insert_diam/2,y*(main_width*0.4),-main_height/2+base_thickness]) {
        children();
      }
    }
    // if mounted on its side, screw holes to mount
    for(z=[-main_height/2+base_thickness+2+m3_threaded_insert_diam/2,main_height/2-8-m3_threaded_insert_diam/2]) {
      translate([controller_side_depth/2,-main_width/2+brace_thickness,z]) {
        rotate([-90,0,0]) {
          children();
        }
      }
    }
  }

  module position_buck_converter() {
    /*
    // alongside raspberry pi -- too close, will probably collide with HDMI port
    translate([left*(brace_thickness/2+bevel_height),-ender3_board_max_x/2+rasp_a_plus_max_x+4+buck_conv_width/2,main_height/2-room_above_ender3_board-rasp_a_plus_max_x+buck_conv_length/2]) {
      rotate([0,-90,0]) {
        rotate([0,0,-90]) {
          children();
        }
      }
    }
    */
    /*
    // below raspberry pi
    translate([left*(brace_thickness/2+bevel_height),-main_width/2+brace_thickness+bevel_height+buck_conv_length/2,-main_height/2+base_thickness+bevel_height/2+buck_conv_width/2]) {
      rotate([0,-90,0]) {
        rotate([0,0,180]) {
          children();
        }
      }
    }
    */
    /*
    // on base, below controller
    translate([brace_thickness/2+controller_side_depth/2,-main_width/2+8+brace_thickness+bevel_height/2+buck_conv_length/2,-main_height/2+base_thickness+bevel_height]) {
      rotate([0,0,0]) {
        rotate([0,0,0]) {
          children();
        }
      }
    }
    */
    // on base, below raspi
    translate([-brace_thickness/2-buck_conv_width/2-2,main_width/2-brace_thickness-room_for_screw_terminal_cables-buck_conv_length/2,-main_height/2+base_thickness+bevel_height/2]) {
      rotate([0,0,180]) {
        children();
      }
    }
  }

  module body_profile() {
    rounded_square(brace_thickness,main_width,brace_thickness);

    for(y=[front]) {
      mirror([0,y-1,0]) {
        translate([-raspi_side_depth-brace_thickness/2+overall_depth/2,main_width/2-brace_thickness/2,0]) {
          rounded_square(overall_depth,brace_thickness,brace_thickness);
        }

        for(x=[left,right]) {
          mirror([x-1,0,0]) {
            translate([brace_thickness/2,main_width/2-brace_thickness,0]) {
              rotate([0,0,-90]) {
                round_corner_filler_profile(brace_thickness);
              }
            }
          }
        }
      }
    }
  }

  module body() {
    linear_extrude(height=main_height,center=true,convexity=3) {
      body_profile();
    }
    translate([-raspi_side_depth-brace_thickness/2+overall_depth/2,0,-main_height/2+base_thickness/2]) {
      rounded_cube(overall_depth,main_width,base_thickness,brace_thickness);
    }

    translate([0,main_width/2-screw_area_diam/2,main_height/2]) {
      hull() {
        translate([-brace_thickness/2+screw_area_diam/2,0,-screw_area_height/2]) {
          hole(screw_area_diam,screw_area_height,resolution);
        }
        translate([0,0,-screw_area_height]) {
          rounded_cube(brace_thickness,screw_area_diam,screw_area_height*2,brace_thickness);
        }
      }
    }

    position_ender3_board() {
      position_ender3_holes() {
        bevel_rim_diam = m3_thread_into_plastic_hole_diam+extrude_width*4;
        bevel(bevel_rim_diam+bevel_height*2,bevel_rim_diam,bevel_height);
      }
    }

    position_pi_board() {
      position_pi_holes() {
        bevel_rim_diam = m2_5_thread_into_plastic_hole_diam+extrude_width*4;
        bevel(bevel_rim_diam+bevel_height*2,bevel_rim_diam,bevel_height);
      }
    }

    position_buck_converter() {
      position_buck_converter_holes() {
        bevel_rim_diam = m2_5_thread_into_plastic_hole_diam+extrude_width*4;
        bevel(bevel_rim_diam+bevel_height*2,bevel_rim_diam,bevel_height);

        translate([0,buck_conv_hole_spacing_y/2,0]) {
          bevel_rim_diam = m2_5_thread_into_plastic_hole_diam+extrude_width*4;
          bevel(bevel_rim_diam+bevel_height*2,bevel_rim_diam,bevel_height);
        }
      }
    }

    position_mounting_holes() {
      translate([0,0,bevel_height]) {
        bevel_rim_diam = m3_threaded_insert_diam+extrude_width*4;
        bevel(bevel_rim_diam+bevel_height*2,bevel_rim_diam,bevel_height);
      }
    }
  }

  module holes() {
    position_ender3_board() {
      position_ender3_holes() {
        hole(m3_thread_into_plastic_hole_diam,2*(bevel_height+brace_thickness-extrude_width*2),8);
      }
    }
    position_pi_board() {
      position_pi_holes() {
        hole(m2_5_thread_into_plastic_hole_diam,2*(bevel_height+brace_thickness-extrude_width*2),8);
      }
    }

    position_buck_converter() {
      position_buck_converter_holes() {
        hole(m3_thread_into_plastic_hole_diam,2*(bevel_height+brace_thickness-extrude_width*2),resolution);

        translate([0,buck_conv_hole_spacing_y/2,0]) {
          hole(m3_thread_into_plastic_hole_diam,2*(bevel_height+brace_thickness-extrude_width*2),resolution);
        }
      }
    }

    // if/when there is a cover, here is a place to screw it down
    translate([-brace_thickness/2+screw_area_diam/2,main_width/2-screw_area_diam/2,main_height/2]) {
      hole(m3_threaded_insert_diam,2*(screw_area_height-2),resolution);
    }

    position_mounting_holes() {
      hole(m3_threaded_insert_diam,base_thickness*3,resolution);
    }

    // tiedown spots for zip ties
    zip_tie_hole_x = 2.5;
    zip_tie_hole_y = 5;
    translate([brace_thickness/2+controller_side_depth-wall_thickness*2-3-zip_tie_hole_x/2,-main_width/2+brace_thickness,-main_height/2]) {
      for(y=[8:16:70]) {
        translate([0,y,0]) {
          rounded_cube(zip_tie_hole_x,zip_tie_hole_y,base_thickness*4,1);
        }
      }
    }

    // clearance for wire from voltage out on controller board to buck converter
    translate([0,main_width/2,-main_height/2+room_below_ender3_board+20]) {
      difference() {
        cube([brace_thickness*2,(brace_thickness+room_for_screw_terminal_cables)*2,30],center=true);

        translate([0,-room_for_screw_terminal_cables-brace_thickness,0]) {
          hole(brace_thickness,12,resolution);

          for(z=[top,bottom]) {
            hull() {
              translate([0,0,z*(15)]) {
                hole(brace_thickness,20,resolution);

                translate([0,brace_thickness+room_for_screw_terminal_cables,0]) {
                  hole(brace_thickness,1,resolution);
                }
              }
            }
          }
        }
      }
    }
  }

  position_ender3_board() {
    % ender3_board();
  }

  position_pi_board() {
    % raspi_3a();
  }

  % position_buck_converter() {
    buck_converter();
  }

  difference() {
    body();
    holes();
  }
}

module ender3_board() {
  board_thickness = 2;

  ender3_usb_offset_from_top_y = 22.27;
  ender3_usb_connector_height = 5.2;
  ender3_usb_connector_width = 29.92 - ender3_usb_offset_from_top_y;
  ender3_usb_connector_depth = 8;
  ender3_usb_connector_offset_y = ender3_board_max_y-ender3_usb_offset_from_top_y-ender3_usb_connector_width/2;

  power_input_width = 11;
  power_input_depth = 11;
  power_input_height = 20;
  power_input_pos_x = 1+power_input_depth/2;
  power_input_pos_y = 5+power_input_width/2;

  microsd_socket_x = 14;
  microsd_socket_y = 15;
  microsd_socket_z = 2;
  microsd_socket_from_edge_y = 2;

  module body() {
    translate([ender3_board_max_x/2,ender3_board_max_y/2,board_thickness/2]) {
      color("green") cube([ender3_board_max_x,ender3_board_max_y,board_thickness],center=true);
    }

    translate([ender3_board_max_x-ender3_usb_connector_depth/2+2,ender3_usb_connector_offset_y,board_thickness+ender3_usb_connector_height/2]) {
      color("silver") cube([ender3_usb_connector_depth,ender3_usb_connector_width,ender3_usb_connector_height],center=true);
    }

    translate([ender3_board_max_x-microsd_socket_x/2,ender3_board_max_y-microsd_socket_from_edge_y-microsd_socket_y/2,board_thickness+microsd_socket_z/2]) {
      color("silver") cube([microsd_socket_x,microsd_socket_y,microsd_socket_z],center=true);
    }

    translate([power_input_pos_x,power_input_pos_y,board_thickness/2+power_input_height/2]) {
      color("lightgreen") cube([power_input_depth,power_input_width,power_input_height],center=true);
    }

    output_block_depth = 10;
    output_block_width = 30;
    output_block_height = 14;
    translate([13+output_block_width/2,output_block_depth/2,board_thickness+output_block_height/2]) {
      // power outputs
      color("lightgreen") cube([output_block_width,output_block_depth,output_block_height],center=true);
    }

    endstop_block_width = 48.25;
    endstop_block_depth = 6;
    endstop_block_height = 7;
    translate([46.5+endstop_block_width/2,endstop_block_depth/2,board_thickness+endstop_block_height/2]) {
      // power outputs
      color("white") cube([endstop_block_width,endstop_block_depth,endstop_block_height],center=true);
    }

    motor_connector_width = 12.5;
    motor_connector_depth = 5.75;
    motor_connector_height = 7;
    motor_connector_offsets_x = [4,24,45,62.5];
    for(x=motor_connector_offsets_x) {
      translate([x+motor_connector_width/2,ender3_board_max_y-0.75-motor_connector_depth/2,board_thickness+motor_connector_height/2]) {
        color("white") cube([motor_connector_width,motor_connector_depth,motor_connector_height],center=true);
      }
    }
  }

  module holes() {
    position_ender3_holes() {
      hole(3,board_thickness*3,resolution);
    }
  }

  difference() {
    body();
    holes();
  }
}

module raspi_3a() {
  board_thickness = 1.5;

  usb_connector_height = 7.1;
  usb_connector_width = 13.1;
  usb_connector_length = 14;
  usb_connector_overhang = 2;
  usb_connector_offset_y = 31.45;

  microusb_connector_width = 8;
  microusb_connector_height = 3;
  microusb_connector_length = 6;
  microusb_connector_overhang = 1.5;

  gpio_width = 5;
  gpio_length = 50;
  gpio_pos_x = 7+gpio_length/2;
  gpio_pos_y = rasp_a_plus_max_y-1-gpio_width/2;

  microsd_width = 11;
  microsd_length = 15;
  microsd_thickness = 1.5;
  microsd_overhang = 2;

  rasp_plus_max_x = rasp_a_plus_max_x + 20;
  rasp_connector_area_x = 22;
  rasp_connector_area_y = 53;
  rasp_connector_area_z = 16;
  rasp_connector_overhang = 2;

  module body() {
    translate([0,rasp_a_plus_max_y/2,board_thickness/2]) {
      translate([rasp_a_plus_max_x/2,0,0]) {
        color("green") rounded_cube(rasp_a_plus_max_x,rasp_a_plus_max_y,board_thickness,3);
      }

      translate([rasp_plus_max_x/2,0,0]) {
        color("green", 0.4) rounded_cube(rasp_plus_max_x,rasp_a_plus_max_y,board_thickness,3);
      }
    }

    translate([rasp_a_plus_max_x-usb_connector_length/2+usb_connector_overhang,usb_connector_offset_y,board_thickness+usb_connector_height/2]) {
      color("silver") cube([usb_connector_length,usb_connector_width,usb_connector_height],center=true);
    }

    translate([rasp_plus_max_x-rasp_connector_area_x/2+rasp_connector_overhang,rasp_a_plus_max_y/2,board_thickness+rasp_connector_area_z/2]) {
      color("silver", 0.4) cube([rasp_connector_area_x,rasp_connector_area_y,rasp_connector_area_z],center=true);
    }

    translate([microsd_length/2-microsd_overhang,rasp_a_plus_max_y/2,-microsd_thickness/2]) {
      color("#333") cube([microsd_length,microsd_width,microsd_thickness],center=true);
    }

    translate([10.6,microusb_connector_length/2-microusb_connector_overhang,board_thickness+microusb_connector_height/2]) {
      color("silver") cube([microusb_connector_width,microusb_connector_length,microusb_connector_height],center=true);
    }

    translate([gpio_pos_x,gpio_pos_y,board_thickness+3]) {
      color("#333") cube([gpio_length,gpio_width,6],center=true);
    }
  }

  module holes() {
    position_pi_holes() {
      color("tan") hole(2.5,board_thickness*3,resolution);
    }
  }

  difference() {
    body();
    holes();
  }
}

module pi_b_plus() {
}

electronics_mount();

translate([-ender3_board_max_x/2,ender3_board_max_y/2,-ender3_board_max_y/2]) {
  // % ender3_board();
}
