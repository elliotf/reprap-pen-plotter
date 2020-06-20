include <config.scad>;
use <sketch-for-simpler.scad>;
use <z-axis-mount.scad>;
use <lib/vitamins.scad>;


belt_width = 6;
pulley_diam = gt2_16t_pulley_diam;
translate([0,0,20+mini_v_wheel_plate_thickness+mini_v_wheel_plate_above_extrusion]) {
  translate([0,-10,0]) {
    rotate([90,0,0]) {
      rotate([0,0,90]) {
        // module basic_mini_v_wheel_plate(extrusion_width=20,wheel_spacing_y=10+20+wall_thickness*4)
        basic_mini_v_wheel_plate(40);
      }
    }
  }

  rotate([0,90,0]) {
    color("silver", 0.3) extrusion_2040(y_rail_len);
  }
}
for(x=[left,right]) {
  translate([x*x_rail_len/2,0,0]) {
    mirror([x-1,0,0]) {
      translate([0,0,mini_v_wheel_plate_above_extrusion]) {
        basic_mini_v_wheel_plate();
      }
    }

    % translate([0,0,-20]) {
      rotate([90,0,0]) {
        rotate([0,0,90]) {
          color("silver", 0.3) extrusion_2040(y_rail_len);
        }
      }
    }

    % for(y=[front,rear]) {
      translate([0,y*(y_rail_len/2+10),mini_v_wheel_belt_above_extrusion-pulley_diam/2]) {
        rotate([0,90,0]) {
          hole(pulley_diam,belt_width,resolution);
        }
        for(z=[top,bottom]) {
          translate([0,-y*(y_rail_len/4),z*(pulley_diam/2)]) {
            cube([belt_width,y_rail_len/2,1],center=true);
            if (z < 0) {
              rotate([0,90,0]) {
                cube([belt_width,y_rail_len/2,1],center=true);
              }
            }
          }
        }
      }
    }
  }
}


module motor_mount() {
}

module idler_mount() {
  
}


//linear_extrude(height=2,center=true) {
//y_carriage();
//rotate([90,0,0]) {
//  color("silver", 0.3) extrusion_2040(y_rail_len);
//}
//}

//y_dragchain_clamp();
//y_endcap_with_motor();
//y_on_carriage_dragchain_anchor_mount();

/*
translate([0,0,0.1]) {
  % color("lightgrey") extrusion_2040_profile();
}
*/

/*
use <lib/util.scad>;
use <lib/ISOThread.scad>;

height = 10;

difference() {
  cube([10,10,height],center=true);
  hole(5,height+1,16);
}
translate([0,0,-height/2]) {
  thread_in_pitch(5,height,0.8);			// make an M8 x 10 thread with 1mm pitch
}
*/

