const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

const Ev = union(enum) {
    Wake: u8,
    Sleep: u8,
};

const DAYS: usize = 31 * 12;
const SIZE: usize = 10;
const LEN: usize = DAYS * SIZE;
const MAX_GUARDS: usize = 32;

fn parts(inp: []const u8) anyerror![2]usize {
    var events: [LEN]?Ev = .{null} ** LEN;
    var guard_num: [MAX_GUARDS]u16 = .{0} ** MAX_GUARDS;
    var guards: [DAYS]?u8 = .{null} ** DAYS;
    var seen: [256]?u16 = .{null} ** 256;
    var num_guards: usize = 0;
    {
        var i: usize = 0;
        while (i < inp.len) : (i += 1) {
            var d = (@as(usize, @intCast(inp[i + 6] & 0xf)) * 10 + @as(usize, @intCast(inp[i + 7] & 0xf))) * 31 + @as(usize, @intCast(inp[i + 9] & 0xf)) * 10 + @as(usize, @intCast(inp[i + 10] & 0xf));
            const min = (inp[i + 15] & 0xf) * 10 + (inp[i + 16] & 0xf);
            var ev: Ev = undefined;
            switch (inp[i + 19]) {
                'G' => {
                    if (inp[i + 12] == '2') {
                        d += 1;
                    }
                    i += 26;
                    var j = i;
                    const g_id = try aoc.chompId(inp, &j, 167);
                    const g_num = try aoc.chompUint(u16, inp, &i);
                    if (seen[g_id] == null) {
                        seen[g_id] = @as(u16, @intCast(num_guards));
                        num_guards += 1;
                    }
                    const idx = seen[g_id].?;
                    guard_num[idx] = g_num;
                    guards[d] = @as(u8, @intCast(idx));
                    i += 13;
                    continue;
                },
                'f' => {
                    i += 31;
                    ev = Ev{ .Sleep = min };
                },
                'w' => {
                    i += 27;
                    ev = Ev{ .Wake = min };
                },
                else => unreachable,
            }
            var inserted = false;
            for (0..SIZE) |j| {
                const k = d * SIZE + j;
                if (events[k] == null) {
                    events[k] = ev;
                    inserted = true;
                    break;
                }
                switch (events[k].?) {
                    Ev.Wake => |m| {
                        if (m > min) {
                            events[k] = ev;
                            ev = Ev{ .Wake = m };
                        }
                    },
                    Ev.Sleep => |m| {
                        if (m > min) {
                            events[k] = ev;
                            ev = Ev{ .Sleep = m };
                        }
                    },
                }
            }
            if (!inserted) {
                unreachable;
            }
        }
    }
    var minutes: [MAX_GUARDS]u32 = .{0} ** MAX_GUARDS;
    var guard_minutes: [MAX_GUARDS * 60]u32 = .{0} ** (MAX_GUARDS * 60);
    for (0..DAYS) |d| {
        const maybe_guard = guards[d];
        if (maybe_guard == null) {
            continue;
        }
        const guard = maybe_guard.?;
        const gm_idx = @as(usize, guard) * 60;
        for (0..SIZE / 2) |j| {
            const k = d * SIZE + j * 2;
            if (events[k] == null) {
                continue;
            }
            switch (events[k].?) {
                Ev.Wake => |_| unreachable,
                Ev.Sleep => |sm| {
                    switch (events[k + 1].?) {
                        Ev.Wake => |wm| {
                            minutes[guard] += @as(u32, @intCast(wm - sm));
                            for (sm..wm) |min| {
                                const mi = gm_idx + @as(usize, @intCast(min));
                                guard_minutes[mi] += 1;
                            }
                        },
                        else => {
                            unreachable;
                        },
                    }
                },
            }
        }
    }
    var max: u32 = 0;
    var max_guard: usize = 0;
    for (0..num_guards) |i| {
        if (minutes[i] > max) {
            max = minutes[i];
            max_guard = i;
        }
    }
    const max_guard_gm_idx = max_guard * 60;
    var max_times: usize = 0;
    var max_min: usize = 0;
    for (0..60) |m| {
        const times = guard_minutes[max_guard_gm_idx + m];
        if (times > max_times) {
            max_times = times;
            max_min = m;
        }
    }
    const p1 = guard_num[max_guard] * max_min;
    max = 0;
    max_guard = 0;
    max_min = 0;
    for (0..num_guards) |i| {
        const gm_idx = i * 60;
        for (0..60) |m| {
            const times = guard_minutes[gm_idx + m];
            if (times > max_times) {
                max_times = times;
                max_guard = i;
                max_min = m;
            }
        }
    }
    const p2 = guard_num[max_guard] * max_min;
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
