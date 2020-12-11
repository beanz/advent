const std = @import("std");
const warn = std.debug.warn;
const Args = std.process.args;
const math = std.math;
const aoc = @import("aoc-lib.zig");
const assert = std.testing.expect;
const assertEq = std.testing.expectEqual;

const input = @embedFile("input.txt");
const test1file = @embedFile("test1.txt");
const test2file = @embedFile("test2.txt");
const stdout = &std.io.getStdOut().outStream();
const alloc = std.heap.page_allocator;

test "examples" {
    const test1 = try aoc.readLines(test1file);
    const test2 = try aoc.readLines(test2file);
    const inp = try aoc.readLines(input);

    var r: usize = 71;
    var map = Map.fromInput(test1, alloc) catch unreachable;
    assertEq(r, map.RunOnce(4, false));
    r = 20;
    assertEq(r, map.RunOnce(4, false));

    map = Map.fromInput(test2, alloc) catch unreachable;
    r = 29;
    assertEq(r, map.RunOnce(4, false));

    map = Map.fromInput(inp, alloc) catch unreachable;
    r = 7906;
    assertEq(r, map.RunOnce(4, false));
    r = 148;
    assertEq(r, map.RunOnce(4, false));

    r = 37;
    assertEq(r, part1(test1));
    r = 26;
    assertEq(r, part2(test1));

    r = 2481;
    assertEq(r, part1(inp));
    r = 2227;
    assertEq(r, part2(inp));
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

    pub fn fromInput(inp: std.ArrayListAligned([]const u8, null), allocator: *std.mem.Allocator) !*Map {
        var h = inp.items.len;
        var w = inp.items[0].len;
        var map = try allocator.alloc(SeatState, h * w);
        var new = try allocator.alloc(SeatState, h * w);
        var m = try alloc.create(Map);
        m.map = map;
        m.new = new;
        m.h = h;
        m.w = w;
        for (inp.items) |line, y| {
            for (line) |s, x| {
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

    pub fn SetSeat(self: *Map, x: isize, y: isize, state: SeatState) void {
        self.new[math.absCast(y) * self.w + math.absCast(x)] = state;
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
        return self.map[math.absCast(y) * self.w + math.absCast(x)];
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
        while (y < self.h) {
            var x: isize = 0;
            while (x < self.w) {
                switch (self.Seat(x, y)) {
                    .empty => {
                        stdout.print("{}", .{"L"}) catch unreachable;
                    },
                    .occupied => {
                        stdout.print("{}", .{"#"}) catch unreachable;
                    },
                    else => {
                        stdout.print("{}", .{"."}) catch unreachable;
                    },
                }
                x += 1;
            }
            stdout.print("\n", .{}) catch unreachable;
            y += 1;
        }
    }

    pub fn RunOnce(self: *Map, group: usize, sight: bool) usize {
        self.changes = 0;
        var oc: usize = 0;
        var x: isize = 0;
        while (x < self.w) {
            var y: isize = 0;
            while (y < self.h) {
                defer {
                    y += 1;
                }
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
            x += 1;
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

fn part1(in: std.ArrayListAligned([]const u8, null)) usize {
    var map = Map.fromInput(in, alloc) catch unreachable;
    return map.Run(4, false);
}

fn part2(in: std.ArrayListAligned([]const u8, null)) usize {
    var map = Map.fromInput(in, alloc) catch unreachable;
    return map.Run(5, true);
}

pub fn main() anyerror!void {
    var args = Args();
    const arg0 = args.next(alloc).?;
    var lines: std.ArrayListAligned([]const u8, null) = undefined;
    if (args.next(alloc)) |_| {
        lines = try aoc.readLines(test1file);
    } else {
        lines = try aoc.readLines(input);
    }
    try stdout.print("Part1: {}\n", .{part1(lines)});
    try stdout.print("Part2: {}\n", .{part2(lines)});
}
