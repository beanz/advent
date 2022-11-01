const std = @import("std");
const aoc = @import("aoc-lib.zig");

fn get(bm: *aoc.ByteMap, x: usize, y: usize) usize {
    var mw = bm.width();
    var mh = bm.height();
    var v = bm.getXY(x % mw, y % mh) - '0';
    v += @intCast(u8, x / mw);
    v += @intCast(u8, y / mh);
    while (v > 9) : (v -= 9) {}
    return @as(usize, v);
}

fn add(bm: *aoc.ByteMap, q: []std.ArrayList([2]usize), dist: []usize, x: usize, y: usize, d: usize, w: usize) !void {
    var nd = d + get(bm, x, y);
    var di = x + y * w;
    if (dist[di] <= nd) {
        return;
    }
    dist[di] = nd;
    try q[nd].append([2]usize{ x, y });
}

pub fn parts(alloc: std.mem.Allocator, inp: []const u8) ![2]usize {
    var bm = try aoc.ByteMap.init(alloc, inp);
    defer bm.deinit();
    return [2]usize{ try solve(alloc, bm, 1), try solve(alloc, bm, 5) };
}
pub fn solve(alloc: std.mem.Allocator, bm: *aoc.ByteMap, dim: usize) !usize {
    var w = bm.width();
    var h = bm.height();
    w *= dim;
    h *= dim;
    var size = w * h;
    var dist = try alloc.alloc(usize, size);
    defer alloc.free(dist);
    std.mem.set(usize, dist[0..], aoc.maxInt(usize));
    var qsize = (w + h) * 9;
    var q = try alloc.alloc(std.ArrayList([2]usize), qsize);
    var i: usize = 0;
    while (i < qsize) : (i += 1) {
        q[i] = std.ArrayList([2]usize).init(alloc);
    }
    defer {
        i = 0;
        while (i < qsize) : (i += 1) {
            q[i].deinit();
        }
        alloc.free(q);
    }
    try q[0].append([2]usize{ 0, 0 });
    dist[0] = 0;
    var qi: usize = 0;
    while (qi < q.len) : (qi += 1) {
        var j: usize = 0;
        while (j < q[qi].items.len) : (j += 1) {
            var xy: [2]usize = q[qi].items[j];
            var x = xy[0];
            var y = xy[1];
            var vi = x + y * w;
            var d = dist[vi];
            if (x == w - 1 and y == h - 1) {
                return d;
            }
            // aoc.print("{}: {},{} = {}\n", .{ vi, x, y, d });
            if (x > 0) {
                try add(bm, q, dist, x - 1, y, d, w);
            }
            if (x < w - 1) {
                try add(bm, q, dist, x + 1, y, d, w);
            }
            if (y > 0) {
                try add(bm, q, dist, x, y - 1, d, w);
            }
            if (y < h - 1) {
                try add(bm, q, dist, x, y + 1, d, w);
            }
        }
    }
    return 0;
}

test "parts" {
    var t1 = try parts(aoc.talloc, aoc.test1file);
    try aoc.assertEq(@as(usize, 40), t1[0]);
    var r = try parts(aoc.talloc, aoc.inputfile);
    try aoc.assertEq(@as(usize, 595), r[0]);
    try aoc.assertEq(@as(usize, 315), t1[1]);
    try aoc.assertEq(@as(usize, 2914), r[1]);
}

var buf: [16 * 1024 * 1024]u8 = undefined;
fn day15(inp: []const u8, bench: bool) anyerror!void {
    var alloc = std.heap.FixedBufferAllocator.init(&buf);
    var p = try parts(alloc.allocator(), inp);
    if (!bench) {
        aoc.print("Part 1: {}\nPart 2: {}\n", .{ p[0], p[1] });
    }
}

pub fn main() anyerror!void {
    try aoc.benchme(aoc.input(), day15);
}
