usingnamespace @import("aoc-lib.zig");

const Map = struct {
    const MAX: usize = 22;
    const OFF: i8 = MAX / 2;

    cur: [MAX * MAX * MAX * MAX]bool,
    new: [MAX * MAX * MAX * MAX]bool,
    w: i8,
    w2: i8,
    debug: bool,

    const NB = [_]i8{ -1, 0, 1 };

    pub fn index(x: i8, y: i8, z: i8, q: i8) usize {
        return @intCast(usize, x) + MAX * (@intCast(usize, y) + MAX * (@intCast(usize, z) + MAX * @intCast(usize, q)));
    }

    pub fn fromInput(inp: [][]const u8, allocator: *Allocator) !*Map {
        var m = try alloc.create(Map);
        memset(bool, m.cur[0..], false);
        memset(bool, m.new[0..], false);
        var size: i8 = @intCast(i8, inp.len);
        m.w = size;
        var s2: i8 = size >> 1;
        m.w2 = s2;
        var y: i8 = 0;
        while (y < inp.len) {
            var x: i8 = 0;
            while (x < inp[@intCast(usize, y)].len) {
                if (inp[@intCast(usize, y)][@intCast(usize, x)] == '#') {
                    m.Set(OFF - s2 + x, OFF - s2 + y, OFF, OFF);
                }
                x += 1;
            }
            y += 1;
        }
        m.Swap();
        return m;
    }

    pub fn Print(self: *Map, iter: i8, part2: bool) void {
        var xystart: i8 = OFF - (1 + self.w2 + iter);
        var xyend: i8 = OFF + (2 + self.w2 + iter);
        var zstart: i8 = OFF - (1 + iter);
        var zend: i8 = OFF + (1 + iter);
        var qstart: i8 = OFF;
        var qend: i8 = OFF;
        if (part2) {
            qstart = zstart;
            qend = zend;
        }
        var q: i8 = qstart;
        while (q <= qend) {
            var z: i8 = zstart;
            while (z <= zend) {
                var y: i8 = xystart;
                warn("q={} z={}\n", .{ q, z });
                while (y <= xyend) {
                    var x: i8 = xystart;
                    while (x <= xyend) {
                        const cur = self.Get(x, y, z, q);
                        if (cur) {
                            warn("#", .{});
                            self.Set(x, y, z, q);
                        } else {
                            warn(".", .{});
                        }
                        x += 1;
                    }
                    warn(" ({} {})\n", .{ y, index(11, y, z, q) });
                    y += 1;
                }
                z += 1;
            }
            q += 1;
            warn("\n", .{});
        }
    }

    pub fn Set(self: *Map, x: i8, y: i8, z: i8, q: i8) void {
        self.new[index(x, y, z, q)] = true;
    }

    pub fn Get(self: *Map, x: i8, y: i8, z: i8, q: i8) bool {
        return self.cur[index(x, y, z, q)];
    }

    pub fn Swap(self: *Map) void {
        const tmp = self.cur;
        self.cur = self.new;
        self.new = tmp;
    }

    pub fn NeighbourCount(self: *Map, x: i8, y: i8, z: i8, q: i8, part2: bool) usize {
        var n: usize = 0;
        var qfirst: usize = 0;
        var qlast: usize = 3;
        if (!part2) {
            qfirst = 1;
            qlast = 2;
        }
        for (NB[qfirst..qlast]) |oq| {
            for (NB[0..3]) |oz| {
                for (NB[0..3]) |oy| {
                    for (NB[0..3]) |ox| {
                        if (ox == 0 and oy == 0 and oz == 0 and oq == 0) {
                            continue;
                        }
                        if (self.Get(x + ox, y + oy, z + oz, q + oq)) {
                            n += 1;
                        }
                    }
                }
            }
        }
        return n;
    }

    pub fn Iter(self: *Map, iter: i8, part2: bool) usize {
        var n: usize = 0;
        var a: usize = 0;
        memset(bool, self.new[0..], false);

        var xystart: i8 = OFF - (1 + self.w2 + iter);
        var xyend: i8 = OFF + (2 + self.w2 + iter);
        var zstart: i8 = OFF - (1 + iter);
        var zend: i8 = OFF + (1 + iter);
        var qstart: i8 = OFF;
        var qend: i8 = OFF;
        if (part2) {
            qstart = zstart;
            qend = zend;
        }
        var q: i8 = qstart;
        while (q <= qend) {
            var z: i8 = zstart;
            while (z <= zend) {
                var y: i8 = xystart;
                while (y <= xyend) {
                    var x: i8 = xystart;
                    while (x <= xyend) {
                        const nc = self.NeighbourCount(x, y, z, q, part2);
                        const cur = self.Get(x, y, z, q);
                        var new = false;
                        if ((cur and nc == 2) or nc == 3) {
                            new = true;
                        }
                        if (new) {
                            self.Set(x, y, z, q);
                            n += 1;
                        }
                        x += 1;
                    }
                    y += 1;
                }
                z += 1;
            }
            q += 1;
        }

        self.Swap();
        //self.Print(iter, part2);
        return n;
    }

    pub fn Calc(self: *Map, part2: bool) usize {
        var r: usize = 0;
        var i: i8 = 0;
        while (i < 6) {
            r = self.Iter(i, part2);
            if (self.debug) {
                warn("Iter {}: {}\n", .{ i, r });
            }
            i += 1;
        }
        return r;
    }

    pub fn Part1(self: *Map) !usize {
        return self.Calc(false);
    }

    pub fn Part2(self: *Map) !usize {
        return self.Calc(true);
    }
};

test "part1" {
    const test0 = readLines(test0file);
    const test1 = readLines(test1file);
    const inp = readLines(inputfile);

    var t1m = Map.fromInput(test1, alloc) catch unreachable;
    assertEq(@as(usize, 112), try t1m.Part1());

    t1m = Map.fromInput(test1, alloc) catch unreachable;
    assertEq(@as(usize, 848), try t1m.Part2());

    var m = Map.fromInput(inp, alloc) catch unreachable;
    assertEq(@as(usize, 209), try m.Part1());

    m = Map.fromInput(inp, alloc) catch unreachable;
    assertEq(@as(usize, 1492), try m.Part2());
}

pub fn main() anyerror!void {
    const lines = readLines(input());
    var m = try Map.fromInput(lines, alloc);
    try print("Part1: {}\n", .{m.Part1()});
    m = try Map.fromInput(lines, alloc);
    try print("Part2: {}\n", .{m.Part2()});
}
