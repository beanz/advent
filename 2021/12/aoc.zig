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
    var rev: [16][2]u8 = undefined;
    rev[0] = [2]u8{ 's', 't' };
    rev[1] = [2]u8{ 'e', 'n' };
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
                    rev[ids[n].?] = [2]u8{ inp[i - 2], inp[i - 1] };
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
                    rev[ids[n].?] = [2]u8{ inp[i - 2], inp[i - 1] };
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
    var mem: [MEM_SIZE]u32 = .{0} ** MEM_SIZE;
    return [2]u32{ solve(rev, mem[0..], adj, small, false), solve(rev, mem[0..], adj, small, true) };
}

const MEM_SIZE = 2097152;

fn solve(rev: [16][2]u8, mem: []u32, adj: [16]u16, small: u16, part2: bool) u32 {
    @memset(mem, 0);
    var s: [100]u8 = .{32} ** 100;
    s[0] = 's';
    s[1] = 't';
    s[2] = ',';
    return search(rev, mem, adj, small, part2, START, 0, 3, s[0..]);
}

inline fn key(twice: bool, cur: u4, visited: u16) usize {
    return @as(usize, @intFromBool(twice)) + (@as(usize, @intCast(cur)) << 17) + (@as(usize, @intCast(visited)) << 1);
}

fn search(rev: [16][2]u8, mem: []u32, adj: [16]u16, small: u16, twice: bool, cur: u4, visited: u16, sl: usize, s: []u8) u32 {
    const k: usize = key(twice, cur, visited);
    var st = mem[k];
    if (st > 0) {
        return st;
    }
    var next = adj[cur];
    if (next & END_BIT != 0) {
        next ^= END_BIT;
        st += 1;
        aoc.print("P: {s}end\n", .{s[0..sl]});
    }
    var bit = aoc.biterator(u16, next);
    while (bit.next()) |n| {
        const to = @as(u4, @intCast(n));
        const nBit = @as(u16, 1) << to;
        const big = small & nBit == 0;
        if (big or visited & nBit == 0) {
            s[sl] = rev[to][0];
            s[sl + 1] = rev[to][1];
            s[sl + 2] = ',';
            st += search(rev, mem, adj, small, twice, to, visited | nBit, sl + 3, s);
        } else if (twice) {
            s[sl] = rev[to][0];
            s[sl + 1] = rev[to][1];
            s[sl + 2] = ',';
            st += search(rev, mem, adj, small, false, to, visited | nBit, sl + 3, s);
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
