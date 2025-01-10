const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

inline fn initRope(comptime l: usize) [l]u8 {
    var r: [l]u8 = undefined;
    inline for (0..l) |i| {
        r[i] = @as(u8, @intCast(i));
    }
    return r;
}

const SIZE = 256;

fn parts(inp: []const u8) anyerror![2]usize {
    var rows: [128]u128 = .{0} ** 128;
    var p1: usize = 0;
    for (0..128) |y| {
        var rope: [SIZE]u8 = initRope(SIZE);
        var cur: usize = 0;
        var skip: usize = 0;
        for (0..64) |_| {
            {
                var i: usize = 0;
                while (i < inp.len - 1) : (i += 1) {
                    cur = twist(&rope, @as(usize, @intCast(inp[i])), cur, skip);
                    skip += 1;
                }
            }
            cur = twist(&rope, @as(usize, @intCast('-')), cur, skip);
            skip += 1;
            for ([_]usize{ 100, 10 }) |m| {
                if (y < m) {
                    continue;
                }
                const n = (y % (10 * m)) / m;
                cur = twist(&rope, 48 + n, cur, skip);
                skip += 1;
            }
            {
                const n = y % 10;
                cur = twist(&rope, 48 + n, cur, skip);
                skip += 1;
            }
            for ([5]usize{ 17, 31, 73, 47, 23 }) |n| {
                cur = twist(&rope, n, cur, skip);
                skip += 1;
            }
        }
        for (0..16) |i| {
            var sum: u8 = 0;
            for (0..16) |j| {
                sum ^= rope[i * 16 + j];
            }
            const s = @as(u128, @intCast(sum));
            rows[y] |= s << @as(u7, @intCast((15 - i) * 8));
        }
        p1 += @popCount(rows[y]);
    }
    var r: usize = 0;
    var seen: [16384]bool = .{false} ** 16384;
    var back: [16384][2]usize = undefined;
    var todo = aoc.Deque([2]usize).init(back[0..]);
    for (0..128) |y| {
        for (0..128) |x| {
            if (!is_set(rows, x, y)) {
                continue;
            }
            if (seen[x + y * 128]) {
                continue;
            }
            seen[x + y * 128] = true;
            r += 1;
            try todo.push([2]usize{ x, y });
            while (todo.pop()) |cur| {
                if (cur[0] > 0 and !seen[cur[0] - 1 + cur[1] * 128] and is_set(rows, cur[0] - 1, cur[1])) {
                    try todo.push([2]usize{ cur[0] - 1, cur[1] });
                    seen[cur[0] - 1 + cur[1] * 128] = true;
                }
                if (cur[1] > 0 and !seen[cur[0] + cur[1] * 128 - 128] and is_set(rows, cur[0], cur[1] - 1)) {
                    try todo.push([2]usize{ cur[0], cur[1] - 1 });
                    seen[cur[0] + cur[1] * 128 - 128] = true;
                }
                if (cur[0] < 127 and !seen[cur[0] + 1 + cur[1] * 128] and is_set(rows, cur[0] + 1, cur[1])) {
                    try todo.push([2]usize{ cur[0] + 1, cur[1] });
                    seen[cur[0] + 1 + cur[1] * 128] = true;
                }
                if (cur[1] < 127 and !seen[cur[0] + cur[1] * 128 + 128] and is_set(rows, cur[0], cur[1] + 1)) {
                    try todo.push([2]usize{ cur[0], cur[1] + 1 });
                    seen[cur[0] + cur[1] * 128 + 128] = true;
                }
            }
        }
    }

    return [2]usize{ p1, r };
}

fn is_set(r: [128]u128, x: usize, y: usize) bool {
    const bit: u128 = @as(u128, 1) << @as(u7, @intCast(127 - x));
    return r[y] & bit != 0;
}

fn twist(rope: *[256]u8, n: usize, cur: usize, skip: usize) usize {
    std.mem.rotate(u8, rope, cur);
    std.mem.reverse(u8, rope[0..n]);
    std.mem.rotate(u8, rope, SIZE - cur);
    return (cur + n + skip) & 0xff;
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
