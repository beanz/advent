const std = @import("std");
const aoc = @import("aoc-lib.zig");
const isDigit = std.ascii.isDigit;

test "testcases" {
    try aoc.TestCases(usize, parts);
}

fn parts(inp: []const u8) anyerror![2]usize {
    var a: [320]?usize = .{null} ** 320;
    var u: usize = 0;
    {
        var x: usize = 0;
        var y: usize = 0;
        LOOP: for (0..inp.len) |i| {
            switch (inp[i]) {
                '\n' => {
                    u = x;
                    y += 1;
                    x = 0;
                    continue :LOOP;
                },
                '.' => {},
                else => {
                    var j = 4 * @as(usize, inp[i] - '0');
                    while (a[j] != null) : (j += 1) {}
                    a[j] = i;
                },
            }
            x += 1;
        }
    }
    const w: isize = @intCast(u);
    const h: isize = @intCast(inp.len / (u + 1));
    const p1 = struct {
        var an1: [4096]bool = .{false} ** 4096;
        var c1: usize = 0;
        pub fn check(x: isize, y: isize, ww: isize, hh: isize) bool {
            if (!(0 <= x and x < ww and 0 <= y and y < hh)) {
                return false;
            }
            const kk: usize = @intCast(x + y * ww);
            if (!an1[kk]) {
                c1 += 1;
            }
            an1[kk] = true;
            return true;
        }
        pub fn count() usize {
            return c1;
        }
    };
    const p2 = struct {
        var an2: [4096]bool = .{false} ** 4096;
        var c2: usize = 0;
        pub fn check(x: isize, y: isize, ww: isize, hh: isize) bool {
            if (!(0 <= x and x < ww and 0 <= y and y < hh)) {
                return false;
            }
            const kk: usize = @intCast(x + y * ww);
            if (!an2[kk]) {
                c2 += 1;
            }
            an2[kk] = true;
            return true;
        }
        pub fn count() usize {
            return c2;
        }
    };

    for (0..80) |k| {
        for (0..4) |i| {
            const ai = a[4 * k + i] orelse break;
            const ax: isize = @intCast(ai % (u + 1));
            const ay: isize = @intCast(ai / (u + 1));
            for (i + 1..4) |j| {
                const bi = a[4 * k + j] orelse break;
                const bx: isize = @intCast(bi % (u + 1));
                const by: isize = @intCast(bi / (u + 1));
                _ = p2.check(ax, ay, w, h);
                _ = p2.check(bx, by, w, h);
                const dx: isize = ax - bx;
                const dy: isize = ay - by;
                var x = ax + dx;
                var y = ay + dy;
                if (p1.check(x, y, w, h)) {
                    while (p2.check(x, y, w, h)) {
                        x += dx;
                        y += dy;
                    }
                }
                x = bx - dx;
                y = by - dy;
                if (p1.check(x, y, w, h)) {
                    while (p2.check(x, y, w, h)) {
                        x -= dx;
                        y -= dy;
                    }
                }
            }
        }
    }

    return [2]usize{ p1.count(), p2.count() };
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
