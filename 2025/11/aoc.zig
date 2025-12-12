const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

const id_prime = 73;

fn parts(inp: []const u8) anyerror![2]usize {
    var g = std.AutoHashMap(u15, std.ArrayList(u15)).init(aoc.halloc);
    try g.ensureTotalCapacity(600);
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
    const svr = chompID("svr");
    const dac = chompID("dac");
    const fft = chompID("fft");
    var cache = std.AutoHashMap(u15, usize).init(aoc.halloc);
    try cache.ensureTotalCapacity(1024);
    const p1 = try search(g, you, out, &cache);
    cache.clearRetainingCapacity();
    const svrToFft = try search(g, svr, fft, &cache);
    cache.clearRetainingCapacity();
    const fftToDac = try search(g, fft, dac, &cache);
    cache.clearRetainingCapacity();
    const dacToOut = try search(g, dac, out, &cache);
    cache.deinit();

    return [2]usize{ p1, svrToFft * fftToDac * dacToOut };
}

fn search(g: std.AutoHashMap(u15, std.ArrayList(u15)), cur: u15, end: u15, cache: *std.AutoHashMap(u15, usize)) anyerror!usize {
    if (cache.get(cur)) |v| {
        return v;
    }
    if (cur == end) {
        return 1;
    }
    const next = g.get(cur) orelse return 0;
    var r: usize = 0;
    for (next.items) |n| {
        r += try search(g, n, end, cache);
    }
    try cache.put(cur, r);
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
