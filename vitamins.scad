use <util.scad>;

include <config.scad>;

z_stepper_diam = 28;
z_stepper_height = 19.5; // body is 19, but flanges stick up

z_stepper_shaft_diam = 5;
z_stepper_flange_width = 42;
z_stepper_flange_diam = 7;
z_stepper_flange_thickness = 0.8;
z_stepper_flange_hole_diam = 4.2;
z_stepper_flange_hole_spacing = 35;

z_stepper_shaft_from_center = 8;
z_stepper_shaft_length = 7.9; // varies between 7.9 and 8.5, due to slop in the shaft
z_stepper_shaft_flat_length = 6.1;
z_stepper_shaft_flat_thickness = 3;
z_stepper_shaft_flat_cut_depth = (z_stepper_shaft_diam-z_stepper_shaft_flat_thickness)/2;
z_stepper_shaft_base_diam = 9.25;
z_stepper_shaft_base_height = 1.7; // what drawings say.  Actual measurement is 1.6

z_stepper_hump_height = 16.8;
z_stepper_hump_width = 15;
z_stepper_hump_depth = 17-z_stepper_diam/2;

module stepper28BYJ(shaft_angle) {
  cable_distance_from_face = 1.75;
  cable_diam    = 1;
  num_cables    = 5;
  cable_pos_x   = [-2.4,-1.2,0,1.2,2.4];
  cable_colors  = ["yellow","orange","red","pink","royalblue"];
  cable_spacing = 1.2;
  cable_sample_len = 5;
  cable_opening_width = 7.3;

  resolution = 32;

  module position_at_flange_centers() {
    for(side=[left,right]) {
      translate([side*(z_stepper_flange_hole_spacing/2),0,0]) {
        children();
      }
    }
  }

  color("lightgrey") {
    // main body
    translate([0,0,-z_stepper_height/2]) {
      hole(z_stepper_diam,z_stepper_height,resolution*1.25);
    }

    // flanges
    translate([0,0,-z_stepper_flange_thickness/2]) {
      linear_extrude(height=z_stepper_flange_thickness,center=true,convexity=3) {
        difference() {
          hull() {
            position_at_flange_centers() {
              accurate_circle(z_stepper_flange_diam,resolution/2);
            }
          }
          position_at_flange_centers() {
            accurate_circle(z_stepper_flange_hole_diam,resolution/2);
          }
        }
      }
    }

    // shaft base
    translate([0,-z_stepper_shaft_from_center,0]) {
      hole(z_stepper_shaft_base_diam,z_stepper_shaft_base_height*2,resolution);
    }
  }

  // shaft
  color("gold") {
    translate([0,-z_stepper_shaft_from_center,0]) {
      rotate([0,0,shaft_angle]) {
        difference() {
          hole(z_stepper_shaft_diam,(z_stepper_shaft_length+z_stepper_shaft_base_height)*2,resolution);

          translate([0,0,z_stepper_shaft_base_height+z_stepper_shaft_length]) {
            for(y=[left,right]) {
              translate([0,y*z_stepper_shaft_diam/2,0]) {
                cube([z_stepper_shaft_diam,z_stepper_shaft_flat_cut_depth*2,z_stepper_shaft_flat_length*2],center=true);
              }
            }
          }
        }
      }
    }
  }

  // hump
  translate([0,z_stepper_diam/2,-z_stepper_hump_height/2-0.05]) {
    color("dodgerblue") {
      difference() {
        cube([z_stepper_hump_width,z_stepper_hump_depth*2,z_stepper_hump_height],center=true);

        translate([0,z_stepper_hump_depth,z_stepper_hump_height/2-cable_distance_from_face-cable_diam/2]) {
          rotate([90,0,0]) {
            hull() {
              for(x=[left,right]) {
                translate([x*(cable_opening_width/2-cable_diam/2),0,0]) {
                  hole(cable_diam+0.1,8,10);
                }
              }
            }
          }
        }
      }
    }
  }

  // hump cables
  translate([0,z_stepper_diam/2+z_stepper_hump_depth,-cable_distance_from_face-cable_diam/2]) {
    rotate([90,0,0]) {
      for(c=[0:num_cables-1]) {
        translate([cable_pos_x[c],0,0]) {
          color(cable_colors[c]) {
            hole(cable_diam,cable_sample_len*2,8);
          }
        }
      }
    }
  }
}

tuner_hole_to_shoulder = 22.5;
wire_hole_diam = 2;

tuner_thin_diam = 6;
tuner_thin_len_past_hole = 5;
tuner_thin_len = tuner_hole_to_shoulder + tuner_thin_len_past_hole;
tuner_thin_pos = tuner_hole_to_shoulder/2-tuner_thin_len_past_hole/2;

tuner_thick_diam = 10;
tuner_thick_len = 10;
tuner_thick_pos = tuner_hole_to_shoulder-tuner_thick_len+tuner_thick_len/2;

tuner_body_diam = 15;
tuner_body_thickness = 9;
tuner_body_square_len = 10;
tuner_body_pos = -tuner_hole_to_shoulder-tuner_body_thickness/2;

tuner_anchor_screw_hole_thickness = 2;
tuner_anchor_screw_hole_diam = 2;
tuner_anchor_diam = 6;
tuner_anchor_screw_hole_pos_x = -tuner_hole_to_shoulder-tuner_anchor_screw_hole_thickness/2;
tuner_anchor_screw_hole_pos_y = -tuner_body_diam/2;
tuner_anchor_screw_hole_pos_z = -tuner_body_diam/2;

module tuner_anchor_hole_positioner_relative_to_tuner() {
  translate([tuner_anchor_screw_hole_pos_x,tuner_anchor_screw_hole_pos_y,tuner_anchor_screw_hole_pos_z]) {
    rotate([0,90,0]) {
      children();
    }
  }
}

module tuner() {
  adjuster_narrow_neck_len = 2;
  adjuster_len = 24 - tuner_body_diam + adjuster_narrow_neck_len;
  adjuster_large_diam = 8;
  adjuster_tuner_thin_diam = 6;
  adjuster_x = tuner_body_pos;
  adjuster_y = tuner_body_square_len/2;
  adjuster_shaft_z = tuner_body_diam/2+adjuster_len/2;
  adjuster_paddle_len = 20;
  adjuster_paddle_z = adjuster_shaft_z + adjuster_len/2 + adjuster_paddle_len/2;
  adjuster_paddle_width = 17.8;
  adjuster_paddle_thickness = adjuster_tuner_thin_diam;

  module body() {
    //% translate([-tuner_hole_to_shoulder/2,-tuner_thick_diam,0]) rotate([0,90,0]) cylinder(r=tuner_thin_diam/4,h=tuner_hole_to_shoulder,center=true);

    // thin shaft
    translate([-tuner_thin_pos,0,0]) rotate([0,90,0])
      hole(tuner_thin_diam,tuner_thin_len,resolution);

    // thick shaft (area to clamp)
    translate([-tuner_thick_pos,0,0]) rotate([0,90,0])
      hole(tuner_thick_diam,tuner_thick_len,resolution);

    // body
    translate([tuner_body_pos,0,0]) {
      hull() {
        rotate([0,90,0]) {
          hole(tuner_body_diam,tuner_body_thickness,resolution);
        }
        translate([0,tuner_body_square_len/2,0]) {
          cube([tuner_body_thickness,tuner_body_square_len,tuner_body_diam],center=true);
        }
      }
    }

    // anchor screw hole
    hull() {
      translate([tuner_anchor_screw_hole_pos_x,0,0]) {
        rotate([0,90,0])
          hole(tuner_thick_diam,tuner_anchor_screw_hole_thickness);
      }
      tuner_anchor_hole_positioner_relative_to_tuner() {
        hole(tuner_anchor_diam,tuner_anchor_screw_hole_thickness,resolution);
      }
    }

    // twist adjuster
    translate([adjuster_x,adjuster_y,adjuster_shaft_z]) {
      hull() {
        translate([0,0,-adjuster_len/2-.5]) hole(adjuster_large_diam,1,resolution);
        translate([0,0,+adjuster_len/2-.5]) hole(adjuster_tuner_thin_diam,1,resolution);
      }
      // paddle, representing space taken when rotated
      /*
      hull() {
        //translate([0,0,adjuster_paddle_len/2]) cylinder(r=adjuster_paddle_width/2,h=1,center=true);
        //translate([0,0,1]) cylinder(r=adjuster_paddle_thickness/2,h=1,center=true);
        translate([0,0,adjuster_paddle_len-.5]) cube([adjuster_paddle_width,adjuster_paddle_thickness,1],center=true);
        translate([0,0,adjuster_len/2]) cube([adjuster_paddle_thickness,adjuster_paddle_thickness,1],center=true);
      }
      */
    }
  }

  module holes() {
    cylinder(r=wire_hole_diam/3,h=tuner_thin_diam*2,center=true);

    translate([tuner_anchor_screw_hole_pos_x,tuner_anchor_screw_hole_pos_y,tuner_anchor_screw_hole_pos_z]) rotate([0,90,0])
      hole(tuner_anchor_screw_hole_diam,tuner_anchor_screw_hole_thickness+1,8);
  }

  difference() {
    body();
    holes();
  }
}
