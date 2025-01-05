const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

fn parts(inp: []const u8) anyerror![2]usize {
    var p1: usize = 0;
    var p2: usize = 0;
    var start: usize = 0;
    var i: usize = 0;
    while (i < inp.len) : (i += 1) {
        switch (inp[i]) {
            '\n' => {
                p1 += is_tls(inp[start..i]);
                p2 += is_ssl(inp[start..i]);
                start = i + 1;
            },
            else => {},
        }
    }
    return [2]usize{ p1, p2 };
}

fn is_tls(s: []const u8) usize {
    var outside = true;
    var found: usize = 0;
    for (0..s.len - 3) |i| {
        if (s[i] < 'a') {
            outside = !outside;
            continue;
        }
        if (s[i] != s[i + 1] and s[i] == s[i + 3] and s[i + 1] == s[i + 2]) {
            if (!outside) {
                return 0;
            }
            found = 1;
        }
    }
    return found;
}

fn is_ssl(s: []const u8) usize {
    var out: [858]bool = .{false} ** 858;
    var in: [858]bool = .{false} ** 858;
    var outside = false;
    for (0..s.len - 2) |i| {
        if (s[i] < 'a') {
            outside = !outside;
            continue;
        }
        if (s[i + 1] < 'a' or s[i + 2] < 'a') {
            continue;
        }
        if (s[i] != s[i + 1] and s[i] == s[i + 2]) {
            const k = (@as(usize, s[i] - 'a') << 5) + @as(usize, s[i + 1] - 'a');
            const k2 = (@as(usize, s[i + 1] - 'a') << 5) + @as(usize, s[i] - 'a');
            if (outside) {
                if (in[k2]) {
                    return 1;
                }
                out[k] = true;
            } else {
                if (out[k2]) {
                    return 1;
                }
                in[k] = true;
            }
        }
    }
    return 0;
}

fn aba(in: []const u8, a: u8, b: u8) bool {
    for (0..in.len - 2) |i| {
        if (in[i] == a and in[i + 1] == b and in[i + 2] == a) {
            return true;
        }
    }
    return false;
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
