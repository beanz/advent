const std = @import("std");
const aoc = @import("aoc-lib.zig");
const isDigit = std.ascii.isDigit;

test "testcases" {
    try aoc.TestCases(usize, parts);
}

fn parts(inp: []const u8) anyerror![2]usize {
    var p1: usize = 0;
    var p2: usize = 0;
    var i: usize = 0;
    while (i < inp.len) {
        const total = try aoc.chompUint(usize, inp, &i);
        i += 2;
        var l = try std.BoundedArray(usize, 16).init(0);
        while (inp[i] != '\n') {
            const n = try aoc.chompUint(usize, inp, &i);
            try l.append(n);
            i += 1;
            if (inp[i - 1] == '\n') {
                break;
            }
        }
        const nums = l.slice();
        if (sums(nums, nums.len - 1, total, false)) {
            p1 += total;
            p2 += total;
            continue;
        }
        if (sums(nums, nums.len - 1, total, true)) {
            p2 += total;
        }
    }

    return [2]usize{ p1, p2 };
}

fn sums(nums: []usize, i: usize, total: usize, p2: bool) bool {
    if (i == 0) {
        return nums[i] == total;
    }
    if (total > nums[i] and sums(nums, i - 1, total - nums[i], p2)) {
        return true;
    }
    if (total % nums[i] == 0 and sums(nums, i - 1, total / nums[i], p2)) {
        return true;
    }
    if (!p2) {
        return false;
    }
    const m: usize = if (nums[i] < 10) 10 else (if (nums[i] < 100) 100 else 1000);
    return total % m == nums[i] and sums(nums, i - 1, total / m, p2);
}

fn concat(a: usize, b: usize) usize {
    const l = std.math.log10_int(b) + 1;
    const e = std.math.powi(usize, 10, l) catch unreachable;
    return a * e + b;
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
