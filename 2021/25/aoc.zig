const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

fn parts(inp: []const u8) anyerror![2]usize {
    var as = try std.BoundedArray(u139, 137).init(0);
    var ds = try std.BoundedArray(u139, 137).init(0);
    {
        var bit: u139 = 1;
        var a: u139 = 0;
        var d: u139 = 0;
        for (inp) |ch| {
            switch (ch) {
                '\n' => {
                    try as.append(a);
                    try ds.append(d);
                    bit = 1;
                    a = 0;
                    d = 0;
                    continue;
                },
                '>' => a |= bit,
                'v' => d |= bit,
                '.' => {},
                else => unreachable,
            }
            bit <<= 1;
        }
    }
    const across = as.slice();
    const down = ds.slice();
    const width: u8 = if (across.len == 137) 139 else 10;

    // simplicity in parsing means rows are backwards
    // which means we rotate left not right
    var c: usize = 0;
    while (true) {
        var changes = false;
        for (0..across.len) |i| {
            const possible = rotate(across[i], width);
            const moves = possible & ~(across[i] | down[i]);
            changes = changes or moves != 0;
            const rem = across[i] & ~rotate_back(moves, width);
            across[i] = moves | rem;
        }
        const top_mask = across[0] | down[0];
        var moves = down[down.len - 1] & ~top_mask;
        for (0..(down.len - 1)) |i| {
            changes = changes or moves != 0;
            const blocked = across[i + 1] | down[i + 1];
            const rem = down[i] & blocked;
            const new_moves = down[i] & ~rem;
            down[i] = moves | rem;
            moves = new_moves;
        }
        changes = changes or moves != 0;
        const rem = down[down.len - 1] & top_mask;
        down[down.len - 1] = moves | rem;
        c += 1;
        if (!changes) {
            break;
        }
    }

    return [2]usize{ c, 0 };
}

fn rotate(v: u139, w: u8) u139 {
    if (w != 139) {
        return ((v << 1) & ~(@as(u139, 1) << w)) | (v >> (w - 1));
    } else {
        return (v << 1) | (v >> 138);
    }
}

fn rotate_back(v: u139, w: u8) u139 {
    return (v >> 1) | ((v & 1) << (w - 1));
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
