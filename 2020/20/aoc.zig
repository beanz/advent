usingnamespace @import("aoc-lib.zig");

const Tile = struct {
    num: usize,
    lines: [][]u8,
    width: usize,
    top: u10,
    right: u10,
    bottom: u10,
    left: u10,
    alloc: *Allocator,

    pub fn init(chunk: []const u8, alloc: *Allocator) !*Tile {
        var s = try alloc.create(Tile);
        s.alloc = alloc;
        var lit = split(chunk, "\n");
        var first = lit.next().?;
        s.num = parseUnsigned(usize, first[5..9], 10) catch unreachable;
        var ls = ArrayList([]u8).init(alloc);
        defer ls.deinit();
        while (lit.next()) |line| {
            var x = try alloc.dupe(u8, line);
            try ls.append(x);
        }
        s.lines = ls.toOwnedSlice();
        s.width = s.lines.len;
        s.calc_edges();
        return s;
    }

    pub fn deinit(s: *Tile) void {
        for (s.lines) |_, i| {
            s.alloc.free(s.lines[i]);
        }
        s.alloc.free(s.lines);
        s.alloc.destroy(s);
    }

    pub fn flip(s: *Tile) void {
        reverseLines(s.lines);
        s.calc_edges();
    }

    pub fn rotate(s: *Tile) void {
        rotateLines(s.lines);
        s.calc_edges();
    }

    pub fn calc_edges(s: *Tile) void {
        const end = s.width - 1;
        s.top = 0;
        s.right = 0;
        s.bottom = 0;
        s.left = 0;
        var i: usize = 0;
        while (i < s.width) : (i += 1) {
            s.top <<= 1;
            s.left <<= 1;
            s.bottom <<= 1;
            s.right <<= 1;
            if (s.lines[0][i] == '#') {
                s.top += 1;
            }
            if (s.lines[end][i] == '#') {
                s.bottom += 1;
            }
            if (s.lines[i][end] == '#') {
                s.right += 1;
            }
            if (s.lines[i][0] == '#') {
                s.left += 1;
            }
        }
    }
};

test "tile" {
    var t = try Tile.init("Tile 1951:\n.#.\n.##\n#.#", talloc);
    defer t.deinit();
    try assertEq(@as(usize, 1951), t.num);
    try assertEq(@as(u10, 2), t.top);
    try assertEq(@as(u10, 3), t.right);
    try assertEq(@as(u10, 5), t.bottom);
    try assertEq(@as(u10, 1), t.left);
    t.flip();
    try assertEq(@as(u10, 5), t.top);
    try assertEq(@as(u10, 6), t.right);
    try assertEq(@as(u10, 2), t.bottom);
    try assertEq(@as(u10, 4), t.left);
    t.flip();
    try assertEq(@as(u10, 2), t.top);
    try assertEq(@as(u10, 3), t.right);
    try assertEq(@as(u10, 5), t.bottom);
    try assertEq(@as(u10, 1), t.left);
    t.rotate();
    try assertEq(@as(u10, 4), t.top);
    try assertEq(@as(u10, 2), t.right);
    try assertEq(@as(u10, 6), t.bottom);
    try assertEq(@as(u10, 5), t.left);
    t.rotate();
    try assertEq(@as(u10, 5), t.top);
    try assertEq(@as(u10, 4), t.right);
    try assertEq(@as(u10, 2), t.bottom);
    try assertEq(@as(u10, 6), t.left);
}

fn CanonicalEdge(e: u10) u10 {
    const r = @bitReverse(u10, e);
    if (e < r) {
        return e;
    } else {
        return r;
    }
}

test "canonical" {
    try assertEq(@as(u10, 210), CanonicalEdge(@as(u10, 300)));
    try assertEq(@as(u10, 791), CanonicalEdge(@as(u10, 931)));
}

const Water = struct {
    tiles: AutoHashMap(usize, *Tile),
    edges: AutoHashMap(usize, ArrayList(usize)),
    starter: usize,
    width: usize,
    alloc: *Allocator,
    debug: bool,

    pub fn init(in: [][]const u8, alloc: *Allocator) !*Water {
        var s = try alloc.create(Water);
        s.alloc = alloc;
        s.debug = false;
        s.tiles = AutoHashMap(usize, *Tile).init(alloc);
        s.edges = AutoHashMap(usize, ArrayList(usize)).init(alloc);
        s.starter = 0;
        for (in) |chunk| {
            var tile = try Tile.init(chunk, alloc);
            try s.tiles.put(tile.num, tile);
            for ([_]u10{ tile.top, tile.right, tile.bottom, tile.left }) |e| {
                const ce = CanonicalEdge(e);
                var kv = try s.edges.getOrPutValue(ce, ArrayList(usize).init(alloc));
                try kv.value_ptr.append(tile.num);
            }
        }
        s.width = isqrt(s.tiles.count());
        if (s.debug) {
            warn("width {}\n", .{s.width});
        }

        return s;
    }

    pub fn deinit(s: *Water) void {
        var it = s.tiles.iterator();
        while (it.next()) |e| {
            e.value_ptr.*.deinit();
        }
        s.tiles.deinit();
        var eit = s.edges.iterator();
        while (eit.next()) |e| {
            e.value_ptr.*.deinit();
        }
        s.edges.deinit();
        s.alloc.destroy(s);
    }

    pub fn EdgeTileCount(s: *Water, e: u10) usize {
        const ce = CanonicalEdge(e);
        return (s.edges.get(ce) orelse unreachable).items.len;
    }

    pub fn Part1(s: *Water) usize {
        var p: usize = 1;
        var it = s.tiles.iterator();
        while (it.next()) |kv| {
            var tile = kv.value_ptr.*;
            var c: usize = 0;
            for ([_]u10{ tile.top, tile.right, tile.bottom, tile.left }) |e| {
                if (s.EdgeTileCount(e) > 1) {
                    c += 1;
                }
            }
            if (c == 2) {
                if (s.debug) {
                    warn("Found corner {}\n", .{tile.num});
                }
                p *= tile.num;
                s.starter = tile.num; // starter corner for part 2
            }
        }
        return p;
    }

    pub fn EdgeTiles(s: *Water, e: u10) []usize {
        const ce = CanonicalEdge(e);
        return (s.edges.get(ce) orelse unreachable).items;
    }

    pub fn FindRightTile(s: *Water, n: usize) usize {
        var t = s.tiles.get(n) orelse unreachable;
        var edge = t.right;
        var matching = s.EdgeTiles(edge);
        var match: usize = 0;
        for (matching) |tn| {
            if (tn != t.num) {
                match = tn;
                break;
            }
        }
        if (match == 0) {
            if (s.debug) {
                warn("no match found\n", .{});
            }
            return 0;
        }
        if (s.debug) {
            warn("  found next tile {}\n", .{match});
        }
        var next = s.tiles.get(match) orelse unreachable;
        var i: u8 = 0;
        while (i < 8) : (i += 1) {
            if (next.left == edge) {
                return next.num;
            }
            if (i == 3) {
                next.flip();
            } else {
                next.rotate();
            }
        }
        warn("Failed to find next tile orientation\n", .{});
        return 0;
    }

    pub fn FindBottomTile(s: *Water, n: usize) usize {
        var t = s.tiles.get(n) orelse unreachable;
        var edge = t.bottom;
        var matching = s.EdgeTiles(edge);
        var match: usize = 0;
        for (matching) |tn| {
            if (tn != t.num) {
                match = tn;
                break;
            }
        }
        if (match == 0) {
            if (s.debug) {
                warn("no match found\n", .{});
            }
            return 0;
        }
        if (s.debug) {
            warn("  found next tile {}\n", .{match});
        }
        var next = s.tiles.get(match) orelse unreachable;
        var i: u8 = 0;
        while (i < 8) : (i += 1) {
            if (next.top == edge) {
                return next.num;
            }
            if (i == 3) {
                next.flip();
            } else {
                next.rotate();
            }
        }
        warn("  Failed to find next tile orientation\n", .{});
        return 0;
    }

    fn isqrt(x: usize) usize {
        const ix = @intCast(isize, x);
        var q: isize = 1;
        while (q <= ix) {
            q <<= 2;
        }
        var z = ix;
        var r: isize = 0;
        while (q > 1) {
            q >>= 2;
            var t = z - r - q;
            r >>= 1;
            if (t >= 0) {
                z = t;
                r += q;
            }
        }
        return @intCast(usize, r);
    }

    pub fn Image(s: *Water) [][]const u8 {
        var layout = s.alloc.alloc(usize, s.tiles.count()) catch unreachable;
        defer s.alloc.free(layout);
        if (s.starter == 0) {
            _ = s.Part1();
        }
        if (s.debug) {
            warn("Starting with corner {}\n", .{s.starter});
        }
        var t = s.tiles.get(s.starter) orelse unreachable;
        while (s.EdgeTileCount(t.right) != 2 or s.EdgeTileCount(t.bottom) != 2) {
            t.rotate();
        }
        layout[0] = t.num;
        var i: usize = 1;
        while (i < s.width * s.width) : (i += 1) {
            var tn: usize = undefined;
            if ((i % s.width) == 0) {
                tn = s.FindBottomTile(layout[i - s.width]);
            } else {
                tn = s.FindRightTile(layout[i - 1]);
            }
            if (tn == 0) {
                warn("failed to find next tile\n", .{});
                unreachable;
            }
            if (s.debug) {
                warn("Found #{}: {}\n", .{ i, tn });
            }
            layout[i] = tn;
        }
        var tl = t.width - 2;
        var nl = s.width * tl;
        var res = s.alloc.alloc([]u8, nl) catch unreachable;
        var irow: usize = 0;
        while (irow < s.width) : (irow += 1) {
            var trow: usize = 0;
            while (trow < t.width - 2) : (trow += 1) {
                res[irow * tl + trow] = s.alloc.alloc(u8, nl) catch unreachable;
                var icol: usize = 0;
                while (icol < s.width) : (icol += 1) {
                    var tt = s.tiles.get(layout[irow * s.width + icol]) orelse unreachable;
                    var tcol: usize = 0;
                    while (tcol < t.width - 2) : (tcol += 1) {
                        res[irow * tl + trow][icol * tl + tcol] = tt.lines[trow + 1][tcol + 1];
                    }
                }
            }
        }
        return res;
    }

    pub fn Part2(s: *Water) usize {
        var image = s.Image();
        defer {
            for (image) |_, j| {
                s.alloc.free(image[j]);
            }
            s.alloc.free(image);
        }
        if (s.debug) {
            for (image) |l| {
                warn("{s}\n", .{l});
            }
            warn("\n", .{});
        }
        const monster = readLines(@embedFile("monster.txt"), s.alloc);
        defer s.alloc.free(monster);
        const mh = monster.len;
        const mw = monster[0].len;
        var monsterSize: usize = countCharsInLines(monster, '#');
        const ih = image.len;
        const iw = image[0].len;
        if (s.debug) {
            warn("image {} x {}\n", .{ iw, ih });
            warn("monster {} x {} #={}\n", .{ mw, mh, monsterSize });
        }
        var i: usize = 0;
        var mchars: usize = 0;
        while (i < 8) : (i += 1) {
            var r: usize = 0;
            while (r < (ih - mh)) : (r += 1) {
                var c: usize = 0;
                while (c < (iw - mw)) : (c += 1) {
                    var match: bool = true;
                    var mr: usize = 0;
                    while (mr < mh and match) : (mr += 1) {
                        var mc: usize = 0;
                        while (mc < mw and match) : (mc += 1) {
                            if (monster[mr][mc] != '#') {
                                continue;
                            }
                            if (image[r + mr][c + mc] != '#') {
                                match = false;
                            }
                        }
                    }
                    if (match) {
                        if (s.debug) {
                            warn("found monster at {},{}\n", .{ c, r });
                        }
                        mchars += monsterSize;
                    }
                }
            }
            if (i == 3) {
                reverseLines(image);
            } else {
                var old = image;
                defer {
                    for (old) |_, j| {
                        s.alloc.free(old[j]);
                    }
                    s.alloc.free(old);
                }
                image = rotateLinesNonSymmetric(image, s.alloc);
            }
        }
        var c: usize = countCharsInLines(image, '#');
        return c - mchars;
    }
};

test "part1" {
    const test1 = readChunks(test1file, talloc);
    defer talloc.free(test1);
    const inp = readChunks(inputfile, talloc);
    defer talloc.free(inp);

    var wt = try Water.init(test1, talloc);
    defer wt.deinit();
    try assertEq(@as(usize, 20899048083289), wt.Part1());

    var w = try Water.init(inp, talloc);
    defer w.deinit();
    try assertEq(@as(usize, 17712468069479), w.Part1());
}

test "part2" {
    const test1 = readChunks(test1file, talloc);
    defer talloc.free(test1);
    const inp = readChunks(inputfile, talloc);
    defer talloc.free(inp);
    var wt = try Water.init(test1, talloc);
    defer wt.deinit();
    try assertEq(@as(usize, 273), wt.Part2());

    var w = try Water.init(inp, talloc);
    defer w.deinit();
    try assertEq(@as(usize, 2173), w.Part2());
}

fn aoc(inp: []const u8, bench: bool) anyerror!void {
    const chunks = readChunks(inp, halloc);
    defer halloc.free(chunks);
    var w = try Water.init(chunks, halloc);
    defer w.deinit();
    var p1 = w.Part1();
    var p2 = w.Part2();
    if (!bench) {
        try print("Part 1: {}\nPart 2: {}\n", .{ p1, p2 });
    }
}

pub fn main() anyerror!void {
    try benchme(input(), aoc);
}
