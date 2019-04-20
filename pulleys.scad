include <config.scad>;
use <lib/util.scad>;

module filament_pulley(diam=(16*2/pi), base_height=6, wraps=5,hole_od=0,od_height=0) {
  //diam           = circumference/pi;
  circumference  = diam*pi;
  height         = wraps*groove_height+2*(wraps+1)*groove_depth;
  base_diam      = diam+groove_depth*2;
  steps_per_mm   = steps_per_turn/circumference;
  echo("CIRCUMF:   ", steps_per_mm);
  echo("STEPS/MM:  ", steps_per_mm);
  echo("DIAM:      ", diam);
  echo("BASE_DIAM: ", base_diam);
  echo("HEIGHT:    ", height+base_height-groove_depth);

  base_pos_z     = height+base_height/2-groove_depth;
  bottom_pos_z   = 0;
  top_pos_z      = (base_height > 0) ? base_pos_z + base_height/2 : height;

  overall_height = top_pos_z - bottom_pos_z;

  module profile() {
    difference() {
      union() {
        translate([diam/4,height/2,0]) {
          square([diam/2,height],center=true);
        }

        translate([base_diam/4,base_pos_z,0]) {
          square([base_diam/2,base_height],center=true);
        }

        for (z=[0:wraps]) {
          translate([diam/2,groove_depth+z*(groove_height+groove_depth*2)]) {
            hull() {
              translate([-0.5,0,0]) {
                square([1,groove_depth*2],center=true);
              }
              translate([0,0,0]) {
                square([groove_depth*2,0.005],center=true);
              }
            }
          }
        }
      }
    }
  }

  translate([0,0,height+1]) {
    /*
    % difference() {
      profile();
      hole_profile();
    }
    */
  }

  module body() {
    rotate_extrude(convexity=10,$fn=resolution) {
      profile();
    }

    translate([diam/2+1,0,groove_depth*2+groove_height/2]) {
      // % cube([1,1,groove_height],center=true);
    }
  }

  module holes() {
    // for driver
    nut_thickness = 2.70;
    nut_diam      = 5.55;
    screw_diam    = 3.15;
    shaft_diam    = 5.1;
    d_cut_depth   = shaft_diam-4.6;
    // d_cut_height  = base_height+3;
    d_cut_height  = 100;

    round_shaft_allowance = 5.5;

    // idler branch
    if (hole_od) {
      hole_diam = pulley_idler_bearing_od + tolerance;
      bearing_hole_resolution = 12;
      hole_id = hole_diam-1;
      hole(hole_id,40,bearing_hole_resolution);

      for(z=[top_pos_z-pulley_idler_bearing_height/2,bottom_pos_z+pulley_idler_bearing_height/2]) {
        translate([0,0,z]) {
          % hole(pulley_idler_bearing_od, pulley_idler_bearing_height+0.05, resolution*2);
          hull() {
            hole(hole_diam, pulley_idler_bearing_height, bearing_hole_resolution);
            hole(hole_diam-1, pulley_idler_bearing_height+1, bearing_hole_resolution);
          }
        }
      }
    }

    // driver
    if (base_height) {
      difference() {
        hole(shaft_diam,50,12);

        translate([shaft_diam/2,0,overall_height/2+round_shaft_allowance-0.05]) {
          cube([d_cut_depth*2,shaft_diam+1,overall_height],center=true);
        }
      }
      translate([shaft_diam/2-d_cut_depth-0.1+nut_thickness/2,0,top_pos_z-nut_diam/2]) {
        rotate([0,90,0]) {
          rotate([0,0,90]) {
            hole(nut_diam,nut_thickness,6);
          }
          translate([0,0,10]) {
            hole(screw_diam,20,16);
          }
        }
        translate([0,0,nut_diam/2]) {
          cube([nut_thickness,nut_diam,nut_diam],center=true);
        }
      }
    }
  }

  difference() {
    body();
    holes();
  }
}

module driver_pulley() {
  base_height   = 7;

  filament_pulley(driver_diam,base_height,driver_wraps);
}

module idler_pulley() {
  intersection() {
    filament_pulley(pulley_idler_diam,0,idler_wraps,pulley_idler_bearing_od,pulley_idler_bearing_height);

    translate([0,20,0]) {
      // cube([40,40,40],center=true);
    }
  }
}

