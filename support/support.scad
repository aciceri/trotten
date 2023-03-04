module motore() {
    cylinder(56, 18.5, 18.5, $fn=72);
}

module involucro() {
    
  difference() {
    translate([0, 0, 2]) cylinder(58, 18.5+2, 18.5+2, $fn=72);
    motore();
    translate([0,7,5]) cylinder(58, 7, 7, $fn=72);
    translate([15.5,0,5]) cylinder(58, 1, 1, $fn=72);
    translate([-15.5,0,5]) cylinder(58, 1, 1, $fn=72);
    translate([15.5*cos(60),15.5*sin(60),5]) cylinder(58, 1, 1, $fn=72);
    translate([15.5*cos(120),15.5*sin(120),5]) cylinder(58, 1, 1, $fn=72);
    translate([15.5*cos(240),15.5*sin(240),5]) cylinder(58, 1, 1, $fn=72);
    translate([15.5*cos(300),15.5*sin(300),5]) cylinder(58, 1, 1, $fn=72);
    translate([-50, -85, 10]) cube([100, 100, 40]);
  }
  
}

module coso() {
    difference() {
        translate([-14, 15, 2]) cube([28, 7.5, 58]);
        hull() involucro();
    }
}

difference() {
    union() {
        coso();
        involucro();
        translate([-25, 19.5, 5]) cube([50, 3, 10]);
        translate([-25, 19.5, 47]) cube([50, 3, 10]);
    }
    translate([21,50,10]) rotate([90, 0, 0]) cylinder(58, 0.8, 0.8, $fn=72);
    translate([-21,50,10]) rotate([90, 0, 0]) cylinder(58, 0.8, 0.8, $fn=72);
    translate([21,50,52]) rotate([90, 0, 0]) cylinder(58, 0.8, 0.8, $fn=72);
    translate([-21,50,52]) rotate([90, 0, 0]) cylinder(58, 0.8, 0.8, $fn=72);
}