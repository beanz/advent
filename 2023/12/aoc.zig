const std = @import("std");
const aoc = @import("aoc-lib.zig");
const isDigit = std.ascii.isDigit;

test "testcases" {
    try aoc.TestCases(usize, parts);
}

fn parts(inp: []const u8) anyerror![2]usize {
    var p1: usize = 0;
    var p2: usize = 0;
    var nums = try std.BoundedArray(usize, 256).init(0);
    var i: usize = 0;
    while (i < inp.len) : (i += 1) {
        var start = i;
        var end = std.mem.indexOfScalar(u8, inp[i..], ' ') orelse unreachable;
        i += end + 1;
        while (i < inp.len) : (i += 1) {
            var n = try aoc.chompUint(usize, inp, &i);
            try nums.append(n);
            if (inp[i] == '\n') {
                break;
            }
        }
        var r1 = try solve(inp[start .. start + end], nums.slice(), 1);
        p1 += r1;
        var r2 = try solve(inp[start .. start + end], nums.slice(), 5);
        p2 += r2;
        try nums.resize(0);
    }
    return [2]usize{ p1, p2 };
}

fn solve(inp: []const u8, nums: []const usize, mul: usize) anyerror!usize {
    var mat = try std.BoundedArray(u8, 256).init(0);
    try mat.append('.');
    for (0..nums.len * mul) |i| {
        for (0..nums[i % nums.len]) |_| {
            try mat.append('#');
        }
        try mat.append('.');
    }
    var match = mat.slice();
    var state_count: [256]usize = std.mem.zeroes([256]usize);
    var next_state_count: [256]usize = std.mem.zeroes([256]usize);
    state_count[0] = 1;

    var inpLen = inp.len * mul + (mul - 1);
    for (0..inpLen) |i| {
        var ch = inpChar(inp, i);
        for (0..256) |state| {
            var count = state_count[state];
            if (count == 0) {
                continue;
            }
            state_count[state] = 0;
            if (state + 1 < match.len) {
                if (ch == '?' or (ch == '#' and match[state + 1] == '#') or (ch == '.' and match[state + 1] == '.')) {
                    next_state_count[state + 1] += count;
                }
            }
            if (ch != '#' and match[state] == '.') {
                next_state_count[state] += count;
            }
        }
        std.mem.swap([256]usize, &state_count, &next_state_count);
    }
    return state_count[match.len - 1] + state_count[match.len - 2];
}

fn inpChar(inp: []const u8, i: usize) u8 {
    if ((i % (inp.len + 1)) == inp.len) {
        return '?';
    }
    return inp[i % (inp.len + 1)];
}

fn day(inp: []const u8, bench: bool) anyerror!void {
    var p = try parts(inp);
    if (!bench) {
        aoc.print("Part1: {}\nPart2: {}\n", .{ p[0], p[1] });
    }
}

pub fn main() anyerror!void {
    try aoc.benchme(aoc.input(), day);
}
