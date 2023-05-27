use <../moar-wheels.scad>;

mirror([1,0,0]) {
  rotate([0,90,0]) {
    motor_mount_cap();
  }
}
