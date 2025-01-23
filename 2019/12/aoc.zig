const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

const Int = i16;

fn parts(inp: []const u8) anyerror![2]usize {
    var moons: [4][6]Int = undefined;
    var moons2: [4][6]Int = undefined;
    {
        var i: usize = 0;
        var l: usize = 0;
        while (i < inp.len) : (i += 1) {
            i += 3;
            const x = try aoc.chompInt(Int, inp, &i);
            i += 4;
            const y = try aoc.chompInt(Int, inp, &i);
            i += 4;
            const z = try aoc.chompInt(Int, inp, &i);
            i += 1;
            moons[l] = [6]Int{ x, y, z, 0, 0, 0 };
            moons2[l] = [6]Int{ x, y, z, 0, 0, 0 };
            l += 1;
        }
    }
    {
        for (0..1000) |_| {
            inline for (0..3) |axis| {
                stepAxis(moons[0..], axis);
            }
        }
    }
    var p1: usize = 0;
    {
        inline for (0..4) |i| {
            p1 += (@abs(moons[i][0]) + @abs(moons[i][1]) + @abs(moons[i][2])) * (@abs(moons[i][3]) + @abs(moons[i][4]) + @abs(moons[i][5]));
        }
    }
    var cycle: [3]?usize = .{null} ** 3;
    for (0..3) |axis| {
        const initial = axisState(&moons2, axis);
        var st: usize = 0;
        while (true) {
            st += 1;
            stepAxis(moons2[0..], axis);
            if (initial == axisState(&moons2, axis) and axisState(&moons2, 3 + axis) == 0) {
                cycle[axis] = st;
                break;
            }
        }
    }
    const p2 = aoc.lcm(cycle[0].?, aoc.lcm(cycle[1].?, cycle[2].?));

    return [2]usize{ p1, p2 };
}

fn axisState(moons: *[4][6]Int, axis: usize) usize {
    var s: usize = 0;
    for (moons) |m| {
        s = (s << 16) + @as(usize, @as(u16, @bitCast(m[axis])));
    }
    return s;
}

fn stepAxis(moons: [][6]Int, axis: usize) void {
    {
        for (0..4) |i| {
            for (i + 1..4) |j| {
                if (moons[i][axis] > moons[j][axis]) {
                    moons[i][3 + axis] -= 1;
                    moons[j][3 + axis] += 1;
                } else if (moons[i][axis] < moons[j][axis]) {
                    moons[i][3 + axis] += 1;
                    moons[j][3 + axis] -= 1;
                }
            }
        }
    }
    inline for (0..4) |i| {
        moons[i][axis] += moons[i][3 + axis];
    }
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
