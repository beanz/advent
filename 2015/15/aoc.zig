const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

fn parts(inp: []const u8) anyerror![2]usize {
    var is = try std.BoundedArray([5]isize, 16).init(0);
    var it = aoc.intIter(isize, inp);
    while (it.next()) |capacity| {
        const durability = it.next().?;
        const flavor = it.next().?;
        const texture = it.next().?;
        const calories = it.next().?;
        try is.append([5]isize{ capacity, durability, flavor, texture, calories });
    }
    const ing = is.slice();
    var p1: usize = 0;
    var p2: usize = 0;
    if (ing.len == 2) {
        var i: isize = 0;
        while (i <= 100) : (i += 1) {
            const j = 100 - i;
            const capacity = ing[0][0] * i + ing[1][0] * j;
            const durability = ing[0][1] * i + ing[1][1] * j;
            const flavor = ing[0][2] * i + ing[1][2] * j;
            const texture = ing[0][3] * i + ing[1][3] * j;
            const calories = ing[0][4] * i + ing[1][4] * j;
            if (capacity <= 0 or durability <= 0 or flavor <= 0 or texture <= 0) {
                continue;
            }
            const s = capacity * durability * flavor * texture;
            if (s > p1) {
                p1 = @as(usize, @intCast(s));
            }
            if (calories == 500 and s > p2) {
                p2 = @as(usize, @intCast(s));
            }
        }
    } else {
        var i: isize = 100;
        while (i >= 0) : (i -= 1) {
            var j: isize = 100 - i;
            while (j >= 0) : (j -= 1) {
                var k = 100 - (i + j);
                while (k >= 0) : (k -= 1) {
                    const l = 100 - (i + j + k);
                    const capacity = ing[0][0] * i + ing[1][0] * j + ing[2][0] * k + ing[3][0] * l;
                    const durability = ing[0][1] * i + ing[1][1] * j + ing[2][1] * k + ing[3][1] * l;
                    const flavor = ing[0][2] * i + ing[1][2] * j + ing[2][2] * k + ing[3][2] * l;
                    const texture = ing[0][3] * i + ing[1][3] * j + ing[2][3] * k + ing[3][3] * l;
                    const calories = ing[0][4] * i + ing[1][4] * j + ing[2][4] * k + ing[3][4] * l;
                    if (capacity <= 0 or durability <= 0 or flavor <= 0 or texture <= 0) {
                        continue;
                    }
                    const s = capacity * durability * flavor * texture;
                    if (s > p1) {
                        p1 = @as(usize, @intCast(s));
                    }
                    if (calories == 500 and s > p2) {
                        p2 = @as(usize, @intCast(s));
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
