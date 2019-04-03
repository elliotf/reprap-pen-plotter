include <../config.scad>;

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
  difference() {
    translate([diam/4,diam/4,0]) {
      square([diam/2,diam/2],center=true);
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

/*
translate([-10,0,0]) {
  letter_L();
}

translate([10,0,0]) {
  letter_R();
}
*/
