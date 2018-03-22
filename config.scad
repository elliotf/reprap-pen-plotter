// All hail whosawhatsis
da6 = 1 / cos(180 / 6) / 2;
da8 = 1 / cos(180 / 8) / 2;

pi = 3.14159;

// Screws, nuts
m3_diam = 3.1;
m3_nut_diam  = 5.5 + 0.1;
m3_nut_thickness  = 4;
m3_washer_thickness  = .6;

m5_diam = 5;
m5_nut_diam = 8;
m5_nut_thickness = 5;
m5_washer_thickness  = 1;

m4_diam = 4;
m4_nut_diam = 7;
m4_nut_thickness = 4.5;
m4_washer_thickness  = 1;

bearing_623_diam      = 10;
bearing_623_inner     = 3;
bearing_623_thickness = 4;

bearing_625_diam      = 16;
bearing_625_inner     = 5;
bearing_625_thickness = 5;

approx_pi = 3.14159265359;

laser_cut_kerf = 0.06;

filament_spool_mount_spacer = 4;
filament_spool_inner_diam   = 53;
filament_spool_core_diam    = 93;
filament_spool_outer_diam   = 200;
filament_spool_width        = 71;

// make coordinates more communicative
left    = -1;
right   = 1;
front   = -1;
rear    = 1;
top     = 1;
bottom  = -1;

x = 0;
y = 1;
z = 2;

resolution = 16;
resolution = 64;
resolution = 32;

extrusion_width  = 0.5;
extrusion_height = 0.2;
min_material_thickness = extrusion_width*2;
//wall_thickness         = extrusion_width*4;
rounded_diam           = 4;

// material dimensions
zip_tie_width = 3;
zip_tie_thickness = 2;
line_diam = .5;
line_cube = [line_diam,line_diam,line_diam];

// Printer size
build_x = 200;
build_y = 200;
build_z = 200;

build_x = 150;
build_y = 150;
build_z = 150;

z_belt_clamp_width = 14;

/*
build_x = 100;
build_y = 50;
build_z = 25;

build_x = 100;
build_y = 100;
build_z = 100;
*/

belt_total_thickness = 1.38;
belt_tooth_depth     = 0.75;
belt_thickness       = belt_total_thickness - belt_tooth_depth;
belt_thickness       = 1;
belt_width           = 6; // FIXME: make correct

belt_tooth_pitch   = 2;
num_teeth_to_clamp = 7;
belt_clamp_depth   = belt_width + m3_nut_diam + wall_thickness*1.5 + 1;
belt_clamp_width   = m3_nut_diam + wall_thickness*2;
belt_clamp_height  = num_teeth_to_clamp*belt_tooth_pitch;
z_belt_anchor_height       = belt_clamp_height*1.5;
z_belt_anchor_hole_spacing = z_belt_anchor_height/2;

z_idler_pulley_bearing_retainer_rim_thickness     = 1;
z_idler_pulley_bearing_retainer_thickness         = bearing_625_thickness + z_idler_pulley_bearing_retainer_rim_thickness;

filament_diam = 3;

hotend_diam                = 16;
hotend_groove_diam         = 12;
hotend_groove_height       = 4.6;
hotend_height_above_groove = 5;
hotend_len                 = 63;
hotend_clamped_height      = hotend_groove_height + hotend_height_above_groove;
hotend_len_below_groove    = hotend_len - hotend_clamped_height;
hotend_clearance   = 0.15;

// jhead
hotend_height_above_groove = 4.8;
hotend_groove_height = 4.6;

// e3d v6
hotend_height_above_groove = 3.7;
hotend_groove_height = 6;

// e3d v6 bowden heatsink mount
hotend_len                 = 65;
hotend_height_above_groove = 7;
hotend_height_below_groove = 3;
hotend_groove_height = 6;
hotend_diam = 22.4;
hotend_heatsink_diam = 22.4;
hotend_nozzle_to_bottom_fin = 20;
hotend_nozzle_to_top_fin = 46;
hotend_heatsink_height = 26;
hotend_dist_to_heatsink_bottom = 46;
hotend_dist_to_heatsink_top = hotend_dist_to_heatsink_bottom - hotend_heatsink_height;
hotend_mount_diam  = 16;
hotend_groove_diam = 12;

tuner_hole_to_shoulder = 22.5;
wire_hole_diam = 2;

tuner_thin_diam = 6;
tuner_thin_len_past_hole = 5;
tuner_thin_len = tuner_hole_to_shoulder + tuner_thin_len_past_hole;
tuner_thin_pos = tuner_hole_to_shoulder/2-tuner_thin_len_past_hole/2;

tuner_thick_diam = 10;
tuner_thick_len = 10;
tuner_thick_pos = tuner_hole_to_shoulder-tuner_thick_len+tuner_thick_len/2;

tuner_body_diam = 15;
tuner_body_thickness = 9;
tuner_body_square_len = 10;
tuner_body_pos = -tuner_hole_to_shoulder-tuner_body_thickness/2;

tuner_anchor_screw_hole_thickness = 2;
tuner_anchor_screw_hole_diam = 2;
tuner_anchor_screw_hole_width = 2;
tuner_anchor_screw_hole_pos_x = tuner_body_pos+tuner_body_thickness/2-tuner_anchor_screw_hole_thickness/2;
tuner_anchor_screw_hole_pos_y = -tuner_body_diam/2;
tuner_anchor_screw_hole_pos_z = -tuner_body_diam/2;

// Linear bearings and rods
// should record bearing groove offset, depth, width

// lm10uu, M10 rods
lm10uu_bearing_diam = 19;
lm10uu_bearing_len  = 29;
lm10uu_bearing_groove_spacing = 0;
lm10uu_bearing_groove_width = 0;
lm10uu_bearing_groove_depth = 0;
lm10uu_rod_diam = 10;

// lm8uu, M8 rods
lm8uu_bearing_diam = 15;
lm8uu_bearing_len  = 24;
lm8uu_bearing_groove_spacing = 0;
lm8uu_bearing_groove_width = 0;
lm8uu_bearing_groove_depth = 0;
lm8uu_rod_diam = 8;

// lm8luu, M8 rods
lm8luu_bearing_diam = 15;
lm8luu_bearing_len  = 45;
lm8luu_bearing_groove_spacing = 0;
lm8luu_bearing_groove_width = 0;
lm8luu_bearing_groove_depth = 0;
lm8luu_rod_diam = 8;

// bronze bushings, M8 rods
bronze_bearing_diam = 12;
bronze_bearing_len  = 15;
//bronze_bearing_len  = 30;
bronze_bearing_groove_spacing = 0;
bronze_bearing_groove_width = 0;
bronze_bearing_groove_depth = 0;
bronze_rod_diam = 8;

// lm6uu, M6 rods
lm6uu_bearing_diam = 12;
lm6uu_bearing_len  = 19;
lm6uu_bearing_groove_spacing = 12.25;
lm6uu_bearing_groove_width = .5;
lm6uu_bearing_groove_depth = .2;
lm6uu_rod_diam = 6;

// lm6luu, M6 rods
lm6luu_bearing_diam = 12;
lm6luu_bearing_len  = 35;
lm6luu_bearing_groove_spacing = 12.25;
lm6luu_bearing_groove_width = .5;
lm6luu_bearing_groove_depth = .2;
lm6luu_rod_diam = 6;

// graphite bearings from robotdigg
graphite_bronze_bearing_diam = 11;
graphite_bronze_bearing_len  = 30;
graphite_bronze_bearing_groove_spacing = 0;
graphite_bronze_bearing_groove_width = 0;
graphite_bronze_bearing_groove_depth = 0;
graphite_bronze_rod_diam = 8;

bearing_diam           = lm10uu_bearing_diam;
bearing_len            = lm10uu_bearing_len;
bearing_groove_spacing = lm10uu_bearing_groove_spacing;
bearing_groove_width   = lm10uu_bearing_groove_width;
bearing_groove_depth   = lm10uu_bearing_groove_depth;
rod_diam               = lm10uu_rod_diam;

bearing_diam           = lm8uu_bearing_diam;
bearing_len            = lm8uu_bearing_len;
bearing_groove_spacing = lm8uu_bearing_groove_spacing;
bearing_groove_width   = lm8uu_bearing_groove_width;
bearing_groove_depth   = lm8uu_bearing_groove_depth;
rod_diam               = lm8uu_rod_diam;

/*
bearing_diam           = bronze_bearing_diam;
bearing_len            = bronze_bearing_len;
bearing_groove_spacing = bronze_bearing_groove_spacing;
bearing_groove_width   = bronze_bearing_groove_width;
bearing_groove_depth   = bronze_bearing_groove_depth;
rod_diam               = bronze_rod_diam;

bearing_diam           = lm6uu_bearing_diam;
bearing_len            = lm6uu_bearing_len;
bearing_groove_spacing = lm6uu_bearing_groove_spacing;
bearing_groove_width   = lm6uu_bearing_groove_width;
bearing_groove_depth   = lm6uu_bearing_groove_depth;
rod_diam               = lm6uu_rod_diam;
*/

// if you'd like the x axis to use different rods/bearings
x_bearing_diam           = lm8luu_bearing_diam;
x_bearing_len            = lm8luu_bearing_len;
x_bearing_groove_spacing = lm8luu_bearing_groove_spacing;
x_bearing_groove_width   = lm8luu_bearing_groove_width;
x_bearing_groove_depth   = lm8luu_bearing_groove_depth;
x_rod_diam               = lm8luu_rod_diam;

x_bearing_diam           = lm8uu_bearing_diam;
x_bearing_len            = lm8uu_bearing_len;
x_bearing_groove_spacing = lm8uu_bearing_groove_spacing;
x_bearing_groove_width   = lm8uu_bearing_groove_width;
x_bearing_groove_depth   = lm8uu_bearing_groove_depth;
x_rod_diam               = lm8uu_rod_diam;

x_bearing_diam           = lm6uu_bearing_diam;
x_bearing_len            = lm6uu_bearing_len;
x_bearing_groove_spacing = lm6uu_bearing_groove_spacing;
x_bearing_groove_width   = lm6uu_bearing_groove_width;
x_bearing_groove_depth   = lm6uu_bearing_groove_depth;
x_rod_diam               = lm6uu_rod_diam;

x_bearing_diam           = lm6luu_bearing_diam;
x_bearing_len            = lm6luu_bearing_len;
x_bearing_groove_spacing = lm6luu_bearing_groove_spacing;
x_bearing_groove_width   = lm6luu_bearing_groove_width;
x_bearing_groove_depth   = lm6luu_bearing_groove_depth;
x_rod_diam               = lm6luu_rod_diam;

x_bearing_diam           = graphite_bronze_bearing_diam;
x_bearing_len            = graphite_bronze_bearing_len;
x_bearing_groove_spacing = graphite_bronze_bearing_groove_spacing;
x_bearing_groove_width   = graphite_bronze_bearing_groove_width;
x_bearing_groove_depth   = graphite_bronze_bearing_groove_depth;
x_rod_diam               = graphite_bronze_rod_diam;

/*
// if you'd like the x axis to use the default rods/bearings
x_bearing_diam           = bearing_diam;
x_bearing_len            = bearing_len;
x_bearing_groove_spacing = bearing_groove_spacing;
x_bearing_groove_width   = bearing_groove_width;
x_bearing_groove_depth   = bearing_groove_depth;
x_rod_diam               = rod_diam;
*/

// y bearings
y_bearing_diam           = lm8luu_bearing_diam;
y_bearing_len            = lm8luu_bearing_len;
y_bearing_groove_spacing = lm8luu_bearing_groove_spacing;
y_bearing_groove_width   = lm8luu_bearing_groove_width;
y_bearing_groove_depth   = lm8luu_bearing_groove_depth;
y_rod_diam               = lm8luu_rod_diam;

// y bearings
y_bearing_diam           = graphite_bronze_bearing_diam;
y_bearing_len            = graphite_bronze_bearing_len;
y_bearing_groove_spacing = graphite_bronze_bearing_groove_spacing;
y_bearing_groove_width   = graphite_bronze_bearing_groove_width;
y_bearing_groove_depth   = graphite_bronze_bearing_groove_depth;
y_rod_diam               = graphite_bronze_rod_diam;

// if you'd like the z axis to use different rods/bearings
z_bearing_diam           = lm8uu_bearing_diam;
z_bearing_len            = lm8uu_bearing_len;
z_bearing_groove_spacing = lm8uu_bearing_groove_spacing;
z_bearing_groove_width   = lm8uu_bearing_groove_width;
z_bearing_groove_depth   = lm8uu_bearing_groove_depth;
z_rod_diam               = lm8uu_rod_diam;

/*
z_bearing_diam           = lm8luu_bearing_diam;
z_bearing_len            = lm8luu_bearing_len;
z_bearing_groove_spacing = lm8luu_bearing_groove_spacing;
z_bearing_groove_width   = lm8luu_bearing_groove_width;
z_bearing_groove_depth   = lm8luu_bearing_groove_depth;
z_rod_diam               = lm8luu_rod_diam;

z_bearing_diam           = bearing_diam;
z_bearing_len            = bearing_len;
z_bearing_groove_spacing = bearing_groove_spacing;
z_bearing_groove_width   = bearing_groove_width;
z_bearing_groove_depth   = bearing_groove_depth;
z_rod_diam               = rod_diam;
*/

rod_slop = 0.05;

rod_clamp_height = m3_nut_diam + extrusion_height*4;

// endstop dimensions
endstop_len = 20;
endstop_width = 6;
endstop_height = 8;
endstop_hole_spacing = 10;
endstop_hole_diam = 2;
endstop_hole_from_top = 5;

// Groove bearings
// 625s
line_bearing_diam = 15;
line_bearing_groove_depth = .5;
line_bearing_inner = m5_diam;
line_bearing_thickness = 5;
line_bearing_nut_diam = m5_nut_diam;
line_bearing_nut_thickness = m5_nut_thickness;
line_bearing_washer_thickness = m5_washer_thickness;

// 623vv
/*
*/
line_bearing_diam = 13;
line_bearing_diam = 12;
line_bearing_groove_depth = 2;
line_bearing_groove_depth = 1.7;
line_bearing_inner = m3_diam;
//line_bearing_thickness = 6;
line_bearing_nut_diam = m3_nut_diam;
line_bearing_nut_thickness = m3_nut_thickness;
line_bearing_washer_thickness = m3_washer_thickness;

// 604UU
line_bearing_diam = 13;
line_bearing_groove_depth = 1;
line_bearing_inner = 4;
line_bearing_thickness = 4;
line_bearing_nut_diam = m4_nut_diam;
line_bearing_nut_thickness = m4_nut_thickness;
line_bearing_washer_thickness = m4_washer_thickness;

line_bearing_effective_diam = line_bearing_diam - (line_bearing_groove_depth*2);

pulley_idler_bearing_diam = 16;
pulley_idler_bearing_inner = 5;
pulley_idler_bearing_thickness = 5;

// Motor
nema17_side = 43;
nema17_len = 43;
nema17_hole_spacing = 31;
nema17_shoulder_diam = 22;
nema17_shoulder_height = 2;
nema17_screw_diam = m3_diam;
nema17_shaft_diam = 5;
nema17_shaft_len = 24;

nema14_side = 35.3;
nema14_len = nema14_side;
nema14_hole_spacing = 26;
nema14_shoulder_diam = 22;
nema14_shoulder_height = 2;
nema14_screw_diam = m3_diam;
nema14_shaft_diam = 5;
nema14_shaft_len = 20;

motor_side = nema17_side;
motor_len = nema17_len;
motor_hole_spacing = nema17_hole_spacing;
motor_shoulder_diam = nema17_shoulder_diam;
motor_screw_diam = nema17_screw_diam;
motor_shaft_diam = nema17_shaft_diam;
motor_shaft_len = nema17_shaft_len;
motor_wire_hole_width = 9;
motor_wire_hole_height = 6;

z_motor_side = nema14_side;
z_motor_len = z_motor_side;
z_motor_hole_spacing = nema14_hole_spacing;
z_motor_shoulder_diam = nema14_shoulder_diam;
z_motor_screw_diam = nema14_screw_diam;
z_motor_shaft_diam = nema14_shaft_diam;
z_motor_shaft_len = nema14_shaft_len;

z_motor_side = nema17_side;
z_motor_len = z_motor_side;
z_motor_hole_spacing = nema17_hole_spacing;
z_motor_shoulder_diam = nema17_shoulder_diam;
z_motor_screw_diam = nema17_screw_diam;
z_motor_shaft_diam = nema17_shaft_diam;
z_motor_shaft_len = nema17_shaft_len;

z_line_bearing_diam      = 10;
z_line_bearing_inner     = 3;
z_line_bearing_thickness = 8; // F623ZZ * 2

z_line_bearing_diam      = 10;
z_line_bearing_inner     = 5;
z_line_bearing_thickness = 8; // MF105ZZ * 2
z_pulley_diam            = (16*2)/approx_pi;
z_pulley_diam            = (20*2)/approx_pi;
z_pulley_height          = 10;

z_idler_pulley_diam        = (20*2)/approx_pi; // 20T GT2
z_idler_pulley_diam        = (16*2)/approx_pi; // 16T GT2
z_idler_pulley_height      = 10;

z_pulley_bearing_diam      = 10;
z_pulley_bearing_inner     = 5;
z_pulley_bearing_thickness = 4;

// Frame sheet
//sheet_thickness = 6.5;
//sheet_thickness = 5.2;
sheet_thickness = 4.98;
sheet_min_width = 30;
sheet_shoulder_width = 3; // material to have on the far side of a slot
sheet_screw_diam = m3_diam;
sheet_screw_nut_diam = m3_nut_diam;
sheet_screw_nut_thickness = m3_nut_thickness;
sheet_hole_resolution = resolution;

top_plate_screw_diam = sheet_screw_diam;

// Misc settings
min_material_thickness = 1;
spacer = 1;
clamp_gap_width = spacer;
screw_pad_height = min_material_thickness*2;
screw_pad_outer_diam = top_plate_screw_diam+min_material_thickness*3;
screw_pad_hole_spacing = (rod_diam/2 + min_material_thickness*3 + top_plate_screw_diam/2) * 2;
screw_pad_width = screw_pad_hole_spacing + (top_plate_screw_diam/2 + min_material_thickness*2) * 2;

// Screws
clamp_screw_diam = m3_diam;
clamp_screw_nut_diam = m3_nut_diam;
clamp_screw_nut_thickness = m3_nut_thickness;
clamp_area_width = clamp_screw_diam+min_material_thickness*2;

// calculated rod lengths
//x_rod_len = build_x + x_carriage_width + line_bearing_diam*2 + min_material_thickness;
//y_rod_len = build_y + x_rod_spacing + rod_diam + min_material_thickness*2;
//x_rod_len = 270; // have avail
//y_rod_len = 265; // have avail

// tuner dimensions (pull out into a different file)
tuner_shoulder_width = 10;
tuner_shoulder_diam  = 10;
tuner_shaft_diam     = 6;
tuner_hole_to_shoulder = 22.5;
tensioner_angle = 45;

// Power supply
psu_length = 215;
psu_width = 114;
psu_height = 50;

// Pulley
// pulley_diam = 20;
// pulley_diam = 40/approx_pi; // 32 =~ 16T GT2, 40 =~ 20T GT2
// pulley_diam = 15; // graber cars pulley
// pulley_diam = 18; // graber cars pulley from wolfjm
// pulley_height = line_bearing_diam;
// pulley_height = 13;
// pulley_height = 28; // graber cars pulley from wolfjm

//pulley_idler_height = pulley_height;
//pulley_idler_diam = pulley_idler_bearing_diam + min_material_thickness*2;
//pulley_idler_shaft_diam = m5_diam;
//pulley_idler_shaft_nut_diam = m5_nut_diam;
//pulley_idler_shaft_nut_thickness = m5_nut_thickness;
//pulley_idler_shaft_support_len = pulley_height;

// heated bed / build plate
heatbed_thickness = 1;
heatbed_hole_spacing_x = build_x+9;
heatbed_hole_spacing_y = build_y+9;
heatbed_hole_diam = 3;
heatbed_width = build_x+14;
heatbed_depth = build_y+14;

tuner_nut_flat_diam      = 10;
tuner_nut_max_diam       = 11.5;
tuner_shaft_screw_diam   = 7.75;
tuner_shaft_screwed_diam = 10;
tuner_shaft_screwed_len  = 18.5;

z_build_platform_width = build_x + 25;
z_build_platform_depth = build_y + 25;
