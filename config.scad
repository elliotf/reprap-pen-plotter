include <lib/vitamins.scad>;

colors = ["royalblue", "green", "crimson"];

function lineColorForSide(side) = colors[side+1];

pi = 3.141592;
approx_pi = 3.14159;
inch = 25.4;
extrude_width = 0.4;

debug = 1;

y_rail_len = (debug) ? 200 : 500;
x_rail_len = (debug) ? 200 : 500;

tolerance = 0.2;

//
// filament drive system
//
groove_height  = 0.7;
groove_depth   = 0.5;

driver_wraps         = 5;
idler_wraps          = driver_wraps + 1;

steps_per_turn = 200*32; // 1.8deg stepper at 1/32 microstepping
desired_steps_per_mm = 140; // 200 = 16T GT2, 160 = 20T GT2
driver_circumference = steps_per_turn/desired_steps_per_mm;

driver_diam = driver_circumference/pi;

gt2_16t_pulley_diam = 2*16/pi;
gt2_20t_pulley_diam = 2*20/pi;

ptfe_bushing_diam = 4;
ptfe_bushing_preload_amount = 0.0; // undersize by this much to ensure no slop

idler_top_bottom_groove_dist = (idler_wraps-1)*groove_height+(idler_wraps-1)*(groove_depth*2);
pulley_idler_height = idler_top_bottom_groove_dist + groove_height + groove_depth*4;

625_bearing_id        = 5;
625_bearing_od        = 16; // 625zz v-groove for filament
625_bearing_thickness = 5;  // 625zz v-groove for filament

mr105_bearing_id        = 5;
mr105_bearing_od        = 10;
mr105_bearing_thickness = 4;

line_height            = 1;
line_thickness         = 1;
line_bearing_diam      = 16-0.5*2; // 625zz v-groove for filament
line_bearing_thickness = 5;  // 625zz v-groove for filament
line_bearing_inner     = 5;

bearing_bevel_height = 1;

// 625
//pulley_idler_bearing_id     = 5;
//pulley_idler_bearing_od     = 16;
//pulley_idler_bearing_height = 5;

// MR105 or 623
//pulley_idler_bearing_id     = 3; // 623
pulley_idler_bearing_id     = 5; // MR105
pulley_idler_bearing_od     = 10;
pulley_idler_bearing_height = 4;

// 688 bearing
//pulley_idler_bearing_id     = 8;
//pulley_idler_bearing_od     = 16;
//pulley_idler_bearing_height = 5;

//pulley_idler_diam = pulley_idler_bearing_od + tolerance + (extrude_width*10);
pulley_idler_diam = 16 + tolerance + (extrude_width*10);

//
// plotter
//

resolution = 32;
left    = -1;
right   = 1;
front   = -1;
rear    = 1;
top     = 1;
bottom  = -1;
m3_diam = 3.3;
m3_nut_diam = 5.7; // actually 5.5, but add fudge
m3_nut_max_diam = 6.2;
m3_nut_height = 5; // theoretically actually only 4mm

//base_plate_thickness = 3/4*inch;
base_plate_thickness = 1/2*inch;

m5_bolt_diam        = 5.25;
m5_bolt_head_height = 5;
m5_bolt_head_diam   = 9;
m5_nut_thickness    = 5;
m3_bolt_diam        = 3.25;
m3_bolt_head_height = 5;
m3_bolt_head_diam   = 6;

spacer  = 1;

nema17_side = 42;
nema17_len = 48;
nema17_hole_spacing = 31;
nema17_shoulder_diam = 22;
nema17_shoulder_height = 2;
nema17_screw_diam = m3_diam;
nema17_shaft_diam = 5;
nema17_shaft_len = 26;

nema14_side = 35.3;
nema14_len = 44;
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

zip_tie_thickness = 2.5;
zip_tie_width     = 4;

wall_thickness = extrude_width*3;
carriage_wall_thickness = extrude_width*4;

y_rail_extrusion_width = 20;
y_rail_extrusion_height = 40;
x_rail_extrusion_width = 40;
x_rail_extrusion_height = 20;
extrusion_screw_hole = 5;

y_rail_dist_above_plate = 15;

z_rod_diam  = 3;

m2_threaded_insert_diam = 3.4;
m2_5_threaded_insert_diam = 3.6;
m3_threaded_insert_diam = 5.4;
m2_5_loose_hole = 2.5 + 0.3;
m3_loose_hole = 3.4;
m5_tight_hole = 5;
m5_loose_hole = 5.2;
m5_thread_into_plastic_hole_diam = 4.65;
m4_thread_into_plastic_hole_diam = 3.7;
m3_thread_into_plastic_hole_diam = 2.8;
m2_5_thread_into_plastic_hole_diam = 2.5-0.2;
m2_thread_into_plastic_hole_diam = 2-0.2;


printed_carriage_extrusion_carriage_gap = ptfe_bushing_diam*0.3 - ptfe_bushing_preload_amount;
printed_carriage_outer_skin_from_extrusion = ptfe_bushing_diam -ptfe_bushing_preload_amount + extrude_width *6;
printed_carriage_wall_thickness = printed_carriage_outer_skin_from_extrusion - printed_carriage_extrusion_carriage_gap;
printed_carriage_bushing_len = 10;
printed_carriage_bushing_from_end = 2.5;
printed_carriage_inner_diam = printed_carriage_extrusion_carriage_gap*2;
printed_carriage_outer_diam = (printed_carriage_outer_skin_from_extrusion-printed_carriage_extrusion_carriage_gap)*2;

x_carriage_overall_depth = x_rail_extrusion_width+printed_carriage_outer_skin_from_extrusion*2;
x_carriage_overall_height = x_rail_extrusion_height+printed_carriage_outer_skin_from_extrusion*2;

x_carriage_opening_depth  = x_rail_extrusion_width + printed_carriage_extrusion_carriage_gap*2;
x_carriage_opening_height = x_rail_extrusion_height + printed_carriage_extrusion_carriage_gap*2;
x_carriage_wall_thickness = (x_carriage_overall_height - x_carriage_opening_height)/2;

y_carriage_opening_depth  = y_rail_extrusion_width + printed_carriage_extrusion_carriage_gap*2;
y_carriage_opening_height = y_rail_extrusion_height + printed_carriage_extrusion_carriage_gap*2;
y_carriage_wall_thickness = (x_carriage_overall_height - x_carriage_opening_height)/2;

line_bearing_above_extrusion = printed_carriage_wall_thickness+bearing_bevel_height+line_bearing_thickness/2;

// new sketch
gap_between_x_rail_end_and_y_carriage = 1;
x_rail_end_relative_to_y_rail_x = left*(10 + printed_carriage_outer_skin_from_extrusion + gap_between_x_rail_end_and_y_carriage);
x_rail_end_relative_to_y_rail_z = 6.4;

x_carriage_width = 50;
x_carriage_line_spacing = 20 - line_bearing_diam;

z_carriage_carrier_room_for_nut = m3_threaded_insert_diam + wall_thickness*2 + printed_carriage_inner_diam + 2;
//z_carriage_carrier_hole_spacing_x = x_carriage_width - z_carriage_carrier_room_for_nut;
z_carriage_carrier_hole_spacing_x = round_nema14_hole_spacing - 2;// - 5;
echo("z_carriage_carrier_hole_spacing_x: ", z_carriage_carrier_hole_spacing_x);
z_carriage_carrier_hole_spacing_z = x_carriage_overall_height + m3_threaded_insert_diam;
z_carriage_carrier_height = 36; //z_carriage_carrier_hole_spacing_z + m3_threaded_insert_diam + extrude_width*16;

z_spring_wire_diam = 0.5;
z_spring_diam = 6;
z_spring_screw_diam = 3;
z_spring_len = 25;
z_spring_preload = 3; // to keep sprint under tension
z_spring_center_to_center = z_spring_len - z_spring_diam + z_spring_screw_diam - z_spring_preload;

z_stepper_pos_x = 1;
z_stepper_angle = 0;
z_bushing_id = 3.8;
z_bushing_od = 6;
clearance_for_z_bushings_and_zip_ties = z_bushing_od + 0.5;

y_rail_pos_x = x_rail_len/2 + -1*(x_rail_end_relative_to_y_rail_x);
y_rail_pos_z = y_rail_dist_above_plate + 20;
x_rail_pos_z = y_rail_pos_z + x_rail_end_relative_to_y_rail_z;
x_line_pos_z = x_rail_pos_z + x_rail_extrusion_height/2+line_bearing_above_extrusion;

motor_line_pos_z = x_line_pos_z - (idler_wraps) * (groove_height + groove_depth*1.5); // FIXME: this is slightly off.  :(

x_line_pos_x = x_rail_len/2;
motor_line_pos_x = x_line_pos_x + (pulley_idler_diam + line_thickness/2);

motor_pos_x = x_line_pos_x + (abs(motor_line_pos_x) - abs(x_line_pos_x))/2;

motor_mount_wall_thickness = extrude_width*6;
motor_mount_motor_opening = tolerance*2 + motor_side;

plate_anchor_thickness = wall_thickness*2;
plate_anchor_screw_hole_diam = line_bearing_inner;
plate_anchor_diam = line_bearing_inner + wall_thickness*4;

z_stepper_body_diam = round_nema14_body_diam;
z_stepper_hole_spacing = round_nema14_hole_spacing;
z_stepper_shaft_diam = round_nema14_shaft_diam;
z_stepper_shaft_length = round_nema14_shaft_len;
z_stepper_shaft_flat_length = round_nema14_shaft_flat_len;
z_stepper_shaft_flat_thickness = round_nema14_shaft_flat_thickness;
z_stepper_shaft_flat_offset = round_nema14_shaft_flat_offset;
z_stepper_shoulder_diam = round_nema14_shoulder_diam;
z_stepper_shoulder_height = round_nema14_shoulder_height;
z_stepper_shaft_from_center = round_nema14_shaft_from_center;
z_stepper_dist_from_x_rail_z = z_carriage_carrier_height/2 + z_stepper_body_diam/2 + 5;
z_stepper_extra_meat_for_set_screw = -2; // for long-shaft nema14 stepper

// z_stepper_body_diam = byj_body_diam;
// z_stepper_hole_spacing = byj_hole_spacing;
// z_stepper_shaft_diam = byj_shaft_diam;
// z_stepper_shaft_length = byj_shaft_len;
// z_stepper_shaft_flat_length = byj_shaft_flat_len;
// z_stepper_shaft_flat_thickness = byj_shaft_flat_thickness;
// z_stepper_shaft_flat_offset = byj_shaft_flat_offset;
// z_stepper_shoulder_diam = byj_shoulder_diam;
// z_stepper_shoulder_height = byj_shoulder_height;
// z_stepper_shaft_from_center = byj_shaft_from_center;
// z_stepper_dist_from_x_rail_z = z_carriage_carrier_height/2 + z_stepper_body_diam/2 + 5;
// z_stepper_extra_meat_for_set_screw = 4; // for byj stepper

z_limit_switch_pos_x = -z_carriage_carrier_hole_spacing_x/4;
