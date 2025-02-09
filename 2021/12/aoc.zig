const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(u32, parts);
}

fn chompCave(inp: []const u8, i: *usize) u16 {
    const ch0: u16 = @intCast(inp[i.*]);
    i.* += 1;
    const ch1: u16 = @intCast(inp[i.*]);
    i.* += 1;
    switch (ch0) {
        's' => if (ch1 == 't') {
            i.* += 3;
        },
        'e' => if (ch1 == 'n') {
            i.* += 1;
        },
        else => {},
    }
    return (((ch0 & 0x1f) * 26 + (ch1 & 0x1f)) << 1) + @intFromBool(ch0 & 32 != 0);
}

const START_ID = start: {
    var i: usize = 0;
    break :start chompCave("start", &i);
};

const END_ID = end: {
    var i: usize = 0;
    break :end chompCave("end", &i);
};

const START = 0;
const END = 1;
const END_BIT = 1 << END;

fn parts(inp: []const u8) anyerror![2]u32 {
    var adj: [16]u16 = .{0} ** 16;
    var small: u16 = 0b11;
    {
        var ids: [1404]?u4 = .{null} ** 1404;
        ids[START_ID] = START;
        ids[END_ID] = END;
        var l: u4 = 2;
        var i: usize = 0;
        while (i < inp.len) : (i += 1) {
            const from = from: {
                const n = chompCave(inp, &i);
                if (ids[n] == null) {
                    ids[n] = l;
                    l += 1;
                }
                const id = ids[n].?;
                small |= @as(u16, n & 1) << id;
                break :from id;
            };
            i += 1;
            const to = to: {
                const n = chompCave(inp, &i);
                if (ids[n] == null) {
                    ids[n] = l;
                    l += 1;
                }
                const id = ids[n].?;
                small |= @as(u16, n & 1) << id;
                break :to id;
            };
            if (to != 0) {
                adj[from] |= @as(u16, 1) << to;
            }
            if (to != 1 and from != 0) {
                adj[to] |= @as(u16, 1) << from;
            }
        }
    }
    return [2]u32{ solve(adj, small, false), solve(adj, small, true) };
}

const MEM_SIZE = 131072;

fn solve(adj: [16]u16, small: u16, part2: bool) u32 {
    var mem: [MEM_SIZE]u32 = .{0} ** MEM_SIZE;
    return search(mem[0..], adj, small, part2, START, 0);
}

inline fn key(twice: bool, cur: u4, visited: u16) usize {
    return @as(usize, @intFromBool(twice)) + (@as(usize, @intCast(cur)) << 13) + (@as(usize, @intCast(visited)) << 1);
}

fn search(mem: []u32, adj: [16]u16, small: u16, twice: bool, cur: u4, visited: u16) u32 {
    const k: usize = key(twice, cur, visited);
    var st = mem[k];
    if (st > 0) {
        return st;
    }
    var next = adj[cur];
    if (next & END_BIT != 0) {
        next ^= END_BIT;
        st += 1;
    }
    var bit = aoc.biterator(u16, next);
    while (bit.next()) |n| {
        const to = @as(u4, @intCast(n));
        const nBit = @as(u16, 1) << to;
        const big = small & nBit == 0;
        if (big or visited & nBit == 0) {
            st += search(mem, adj, small, twice, to, visited | nBit);
        } else if (twice) {
            st += search(mem, adj, small, false, to, visited | nBit);
        }
    }
    mem[k] = st;
    return st;
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
