use <../filament-drive.scad>;

mirror([1,0,0]) {
  rotate([180,0,0]) {
    motor_mount_brace();
  }
}
