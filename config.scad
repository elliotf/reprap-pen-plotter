pi = 3.14159;
approx_pi = 3.14159;
inch = 25.4;
extrude_width = 0.4;


//
// filament drive system
//
groove_height  = 0.7;
groove_depth   = 0.5;

driver_wraps         = 5;
idler_wraps          = driver_wraps + 1;

steps_per_turn = 200*32; // 1.8deg stepper at 1/32 microstepping
desired_steps_per_mm = 140;
// driver_circumference = 25*2; // akin to a 20T gt2 pulley
driver_circumference = steps_per_turn/desired_steps_per_mm;

driver_diam = driver_circumference/pi;

ptfe_bushing_diam = 4;
ptfe_bushing_preload_amount = 0.0; // undersize by this much to ensure no slop

idler_top_bottom_groove_dist = (idler_wraps-1)*groove_height+(idler_wraps-1)*(groove_depth*2);
pulley_idler_height = idler_top_bottom_groove_dist + groove_height + groove_depth*4;

625_bearing_id        = 5;
625_bearing_od        = 16; // 625zz v-groove for filament
625_bearing_thickness = 5;  // 625zz v-groove for filament

line_height            = 1;
line_thickness         = 1;
line_bearing_diam      = 16-0.5*2; // 625zz v-groove for filament
line_bearing_thickness = 5;  // 625zz v-groove for filament
line_bearing_inner     = 5;

bearing_bevel_height = 1;

// 625
// pulley_idler_bearing_id     = 5;
//pulley_idler_bearing_od     = 16;
//pulley_idler_bearing_height = 5;

// MR105 or 623
//pulley_idler_bearing_od     = 10.2;
//pulley_idler_bearing_height = 4;

// 688 bearing
pulley_idler_bearing_id     = 8;
pulley_idler_bearing_od     = 16.2;
pulley_idler_bearing_height = 4;

pulley_idler_diam = pulley_idler_bearing_od + (extrude_width*7);

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

//base_plate_thickness = 3/4*inch;
base_plate_thickness = 1/2*inch;

m5_bolt_diam        = 5.25;
m5_bolt_head_height = 5;
m5_bolt_head_diam   = 10;
m5_nut_thickness    = 5;
m3_bolt_diam        = 3.25;
m3_bolt_head_height = 5;
m3_bolt_head_diam   = 7;

spacer  = 1;

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

zip_tie_thickness = 2;
zip_tie_width     = 4;

wall_thickness = extrude_width*4;

y_rail_extrusion_width = 20;
y_rail_extrusion_height = 40;
x_rail_extrusion_width = 40;
x_rail_extrusion_height = 20;
extrusion_screw_hole = 5;

y_rail_dist_above_plate = 10;

z_rod_diam  = 3;

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

// FIXME: base this on actual things rather than random numbers
line_bearing_above_extrusion = printed_carriage_wall_thickness+bearing_bevel_height+line_bearing_thickness/2;

// new sketch
gap_between_x_rail_end_and_y_carriage = 1;
x_rail_end_relative_to_y_rail_x = left*(10 + printed_carriage_outer_skin_from_extrusion + gap_between_x_rail_end_and_y_carriage);
x_rail_end_relative_to_y_rail_z = 6.4;

x_carriage_width = 50;
x_carriage_line_spacing = 20 - line_bearing_diam;

z_carriage_carrier_room_for_nut = m3_nut_max_diam + printed_carriage_inner_diam + 2;
z_carriage_carrier_hole_spacing_x = x_carriage_width - z_carriage_carrier_room_for_nut;
z_carriage_carrier_hole_spacing_z = x_carriage_overall_height + z_carriage_carrier_room_for_nut;
z_carriage_carrier_height = z_carriage_carrier_hole_spacing_z + z_carriage_carrier_room_for_nut;
