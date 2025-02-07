const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

fn parts(inp: []const u8) anyerror![2]usize {
    var s: [1024]u16 = undefined;
    var l: usize = 0;
    var ones: [12]usize = .{0} ** 12;
    var w: u6 = 0;
    {
        var n: u16 = 0;
        var i: usize = 0;
        for (inp) |ch| {
            switch (ch) {
                '\n' => {
                    s[l] = n;
                    l += 1;
                    n = 0;
                    w = @intCast(i);
                    i = 0;
                },
                '0' => {
                    n <<= 1;
                    i += 1;
                },
                '1' => {
                    ones[i] += 1;
                    n <<= 1;
                    n += 1;
                    i += 1;
                },
                else => unreachable,
            }
        }
    }
    var nums = s[0..l];
    var gamma: usize = 0;
    const half = nums.len >> 1;
    for (0..w) |i| {
        if (ones[i] >= half) {
            gamma += @as(usize, 1) << @as(u6, @intCast(w - 1 - i));
        }
    }
    const p1 = gamma * (((@as(usize, 1) << w) - 1) - gamma);
    const oxy = reduce(nums[0..], w, true);
    const co2 = reduce(nums[0..], w, false);
    return [2]usize{ p1, oxy * co2 };
}

fn reduce(nums: []u16, w: usize, most: bool) usize {
    var l = nums.len;
    for (0..w) |i| {
        const bit = @as(usize, 1) << @as(u6, @intCast(w - 1 - i));
        var ones: usize = 0;
        for (0..l) |j| {
            ones += @intFromBool(nums[j] & bit != 0);
        }
        const half = (l + 1) >> 1;
        const keep = if ((ones >= half) == most) bit else 0;
        var n: usize = 0;
        for (0..l) |j| {
            if (nums[j] & bit == keep) {
                std.mem.swap(u16, &nums[n], &nums[j]);
                n += 1;
            }
        }
        if (n == 1) {
            return nums[0];
        }
        l = n;
    }
    return 0;
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
