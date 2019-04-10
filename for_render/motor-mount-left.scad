use <../filament-drive.scad>;

left = -1;
mirror([1,0,0]) {
  motor_mount(left);
}
