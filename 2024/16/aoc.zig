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
    //aoc.print("{}x{} {},{} {},{}\n", .{ w, h, start % w, start / w, end % w, end / w });

    const p2 = 0;
    var costs: [COST_SIZE]?usize = .{null} ** COST_SIZE;
    const p1 = try search(inp, w, start, end, costs[0..COST_SIZE], false);
    return [2]usize{ p1, p2 };
}

fn search(map: []const u8, w: usize, start: usize, end: usize, costs: []?usize, part2: bool) anyerror!usize {
    var back: [WORK_SIZE]Rec = undefined;
    var work = Deque(Rec).init(back[0..]);
    var back2: [WORK_SIZE]Rec = undefined;
    var next_work = Deque(Rec).init(back2[0..]);
    try work.push(Rec{ .pos = start, .dir = 1, .cost = 0 });
    if (part2) {
        try work.push(Rec{ .pos = start, .dir = 2, .cost = 0 });
        try work.push(Rec{ .pos = start, .dir = 3, .cost = 0 });
        try work.push(Rec{ .pos = start, .dir = 0, .cost = 0 });
    }
    var res: ?usize = null;
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
            if (res == null or res.? > cur.cost) {
                res = cur.cost;
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
            if (map[npos] != '#') {
                try work.push(Rec{ .pos = npos, .dir = cur.dir, .cost = cur.cost + 1 });
            }
        }
        try work.push(Rec{ .pos = cur.pos, .dir = cur.dir +% 1, .cost = cur.cost + 1000 });
        try work.push(Rec{ .pos = cur.pos, .dir = cur.dir +% 3, .cost = cur.cost + 1000 });
    }
    return res.?;
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

pub fn Deque(comptime T: type) type {
    return struct {
        buf: []T,
        head: usize,
        tail: usize,
        length: usize,

        const Self = @This();

        pub fn init(buf: []T) Self {
            return Self{ .buf = buf, .head = 0, .tail = 0, .length = 0 };
        }
        pub fn len(self: Self) usize {
            return self.length;
        }
        pub fn is_empty(self: Self) bool {
            return self.length == 0;
        }
        pub fn push(self: *Self, v: T) anyerror!void {
            if (self.length == self.buf.len) {
                return error.OverFlow;
            }
            self.buf[self.tail] = v;
            self.tail += 1;
            if (self.tail == self.buf.len) {
                self.tail = 0;
            }
            self.length += 1;
        }
        pub fn pop(self: *Self) ?T {
            if (self.length == 0) {
                return null;
            }
            const r = self.buf[self.head];
            self.head += 1;
            if (self.head == self.buf.len) {
                self.head = 0;
            }
            self.length -= 1;
            return r;
        }
    };
}
