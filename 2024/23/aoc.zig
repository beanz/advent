const std = @import("std");
const aoc = @import("aoc-lib.zig");
const isDigit = std.ascii.isDigit;

test "testcases" {
    try aoc.TestCasesRes(Res, parts);
}

const Res = struct {
    p1: usize,
    p2: [38]u8,
};

fn parts(inp: []const u8) anyerror!Res {
    var g: [456976]bool = .{false} ** 456976;
    var nodes: []usize = undefined;
    {
        var n = try std.BoundedArray(usize, 1024).init(0);
        var dedup: [676]bool = .{false} ** 676;
        var i: usize = 0;
        while (i < inp.len) : (i += 6) {
            const a = num(inp[i], inp[i + 1]);
            const b = num(inp[i + 3], inp[i + 4]);
            g[(a * 676) + b] = true;
            g[(b * 676) + a] = true;
            if (!dedup[a]) {
                try n.append(a);
                dedup[a] = true;
            }
            if (!dedup[b]) {
                try n.append(b);
                dedup[b] = true;
            }
        }
        nodes = n.slice();
    }
    var p1: usize = 0;
    for (0..nodes.len) |i| {
        const a = nodes[i];
        for (i + 1..nodes.len) |j| {
            const b = nodes[j];
            if (!g[(a * 676) + b]) {
                continue;
            }

            for (j + 1..nodes.len) |k| {
                const c = nodes[k];
                if (!g[(a * 676) + c] or !g[(b * 676) + c]) {
                    continue;
                }
                if (has_t(a) or has_t(b) or has_t(c)) {
                    p1 += 1;
                }
            }
        }
    }
    var best = try std.BoundedArray(usize, 32).init(0);
    {
        var dedup: [676]bool = .{false} ** 676;
        var set = try std.BoundedArray(usize, 32).init(0);
        for (0..nodes.len) |i| {
            const a = nodes[i];
            if (dedup[a]) {
                continue;
            }
            dedup[a] = true;
            try set.append(a);
            for (0..nodes.len) |j| {
                if (i == j) {
                    continue;
                }
                const b = nodes[j];
                if (!g[(a * 676) + b]) {
                    continue;
                }
                var l: usize = 0;
                for (set.slice()) |c| {
                    if (g[(b * 676) + c]) {
                        l += 1;
                    }
                }
                if (l == set.len) {
                    dedup[b] = true;
                    try set.append(b);
                }
            }
            if (set.len > best.len) {
                const tmp = best;
                best = set;
                set = tmp;
            }
            try set.resize(0);
        }
    }
    const p2 = best.slice();
    std.mem.sort(usize, p2, {}, comptime std.sort.asc(usize));
    var p2r: [38]u8 = .{32} ** 38;
    const n = name(p2[0]);
    p2r[0] = n[0];
    p2r[1] = n[1];
    for (1..p2.len) |i| {
        const j = 2 + (i - 1) * 3;
        const nn = name(p2[i]);
        p2r[j] = ',';
        p2r[j + 1] = nn[0];
        p2r[j + 2] = nn[1];
    }
    return Res{ .p1 = p1, .p2 = p2r };
}

inline fn name(a: usize) [2]u8 {
    return [2]u8{ @as(u8, @intCast(a / 26)) + 'a', @as(u8, @intCast(a % 26)) + 'a' };
}

inline fn num(a: u8, b: u8) usize {
    return (@as(usize, (a - 'a')) * 26) + @as(usize, b - 'a');
}

inline fn has_t(a: usize) bool {
    return (a / 26) == 19;
}

fn day(inp: []const u8, bench: bool) anyerror!void {
    const p = try parts(inp);
    if (!bench) {
        aoc.print("Part1: {}\nPart2: {s}\n", .{ p.p1, p.p2 });
    }
}

pub fn main() anyerror!void {
    try aoc.benchme(aoc.input(), day);
}
