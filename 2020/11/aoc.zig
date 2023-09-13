const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "examples" {
    const test1 = try aoc.readLines(aoc.talloc, aoc.test1file);
    defer aoc.talloc.free(test1);
    const test2 = try aoc.readLines(aoc.talloc, aoc.test2file);
    defer aoc.talloc.free(test2);
    const inp = try aoc.readLines(aoc.talloc, aoc.inputfile);
    defer aoc.talloc.free(inp);

    var map = Map.fromInput(aoc.talloc, test1) catch unreachable;
    try aoc.assertEq(@as(usize, 71), map.RunOnce(4, false));
    try aoc.assertEq(@as(usize, 20), map.RunOnce(4, false));
    map.deinit();

    map = Map.fromInput(aoc.talloc, test2) catch unreachable;
    try aoc.assertEq(@as(usize, 29), map.RunOnce(4, false));
    map.deinit();

    map = Map.fromInput(aoc.talloc, inp) catch unreachable;
    defer map.deinit();
    try aoc.assertEq(@as(usize, 7906), map.RunOnce(4, false));
    try aoc.assertEq(@as(usize, 148), map.RunOnce(4, false));

    try aoc.assertEq(@as(usize, 37), part1(aoc.talloc, test1));
    try aoc.assertEq(@as(usize, 26), part2(aoc.talloc, test1));

    try aoc.assertEq(@as(usize, 2481), part1(aoc.talloc, inp));
    try aoc.assertEq(@as(usize, 2227), part2(aoc.talloc, inp));
}

const Map = struct {
    pub const SeatState = enum(u8) { empty, occupied, none, none_outside };
    pub const NeighbourOffsets = [8][2]isize{
        [2]isize{ -1, -1 }, [2]isize{ 0, -1 }, [2]isize{ 1, -1 },
        [2]isize{ -1, 0 },  [2]isize{ 1, 0 },  [2]isize{ -1, 1 },
        [2]isize{ 0, 1 },   [2]isize{ 1, 1 },
    };
    h: usize,
    w: usize,
    map: []SeatState,
    new: []SeatState,
    changes: usize,
    alloc: std.mem.Allocator,

    pub fn fromInput(alloc: std.mem.Allocator, inp: [][]const u8) !*Map {
        var h = inp.len;
        var w = inp[0].len;
        var map = try alloc.alloc(SeatState, h * w);
        var new = try alloc.alloc(SeatState, h * w);
        var m = try alloc.create(Map);
        m.map = map;
        m.new = new;
        m.h = h;
        m.w = w;
        m.alloc = alloc;
        for (inp, 0..) |line, y| {
            for (line, 0..) |s, x| {
                if (s == 'L') {
                    map[y * w + x] = .empty;
                } else if (s == '#') {
                    map[y * w + x] = .occupied;
                } else {
                    map[y * w + x] = .none;
                    new[y * w + x] = .none;
                }
            }
        }
        return m;
    }

    pub fn deinit(self: *Map) void {
        self.alloc.free(self.map);
        self.alloc.free(self.new);
        self.alloc.destroy(self);
    }

    pub fn SetSeat(self: *Map, x: isize, y: isize, state: SeatState) void {
        self.new[std.math.absCast(y) * self.w + std.math.absCast(x)] = state;
    }

    pub fn Swap(self: *Map) void {
        const tmp = self.map;
        self.map = self.new;
        self.new = tmp;
    }

    pub fn Seat(self: *Map, x: isize, y: isize) SeatState {
        if (x < 0 or x > self.w - 1 or y < 0 or y > self.h - 1) {
            return .none_outside;
        }
        return self.map[std.math.absCast(y) * self.w + std.math.absCast(x)];
    }

    pub fn Next(self: *Map, x: isize, y: isize, group: usize, sight: bool) SeatState {
        var oc: usize = 0;
        for (Map.NeighbourOffsets) |o| {
            var ox = x;
            var oy = y;
            while (true) {
                ox += o[0];
                oy += o[1];
                var ns = self.Seat(ox, oy);
                if (ns == .occupied) {
                    oc += 1;
                }
                if (ns != .none or !sight) {
                    break;
                }
            }
        }
        var n = self.Seat(x, y);
        if (n == .empty and oc == 0) {
            n = .occupied;
        } else if (n == .occupied and oc >= group) {
            n = .empty;
        }
        return n;
    }

    pub fn Print(self: *Map) void {
        var y: isize = 0;
        while (y < self.h) : (y += 1) {
            var x: isize = 0;
            while (x < self.w) : (x += 1) {
                switch (self.Seat(x, y)) {
                    .empty => {
                        aoc.print("{}", .{"L"}) catch unreachable;
                    },
                    .occupied => {
                        aoc.print("{}", .{"#"}) catch unreachable;
                    },
                    else => {
                        aoc.print("{}", .{"."}) catch unreachable;
                    },
                }
            }
            aoc.print("\n", .{}) catch unreachable;
        }
    }

    pub fn RunOnce(self: *Map, group: usize, sight: bool) usize {
        self.changes = 0;
        var oc: usize = 0;
        var x: isize = 0;
        while (x < self.w) : (x += 1) {
            var y: isize = 0;
            while (y < self.h) : (y += 1) {
                var cur = self.Seat(x, y);
                if (cur == .none) {
                    continue;
                }
                var new = self.Next(x, y, group, sight);
                self.SetSeat(x, y, new);
                if (cur != new) {
                    self.changes += 1;
                }
                if (new == .occupied) {
                    oc += 1;
                }
            }
        }
        self.Swap();
        return oc;
    }

    pub fn Run(self: *Map, group: usize, sight: bool) usize {
        while (true) {
            var oc = self.RunOnce(group, sight);
            if (self.changes == 0) {
                return oc;
            }
        }
        return 0;
    }
};

fn part1(alloc: std.mem.Allocator, in: [][]const u8) usize {
    var map = Map.fromInput(alloc, in) catch unreachable;
    defer map.deinit();
    return map.Run(4, false);
}

fn part2(alloc: std.mem.Allocator, in: [][]const u8) usize {
    var map = Map.fromInput(alloc, in) catch unreachable;
    defer map.deinit();
    return map.Run(5, true);
}

fn day11(inp: []const u8, bench: bool) anyerror!void {
    const lines = try aoc.readLines(aoc.halloc, inp);
    defer aoc.halloc.free(lines);
    var p1 = part1(aoc.halloc, lines);
    var p2 = part2(aoc.halloc, lines);
    if (!bench) {
        aoc.print("Part 1: {}\nPart 2: {}\n", .{ p1, p2 });
    }
}

pub fn main() anyerror!void {
    try aoc.benchme(aoc.input(), day11);
}
