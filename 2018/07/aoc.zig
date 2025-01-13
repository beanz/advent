const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCasesRes(Res, parts);
}

const Res = struct {
    p1: [26]u8,
    p2: usize,
};

const IDLE: u32 = std.math.maxInt(u32);

fn parts(inp: []const u8) anyerror!Res {
    var deps: [26]u32 = .{0} ** 26;
    var todo: u32 = 0;
    var has_deps: u32 = 0;
    {
        var i: usize = 0;
        while (i < inp.len) {
            const a = inp[i + 5] - 'A';
            const b = inp[i + 36] - 'A';
            const ba: u32 = @as(u32, 1) << @as(u5, @intCast(a));
            const bb: u32 = @as(u32, 1) << @as(u5, @intCast(b));
            todo |= ba | bb;
            deps[b] |= ba;
            has_deps |= bb;
            i += 49;
        }
    }

    var deps2: [26]u32 = undefined;
    std.mem.copyForwards(u32, &deps2, &deps);
    var p1: [26]u8 = .{32} ** 26;
    var p1l: usize = 0;
    {
        var available = todo ^ has_deps;
        while (available != 0) {
            const n = @ctz(available);
            available ^= @as(u32, 1) << @as(u5, @intCast(n));
            available |= step(n, &deps);
            p1[p1l] = 'A' + @as(u8, n);
            p1l += 1;
        }
    }

    var timeleft: [26]usize = .{0} ** 26;
    const workload: u32 = if (@popCount(todo) < 10) 0 else 60;
    const workers: usize = if (@popCount(todo) < 10) 2 else 5;
    var total_left: usize = 0;
    for (0..26) |i| {
        if (todo & (@as(u32, 1) << @as(u5, @intCast(i))) != 0) {
            timeleft[i] = workload + 1 + i;
            total_left += workload + 1 + i;
        }
    }

    var doing: [5]u32 = .{IDLE} ** 5;
    var available = todo ^ has_deps;
    var t: usize = 0;
    while (available != 0 or total_left != 0) {
        var cur_avail = available;
        for (0..workers) |wn| {
            var n: u32 = undefined;
            if (doing[wn] != IDLE) {
                n = doing[wn];
            } else if (cur_avail != 0) {
                n = @ctz(cur_avail);
                const b = @as(u32, 1) << @as(u5, @intCast(n));
                cur_avail ^= b;
                available ^= b;
                doing[wn] = n;
            } else {
                continue;
            }
            timeleft[n] -= 1;
            total_left -= 1;
            if (timeleft[n] > 0) {
                continue;
            }
            doing[wn] = IDLE;
            available |= step(n, &deps2);
        }
        t += 1;
    }

    return Res{ .p1 = p1, .p2 = t };
}

fn step(n: u32, deps: *[26]u32) u32 {
    var avail: u32 = 0;
    const mask = std.math.maxInt(u32) ^ (@as(u32, 1) << @as(u5, @intCast(n)));
    for (0..26) |k| {
        const ki = @as(usize, k);
        if (deps[ki] == 0) {
            continue;
        }
        deps[ki] &= mask;
        if (deps[ki] != 0) {
            continue;
        }
        avail |= @as(u32, 1) << @as(u5, @intCast(k));
    }
    return avail;
}

fn day(inp: []const u8, bench: bool) anyerror!void {
    const p = try parts(inp);
    if (!bench) {
        aoc.print("Part1: {s}\nPart2: {}\n", .{ p.p1, p.p2 });
    }
}

pub fn main() anyerror!void {
    try aoc.benchme(aoc.input(), day);
}
