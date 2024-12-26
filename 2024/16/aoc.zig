const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

const Rec = struct {
    pos: usize,
    dir: u2,
    cost: usize,
};

const COST_SIZE = 81920;
const WORK_SIZE = 32768;

fn parts(inp: []const u8) anyerror![2]usize {
    var i: usize = 0;
    while (inp[i] != '\n') : (i += 1) {}
    const w = i + 1;
    const start = inp.len - w * 2 + 1;
    const end = w * 2 - 3;
    var costs: [COST_SIZE]?usize = .{null} ** COST_SIZE;
    var back: [WORK_SIZE]Rec = undefined;
    var work = aoc.Deque(Rec).init(back[0..]);
    var back2: [WORK_SIZE]Rec = undefined;
    var next_work = aoc.Deque(Rec).init(back2[0..]);
    try work.push(Rec{ .pos = start, .dir = 1, .cost = 0 });
    var best: ?usize = null;
    while (true) {
        if (work.is_empty()) {
            if (next_work.is_empty()) { // or res != null) {
                break;
            }
            const tw = work;
            work = next_work;
            next_work = tw;
            continue;
        }
        const cur = work.pop().?;
        const k = (cur.pos << 2) + @as(usize, cur.dir);
        if (costs[k]) |cost| {
            if (cur.cost > cost) {
                continue;
            }
            if (cur.cost != cost) {
                costs[k] = cur.cost;
            }
        } else {
            costs[k] = cur.cost;
        }
        if (cur.pos == end) {
            if (best == null or best.? > cur.cost) {
                best = cur.cost;
            }
            continue;
        }
        {
            const npos = switch (cur.dir) {
                0 => cur.pos - w,
                1 => cur.pos + 1,
                2 => cur.pos + w,
                3 => cur.pos - 1,
            };
            if (inp[npos] != '#') {
                try work.push(Rec{ .pos = npos, .dir = cur.dir, .cost = cur.cost + 1 });
            }
        }
        try work.push(Rec{ .pos = cur.pos, .dir = cur.dir +% 1, .cost = cur.cost + 1000 });
        try work.push(Rec{ .pos = cur.pos, .dir = cur.dir +% 3, .cost = cur.cost + 1000 });
    }
    try work.push(Rec{ .pos = end, .dir = 1, .cost = 0 });
    try work.push(Rec{ .pos = end, .dir = 2, .cost = 0 });
    try work.push(Rec{ .pos = end, .dir = 3, .cost = 0 });
    try work.push(Rec{ .pos = end, .dir = 0, .cost = 0 });
    var seen: [COST_SIZE]bool = .{false} ** COST_SIZE;
    var p2set: [COST_SIZE]bool = .{false} ** COST_SIZE;
    const p1 = best.?;
    var p2: usize = 0;
    while (true) {
        if (work.is_empty()) {
            if (next_work.is_empty()) { // or res != null) {
                break;
            }
            const tw = work;
            work = next_work;
            next_work = tw;
            continue;
        }
        const cur = work.pop().?;
        const k = (cur.pos << 2) + @as(usize, (cur.dir +% 2));
        const cost = cur.cost + (costs[k] orelse p1);
        if (cost > p1) {
            continue;
        }
        const k2 = (k | 3) ^ 3;
        if (cost == p1 and !p2set[k2]) {
            p2 += 1;
            p2set[k2] = true;
        }
        if (seen[k]) {
            continue;
        }
        seen[k] = true;
        {
            const npos = switch (cur.dir) {
                0 => cur.pos - w,
                1 => cur.pos + 1,
                2 => cur.pos + w,
                3 => cur.pos - 1,
            };
            if (inp[npos] != '#') {
                try work.push(Rec{ .pos = npos, .dir = cur.dir, .cost = cur.cost + 1 });
            }
        }
        try work.push(Rec{ .pos = cur.pos, .dir = cur.dir +% 1, .cost = cur.cost + 1000 });
        try work.push(Rec{ .pos = cur.pos, .dir = cur.dir +% 3, .cost = cur.cost + 1000 });
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
