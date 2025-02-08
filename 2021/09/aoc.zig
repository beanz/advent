const std = @import("std");
const aoc = @import("aoc-lib.zig");

const Int = usize;

test "testcases" {
    try aoc.TestCases(Int, parts);
}

const Map = struct {
    m: []u8,
    w: Int,
    h: Int,
    fn flood(self: *Map, i: usize, x: Int, y: Int) Int {
        if (self.m[i] >= '9') {
            return 0;
        }
        self.m[i] = '9';
        var size: Int = 1;
        if (x > 0) {
            size += self.flood(i - 1, x - 1, y);
        }
        if (y > 0) {
            size += self.flood(i - self.w, x, y - 1);
        }
        if (x < self.w - 2) {
            size += self.flood(i + 1, x + 1, y);
        }
        if (y < self.h - 1) {
            size += self.flood(i + self.w, x, y + 1);
        }
        return size;
    }
    fn basin(self: *Map, i: usize, x: Int, y: Int) bool {
        if (self.m[i] >= '9') {
            return false;
        }
        const ch = self.m[i];
        if (x > 0 and self.m[i - 1] <= ch) {
            return false;
        }
        if (y > 0 and self.m[i - self.w] <= ch) {
            return false;
        }
        if (x < self.w - 2 and self.m[i + 1] <= ch) {
            return false;
        }
        if (y < self.h - 1 and self.m[i + self.w] <= ch) {
            return false;
        }
        return true;
    }
};

fn parts(inp: []const u8) anyerror![2]Int {
    var back: [12800]u8 = undefined;
    std.mem.copyForwards(u8, back[0..inp.len], inp);
    const w: usize = 1 + std.mem.indexOfScalar(u8, inp, '\n').?;
    var m = Map{
        .m = back[0..inp.len],
        .w = @intCast(w),
        .h = @intCast(inp.len / w),
    };
    var y: Int = 0;
    var m0: usize = 0;
    var m1: usize = 0;
    var m2: usize = 0;
    var p1: usize = 0;
    while (y < m.h) : (y += 1) {
        var x: Int = 0;
        while (x < m.w - 1) : (x += 1) {
            const i: usize = @intCast(x + y * m.w);
            if (!m.basin(i, x, y)) {
                continue;
            }
            p1 += 1 + (m.m[i] & 0xf);
            var size = m.flood(i, x, y);
            if (size > m0) {
                std.mem.swap(usize, &m0, &size);
            }
            if (size > m1) {
                std.mem.swap(usize, &m1, &size);
            }
            if (size > m2) {
                m2 = size;
            }
        }
    }

    return [2]Int{ p1, m0 * m1 * m2 };
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
