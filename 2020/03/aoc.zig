const std = @import("std");
const assert = std.testing.expect;
const assertEq = std.testing.expectEqual;
const warn = std.debug.warn;
const ArrayList = std.ArrayList;

const input = @embedFile("input.txt");
const out = &std.io.getStdOut().outStream();
const alloc = std.heap.page_allocator;

test "examples" {
    const example = @embedFile("test1.txt");
    const map = try readLines(example);
    var r: usize = 7;
    assertEq(r, part1(map));
    r = 336;
    assertEq(r, part2(map));
}

fn isTree(map: std.ArrayListAligned([]const u8, null), x: usize, y: usize) bool {
    const n = map.items[0].len;
    const m = map.items.len;
    return map.items[y % m][x % n] == '#';
}

fn calc(map: std.ArrayListAligned([]const u8, null), sx: usize, sy: usize) usize {
    var trees: usize = 0;
    var x: usize = 0;
    var y: usize = 0;
    while (y < map.items.len) {
        if (isTree(map, x, y)) {
            trees += 1;
        }
        x += sx;
        y += sy;
    }
    return trees;
}

fn part1(map: std.ArrayListAligned([]const u8, null)) usize {
    return calc(map, 3, 1);
}

fn part2(map: std.ArrayListAligned([]const u8, null)) usize {
    var p: usize = 1;
    p *= calc(map, 1, 1);
    p *= calc(map, 3, 1);
    p *= calc(map, 5, 1);
    p *= calc(map, 7, 1);
    p *= calc(map, 1, 2);
    return p;
}

fn readLines(inp: anytype) anyerror!std.ArrayListAligned([]const u8, null) {
    var lines = ArrayList([]const u8).init(alloc);
    var lit = std.mem.split(inp, "\n");
    while (lit.next()) |line| {
        if (line.len == 0) {
            break;
        }
        try lines.append(line);
    }
    return lines;
}

pub fn main() anyerror!void {
    const map = try readLines(input);
    //try out.print("{}\n", .{report.items.len});
    try out.print("Part1: {}\n", .{part1(map)});
    try out.print("Part2: {}\n", .{part2(map)});
}
