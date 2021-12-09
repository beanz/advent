const inputfile = @embedFile("input.txt");
const test1file = @embedFile("test1.txt");
const std = @import("std");
const assertEq = std.testing.expectEqual;
const print = std.io.getStdOut().writer().print;
const mem = std.mem;
const alloc = std.heap.page_allocator;

const P1P2 = struct { p1: usize, p2: usize };

fn indexOf(h: []const u8, n: u8, o: usize) ?usize {
    var i = o;
    while (i < h.len) : (i += 1) {
        if (h[i] == n) {
            return i;
        }
    }
    return null;
}

pub fn usizeLessThan(c: void, a: usize, b: usize) bool {
    return a < b;
}

fn flood(l: []u8, p: usize, w: usize, h: usize) anyerror!usize {
    var x: usize = p % w;
    var y: usize = p / w;
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

fn pp(l: []u8, w: usize, h: usize) void {
    var y: usize = 0;
    while (y < h) : (y += 1) {
        print("{s}", .{l[y * w .. (1 + y) * w]}) catch unreachable;
    }
}

fn lava(in: []const u8) anyerror!P1P2 {
    var l: []u8 = mem.dupe(alloc, u8, in) catch unreachable;
    var w = indexOf(l, '\n', 0).? + 1;
    var h = in.len / w;
    var p1: usize = 0;
    var ch: u8 = '0';
    var sizes = std.ArrayList(usize).init(alloc);
    defer sizes.deinit();
    //print("\n", .{}) catch unreachable;
    var min: usize = 0;
    while (ch < '9') : (ch += 1) {
        var p: usize = 0;
        while (p < l.len - 1) : (p += 1) {
            if (l[p] != ch) {
                continue;
            }
            p1 += 1 + ch - '0';
            var size: usize = try flood(l, p, w, h);
            //print("{},{} s={}\n", .{ p % w, p / w, size }) catch unreachable;
            try sizes.append(size);
        }
    }
    std.sort.sort(usize, sizes.items, {}, usizeLessThan);
    var p2 = (sizes.items[sizes.items.len - 3] *
        sizes.items[sizes.items.len - 2] *
        sizes.items[sizes.items.len - 1]);
    return P1P2{ .p1 = p1, .p2 = p2 };
}

test "examples" {
    var test1 = lava(test1file) catch unreachable;
    try assertEq(@as(usize, 15), test1.p1);
    var real = lava(inputfile) catch unreachable;
    try assertEq(@as(usize, 456), real.p1);
    try assertEq(@as(usize, 1134), test1.p2);
    try assertEq(@as(usize, 1047744), real.p2);
}

pub fn main() anyerror!void {
    var res = try lava(input());
    try print("Part1: {}\n", .{res.p1});
    try print("Part2: {}\n", .{res.p2});
}

pub fn input() []const u8 {
    var args = std.process.args();
    _ = args.skip();
    var res: []const u8 = inputfile;
    if (args.next(alloc)) |arg1| {
        alloc.free(arg1 catch unreachable);
        res = test1file;
    }
    return res;
}
