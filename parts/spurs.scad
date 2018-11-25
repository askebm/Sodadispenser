use <../libs/parametric_involute_gear_v5.0.scad>
use <../libs/spur_generator.scad>

teeth1=50;
teeth2=24;
circular_pitch=fit_spur_gears(teeth1,teeth2,57);
gear_thickness=4;
R_gear=gear_outer_radius(teeth1,circular_pitch);
r_gear=gear_outer_radius(teeth2,circular_pitch);
d_cutout=65;
module big_gear() {
	translate([0,0,-gear_thickness/2])
	color("YellowGreen")
	difference() {
	gear(number_of_teeth=teeth1,
		circular_pitch=circular_pitch,
		pressure_angle=20,
		rim_thickness=gear_thickness,
		hub_thickness=gear_thickness,
		gear_thickness=gear_thickness);
	a=sqrt(pow(gear_thickness*2+d_cutout/2,2)/2);
	rotate([0,0,5])
	translate([a,a,1])
	cylinder(h=gear_thickness*2,d=d_cutout,center=true);
	 }
}
module small_gear() {
	translate([0,0,-gear_thickness/2])
	rotate([0,0,360/(2*teeth2)])
		color("YellowGreen")
		gear(number_of_teeth=teeth2,
			circular_pitch=circular_pitch,
			pressure_angle=20,
			rim_thickness=gear_thickness,
			hub_thickness=gear_thickness,
			gear_thickness=gear_thickness);
}
//big_gear();
//translate([gear_outer_radius(teeth1,circular_pitch)+gear_outer_radius(teeth2,circular_pitch),0,0])
//small_gear();
echo(gear_outer_radius(teeth1,circular_pitch));
echo(gear_outer_radius(teeth2,circular_pitch));
