resolution = 32;

function accurate_diam(diam,sides) = 1 / cos(180/sides) / 2 * diam;

module hole(diam,len,sides=8) {
  rotate([0,0,180/sides]) {
    cylinder(r=accurate_diam(diam,sides),h=len,center=true,$fn=sides);
  }
}

module accurate_circle(diam,sides=8) {
  rotate([0,0,180/sides]) {
    circle(r=accurate_diam(diam,sides),$fn=sides);
  }
}

module debug_axes() {
  color("red") translate([50,0,0]) cube([100,.2,.2],center=true);
  color("green") translate([0,50,0]) cube([.2,100,.2],center=true);
  color("blue") translate([0,0,50]) cube([.2,.2,100],center=true);
}

module ring(id,thickness,height,fn=16) {
  od = id + thickness;
  linear_extrude(height=height,center=true) {
    difference() {
      accurate_circle(od,fn);
      accurate_circle(id,fn);
    }
  }
}

module rounded_square(width,depth,diam,fn=resolution) {
  pos_x = width/2-diam/2;
  pos_y = depth/2-diam/2;

  hull() {
    for(x=[left,right]) {
      for(y=[front,rear]) {
        translate([x*pos_x,y*pos_y,0]) {
          accurate_circle(diam,fn);
        }
      }
    }
  }
}

module rounded_cube(width,depth,height,diam,fn=resolution) {
  linear_extrude(height=height,center=true,convexity=3) {
    rounded_square(width,depth,diam,fn);
  }
}

module round_corner_filler(diam,length) {
  linear_extrude(height=length,center=true,convexity=3) {
    round_corner_filler_profile(diam);
  }
}

module round_corner_filler_profile(diam,res=resolution) {
  extra = 0.1;
  main = diam/2+extra;
  difference() {
    translate([diam/4-extra,diam/4-extra,0]) {
      square([main,main],center=true);
    }
    translate([diam/2,diam/2,0]) {
      accurate_circle(diam,res);
    }
  }
}

module space_along_length(length,min_hole_spacing=4*inch,from_end=1*inch) {
  avail_length = length - (from_end*2);
  num_spaces   = floor(avail_length / min_hole_spacing);
  extra_space  = (avail_length - (num_spaces*min_hole_spacing)) / num_spaces;
  spacing      = min_hole_spacing + extra_space;

  // echo(length, num_spaces, spacing);

  translate([0,-length/2+from_end,0]) {
    for(y=[0:num_spaces]) {
      translate([0,y*spacing,0]) {
        children();
      }
    }
  }
}

module letter_spike(thin_width,thick_width,thickness) {
  hull() {
    cylinder(r=thin_width,h=thickness*2,center=true,$fn=16);
    cylinder(r=thick_width,h=0.01,center=true,$fn=16);
  }
}

module letter_L(width=10,height=20,thickness=0.5,thick_width=2,thin_width=0.3) {
  lines = [
    [
      [-width/2,height/2,0],
      [-width/2,-height/2,0],
    ],
    [
      [-width/2,-height/2,0],
      [width/2,-height/2,0],
    ],
  ];

  for(pair=lines) {
    hull() {
      for(vect=pair) {
        translate(vect) {
          letter_spike(thin_width,thick_width,thickness);
        }
      }
    }
  }
}

module letter_R(width=10,height=20,thickness=0.5,thick_width=2,thin_width=0.3) {
  lines = [
    [
      [-width/2,height/2,0],
      [-width/2,-height/2,0],
    ],
    [
      [-width/2,height/2,0],
      [width/2,height/3,0],
    ],
    [
      [width/2,height/3,0],
      [-width/4,0,0],
    ],
    [
      [-width/2,0,0],
      [-width/4,0,0],
    ],
    [
      [-width/4,0,0],
      [width/2,-height/2,0],
    ],
  ];

  for(pair=lines) {
    hull() {
      for(vect=pair) {
        translate(vect) {
          letter_spike(thin_width,thick_width,thickness);
        }
      }
    }
  }
}

module zip_tie_cavity(inner_diam_input,zip_tie_thickness,zip_tie_width,fn=resolution) {
  inner_diam = inner_diam_input -0.05;
  overall_width = inner_diam+zip_tie_thickness*2;

  module profile() {
    for(x=[left,right]) {
      translate([x*(inner_diam/2+zip_tie_thickness/2),overall_width,0]) {
        square([zip_tie_thickness,overall_width*2],center=true);
      }
    }

    intersection() {
      translate([0,-overall_width,0]) {
        square([overall_width*2,overall_width*2],center=true);
      }
      difference() {
        accurate_circle(inner_diam+zip_tie_thickness*2,fn);
        accurate_circle(inner_diam,fn);
      }
    }
  }

  linear_extrude(height=zip_tie_width,convexity=3,center=true) {
    profile();
  }
}

module printed_extrusion_carriage_profile(body_width,body_height) {
  spring_thickness = extrude_width*4;
  spring_gap_width = 1;
  preload = -0.2; // negative makes more slack both for print and UHMWPE tape
  wall_thickness = extrude_width*4;

  cavity_width = body_width - wall_thickness*4;
  cavity_height = body_height - wall_thickness*4;

  module spring_profile() {
    contact_width = 8;

    translate([0,-preload+spring_thickness/2]) {
      translate([left*(y_rail_extrusion_width/2-contact_width/2),0,0]) {
        rounded_square(contact_width,spring_thickness,spring_thickness);
      }
      hull() {
        translate([left*(y_rail_extrusion_width/2-contact_width+spring_thickness/2),0,0]) {
          accurate_circle(spring_thickness,resolution);
        }
        translate([right*(y_rail_extrusion_width/2-spring_thickness),spring_gap_width/2,0]) {
          accurate_circle(spring_thickness,resolution);
        }
      }
      translate([right*(y_rail_extrusion_width/2-spring_thickness),2-spring_thickness/2+spring_gap_width/2,0]) {
        rounded_square(spring_thickness,4,spring_thickness);
      }
    }
  }

  for(z=[top,bottom]) {
    mirror([0,1-z,0]) {
      translate([0,y_rail_extrusion_height/2]) {
        spring_profile();
      }

      for(x=[left,right]) {
        mirror([1-x,0,0]) {
          translate([y_rail_extrusion_width/2,y_rail_extrusion_height/4,0]) {
            rotate([0,0,-90]) {
              spring_profile();
            }
          }
        }
      }
    }
  }

  difference() {
    gap_width = cavity_height - y_rail_extrusion_height;
    rounded_square(body_width,body_height,wall_thickness*8);
    rounded_square(cavity_width,cavity_height,gap_width);
  }
}

/*
translate([-10,0,0]) {
  letter_L();
}

translate([10,0,0]) {
  letter_R();
}
*/
