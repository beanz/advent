const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

fn parts(inp: []const u8) anyerror![2]usize {
    var m: [110]u8 = undefined;
    std.mem.copyForwards(u8, m[0..inp.len], inp);
    var oct = m[0..inp.len];
    const w = 1 + std.mem.indexOfScalar(u8, oct, '\n').?;
    const h = inp.len / w;
    var r = [2]usize{ 0, 0 };
    var c: usize = 0;
    var d: usize = 1;
    while (true) : (d += 1) {
        for (oct, 0..) |ch, i| {
            if (ch != '\n') {
                oct[i] += 1;
            }
        }
        for (oct, 0..) |ch, i| {
            if (ch > '9' and ch != '~') {
                flash(oct, i, w, h);
            }
        }
        var p2: usize = 0;
        for (oct, 0..) |ch, i| {
            if (ch != '~') {
                continue;
            }
            oct[i] = '0';
            p2 += 1;
        }
        c += p2;
        if (d == 100) {
            r[0] = c;
        }
        if (p2 == (w - 1) * h) {
            r[1] = d;
            return r;
        }
    }
    return r;
}

fn flash(oct: []u8, i: usize, w: usize, h: usize) void {
    const x = @as(isize, @intCast(i % w));
    const y = @as(isize, @intCast(i / w));
    oct[i] = '~';
    for ([3]isize{ x - 1, x, x + 1 }) |nx| {
        for ([3]isize{ y - 1, y, y + 1 }) |ny| {
            if (x == nx and y == ny) {
                continue;
            }
            if (nx < 0 or ny < 0 or nx >= (w - 1) or ny >= h) {
                continue;
            }
            const ni = @as(usize, @intCast(nx)) + @as(usize, @intCast(ny)) * w;
            if (oct[ni] == '~') {
                continue;
            }
            oct[ni] += 1;
            if (oct[ni] > '9') {
                flash(oct, ni, w, h);
            }
        }
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
