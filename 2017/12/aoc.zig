const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

fn parts(inp: []const u8) anyerror![2]usize {
    var group: [2000]?usize = .{null} ** 2000;
    var back: [153600]u16 = .{0} ** 153600;
    var members = aoc.ListOfLists(u16).init(back[0..], 512);
    var l: usize = 0;
    var i: usize = 0;
    while (i < inp.len) : (i += 1) {
        const n = try aoc.chompUint(u16, inp, &i);
        if (group[n] == null) {
            while (members.sublen(l) > 0) : (l = (l + 1) & 0x1ff) {}
            group[n] = l;
            try members.put(l, n);
            l = (l + 1) & 0x1ff;
        }
        i += 5;
        while (i < inp.len) : (i += 2) {
            const m = try aoc.chompUint(u16, inp, &i);
            const ng = group[n].?;
            const maybe_mg = group[m];
            if (maybe_mg) |mg| {
                if (mg != ng) {
                    for (members.items(ng)) |o| {
                        try members.put(mg, o);
                        group[o] = mg;
                    }
                    members.clear(ng);
                }
            } else {
                try members.put(ng, m);
                group[m] = ng;
            }

            if (inp[i] == '\n') {
                break;
            }
        }
    }
    var p2: usize = 0;
    for (0..512) |j| {
        p2 += @intFromBool(members.sublen(j) > 0);
    }
    return [2]usize{ members.sublen(group[0].?), p2 };
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
