const std = @import("std");
const math = std.math;
const aoc = @import("aoc-lib.zig");
const assert = std.testing.expect;
const assertEq = std.testing.expectEqual;
const warn = std.debug.warn;
const ArrayList = std.ArrayList;

const input = @embedFile("input.txt");
const test1file = @embedFile("test1.txt");
const out = &std.io.getStdOut().outStream();
const alloc = std.heap.page_allocator;

test "examples" {
    const test1 = try aoc.readInts(test1file);
    const inp = try aoc.readInts(input);

    var r: i64 = 127;
    assertEq(r, part1(test1, 5));
    r = 62;
    assertEq(r, part2(test1, 127));

    r = 31161678;
    assertEq(r, part1(inp, 25));
    r = 5453868;
    assertEq(r, part2(inp, 31161678));
}

fn part1(nums: []const i64, pre: usize) i64 {
    var i = pre;
    while (i < nums.len) {
        var valid = false;
        var j: usize = i - pre;
        while (j <= i) {
            var k: usize = j;
            while (k <= i) {
                if (nums[j] + nums[k] == nums[i]) {
                    valid = true;
                }
                k += 1;
            }
            j += 1;
        }
        if (!valid) {
            return nums[i];
        }
        i += 1;
    }
    return 0;
}

fn part2(nums: []const i64, p1: i64) i64 {
    var n: usize = 1;
    while (n < nums.len) {
        var i: usize = 0;
        while (i < nums.len - n) {
            var s: i64 = 0;
            var min: i64 = math.maxInt(i64);
            var max: i64 = math.minInt(i64);
            var j = i;
            while (j <= i + n) {
                if (nums[j] < min) {
                    min = nums[j];
                }
                if (nums[j] > max) {
                    max = nums[j];
                }
                s += nums[j];
                j += 1;
            }
            if (s == p1) {
                return min + max;
            }
            i += 1;
        }
        n += 1;
    }
    return 0;
}

pub fn main() anyerror!void {
    var nums = try aoc.readInts(input);
    var p1 = part1(nums, 25);
    try out.print("Part1: {}\n", .{p1});
    try out.print("Part2: {}\n", .{part2(nums, p1)});
}
