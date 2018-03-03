
function accurate_diam(diam,sides) = 1 / cos(180/sides) / 2 * diam;

module hole(diam,len,sides=8) {
  rotate([0,0,180/sides]) {
    cylinder(r=accurate_diam(diam,sides),h=len,center=true,$fn=sides);
  }
}

module accurate_circle(diam,sides=8) {
  rotate([0,0,180/sides]) {
    circle(r=accurate_diam(diam,sides),center=true,$fn=sides);
  }
}

module debug_axes() {
  color("red") {
    translate([50,0,0]) cube([100,.2,.2],center=true);
    translate([0,50,0]) cube([.2,100,.2],center=true);
    translate([0,0,50]) cube([.2,.2,100],center=true);
  }
}
