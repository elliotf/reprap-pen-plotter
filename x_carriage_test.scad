include <sketch.scad>;

rail_length = 120;

motor_mount_thickness = extrude_width*12;
test_motor_tolerance = 0.1;
test_motor_mount_overall_width = motor_side+(test_motor_tolerance+motor_mount_thickness)*2;
test_motor_mount_overall_depth = motor_side+(test_motor_tolerance+motor_mount_thickness)*2;
test_motor_mount_overall_height = motor_len+motor_mount_thickness*2;

test_motor_pos_y = -rail_length/2-test_motor_mount_overall_depth/2-0.1-5;
test_motor_pos_x = x_carriage_belt_spacing/2-line_pulley_diam/2-line_thickness/2;

module motor_bracket() {
  extrusion_brace_depth = 25;
  m5_bolt_head_height = 5;
  m5_bolt_head_diam = 10;

  module body() {
    hull() {
      translate([0,0,-test_motor_mount_overall_height/2+motor_mount_thickness]) {
        cube([test_motor_mount_overall_width,test_motor_mount_overall_depth,test_motor_mount_overall_height],center=true);
      }
      translate([-test_motor_pos_x,test_motor_mount_overall_depth/2,-extrusion_width/2]) {
        cube([extrusion_height,10,extrusion_width],center=true);
      }
    }
    hull() {
      translate([-test_motor_pos_x,test_motor_mount_overall_depth/2+5,-extrusion_width-motor_mount_thickness/2]) {
        cube([extrusion_height,extrusion_brace_depth*2,motor_mount_thickness],center=true);
      }
      translate([-test_motor_pos_x,0,-test_motor_mount_overall_height+motor_mount_thickness+1]) {
        cube([extrusion_height,test_motor_mount_overall_depth,2],center=true);
      }
    }
  }

  module holes() {
    for(x=[left,right]) {
      for(y=[front,rear]) {
        translate([x*(motor_hole_spacing/2),y*(motor_hole_spacing/2),0]) {
          hole(3.1,motor_len*3,8);
        }
      }
    }

    hole(motor_shoulder_diam+2,test_motor_mount_overall_height*2,resolution);

    // room for the motor
    translate([0,0,-motor_len]) {
      cube([motor_side+test_motor_tolerance*2,motor_side+test_motor_tolerance*2,motor_len*2],center=true);
    }

    // make printable at an angle
    translate([0,-test_motor_mount_overall_depth/2-motor_mount_thickness,motor_mount_thickness]) {
      rotate([-45,0,0]) {
        translate([0,test_motor_mount_overall_depth,-test_motor_mount_overall_height]) {
          cube([test_motor_mount_overall_width*2,test_motor_mount_overall_depth*2,test_motor_mount_overall_height*2],center=true);
        }
      }
    }

    // mount to the extrusion
    translate([-test_motor_pos_x,0,-extrusion_width/2]) {
      for(x=[left,right]) {
        // bolt into the extrusion end
        translate([x*extrusion_height/4,0,0]) {
          rotate([90,0,0]) {
            hole(5.1,motor_side*2,8);

            // room for bolt head
            hole(m5_bolt_head_diam,motor_side+m5_bolt_head_height*2,8);
          }
        }

        translate([x*extrusion_height/4,test_motor_mount_overall_depth/2+5+extrusion_brace_depth/2,-extrusion_width/2]) {
          hole(5.1,motor_side*2,8);

          translate([0,0,-motor_mount_thickness-motor_len/2]) {
            hole(m5_bolt_head_diam,motor_len,8);
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

//translate([0,-rail_length/2,motor_len*2]) {
  rotate([45,0,0]) {
    motor_bracket();
  }
//}

/*

translate([0,0,0]) {
  rotate([0,0,-90]) {
    x_carriage_printed();
  }
}
rotate([0,0,-90]) {
  rotate([0,90,0]) {
    color("silver") extrusion(rail_length);
  }
}
translate([test_motor_pos_x,test_motor_pos_y,extrusion_width/2]) {
  motor_bracket();
  % motor_nema17();
}
*/
