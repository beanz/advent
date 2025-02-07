const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

const Keys = u32;
const KeySet = u32;
const Search = struct { pos: KeySet, steps: usize, rem: KeySet };
const Node = struct { steps: usize, need: KeySet };

fn parts(inp: []const u8) anyerror![2]usize {
    var loc: [31]usize = .{0} ** 31;
    var w: usize = 0;
    var toFind: KeySet = 0;
    var start: KeySet = 0;
    var quadKeys: [4]KeySet = .{0} ** 4;
    var quad: [31]usize = .{0} ** 31;
    var m: [31][31]Node = .{.{Node{ .steps = std.math.maxInt(Keys), .need = 0 }} ** 31} ** 31;
    {
        var h: usize = 0;
        var hw: usize = 0;
        var hh: usize = 0;
        var startIndex: usize = 26;
        for (0..inp.len) |i| {
            switch (inp[i]) {
                '\n' => if (w == 0) {
                    w = i + 1;
                    h = @divTrunc(inp.len, w);
                    hw = w >> 1;
                    hh = h >> 1;
                },
                '@' => {
                    loc[startIndex] = @intCast(i);
                    start |= keyBit(startIndex);
                    startIndex += 1;
                },
                'a'...'z' => |ch| {
                    const k: usize = @intCast(ch - 'a');
                    const kbit = keyBit(k);
                    toFind |= kbit;
                    loc[k] = i;
                    const x = @rem(i, w);
                    const y = @divTrunc(i, w);
                    const qi = @divTrunc(x, hw) + 2 * @divTrunc(y, hh);
                    quadKeys[qi] |= kbit;
                    quad[k] = qi;
                },
                else => {},
            }
        }
        const Rec = struct {
            pos: usize,
            steps: usize,
            need: KeySet,
        };
        var back: [2048]Rec = undefined;
        var work = aoc.Deque(Rec).init(back[0..]);
        var visited: [6642]u8 = .{0} ** 6642;
        var visit_value: u8 = 1;
        for (0..31) |j| {
            if (loc[j] == 0) {
                continue;
            }
            try work.push(Rec{ .pos = loc[j], .steps = 0, .need = 0 });
            while (work.pop()) |cur| {
                var need = cur.need;
                switch (inp[cur.pos]) {
                    'A'...'Z' => |ch| {
                        const door = ch - 'A';
                        need |= keyBit(door);
                    },
                    'a'...'z' => |ch| {
                        if (cur.steps != 0) {
                            const k = (ch & 0x1f) - 1;
                            //aoc.print("{c} => {c}: {} {b}\n", .{ @as(u8, @intCast(j + 'a')), @as(u8, @intCast(k + 'a')), cur.steps, need });
                            m[j][k] = Node{ .steps = cur.steps, .need = need };
                            m[k][j] = Node{ .steps = cur.steps, .need = need };
                            continue;
                        }
                    },
                    else => {},
                }
                for (&[4]usize{ cur.pos - w, cur.pos + 1, cur.pos + w, cur.pos - 1 }) |next| {
                    if (inp[next] != '#' and visited[next] != visit_value) {
                        try work.push(Rec{ .pos = next, .steps = cur.steps + 1, .need = need });
                        visited[next] = visit_value;
                    }
                }
            }
            visit_value += 1;
        }
        // https://en.wikipedia.org/wiki/Floyd%E2%80%93Warshall_algorithm
        for (0..31) |j| {
            m[j][j].steps = 0;
        }
        for (0..31) |k| {
            for (0..31) |i| {
                for (0..31) |j| {
                    const d = m[i][k].steps +| m[k][j].steps;
                    if (m[i][j].steps > d) {
                        m[i][j].steps = d;
                        const need = m[i][k].need | m[k][j].need | keyBit(k);
                        m[i][j].need = need;
                    }
                }
            }
        }
    }
    //aoc.print("{any} {b}\n", .{ loc, toFind });
    const p1 = try search(m, start, toFind);
    start = 0;
    {
        for (0..4) |i| {
            start |= keyBit(27 + i);
            for (0..26) |j| {
                if (quad[j] == i) {
                    m[27 + i][j] = Node{
                        .steps = m[26][j].steps - 2,
                        .need = m[26][j].need,
                    };
                } else {
                    m[27 + i][j] = Node{
                        .steps = std.math.maxInt(Keys),
                        .need = 0,
                    };
                }
                m[j][27 + i] = m[27 + i][j];
            }
        }
        for (0..26) |j| {
            m[26][j].steps = std.math.maxInt(Keys);
        }
    }
    const p2 = try search(m, start, toFind);
    return [2]usize{ p1, p2 };
}

fn search(m: [31][31]Node, start: KeySet, toFind: KeySet) anyerror!usize {
    var res: usize = 0;
    var visited = std.AutoHashMap(u64, usize).init(aoc.halloc);
    defer visited.deinit();
    try visited.ensureTotalCapacity(512000);
    var work = std.PriorityQueue(Search, void, search_cmp).init(aoc.halloc, {});
    defer work.deinit();
    try work.ensureTotalCapacity(5120000);
    try work.add(Search{ .pos = start, .steps = 0, .rem = toFind });
    while (work.removeOrNull()) |cur| {
        //aoc.print("{} {c}\n", .{ cur.steps, @as(u8, @intCast(cur.pos + 'a')) });
        if (@popCount(cur.rem) == 0) {
            res = cur.steps;
            break;
        }
        const vk = (@as(u64, @intCast(cur.pos)) << 31) + @as(u64, @intCast(cur.rem));
        if (visited.contains(vk)) {
            continue;
        }
        visited.putAssumeCapacity(vk, cur.steps);
        var fromIt = aoc.biterator(KeySet, cur.pos);
        while (fromIt.next()) |from| {
            const fromBit = keyBit(from);
            var it = aoc.biterator(KeySet, cur.rem);
            while (it.next()) |to| {
                const steps = m[from][to].steps;
                if (steps == std.math.maxInt(usize)) {
                    continue;
                }
                const need = m[from][to].need;
                if (@popCount(need & cur.rem) != 0) {
                    continue;
                }
                const toBit = keyBit(to);
                var n = cur.rem;
                n &= ~toBit;
                var npos = cur.pos;
                npos ^= fromBit;
                npos |= toBit;
                try work.add(Search{ .pos = npos, .steps = cur.steps + steps, .rem = n });
            }
        }
    }
    return res;
}

inline fn keyBit(k: usize) KeySet {
    return @as(KeySet, 1) << @as(u5, @intCast(k));
}

fn search_cmp(_: void, a: Search, b: Search) std.math.Order {
    return std.math.order(a.steps, b.steps);
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
