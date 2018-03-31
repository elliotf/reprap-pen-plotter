all: carriage rear_idler_mounts z_axis_mount z_carriage motor_mounts

carriage:
	openscad -m make -o x_carriage.stl x_carriage.scad
rear_idler_mounts:
	openscad -m make -o rear_idler_mounts.stl rear_idler_mounts.scad
z_axis_mount:
	openscad -m make -o z_axis_mount.stl z_axis_mount.scad
z_carriage:
	openscad -m make -o z_carriage.stl z_carriage.scad

motor_mounts: motor_mount_left motor_mount_right
motor_mount_left:
	openscad -m make -o motor_mount_left.stl motor_mount_left.scad
motor_mount_right:
	openscad -m make -o motor_mount_right.stl motor_mount_right.scad

.PHONY: all carriage rear_idler_mounts z_axis_mount z_carriage
