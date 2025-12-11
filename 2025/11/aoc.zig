const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

const id_prime = 73;

fn parts(inp: []const u8) anyerror![2]usize {
    var g = std.AutoHashMap(u15, std.ArrayList(u15)).init(aoc.halloc);
    var i: usize = 0;
    while (i < inp.len) : (i += 1) {
        const id = chompID(inp[i .. i + 3]);
        i += 4;
        const kv = try g.getOrPutValue(id, std.ArrayList(u15).init(aoc.halloc));
        while (i + 3 < inp.len and inp[i] != '\n') : (i += 3) {
            i += 1;
            const o = chompID(inp[i .. i + 3]);
            try kv.value_ptr.append(o);
        }
    }
    const you = chompID("you");
    const out = chompID("out");
    var p1: usize = 0;
    var back: [128]u15 = undefined;
    var todo = aoc.Deque(u15).init(back[0..]);
    try todo.push(you);
    while (todo.shift()) |cur| {
        if (cur == out) {
            p1 += 1;
            continue;
        }
        const next = g.get(cur) orelse continue;
        for (next.items) |n| {
            try todo.push(n);
        }
    }

    const svr = chompID("svr");
    const dac = chompID("dac");
    const fft = chompID("fft");
    var cache = std.AutoHashMap(u17, usize).init(aoc.halloc);
    const p2 = try search2(g, Rec{ .node = svr, .visited = 0 }, out, dac, fft, &cache);
    return [2]usize{ p1, p2 };
}

const Rec = struct {
    node: u15,
    visited: u2,

    fn key(r: Rec) u17 {
        return (@as(u17, @intCast(r.node)) << 2) + @as(u17, @intCast(r.visited));
    }
};

fn search2(g: std.AutoHashMap(u15, std.ArrayList(u15)), cur: Rec, end: u15, dac: u15, fft: u15, cache: *std.AutoHashMap(u17, usize)) anyerror!usize {
    const k = cur.key();
    if (cache.get(k)) |v| {
        return v;
    }
    if (cur.node == end) {
        if (cur.visited == 3) {
            return 1;
        } else {
            return 0;
        }
    }
    const next = g.get(cur.node) orelse return 0;
    var nv = cur.visited;
    if (cur.node == dac) {
        nv |= 2;
    }
    if (cur.node == fft) {
        nv |= 1;
    }
    var r: usize = 0;
    for (next.items) |n| {
        r += try search2(g, Rec{ .node = n, .visited = nv }, end, dac, fft, cache);
    }
    try cache.put(k, r);
    return r;
}

inline fn chompID(inp: []const u8) u15 {
    var id: u15 = 0;
    for (inp) |ch| {
        const ord = ch - 'a';
        id = (id * 26) + ord;
    }
    return id;
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
