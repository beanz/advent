const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

const Int = i32;

fn parts(inp: []const u8) anyerror![2]usize {
    const nums: []Int = parse: {
        var nums: [5000]Int = undefined;
        var l: usize = 0;
        var it = aoc.intIter(Int, inp);
        while (it.next()) |n| {
            nums[l] = n;
            l += 1;
        }
        break :parse nums[0..l];
    };
    return [2]usize{ @intCast(mix(nums, 1, 1)), @intCast(mix(nums, 10, 811589153)) };
}

fn mix(nums: []const Int, rounds: usize, key: isize) isize {
    const len = nums.len;
    const leni: isize = @intCast(len);
    var idx: []usize = init: {
        var idx: [5000]usize = undefined;
        for (0..len) |i| {
            idx[i] = i;
        }
        break :init idx[0..len];
    };
    for (0..rounds) |_| {
        for (nums, 0..) |n, i| {
            const num = n * key;
            var j: usize = 0;
            while (idx[j] != i) : (j += 1) {}
            const nii: isize = @rem(@as(isize, @intCast(j)) + num, leni - 1);
            const ni: usize = @intCast(if (nii < 0) nii + leni - 1 else nii);
            switch (std.math.order(ni, j)) {
                .gt => std.mem.copyForwards(usize, idx[j..ni], idx[j + 1 .. ni + 1]),
                .lt => std.mem.copyBackwards(usize, idx[ni + 1 .. j + 1], idx[ni..j]),
                else => {},
            }
            idx[ni] = i;
        }
    }
    var zero: usize = 0;
    while (nums[zero] != 0) : (zero += 1) {}
    var nZero: usize = 0;
    while (idx[nZero] != zero) : (nZero += 1) {}
    return nums[idx[(nZero + 1000) % len]] * key + nums[idx[(nZero + 2000) % len]] * key + nums[idx[(nZero + 3000) % len]] * key;
}

fn day(inp: []const u8, bench: bool) anyerror!void {
    const p = try parts(inp);
    if (!bench) {
        aoc.print("Part1: {}\nPart2: {}\n", .{ p[0], p[1] });
    }
}

pub fn main() anyerror!void {
    try aoc.benchme(aoc.input(), day);
}
