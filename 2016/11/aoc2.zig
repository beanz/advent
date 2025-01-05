const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

fn parts(inp: []const u8) anyerror![2]usize {
    var floors: [17]u2 = .{0} ** 17;
    var i: usize = 0;
    var n: usize = 0;
    var el: [256]?usize = .{null} ** 256;
    while (i < inp.len) {
        var f: usize = undefined;
        switch (inp[i + 4]) {
            'f' => {
                if (inp[i + 5] == 'i') {
                    f = 0;
                    i += 25;
                } else {
                    f = 3;
                    i += 26;
                }
            },
            's' => {
                f = 1;
                i += 26;
            },
            't' => {
                f = 2;
                i += 25;
            },
            else => unreachable,
        }
        if (inp[i] == 'n') {
            // nothing relevant.
            i += 18;
            continue;
        }
        while (true) {
            if (inp[i] == ' ') {
                i += 1;
            }
            if (inp[i] == ',') {
                i += 2;
            }
            if (inp[i] == 'a' and inp[i + 1] == 'n' and inp[i + 2] == 'd') {
                i += 4;
            }
            if (inp[i] == 'a' and inp[i + 1] == ' ') {
                i += 2;
            }
            const id = try aoc.chompId(inp, &i, 173);
            if (el[id] == null) {
                el[id] = n;
                n += 1;
            }
            const e = el[id].?;
            if (inp[i] == '-') {
                aoc.print("{}: {} M\n", .{ f, e });
                floors[1 + e * 2] = @as(u2, @intCast(f));
                i += 21;
            } else {
                aoc.print("{}: {} G\n", .{ f, e });
                floors[2 + e * 2] = @as(u2, @intCast(f));
                i += 10;
            }
            if (inp[i] == '.') {
                i += 2;
                break;
            }
        }
    }
    const l = n * 2 + 1;
    aoc.print("{any} {}\n", .{ floors, done(floors[0..l]) });
    aoc.print("{any} {}\n", .{ floors, safe(floors[0..l]) });
    aoc.print("{}\n", .{key(floors[0..l])});
    return [2]usize{ inp.len, 999 };
}

fn key(f: []u2) u64 {
    var k: u64 = 0;
    for (0..4) |l| {
        var cm: u64 = 0;
        var cg: u64 = 0;
        for (0..f.len / 2) |i| {
            if (f[1 + i * 2] == l) {
                cm += 1;
            }
            if (f[2 + i * 2] == l) {
                cg += 1;
            }
        }
        k = (((k << 4) + cm) << 4) + cg;
    }
    k = (k << 2) + @as(u64, f[0]);
    return k;
}
fn safe(f: []u2) bool {
    for (0..f.len / 2) |i| {
        if (f[1 + i * 2] == f[2 + i * 2]) {
            continue;
        }
        for (0..f.len / 2) |j| {
            if (i == j) {
                continue;
            }
            if (f[2 + j * 2] == f[1 + i * 2]) {
                return false;
            }
        }
    }
    return true;
}

fn done(f: []u2) bool {
    for (1..f.len) |i| {
        if (f[i] != 3) {
            return false;
        }
    }
    return true;
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
