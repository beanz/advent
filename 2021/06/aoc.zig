const inputfile = @embedFile("input.txt");
const test1file = @embedFile("test1.txt");
const std = @import("std");
const assertEq = std.testing.expectEqual;
const print = std.io.getStdOut().writer().print;

fn fish(in: []const u8, days: usize) usize {
    var f = [_]usize{ 0, 0, 0, 0, 0, 0, 0, 0, 0 };
    for (in) |ch| {
        if (ch < '0') {
            continue;
        }
        f[ch - 48] += 1;
    }
    var z: usize = 0;
    var d: usize = 0;
    while (d < days) : (d += 1) {
        f[(z + 7) % 9] += f[z];
        z = (z + 1) % 9;
    }
    var c: usize = 0;
    for (f) |fc| {
        c += fc;
    }
    return c;
}

test "examples" {
    try assertEq(@as(usize, 5), fish(test1file, 1));
    try assertEq(@as(usize, 6), fish(test1file, 2));
    try assertEq(@as(usize, 7), fish(test1file, 3));
    try assertEq(@as(usize, 9), fish(test1file, 4));
    try assertEq(@as(usize, 10), fish(test1file, 5));
    try assertEq(@as(usize, 11), fish(test1file, 9));
    try assertEq(@as(usize, 26), fish(test1file, 18));
    try assertEq(@as(usize, 5934), fish(test1file, 80));
    try assertEq(@as(usize, 26984457539), fish(test1file, 256));
    try assertEq(@as(usize, 365131), fish(inputfile, 80));
    try assertEq(@as(usize, 1650309278600), fish(inputfile, 256));
}

pub fn main() anyerror!void {
    try print("Part1: {}\n", .{fish(inputfile, 80)});
    try print("Part2: {}\n", .{fish(inputfile, 256)});
}
