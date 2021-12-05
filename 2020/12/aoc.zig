usingnamespace @import("aoc-lib.zig");

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
        try assertEq(dir.dx, tc.dx);
        try assertEq(dir.dy, tc.dy);
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
                debug.panic("Compass {} not supported", .{c});
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
        return absCast(self.x) + absCast(self.y);
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

    pub fn fromInput(inp: [][]const u8, allocator: *Allocator) !*Nav {
        var l = inp.len;
        var inst = try allocator.alloc(Inst, l);
        var nav = try alloc.create(Nav);
        for (inp) |line, i| {
            const n = try parseUnsigned(usize, line[1..], 10);
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
                    debug.panic("Invalid nav instruction: {}", .{in});
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
                    debug.panic("Invalid nav instruction: {}", .{in});
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
            print("{s} {}", .{ "east", absCast(self.ship.x) }) catch unreachable;
        } else {
            print("{s} {}", .{ "west", absCast(self.ship.x) }) catch unreachable;
        }
        if (self.ship.y <= 0) {
            print(" {s} {}", .{ "north", absCast(self.ship.y) }) catch unreachable;
        } else {
            print(" {s} {}", .{ "south", absCast(self.ship.y) }) catch unreachable;
        }
        print(" [{},{}]\n", .{ self.dir.dx, self.dir.dy }) catch unreachable;
    }
};

fn part1(in: [][]const u8) usize {
    var nav = Nav.fromInput(in, alloc) catch unreachable;
    return nav.Part1();
}

fn part2(in: [][]const u8) usize {
    var nav = Nav.fromInput(in, alloc) catch unreachable;
    return nav.Part2();
}

test "examples" {
    const test1 = readLines(test1file);
    const inp = readLines(inputfile);

    try assertEq(@as(usize, 25), part1(test1));
    try assertEq(@as(usize, 286), part2(test1));

    try assertEq(@as(usize, 759), part1(inp));
    try assertEq(@as(usize, 45763), part2(inp));
}

pub fn main() anyerror!void {
    const lines = readLines(input());
    try print("Part1: {}\n", .{part1(lines)});
    try print("Part2: {}\n", .{part2(lines)});
}
