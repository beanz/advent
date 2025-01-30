const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

fn Sensor(comptime T: type) type {
    return struct {
        x: T,
        y: T,
        bx: T,
        by: T,
        md: T,
        r1x: T,
        r1y: T,
        r2x: T,
        r2y: T,

        fn chomp(inp: []const u8, i: *usize) !Sensor(T) {
            i.* += 12;
            const x = try aoc.chompInt(T, inp, i);
            i.* += 4;
            const y = try aoc.chompInt(T, inp, i);
            i.* += 25;
            const bx = try aoc.chompInt(T, inp, i);
            i.* += 4;
            const by = try aoc.chompInt(T, inp, i);
            i.* += 1;
            const md: T = @intCast(@abs(x - bx) + @abs(y - by));
            const r1 = rot_ccw(x - md - 1, y);
            const r2 = rot_ccw(x + md + 1, y);
            return Sensor(T){
                .x = x,
                .y = y,
                .bx = bx,
                .by = by,
                .md = md,
                .r1x = r1[0],
                .r1y = r1[1],
                .r2x = r2[0],
                .r2y = r2[1],
            };
        }
        fn rot_ccw(x: T, y: T) [2]T {
            return [2]T{ x + y, y - x };
        }
    };
}

const Int = i64;

fn rot_cw(x: Int, y: Int) [2]Int {
    return [2]Int{ (x - y) >> 1, (y + x) >> 1 };
}

fn parts(inp: []const u8) anyerror![2]usize {
    var s: [30]Sensor(Int) = undefined;
    var l: usize = 0;
    {
        var i: usize = 0;
        while (i < inp.len) {
            s[l] = try Sensor(Int).chomp(inp, &i);
            l += 1;
        }
    }
    const sensors = s[0..l];
    const y: Int = if (l < 15) 10 else 2000000;
    const max: Int = if (l < 15) 20 else 4000000;
    const p1 = P1: {
        var bOnY = try std.BoundedArray(Int, 30).init(0);
        for (sensors) |sn| {
            if (sn.by == y) {
                try bOnY.append(sn.bx);
            }
        }
        var beaconsOnY = bOnY.slice();
        std.mem.sort(Int, beaconsOnY, {}, comptime std.sort.asc(Int));
        {
            var n: usize = 1;
            for (1..beaconsOnY.len) |i| {
                if (beaconsOnY[i - 1] == beaconsOnY[i]) {
                    continue;
                }
                beaconsOnY[n] = beaconsOnY[i];
                n += 1;
            }
            beaconsOnY = beaconsOnY[0..n];
        }
        var sp = try std.BoundedArray([2]Int, 30).init(0);
        for (sensors) |sn| {
            const d: Int = sn.md - @as(Int, @intCast(@abs(sn.y - y)));
            if (d < 0) {
                continue;
            }
            try sp.append([2]Int{ sn.x - d, sn.x + d + 1 });
        }
        var spans = sp.slice();
        std.mem.sort([2]Int, spans, {}, span_cmp);
        {
            var j: usize = 0;
            var i: usize = 1;
            while (i < spans.len) : (i += 1) {
                if (spans[i][0] <= spans[j][1]) {
                    if (spans[i][1] > spans[j][1]) {
                        spans[j][1] = spans[i][1];
                    }
                    continue;
                }
                j += 1;
                spans[j][0] = spans[i][0];
                spans[j][1] = spans[i][1];
            }
            j += 1;
            spans = spans[0..j];
        }
        var p1: usize = 0;
        for (spans) |span| {
            p1 += @intCast(span[1] - span[0]);
        }
        p1 -= beaconsOnY.len;
        break :P1 p1;
    };
    const p2 = P2: {
        var nxs = try std.BoundedArray(Int, 30).init(0);
        var nys = try std.BoundedArray(Int, 30).init(0);
        for (0..sensors.len) |i| {
            for (i + 1..sensors.len) |j| {
                if (sensors[i].r1x == sensors[j].r2x) {
                    try nxs.append(sensors[i].r1x);
                }
                if (sensors[i].r2x == sensors[j].r1x) {
                    try nxs.append(sensors[i].r2x);
                }
                if (sensors[i].r1y == sensors[j].r2y) {
                    try nys.append(sensors[i].r1y);
                }
                if (sensors[i].r2y == sensors[j].r1y) {
                    try nys.append(sensors[i].r2y);
                }
            }
        }
        var nx = nxs.slice();
        std.mem.sort(Int, nx, {}, comptime std.sort.asc(Int));
        {
            var n: usize = 1;
            for (1..nx.len) |i| {
                if (nx[i - 1] == nx[i]) {
                    continue;
                }
                nx[n] = nx[i];
                n += 1;
            }
            nx = nx[0..n];
        }
        var ny = nys.slice();
        std.mem.sort(Int, ny, {}, comptime std.sort.asc(Int));
        {
            var n: usize = 1;
            for (1..ny.len) |i| {
                if (ny[i - 1] == ny[i]) {
                    continue;
                }
                ny[n] = ny[i];
                n += 1;
            }
            ny = ny[0..n];
        }
        var possible = try std.BoundedArray([2]Int, 30).init(0);
        for (nx) |rx| {
            for (ny) |ry| {
                const r = rot_cw(rx, ry);
                if (0 <= r[0] and r[0] <= max and 0 <= r[1] and r[1] <= max) {
                    try possible.append(r);
                }
            }
        }
        const poss = possible.slice();
        if (poss.len == 1) {
            break :P2 @as(usize, @intCast(4000000 * poss[0][0] + poss[0][1]));
        }

        for (poss) |p| {
            var near = false;
            for (sensors) |sn| {
                const md: Int = @intCast(@abs(sn.x - p[0]) + @abs(sn.y - p[1]));
                if (md <= sn.md) {
                    near = true;
                    break;
                }
            }
            if (!near) {
                break :P2 @as(usize, @intCast(4000000 * p[0] + p[1]));
            }
        }

        break :P2 0;
    };
    return [2]usize{ p1, p2 };
}

fn span_cmp(_: void, a: [2]Int, b: [2]Int) bool {
    return a[0] < b[0];
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
