const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

fn parts(inp: []const u8) anyerror![2]usize {
    var w = try std.BoundedArray([]const u8, 16).init(0);
    var a: [16]u8 = .{0} ** 16;
    var b: [16]u8 = .{0} ** 16;
    var j: usize = 0;
    var i: usize = 0;
    var p1: usize = 0;
    var p2: usize = 0;
    while (i < inp.len) : (i += 1) {
        switch (inp[i]) {
            ' ' => {
                try w.append(inp[j..i]);
                j = i + 1;
            },
            '\n' => {
                try w.append(inp[j..i]);
                var ok = true;
                var ok2 = true;
                for (0..w.len) |k| {
                    const wa = w.get(k);
                    std.mem.copyForwards(u8, a[0..wa.len], wa);
                    std.mem.sort(u8, a[0..wa.len], {}, comptime std.sort.asc(u8));
                    for (k + 1..w.len) |l| {
                        const wb = w.get(l);
                        if (std.mem.eql(u8, wa, wb)) {
                            ok = false;
                        }
                        if (wa.len != wb.len) {
                            continue;
                        }
                        std.mem.copyForwards(u8, b[0..wb.len], wb);
                        std.mem.sort(u8, b[0..wb.len], {}, comptime std.sort.asc(u8));
                        if (std.mem.eql(u8, a[0..wa.len], b[0..wb.len])) {
                            ok2 = false;
                        }
                    }
                }
                p1 += @intFromBool(ok);
                p2 += @intFromBool(ok2);
                try w.resize(0);
                j = i + 1;
            },
            else => {},
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
