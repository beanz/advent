const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

const Int = u32;

fn parts(inp: []const u8) anyerror![2]usize {
    const m, const w, const h = parse: {
        var w: Int = 0;
        var x: Int = 0;
        var h: Int = 0;
        var m: [20000]Int = undefined;
        var i: usize = 0;
        for (inp) |ch| {
            switch (ch) {
                '\n' => {
                    w = x;
                    h += 1;
                    x = 0;
                },
                else => {
                    m[i] = @intCast(ch & 0xf);
                    i += 1;
                    x += 1;
                },
            }
        }
        break :parse .{ m[0 .. w * h], w, h };
    };
    return [2]usize{ solve(1, 3, m, w, h), solve(4, 10, m, w, h) };
}

const BUCKETS = 128;
const BUCKET_DEPTH = 192;
const Dir = enum(u1) {
    Horizontal,
    Vertical,
};
const Search = struct {
    x: u8,
    y: u8,
    dir: Dir,
};
fn solve(comptime min: usize, comptime max: usize, m: []const Int, w: Int, h: Int) usize {
    var lengths: [BUCKETS]usize = .{0} ** BUCKETS;
    var work: [BUCKETS * BUCKET_DEPTH]Search = undefined;
    var cost: [20000][2]usize = .{[2]usize{ std.math.maxInt(usize), std.math.maxInt(usize) }} ** 20000;
    work[lengths[0]] = Search{ .x = 0, .y = 0, .dir = Dir.Horizontal };
    lengths[0] += 1;
    work[lengths[0]] = Search{ .x = 0, .y = 0, .dir = Dir.Vertical };
    lengths[0] += 1;
    cost[0][@intFromEnum(Dir.Horizontal)] = 0;
    cost[0][@intFromEnum(Dir.Vertical)] = 0;
    var i: usize = 0;

    while (true) {
        const qi = i & 0x7f;
        for (0..lengths[qi]) |j| {
            const cur = work[qi * BUCKET_DEPTH + j];
            const ci = w * cur.y + cur.x;
            const st = cost[ci][@intFromEnum(cur.dir)];
            if (cur.x == w - 1 and cur.y == h - 1) {
                return st;
            }
            switch (cur.dir) {
                .Vertical => {
                    {
                        var nci = ci;
                        var nst = st;
                        for (1..max + 1) |k| {
                            if (cur.x + @as(u8, @intCast(k)) >= w) {
                                break;
                            }
                            nci += 1;
                            nst += @intCast(m[nci]);
                            if (@as(Int, @intCast(k)) >= min and nst < cost[nci][@intFromEnum(Dir.Horizontal)]) {
                                const heur = heuristic(w, h, cur.x + @as(u8, @intCast(k)), cur.y, nst);
                                work[heur * BUCKET_DEPTH + lengths[heur]] = Search{ .x = cur.x + @as(u8, @intCast(k)), .y = cur.y, .dir = Dir.Horizontal };
                                lengths[heur] += 1;
                                cost[nci][@intFromEnum(Dir.Horizontal)] = nst;
                            }
                        }
                    }
                    {
                        var nci = ci;
                        var nst = st;
                        for (1..max + 1) |k| {
                            if (@as(u8, @intCast(k)) > cur.x) {
                                break;
                            }
                            nci -= 1;
                            nst += @intCast(m[nci]);
                            if (@as(Int, @intCast(k)) >= min and nst < cost[nci][@intFromEnum(Dir.Horizontal)]) {
                                const heur = heuristic(w, h, cur.x - @as(u8, @intCast(k)), cur.y, nst);
                                work[heur * BUCKET_DEPTH + lengths[heur]] = Search{ .x = cur.x - @as(u8, @intCast(k)), .y = cur.y, .dir = Dir.Horizontal };
                                lengths[heur] += 1;
                                cost[nci][@intFromEnum(Dir.Horizontal)] = nst;
                            }
                        }
                    }
                },
                .Horizontal => {
                    {
                        var nci = ci;
                        var nst = st;
                        for (1..max + 1) |k| {
                            if (cur.y + @as(u8, @intCast(k)) >= h) {
                                break;
                            }
                            nci += w;
                            nst += @intCast(m[nci]);
                            if (@as(Int, @intCast(k)) >= min and nst < cost[nci][@intFromEnum(Dir.Vertical)]) {
                                const heur = heuristic(w, h, cur.x, cur.y + @as(u8, @intCast(k)), nst);
                                work[heur * BUCKET_DEPTH + lengths[heur]] = Search{ .x = cur.x, .y = cur.y + @as(u8, @intCast(k)), .dir = Dir.Vertical };
                                lengths[heur] += 1;
                                cost[nci][@intFromEnum(Dir.Vertical)] = nst;
                            }
                        }
                    }
                    {
                        var nci = ci;
                        var nst = st;
                        for (1..max + 1) |k| {
                            if (@as(u8, @intCast(k)) > cur.y) {
                                break;
                            }
                            nci -= w;
                            nst += @intCast(m[nci]);
                            if (@as(Int, @intCast(k)) >= min and nst < cost[nci][@intFromEnum(Dir.Vertical)]) {
                                const heur = heuristic(w, h, cur.x, cur.y - @as(u8, @intCast(k)), nst);
                                work[heur * BUCKET_DEPTH + lengths[heur]] = Search{ .x = cur.x, .y = cur.y - @as(u8, @intCast(k)), .dir = Dir.Vertical };
                                lengths[heur] += 1;
                                cost[nci][@intFromEnum(Dir.Vertical)] = nst;
                            }
                        }
                    }
                },
            }
        }
        lengths[qi] = 0;
        i += 1;
    }
    return 1;
}

fn heuristic(w: Int, h: Int, x: Int, y: Int, cost: usize) usize {
    const p: usize = @intCast(@min(w * h - x - y, w + h / 2));
    return (cost + p) & 0x7f;
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
