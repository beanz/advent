usingnamespace @import("aoc-lib.zig");

pub fn Part1(s: [][]const u8) usize {
    var t: usize = 0;
    return t;
}

pub fn Part2(s: [][]const u8) usize {
    var t: usize = 0;
    return t;
}

test "examples" {
    const test1 = readLines(test1file);
    const inp = readLines(inputfile);

    assertEq(@as(usize, 0), Part1(test1));
    assertEq(@as(usize, 0), Part2(test1));
    assertEq(@as(usize, 0), Part1(inp));
    assertEq(@as(usize, 0), Part2(inp));
}

pub fn main() anyerror!void {
    const lines = readLines(input());
    try print("Part1: {}\n", .{Part1(lines)});
    try print("Part2: {}\n", .{Part2(lines)});
}
