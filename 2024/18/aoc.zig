const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

const Rec = struct {
    x: u8,
    y: u8,
    st: usize,
};

fn parts(inp: []const u8) anyerror![2]usize {
    const end: usize = if (inp.len < 150) 6 else 70;
    const corrupt: usize = if (inp.len < 150) 12 else 1024;
    const w = end + 1;
    var drops: [4096]u16 = .{0} ** 4096;
    var map: [8192]usize = .{0} ** 8192;
    var i: usize = 0;
    var n: usize = 0;
    while (i < inp.len) : (i += 1) {
        const x = try aoc.chompUint(u8, inp, &i);
        i += 1;
        const y = try aoc.chompUint(u8, inp, &i);
        drops[n] = (@as(u16, x) << 8) + @as(u16, y);
        n += 1;
        map[x + y * w] = n;
    }
    var back: [16384]Rec = undefined;
    var work = aoc.Deque(Rec).init(back[0..]);
    const p1 = try search(map[0..], end, corrupt, &work);
    var hi = n;
    var lo = corrupt + 1;
    while (true) {
        const mid = (lo + hi) / 2;
        work.clear();
        const st = try search(map[0..], end, mid, &work);
        if (st == 0) {
            hi = mid;
        } else {
            lo = mid + 1;
        }
        if (lo == hi) {
            break;
        }
    }
    return [2]usize{ p1, drops[lo - 1] };
}

fn search(map: []usize, end: usize, corrupt: usize, work: *aoc.Deque(Rec)) anyerror!usize {
    const w = end + 1;
    try work.push(Rec{ .x = 0, .y = 0, .st = 0 });
    var seen: [8000]bool = .{false} ** 8000;
    while (work.pop()) |cur| {
        if (cur.x == end and cur.y == end) {
            return cur.st;
        }
        const k = cur.x + cur.y * w;
        if (seen[k]) {
            continue;
        }
        seen[k] = true;

        if (cur.y > 0) {
            const nx = cur.x;
            const ny = cur.y - 1;
            const nk = nx + ny * w;
            const c = map[nk];
            if (!(c != 0 and (c - 1) < corrupt)) {
                try work.push(Rec{ .x = nx, .y = ny, .st = cur.st + 1 });
            }
        }
        if (cur.x < end) {
            const nx = cur.x + 1;
            const ny = cur.y;
            const nk = nx + ny * w;
            const c = map[nk];
            if (!(c != 0 and (c - 1) < corrupt)) {
                try work.push(Rec{ .x = nx, .y = ny, .st = cur.st + 1 });
            }
        }
        if (cur.y < end) {
            const nx = cur.x;
            const ny = cur.y + 1;
            const nk = nx + ny * w;
            const c = map[nk];
            if (!(c != 0 and (c - 1) < corrupt)) {
                try work.push(Rec{ .x = nx, .y = ny, .st = cur.st + 1 });
            }
        }
        if (cur.x > 0) {
            const nx = cur.x - 1;
            const ny = cur.y;
            const nk = nx + ny * w;
            const c = map[nk];
            if (!(c != 0 and (c - 1) < corrupt)) {
                try work.push(Rec{ .x = nx, .y = ny, .st = cur.st + 1 });
            }
        }
    }
    return 0;
}

fn day(inp: []const u8, bench: bool) anyerror!void {
    const p = try parts(inp);
    if (!bench) {
        aoc.print("Part1: {}\nPart2: {},{}\n", .{ p[0], p[1] >> 8, p[1] & 0xff });
    }
}

pub fn main() anyerror!void {
    try aoc.benchme(aoc.input(), day);
}
