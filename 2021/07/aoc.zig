usingnamespace @import("aoc-lib.zig");

fn fuel1(a: usize, b: usize) usize {
    return absCast(@intCast(isize, a) - @intCast(isize, b));
}

test "fuel1" {
    try assertEq(@as(usize, 14), fuel1(16, 2));
    try assertEq(@as(usize, 1), fuel1(1, 2));
    try assertEq(@as(usize, 0), fuel1(2, 2));
    try assertEq(@as(usize, 2), fuel1(0, 2));
    try assertEq(@as(usize, 2), fuel1(4, 2));
    try assertEq(@as(usize, 0), fuel1(2, 2));
    try assertEq(@as(usize, 5), fuel1(7, 2));
    try assertEq(@as(usize, 1), fuel1(1, 2));
    try assertEq(@as(usize, 0), fuel1(2, 2));
    try assertEq(@as(usize, 12), fuel1(14, 2));
}

fn fuelsum1(p: usize, inp: []const usize) usize {
    var c: usize = 0;
    for (inp) |v| {
        c += fuel1(p, v);
    }
    return c;
}

fn part1(inp: []usize) usize {
    sort.sort(usize, inp, {}, usizeLessThan);
    return fuelsum1(inp[inp.len / 2], inp);
}

test "part1" {
    var crabs = readInts(test1file, usize);
    defer free(crabs);
    var nums: []usize = dupe(alloc, usize, crabs) catch unreachable;
    defer free(nums);
    try assertEq(@as(usize, 37), part1(nums));
    var crabs2 = readInts(inputfile, usize);
    defer free(crabs2);
    var nums2: []usize = dupe(alloc, usize, crabs2) catch unreachable;
    defer free(nums2);
    try assertEq(@as(usize, 336701), part1(nums2));
}

fn fuel2(a: usize, b: usize) usize {
    var f = fuel1(a, b);
    return f * (f + 1) / 2;
}

fn fuelsum2(p: usize, inp: []const usize) usize {
    var c: usize = 0;
    for (inp) |v| {
        c += fuel2(p, v);
    }
    return c;
}

fn part2(inp: []usize) usize {
    var mean = inp[0];
    var i: usize = 1;
    while (i < inp.len) : (i += 1) {
        mean += inp[i];
    }
    mean /= inp.len;
    var min = fuelsum2(mean, inp);
    var c = fuelsum2(mean + 1, inp);
    if (min > c) {
        min = c;
    }
    return min;
}

test "part2" {
    var crabs = readInts(test1file, usize);
    defer free(crabs);
    var nums: []usize = dupe(alloc, usize, crabs) catch unreachable;
    defer free(nums);
    try assertEq(@as(usize, 168), part2(nums));
    var crabs2 = readInts(inputfile, usize);
    defer free(crabs2);
    var nums2: []usize = dupe(alloc, usize, crabs2) catch unreachable;
    defer free(nums2);
    try assertEq(@as(usize, 95167302), part2(nums2));
}

pub fn main() anyerror!void {
    var crabs = readInts(input(), usize);
    defer free(crabs);
    try print("Part1: {}\n", .{part1(crabs)});
    try print("Part2: {}\n", .{part2(crabs)});
}
