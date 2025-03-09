const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

fn parts(inp: []const u8) anyerror![2]usize {
    var hs = try std.BoundedArray([6]i64, 300).init(0);
    var it = aoc.intIter(i64, inp);
    while (it.next()) |x| {
        const y = it.next().?;
        const z = it.next().?;
        const vx = it.next().?;
        const vy = it.next().?;
        const vz = it.next().?;
        try hs.append([6]i64{ x, y, z, vx, vy, vz });
    }
    const hailstones = hs.slice();
    const min: i64, const max: i64 = .{ 200000000000000, 400000000000000 };
    var part1: usize = 0;
    {
        for (0..hailstones.len) |i| {
            const a = hailstones[i];
            const ax, const ay, const avx, const avy = .{ a[0], a[1], a[3], a[4] };
            for (i + 1..hailstones.len) |j| {
                const b = hailstones[j];
                const bx, const by, const bvx, const bvy = .{ b[0], b[1], b[3], b[4] };
                const deter = avy * bvx - avx * bvy;
                if (deter == 0) {
                    continue;
                }
                const ta = @divFloor(bvx * (by - ay) - bvy * (bx - ax), deter);
                const tb = @divFloor(avx * (by - ay) - avy * (bx - ax), deter);
                if (ta < 0 or tb < 0) {
                    continue;
                }
                const x = ax + ta * avx;
                const y = ay + ta * avy;
                if (min > x or x > max) {
                    continue;
                }
                if (min > y or y > max) {
                    continue;
                }
                part1 += 1;
            }
        }
    }
    var part2: i128 = undefined;
    {
        const p0, const v0 = .{
            Vec{ .x = @intCast(hailstones[0][0]), .y = @intCast(hailstones[0][1]), .z = @intCast(hailstones[0][2]) },
            Vec{ .x = @intCast(hailstones[0][3]), .y = @intCast(hailstones[0][4]), .z = @intCast(hailstones[0][5]) },
        };
        const p1, const v1 = .{
            Vec{ .x = @intCast(hailstones[1][0]), .y = @intCast(hailstones[1][1]), .z = @intCast(hailstones[1][2]) },
            Vec{ .x = @intCast(hailstones[1][3]), .y = @intCast(hailstones[1][4]), .z = @intCast(hailstones[1][5]) },
        };
        const p2, const v2 = .{
            Vec{ .x = @intCast(hailstones[2][0]), .y = @intCast(hailstones[2][1]), .z = @intCast(hailstones[2][2]) },
            Vec{ .x = @intCast(hailstones[2][3]), .y = @intCast(hailstones[2][4]), .z = @intCast(hailstones[2][5]) },
        };
        const p3 = p1.sub(&p0);
        const p4 = p2.sub(&p0);
        const v3 = v1.sub(&v0);
        const v4 = v2.sub(&v0);

        const q = v3.cross(&p3).gcd();
        const r = v4.cross(&p4).gcd();
        const s = q.cross(&r).gcd();

        const t = @divTrunc(p3.y * s.x - p3.x * s.y, v3.x * s.y - v3.y * s.x);
        const u = @divTrunc(p4.y * s.x - p4.x * s.y, v4.x * s.y - v4.y * s.x);
        const a = p0.add(&p3).sum();
        const b = p0.add(&p4).sum();
        const c = v3.sub(&v4).sum();
        part2 = @divTrunc(u * a - t * b + u * t * c, u - t);
    }
    return [2]usize{ part1, @intCast(part2) };
}

const Vec = struct {
    x: i128,
    y: i128,
    z: i128,
    fn add(a: *const Vec, b: *const Vec) Vec {
        return Vec{ .x = a.x + b.x, .y = a.y + b.y, .z = a.z + b.z };
    }
    fn sub(a: *const Vec, b: *const Vec) Vec {
        return Vec{ .x = a.x - b.x, .y = a.y - b.y, .z = a.z - b.z };
    }
    fn cross(a: *const Vec, b: *const Vec) Vec {
        return Vec{
            .x = a.y * b.z - a.z * b.y,
            .y = a.z * b.x - a.x * b.z,
            .z = a.x * b.y - a.y * b.x,
        };
    }
    fn gcd(a: *const Vec) Vec {
        const d: i128 = @intCast(std.math.gcd(@abs(a.x), std.math.gcd(@abs(a.y), @abs(a.z))));
        return Vec{ .x = @divExact(a.x, d), .y = @divExact(a.y, d), .z = @divExact(a.z, d) };
    }
    fn sum(a: *const Vec) i128 {
        return a.x + a.y + a.z;
    }
};

fn day(inp: []const u8, bench: bool) anyerror!void {
    const p = try parts(inp);
    if (!bench) {
        aoc.print("Part1: {}\nPart2: {}\n", .{ p[0], p[1] });
    }
}

pub fn main() anyerror!void {
    try aoc.benchme(aoc.input(), day);
}
