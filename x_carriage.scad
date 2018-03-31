include <main.scad>;

translate([0,0,x_carriage_overall_depth+x_carriage_opening_height]) {
  rotate([0,0,0]) {
    // x_carriage();
  }
}

rotate([0,90,0]) {
  x_carriage();
}
//x_carriage_assembly();
