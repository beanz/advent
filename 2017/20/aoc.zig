const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

fn parts(inp: []const u8) anyerror![2]usize {
    var s = try std.BoundedArray([10]isize, 1024).init(0);
    var p1: usize = 0;
    {
        var i: usize = 0;
        var min: usize = 100000000;
        while (i < inp.len) : (i += 1) {
            i += 3;
            const x = try aoc.chompInt(isize, inp, &i);
            i += 1;
            const y = try aoc.chompInt(isize, inp, &i);
            i += 1;
            const z = try aoc.chompInt(isize, inp, &i);
            i += 6;
            const vx = try aoc.chompInt(isize, inp, &i);
            i += 1;
            const vy = try aoc.chompInt(isize, inp, &i);
            i += 1;
            const vz = try aoc.chompInt(isize, inp, &i);
            i += 6;
            const ax = try aoc.chompInt(isize, inp, &i);
            i += 1;
            const ay = try aoc.chompInt(isize, inp, &i);
            i += 1;
            const az = try aoc.chompInt(isize, inp, &i);
            i += 1;

            try s.append([10]isize{ x, y, z, vx, vy, vz, ax, ay, az, 0 });
            const xx = x + vx * 1000 + ax * 500000;
            const yy = y + vy * 1000 + ay * 500000;
            const zz = z + vz * 1000 + az * 500000;
            const a = @abs(xx) + @abs(yy) + @abs(zz);
            if (a < min) {
                min = a;
                p1 = s.len - 1;
            }
        }
    }
    var p = s.slice();
    var p2 = p.len;
    for (1..1000) |t| {
        const dt = @as(isize, @intCast(t));
        for (p) |*e| {
            if (e[9] != 0) {
                continue;
            }
            e[3] += e[6];
            e[4] += e[7];
            e[5] += e[8];
            e[0] += e[3];
            e[1] += e[4];
            e[2] += e[5];
        }
        for (0..p.len) |i| {
            if (p[i][9] != 0) {
                continue;
            }
            for (i + 1..p.len) |j| {
                if (p[j][9] != 0 and p[j][9] != dt) {
                    continue;
                }
                if (p[i][0] == p[j][0] and p[i][1] == p[j][1] and p[i][2] == p[j][2]) {
                    if (p[i][9] != dt) {
                        p[i][9] = dt;
                        p2 -= 1;
                    }
                    if (p[j][9] != dt) {
                        p[j][9] = dt;
                        p2 -= 1;
                    }
                }
            }
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
