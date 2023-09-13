const std = @import("std");
const aoc = @import("aoc-lib.zig");

fn fuel1(a: usize, b: usize) usize {
    return aoc.absCast(@as(isize, @intCast(a)) - @as(isize, @intCast(b)));
}

test "fuel1" {
    try aoc.assertEq(@as(usize, 14), fuel1(16, 2));
    try aoc.assertEq(@as(usize, 1), fuel1(1, 2));
    try aoc.assertEq(@as(usize, 0), fuel1(2, 2));
    try aoc.assertEq(@as(usize, 2), fuel1(0, 2));
    try aoc.assertEq(@as(usize, 2), fuel1(4, 2));
    try aoc.assertEq(@as(usize, 0), fuel1(2, 2));
    try aoc.assertEq(@as(usize, 5), fuel1(7, 2));
    try aoc.assertEq(@as(usize, 1), fuel1(1, 2));
    try aoc.assertEq(@as(usize, 0), fuel1(2, 2));
    try aoc.assertEq(@as(usize, 12), fuel1(14, 2));
}

fn fuelsum1(p: usize, inp: []const usize) usize {
    var c: usize = 0;
    for (inp) |v| {
        c += fuel1(p, v);
    }
    return c;
}

fn part1(inp: []usize) usize {
    std.mem.sort(usize, inp, {}, std.sort.asc(usize));
    return fuelsum1(inp[inp.len / 2], inp);
}

test "part1" {
    var crabs = try aoc.Ints(aoc.talloc, usize, aoc.test1file);
    defer aoc.talloc.free(crabs);
    try aoc.assertEq(@as(usize, 37), part1(crabs));
    var crabs2 = try aoc.Ints(aoc.talloc, usize, aoc.inputfile);
    defer aoc.talloc.free(crabs2);
    try aoc.assertEq(@as(usize, 336701), part1(crabs2));
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
    var crabs = try aoc.Ints(aoc.talloc, usize, aoc.test1file);
    defer aoc.talloc.free(crabs);
    try aoc.assertEq(@as(usize, 168), part2(crabs));
    var crabs2 = try aoc.Ints(aoc.talloc, usize, aoc.inputfile);
    defer aoc.talloc.free(crabs2);
    try aoc.assertEq(@as(usize, 95167302), part2(crabs2));
}

fn day07(inp: []const u8, bench: bool) anyerror!void {
    var crabs = try aoc.Ints(aoc.halloc, usize, inp);
    defer aoc.halloc.free(crabs);
    var p1 = part1(crabs);
    var p2 = part2(crabs);
    if (!bench) {
        aoc.print("Part 1: {}\nPart 2: {}\n", .{ p1, p2 });
    }
}

pub fn main() anyerror!void {
    try aoc.benchme(aoc.input(), day07);
}
