const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

const SIZE = 512;
const MAP_SIZE = SIZE * SIZE;
const OFFSET = SIZE / 2;

const Node1 = enum(u1) {
    Clean,
    Infected,
};

const Node2 = enum(u2) {
    Clean,
    Weakened,
    Infected,
    Flagged,
};

fn parts(inp: []const u8) anyerror![2]usize {
    const w = std.mem.indexOfScalar(u8, inp, '\n') orelse unreachable;
    const p1 = try bursts(Node1, 10000, inp, w);
    const p2 = try bursts(Node2, 10000000, inp, w);
    return [2]usize{ p1, p2 };
}

fn bursts(comptime T: type, comptime n: usize, inp: []const u8, w: usize) anyerror!usize {
    var map: [MAP_SIZE]T = .{T.Clean} ** MAP_SIZE;
    const w1 = w + 1;
    const h = inp.len / w1;
    const cx = w / 2;
    const cy = h / 2;
    for (0..h) |y| {
        for (0..w) |x| {
            if (inp[x + y * w1] == '#') {
                map[(OFFSET - cx + x) + (OFFSET - cy + y) * SIZE] = T.Infected;
            }
        }
    }
    var c: usize = 0;
    var x: isize = 256;
    var y: isize = 256;
    var dx: isize = 0;
    var dy: isize = -1;
    for (0..n) |_| {
        const i = @as(usize, @intCast(x + y * SIZE));
        switch (T) {
            Node1 => {
                switch (map[i]) {
                    Node1.Clean => {
                        const t = dx;
                        dx = dy;
                        dy = -t;
                        map[i] = Node1.Infected;
                        c += 1;
                    },
                    Node1.Infected => {
                        const t = dx;
                        dx = -dy;
                        dy = t;
                        map[i] = Node1.Clean;
                    },
                }
            },
            Node2 => {
                switch (map[i]) {
                    Node2.Clean => {
                        const t = dx;
                        dx = dy;
                        dy = -t;
                        map[i] = Node2.Weakened;
                    },
                    Node2.Weakened => {
                        map[i] = Node2.Infected;
                        c += 1;
                    },
                    Node2.Infected => {
                        const t = dx;
                        dx = -dy;
                        dy = t;
                        map[i] = Node2.Flagged;
                    },
                    Node2.Flagged => {
                        dx = -dx;
                        dy = -dy;
                        map[i] = Node2.Clean;
                    },
                }
            },
            else => unreachable,
        }
        x += dx;
        y += dy;
    }
    return c;
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
