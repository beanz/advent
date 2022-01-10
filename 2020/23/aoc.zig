usingnamespace @import("aoc-lib.zig");

const Cup = struct {
    val: usize,
    cw: *Cup,
    ccw: *Cup,
    alloc: *Allocator,

    pub fn init(val: usize, alloc: *Allocator) *Cup {
        var self = alloc.create(Cup) catch unreachable;
        self.val = val;
        self.cw = self;
        self.ccw = self;
        self.alloc = alloc;
        return self;
    }

    pub fn insertAfter(c: *Cup, new: *Cup) void {
        var last = new.ccw;
        var next = c.cw;
        c.cw = new;
        last.cw = next;
        new.ccw = c;
        next.ccw = last;
    }

    pub fn pick(c: *Cup) *Cup {
        var p1 = c.cw;
        var p3 = p1.cw.cw;
        var n = p3.cw;

        // fix ring
        c.cw = n;
        n.ccw = c;

        // fix pick ring
        p1.ccw = p3;
        p3.cw = p1;
        return p1;
    }

    pub fn string(c: *Cup) []const u8 {
        var l: usize = 1;
        var n = c.cw;
        while (n != c) : (n = n.cw) {
            l += 1;
        }
        var res = c.alloc.alloc(u8, l) catch unreachable;
        res[0] = @intCast(u8, c.val) + '0';
        n = c.cw;
        var i: usize = 1;
        while (n != c) : (n = n.cw) {
            res[i] = @intCast(u8, n.val) + '0';
            i += 1;
        }
        return res;
    }

    pub fn part1string(c: *Cup) []const u8 {
        var l: usize = 0;
        var n = c.cw;
        while (n != c) : (n = n.cw) {
            l += 1;
        }
        var res = c.alloc.alloc(u8, l) catch unreachable;
        var i: usize = 0;
        n = c.cw;
        while (n != c) : (n = n.cw) {
            res[i] = @intCast(u8, n.val) + '0';
            i += 1;
        }
        return res;
    }
};

test "cup" {
    var c1 = Cup.init(1, talloc);
    try assertEq(@as(usize, 1), c1.val);
    try assertEq(c1, c1.cw);
    try assertEq(c1, c1.ccw);
    var c2 = Cup.init(2, talloc);
    try assertEq(@as(usize, 2), c2.val);
    try assertEq(c2, c2.cw);
    try assertEq(c2, c2.ccw);
    c1.insertAfter(c2);
    try assertEq(c2, c1.cw);
    try assertEq(c2, c1.ccw);
    try assertEq(c1, c2.cw);
    try assertEq(c1, c2.ccw);
    var i: usize = 3;
    var c = c2;
    while (i < 10) : (i += 1) {
        c.insertAfter(Cup.init(arena, i));
        c = c.cw;
    }
    try assertStrEq("123456789", c1.string());
    try assertStrEq("23456789", c1.part1string());
    try assertStrEq("67891234", c2.cw.cw.cw.part1string());
}

const Game = struct {
    init: []u8,
    alloc: *Allocator,
    debug: bool,

    pub fn init(in: [][]const u8, alloc: *Allocator) !*Game {
        var self = try alloc.create(Game);
        self.alloc = alloc;
        self.debug = true;
        var l = in[0].len;
        self.init = try alloc.alloc(u8, l);
        var i: usize = 0;
        while (i < l) : (i += 1) {
            self.init[i] = in[0][i] - '0';
        }
        return self;
    }

    pub fn deinit(g: *Game) void {
        g.alloc.free(g.init);
        g.alloc.destroy(g);
    }

    pub fn play(g: *Game, moves: usize, max: usize) *Cup {
        var map = g.alloc.alloc(*Cup, max + 1) catch unreachable; // ignore 0
        var cur = Cup.init(g.init[0], g.alloc);
        map[g.init[0]] = cur;
        var last = cur;
        var i: usize = 1;
        while (i < g.init.len) : (i += 1) {
            var v = g.init[i];
            var n = Cup.init(v, g.alloc);
            map[v] = n;
            last.insertAfter(n);
            last = n;
        }
        i = 10;
        while (i <= max) : (i += 1) {
            var n = Cup.init(i, g.alloc);
            map[i] = n;
            last.insertAfter(n);
            last = n;
        }
        var move: usize = 1;
        while (move <= moves) : (move += 1) {
            var pick = cur.pick();
            var dst = cur.val;
            while (true) {
                dst -= 1;
                if (dst == 0) {
                    dst = max;
                }
                if (dst != pick.val and
                    dst != pick.cw.val and dst != pick.cw.cw.val)
                {
                    break;
                }
            }
            var dcup = map[dst];
            dcup.insertAfter(pick);
            cur = cur.cw;
        }

        return map[1];
    }

    pub fn part1(g: *Game, moves: usize) []const u8 {
        var c1 = g.play(moves, 9);
        return c1.part1string();
    }

    pub fn part2(g: *Game, moves: usize, max: usize) usize {
        var c1 = g.play(moves, max);
        return c1.cw.val * c1.cw.cw.val;
    }
};

test "part1" {
    const test1 = readLines(test1file);
    const inp = readLines(inputfile);

    var gt = Game.init(test1);
    try assertStrEq("25467389", gt.part1(0));
    try assertStrEq("54673289", gt.part1(1));
    try assertStrEq("92658374", gt.part1(10));
    try assertStrEq("67384529", gt.part1(100));
    var g = Game.init(inp);
    try assertStrEq("92736584", g.part1(10));
    try assertStrEq("63598274", g.part1(50));
    try assertStrEq("46978532", g.part1(100));
}

test "part2" {
    const test1 = readLines(test1file);
    const inp = readLines(inputfile);

    var gt = Game.init(test1);
    try assertEq(@as(usize, 136), gt.part2(30, 20));
    try assertEq(@as(usize, 54), gt.part2(100, 20));
    try assertEq(@as(usize, 42), gt.part2(1000, 20));
    try assertEq(@as(usize, 285), gt.part2(10000, 20));
    try assertEq(@as(usize, 285), gt.part2(10001, 20));
    try assertEq(@as(usize, 12), gt.part2(10, 1000000));
    try assertEq(@as(usize, 12), gt.part2(100, 1000000));
    try assertEq(@as(usize, 126), gt.part2(1000000, 1000000));
    try assertEq(@as(usize, 32999175), gt.part2(2000000, 1000000));
    try assertEq(@as(usize, 149245887792), gt.part2(10000000, 1000000));

    var g = Game.init(inp);
    try assertEq(@as(usize, 163035127721), g.part2(10000000, 1000000));
}

fn aoc(inp: []const u8, bench: bool) anyerror!void {
    const lines = readLines(inp, halloc);
    defer halloc.free(lines);
    var g = try Game.init(lines, halloc);
    defer g.deinit();
    var p1 = g.part1(100);
    var p2 = g.part2(10000000, 1000000);
    if (!bench) {
        try print("Part 1: {s}\nPart 2: {}\n", .{ p1, p2 });
    }
}

pub fn main() anyerror!void {
    try benchme(input(), aoc);
}
