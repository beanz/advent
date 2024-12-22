const std = @import("std");
const aoc = @import("aoc-lib.zig");
const isDigit = std.ascii.isDigit;

test "testcases" {
    try aoc.TestCases(usize, parts);
}

fn parts(inp: []const u8) anyerror![2]usize {
    var i: usize = 0;
    var rules: [13000]bool = .{false} ** 13000;
    while (i < inp.len) : (i += 1) {
        const a = try aoc.chompUint(u16, inp, &i);
        i += 1;
        const b = try aoc.chompUint(u16, inp, &i);
        rules[(a << 7) + b] = true;
        if (inp[i + 1] == '\n') {
            i += 2;
            break;
        }
    }
    var p1: usize = 0;
    var p2: usize = 0;
    while (i < inp.len) {
        var ns = try std.BoundedArray(u16, 128).init(0);
        while (i < inp.len) {
            const n = try aoc.chompUint(u16, inp, &i);
            try ns.append(n);
            if (inp[i] == '\n') {
                i += 1;
                break;
            }
            i += 1;
        }

        const nums = ns.slice();
        if (std.sort.isSorted(u16, nums, rules, rules_cmp)) {
            const mid = nums[nums.len / 2];
            p1 += mid;
            continue;
        }
        std.mem.sort(u16, nums, rules, rules_cmp);
        const mid2 = nums[nums.len / 2];
        p2 += mid2;
    }

    return [2]usize{ p1, p2 };
}

fn rules_cmp(rules: [13000]bool, a: u16, b: u16) bool {
    return rules[(a << 7) + b];
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
