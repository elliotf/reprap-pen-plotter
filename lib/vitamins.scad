use <lib/util.scad>;

include <config.scad>;

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

module line_bearing(resolution=16) {
  module profile() {
    difference() {
      translate([line_bearing_diam/4,0]) {
        square([line_bearing_diam/2,line_bearing_thickness], center=true);
      }
      translate([line_bearing_inner/4,0]) {
        square([line_bearing_inner/2,line_bearing_thickness+1], center=true);
      }

      // groove
      translate([line_bearing_diam/2,0,0]) {
        rotate([0,0,0]) {
          accurate_circle(1,6);
        }
      }
    }
  }

  rotate_extrude(convexity=3,$fn=resolution) {
    profile();
  }

  // hole(line_bearing_diam,line_bearing_thickness,resolution);
  // hole(line_bearing_inner,line_bearing_thickness+1,resolution);
}

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

module extrusion_2040_profile() {
  v_slot_depth     = 1.80;
  //v_slot_gap       = 5.68;
  v_slot_width     = 9.5;
  v_slot_gap       = v_slot_width-v_slot_depth*2;
  v_slot_opening   = 6.2;

  width = 40;
  height = 20;

  module groove_profile() {
    square([v_slot_depth*3,v_slot_opening],center=true);
    hull() {
      square([v_slot_depth*2,v_slot_gap],center=true);
      translate([0,0,0]) {
        square([0.00001,v_slot_width],center=true);
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

  base_unit = 20;
  open_space_between_sides = base_unit-v_slot_depth*2;
  difference() {
    square([width,height],center=true);

    square([5.4,open_space_between_sides],center=true);

    hull() {
      square([5.4,open_space_between_sides-1.96*2],center=true);
      square([12.2,5.68],center=true);
    }

    for(x=[left,right]) {
      translate([x*width/4,0]) {
        accurate_circle(4.2,16);

        for(y=[top,bottom]) {
          translate([0,y*height/2,0]) {
            rotate([0,0,90]) {
              groove_profile();
            }
          }
        }
      }

      translate([x*width/2,0]) {
        rotate([0,0,0]) {
          groove_profile();
        }
      }
    }
  }
}

module extrusion_2040(length) {
  linear_extrude(height=length,center=true,convexity=2) {
    extrusion_2040_profile();
  }
}

module ptfe_bushing_profile_for_2040_extrusion() {
  width = 40;
  height = 20;
  bushing_from_extrusion_corner = ptfe_bushing_diam/2+0.5;
  
  // PTFE bushings
  // short side bushings
  for(x=[left,right]) {
    for (z=[top,bottom]) {
      translate([x*(width/2+ptfe_bushing_diam/2-ptfe_bushing_preload_amount),z*(height/2-bushing_from_extrusion_corner)]) {
        accurate_circle(ptfe_bushing_diam,8);
      }
    }
  }

  // long side bushings
  for(x=[left,right]) {
    for (z=[top,bottom]) {
      translate([x*(width/2-bushing_from_extrusion_corner),z*(height/2+ptfe_bushing_diam/2-ptfe_bushing_preload_amount)]) {
        accurate_circle(ptfe_bushing_diam,8);
      }
    }
  }
}

module motor_nema17() {
  difference() {
    translate([0,0,-nema17_len/2]) cube([nema17_side,nema17_side,nema17_len],center=true);
    for(end=[left,right]) {
      for(side=[front,rear]) {
        translate([nema17_hole_spacing/2*side,nema17_hole_spacing/2*end,0]) cylinder(r=motor_screw_diam/2,h=100,center=true);
      }
    }
  }
  hole(nema17_shoulder_diam,nema17_shoulder_height*2,16);

  translate([0,0,nema17_shaft_len/2]) {
    hole(nema17_shaft_diam,nema17_shaft_len,16);
    // hole(line_pulley_diam,line_pulley_height,16);
  }
}

module motor_nema14() {
  difference() {
    translate([0,0,-nema14_len/2]) cube([nema14_side,nema14_side,nema14_len],center=true);
    for(end=[left,right]) {
      for(side=[front,rear]) {
        translate([nema14_hole_spacing/2*side,nema14_hole_spacing/2*end,0]) cylinder(r=motor_screw_diam/2,h=100,center=true);
      }
    }
  }
  hole(nema14_shoulder_diam,nema14_shoulder_height*2,16);

  translate([0,0,nema14_shaft_len/2]) {
    hole(nema14_shaft_diam,nema14_shaft_len,16);
    hole(line_pulley_diam,line_pulley_height,16);
  }
}
