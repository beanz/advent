const std = @import("std");
const Args = std.process.args;
const warn = std.debug.warn;
const math = std.math;
const aoc = @import("aoc-lib.zig");
const assert = std.testing.expect;
const assertEq = std.testing.expectEqual;

const input = @embedFile("input.txt");
const test1file = @embedFile("test1.txt");
const test2file = @embedFile("test2.txt");
const test3file = @embedFile("test3.txt");
const test4file = @embedFile("test4.txt");
const test5file = @embedFile("test5.txt");
const test6file = @embedFile("test6.txt");
const test7file = @embedFile("test7.txt");
const stdout = &std.io.getStdOut().outStream();
const alloc = std.heap.page_allocator;

fn calc(nums: []const i64, maxTurn: i64) i64 {
    var lastSeen = std.AutoHashMap(i64, i64).init(alloc);
    var n: i64 = undefined;
    var p: i64 = undefined;
    var t: i64 = 1;
    while (t <= maxTurn) {
        if (t <= nums.len) {
            n = nums[math.absCast(t - 1)];
        } else {
            if (lastSeen.get(p)) |lt| {
                n = t - 1 - lt;
            } else {
                n = 0;
            }
        }
        if (t > 1) {
            lastSeen.put(p, t-1) catch unreachable;
        }
        p = n;
        //if ((@mod(t,100000)) == 0) {
        //   warn("{}: {}\n", .{ t, n });
        //}
        t += 1;
    }
    return n;
}

fn part1(in: []const i64) i64 {
    return calc(in, 2020);
}

fn part2(in: []const i64) i64 {
    return calc(in, 30000000);
}

test "examples" {
    const test1 = try aoc.readInts(test1file);
    const test2 = try aoc.readInts(test2file);
    const test3 = try aoc.readInts(test3file);
    const test4 = try aoc.readInts(test4file);
    const test5 = try aoc.readInts(test5file);
    const test6 = try aoc.readInts(test6file);
    const test7 = try aoc.readInts(test7file);
    const inp = try aoc.readInts(input);

    var r: i64 = 436;
    assertEq(r, part1(test1));
    r = 1;
    assertEq(r, part1(test2));
    r = 10;
    assertEq(r, part1(test3));
    r = 27;
    assertEq(r, part1(test4));
    r = 78;
    assertEq(r, part1(test5));
    r = 438;
    assertEq(r, part1(test6));
    r = 1836;
    assertEq(r, part1(test7));
    r = 260;
    assertEq(r, part1(inp));

    // r = 175594;
    // assertEq(r, part2(test1));
    // r = 2578;
    // assertEq(r, part2(test2));
    // r = 3544142;
    // assertEq(r, part2(test3));
    // r = 261214;
    // assertEq(r, part2(test4));
    // r = 6895259;
    // assertEq(r, part2(test5));
    // r = 18;
    // assertEq(r, part2(test6));
    // r = 362;
    // assertEq(r, part2(test7));
    // r = 950;
    // assertEq(r, part2(inp));
}

pub fn main() anyerror!void {
    var args = Args();
    const arg0 = args.next(alloc).?;
    var ints: []const i64 = undefined;
    if (args.next(alloc)) |_| {
        ints = try aoc.readInts(test1file);
    } else {
        ints = try aoc.readInts(input);
    }
    try stdout.print("Part1: {}\n", .{part1(ints)});
    try stdout.print("Part2: {}\n", .{part2(ints)});
}
