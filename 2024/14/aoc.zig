const std = @import("std");
const aoc = @import("aoc-lib.zig");
const isDigit = std.ascii.isDigit;

test "testcases" {
    try aoc.TestCases(usize, parts);
}

const Robot = struct {
    x: isize,
    y: isize,
    vx: isize,
    vy: isize,
};

fn parts(inp: []const u8) anyerror![2]usize {
    var i: usize = 0;
    var r = try std.BoundedArray(Robot, 500).init(0);
    while (i < inp.len) : (i += 1) {
        i += 2;
        const x = try aoc.chompInt(isize, inp, &i);
        i += 1;
        const y = try aoc.chompInt(isize, inp, &i);
        i += 3;
        const vx = try aoc.chompInt(isize, inp, &i);
        i += 1;
        const vy = try aoc.chompInt(isize, inp, &i);

        try r.append(Robot{ .x = x, .y = y, .vx = vx, .vy = vy });
    }
    const robots = r.slice();
    const w: isize = if (robots.len <= 12) 11 else 101;
    const h: isize = if (robots.len <= 12) 7 else 103;
    const qw = @divFloor(w, 2);
    const qh = @divFloor(h, 2);
    var q: @Vector(4, usize) = @splat(0);
    {
        const d: isize = 100;
        for (robots) |robot| {
            const x = @mod(robot.x + robot.vx * d, w);
            const y = @mod(robot.y + robot.vy * d, h);
            var qi: usize = 0;
            if (x > qw) {
                qi += 1;
            }
            if (y > qh) {
                qi += 2;
            }
            if (x != qw and y != qh) {
                q[qi] += 1;
            }
        }
    }
    const p1 = @reduce(.Mul, q);
    var p2: usize = 0;
    LOOP: for (1..10000) |d| {
        var seen: [12000]bool = .{false} ** 12000;
        const id: isize = @intCast(d);
        for (robots) |robot| {
            const x: usize = @intCast(@mod(robot.x + robot.vx * id, w));
            const y: usize = @intCast(@mod(robot.y + robot.vy * id, h));
            const k: usize = x + y * @as(usize, @bitCast(w));
            if (seen[k]) {
                continue :LOOP;
            }
            seen[k] = true;
        }
        p2 = d;
        break;
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
