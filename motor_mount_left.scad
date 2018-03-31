include <main.scad>;

for(side=[1]) {
  mirror([side,0,0]) {
    rotate([45,0,0]) {
      color(colors[side]) motor_mount();
    }
  }
}
