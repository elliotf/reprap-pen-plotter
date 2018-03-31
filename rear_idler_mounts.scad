include <main.scad>;

for(side=[0,1]) {
  mirror([side,0,0]) {
    translate([5,0,0]) {
      rotate([0,0,-90]) {
        color(colors[side]) rear_idler_mount(side);
      }
    }
  }
}
