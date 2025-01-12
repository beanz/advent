const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

const Comp = struct {
    p0: u8,
    p1: u8,
    used: bool,

    fn next(self: Comp, p: u8) ?u8 {
        if (self.p0 == p) {
            return self.p1;
        }
        if (self.p1 == p) {
            return self.p0;
        }
        return null;
    }
};

fn parts(inp: []const u8) anyerror![2]usize {
    var it = aoc.uintIter(u8, inp);
    var s = try std.BoundedArray(Comp, 64).init(0);
    while (it.next()) |a| {
        const b = it.next().?;
        try s.append(Comp{ .p0 = a, .p1 = b, .used = false });
    }
    const comp = s.slice();
    const Search = struct {
        comp: []Comp,
        p1: usize,
        ml: usize,
        p2: usize,
        pub fn search(self: *@This(), port: u8, len: usize, st: usize) void {
            self.p1 = @max(self.p1, st);
            self.ml = @max(self.ml, len);
            if (self.ml == len) {
                self.p2 = @max(self.p2, st);
            }
            for (0..self.comp.len) |i| {
                if (self.comp[i].used) {
                    continue;
                }
                if (self.comp[i].next(port)) |new_port| {
                    self.comp[i].used = true;
                    self.search(new_port, len + 1, st + self.comp[i].p0 + self.comp[i].p1);
                    self.comp[i].used = false;
                }
            }
        }
    };
    var search = Search{ .comp = comp, .p1 = 0, .ml = 0, .p2 = 0 };
    search.search(0, 0, 0);
    return [2]usize{ search.p1, search.p2 };
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
