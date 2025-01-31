const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

const Valve = struct {
    id: usize,
    idx: usize,
    bit: u64,
    rate: usize,
    next: u64,
};

fn parts(inp: []const u8) anyerror![2]usize {
    var s = try std.BoundedArray(Valve, 64).init(0);
    var ids: [676]?usize = .{null} ** 676;
    {
        var l: usize = 0;
        var i: usize = 0;
        while (i < inp.len) {
            const id = @as(usize, @intCast(inp[i + 6] - 'A')) * 26 + @as(usize, @intCast(inp[i + 7] - 'A'));
            if (ids[id] == null) {
                ids[id] = l;
                l += 1;
            }
            const bit: u64 = @as(u64, 1) << @as(u6, @intCast(ids[id].?));
            i += 23;
            const flow = try aoc.chompUint(usize, inp, &i);
            i += 23;
            var leads: u64 = 0;
            while (true) {
                switch (inp[i]) {
                    '\n' => break,
                    ' ' => i -= 1,
                    else => {},
                }
                i += 2;
                const nid = @as(usize, @intCast(inp[i] - 'A')) * 26 + @as(usize, @intCast(inp[i + 1] - 'A'));
                if (ids[nid] == null) {
                    ids[nid] = l;
                    l += 1;
                }
                leads |= @as(u64, 1) << @as(u6, @intCast(ids[nid].?));
                i += 2;
            }
            try s.append(Valve{
                .id = id,
                .idx = ids[id].?,
                .bit = bit,
                .rate = flow,
                .next = leads,
            });
            i += 1;
        }
    }
    const valves = s.slice();
    std.mem.sort(Valve, valves, {}, valve_cmp);
    { // fix up bit sets and idx values after sorting
        var new: [64]usize = .{0} ** 64;
        for (valves, 0..) |v, idx| {
            new[v.idx] = idx;
        }
        for (0..valves.len) |i| {
            var nn: u64 = 0;
            valves[i].bit = @as(u64, 1) << @as(u6, @intCast(i));
            valves[i].idx = i;
            var bit = aoc.biterator(usize, valves[i].next);
            while (bit.next()) |j| {
                nn |= @as(u64, 1) << @as(u6, @intCast(new[j]));
            }
            valves[i].next = nn;
        }
    }
    var aa: usize = 0;
    while (valves[aa].id != 0) : (aa += 1) {}
    const l = aa + 1;
    var m: [64][64]usize = .{.{std.math.maxInt(usize)} ** 64} ** 64;
    for (0..l) |start| {
        m[start][start] = 0;
        var bit = aoc.biterator(usize, valves[start].next);
        while (bit.next()) |n| {
            var end = n;
            var cur = valves[start].bit;
            var d: usize = 1;
            while (valves[end].rate == 0 and end != aa) {
                const fwd = valves[end].next ^ cur;
                cur = valves[end].bit;
                end = @ctz(fwd);
                d += 1;
            }
            m[start][end] = d;
        }
    }
    for (0..l) |k| {
        for (0..l) |i| {
            for (0..l) |j| {
                const d = m[i][k] +| m[k][j];
                if (m[i][j] > d) {
                    m[i][j] = d;
                }
            }
        }
    }
    const todo: u64 = (@as(u64, 1) << @as(u6, @intCast(l - 1))) - 1;
    const p1 = search(valves[0..l], &m, todo, aa, 30, l);
    var p2: usize = 0;
    for (0..todo + 1) |set| {
        if (@popCount(set) != (l / 2)) {
            continue;
        }
        var pres = search(valves[0..l], &m, set, aa, 26, l);
        pres += search(valves[0..l], &m, todo ^ set, aa, 26, l);
        if (pres > p2) {
            p2 = pres;
        }
    }
    return [2]usize{ p1, p2 };
}

fn chr(n: usize) u8 {
    return 'A' + @as(u8, @intCast(n / 26));
}

fn search(v: []Valve, m: *[64][64]usize, todo: u64, pos: usize, t: usize, l: usize) usize {
    var max: usize = 0;
    //aoc.print("{} {b} {}\n", .{ pos, todo, t });
    for (0..l) |i| {
        const bit: u64 = @as(u64, 1) << @as(u6, @intCast(i));
        //aoc.print(" {b:>8}\n", .{bit});
        if (todo & bit == 0) {
            continue;
        }
        //aoc.print(" {} < {}\n", .{ t, m[pos][i] + 1 });
        if (t < m[pos][i] + 1) {
            continue;
        }
        const nt = t - m[pos][i] - 1; // open
        var pres = search(v, m, todo ^ bit, i, nt, l);
        pres += v[i].rate * nt;
        if (max < pres) {
            max = pres;
        }
    }
    return max;
}

fn valve_cmp(_: void, a: Valve, b: Valve) bool {
    return switch (std.math.order(a.rate, b.rate)) {
        .eq => a.id < b.id,
        .gt => true,
        .lt => false,
    };
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
