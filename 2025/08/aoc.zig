const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

const Point = struct {
    x: isize,
    y: isize,
    z: isize,
};

const Dist = struct {
    d: u32,
    a: u16,
    b: u16,
};

fn parts(inp: []const u8) anyerror![2]usize {
    var point = try std.BoundedArray(Point, 1024).init(0);
    {
        var i: usize = 0;
        while (i < inp.len) : (i += 1) {
            const x = try aoc.chompUint(isize, inp, &i);
            i += 1;
            const y = try aoc.chompUint(isize, inp, &i);
            i += 1;
            const z = try aoc.chompUint(isize, inp, &i);
            try point.append(Point{ .x = x, .y = y, .z = z });
        }
    }
    const points = point.slice();
    var dist = try std.ArrayList(Dist).initCapacity(aoc.halloc, 500000);
    defer dist.deinit();
    for (0..points.len) |i| {
        for (i + 1..points.len) |j| {
            const dx = points[i].x - points[j].x;
            const dy = points[i].y - points[j].y;
            const dz = points[i].z - points[j].z;
            const fdx = @as(f32, @floatFromInt(dx * dx));
            const fdy = @as(f32, @floatFromInt(dy * dy));
            const fdz = @as(f32, @floatFromInt(dz * dz));
            const d: u32 = @intFromFloat(std.math.sqrt(fdx + fdy + fdz));
            try dist.append(Dist{ .d = d, .a = @intCast(i), .b = @intCast(j) });
        }
    }

    const dists = dist.items;
    std.mem.sort(Dist, dists[0..], {}, cmp_dist);

    const conns: usize = init: {
        var conns: usize = 1000;
        if (points.len < 30) {
            conns = 10;
        }
        break :init conns;
    };

    var uf = UnionFind.init(points.len);
    var p1: usize = 0;
    var p2: usize = 0;
    var count: usize = 0;
    for (dists) |d| {
        const s = uf.join(d.a, d.b);
        count += 1;
        if (s == points.len) {
            p2 = @intCast(points[d.a].x * points[d.b].x);
            break;
        }
        if (count == conns) {
            var s0: usize = 0;
            var s1: usize = 0;
            var s2: usize = 0;
            for (0..uf.size.len) |i| {
                var n = uf.size[i];
                if (s0 < n) {
                    std.mem.swap(usize, &s0, &n);
                }
                if (s1 < n) {
                    std.mem.swap(usize, &s1, &n);
                }
                if (s2 < n) {
                    std.mem.swap(usize, &s2, &n);
                }
            }
            p1 = s0 * s1 * s2;
        }
    }

    return [2]usize{ p1, p2 };
}

const UnionFind = struct {
    parent: [1000]usize,
    size: [1000]usize,
    n: usize,
    fn init(n: usize) UnionFind {
        var uf = UnionFind{
            .parent = .{0} ** 1000,
            .size = .{1} ** 1000,
            .n = n,
        };
        for (0..n) |i| {
            uf.parent[i] = i;
        }
        return uf;
    }
    fn find(uf: *UnionFind, i: usize) usize {
        var p = uf.parent[i];
        if (p == i) {
            return i;
        }
        p = uf.find(p);
        uf.parent[i] = p;
        return p;
    }
    inline fn join(uf: *UnionFind, i: usize, j: usize) usize {
        const ir = uf.find(i);
        const jr = uf.find(j);
        if (ir == jr) {
            return uf.size[ir];
        }
        uf.parent[jr] = ir;
        uf.size[ir] += uf.size[jr];
        uf.size[jr] = 0;
        return uf.size[ir];
    }
};

fn cmp_dist(_: void, a: Dist, b: Dist) bool {
    return a.d < b.d;
}

fn day(inp: []const u8, bench: bool) anyerror!void {
    const p = try parts(inp);
    if (!bench) {
        aoc.print("Part1: {}\nPart2: {}\n", .{ p[0], p[1] });
    }
}

pub fn main() anyerror!void {
    try aoc.benchme(aoc.input(), day);
}
