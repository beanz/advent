const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

const Cuboid = struct {
    value: bool,
    xMin: i32,
    xMax: i32,
    yMin: i32,
    yMax: i32,
    zMin: i32,
    zMax: i32,
    fn new(value: bool, x: i32, xm: i32, y: i32, ym: i32, z: i32, zm: i32) Cuboid {
        return Cuboid{
            .value = value,
            .xMin = x,
            .xMax = xm,
            .yMin = y,
            .yMax = ym,
            .zMin = z,
            .zMax = zm,
        };
    }
    fn volume(self: *const Cuboid) usize {
        return @as(usize, @intCast(self.xMax - self.xMin)) * @as(usize, @intCast(self.yMax - self.yMin)) * @as(usize, @intCast(self.zMax - self.zMin));
    }

    fn contains(self: *const Cuboid, other: *const Cuboid) bool {
        return self.xMin <= other.xMin and self.xMax >= other.xMax and self.yMin <= other.yMin and self.yMax >= other.yMax and self.zMin <= other.zMin and self.zMax >= other.zMax;
    }
    fn intersects(self: *const Cuboid, other: *const Cuboid) bool {
        return self.xMin <= other.xMax and self.xMax >= other.xMin and self.yMin <= other.yMax and self.yMax >= other.yMin and self.zMin <= other.zMax and self.zMax >= other.zMin;
    }
    fn intersection(self: *const Cuboid, other: *const Cuboid) ?Cuboid {
        if (!self.intersects(other)) {
            return null;
        }
        return Cuboid{
            .value = self.value,
            .xMin = @max(self.xMin, other.xMin),
            .xMax = @min(self.xMax, other.xMax),
            .yMin = @max(self.yMin, other.yMin),
            .yMax = @min(self.yMax, other.yMax),
            .zMin = @max(self.zMin, other.zMin),
            .zMax = @min(self.zMax, other.zMax),
        };
    }
};

const SIZE = 16384;

fn parts(inp: []const u8) anyerror![2]usize {
    var initial = try std.BoundedArray(Cuboid, 512).init(0);
    {
        var i: usize = 0;
        while (i < inp.len) : (i += 1) {
            var value = true;
            if (inp[i + 1] == 'n') {
                i += 5;
            } else {
                i += 6;
                value = false;
            }
            const xMin = try aoc.chompInt(i32, inp, &i);
            i += 2;
            const xMax = try aoc.chompInt(i32, inp, &i);
            i += 3;
            const yMin = try aoc.chompInt(i32, inp, &i);
            i += 2;
            const yMax = try aoc.chompInt(i32, inp, &i);
            i += 3;
            const zMin = try aoc.chompInt(i32, inp, &i);
            i += 2;
            const zMax = try aoc.chompInt(i32, inp, &i);
            try initial.append(Cuboid{
                .value = value,
                .xMin = xMin,
                .xMax = xMax + 1,
                .yMin = yMin,
                .yMax = yMax + 1,
                .zMin = zMin,
                .zMax = zMax + 1,
            });
        }
    }
    var cuboids = try std.BoundedArray(Cuboid, SIZE).init(0);
    var next = try std.BoundedArray(Cuboid, SIZE).init(0);
    for (initial.slice()) |c| {
        for (cuboids.slice()) |old| {
            if (c.contains(&old)) {
                continue;
            }
            if (!old.intersects(&c)) {
                try next.append(old);
                continue;
            }
            var xs = try std.BoundedArray(i32, 4).init(0);
            try xs.append(old.xMin);
            if (old.xMin < c.xMin and c.xMin < old.xMax) {
                try xs.append(c.xMin);
            }
            if (old.xMin < c.xMax and c.xMax < old.xMax) {
                try xs.append(c.xMax);
            }
            try xs.append(old.xMax);
            var ys = try std.BoundedArray(i32, 4).init(0);
            try ys.append(old.yMin);
            if (old.yMin < c.yMin and c.yMin < old.yMax) {
                try ys.append(c.yMin);
            }
            if (old.yMin < c.yMax and c.yMax < old.yMax) {
                try ys.append(c.yMax);
            }
            try ys.append(old.yMax);
            var zs = try std.BoundedArray(i32, 4).init(0);
            try zs.append(old.zMin);
            if (old.zMin < c.zMin and c.zMin < old.zMax) {
                try zs.append(c.zMin);
            }
            if (old.zMin < c.zMax and c.zMax < old.zMax) {
                try zs.append(c.zMax);
            }
            try zs.append(old.zMax);
            const x = xs.slice();
            const y = ys.slice();
            const z = zs.slice();
            for (0..x.len - 1) |xi| {
                for (0..y.len - 1) |yi| {
                    for (0..z.len - 1) |zi| {
                        const n = Cuboid{
                            .value = old.value,
                            .xMin = x[xi],
                            .xMax = x[xi + 1],
                            .yMin = y[yi],
                            .yMax = y[yi + 1],
                            .zMin = z[zi],
                            .zMax = z[zi + 1],
                        };
                        if (!c.contains(&n)) {
                            try next.append(n);
                        }
                    }
                }
            }
        }
        if (c.value) {
            try next.append(c);
        }
        std.mem.swap(std.BoundedArray(Cuboid, SIZE), &cuboids, &next);
        try next.resize(0);
    }
    var p1: usize = 0;
    var p2: usize = 0;
    const p1Region = Cuboid{
        .value = true,
        .xMin = -50,
        .xMax = 51,
        .yMin = -50,
        .yMax = 51,
        .zMin = -50,
        .zMax = 51,
    };
    for (cuboids.slice()) |c| {
        p2 += c.volume();
        if (c.intersection(&p1Region)) |i| {
            p1 += i.volume();
        }
    }
    return [2]usize{ p1, p2 };
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
