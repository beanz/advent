const std = @import("std");
const Args = std.process.args;
const math = std.math;
const warn = std.debug.warn;
const aoc = @import("aoc-lib.zig");
const assert = std.testing.expect;
const assertEq = std.testing.expectEqual;

const input = @embedFile("input.txt");
const test1file = @embedFile("test1.txt");
const stdout = &std.io.getStdOut().outStream();
const alloc = std.heap.page_allocator;

test "direction" {
    const TC = struct {
        c: u8, dx: i64, dy: i64
    };
    const tests = [_]TC{
        TC{ .c = 'N', .dx = 0, .dy = -1 },
        TC{ .c = 'S', .dx = 0, .dy = 1 },
        TC{ .c = 'E', .dx = 1, .dy = 0 },
        TC{ .c = 'W', .dx = -1, .dy = 0 },
    };

    for (tests) |tc| {
        var dir = Direction.newFromCompass(tc.c) catch unreachable;
        assertEq(dir.dx, tc.dx);
        assertEq(dir.dy, tc.dy);
    }
}

const Direction = struct {
    dx: i64,
    dy: i64,

    pub fn newFromCompass(c: u8) !*Direction {
        var d = try alloc.create(Direction);
        switch (c) {
            'N' => {
                d.dx = 0;
                d.dy = -1;
            },
            'S' => {
                d.dx = 0;
                d.dy = 1;
            },
            'E' => {
                d.dx = 1;
                d.dy = 0;
            },
            'W' => {
                d.dx = -1;
                d.dy = 0;
            },
            else => {
                std.debug.panic("Compass {} not supported", .{c});
            },
        }
        return d;
    }

    pub fn CCW(self: *Direction) void {
        var t = self.dx;
        self.dx = self.dy;
        self.dy = -1 * t;
    }
    pub fn CW(self: *Direction) void {
        var t = self.dx;
        self.dx = -1 * self.dy;
        self.dy = t;
    }
};

const Point = struct {
    x: i64,
    y: i64,
    pub fn Add(self: *Point, p: Point) void {
        self.x += p.x;
        self.y += p.y;
    }
    pub fn In(self: *Point, d: *Direction) void {
        self.x += d.dx;
        self.y += d.dy;
    }
    pub fn ManDist(self: *Point) usize {
        return math.absCast(self.x) + math.absCast(self.y);
    }
    pub fn CCW(self: *Point) void {
        var t = self.x;
        self.x = self.y;
        self.y = -1 * t;
    }
    pub fn CW(self: *Point) void {
        var t = self.x;
        self.x = -1 * self.y;
        self.y = t;
    }
};

const Nav = struct {
    pub const Inst = struct {
        act: u8,
        val: usize,
    };
    inst: []Inst,
    ship: Point,
    dir: *Direction,
    wp: Point,
    debug: bool,

    pub fn fromInput(inp: std.ArrayListAligned([]const u8, null), allocator: *std.mem.Allocator) !*Nav {
        var l = inp.items.len;
        var inst = try allocator.alloc(Inst, l);
        var nav = try alloc.create(Nav);
        for (inp.items) |line, i| {
            const n = try std.fmt.parseUnsigned(usize, line[1..], 10);
            inst[i].act = line[0];
            inst[i].val = n;
        }
        nav.inst = inst;
        nav.ship = Point{ .x = 0, .y = 0 };
        nav.dir = try Direction.newFromCompass('E');
        nav.wp = Point{ .x = 10, .y = -1 };
        nav.debug = false;
        return nav;
    }

    pub fn Part1(self: *Nav) usize {
        if (self.debug) {
            self.Print();
        }
        for (self.inst) |in| {
            switch (in.act) {
                'N', 'S', 'E', 'W' => {
                    var dir = Direction.newFromCompass(in.act) catch unreachable;
                    var i: usize = 0;
                    while (i < in.val) {
                        self.ship.In(dir);
                        i += 1;
                    }
                },
                'L' => {
                    var i: usize = 0;
                    while (i < in.val) {
                        self.dir.CCW();
                        i += 90;
                    }
                },
                'R' => {
                    var i: usize = 0;
                    while (i < in.val) {
                        self.dir.CW();
                        i += 90;
                    }
                },
                'F' => {
                    var i: usize = 0;
                    while (i < in.val) {
                        self.ship.In(self.dir);
                        i += 1;
                    }
                },
                else => {
                    std.debug.panic("Invalid nav instruction: {}", .{in});
                },
            }
            if (self.debug) {
                self.Print();
            }
        }
        return self.ship.ManDist();
    }

    pub fn Part2(self: *Nav) u64 {
        if (self.debug) {
            self.Print();
        }
        for (self.inst) |in| {
            switch (in.act) {
                'N', 'S', 'E', 'W' => {
                    var dir = Direction.newFromCompass(in.act) catch unreachable;
                    var i: usize = 0;
                    while (i < in.val) {
                        self.wp.In(dir);
                        i += 1;
                    }
                },
                'L' => {
                    var i: usize = 0;
                    while (i < in.val) {
                        self.wp.CCW();
                        i += 90;
                    }
                },
                'R' => {
                    var i: usize = 0;
                    while (i < in.val) {
                        self.wp.CW();
                        i += 90;
                    }
                },
                'F' => {
                    var i: usize = 0;
                    while (i < in.val) {
                        self.ship.Add(self.wp);
                        i += 1;
                    }
                },
                else => {
                    std.debug.panic("Invalid nav instruction: {}", .{in});
                },
            }
            if (self.debug) {
                self.Print();
            }
        }
        return self.ship.ManDist();
    }

    pub fn Print(self: *Nav) void {
        if (self.ship.x >= 0) {
            stdout.print("{} {}", .{ "east", math.absCast(self.ship.x) }) catch unreachable;
        } else {
            stdout.print("{} {}", .{ "west", math.absCast(self.ship.x) }) catch unreachable;
        }
        if (self.ship.y <= 0) {
            stdout.print(" {} {}", .{ "north", math.absCast(self.ship.y) }) catch unreachable;
        } else {
            stdout.print(" {} {}", .{ "south", math.absCast(self.ship.y) }) catch unreachable;
        }
        stdout.print(" [{},{}]\n", .{ self.dir.dx, self.dir.dy }) catch unreachable;
    }
};

fn part1(in: std.ArrayListAligned([]const u8, null)) usize {
    var nav = Nav.fromInput(in, alloc) catch unreachable;
    return nav.Part1();
}

fn part2(in: std.ArrayListAligned([]const u8, null)) usize {
    var nav = Nav.fromInput(in, alloc) catch unreachable;
    return nav.Part2();
}

test "examples" {
    const test1 = try aoc.readLines(test1file);
    const inp = try aoc.readLines(input);

    var r: usize = 25;
    assertEq(r, part1(test1));
    r = 286;
    assertEq(r, part2(test1));

    r = 759;
    assertEq(r, part1(inp));
    r = 45763;
    assertEq(r, part2(inp));
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
