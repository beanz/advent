const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

const SIZE = 1536;
const EDGES = 10;

fn parts(inp: []const u8) anyerror![2]usize {
    var n: usize = 0;
    var ids: [17576]?usize = .{null} ** 17576;
    var back: [SIZE * EDGES]usize = .{0} ** (SIZE * EDGES);
    var g = aoc.ListOfLists(usize).init(back[0..], SIZE);
    var i: usize = 0;
    while (i < inp.len) : (i += 1) {
        const a = (@as(usize, @intCast(inp[i] - 'a')) * 26 + @as(usize, @intCast(inp[i + 1] - 'a'))) * 26 + @as(usize, @intCast(inp[i + 2] - 'a'));
        if (ids[a] == null) {
            ids[a] = n;
            n += 1;
        }
        const an = ids[a].?;
        i += 4;
        while (inp[i] != '\n') {
            i += 1;
            const b = (@as(usize, @intCast(inp[i] - 'a')) * 26 + @as(usize, @intCast(inp[i + 1] - 'a'))) * 26 + @as(usize, @intCast(inp[i + 2] - 'a'));
            if (ids[b] == null) {
                ids[b] = n;
                n += 1;
            }
            const bn = ids[b].?;
            try g.put(an, bn);
            try g.put(bn, an);
            i += 3;
        }
    }
    const a = try traverse(&g, 0);
    const b = try traverse(&g, a);
    const size = try fill(&g, a, b);
    return [2]usize{ size * (n - size), 1 };
}

fn fill(g: *aoc.ListOfLists(usize), start: usize, end: usize) !usize {
    var back: [512][2]usize = undefined;
    var work = aoc.Deque([2]usize).init(back[0..]);
    var path = try std.BoundedArray([2]usize, SIZE).init(0);
    var used: [SIZE * SIZE]bool = .{false} ** (SIZE * SIZE);
    var size: usize = undefined;
    for (0..4) |_| {
        try work.push([2]usize{ start, std.math.maxInt(usize) });
        var seen: [SIZE]bool = .{false} ** SIZE;
        seen[start] = true;
        size = 0;
        while (work.pop()) |r| {
            const cur = r[0];
            const head = r[1];
            size += 1;
            if (cur == end) {
                var i = head;
                const p = path.slice();
                while (i != std.math.maxInt(usize)) {
                    const e, const ni = .{ p[i][0], p[i][1] };
                    used[e] = true;
                    i = ni;
                }
                break;
            }
            for (g.items(cur)) |next| {
                const e = edge(cur, next);
                if (seen[next] or used[e]) {
                    continue;
                }
                try work.push([2]usize{ next, path.len });
                seen[next] = true;
                try path.append([2]usize{ e, head });
            }
        }
        work.clear();
        try path.resize(0);
    }
    return size;
}

inline fn edge(a: usize, b: usize) usize {
    return if (a < b) a * SIZE + b else b * SIZE + a;
}

fn traverse(g: *aoc.ListOfLists(usize), start: usize) !usize {
    var back: [512]usize = undefined;
    var work = aoc.Deque(usize).init(back[0..]);
    try work.push(start);
    var seen: [SIZE]bool = .{false} ** SIZE;
    seen[start] = true;
    var last: usize = start;
    while (work.pop()) |cur| {
        last = cur;
        for (g.items(cur)) |next| {
            if (seen[next]) {
                continue;
            }
            try work.push(next);
            seen[next] = true;
        }
    }
    return last;
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
