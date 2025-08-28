const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

const Constraint = struct {
    i: usize,
    j: usize,
};

const Int = i32;

const ALU = struct {
    addX: [14]Int,
    addY: [14]Int,
    divZ: [14]Int,
    cons: [7]Constraint,

    fn from(inp: []const u8) !ALU {
        var a = ALU{ .addX = undefined, .addY = undefined, .divZ = undefined, .cons = undefined };
        {
            var xi: usize = 0;
            var yi: usize = 0;
            var zi: usize = 0;
            var y: usize = 0;
            var i: usize = 0;
            while (i < inp.len) : (i += 1) {
                switch (inp[i]) {
                    'a' => {
                        if (inp[i + 6] < 'w') {
                            switch (inp[i + 4]) {
                                'x' => {
                                    i += 6;
                                    a.addX[xi] = try aoc.chompInt(Int, inp, &i);
                                    xi += 1;
                                },
                                'y' => {
                                    i += 6;
                                    const n = try aoc.chompInt(Int, inp, &i);
                                    if (y % 3 == 2) {
                                        a.addY[yi] = n;
                                        yi += 1;
                                    }
                                    y += 1;
                                },
                                else => unreachable,
                            }
                        } else {
                            i += 7;
                        }
                    },
                    'd' => {
                        i += 6;
                        a.divZ[zi] = try aoc.chompInt(Int, inp, &i);
                        zi += 1;
                    },
                    'm' => {
                        if (inp[i + 1] == 'o') {
                            i += 8;
                        } else {
                            i += 7;
                        }
                    },
                    'e' => i += 7,
                    'i' => i += 5,
                    else => unreachable,
                }
            }
        }
        var ci: usize = 0;
        var stack = try std.BoundedArray(usize, 7).init(0);
        for (0..14) |i| {
            if (a.divZ[i] == 1) {
                try stack.append(i);
            } else {
                const j = stack.pop().?;
                a.cons[ci] = Constraint{ .i = i, .j = j };
                ci += 1;
            }
        }
        return a;
    }
    fn solve(self: *const ALU, comptime start: Int, comptime inc: Int) usize {
        var ans: [14]Int = .{start} ** 14;
        for (self.cons) |c| {
            while (true) {
                ans[c.i] = ans[c.j] + self.addY[c.j] + self.addX[c.i];
                if (0 < ans[c.i] and ans[c.i] <= 9) {
                    break;
                }
                ans[c.j] += inc;
            }
        }
        var n: usize = 0;
        for (0..14) |i| {
            n = n * 10 + @as(usize, @intCast(ans[i]));
        }
        return n;
    }
};

fn parts(inp: []const u8) anyerror![2]usize {
    const a = try ALU.from(inp);
    return [2]usize{ a.solve(9, -1), a.solve(1, 1) };
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
