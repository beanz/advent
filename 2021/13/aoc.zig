const std = @import("std");
const aoc = @import("aoc-lib.zig");

const Paper = struct {
    const Fold = struct {
        axis: u1,
        pos: u11,
    };

    points: std.AutoHashMap([2]u11, bool),
    folds: []*Fold,
    next: usize,
    bb: [2]u11,
    alloc: std.mem.Allocator,

    pub fn init(alloc: std.mem.Allocator, inp: []const u8) !*Paper {
        var paper = try alloc.create(Paper);
        paper.alloc = alloc;
        paper.next = 0;
        var chunks = std.mem.split(u8, inp, "\n\n");
        var b = try std.BoundedArray(u11, 2048).init(0);
        const ints = try aoc.BoundedInts(u11, &b, chunks.next().?);
        var points = std.AutoHashMap([2]u11, bool).init(alloc);
        var i: usize = 0;
        while (i < ints.len) : (i += 2) {
            try points.put([2]u11{ ints[i], ints[i + 1] }, true);
        }
        var folds = std.ArrayList(*Fold).init(alloc);
        const foldsChunk = chunks.next().?;
        var n: u11 = 0;
        var axis: u1 = 0;
        i = 0;
        while (i < foldsChunk.len) : (i += 1) {
            switch (foldsChunk[i]) {
                'x' => {
                    axis = 0;
                },
                'y' => {
                    axis = 1;
                },
                '0'...'9' => {
                    n = 10 * n + @as(u11, foldsChunk[i] - '0');
                },
                '\n' => {
                    var f = try alloc.create(Fold);
                    f.axis = axis;
                    f.pos = n;
                    try folds.append(f);
                    n = 0;
                },
                else => {},
            }
        }
        paper.folds = try folds.toOwnedSlice();
        //aoc.print("{any}\n", .{paper}) catch unreachable;
        paper.points = points;
        return paper;
    }
    pub fn deinit(self: *Paper) void {
        for (self.folds) |e| {
            self.alloc.destroy(e);
        }
        self.alloc.free(self.folds);
        self.points.deinit();
        self.alloc.destroy(self);
    }
    pub fn nextFold(self: *Paper) !usize {
        const fold = self.folds[self.next];
        var it = self.points.keyIterator();
        while (it.next()) |k| {
            var np: [2]u11 = k.*;
            if (np[fold.axis] > fold.pos) {
                np[fold.axis] = fold.pos - (np[fold.axis] - fold.pos);
                _ = self.points.remove(k.*);
                if (!self.points.contains(np)) {
                    try self.points.put(np, true);
                }
            }
        }
        self.bb[fold.axis] = fold.pos;
        self.next += 1;
        return self.points.count();
    }
    pub fn part1(self: *Paper) !usize {
        return self.nextFold();
    }
    pub fn part2(self: *Paper) ![]const u8 {
        while (self.next < self.folds.len) {
            _ = try self.nextFold();
        }
        var s = try self.alloc.alloc(u8, @as(usize, self.bb[0] + 1) * @as(usize, self.bb[1]));
        @memset(s, ' ');
        var y: u11 = 0;
        while (y < self.bb[1]) : (y += 1) {
            var x: u11 = 0;
            while (x < self.bb[0]) : (x += 1) {
                if (self.points.contains([2]u11{ x, y })) {
                    s[x + y * (self.bb[0] + 1)] = '#';
                }
            }
            s[x + y * (self.bb[0] + 1)] = '\n';
        }
        return s;
    }
};

test "part1" {
    var t1 = try Paper.init(aoc.talloc, aoc.test1file);
    defer t1.deinit();
    try aoc.assertEq(@as(usize, 10), try t1.part1());
    var r = try Paper.init(aoc.talloc, aoc.inputfile);
    defer r.deinit();
    try aoc.assertEq(@as(usize, 4691), try r.part1());
}

test "part2" {
    var t1 = try Paper.init(aoc.talloc, aoc.test1file);
    defer t1.deinit();
    try aoc.assertStrEq("bar", try t1.part2());
    var r = try Paper.init(aoc.talloc, aoc.inputfile);
    defer r.deinit();
    try aoc.assertStrEq("foo", try r.part2());
}

fn day13(inp: []const u8, bench: bool) anyerror!void {
    var paper = try Paper.init(aoc.halloc, inp);
    const p1 = try paper.part1();
    const p2 = try paper.part2();
    if (!bench) {
        aoc.print("Part 1: {}\nPart 2:\n{s}\n", .{ p1, p2 });
    }
}

pub fn main() anyerror!void {
    try aoc.benchme(aoc.input(), day13);
}
