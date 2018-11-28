include <../libs/MCAD/stepper.scad>
use <Limit_Switch_v1_0.scad>
use <../libs/parametric_involute_gear_v5.0.scad>
use <../libs/spur_generator.scad>
//$fs=0.5;
dip_width=10;
thickness=4;
internal_width=130;
safe_space=5;

teeth1=50;
teeth2=24;
circular_pitch=fit_spur_gears(teeth1,teeth2,57);
gear_thickness=thickness;
R_gear=gear_outer_radius(teeth1,circular_pitch);
r_gear=gear_outer_radius(teeth2,circular_pitch);
d_cutout=65;
gear_spacing=60;
soda_spacing=70;

main_axel_diameter=8;

slide_angle=5;
dispenser_length=460;
slide_length=[for(i=[thickness,soda_spacing+1.5*thickness])(dispenser_length-i)/cos(slide_angle)];	
sinus_dip_length=150;

small_gear_pos=[0,30,motorWidth(model=Nema17)/2];
motor_pos=small_gear_pos-[0,10,0];
motor_mount_pos=motor_pos+[0,1,0];
motor_mount_dip_offset=motorWidth(model=Nema17)/2-dip_width/2;
big_gear_pos1=small_gear_pos+[sqrt(pow(r_gear+R_gear,2)-pow(R_gear-r_gear,2)),0,R_gear-r_gear];
big_gear_pos2=big_gear_pos1-[0,gear_spacing,0];
main_axel_pos=[[big_gear_pos1.x,0,0],
				[big_gear_pos1.x,-50,0],
				[big_gear_pos1.x,50,0]];
axel_mount_dip_offset=main_axel_diameter/2+dip_width/2;
main_slide_pos=[big_gear_pos1.x,0,big_gear_pos1.z]+
		[R_gear+safe_space+thickness/2,0,
		-tan(slide_angle)*(R_gear+safe_space)+main_axel_diameter/2+thickness*1.5];
loader_plate_length=safe_space+motorWidth(model=Nema17)/2+main_slide_pos.x-thickness;
loader_plate_pos=[loader_plate_length/2-motorWidth(model=Nema17)/2-safe_space,0,0];
loader_plate_dip_pos=[for(i=[-1,1])
					loader_plate_pos+[i*(loader_plate_length/2-dip_width),0,-thickness/2]];
loader_plate_front_dip_pos=[for(i=[-1,1]*internal_width/6) 
		loader_plate_pos+[(loader_plate_length+thickness)/2,i,0]];

main_slide_dip_pos=[for(i=[0:3]) 
	[-cos(slide_angle),0,sin(slide_angle)
	]*(i*(slide_length[0]-(2*safe_space+dip_width))/3+safe_space+dip_width/2)
	+main_slide_pos];

main_side_length=dispenser_length+thickness;
main_side_height=main_slide_pos.z+sin(slide_angle)*slide_length[1]+soda_spacing/2+1.5*thickness;
main_side_pos=[for(y=(internal_width/2+thickness/2)*[-1,1])
		[-main_side_length/2+main_slide_pos.x,y,main_side_height/2-thickness]];

main_backplate_pos=[main_slide_pos.x-dispenser_length-thickness/2,0,main_side_pos[0].z];
main_backplate_dip_pos=[for(i=[-1,1]*main_side_height/3)
		[main_backplate_pos.x-0.1,0,i+main_backplate_pos.z]];

stack_side_height=soda_spacing+sin(slide_angle)*(slide_length[1]-soda_spacing/cos(slide_angle));
stack_side_pos=[for(i=[0:len(main_side_pos)-1])
		main_side_pos[i]+[0,0,(stack_side_height+main_side_height)/2]];

stack_backplate_pos=main_backplate_pos+[0,0,(stack_side_height+main_side_height)/2];

stack_slide_pos=main_slide_pos+
		[-cos(slide_angle),0,sin(slide_angle)]*slide_length[1]+[-1.5*thickness,0,soda_spacing];
stack_slide_dip_pos=[for(i=[0:3]) 
	[cos(slide_angle),0,sin(slide_angle)
	]*(i*(slide_length[1]-(2*safe_space+dip_width))/3+safe_space+dip_width/2)
	+stack_slide_pos];
stack_backplate_dip_pos=[for(i=[-1,1]*stack_side_height/3)
		[stack_backplate_pos.x,0,i+stack_backplate_pos.z]];
stack_front_pos=stack_backplate_pos+[dispenser_length,0,0];
limit_switch_pos=big_gear_pos2+[2*R_gear/3,-11-thickness/2,-10];
limit_switch_rot=[90,0,180];
limit_switch_width=6;
limit_switch_mount_pos=[for(x=[-1,1]*(limit_switch_width+thickness)/2)
		[limit_switch_pos.x+x,limit_switch_pos.y+0.7,0]];
limit_switch_dip_pos=[for(i=[0:len(limit_switch_mount_pos)-1])
		limit_switch_mount_pos[i]+[0,2.35+2.5/2-dip_width/2,0]];
		
front_io_height=main_slide_pos.z+thickness/2;
front_io_pos=main_slide_pos-[thickness/2,0,main_slide_pos.z/2+3*thickness/4];
//front_io_dip_pos=[for(i=[-1,1]*(internal_width+thickness)/2) 
//		front_io_pos+[0,i,-front_io_height/2+dip_width/2]];
	
ramp_length=sqrt(pow(3*(internal_width+2*thickness),2)+pow(main_slide_pos.z,2));
ramp_angle=asin(main_slide_pos.z/ramp_length);
ramp_backplate_pos=[-3*(internal_width+2*thickness)+thickness/2,0,main_slide_pos.z/2-tan(ramp_angle)*thickness];
ramp_backplate_height=main_slide_pos.z-tan(ramp_angle)*thickness;


// Modules
module dip_square(center=true) {
	square([thickness,dip_width],center=center);
}
module dip_sinus_polygon(length=40,d=0){
	w=6;
	A=10;
	xA=2*15/w;
	m=(w/2)*xA;
	y=[for(i=[0:w-1]) A*sin(i*360/w)];
	translate([d*xA*w/2,0,0])
	polygon(points=concat([
		[0,-A]],
		[for(X=[0:xA*w/2:length-m])for(x=[0:w/2-1])
		[X+x*xA,y[(X/xA+x)%w]]],[[length,-A]])); 
}
module big_gear() {
	translate([0,0,-gear_thickness/2])
	color("YellowGreen")
	difference() {
	gear(number_of_teeth=teeth1,
		circular_pitch=circular_pitch,
		pressure_angle=20,
		rim_thickness=gear_thickness,
		hub_thickness=gear_thickness,
		gear_thickness=gear_thickness,
		bore_diameter=main_axel_diameter);
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
module stack_side(dip=true,mirrored=false) {
	l=main_side_length;
	h=stack_side_height;
	sdl=sinus_dip_length;
	rotate([90,0,0])
	translate([0,0,-thickness/2])
	linear_extrude(height=thickness)
	difference() {
		union(){
			square([l,h],center=true);
			translate([0,-h/2,0])
				rotate([0,0,180])
				translate([-sdl/2,0,0])
				dip_sinus_polygon(length=sdl,d=1);
			if(dip)
				translate([0,h/2,0])
				translate([-sdl/2,0,0])
				dip_sinus_polygon(length=sdl,d=1);
		}
		translate([0,-h/2,0])
			rotate([0,0,180])
			translate([-sdl/2,0,0])
			mirror([0,1,0])
			dip_sinus_polygon(length=sdl,d=0);
		if(dip)
			translate([0,h/2,0])
			translate([-sdl/2,0,0])
			mirror([0,1,0])
			dip_sinus_polygon(length=sdl,d=0);
		mirror([0,mirrored?1:0,0])
		translate(-[stack_side_pos[0].x,stack_side_pos[0].z,0]){
			disp= !mirrored?0:soda_spacing;
			for(i=[0:len(stack_slide_dip_pos)-1])
				translate(-[disp,0,0])
				translate([stack_slide_dip_pos[i].x,stack_slide_dip_pos[i].z,0])
				rotate([0,0,90+slide_angle]) dip_square();
			for(x=[0,dispenser_length+0.2])
			for(i=[0:len(stack_backplate_dip_pos)-1])
				translate([stack_backplate_dip_pos[i].x-0.1+x,stack_backplate_dip_pos[i].z,0])
					dip_square();
		}
	}
}
module stack_backplate (dip=true,dib=true,first=false) {
	h=stack_side_height;
	w=internal_width;
	l=60;
	rotate([0,90,0])
	translate([0,0,-thickness/2])
	linear_extrude(height=thickness)	
	difference () {
		union() {
			square([h,w],center=true);
			if(dib)
			translate([h/2,0,0])
				rotate([0,0,-90])
				translate([-l/2,0,0])
				dip_sinus_polygon(length=l);
			if(dip)
			translate([-h/2,0,0])
				rotate([0,0,90])
				translate([-l/2,0,0])
				dip_sinus_polygon(length=l);
			translate(-[stack_backplate_pos.z,0,0])
				for(y=[-1,1]*(thickness+w)/2)
				for(x=[0:len(stack_backplate_dip_pos)-1])
					translate([stack_backplate_dip_pos[x].z,y,0])
						rotate([0,0,90]) dip_square();	
			if(first)
			translate([h/2,0,0])
				square([2*thickness,w],center=true);
		}
		if(dib)
		translate([h/2,0,0])
			rotate([0,0,-90])
			mirror([0,1,0])
			translate([-l/2,0,0])
			dip_sinus_polygon(length=l,d=1);
		if(dip)
		translate([-h/2,0,0])
			rotate([0,0,90])
			mirror([0,1,0])
			translate([-l/2,0,0])
			dip_sinus_polygon(length=l,d=1);
		
	}
}
module slide(slids=false){
	sl=slide_length[slids?0:1];
	d=2*thickness;
	l=2*R_gear+safe_space;
	rotate([0,slide_angle,0])
	translate([-sl/2,0,-thickness/2])
	linear_extrude(height=thickness)
	difference(){
		union() {
			square([sl,internal_width],center=true);
			for(y=(internal_width/2+thickness/2)*[-1,1]) 
				for(x=((sl-(2*safe_space+dip_width))/3)*[0,1,2,3])
					translate([x-sl/2+safe_space+dip_width/2,y,0])
						rotate([0,0,90]) dip_square();
		}
		if(slids)
		for(y=[-gear_spacing/2,gear_spacing/2])
			translate([sl/2-thickness-l/2,y,0])
				square([l,d],center=true);
	}
}
module front_io() {
	h=front_io_height;
	w=internal_width;
	rjw=15;
	rjh=10;
	rotate([0,90,0])
	linear_extrude(height=thickness,center=true)
	difference() {
		union() {
			square([h,w],center=true);
			translate([front_io_pos.z,0,0])
			for(i=[0:len(front_io_dip_pos)-1])
				translate([-front_io_dip_pos[i].z,front_io_dip_pos[i].y,0])
					rotate([0,0,90])dip_square();
		}
		for(i=[0:len(loader_plate_front_dip_pos)-1])
			translate([(h-thickness)/2,loader_plate_front_dip_pos[i].y,0])
				dip_square();
		circle(d=25);
		translate([h/2-thickness-rjh,-w/2,0])
			square([rjh,rjw]);
		
				
	}
}
module loader_plate() {
	translate([0,0,-thickness])
		linear_extrude(height=thickness)
			difference () {
				union() {
					square([loader_plate_length,internal_width], center=true);
					translate(-loader_plate_pos){
						for(y=[-1,1]) for(x=[0:len(loader_plate_dip_pos)-1])
							translate([loader_plate_dip_pos[x].x,y*(internal_width/2+thickness/2),0])
								rotate([0,0,90]) dip_square();
						for(pos=[0:len(loader_plate_front_dip_pos)-1])
							translate(loader_plate_front_dip_pos[pos])
								dip_square();
					}
				}
				translate(-loader_plate_pos) {
					for(pos=[0:len(main_axel_pos)-1]) translate(main_axel_pos[pos])
						for(i=[-1,1]) translate([i*axel_mount_dip_offset,0,0])
						rotate([0,0,90])
						dip_square();
					translate(motor_mount_pos)
						for(i=[-1,1]) translate([i*motor_mount_dip_offset,0,0])
							rotate([0,0,90])
								dip_square();	
					for(pos=[0:len(limit_switch_dip_pos)-1])
						translate(limit_switch_dip_pos[pos])
							dip_square();
				}
			}
}
module axel_mount() {
	d=thickness;
	rotate([90,0,0])
	translate([0,0,-thickness/2])
	linear_extrude(height=thickness)
	difference() {
		union() {
		polygon(points=[
			[-dip_width-main_axel_diameter/2,0],
			[-main_axel_diameter/2-d,big_gear_pos1.z],
			[main_axel_diameter/2+d,big_gear_pos1.z],
			[dip_width+main_axel_diameter/2,0],
			[dip_width+main_axel_diameter/2,-thickness],
			[main_axel_diameter/2,-thickness],
			[main_axel_diameter/2,0],
			[-main_axel_diameter/2,0],
			[-main_axel_diameter/2,-thickness],
			[-dip_width-main_axel_diameter/2,-thickness]]);
		translate([0,big_gear_pos1.z,0])
			circle(d=main_axel_diameter+2*d);
		}
		translate([0,big_gear_pos1.z,0])
			circle(d=main_axel_diameter);	
	}
}
module motor_mount() {
	w=motorWidth(model=Nema17);
	rotate([90,0,0])
	translate([0,0,-thickness/2])
	linear_extrude(height=thickness)
	difference() {
		polygon(points=[[-w/2,w/2],
			[w/2,w/2],
			[w/2,-w/2-thickness],
			[w/2-dip_width,-w/2-thickness],
			[w/2-dip_width,-w/2],
			[-w/2+dip_width,-w/2],
			[-w/2+dip_width,-w/2-thickness],
			[-w/2,-w/2-thickness]]);
		circle(d=2+lookup(NemaRoundExtrusionDiameter,Nema17));
		dist=lookup(NemaDistanceBetweenMountingHoles,Nema17);
		for(x=[-1,1]) for(y=[-1,1])
			translate([x*dist/2,y*dist/2,0])
				circle(d=0.5+lookup(NemaMountingHoleDiameter,Nema17));
	}
}
module main_side(dip=true) {
	length=main_side_length;
	height=main_side_height;
	l=sinus_dip_length;
	rotate([90,0,0])
	translate([0,0,-thickness/2])
	linear_extrude(height=thickness)
		union(){ 
			difference() {
				square([length,height],center=true);
				if(dip)
				translate([-l/2,height/2,0])
				mirror([0,1,0])
				dip_sinus_polygon(length=l);
				translate(-[main_side_pos[0].x,main_side_pos[0].z,0]){
				for(i=[0:len(loader_plate_dip_pos)-1])
					translate([loader_plate_dip_pos[i].x,loader_plate_dip_pos[i].z-0.1,0])
						rotate([0,0,90]) dip_square();	
				for(i=[0:len(main_slide_dip_pos)-1])
					translate([main_slide_dip_pos[i].x,main_slide_dip_pos[i].z,0])
						rotate([0,0,90-slide_angle]) dip_square();
				for(i=[0:len(main_backplate_dip_pos)-1])
					translate([main_backplate_dip_pos[i].x,main_backplate_dip_pos[i].z,0])
						dip_square();
				translate([front_io_dip_pos[0].x,front_io_dip_pos[0].z,0])
					dip_square();
				}
			}
			if(dip)
			translate([-l/2,height/2,0])
			dip_sinus_polygon(length=l,d=1);
		}
}
module main_backplate () {
	h=main_side_height;
	w=internal_width;
	l=60;
	rotate([0,90,0])
	translate([0,0,-thickness/2])
	linear_extrude(height=thickness)
	difference() {
		union() {
			square([h,w],center=true);
			translate(-[main_backplate_pos.z,0,0])
				for(y=[-1,1]*(thickness+w)/2)
				for(x=[0:len(main_backplate_dip_pos)-1])
					translate([main_backplate_dip_pos[x].z,y,0])
						rotate([0,0,90]) dip_square();	
			translate([-h/2,-l/2,0])
				rotate([0,0,90])
				dip_sinus_polygon(length=l);
		}
		translate([-h/2,-l/2,0])
			rotate([0,0,90])
			mirror([0,1,0])
			dip_sinus_polygon(length=l,d=1);
	}
}
module limit_switch() {
	Switch();	
}
module limit_switch_mount() {
	dx=2.35;
	dy=9.6/2;
	r=2.5/2;
	s=limit_switch_pos;
	points=[
		[dx-r-safe_space,s.z+dy],
		[dx+r+safe_space,s.z+dy],
		[dx+r+safe_space,0],
		[dx+r,0],
		[dx+r,-thickness],
		[dx+r-dip_width,-thickness],
		[dx+r-dip_width,0],
		[dx+r-dip_width-safe_space,0]];
	rotate([90,0,90])
	linear_extrude(height=thickness,center=true)
	difference() {
		union() {
			polygon(points=points);
			translate([dx,s.z+dy,0])
				circle(r=r+safe_space);
		}
	for(y=[-1,1]*dy) translate([dx,y+s.z,0])
		circle(r=r);
	}
}
module ramp_backplate(dxf=false) {

	rotate([0,dxf?0:90,0])
		linear_extrude(height=thickness,center=true)	
			square([ramp_backplate_height,soda_spacing],center=true);

}
module ramp_slide(dxf=false) {

	rotate([0,dxf?0:ramp_angle,0])
		linear_extrude(height=thickness)
			translate([-ramp_length/2,0,0])
				square([ramp_length,soda_spacing],center=true);

}
module ramp_support_side(dxf=false){

	wt=2*tan(ramp_angle/2)*dip_width;
	

}
module ramp() {
	ramp_slide();
	translate(ramp_backplate_pos)
		ramp_backplate();
}
!ramp();
module loader() {
	//Make gear teeth lineup correctly
	gv=acos(sqrt(pow(r_gear+R_gear,2)-pow(R_gear-r_gear,2))/(R_gear+r_gear));
	translate(motor_pos)
		motor(Nema17, orientation=[90,0,0]);
	translate(small_gear_pos) 
		rotate([90,0,0])
		rotate([0,0,gv])
			small_gear();
	translate(big_gear_pos1)
		rotate([90,0,0])
		rotate([0,0,gv])
			big_gear();
	translate(big_gear_pos2)
		rotate([90,0,0])
		rotate([0,0,gv])
			big_gear();
%	translate(motor_mount_pos)
		motor_mount();
%	for(i=[0:len(main_axel_pos)-1])
		translate(main_axel_pos[i])
			axel_mount();
	translate(loader_plate_pos)
		loader_plate();
%	translate(front_io_pos)
		front_io();
	translate(main_slide_pos)
		slide(slids=true);
%	for(i=[0:len(main_side_pos)-1])
		translate(main_side_pos[i])
			main_side();
	translate(main_backplate_pos)
		main_backplate();
	translate(limit_switch_pos)
		rotate(limit_switch_rot)
		limit_switch();
	for(i=[0:len(limit_switch_mount_pos)-1])
		color("DarkCyan")
		translate(limit_switch_mount_pos[i])
			limit_switch_mount();
	translate([0,0,10]){
%		for(i=[0:len(stack_side_pos)-1])
			translate(stack_side_pos[i])
				stack_side();
%		translate(stack_backplate_pos)
			stack_backplate();
		translate(stack_slide_pos)
			rotate([0,0,180])
				slide(slids=false);
		translate(stack_front_pos)
			stack_backplate(dib=false, first=true);
	}
}
module dxf () {
	projection(){
		rotate([90,0,0])
			main_side();	
		translate([0,internal_width+2*safe_space,0])
				rotate([0,-slide_angle,0])
				slide(slids=true);
		translate([2*R_gear,internal_width+2*safe_space,0])	
				big_gear();
		translate([4*R_gear,internal_width+2*safe_space,0])	
				small_gear();
		translate(-[0,internal_width+2*safe_space,0])
				loader_plate();	
		translate(-[100,internal_width+2*safe_space,0])
				rotate([0,90,0])
				front_io();
		translate(-[250,internal_width+2*safe_space,0])
				rotate([0,90,0])
				main_backplate();
		translate(-[-100,internal_width+2*safe_space,0])
				rotate([0,90,0])
				limit_switch_mount();	
		translate(-[-200,internal_width+2*safe_space,0])
				rotate([90,0,0])
				motor_mount();
		translate(-[-300,internal_width+2*safe_space,0])
				rotate([90,0,0])
				axel_mount();
		translate(2*[0,internal_width+2*safe_space,0]-[0.6*dispenser_length,0,0])
				rotate([90,0,0])
				stack_side(mirrored=true);
		translate(2*[0,internal_width+2*safe_space,0]+[0.6*dispenser_length,0,0])
				rotate([90,0,0])
				stack_side(mirrored=false);
		translate(3*[0,internal_width+2*safe_space,0]+[100,0,0])
				rotate([0,90,0])
				stack_backplate();
		translate(3*[0,internal_width+2*safe_space,0]+[-100,0,0])
				rotate([0,90,0])
				stack_backplate(dib=false,first=true);
		translate(4*[0,internal_width+2*safe_space,0])
				rotate([0,-slide_angle,0])
				slide(slids=false);
	}


}
dxf();
translate([0,0,200])
loader();
