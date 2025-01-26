const std = @import("std");
const aoc = @import("aoc-lib.zig");

fn indexOf(h: []const u8, n: u8, o: usize) ?usize {
    var i = o;
    while (i < h.len) : (i += 1) {
        if (h[i] == n) {
            return i;
        }
    }
    return null;
}

fn flood(l: []u8, p: usize, w: usize, h: usize) anyerror!usize {
    const x: usize = p % w;
    const y: usize = p / w;
    if (l[p] >= '9') {
        return 0;
    }
    l[p] = '9';
    var size: usize = 1;
    if (x > 0) {
        size += try flood(l, p - 1, w, h);
    }
    if (x < w - 2) {
        size += try flood(l, p + 1, w, h);
    }
    if (y > 0) {
        size += try flood(l, p - w, w, h);
    }
    if (y < h - 1) {
        size += try flood(l, p + w, w, h);
    }
    return size;
}

fn pp(l: []u8, w: usize, h: usize) !void {
    var y: usize = 0;
    while (y < h) : (y += 1) {
        aoc.print("{s}", .{l[y * w .. (1 + y) * w]});
    }
}

fn lava(alloc: std.mem.Allocator, in: []const u8) ![2]usize {
    const l: []u8 = alloc.dupe(u8, in) catch unreachable;
    defer alloc.free(l);
    const w = indexOf(l, '\n', 0).? + 1;
    const h = in.len / w;
    var r = [2]usize{ 0, 0 };
    var ch: u8 = '0';
    var sizes = std.ArrayList(usize).init(alloc);
    defer sizes.deinit();
    //print("\n", .{}) catch unreachable;
    while (ch < '9') : (ch += 1) {
        var p: usize = 0;
        while (p < l.len - 1) : (p += 1) {
            if (l[p] != ch) {
                continue;
            }
            r[0] += 1 + ch - '0';
            const size: usize = try flood(l, p, w, h);
            //print("{},{} s={}\n", .{ p % w, p / w, size }) catch unreachable;
            try sizes.append(size);
        }
    }
    std.mem.sort(usize, sizes.items, {}, std.sort.asc(usize));
    r[1] = (sizes.items[sizes.items.len - 3] *
        sizes.items[sizes.items.len - 2] *
        sizes.items[sizes.items.len - 1]);
    return r;
}

test "examples" {
    const test1 = try lava(aoc.talloc, aoc.test1file);
    try aoc.assertEq(@as(usize, 15), test1[0]);
    const real = try lava(aoc.talloc, aoc.inputfile);
    try aoc.assertEq(@as(usize, 456), real[0]);
    try aoc.assertEq(@as(usize, 1134), test1[1]);
    try aoc.assertEq(@as(usize, 1047744), real[1]);
}

fn day09(inp: []const u8, bench: bool) anyerror!void {
    const p = try lava(aoc.halloc, inp);
    if (!bench) {
        aoc.print("Part 1: {}\nPart 2: {}\n", .{ p[0], p[1] });
    }
}

pub fn main() anyerror!void {
    try aoc.benchme(aoc.input(), day09);
}
