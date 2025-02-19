const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

fn parts(inp: []const u8) anyerror![2]usize {
    var m: [10240]u8 = undefined;
    @memcpy(m[0..inp.len], inp);
    const w = std.mem.indexOfScalar(u8, inp, '\n').?;
    var p1: usize = 0;
    {
        rotateAndTilt(&m, w);
        for (0..w) |y| {
            const yi = (w + 1) * y;
            for (0..w) |x| {
                if (m[yi + x] == 'O') {
                    p1 += x + 1;
                }
            }
        }
    }
    var seen = std.AutoHashMap(u32, usize).init(aoc.halloc);
    try seen.ensureTotalCapacity(128);
    const tar: usize = 1000000000;
    var c: usize = 1;
    var found = false;
    while (c <= tar) {
        rotateAndTilt(&m, w);
        rotateAndTilt(&m, w);
        rotateAndTilt(&m, w);
        if (!found) {
            const hash = std.hash.Fnv1a_32.hash(m[0..inp.len]);
            if (seen.get(hash)) |pc| {
                found = true;
                const l = c - pc;
                c += ((tar - c) / l) * l;
            } else {
                try seen.put(hash, c);
            }
        }
        c += 1;
        if (c > tar) {
            break;
        }
        rotateAndTilt(&m, w);
    }
    var p2: usize = 0;
    for (0..w) |y| {
        const yi = (w + 1) * y;
        for (0..w) |x| {
            if (m[yi + x] == 'O') {
                p2 += w - y;
            }
        }
    }
    return [2]usize{ p1, p2 };
}

fn rotateAndTilt(m: []u8, w: usize) void {
    for (0..w / 2) |x| {
        const xo = w - x - 1;
        const xyi = x * (w + 1);
        const xyoi = (w - x - 1) * (w + 1);
        for (x..w - x - 1) |y| {
            const yo = w - y - 1;
            const yi = y * (w + 1);
            const yoi = yo * (w + 1);
            const a = m[yoi + x];
            const b = m[xyi + y];
            const c = m[yi + xo];
            const d = m[xyoi + yo];
            m[xyi + y] = a;
            m[yi + xo] = b;
            m[xyoi + yo] = c;
            m[yoi + x] = d;
        }
    }
    for (0..w) |y| {
        var xm: isize = @intCast(w - 1);
        var x = w - 1;
        while (true) {
            switch (m[(w + 1) * y + x]) {
                '#' => {
                    xm = @as(isize, @intCast(x)) - 1;
                },
                'O' => {
                    m[(w + 1) * y + x] = '.';
                    m[(((w + 1) * y) + @as(usize, @intCast(xm)))] = 'O';
                    xm -= 1;
                },
                else => {},
            }
            if (x == 0) {
                break;
            }
            x -= 1;
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
