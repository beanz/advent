const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases([8]u8, parts);
}

fn parts(inp: []const u8) anyerror![2][8]u8 {
    var b: [8]u8 = .{0} ** 8;
    var p1: [8]u8 = .{0} ** 8;
    std.mem.copyForwards(u8, &b, inp[0..8]);
    var p1_done = false;
    var seen: [256]usize = .{0} ** 256;
    var seen_val: usize = 0;
    while (true) {
        var i: usize = 7;
        while (true) : (i -= 1) {
            b[i] += 1;
            if (b[i] == 'i' or b[i] == 'l' or b[i] == 'o') {
                b[i] += 1;
            }
            if (b[i] <= 'z') {
                break;
            }
            b[i] = 'a';
            if (i == 0) {
                break;
            }
        }
        var has_bad = false;
        for (0..7) |k| {
            if (b[k] == 'i' or b[k] == 'l' or b[k] == 'o') {
                has_bad = true;
                break;
            }
        }
        if (has_bad) {
            continue;
        }
        const has_straight =
            (b[1] == b[0] + 1 and b[2] == b[0] + 2) or
            (b[2] == b[1] + 1 and b[3] == b[1] + 2) or
            (b[3] == b[2] + 1 and b[4] == b[2] + 2) or
            (b[4] == b[3] + 1 and b[5] == b[3] + 2) or
            (b[5] == b[4] + 1 and b[6] == b[4] + 2) or
            (b[6] == b[5] + 1 and b[7] == b[5] + 2);
        if (!has_straight) {
            continue;
        }
        seen_val += 1;
        var num_pairs: usize = 0;
        for (0..7) |k| {
            if (b[k] == b[k + 1] and seen[b[k]] != seen_val) {
                seen[b[k]] = seen_val;
                num_pairs += 1;
            }
        }
        if (num_pairs < 2) {
            continue;
        }
        if (!p1_done) {
            std.mem.copyForwards(u8, &p1, b[0..8]);
            p1_done = true;
            continue;
        }
        break;
    }
    return [2][8]u8{ p1, b };
}

fn day(inp: []const u8, bench: bool) anyerror!void {
    const p = try parts(inp);
    if (!bench) {
        aoc.print("Part1: {s}\nPart2: {s}\n", .{ p[0], p[1] });
    }
}

pub fn main() anyerror!void {
    try aoc.benchme(aoc.input(), day);
}
