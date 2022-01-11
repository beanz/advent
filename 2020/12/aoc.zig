const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "direction" {
    const TC = struct { c: u8, dx: i64, dy: i64 };
    const tests = [_]TC{
        TC{ .c = 'N', .dx = 0, .dy = -1 },
        TC{ .c = 'S', .dx = 0, .dy = 1 },
        TC{ .c = 'E', .dx = 1, .dy = 0 },
        TC{ .c = 'W', .dx = -1, .dy = 0 },
    };

    for (tests) |tc| {
        var dir = Direction.newFromCompass(tc.c) catch unreachable;
        try aoc.assertEq(dir.dx, tc.dx);
        try aoc.assertEq(dir.dy, tc.dy);
    }
}

const Direction = struct {
    dx: i64,
    dy: i64,

    pub fn newFromCompass(c: u8) !*Direction {
        var d = try aoc.halloc.create(Direction);
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
        return std.math.absCast(self.x) + std.math.absCast(self.y);
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
    alloc: std.mem.Allocator,
    debug: bool,

    pub fn fromInput(alloc: std.mem.Allocator, inp: [][]const u8) !*Nav {
        var l = inp.len;
        var inst = try alloc.alloc(Inst, l);
        var nav = try alloc.create(Nav);
        for (inp) |line, i| {
            const n = try std.fmt.parseUnsigned(usize, line[1..], 10);
            inst[i].act = line[0];
            inst[i].val = n;
        }
        nav.inst = inst;
        nav.ship = Point{ .x = 0, .y = 0 };
        nav.dir = try Direction.newFromCompass('E');
        nav.wp = Point{ .x = 10, .y = -1 };
        nav.debug = false;
        nav.alloc = alloc;
        return nav;
    }

    pub fn deinit(self: *Nav) void {
        self.alloc.free(self.inst);
        self.alloc.destroy(self);
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
                    while (i < in.val) : (i += 1) {
                        self.ship.In(dir);
                    }
                },
                'L' => {
                    var i: usize = 0;
                    while (i < in.val) : (i += 90) {
                        self.dir.CCW();
                    }
                },
                'R' => {
                    var i: usize = 0;
                    while (i < in.val) : (i += 90) {
                        self.dir.CW();
                    }
                },
                'F' => {
                    var i: usize = 0;
                    while (i < in.val) : (i += 1) {
                        self.ship.In(self.dir);
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
                    while (i < in.val) : (i += 1) {
                        self.wp.In(dir);
                    }
                },
                'L' => {
                    var i: usize = 0;
                    while (i < in.val) : (i += 90) {
                        self.wp.CCW();
                    }
                },
                'R' => {
                    var i: usize = 0;
                    while (i < in.val) : (i += 90) {
                        self.wp.CW();
                    }
                },
                'F' => {
                    var i: usize = 0;
                    while (i < in.val) : (i += 1) {
                        self.ship.Add(self.wp);
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
            aoc.print("{s} {}", .{ "east", std.math.absCast(self.ship.x) }) catch unreachable;
        } else {
            aoc.print("{s} {}", .{ "west", std.math.absCast(self.ship.x) }) catch unreachable;
        }
        if (self.ship.y <= 0) {
            aoc.print(" {s} {}", .{ "north", std.math.absCast(self.ship.y) }) catch unreachable;
        } else {
            aoc.print(" {s} {}", .{ "south", std.math.absCast(self.ship.y) }) catch unreachable;
        }
        aoc.print(" [{},{}]\n", .{ self.dir.dx, self.dir.dy }) catch unreachable;
    }
};

fn part1(alloc: std.mem.Allocator, in: [][]const u8) usize {
    var nav = Nav.fromInput(alloc, in) catch unreachable;
    defer nav.deinit();
    return nav.Part1();
}

fn part2(alloc: std.mem.Allocator, in: [][]const u8) usize {
    var nav = Nav.fromInput(alloc, in) catch unreachable;
    defer nav.deinit();
    return nav.Part2();
}

test "examples" {
    const test1 = aoc.readLines(aoc.talloc, aoc.test1file);
    defer aoc.talloc.free(test1);
    const inp = aoc.readLines(aoc.talloc, aoc.inputfile);
    defer aoc.talloc.free(inp);

    try aoc.assertEq(@as(usize, 25), part1(aoc.talloc, test1));
    try aoc.assertEq(@as(usize, 286), part2(aoc.talloc, test1));

    try aoc.assertEq(@as(usize, 759), part1(aoc.talloc, inp));
    try aoc.assertEq(@as(usize, 45763), part2(aoc.talloc, inp));
}

fn day12(inp: []const u8, bench: bool) anyerror!void {
    const lines = aoc.readLines(aoc.halloc, inp);
    defer aoc.halloc.free(lines);
    var p1 = part1(aoc.halloc, lines);
    var p2 = part2(aoc.halloc, lines);
    if (!bench) {
        try aoc.print("Part 1: {}\nPart 2: {}\n", .{ p1, p2 });
    }
}

pub fn main() anyerror!void {
    try aoc.benchme(aoc.input(), day12);
}
