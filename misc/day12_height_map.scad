translate([0,0,-6]) cube([643,163,10], center = true);
scale([1, 1, 4]) {
    surface(file = "height_map_avg4.dat", center = true, convexity = 5);
}
