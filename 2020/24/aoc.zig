usingnamespace @import("aoc-lib.zig");

pub fn HexTile(q: i8, r: i8) usize {
    return @intCast(usize, ((@intCast(i32, q) + 127) << 8) + (@intCast(i32, r) + 127));
}

pub fn Q(ht: usize) i8 {
    return @intCast(i8, @intCast(i32, (ht >> 8)) - 127);
}
pub fn R(ht: usize) i8 {
    return @intCast(i8, @intCast(i32, (ht & 0xff)) - 127);
}

pub fn HexTileNeighbours(ht: usize) [6]usize {
    var q = Q(ht);
    var r = R(ht);
    return [_]usize{
        HexTile(q + 1, r + 0),
        HexTile(q + 0, r - 1),
        HexTile(q - 1, r - 1),
        HexTile(q - 1, r + 0),
        HexTile(q + 0, r + 1),
        HexTile(q + 1, r + 1),
    };
}

pub fn HexTileFromString(m: []const u8) usize {
    var q: i8 = 0;
    var r: i8 = 0;
    var i: usize = 0;
    while (i < m.len) : (i += 1) {
        switch (m[i]) {
            'e' => {
                q += 1;
            },
            'w' => {
                q -= 1;
            },
            's' => {
                if (m[i + 1] == 'e') {
                    r -= 1;
                } else {
                    q -= 1;
                    r -= 1;
                }
                i += 1;
            },
            'n' => {
                if (m[i + 1] == 'e') {
                    q += 1;
                    r += 1;
                } else {
                    r += 1;
                }
                i += 1;
            },
            else => {
                unreachable;
            },
        }
    }
    return HexTile(q, r);
}

test "hex tile" {
    var ht = HexTileFromString("sesenwnenenewseeswwswswwnenewsewsw");
    try assertEq(@as(i8, -3), Q(ht));
    try assertEq(@as(i8, -2), R(ht));
    var n = HexTileNeighbours(ht);
    try assertEq(@as(i8, -2), Q(n[0]));
    try assertEq(@as(i8, -2), R(n[0]));

    try assertEq(@as(i8, -3), Q(n[1]));
    try assertEq(@as(i8, -3), R(n[1]));

    try assertEq(@as(i8, -4), Q(n[2]));
    try assertEq(@as(i8, -3), R(n[2]));

    try assertEq(@as(i8, -4), Q(n[3]));
    try assertEq(@as(i8, -2), R(n[3]));

    try assertEq(@as(i8, -3), Q(n[4]));
    try assertEq(@as(i8, -1), R(n[4]));

    try assertEq(@as(i8, -2), Q(n[5]));
    try assertEq(@as(i8, -1), R(n[5]));
}

const HexLife = struct {
    pub const State = enum(u2) { white, black };
    pub const BB = struct {
        qmin: i8,
        qmax: i8,
        rmin: i8,
        rmax: i8,
        pub fn init(allocator: *Allocator) !*BB {
            var s = try allocator.create(BB);
            s.qmin = maxInt(i8);
            s.qmax = minInt(i8);
            s.rmin = maxInt(i8);
            s.rmax = minInt(i8);
            return s;
        }
        pub fn reset(s: *BB) void {
            s.qmin = maxInt(i8);
            s.qmax = minInt(i8);
            s.rmin = maxInt(i8);
            s.rmax = minInt(i8);
        }
        pub fn Update(s: *BB, q: i8, r: i8) void {
            if (q < s.qmin) {
                s.qmin = q;
            }
            if (q > s.qmax) {
                s.qmax = q;
            }
            if (r < s.rmin) {
                s.rmin = r;
            }
            if (r > s.rmax) {
                s.rmax = r;
            }
        }
    };
    init: AutoHashMap(usize, State),
    debug: bool,

    pub fn init(in: [][]const u8, allocator: *Allocator) !*HexLife {
        var s = try allocator.create(HexLife);
        s.debug = false;
        s.init = AutoHashMap(usize, State).init(allocator);
        for (in) |line| {
            var ht = HexTileFromString(line);
            if (s.init.contains(ht)) {
                _ = s.init.remove(ht);
            } else {
                try s.init.put(ht, .black);
            }
        }
        return s;
    }

    pub fn Part1(s: *HexLife) usize {
        return s.init.count();
    }

    pub fn Part2(s: *HexLife, days: usize) usize {
        var cur = AutoHashMap(usize, State).init(alloc);
        var cur_bb = BB.init(alloc) catch unreachable;
        var it = s.init.iterator();
        while (it.next()) |e| {
            var ht = e.key_ptr.*;
            cur.put(ht, .black) catch unreachable;
            cur_bb.Update(Q(ht), R(ht));
        }
        var next = AutoHashMap(usize, State).init(alloc);
        var day: usize = 1;
        var bc: usize = 0;
        var next_bb = BB.init(alloc) catch unreachable;
        while (day <= days) : (day += 1) {
            bc = 0;
            var q = cur_bb.qmin - 1;
            while (q <= cur_bb.qmax + 1) : (q += 1) {
                var r = cur_bb.rmin - 1;
                while (r <= cur_bb.rmax + 1) : (r += 1) {
                    var nc: usize = 0;
                    var ht = HexTile(q, r);
                    for (HexTileNeighbours(ht)) |n| {
                        var nst = cur.get(n) orelse .white;
                        if (nst == .black) {
                            nc += 1;
                        }
                    }
                    var st = cur.get(ht) orelse .white;
                    if ((st == .black and !(nc == 0 or nc > 2)) or
                        (st == .white and nc == 2))
                    {
                        next.put(ht, .black) catch unreachable;
                        bc += 1;
                        next_bb.Update(Q(ht), R(ht));
                    }
                }
            }
            if (s.debug) {
                warn("Day {}: {} ({})\n", .{ day, bc, next.count() });
            }
            var tmp = cur;
            cur = next;
            next = tmp;
            next.clearAndFree();
            var tmp_bb = cur_bb;
            cur_bb = next_bb;
            next_bb = tmp_bb;
            next_bb.reset();
        }
        if (s.debug) {
            warn("N: {} - {}  {} - {}\n", .{
                cur_bb.qmin, cur_bb.qmax,
                cur_bb.rmin, cur_bb.rmax,
            });
        }
        return bc;
    }
};

test "hex life part1" {
    const test1 = readLines(test1file);
    const inp = readLines(inputfile);

    var gt = try HexLife.init(test1, alloc);
    try assertEq(@as(usize, 10), gt.Part1());
    var g = try HexLife.init(inp, alloc);
    try assertEq(@as(usize, 307), g.Part1());
}

test "hex life part2" {
    const test1 = readLines(test1file);
    const inp = readLines(inputfile);

    var gt = try HexLife.init(test1, alloc);
    var g = try HexLife.init(inp, alloc);

    try assertEq(@as(usize, 15), gt.Part2(1));
    try assertEq(@as(usize, 12), gt.Part2(2));
    try assertEq(@as(usize, 37), gt.Part2(10));
    try assertEq(@as(usize, 2208), gt.Part2(100));
    try assertEq(@as(usize, 3787), g.Part2(100));
}

pub fn main() anyerror!void {
    const lines = readLines(input());
    var g = try HexLife.init(lines, alloc);
    try print("Part1: {}\n", .{g.Part1()});
    try print("Part2: {}\n", .{g.Part2(100)});
}
