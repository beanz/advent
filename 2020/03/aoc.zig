const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "examples" {
    const map = aoc.readLines(aoc.talloc, aoc.test1file);
    defer aoc.talloc.free(map);
    try aoc.assertEq(@as(usize, 7), part1(map));
    try aoc.assertEq(@as(usize, 336), part2(map));
    const map2 = aoc.readLines(aoc.talloc, aoc.inputfile);
    defer aoc.talloc.free(map2);
    try aoc.assertEq(@as(usize, 169), part1(map2));
    try aoc.assertEq(@as(usize, 7560370818), part2(map2));
}

fn isTree(map: [][]const u8, x: usize, y: usize) bool {
    const n = map[0].len;
    const m = map.len;
    return map[y % m][x % n] == '#';
}

fn calc(map: [][]const u8, sx: usize, sy: usize) usize {
    var trees: usize = 0;
    var x: usize = 0;
    var y: usize = 0;
    while (y < map.len) {
        if (isTree(map, x, y)) {
            trees += 1;
        }
        x += sx;
        y += sy;
    }
    return trees;
}

fn part1(map: [][]const u8) usize {
    return calc(map, 3, 1);
}

fn part2(map: [][]const u8) usize {
    var p: usize = 1;
    p *= calc(map, 1, 1);
    p *= calc(map, 3, 1);
    p *= calc(map, 5, 1);
    p *= calc(map, 7, 1);
    p *= calc(map, 1, 2);
    return p;
}

fn day03(inp: []const u8, bench: bool) anyerror!void {
    const map = aoc.readLines(aoc.halloc, inp);
    defer aoc.halloc.free(map);
    var p1 = part1(map);
    var p2 = part2(map);
    if (!bench) {
        aoc.print("Part 1: {}\nPart 2: {}\n", .{ p1, p2 });
    }
}

pub fn main() anyerror!void {
    try aoc.benchme(aoc.input(), day03);
}
