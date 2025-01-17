const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

const Int = i32;

pub fn BoundingBox(comptime T: type) type {
    return struct {
        min: T,
        max: T,
        const Self = @This();
        pub fn init() Self {
            return Self{ .min = std.math.maxInt(T), .max = std.math.minInt(T) };
        }
        pub fn initWith(min: T, max: T) Self {
            return Self{ .min = min, .max = max };
        }
        pub fn add(self: *Self, n: T) void {
            if (self.min > n) {
                self.min = n;
            }
            if (self.max < n) {
                self.max = n;
            }
        }
        pub fn size(self: *Self) T {
            return self.max - self.min;
        }
        pub fn reset(self: *Self) void {
            self.min = std.math.maxInt(T);
            self.max = std.math.minInt(T);
        }
    };
}

const Rec = struct { x: Int, y: Int, z: Int, r: Int };
const MAX_BOTS = 1024;

fn parts(inp: []const u8) anyerror![2]usize {
    var bx = BoundingBox(Int).init();
    var by = BoundingBox(Int).init();
    var bz = BoundingBox(Int).init();
    var max_r: Int = 0;
    var max_i: usize = 0;
    var s = try std.BoundedArray(Rec, MAX_BOTS).init(0);
    {
        var i: usize = 0;
        while (i < inp.len) : (i += 1) {
            i += 5;
            const x = try aoc.chompInt(Int, inp, &i);
            i += 1;
            const y = try aoc.chompInt(Int, inp, &i);
            i += 1;
            const z = try aoc.chompInt(Int, inp, &i);
            i += 5;
            const r = try aoc.chompUint(Int, inp, &i);
            try s.append(Rec{ .x = x, .y = y, .z = z, .r = r });
            bx.add(x);
            by.add(y);
            bz.add(z);
            if (r > max_r) {
                max_r = r;
                max_i = s.len - 1;
            }
        }
    }
    const bots = s.slice();
    const p1 = countInRange(bots[0..], bots[max_i].x, bots[max_i].y, bots[max_i].z, max_r);

    var scale: Int = 1;
    while (@divTrunc(bx.size(), scale) > 64 or @divTrunc(by.size(), scale) > 64 or @divTrunc(bz.size(), scale) > 64) : (scale <<= 1) {}
    var bsx = BoundingBox(Int).initWith(scaleInt(bx.min, scale), scaleInt(bx.max, scale));
    var bsy = BoundingBox(Int).initWith(scaleInt(by.min, scale), scaleInt(by.max, scale));
    var bsz = BoundingBox(Int).initWith(scaleInt(bz.min, scale), scaleInt(bz.max, scale));
    var best = try std.BoundedArray([3]Int, 4096).init(0);
    while (true) {
        var scaled = try std.BoundedArray(Rec, MAX_BOTS).init(0);
        for (bots) |b| {
            try scaled.append(Rec{ .x = scaleInt(b.x, scale), .y = scaleInt(b.y, scale), .z = scaleInt(b.z, scale), .r = scaleInt(b.r, scale) });
        }
        var min: usize = scaled.len - 1;
        var sbots = scaled.slice();
        var z = bsz.min;
        while (z <= bsz.max) : (z += 1) {
            var y = bsy.min;
            while (y <= bsy.max) : (y += 1) {
                var x = bsx.min;
                while (x <= bsx.max) : (x += 1) {
                    const count = countInRangePoint(sbots[0..], x, y, z);
                    const missing = sbots.len - count;
                    if (missing == min) {
                        try best.append([3]Int{ x, y, z });
                    } else if (missing < min) {
                        //aoc.print("New best {},{},{}, missing {}\n", .{ x, y, z, missing });
                        try best.resize(0);
                        try best.append([3]Int{ x, y, z });
                        min = missing;
                    }
                }
            }
        }
        if (scale == 1) {
            break;
        }
        scale >>= 1;
        bsx.reset();
        bsy.reset();
        bsz.reset();
        for (best.slice()) |b| {
            const nx = b[0] * 2;
            bsx.add(nx - 2);
            bsx.add(nx + 2);
            const ny = b[1] * 2;
            bsy.add(ny - 2);
            bsy.add(ny + 2);
            const nz = b[2] * 2;
            bsz.add(nz - 2);
            bsz.add(nz + 2);
        }
        try best.resize(0);
        try scaled.resize(0);
    }
    const b = best.get(0);
    const p2 = @abs(b[0]) + @abs(b[1]) + @abs(b[2]);
    return [2]usize{ p1, p2 };
}

inline fn scaleInt(x: Int, s: Int) Int {
    const fx: f64 = @floatFromInt(x);
    const fs: f64 = @floatFromInt(s);
    return @intFromFloat(@round(fx / fs));
}

fn countInRangePoint(bots: []Rec, x: Int, y: Int, z: Int) usize {
    var c: usize = 0;
    for (bots) |b| {
        const d = @abs(x - b.x) + @abs(y - b.y) + @abs(z - b.z);
        if (d <= b.r) {
            c += 1;
        }
    }
    return c;
}

fn countInRange(bots: []Rec, x: Int, y: Int, z: Int, r: Int) usize {
    var c: usize = 0;
    for (bots) |b| {
        const d = @abs(x - b.x) + @abs(y - b.y) + @abs(z - b.z);
        if (d <= r) {
            c += 1;
        }
    }
    return c;
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
