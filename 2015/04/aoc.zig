const std = @import("std");
const aoc = @import("aoc-lib.zig");
const Md5 = std.crypto.hash.Md5;

test "testcases" {
    try aoc.TestCases(usize, parts);
}

fn parts(inp: []const u8) anyerror![2]usize {
    var b: [40]u8 = .{0} ** 40;
    var h: [Md5.digest_length]u8 = .{1} ** Md5.digest_length;
    std.mem.copyForwards(u8, &b, inp);
    var n = try NumStr.init(aoc.halloc, &b, inp.len - 1);
    while (true) {
        Md5.hash(n.bytes(), &h, .{});
        if (h[0] == 0 and h[1] == 0 and h[2] & 0xf0 == 0) {
            break;
        }
        n.inc();
    }
    const p1 = n.count();
    n = try NumStr.init(aoc.halloc, &b, inp.len - 1);
    while (true) {
        Md5.hash(n.bytes(), &h, .{});
        if (h[0] == 0 and h[1] == 0 and h[2] == 0) {
            break;
        }
        n.inc();
    }
    const p2 = n.count();
    return [2]usize{ p1, p2 };
}

const NumStr = struct {
    b: *[40]u8,
    l: usize,
    pl: usize,
    c: usize,

    pub fn init(alloc: std.mem.Allocator, b: *[40]u8, pl: usize) anyerror!*NumStr {
        var n = try alloc.create(NumStr);
        n.b = b;
        n.l = pl + 1;
        n.pl = pl;
        n.c = 0;
        n.b[pl] = '0';
        return n;
    }
    pub fn count(self: *NumStr) usize {
        return self.c;
    }
    pub fn inc(self: *NumStr) void {
        self.c += 1;
        var i = self.l - 1;
        while (i >= self.pl) : (i -= 1) {
            self.b[i] += 1;
            if (self.b[i] <= '9') {
                return;
            }
            self.b[i] = '0';
        }
        self.b[self.pl] = '1';
        self.b[self.l] = '0';
        self.l += 1;
    }
    pub fn bytes(self: *NumStr) []u8 {
        return self.b[0..self.l];
    }
};

fn day(inp: []const u8, bench: bool) anyerror!void {
    const p = try parts(inp);
    if (!bench) {
        aoc.print("Part1: {}\nPart2: {}\n", .{ p[0], p[1] });
    }
}

pub fn main() anyerror!void {
    try aoc.benchme(aoc.input(), day);
}
