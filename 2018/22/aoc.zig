const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

const Int = usize;

const EXTRA = 32;
const QUEUE_LEN = 500;
const Tool = enum(u2) {
    Neither,
    Torch,
    Climbing,
};
const Sq = enum(u2) {
    Rocky,
    Wet,
    Narrow,
};

fn parts(inp: []const u8) anyerror![2]usize {
    var i: usize = 7;
    const depth = try aoc.chompUint(Int, inp, &i);
    i += 9;
    const tx = try aoc.chompUint(Int, inp, &i);
    i += 1;
    const ty = try aoc.chompUint(Int, inp, &i);
    const w = tx + EXTRA;
    const h = ty + EXTRA;

    var m: [65536]Sq = undefined;
    {
        var g: [65536]Int = undefined;
        g[0] = 0;
        for (1..w) |x| {
            g[x] = (x * 16807 + depth) % 20183;
        }
        for (1..h) |y| {
            g[(y * w)] = (y * 48271 + depth) % 20183;
        }
        for (1..h) |y| {
            for (1..w) |x| {
                const el = if (x == tx and y == ty) 0 else g[(x - 1) + y * w] * g[x + (y - 1) * w];
                g[x + y * w] = (el + depth) % 20183;
            }
        }
        for (0..h) |y| {
            for (0..w) |x| {
                const j = x + y * w;
                m[j] = switch (g[j] % 3) {
                    0 => Sq.Rocky,
                    1 => Sq.Wet,
                    2 => Sq.Narrow,
                    else => unreachable,
                };
            }
        }
    }
    var p1: usize = 0;
    for (0..ty + 1) |y| {
        for (0..tx + 1) |x| {
            p1 += @intFromEnum(m[x + y * w]);
        }
    }

    const Rec = struct { x: i16, y: i16, tool: Tool };
    var work_len: [1500]usize = .{0} ** 1500;
    var work: [1500 * QUEUE_LEN]Rec = undefined;
    var minutes: usize = 0;
    work[0] = Rec{ .x = 0, .y = 0, .tool = Tool.Torch };
    work_len[minutes] += 1;
    var work_i: usize = 0;
    var p2: usize = undefined;
    var visited: [65536 * 4]bool = .{false} ** (65536 * 4);
    while (true) {
        if (work_i >= work_len[minutes]) {
            work_i = 0;
            minutes += 1;
            continue;
        }
        const cur = work[minutes * QUEUE_LEN + work_i];
        work_i += 1;
        if (cur.x == tx and cur.y == ty) {
            p2 = minutes;
            if (cur.tool != Tool.Torch) {
                p2 += 7;
            }
            break;
        }
        const k = ((@as(usize, @intCast(cur.x)) + @as(usize, @intCast(cur.y)) * w) << 2) + @intFromEnum(cur.tool);
        if (visited[k]) {
            continue;
        }
        visited[k] = true;
        for ([_][2]i16{ [2]i16{ 0, -1 }, [2]i16{ 1, 0 }, [2]i16{ 0, 1 }, [2]i16{ -1, 0 } }) |o| {
            const nx = cur.x + o[0];
            const ny = cur.y + o[1];
            if (nx < 0 or ny < 0) {
                continue;
            }
            if (nx >= w or ny >= h) {
                continue;
            }
            const terrain = m[@as(usize, @intCast(nx)) + @as(usize, @intCast(ny)) * w];
            if ((terrain == Sq.Rocky and cur.tool == Tool.Neither) or (terrain == Sq.Wet and cur.tool == Tool.Torch) or (terrain == Sq.Narrow and cur.tool == Tool.Climbing)) {
                continue;
            }
            work[(minutes + 1) * QUEUE_LEN + work_len[minutes + 1]] = Rec{
                .x = nx,
                .y = ny,
                .tool = cur.tool,
            };
            work_len[minutes + 1] += 1;
        }
        const terrain = m[@as(usize, @intCast(cur.x)) + @as(usize, @intCast(cur.y)) * w];
        const altTool = switch (terrain) {
            Sq.Rocky => if (cur.tool == Tool.Climbing) Tool.Torch else Tool.Climbing,
            Sq.Wet => if (cur.tool == Tool.Climbing) Tool.Neither else Tool.Climbing,
            Sq.Narrow => if (cur.tool == Tool.Torch) Tool.Neither else Tool.Torch,
        };
        work[(minutes + 7) * QUEUE_LEN + work_len[minutes + 7]] = Rec{
            .x = cur.x,
            .y = cur.y,
            .tool = altTool,
        };
        work_len[minutes + 7] += 1;
    }
    return [2]usize{ p1, p2 };
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
