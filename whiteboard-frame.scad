include <config.scad>;
use <sketch-for-simpler.scad>;
use <z-axis-mount.scad>;
use <lib/vitamins.scad>;
use <moar-wheels.scad>;

//debug = 0;
debug = 0;

whiteboard_x = (debug) ? 200 : 580;
whiteboard_y = (debug) ? 200 : 890;

rail_extrusion_length = (debug) ? 280 : 1000;
brace_extrusion_length = (debug) ? 280 : 630;


whiteboard_rim_frontside_width = 22;
whiteboard_rim_backside_width = 14.6;
whiteboard_rim_thickness = 17;
whiteboard_rim_thickness_edge = 14;
whiteboard_rim_thickness_above_surface = 3.7;
whiteboard_rim_thickness_below_surface = 10;
whiteboard_surface_thickness = whiteboard_rim_thickness - whiteboard_rim_thickness_above_surface - whiteboard_rim_thickness_below_surface;

whiteboard_frame_spacing = 1;

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

whiteboard();

frame_outer_width = whiteboard_x+whiteboard_frame_spacing*2+20*2;

echo("frame_outer_width: ", frame_outer_width);

for(x=[left,right]) {
  translate([x*(frame_outer_width/2-20/2),0,40/2]) {
    rotate([90,0,0]) {
      rotate([0,0,90]) {
        color("lightgrey") extrusion_2040(rail_extrusion_length);
      }
    }
  }
}

for(y=[front,0,rear]) {
  echo("overall_height: ", whiteboard_y-whiteboard_rim_backside_width+40);
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
