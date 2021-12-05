usingnamespace @import("aoc-lib.zig");

test "examples" {
    var scan = readInts(test1file, i64);
    defer free(scan);
    try assertEq(@as(usize, 7), part1(scan));
    try assertEq(@as(usize, 5), part2(scan));
    var scan2 = readInts(inputfile, i64);
    defer free(scan2);
    try assertEq(@as(usize, 1342), part1(scan2));
    try assertEq(@as(usize, 1378), part2(scan2));
}

fn calc(exp: []const i64, n: usize) usize {
    var i: usize = n;
    var c: usize = 0;
    while (i < exp.len) : (i += 1) {
        if (exp[i - n] < exp[i]) {
            c += 1;
        }
    }
    return c;
}

fn part1(exp: []const i64) usize {
    return calc(exp, 1);
}

fn part2(exp: []const i64) usize {
    return calc(exp, 3);
}

pub fn main() anyerror!void {
    var scan = readInts(input(), i64);
    defer free(scan);
    try print("Part1: {}\n", .{part1(scan)});
    try print("Part2: {}\n", .{part2(scan)});
}
