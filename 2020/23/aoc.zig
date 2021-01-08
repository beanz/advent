usingnamespace @import("aoc-lib.zig");

const Cup = struct {
    val: usize,
    cw: *Cup,
    ccw: *Cup,
    all: *Allocator,

    pub fn init(all: *Allocator, val: usize) *Cup {
        var self = all.create(Cup) catch unreachable;
        self.val = val;
        self.cw = self;
        self.ccw = self;
        self.all = all;
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
        var res = alloc.alloc(u8, l) catch unreachable;
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
        var res = alloc.alloc(u8, l) catch unreachable;
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
    var arenaAllocator = ArenaAllocator.init(alloc);
    defer arenaAllocator.deinit();
    var arena = &arenaAllocator.allocator;

    var c1 = Cup.init(arena, 1);
    assertEq(@as(usize, 1), c1.val);
    assertEq(c1, c1.cw);
    assertEq(c1, c1.ccw);
    var c2 = Cup.init(arena, 2);
    assertEq(@as(usize, 2), c2.val);
    assertEq(c2, c2.cw);
    assertEq(c2, c2.ccw);
    c1.insertAfter(c2);
    assertEq(c2, c1.cw);
    assertEq(c2, c1.ccw);
    assertEq(c1, c2.cw);
    assertEq(c1, c2.ccw);
    var i: usize = 3;
    var c = c2;
    while (i < 10) : (i += 1) {
        c.insertAfter(Cup.init(arena, i));
        c = c.cw;
    }
    assertStrEq("123456789", c1.string());
    assertStrEq("23456789", c1.part1string());
    assertStrEq("67891234", c2.cw.cw.cw.part1string());
}

const Game = struct {
    init: []u8,
    debug: bool,

    pub fn init(in: [][]const u8) *Game {
        var self = alloc.create(Game) catch unreachable;
        self.debug = true;
        var l = in[0].len;
        self.init = alloc.alloc(u8, l) catch unreachable;
        var i: usize = 0;
        while (i < l) : (i += 1) {
            self.init[i] = in[0][i] - '0';
        }
        return self;
    }

    pub fn play(g: *Game, all: *Allocator, moves: usize, max: usize) *Cup {
        var map = all.alloc(*Cup, max + 1) catch unreachable; // ignore 0
        var cur = Cup.init(all, g.init[0]);
        map[g.init[0]] = cur;
        var last = cur;
        var i: usize = 1;
        while (i < g.init.len) : (i += 1) {
            var v = g.init[i];
            var n = Cup.init(all, v);
            map[v] = n;
            last.insertAfter(n);
            last = n;
        }
        i = 10;
        while (i <= max) : (i += 1) {
            var n = Cup.init(all, i);
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
        var arenaAllocator = ArenaAllocator.init(alloc);
        defer arenaAllocator.deinit();
        var arena = &arenaAllocator.allocator;

        var c1 = g.play(arena, moves, 9);
        return c1.part1string();
    }

    pub fn part2(g: *Game, moves: usize, max: usize) usize {
        var arenaAllocator = ArenaAllocator.init(alloc);
        defer arenaAllocator.deinit();
        var arena = &arenaAllocator.allocator;

        var c1 = g.play(arena, moves, max);
        return c1.cw.val * c1.cw.cw.val;
    }
};

test "part1" {
    const test1 = readLines(test1file);
    const inp = readLines(inputfile);

    var gt = Game.init(test1);
    assertStrEq("25467389", gt.part1(0));
    assertStrEq("54673289", gt.part1(1));
    assertStrEq("92658374", gt.part1(10));
    assertStrEq("67384529", gt.part1(100));
    var g = Game.init(inp);
    assertStrEq("92736584", g.part1(10));
    assertStrEq("63598274", g.part1(50));
    assertStrEq("46978532", g.part1(100));
}

test "part2" {
    const test1 = readLines(test1file);
    const inp = readLines(inputfile);

    var gt = Game.init(test1);
    assertEq(@as(usize, 136), gt.part2(30, 20));
    assertEq(@as(usize, 54), gt.part2(100, 20));
    assertEq(@as(usize, 42), gt.part2(1000, 20));
    assertEq(@as(usize, 285), gt.part2(10000, 20));
    assertEq(@as(usize, 285), gt.part2(10001, 20));
    assertEq(@as(usize, 12), gt.part2(10, 1000000));
    assertEq(@as(usize, 12), gt.part2(100, 1000000));
    assertEq(@as(usize, 126), gt.part2(1000000, 1000000));
    assertEq(@as(usize, 32999175), gt.part2(2000000, 1000000));
    assertEq(@as(usize, 149245887792), gt.part2(10000000, 1000000));

    var g = Game.init(inp);
    assertEq(@as(usize, 163035127721), g.part2(10000000, 1000000));
}

pub fn main() anyerror!void {
    const lines = readLines(input());
    var g = Game.init(lines);
    try print("Part1: {}\n", .{g.part1(100)});
    try print("Part2: {}\n", .{g.part2(10000000, 1000000)});
}
