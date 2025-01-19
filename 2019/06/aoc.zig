const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

const Uint = u16;

const COM = init: {
    var i: usize = 0;
    const id = chompId("COM", &i);
    break :init id;
};

const YOU = init: {
    var i: usize = 0;
    const id = chompId("YOU", &i);
    break :init id;
};

const SAN = init: {
    var i: usize = 0;
    const id = chompId("SAN", &i);
    break :init id;
};

fn parts(inp: []const u8) anyerror![2]usize {
    var back: [202612]Uint = .{0} ** 202612;
    var orb = aoc.ListOfLists(u16).init(back[0..], 50653);
    var i: usize = 0;
    while (i < inp.len) : (i += 1) {
        const a = chompId(inp, &i);
        i += 1;
        const b = chompId(inp, &i);
        try orb.put(a, b);
    }
    var p2: ?usize = null;
    const p1 = count(orb, COM, 0, &p2);
    return [2]usize{ p1[0], p2.? };
}

fn count(orb: aoc.ListOfLists(u16), id: Uint, d: usize, p2: *?usize) [3]usize {
    if (id == SAN) {
        return [3]usize{ d, 0, 1 };
    }
    if (id == YOU) {
        return [3]usize{ d, 1, 0 };
    }
    var s = d;
    var you: usize = 0;
    var san: usize = 0;
    for (orb.items(id)) |sid| {
        const r = count(orb, sid, d + 1, p2);
        s += r[0];
        if (r[1] != 0) {
            you = r[1] + 1;
        }
        if (r[2] != 0) {
            san = r[2] + 1;
        }
    }
    if (san != 0 and you != 0 and p2.* == null) {
        // off by four due to the 1s when found and the ones added above
        p2.* = san + you - 4;
    }
    return [3]usize{ s, you, san };
}

fn chompId(inp: []const u8, i: *usize) Uint {
    var id: Uint = 0;
    while (i.* < inp.len) : (i.* += 1) {
        switch (inp[i.*]) {
            '0'...'9' => |ch| id = id * 37 + 27 + @as(Uint, @intCast(ch & 0xf)),
            'A'...'Z' => |ch| id = id * 37 + @as(Uint, @intCast(ch & 0x1f)),
            else => return id,
        }
    }
    return id;
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
