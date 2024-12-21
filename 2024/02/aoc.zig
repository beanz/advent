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
    while (i < inp.len) : (i += 1) {
        var l = try std.BoundedArray(isize, 16).init(0);
        while (inp[i] != '\n') {
            const a = try aoc.chompUint(isize, inp, &i);
            try l.append(a);
            if (inp[i] == '\n') {
                break;
            }
            i += 1;
        }
        const s = l.slice();
        if (safe(s)) {
            p1 += 1;
            p2 += 1;
        } else if (safe2(s)) {
            p2 += 1;
        }
    }
    return [2]usize{ p1, p2 };
}

fn safe2(nums: []const isize) bool {
    if (safe(nums[1..])) {
        return true;
    }
    if (safe(nums[0 .. nums.len - 1])) {
        return true;
    }
    for (1..nums.len - 1) |i| {
        if (safeWithSkip(nums, i)) {
            return true;
        }
    }
    return false;
}

fn safeWithSkip(nums: []const isize, skip: usize) bool {
    var inc = false;
    var dec = false;
    var p = nums[0];
    for (1..nums.len) |i| {
        if (i == skip) {
            continue;
        }
        const d = p - nums[i];
        switch (d) {
            -1, -2, -3 => {
                inc = true;
            },
            1, 2, 3 => {
                dec = true;
            },
            else => return false,
        }
        if (dec and inc) {
            return false;
        }
        p = nums[i];
    }
    return true;
}

fn safe(nums: []const isize) bool {
    var inc = false;
    var dec = false;
    for (1..nums.len) |i| {
        const d = nums[i - 1] - nums[i];
        switch (d) {
            -1, -2, -3 => {
                inc = true;
            },
            1, 2, 3 => {
                dec = true;
            },
            else => return false,
        }
        if (dec and inc) {
            return false;
        }
    }
    return true;
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
